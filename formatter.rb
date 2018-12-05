#!/usr/bin/ruby

def main

  usage = "Usage:\n" \
        "  ./formatter.rb [-f | --files] FILE...\n" \
        "  ./formatter.rb [-d | --dir] ROLE_DIR\n"
  $verbose = false

  if ARGV.include?('-v') or ARGV.include?('--verbose')
    ARGV.delete('-v')
    ARGV.delete('--verbose')
    $verbose = true
  end

  if ARGV.include?('-h') or ARGV.include?('--help')
    print usage
    print "Change formatting of Ansible task files from oneline syntax to dictionary style\n"
    print "Use -f or --files to format single files\n"
    print "Use -d or --dir to format all files in ROLE_DIR/*/tasks/*.yml\n"
    exit(0)
  elsif ARGV.include?('-f') or ARGV.include?('--files')
    ARGV.delete('-f')
    ARGV.delete('--files')
    files = ARGV
  elsif ARGV.include?('-d') or ARGV.include?('--dir')
    ARGV.delete('-d')
    ARGV.delete('--dir')
    files = Dir.glob("#{ARGV[0].chomp('/')}/*/tasks/*.yml")
  else
    print usage
    print "Try './formatter.rb --help' for more information.\n"
    exit(1)
  end

  files.each do |file_name|
    new_file_string = ''
    changed = false
    File.open(file_name, 'r') do |file|
      file.each_line do |line|
        if safe_line?(line)
          new_file_string += line
        else
          changed = true
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
      print "Formatting #{file_name}\n" if $verbose and changed
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
