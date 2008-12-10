require "rubygems"
require "mechanize"

require "code_extractor"
require "yaml_handler"

# TODOs
# - Save the code snippets in a Ruby document with a shebang at the beginning

class CodeCrawler
  
  def initialize
    @config    = YAMLHandler.new
    @links     = YAMLHandler.new('links.yaml')
    @agent     = WWW::Mechanize.new
    @extractor = CodeExtractor.new
  end
  
  def method_missing(name)
    return @config.send("#{name}") if @config.send("#{name}")
    return @links.send("#{name}") if @links.send("#{name}")
    return false
  end
  
  def login(user, password)
    page = @agent.get(@config.login_page)
    form = page.forms.first
    form.username = user
    form.password = password
    result_page = @agent.submit(form, form.buttons.first)
    # PROBLEM: It would be better to test the uri of the particular page.
    # REFACTOR the if/else
    if result_page.title == page.title
      return false
    else
      @config.add({:user => user, :password => password})
      @config.save
      return true
    end
  end
  
  def extract(filename)
    uri = @links.send("#{filename}")
    page = @agent.get(uri)
    posts = @extractor.get_posts(page)
    code_snippets = get_code_snippets(posts)
    # TODO: Save the code snippets
  end
  
  def save_link
    @links.add({filename.to_sym => uri})
    @links.save('links.yaml')
  end
  
  def get_code_snippets(posts)
    code_snippets = {}
    posts.each do |post|
      author = @extractor.get_author(post)
      unless @config.no_students.include?(author)
        code_snippets[author] ||= []
        snippet = @extractor.get_code_snippet(post)
        (code_snippets[author] << snippet) unless snippet.empty?
      end
    end
    code_snippets
  end
  
  def build_directory(course, lesson, exercise)
    Dir.mkdir(course) unless File.directory?(course)
    directory = (course + '_')
    Dir.chdir(course) do
      Dir.mkdir(lesson) unless File.directory?(lesson)
      directory += (lesson + '_')
      Dir.chdir(lesson) do
        Dir.mkdir(exercise) unless File.directory?(exercise)
        directory += exercise
      end
    end
    directory
  end
  
  def prepare_authors_name(author)
    (author.downcase).split.join('_')
  end
end