require "rubygems"
require "hpricot"
require "htmlentities"

class CodeExtractor
  
  def initialize
    @coder  = HTMLEntities.new
  end
  
  def get_posts(page)
    # TODO: There are post with class 'forumpost unread'
    #       which can be used for parsing only unread posts, yeah!
    page.search("//table[@class='forumpost read']")
  end
  
  def get_author(post)
    text = (post/"div.author")
    @coder.decode((text/"a").inner_html)
  end
  
  def get_code_snippet(post)
    snippet = (post/"pre.ruby").inner_html
    clean(snippet)
  end
  
  def clean(snippet)
    snippet.gsub!(/<span([^>]*)>/, '')
    snippet.gsub!(/<\/span>/, '')
    @coder.decode(snippet)
  end
end