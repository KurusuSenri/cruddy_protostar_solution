#!/usr/bin/ruby

require 'socket'

hostname = 'localhost'
port = 2998
socket = TCPSocket.open(hostname, port)
 
line = socket.recv(8)
puts "> receive: " + line.inspect

response = line.unpack('L*')
puts "> response: " + response.inspect
socket.puts(response)

puts socket.read

socket.close      
