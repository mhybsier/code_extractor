Shoes.setup do
  gem "hpricot"
  gem "htmlentities"
  gem "mechanize"
end

require Dir.pwd + '/code_crawler'
require Dir.pwd + '/gui_builder'

### TODO - ADD TESTS FOR ALL CLASSES ###

# Shoes GUI class for CodeCrawler class

# TODOs
# - GUI for adding a new course/lesson/exercise
# - GUI for adding a new teacher
# - GUI for choosing one or more courses/lessons/exercises
# - better error handling
# - decouple ShowsCrawler class and GUIBuilder class

class ShoesCrawler < Shoes
  SEP = File::SEPARATOR
  
  url '/', :index
  
  include GUIBuilder
  
  def index
    @crawler = CodeCrawler.new
    init_dimensions
    start
  end
  
  def start
    build_background
    @main_stack = build_login_page
  end
  
  def login
    # TODO: Better error handling!
    if @crawler.login(@user, @password)
      @main_stack.clear
      @main_stack = build_start_page
    else
      @main_stack.hide
      show_message("Error!") # Add the exception message here
      # TODO: Add link to return to login page
      # @main_stack.show
    end
  end
  
  def extract
    # TODO: Parse the input and build the directory structure
    directory = @crawler.build_directory(@course, @lesson, @exercise)
    unless @crawler.send("#{directory}")
      # Ask for the URL
    else
      @main_stack.clear
      code_snippets = @crawler.extract(directory)
      save(code_snippets)
      # TODO: Error handling
      show_message("Hooray!!!")
    end
  end
  
  # This shouldn't be a method of ShoesCrawler class
  def save(code_snippets)
    Dir.chdir(@course + SEP + @lesson + SEP + @exercise) do
      code_snippets.each_pair do |author, snippets|
        # TODOs
        # - Open the file only if there is a snippet
        # - add a shebang ruby to the beginning of the file
        name = @crawler.prepare_authors_name(author)
        File.open("#{name}.rb", 'a+') do |file|
          file.write("# Snippets by #{author}:\n\n")
          snippets.each_with_index do |snippet, index|
            file.write("# >Snippet ##{index + 1}:\n")
            file.write(snippet + "\n")
            file.write("#" + ("-" * 60) + "\n\n")
          end
        end
      end
    end
  end
end


###
# Program for the extraction of student's code snippets from rubylearning.org
#         by Mareike Hybsier, 2008

Shoes.app :title => 'RubyLearning.org Code Crawler',
          :width => 500, :height => 300, :resizable => false