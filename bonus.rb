unless ARGV.size == 3
  puts "Usage: #{$0}: #{/home/rahul/workspace/deep-hool/app/view/} rhtml html.erb"
  exit -1
end
root_path, from_ext, to_ext = ARGV

#MOVE_COMMAND = "git mv"
Dir[File.join(root_path, "**", "*.#{from_ext}")].each do |from_path|
  to_path = from_path.chomp(from_ext) + to_ext
#  command = "#{MOVE_COMMAND} #{from_path} #{to_path}"
#  puts command
  system(command)
end
