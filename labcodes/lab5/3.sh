ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x800020
  Start of program headers:          52 (bytes into file)
  Start of section headers:          30336 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         4
  Size of section headers:           40 (bytes)
  Number of section headers:         10
  Section header string table index: 9

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00800020 005020 0010f2 00  AX  0   0  1
  [ 2] .rodata           PROGBITS        00801120 006120 0003f4 00   A  0   0 32
  [ 3] .data             PROGBITS        00802000 007000 00000c 00  WA  0   0  8
  [ 4] .stab_info        PROGBITS        00200000 001000 000010 00   A  0   0  1
  [ 5] .stab             PROGBITS        00200010 001010 002809 0c   A  6   0  4
  [ 6] .stabstr          STRTAB          00202819 003819 000f2f 00   A  0   0  1
  [ 7] .symtab           SYMTAB          00000000 00700c 000440 10      8  19  4
  [ 8] .strtab           STRTAB          00000000 00744c 0001e8 00      0   0  1
  [ 9] .shstrtab         STRTAB          00000000 007634 000049 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00200000 0x00200000 0x03748 0x03748 R   0x1000
  LOAD           0x005020 0x00800020 0x00800020 0x014f4 0x014f4 R E 0x1000
  LOAD           0x007000 0x00802000 0x00802000 0x0000c 0x0000c RW  0x1000
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10

 Section to Segment mapping:
  Segment Sections...
   00     .stab_info .stab .stabstr 
   01     .text .rodata 
   02     .data 
   03     

There is no dynamic section in this file.

There are no relocations in this file.
No processor specific unwind information to decode

