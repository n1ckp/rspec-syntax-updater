require 'tempfile'
require 'fileutils'

filepath = ARGV[0]
temp_file = Tempfile.new('foo')

File.foreach(filepath).with_index do |line, line_num|
  _line = line
  _line.sub!(/([^\s]*\w*)\.any_instance.stub/, 'allow_any_instance_of(\1).to receive')
  _line.sub!(/([^\s]*\w*)\.stub/, 'allow(\1).to receive')
  _line.sub!(/([^\s]*\w*)\.any_instance.should_receive/, 'expect_any_instance_of(\1).to receive')
  _line.sub!(/([^\s]*\w*)\.should_receive/, 'expect(\1).to receive')
  _line.sub!(/([^\s]*\w*)\.any_instance.should_not_receive/, 'expect_any_instance_of(\1).not_to receive')
  _line.sub!(/([^\s]*\w*)\.should_not_receive/, 'expect(\1).not_to receive')
  _line.sub!(/([^\s]*\w*)\.should_not ==/, 'expect(\1).to_not eq')
  _line.sub!(/([^\s]*\w*)\.should ==/, 'expect(\1).to eq')
  _line.sub!(/([^\s]*\w*)\.should eq/, 'expect(\1).to eq')
  _line.sub!(/([^\s]*\w*)\.should/, 'expect(\1).to')
  temp_file << _line
end

temp_file.close
FileUtils.mv(temp_file.path, filepath)
