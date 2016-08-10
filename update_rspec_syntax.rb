require 'tempfile'
require 'fileutils'

def process_file(_filepath)
  temp_file = Tempfile.new('foo')
  File.foreach(_filepath).with_index do |line, line_num|
    _line = line
    _line.sub!(/lambda do/, 'expect {')
    _line.sub!(/end.should_not ==/, '}.to_not eq')
    _line.sub!(/end.should_not/, '}.to_not')
    _line.sub!(/end.should ==/, '}.to eq')
    _line.sub!(/end.should/, '}.to')
    _line.sub!(/([^\s].*)\.any_instance.stub/, 'allow_any_instance_of(\1).to receive')
    _line.sub!(/([^\s].*)\.stub/, 'allow(\1).to receive')
    _line.sub!(/([^\s].*)\.any_instance.should_receive/, 'expect_any_instance_of(\1).to receive')
    _line.sub!(/([^\s].*)\.should_receive/, 'expect(\1).to receive')
    _line.sub!(/([^\s].*)\.any_instance.should_not_receive/, 'expect_any_instance_of(\1).not_to receive')
    _line.sub!(/([^\s].*)\.should_not_receive/, 'expect(\1).not_to receive')
    _line.sub!(/([^\s].*)\.should_not ==/, 'expect(\1).to_not eq')
    _line.sub!(/([^\s].*)\.should_not eq/, 'expect(\1).to_not eq')
    _line.sub!(/([^\s].*)\.should_not/, 'expect(\1).to_not')
    _line.sub!(/([^\s].*)\.should ==/, 'expect(\1).to eq')
    _line.sub!(/([^\s].*)\.should eq/, 'expect(\1).to eq')
    _line.sub!(/([^\s].*)\.should/, 'expect(\1).to')
    temp_file << _line
  end
  temp_file.close
  FileUtils.mv(temp_file.path, _filepath)
end

def process_directory(_directory_path)
  Dir.glob("#{_directory_path}*.rb") do |rb_file|
    process_file(rb_file)
  end
end

_path = ARGV[0]

if _path.end_with?(".rb")
  process_file(_path)
elsif _path.end_with?("/")
  process_directory(_path)
else
  process_directory("#{_path}/")
end
