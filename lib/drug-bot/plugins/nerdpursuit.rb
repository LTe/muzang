class NerdPursuit
  include DrugBot::Plugin::Helpers

  attr_accessor :questions

  def initialize(bot)
    @bot = bot
    @quiz_time = false
    @answers = []
    create_database("nerd_pursuit.yml", Array.new, :questions)
  end

  def call(connection, message)
    if on_channel?(message)
      if match?(message, /^!quiz$/, 0)
        begin
        @quiz_time = true
        @all_questions = Dir["#{File.dirname(__FILE__)}/questions/**/*.json"]
        @current_question_file = (@all_questions - questions).sample
        @questions << @current_question_file and save
        @current_question = JSON.parse(File.open(@current_question_file).read)["question"]
        connection.msg(message[:channel], "Quiz time!")

        EM.add_timer(1) { connection.msg(message[:channel], "Category: #{@current_question["category"]}") } 
        EM.add_timer(2) { connection.msg(message[:channel], "Question: #{@current_question["text"]}") }
        4.times do |time| 
          EM.add_timer(2+time+1) { connection.msg(message[:channel], "Answer #{time+1}: #{@current_question["a#{time+1}"]}") }
        end

        connection.msg(message[:channel], "R: #{@current_question["right_answer"]}")

        EM.add_timer(15) {
          @quiz_time = false
          connection.msg(message[:channel], "Right answer: #{@current_question["right_answer"][1..1]}")
          @winner = @answers.reject{|k| k[:answer] != @current_question["right_answer"][1..1]}.sort_by{|k| k[:time]}
          if @winner.first
            connection.msg(message[:channel], "The winner is... #{@winner.first[:nick]}")
          end
          @answers = []
        }
        rescue
          connection.msg(message[:channel], "Sth went wrong: I'm only beta plugin ;*")
        end
      end

      if(answer = match?(message, /\d/, 0))
        if @quiz_time
          @answers << {:answer => answer, :time => Time.now, :nick => message[:nick]}
        end
      end
    end
  end
end
