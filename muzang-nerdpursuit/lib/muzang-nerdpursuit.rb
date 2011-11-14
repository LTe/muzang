require "json"

class NerdPursuit
  include Muzang::Plugin::Helpers

  attr_accessor :questions, :quiz_time

  def initialize(bot)
    @bot = bot
    @quiz_time = false
    @answers = {}
    create_database("nerd_pursuit.yml", Array.new, :questions)
  end

  def all_questions
    names = Dir["#{File.dirname(__FILE__)}/muzang-nerdpursuit/questions/**/*.json"]
  end

  def quiz!(&block)
    @quiz_time = true
    current_question # load current question
  end

  def end_quiz!
    @quiz_time = false
    @current_question = nil
  end

  def current_question
    if @current_question
      @current_question
    else
      begin
        sample_question = (all_questions - questions).sample
        questions << sample_question
        save
        @current_question = ::JSON.parse(File.open(sample_question).read)["question"]
      end while(!valid?(@current_question))
    end

    @current_question
  end

  def valid?(question)
    if question
      question["category"] and question["text"] and question["right_answer"]
    else
      false
    end
  end

  def find_winner
    @winner = @answers.reject do |_, answer|
      answer[:answer] != current_question["right_answer"][1..1]
    end.sort_by do |_,answer|
      answer[:time]
    end
  end

  def period(time)
    time # need for speed up tests
  end

  def call(connection, message)
    if on_channel?(message)
      if match?(message, :regexp => /^!quiz$/, :position => 0)
        quiz!
        connection.msg(message.channel, "Quiz time!")
        EM.add_timer(period(1)) { connection.msg(message.channel, "Category: #{current_question["category"]}") }
        EM.add_timer(period(2)) { connection.msg(message.channel, "Question: #{current_question["text"]}") }
        4.times do |time|
          EM.add_timer(period(2+time+1)) { connection.msg(message.channel, "Answer #{time+1}: #{current_question["a#{time+1}"]}") }
        end
        EM.add_timer(period(40)) do
          connection.msg(message.channel, "Right answer: #{current_question["right_answer"][1..1]}")
          @winner = find_winner
          if @winner.first && @winner.first.first
            connection.msg(message.channel, "The winner is... #{@winner.first.first}")
          end
          @answers = {}
          @winner = nil
          end_quiz!
        end
      end

      if(answer = match?(message, :regexp => /\d/, :position => 0))
        if @quiz_time
          unless @answers[message.nick]
            @answers[message.nick] = { :answer => answer, :time => Time.now }
          end
        end
      end
    end
  end
end
