ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          2092 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           40 (bytes)
  Number of section headers:         16
  Section header string table index: 15

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00000000 000034 000163 00  AX  0   0  1
  [ 2] .rel.text         REL             00000000 000668 000130 08   I 13   1  4
  [ 3] .data             PROGBITS        00000000 000198 000004 00  WA  0   0  4
  [ 4] .bss              NOBITS          00000000 00019c 000000 00  WA  0   0  1
  [ 5] .stab             PROGBITS        00000000 00019c 0001c8 0c      7   0  4
  [ 6] .rel.stab         REL             00000000 000798 000018 08   I 13   5  4
  [ 7] .stabstr          STRTAB          00000000 000364 00007b 00      0   0  1
  [ 8] .rodata           PROGBITS        00000000 0003e0 000114 00   A  0   0  4
  [ 9] .comment          PROGBITS        00000000 0004f4 000027 01  MS  0   0  1
  [10] .note.GNU-stack   PROGBITS        00000000 00051b 000000 00      0   0  1
  [11] .eh_frame         PROGBITS        00000000 00051c 00003c 00   A  0   0  4
  [12] .rel.eh_frame     REL             00000000 0007b0 000008 08   I 13  11  4
  [13] .symtab           SYMTAB          00000000 000558 0000d0 10     14   4  4
  [14] .strtab           STRTAB          00000000 000628 000040 00      0   0  1
  [15] .shstrtab         STRTAB          00000000 0007b8 000072 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)

There are no section groups in this file.

There are no program headers in this file.

There is no dynamic section in this file.

Relocation section '.rel.text' at offset 0x668 contains 38 entries:
 Offset     Info    Type            Sym.Value  Sym. Name
0000000c  00000301 R_386_32          00000000   .rodata
00000011  00000602 R_386_PC32        00000000   cprintf
00000016  00000702 R_386_PC32        00000000   fork
00000028  00000301 R_386_32          00000000   .rodata
0000002d  00000602 R_386_PC32        00000000   cprintf
00000032  00000802 R_386_PC32        00000000   yield
00000037  00000802 R_386_PC32        00000000   yield
0000003c  00000802 R_386_PC32        00000000   yield
00000041  00000802 R_386_PC32        00000000   yield
00000046  00000802 R_386_PC32        00000000   yield
0000004b  00000802 R_386_PC32        00000000   yield
00000050  00000802 R_386_PC32        00000000   yield
00000055  00000401 R_386_32          00000000   magic
0000005d  00000902 R_386_PC32        00000000   exit
0000006c  00000301 R_386_32          00000000   .rodata
00000071  00000602 R_386_PC32        00000000   cprintf
00000080  00000301 R_386_32          00000000   .rodata
00000088  00000301 R_386_32          00000000   .rodata
00000097  00000301 R_386_32          00000000   .rodata
0000009c  00000a02 R_386_PC32        00000000   __panic
000000a3  00000301 R_386_32          00000000   .rodata
000000a8  00000602 R_386_PC32        00000000   cprintf
000000bc  00000b02 R_386_PC32        00000000   waitpid
000000c9  00000401 R_386_32          00000000   magic
000000d5  00000301 R_386_32          00000000   .rodata
000000dd  00000301 R_386_32          00000000   .rodata
000000ec  00000301 R_386_32          00000000   .rodata
000000f1  00000a02 R_386_PC32        00000000   __panic
00000105  00000b02 R_386_PC32        00000000   waitpid
0000010e  00000c02 R_386_PC32        00000000   wait
0000011a  00000301 R_386_32          00000000   .rodata
00000122  00000301 R_386_32          00000000   .rodata
00000131  00000301 R_386_32          00000000   .rodata
00000136  00000a02 R_386_PC32        00000000   __panic
00000145  00000301 R_386_32          00000000   .rodata
0000014a  00000602 R_386_PC32        00000000   cprintf
00000151  00000301 R_386_32          00000000   .rodata
00000156  00000602 R_386_PC32        00000000   cprintf

Relocation section '.rel.stab' at offset 0x798 contains 3 entries:
 Offset     Info    Type            Sym.Value  Sym. Name
00000014  00000201 R_386_32          00000000   .text
00000044  00000501 R_386_32          00000000   main
000001c4  00000201 R_386_32          00000000   .text

Relocation section '.rel.eh_frame' at offset 0x7b0 contains 1 entry:
 Offset     Info    Type            Sym.Value  Sym. Name
00000020  00000202 R_386_PC32        00000000   .text
No processor specific unwind information to decode

Symbol table '.symtab' contains 13 entries:
   Num:    Value  Size Type    Bind   Vis      Ndx Name
     0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 00000000     0 FILE    LOCAL  DEFAULT  ABS exit.c
     2: 00000000     0 SECTION LOCAL  DEFAULT    1 .text
     3: 00000000     0 SECTION LOCAL  DEFAULT    8 .rodata
     4: 00000000     4 OBJECT  GLOBAL DEFAULT    3 magic
     5: 00000000   355 FUNC    GLOBAL DEFAULT    1 main
     6: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND cprintf
     7: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND fork
     8: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND yield
     9: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND exit
    10: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND __panic
    11: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND waitpid
    12: 00000000     0 NOTYPE  GLOBAL DEFAULT  UND wait

No version information found in this file.
