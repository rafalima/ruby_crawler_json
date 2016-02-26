require 'json'
require 'open-uri'
require 'pry'
require 'hashie'

def find(data)
  data.extend(Hashie::Extensions::DeepFind)
  data.deep_find_all(@key_to_find).each { |item| create_file(item) }

end

def create_file(name)
  File.open(file_name(name), "w+") { |file| file_write(file,name) }
end

def file_write(file,name)
  file.write(JSON.pretty_generate(JSON.parse(open(name).read)))
end

def file_name(name)
  new_array = []
  name.split("/").reverse.each do |value|
    break if value == @file_creation_stopper
    new_array << value
  end
  "#{new_array.reverse.join('_')}.json"
end


#the hash key that the script will look for
@key_to_find = 'href'

# the link is used for file creation. It will use the link from this value until the end of the link
@file_creation_stopper = 'api'

# link to look for the @key_to_find
link = "URL "

find(JSON.parse(open(link).read))
