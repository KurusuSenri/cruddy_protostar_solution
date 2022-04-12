#!/usr/bin/ruby

require 'socket'

# convert a integer into binary
# then split it every 4 characters
def int2bin_split4(int)
  str = int.to_s(2)
  arr = Array.new
  begin
  split = str.split(//).last(4).join
    arr.insert(0, split)
    str = str[0...-4]
  end while split.length == 4
  return arr
end

hostname = 'localhost'
port = 2997
socket = TCPSocket.open(hostname, port)

receive = Array.new
for i in 0..3
  receive += socket.recv(4).unpack('L*')
end
puts "> receive: " + receive.inspect

sum = receive.inject(:+)
puts "> sum in dec: " + sum.inspect
puts "^ in bin: " + int2bin_split4(sum).inspect

puts "----------"

sum_and_f = sum & 0xFFFFFFFF
puts "> sum & 0xFFFFFFFF: " + sum_and_f.inspect
puts "^ in bin: " + int2bin_split4(sum_and_f).inspect

puts "> response: " + ([sum_and_f].pack("L*")).inspect
socket.puts([sum_and_f].pack("L*"))
puts socket.read

socket.close      
