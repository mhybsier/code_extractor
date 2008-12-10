class YAMLHandler
  
  CONFIG_FILE = 'config.yaml'
  
  def initialize(filename = CONFIG_FILE)
    @data = load(filename)
  end
  
  def method_missing(name)
    begin
      @data[name.to_sym]
    rescue
      # TODO: Raise an exception and handle it in the calling class.
      return false
    end
  end
  
  def add(hash)
    hash.each_pair { |key, value| @data[key] = value }
  end
  
  def save(filename = CONFIG_FILE, data = @data)
    File.open((filename), 'w') { |file| file.write(data.to_yaml) }
  end
  
  def user_data?
    @data[:user] && @data[:password]
  end
  
  def load(filename)
    begin
      YAML.load(File.open(filename))
    rescue
      if filename == CONFIG_FILE
        standard_config
        retry # => Infinite loop?
        load(filename)
      else
        File.new(filename, 'w+')
        Hash.new
      end
    end
  end
  
  def standard_config
    data = {:display_mode => "&amp;mode=3",
            :login_page => 'http://rubylearning.org/class/login/index.php',
            :no_students => ["Satish Talim"]}
    save(CONFIG_FILE, data)
    # return data?
  end
end