#!/usr/bin/ruby

require 'socket'

hostname = 'localhost'
port = 2999
socket = TCPSocket.open(hostname, port)
 
line = socket.gets
puts "> receive: " + line

target = line.split("'")
puts "> target: " + target[1]

response = [target[1].to_i].pack('L*')
puts "> response: " + response.inspect
socket.puts(response)

puts socket.read

socket.close      