Symbol table '.symtab' contains 68 entries:
   Num:    Value  Size Type    Bind   Vis      Ndx Name
     0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 00000000     0 FILE    LOCAL  DEFAULT  ABS panic.c
     2: 00000000     0 FILE    LOCAL  DEFAULT  ABS stdio.c
     3: 008000c8    35 FUNC    LOCAL  DEFAULT    1 cputch
     4: 00000000     0 FILE    LOCAL  DEFAULT  ABS syscall.c
     5: 00800199    85 FUNC    LOCAL  DEFAULT    1 syscall
     6: 00000000     0 FILE    LOCAL  DEFAULT  ABS ulib.c
     7: 00000000     0 FILE    LOCAL  DEFAULT  ABS umain.c
     8: 00000000     0 FILE    LOCAL  DEFAULT  ABS hash.c
     9: 00000000     0 FILE    LOCAL  DEFAULT  ABS printfmt.c
    10: 00801220   100 OBJECT  LOCAL  DEFAULT    2 error_string
    11: 008003ad   258 FUNC    LOCAL  DEFAULT    1 printnum
    12: 008004af    79 FUNC    LOCAL  DEFAULT    1 getuint
    13: 008004fe    71 FUNC    LOCAL  DEFAULT    1 getint
    14: 0080094f    54 FUNC    LOCAL  DEFAULT    1 sprintputch
    15: 00000000     0 FILE    LOCAL  DEFAULT  ABS rand.c
    16: 00802000     8 OBJECT  LOCAL  DEFAULT    3 next
    17: 00000000     0 FILE    LOCAL  DEFAULT  ABS string.c
    18: 00000000     0 FILE    LOCAL  DEFAULT  ABS exit.c
    19: 00800b53    63 FUNC    GLOBAL DEFAULT    1 strcpy
    20: 00800329    16 FUNC    GLOBAL DEFAULT    1 yield
    21: 0080030d    28 FUNC    GLOBAL DEFAULT    1 waitpid
    22: 00800245    22 FUNC    GLOBAL DEFAULT    1 sys_yield
    23: 00800e65   163 FUNC    GLOBAL DEFAULT    1 memmove
    24: 00800985    54 FUNC    GLOBAL DEFAULT    1 snprintf
    25: 00800576   985 FUNC    GLOBAL DEFAULT    1 vprintfmt
    26: 0080020b    22 FUNC    GLOBAL DEFAULT    1 sys_fork
    27: 00800120    40 FUNC    GLOBAL DEFAULT    1 cprintf
    28: 0080034e    15 FUNC    GLOBAL DEFAULT    1 getpid
    29: 00800f08    79 FUNC    GLOBAL DEFAULT    1 memcpy
    30: 008009bb   102 FUNC    GLOBAL DEFAULT    1 vsnprintf
    31: 0080036d    25 FUNC    GLOBAL DEFAULT    1 umain
    32: 00202818     0 NOTYPE  GLOBAL DEFAULT    5 __STAB_END__
    33: 0080025b    29 FUNC    GLOBAL DEFAULT    1 sys_kill
    34: 00202819     0 NOTYPE  GLOBAL DEFAULT    6 __STABSTR_BEGIN__
    35: 0080002f    80 FUNC    GLOBAL DEFAULT    1 __panic
    36: 00800ccb   344 FUNC    GLOBAL DEFAULT    1 strtol
    37: 00800b22    49 FUNC    GLOBAL DEFAULT    1 strnlen
    38: 0080035d    16 FUNC    GLOBAL DEFAULT    1 print_pgdir
    39: 00800339    21 FUNC    GLOBAL DEFAULT    1 kill
    40: 00800c9b    48 FUNC    GLOBAL DEFAULT    1 strfind
    41: 008002ef    30 FUNC    GLOBAL DEFAULT    1 wait
    42: 00800020     0 NOTYPE  GLOBAL DEFAULT    1 _start
    43: 00800a21   191 FUNC    GLOBAL DEFAULT    1 rand
    44: 00800c14    83 FUNC    GLOBAL DEFAULT    1 strncmp
    45: 0080028e    29 FUNC    GLOBAL DEFAULT    1 sys_putc
    46: 00800b92    57 FUNC    GLOBAL DEFAULT    1 strncpy
    47: 00800f57    88 FUNC    GLOBAL DEFAULT    1 memcmp
    48: 008002e0    15 FUNC    GLOBAL DEFAULT    1 fork
    49: 00800e23    66 FUNC    GLOBAL DEFAULT    1 memset
    50: 00800faf   355 FUNC    GLOBAL DEFAULT    1 main
    51: 00800ae0    25 FUNC    GLOBAL DEFAULT    1 srand
    52: 00800386    39 FUNC    GLOBAL DEFAULT    1 hash32
    53: 00800545    49 FUNC    GLOBAL DEFAULT    1 printfmt
    54: 00203747     0 NOTYPE  GLOBAL DEFAULT    6 __STABSTR_END__
    55: 00800bcb    73 FUNC    GLOBAL DEFAULT    1 strcmp
    56: 00802008     4 OBJECT  GLOBAL DEFAULT    3 magic
    57: 008000eb    53 FUNC    GLOBAL DEFAULT    1 vcprintf
    58: 0080007f    73 FUNC    GLOBAL DEFAULT    1 __warn
    59: 00800148    81 FUNC    GLOBAL DEFAULT    1 cputs
    60: 008002c1    31 FUNC    GLOBAL DEFAULT    1 exit
    61: 00800221    36 FUNC    GLOBAL DEFAULT    1 sys_wait
    62: 008001ee    29 FUNC    GLOBAL DEFAULT    1 sys_exit
    63: 00200010     0 NOTYPE  GLOBAL DEFAULT    5 __STAB_BEGIN__
    64: 00800af9    41 FUNC    GLOBAL DEFAULT    1 strlen
    65: 008002ab    22 FUNC    GLOBAL DEFAULT    1 sys_pgdir
    66: 00800c67    52 FUNC    GLOBAL DEFAULT    1 strchr
    67: 00800278    22 FUNC    GLOBAL DEFAULT    1 sys_getpid

No version information found in this file.
