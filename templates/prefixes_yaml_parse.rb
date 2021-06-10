require "yaml"
require "open-uri"

yaml_content = URI.open(ARGV[0]) {|f| f.read}; 
puts '<items>'; 
items = YAML::load(yaml_content); 
items.each do |key, value| 
	item = value['symbol']['ascii']; 
	puts '<item>'+item+'</item>'; 
end;
puts '</items>'
