### This module seems too tightly coupled with ShowsCrawler class.

# PROBLEMs
# - can't set a whole para to :align => 'center'
# - can't change the text color of an edit_line field

module GUIBuilder
  
  def init_dimensions
    @width = app.width
    @offset = 10
    @top = @left = 20
    @angle = 45
    @curve = 5
    @inner_width = @width - (2 * @left)
  end
  
  def build_background
    background (white..dimgray), :angle => @angle
    background black, :margin => @offset - 1, :curve => @curve + 1
    background (ivory..sandybrown), :margin => @offset, :curve => @curve,
                                    :angle => @angle
  end
  
  def build_login_page
    stack :margin => @top do  
      # Greetings
      stack do
        para "Welcome to the CodeCrawler for", :align => 'center'
        tagline "RubyLearning.org", :stroke => red, :align => 'center'
        para "Please enter your username and password!", :align => 'center'
        stripline
      end
      
      # Login text fields
      flow :margin_top => 3 * @offset do
        para "Username: ", :left => 2 * @left + @offset
        data = edit_line :width => (@width/2) do |line|
          @user = line.text
        end
        @user = data.text = (@crawler.user || "Your username here.")
      end
      flow do
        para "Password: ", :left => 2 * @left + (@offset + 3)
        data = edit_line :width => (@width/2), :secret => true do |line|
          @password = line.text
        end
        @password = data.text = (@crawler.password || '')
      end
      
      # Buttons
      stack do
        width = 110
        left = 126
        cancel_button = button "Exit", :top => @offset, :left => left,
                                       :width => width
        login_button = button "Login", :top => @offset, :left => 2 * left,
                                       :width => width
        # login_button.focus # This doesn't seem to work :(
        cancel_button.click { exit }
        login_button.click { login }
      end
    end
  end
  
  def build_start_page
    stack :margin => [@top, 0, @top, @offset] do
      # Greetings
      stack do
        para "Please enter the course, lesson and exercise\n" \
             "for what you want to extract the code snippets.",
             :align => 'center'
        stripline
      end
      
      # Course text fields
      flow :margin_top => 3 * @offset do
        para "Course: ", :left => 2 * @left + (@offset + 13)
        data = edit_line :width => (@width/2) do |line|
          @course = line.text
        end
        @course = data.text = 'FORPC101-7C'
      end
      flow do
        para "Lesson: ", :left => 2 * @left + (@offset + 13)
        data = edit_line :width => (@width/2) do |line|
          @lesson = line.text
        end
        @lesson = data.text = 'Lesson5'
      end
      flow do
        para "Exercise: ", :left => 2 * @left + (@offset + 3)
        data = edit_line :width => (@width/2) do |line|
          @exercise = line.text
        end
        @exercise = data.text = 'Exercise6'
      end
      
      # Buttons
      stack do
        width = 110
        left = 120
        cancel_button = button "Cancel", :top => @offset, :left => left,
                                         :width => width
        login_button = button "Extract", :top => @offset, :left => 2 * left,
                                         :width => width
        # login_button.focus # This doesn't seem to work :(
        cancel_button.click { }
        login_button.click { extract }
      end
    end
  end
  
  def show_message(message)
    width = 300
    # height = 180
    stack :margin => [(@width/2 - width/2), (height/2),
                      (@width/2 - width/2), 0] do
      background gray(0.4, 0.6), :curve => 5
      para message, :align => 'center', :margin => @offset
    end
  end
  
  def stripline
    stack { line @left, @offset, @inner_width - (2 * @offset) }
  end
end