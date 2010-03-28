Dir.glob(File.join(File.dirname(__FILE__), 'htmlunit', '*.jar')) do |file|
  require File.expand_path(file)
end

require File.join(File.dirname(__FILE__), 'htmlunit', 'selenium', 'adapter')
