#!/usr/bin/ruby

def main
  directory = ARGV[0]
  files = Dir.glob("#{directory}/**/tasks/*.yml")

  files.each do |file_name|
    new_file_string = ''
    File.open(file_name, 'r') do |file|
      file.each_line do |line|
        if safe_line?(line)
          new_file_string += line
        else
          module_name, module_data = extract_info(line)
          new_file_string += "#{module_name}:\n"
          spacing = module_name.match(/^\s*/)[0]
          module_data.each do |k, v|
            v = "'#{v}'" if (v[0] != '"' and v[0] != "'")
            new_file_string += "#{spacing}  #{k}: #{v}\n"
          end
        end
      end
    end
    File.open("#{file_name}", 'w+') do |file|
      file.write(new_file_string)
    end
  end
end

def safe_line?(line)
  skip_these = [
    '---',
    'name:',
    'block:',
    'when:'
  ]
  return (
    skip_these.any? { |x| line.include?(x) } or
    line.count('=') < 3 or
    line[0] == '#' or
    line == "\n"
  )
end

def extract_info(line)
  data_re = /\s(?<key>.+?)=(?<val>.+?({{\s.+\s}})*?.+?)(?=(\s[a-z]+=)|$)/
  line = line.split(':')
  module_name = line[0]
  module_data = Hash[*line.drop(1).join(':').scan(data_re).flatten]
  return module_name, module_data
end


main unless $0 == "irb"
