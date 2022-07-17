ELF 头：
  Magic：   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  类别:                              ELF32
  数据:                              2 补码，小端序 (little endian)
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI 版本:                          0
  类型:                              EXEC (可执行文件)
  系统架构:                          Intel 80386
  版本:                              0x1
  入口点地址：               0xc0100000
  程序头起点：          52 (bytes into file)
  Start of section headers:          126560 (bytes into file)
  标志：             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         3
  Size of section headers:           40 (bytes)
  Number of section headers:         12
  Section header string table index: 11

节头：
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        c0100000 001000 005ec3 00  AX  0   0  1
  [ 2] .rodata           PROGBITS        c0105ee0 006ee0 001370 00   A  0   0 32
  [ 3] .stab             PROGBITS        c0107250 008250 00b4d9 0c   A  4   0  4
  [ 4] .stabstr          STRTAB          c0112729 013729 003564 00   A  0   0  1
  [ 5] .data             PROGBITS        c0116000 017000 002a36 00  WA  0   0 4096
  [ 6] .data.pgdir       PROGBITS        c0119000 01a000 002000 00  WA  0   0 4096
  [ 7] .bss              NOBITS          c011b000 01c000 000f2c 00  WA  0   0 32
  [ 8] .comment          PROGBITS        00000000 01c000 000026 01  MS  0   0  1
  [ 9] .symtab           SYMTAB          00000000 01c028 001cb0 10     10 115  4
  [10] .strtab           STRTAB          00000000 01dcd8 00112e 00      0   0  1
  [11] .shstrtab         STRTAB          00000000 01ee06 000058 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)

There are no section groups in this file.

程序头：
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0xc0100000 0xc0100000 0x15c8d 0x15c8d R E 0x1000
  LOAD           0x017000 0xc0116000 0xc0116000 0x05000 0x05f2c RW  0x1000
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10

 Section to Segment mapping:
  段节...
   00     .text .rodata .stab .stabstr 
   01     .data .data.pgdir .bss 
   02     

There is no dynamic section in this file.

该文件中没有重定位信息。
No processor specific unwind information to decode

Symbol table '.symtab' contains 459 entries:
   Num:    Value  Size Type    Bind   Vis      Ndx Name
     0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 00000000     0 FILE    LOCAL  DEFAULT  ABS entry.o
     2: c010001e     0 NOTYPE  LOCAL  DEFAULT    1 next
     3: c0100034     0 NOTYPE  LOCAL  DEFAULT    1 spin
     4: c011a000     0 NOTYPE  LOCAL  DEFAULT    6 __boot_pt1
     5: 00000400     0 NOTYPE  LOCAL  DEFAULT  ABS i
     6: 00000000     0 FILE    LOCAL  DEFAULT  ABS init.c
     7: c010013f   192 FUNC    LOCAL  DEFAULT    1 lab1_print_cur_status
     8: c011b000     4 OBJECT  LOCAL  DEFAULT    7 round.0
     9: c01001ff     6 FUNC    LOCAL  DEFAULT    1 lab1_switch_to_user
    10: c0100205     6 FUNC    LOCAL  DEFAULT    1 lab1_switch_to_kernel
    11: c010020b    60 FUNC    LOCAL  DEFAULT    1 lab1_switch_test
    12: 00000000     0 FILE    LOCAL  DEFAULT  ABS readline.c
    13: c011b020  1024 OBJECT  LOCAL  DEFAULT    7 buf
    14: 00000000     0 FILE    LOCAL  DEFAULT  ABS stdio.c
    15: c01002fe    35 FUNC    LOCAL  DEFAULT    1 cputch
    16: 00000000     0 FILE    LOCAL  DEFAULT  ABS kdebug.c
    17: c0100401   336 FUNC    LOCAL  DEFAULT    1 stab_binsearch
    18: c01009b2    19 FUNC    LOCAL  DEFAULT    1 read_eip
    19: 00000000     0 FILE    LOCAL  DEFAULT  ABS kmonitor.c
    20: c0118000    36 OBJECT  LOCAL  DEFAULT    5 commands
    21: c0100a90   185 FUNC    LOCAL  DEFAULT    1 parse
    22: c0100b49   184 FUNC    LOCAL  DEFAULT    1 runcmd
    23: 00000000     0 FILE    LOCAL  DEFAULT  ABS panic.c
    24: c011b420     4 OBJECT  LOCAL  DEFAULT    7 is_panic
    25: 00000000     0 FILE    LOCAL  DEFAULT  ABS clock.c
    26: 00000000     0 FILE    LOCAL  DEFAULT  ABS console.c
    27: c0100e22    44 FUNC    LOCAL  DEFAULT    1 __intr_save
    28: c0100e4e    22 FUNC    LOCAL  DEFAULT    1 __intr_restore
    29: c0100e64    75 FUNC    LOCAL  DEFAULT    1 delay
    30: c011b440     4 OBJECT  LOCAL  DEFAULT    7 crt_buf
    31: c011b444     2 OBJECT  LOCAL  DEFAULT    7 crt_pos
    32: c011b446     2 OBJECT  LOCAL  DEFAULT    7 addr_6845
    33: c0100eaf   232 FUNC    LOCAL  DEFAULT    1 cga_init
    34: c011b448     4 OBJECT  LOCAL  DEFAULT    7 serial_exists
    35: c0100f97   237 FUNC    LOCAL  DEFAULT    1 serial_init
    36: c0101084   126 FUNC    LOCAL  DEFAULT    1 lpt_putc_sub
    37: c0101102    66 FUNC    LOCAL  DEFAULT    1 lpt_putc
    38: c0101144   502 FUNC    LOCAL  DEFAULT    1 cga_putc
    39: c010133a    92 FUNC    LOCAL  DEFAULT    1 serial_putc_sub
    40: c0101396    66 FUNC    LOCAL  DEFAULT    1 serial_putc
    41: c011b460   520 OBJECT  LOCAL  DEFAULT    7 cons
    42: c01013d8    79 FUNC    LOCAL  DEFAULT    1 cons_intr
    43: c0101427    89 FUNC    LOCAL  DEFAULT    1 serial_proc_data
    44: c0118040   256 OBJECT  LOCAL  DEFAULT    5 shiftcode
    45: c0118140   256 OBJECT  LOCAL  DEFAULT    5 togglecode
    46: c0118240   256 OBJECT  LOCAL  DEFAULT    5 normalmap
    47: c0118340   256 OBJECT  LOCAL  DEFAULT    5 shiftmap
    48: c0118440   256 OBJECT  LOCAL  DEFAULT    5 ctlmap
    49: c0118540    16 OBJECT  LOCAL  DEFAULT    5 charcode
    50: c01014a0   391 FUNC    LOCAL  DEFAULT    1 kbd_proc_data
    51: c011b668     4 OBJECT  LOCAL  DEFAULT    7 shift.0
    52: c0101627    23 FUNC    LOCAL  DEFAULT    1 kbd_intr
    53: c010163e    28 FUNC    LOCAL  DEFAULT    1 kbd_init
    54: 00000000     0 FILE    LOCAL  DEFAULT  ABS intr.c
    55: 00000000     0 FILE    LOCAL  DEFAULT  ABS picirq.c
    56: c0118550     2 OBJECT  LOCAL  DEFAULT    5 irq_mask
    57: c011b66c     4 OBJECT  LOCAL  DEFAULT    7 did_init
    58: c0101749    93 FUNC    LOCAL  DEFAULT    1 pic_setmask
    59: 00000000     0 FILE    LOCAL  DEFAULT  ABS trap.c
    60: c0101925    31 FUNC    LOCAL  DEFAULT    1 print_ticks
    61: c011b680  2048 OBJECT  LOCAL  DEFAULT    7 idt
    62: c0118560     6 OBJECT  LOCAL  DEFAULT    5 idt_pd
    63: c0101a4e    49 FUNC    LOCAL  DEFAULT    1 trapname
    64: c01065c0    80 OBJECT  LOCAL  DEFAULT    2 excnames.0
    65: c0118580    96 OBJECT  LOCAL  DEFAULT    5 IA32flags
    66: c0101d01   313 FUNC    LOCAL  DEFAULT    1 trap_dispatch
    67: 00000000     0 FILE    LOCAL  DEFAULT  ABS default_pmm.c
    68: c01028e4    25 FUNC    LOCAL  DEFAULT    1 page2ppn
    69: c01028fd    24 FUNC    LOCAL  DEFAULT    1 page2pa
    70: c0102915    10 FUNC    LOCAL  DEFAULT    1 page_ref
    71: c010291f    14 FUNC    LOCAL  DEFAULT    1 set_page_ref
    72: c010292d    49 FUNC    LOCAL  DEFAULT    1 default_init
    73: c010295e   354 FUNC    LOCAL  DEFAULT    1 default_init_memmap
    74: c0102ac0   380 FUNC    LOCAL  DEFAULT    1 default_alloc_pages
    75: c0102c3c   696 FUNC    LOCAL  DEFAULT    1 default_free_pages
    76: c0102ef4    10 FUNC    LOCAL  DEFAULT    1 default_nr_free_pages
    77: c0102efe  1344 FUNC    LOCAL  DEFAULT    1 basic_check
    78: c010343e  1680 FUNC    LOCAL  DEFAULT    1 default_check
    79: 00000000     0 FILE    LOCAL  DEFAULT  ABS pmm.c
    80: c0103ace    25 FUNC    LOCAL  DEFAULT    1 page2ppn
    81: c0103ae7    24 FUNC    LOCAL  DEFAULT    1 page2pa
    82: c0103aff    81 FUNC    LOCAL  DEFAULT    1 pa2page
    83: c0103b50    86 FUNC    LOCAL  DEFAULT    1 page2kva
    84: c0103ba6    64 FUNC    LOCAL  DEFAULT    1 pte2page
    85: c0103be6    26 FUNC    LOCAL  DEFAULT    1 pde2page
    86: c0103c00    10 FUNC    LOCAL  DEFAULT    1 page_ref
    87: c0103c0a    23 FUNC    LOCAL  DEFAULT    1 page_ref_inc
    88: c0103c21    23 FUNC    LOCAL  DEFAULT    1 page_ref_dec
    89: c0103c38    44 FUNC    LOCAL  DEFAULT    1 __intr_save
    90: c0103c64    22 FUNC    LOCAL  DEFAULT    1 __intr_restore
    91: c011bec0   104 OBJECT  LOCAL  DEFAULT    7 ts
    92: c0118a00    48 OBJECT  LOCAL  DEFAULT    5 gdt
    93: c0118a30     6 OBJECT  LOCAL  DEFAULT    5 gdt_pd
    94: c0103c7a    54 FUNC    LOCAL  DEFAULT    1 lgdt
    95: c0103cbe   236 FUNC    LOCAL  DEFAULT    1 gdt_init
    96: c0103daa    54 FUNC    LOCAL  DEFAULT    1 init_pmm_manager
    97: c0103de0    34 FUNC    LOCAL  DEFAULT    1 init_memmap
    98: c0103e9e  1111 FUNC    LOCAL  DEFAULT    1 page_init
    99: c01042f5   262 FUNC    LOCAL  DEFAULT    1 boot_map_segment
   100: c01043fb    70 FUNC    LOCAL  DEFAULT    1 boot_alloc_page
   101: c01046f1    33 FUNC    LOCAL  DEFAULT    1 check_alloc_page
   102: c0104712  1694 FUNC    LOCAL  DEFAULT    1 check_pgdir
   103: c0104db0   908 FUNC    LOCAL  DEFAULT    1 check_boot_pgdir
   104: c010458a     6 FUNC    LOCAL  DEFAULT    1 page_remove_pte
   105: c010513c    66 FUNC    LOCAL  DEFAULT    1 perm2str
   106: c011bf28     4 OBJECT  LOCAL  DEFAULT    7 str.0
   107: c010517e   180 FUNC    LOCAL  DEFAULT    1 get_pgtable_items
   108: 00000000     0 FILE    LOCAL  DEFAULT  ABS printfmt.c
   109: c01070b8    28 OBJECT  LOCAL  DEFAULT    2 error_string
   110: c0105399   258 FUNC    LOCAL  DEFAULT    1 printnum
   111: c010549b    79 FUNC    LOCAL  DEFAULT    1 getuint
   112: c01054ea    71 FUNC    LOCAL  DEFAULT    1 getint
   113: c010593b    54 FUNC    LOCAL  DEFAULT    1 sprintputch
   114: 00000000     0 FILE    LOCAL  DEFAULT  ABS string.c
   115: c010283c     0 NOTYPE  GLOBAL DEFAULT    1 vector242
   116: c0102293     0 NOTYPE  GLOBAL DEFAULT    1 vector119
   117: c0100879   148 FUNC    GLOBAL DEFAULT    1 print_kerninfo
   118: c0102173     0 NOTYPE  GLOBAL DEFAULT    1 vector87
   119: c010216a     0 NOTYPE  GLOBAL DEFAULT    1 vector86
   120: c01028a8     0 NOTYPE  GLOBAL DEFAULT    1 vector251
   121: c0105a67    63 FUNC    GLOBAL DEFAULT    1 strcpy
   122: c0102197     0 NOTYPE  GLOBAL DEFAULT    1 vector91
   123: c0101f8d     0 NOTYPE  GLOBAL DEFAULT    1 vector33
   124: c010247c     0 NOTYPE  GLOBAL DEFAULT    1 vector162
   125: c01026e0     0 NOTYPE  GLOBAL DEFAULT    1 vector213
   126: c0102230     0 NOTYPE  GLOBAL DEFAULT    1 vector108
   127: c0101fe7     0 NOTYPE  GLOBAL DEFAULT    1 vector43
   128: c0100000     0 NOTYPE  GLOBAL DEFAULT    1 kern_entry
   129: c0100cd4    20 FUNC    GLOBAL DEFAULT    1 mon_backtrace
   130: c01024a0     0 NOTYPE  GLOBAL DEFAULT    1 vector165
   131: c0102590     0 NOTYPE  GLOBAL DEFAULT    1 vector185
   132: c010226f     0 NOTYPE  GLOBAL DEFAULT    1 vector115
   133: c01022ae     0 NOTYPE  GLOBAL DEFAULT    1 vector122
   134: c01045d7   187 FUNC    GLOBAL DEFAULT    1 page_insert
   135: c0102434     0 NOTYPE  GLOBAL DEFAULT    1 vector156
   136: c0102860     0 NOTYPE  GLOBAL DEFAULT    1 vector245
   137: c01025c0     0 NOTYPE  GLOBAL DEFAULT    1 vector189
   138: c0101eb1     0 NOTYPE  GLOBAL DEFAULT    1 vector7
   139: c0102089     0 NOTYPE  GLOBAL DEFAULT    1 vector61
   140: c0101f3c     0 NOTYPE  GLOBAL DEFAULT    1 vector24
   141: c010224b     0 NOTYPE  GLOBAL DEFAULT    1 vector111
   142: c0102644     0 NOTYPE  GLOBAL DEFAULT    1 vector200
   143: c01020bf     0 NOTYPE  GLOBAL DEFAULT    1 vector67
   144: c010235c     0 NOTYPE  GLOBAL DEFAULT    1 vector138
   145: c01020fe     0 NOTYPE  GLOBAL DEFAULT    1 vector74
   146: c0105d79   163 FUNC    GLOBAL DEFAULT    1 memmove
   147: c0102065     0 NOTYPE  GLOBAL DEFAULT    1 vector57
   148: c0105971    54 FUNC    GLOBAL DEFAULT    1 snprintf
   149: c0101a94   435 FUNC    GLOBAL DEFAULT    1 print_trapframe
   150: c01026ec     0 NOTYPE  GLOBAL DEFAULT    1 vector214
   151: c0105562   985 FUNC    GLOBAL DEFAULT    1 vprintfmt
   152: c01021df     0 NOTYPE  GLOBAL DEFAULT    1 vector99
   153: c010452f    91 FUNC    GLOBAL DEFAULT    1 get_page
   154: c0101e50     0 NOTYPE  GLOBAL DEFAULT    1 __alltraps
   155: c01016c8   113 FUNC    GLOBAL DEFAULT    1 cons_getc
   156: c0102380     0 NOTYPE  GLOBAL DEFAULT    1 vector141
   157: c0100daf    10 FUNC    GLOBAL DEFAULT    1 is_kernel_panic
   158: c01024f4     0 NOTYPE  GLOBAL DEFAULT    1 vector172
   159: c01009c5   203 FUNC    GLOBAL DEFAULT    1 print_stackframe
   160: c0102830     0 NOTYPE  GLOBAL DEFAULT    1 vector241
   161: c01028c0     0 NOTYPE  GLOBAL DEFAULT    1 vector253
   162: c0101e8d     0 NOTYPE  GLOBAL DEFAULT    1 vector3
   163: c0101e84     0 NOTYPE  GLOBAL DEFAULT    1 vector2
   164: c0102788     0 NOTYPE  GLOBAL DEFAULT    1 vector227
   165: c01026bc     0 NOTYPE  GLOBAL DEFAULT    1 vector210
   166: c0102764     0 NOTYPE  GLOBAL DEFAULT    1 vector224
   167: c0101fd5     0 NOTYPE  GLOBAL DEFAULT    1 vector41
   168: c0100356    40 FUNC    GLOBAL DEFAULT    1 cprintf
   169: c0101f21     0 NOTYPE  GLOBAL DEFAULT    1 vector21
   170: c0102530     0 NOTYPE  GLOBAL DEFAULT    1 vector177
   171: c010228a     0 NOTYPE  GLOBAL DEFAULT    1 vector118
   172: c01020da     0 NOTYPE  GLOBAL DEFAULT    1 vector70
   173: c01020d1     0 NOTYPE  GLOBAL DEFAULT    1 vector69
   174: c0102800     0 NOTYPE  GLOBAL DEFAULT    1 vector237
   175: c01020a4     0 NOTYPE  GLOBAL DEFAULT    1 vector64
   176: c0101f57     0 NOTYPE  GLOBAL DEFAULT    1 vector27
   177: c0102314     0 NOTYPE  GLOBAL DEFAULT    1 vector132
   178: c010259c     0 NOTYPE  GLOBAL DEFAULT    1 vector186
   179: c0102710     0 NOTYPE  GLOBAL DEFAULT    1 vector217
   180: c0105e1c    79 FUNC    GLOBAL DEFAULT    1 memcpy
   181: c0101e7b     0 NOTYPE  GLOBAL DEFAULT    1 vector1
   182: c010253c     0 NOTYPE  GLOBAL DEFAULT    1 vector178
   183: c0101fba     0 NOTYPE  GLOBAL DEFAULT    1 vector38
   184: c010280c     0 NOTYPE  GLOBAL DEFAULT    1 vector238
   185: c0100247   183 FUNC    GLOBAL DEFAULT    1 readline
   186: c0102320     0 NOTYPE  GLOBAL DEFAULT    1 vector133
   187: c01020f5     0 NOTYPE  GLOBAL DEFAULT    1 vector73
   188: c01023a4     0 NOTYPE  GLOBAL DEFAULT    1 vector144
   189: c0106a50     4 OBJECT  GLOBAL DEFAULT    2 vpd
   190: c0100036   108 FUNC    GLOBAL DEFAULT    1 kern_init
   191: c01028cc     0 NOTYPE  GLOBAL DEFAULT    1 vector254
   192: c01021f1     0 NOTYPE  GLOBAL DEFAULT    1 vector101
   193: c01026c8     0 NOTYPE  GLOBAL DEFAULT    1 vector211
   194: c010250c     0 NOTYPE  GLOBAL DEFAULT    1 vector174
   195: c0102848     0 NOTYPE  GLOBAL DEFAULT    1 vector243
   196: c01022e4     0 NOTYPE  GLOBAL DEFAULT    1 vector128
   197: c010213d     0 NOTYPE  GLOBAL DEFAULT    1 vector81
   198: c0103e3c    53 FUNC    GLOBAL DEFAULT    1 free_pages
   199: c0101edf     0 NOTYPE  GLOBAL DEFAULT    1 vector13
   200: c01059a7   102 FUNC    GLOBAL DEFAULT    1 vsnprintf
   201: c010202f     0 NOTYPE  GLOBAL DEFAULT    1 vector51
   202: c0101ef6     0 NOTYPE  GLOBAL DEFAULT    1 vector16
   203: c011b000     0 NOTYPE  GLOBAL DEFAULT    6 edata
   204: c010165a    47 FUNC    GLOBAL DEFAULT    1 cons_init
   205: c011beac     4 OBJECT  GLOBAL DEFAULT    7 pmm_manager
   206: c0102824     0 NOTYPE  GLOBAL DEFAULT    1 vector240
   207: c010204a     0 NOTYPE  GLOBAL DEFAULT    1 vector54
   208: c0101f0f     0 NOTYPE  GLOBAL DEFAULT    1 vector19
   209: c0112728     0 NOTYPE  GLOBAL DEFAULT    3 __STAB_END__
   210: c01021a0     0 NOTYPE  GLOBAL DEFAULT    1 vector92
   211: c0102854     0 NOTYPE  GLOBAL DEFAULT    1 vector244
   212: c0103cb0    14 FUNC    GLOBAL DEFAULT    1 load_esp0
   213: c0102374     0 NOTYPE  GLOBAL DEFAULT    1 vector140
   214: c0101ff9     0 NOTYPE  GLOBAL DEFAULT    1 vector45
   215: c010212b     0 NOTYPE  GLOBAL DEFAULT    1 vector79
   216: c01027a0     0 NOTYPE  GLOBAL DEFAULT    1 vector229
   217: c010244c     0 NOTYPE  GLOBAL DEFAULT    1 vector158
   218: c01017a6    53 FUNC    GLOBAL DEFAULT    1 pic_enable
   219: c0101fc3     0 NOTYPE  GLOBAL DEFAULT    1 vector39
   220: c01024c4     0 NOTYPE  GLOBAL DEFAULT    1 vector168
   221: c0101f9f     0 NOTYPE  GLOBAL DEFAULT    1 vector35
   222: c010225d     0 NOTYPE  GLOBAL DEFAULT    1 vector113
   223: c0112729     0 NOTYPE  GLOBAL DEFAULT    4 __STABSTR_BEGIN__
   224: c01022c9     0 NOTYPE  GLOBAL DEFAULT    1 vector125
   225: c0100ce8   126 FUNC    GLOBAL DEFAULT    1 __panic
   226: c0102704     0 NOTYPE  GLOBAL DEFAULT    1 vector216
   227: c010209b     0 NOTYPE  GLOBAL DEFAULT    1 vector63
   228: c0101f4e     0 NOTYPE  GLOBAL DEFAULT    1 vector26
   229: c0101480    32 FUNC    GLOBAL DEFAULT    1 serial_intr
   230: c01025f0     0 NOTYPE  GLOBAL DEFAULT    1 vector193
   231: c0102614     0 NOTYPE  GLOBAL DEFAULT    1 vector196
   232: c01000fa    29 FUNC    GLOBAL DEFAULT    1 grade_backtrace0
   233: c01026b0     0 NOTYPE  GLOBAL DEFAULT    1 vector209
   234: c0101e96     0 NOTYPE  GLOBAL DEFAULT    1 vector4
   235: c01024dc     0 NOTYPE  GLOBAL DEFAULT    1 vector170
   236: c0102344     0 NOTYPE  GLOBAL DEFAULT    1 vector136
   237: c0101eca     0 NOTYPE  GLOBAL DEFAULT    1 vector10
   238: c010268c     0 NOTYPE  GLOBAL DEFAULT    1 vector206
   239: c01028d8     0 NOTYPE  GLOBAL DEFAULT    1 vector255
   240: c0102560     0 NOTYPE  GLOBAL DEFAULT    1 vector181
   241: c0102077     0 NOTYPE  GLOBAL DEFAULT    1 vector59
   242: c0100117    40 FUNC    GLOBAL DEFAULT    1 grade_backtrace
   243: c0102161     0 NOTYPE  GLOBAL DEFAULT    1 vector85
   244: c0102158     0 NOTYPE  GLOBAL DEFAULT    1 vector84
   245: c0102578     0 NOTYPE  GLOBAL DEFAULT    1 vector183
   246: c0102458     0 NOTYPE  GLOBAL DEFAULT    1 vector159
   247: c01026d4     0 NOTYPE  GLOBAL DEFAULT    1 vector212
   248: c010200b     0 NOTYPE  GLOBAL DEFAULT    1 vector47
   249: c0105bdf   344 FUNC    GLOBAL DEFAULT    1 strtol
   250: c0102794     0 NOTYPE  GLOBAL DEFAULT    1 vector228
   251: c0101fde     0 NOTYPE  GLOBAL DEFAULT    1 vector42
   252: c0102266     0 NOTYPE  GLOBAL DEFAULT    1 vector114
   253: c0105a36    49 FUNC    GLOBAL DEFAULT    1 strnlen
   254: c0102518     0 NOTYPE  GLOBAL DEFAULT    1 vector175
   255: c0102398     0 NOTYPE  GLOBAL DEFAULT    1 vector143
   256: c01022fc     0 NOTYPE  GLOBAL DEFAULT    1 vector130
   257: c01069b8    28 OBJECT  GLOBAL DEFAULT    2 default_pmm_manager
   258: c010286c     0 NOTYPE  GLOBAL DEFAULT    1 vector246
   259: c0101ec1     0 NOTYPE  GLOBAL DEFAULT    1 vector9
   260: c010238c     0 NOTYPE  GLOBAL DEFAULT    1 vector142
   261: c01021e8     0 NOTYPE  GLOBAL DEFAULT    1 vector100
   262: c0102650     0 NOTYPE  GLOBAL DEFAULT    1 vector201
   263: c0101944   266 FUNC    GLOBAL DEFAULT    1 idt_init
   264: c010090d   165 FUNC    GLOBAL DEFAULT    1 print_debuginfo
   265: c0102080     0 NOTYPE  GLOBAL DEFAULT    1 vector60
   266: c0101f33     0 NOTYPE  GLOBAL DEFAULT    1 vector23
   267: c01027f4     0 NOTYPE  GLOBAL DEFAULT    1 vector236
   268: c011bea4     4 OBJECT  GLOBAL DEFAULT    7 npage
   269: c01027b8     0 NOTYPE  GLOBAL DEFAULT    1 vector231
   270: c01020b6     0 NOTYPE  GLOBAL DEFAULT    1 vector66
   271: c0101f69     0 NOTYPE  GLOBAL DEFAULT    1 vector29
   272: c0105232   359 FUNC    GLOBAL DEFAULT    1 print_pgdir
   273: c0102338     0 NOTYPE  GLOBAL DEFAULT    1 vector135
   274: c0100c01    98 FUNC    GLOBAL DEFAULT    1 kmonitor
   275: c0102119     0 NOTYPE  GLOBAL DEFAULT    1 vector77
   276: c0102554     0 NOTYPE  GLOBAL DEFAULT    1 vector180
   277: c0100db9   105 FUNC    GLOBAL DEFAULT    1 clock_init
   278: c01026a4     0 NOTYPE  GLOBAL DEFAULT    1 vector208
   279: c01021d6     0 NOTYPE  GLOBAL DEFAULT    1 vector98
   280: c01021cd     0 NOTYPE  GLOBAL DEFAULT    1 vector97
   281: c0103e71    45 FUNC    GLOBAL DEFAULT    1 nr_free_pages
   282: c0102524     0 NOTYPE  GLOBAL DEFAULT    1 vector176
   283: c01025fc     0 NOTYPE  GLOBAL DEFAULT    1 vector194
   284: c0101f84     0 NOTYPE  GLOBAL DEFAULT    1 vector32
   285: c011bea8     4 OBJECT  GLOBAL DEFAULT    7 boot_cr3
   286: c011bf2c     0 NOTYPE  GLOBAL DEFAULT    7 end
   287: c0102638     0 NOTYPE  GLOBAL DEFAULT    1 vector199
   288: c0102308     0 NOTYPE  GLOBAL DEFAULT    1 vector131
   289: c01028b4     0 NOTYPE  GLOBAL DEFAULT    1 vector252
   290: c0101e72     0 NOTYPE  GLOBAL DEFAULT    1 vector0
   291: c0105baf    48 FUNC    GLOBAL DEFAULT    1 strfind
   292: c0101689    63 FUNC    GLOBAL DEFAULT    1 cons_putc
   293: c0105ec3     0 NOTYPE  GLOBAL DEFAULT    1 etext
   294: c01023b0     0 NOTYPE  GLOBAL DEFAULT    1 vector145
   295: c0102227     0 NOTYPE  GLOBAL DEFAULT    1 vector107
   296: c01189e0     4 OBJECT  GLOBAL DEFAULT    5 boot_pgdir
   297: c0101fcc     0 NOTYPE  GLOBAL DEFAULT    1 vector40
   298: c0101739     8 FUNC    GLOBAL DEFAULT    1 intr_enable
   299: c01021fa     0 NOTYPE  GLOBAL DEFAULT    1 vector102
   300: c010205c     0 NOTYPE  GLOBAL DEFAULT    1 vector56
   301: c01020c8     0 NOTYPE  GLOBAL DEFAULT    1 vector68
   302: c0101ea8     0 NOTYPE  GLOBAL DEFAULT    1 vector6
   303: c01022f0     0 NOTYPE  GLOBAL DEFAULT    1 vector129
   304: c0102620     0 NOTYPE  GLOBAL DEFAULT    1 vector197
   305: c0102404     0 NOTYPE  GLOBAL DEFAULT    1 vector152
   306: c01185e0     0 NOTYPE  GLOBAL DEFAULT    5 __vectors
   307: c01027ac     0 NOTYPE  GLOBAL DEFAULT    1 vector230
   308: c0105b28    83 FUNC    GLOBAL DEFAULT    1 strncmp
   309: c0104529     6 FUNC    GLOBAL DEFAULT    1 get_pte
   310: c0101fb1     0 NOTYPE  GLOBAL DEFAULT    1 vector37
   311: c0102680     0 NOTYPE  GLOBAL DEFAULT    1 vector205
   312: c0102470     0 NOTYPE  GLOBAL DEFAULT    1 vector161
   313: c0105aa6    57 FUNC    GLOBAL DEFAULT    1 strncpy
   314: c01020e3     0 NOTYPE  GLOBAL DEFAULT    1 vector71
   315: c0102464     0 NOTYPE  GLOBAL DEFAULT    1 vector160
   316: c01026f8     0 NOTYPE  GLOBAL DEFAULT    1 vector215
   317: c0102440     0 NOTYPE  GLOBAL DEFAULT    1 vector157
   318: c0101741     8 FUNC    GLOBAL DEFAULT    1 intr_disable
   319: c0101c47   186 FUNC    GLOBAL DEFAULT    1 print_regs
   320: c0102254     0 NOTYPE  GLOBAL DEFAULT    1 vector112
   321: c01000a2    39 FUNC    GLOBAL DEFAULT    1 grade_backtrace2
   322: c010256c     0 NOTYPE  GLOBAL DEFAULT    1 vector182
   323: c0101ed8     0 NOTYPE  GLOBAL DEFAULT    1 vector12
   324: c0105e6b    88 FUNC    GLOBAL DEFAULT    1 memcmp
   325: c0102239     0 NOTYPE  GLOBAL DEFAULT    1 vector109
   326: c0101f18     0 NOTYPE  GLOBAL DEFAULT    1 vector20
   327: c0102041     0 NOTYPE  GLOBAL DEFAULT    1 vector53
   328: c0101f06     0 NOTYPE  GLOBAL DEFAULT    1 vector18
   329: c01021bb     0 NOTYPE  GLOBAL DEFAULT    1 vector95
   330: c010277c     0 NOTYPE  GLOBAL DEFAULT    1 vector226
   331: c010201d     0 NOTYPE  GLOBAL DEFAULT    1 vector49
   332: c0101ff0     0 NOTYPE  GLOBAL DEFAULT    1 vector44
   333: c0102122     0 NOTYPE  GLOBAL DEFAULT    1 vector78
   334: c0102500     0 NOTYPE  GLOBAL DEFAULT    1 vector173
   335: c0102281     0 NOTYPE  GLOBAL DEFAULT    1 vector117
   336: c0101a7f    21 FUNC    GLOBAL DEFAULT    1 trap_in_kernel
   337: c0102146     0 NOTYPE  GLOBAL DEFAULT    1 vector82
   338: c010274c     0 NOTYPE  GLOBAL DEFAULT    1 vector222
   339: c0101eba     0 NOTYPE  GLOBAL DEFAULT    1 vector8
   340: c01023e0     0 NOTYPE  GLOBAL DEFAULT    1 vector149
   341: c010037e    22 FUNC    GLOBAL DEFAULT    1 cputchar
   342: c0105d37    66 FUNC    GLOBAL DEFAULT    1 memset
   343: c01027c4     0 NOTYPE  GLOBAL DEFAULT    1 vector232
   344: c010221e     0 NOTYPE  GLOBAL DEFAULT    1 vector106
   345: c0102734     0 NOTYPE  GLOBAL DEFAULT    1 vector220
   346: c010218e     0 NOTYPE  GLOBAL DEFAULT    1 vector90
   347: c0102488     0 NOTYPE  GLOBAL DEFAULT    1 vector163
   348: c01027dc     0 NOTYPE  GLOBAL DEFAULT    1 vector234
   349: c0102092     0 NOTYPE  GLOBAL DEFAULT    1 vector62
   350: c0101f45     0 NOTYPE  GLOBAL DEFAULT    1 vector25
   351: c010262c     0 NOTYPE  GLOBAL DEFAULT    1 vector198
   352: c010229c     0 NOTYPE  GLOBAL DEFAULT    1 vector120
   353: c01003e5    28 FUNC    GLOBAL DEFAULT    1 getchar
   354: c0104590    71 FUNC    GLOBAL DEFAULT    1 page_remove
   355: c0102026     0 NOTYPE  GLOBAL DEFAULT    1 vector50
   356: c0101eed     0 NOTYPE  GLOBAL DEFAULT    1 vector15
   357: c0105531    49 FUNC    GLOBAL DEFAULT    1 printfmt
   358: c01023f8     0 NOTYPE  GLOBAL DEFAULT    1 vector151
   359: c010214f     0 NOTYPE  GLOBAL DEFAULT    1 vector83
   360: c0102185     0 NOTYPE  GLOBAL DEFAULT    1 vector89
   361: c010217c     0 NOTYPE  GLOBAL DEFAULT    1 vector88
   362: c0101e3a    22 FUNC    GLOBAL DEFAULT    1 trap
   363: c0102548     0 NOTYPE  GLOBAL DEFAULT    1 vector179
   364: c0101f96     0 NOTYPE  GLOBAL DEFAULT    1 vector34
   365: c0115c8c     0 NOTYPE  GLOBAL DEFAULT    4 __STABSTR_END__
   366: c0102002     0 NOTYPE  GLOBAL DEFAULT    1 vector46
   367: c0105adf    73 FUNC    GLOBAL DEFAULT    1 strcmp
   368: c010232c     0 NOTYPE  GLOBAL DEFAULT    1 vector134
   369: c0102758     0 NOTYPE  GLOBAL DEFAULT    1 vector223
   370: c010271c     0 NOTYPE  GLOBAL DEFAULT    1 vector218
   371: c0100551   808 FUNC    GLOBAL DEFAULT    1 debuginfo_eip
   372: c01017db   330 FUNC    GLOBAL DEFAULT    1 pic_init
   373: c0102770     0 NOTYPE  GLOBAL DEFAULT    1 vector225
   374: c01025a8     0 NOTYPE  GLOBAL DEFAULT    1 vector187
   375: c0104441   232 FUNC    GLOBAL DEFAULT    1 pmm_init
   376: c0101f72     0 NOTYPE  GLOBAL DEFAULT    1 vector30
   377: c01022db     0 NOTYPE  GLOBAL DEFAULT    1 vector127
   378: c011b424     4 OBJECT  GLOBAL DEFAULT    7 ticks
   379: c01025e4     0 NOTYPE  GLOBAL DEFAULT    1 vector192
   380: c01024ac     0 NOTYPE  GLOBAL DEFAULT    1 vector166
   381: c0102110     0 NOTYPE  GLOBAL DEFAULT    1 vector76
   382: c0102107     0 NOTYPE  GLOBAL DEFAULT    1 vector75
   383: c0102608     0 NOTYPE  GLOBAL DEFAULT    1 vector195
   384: c01023ec     0 NOTYPE  GLOBAL DEFAULT    1 vector150
   385: c010206e     0 NOTYPE  GLOBAL DEFAULT    1 vector58
   386: c0102884     0 NOTYPE  GLOBAL DEFAULT    1 vector248
   387: c01022b7     0 NOTYPE  GLOBAL DEFAULT    1 vector123
   388: c01021c4     0 NOTYPE  GLOBAL DEFAULT    1 vector96
   389: c0101f7b     0 NOTYPE  GLOBAL DEFAULT    1 vector31
   390: c0102668     0 NOTYPE  GLOBAL DEFAULT    1 vector203
   391: c0103e02    58 FUNC    GLOBAL DEFAULT    1 alloc_pages
   392: c0102368     0 NOTYPE  GLOBAL DEFAULT    1 vector139
   393: c0102410     0 NOTYPE  GLOBAL DEFAULT    1 vector153
   394: c0102494     0 NOTYPE  GLOBAL DEFAULT    1 vector164
   395: c01022a5     0 NOTYPE  GLOBAL DEFAULT    1 vector121
   396: c0101e9f     0 NOTYPE  GLOBAL DEFAULT    1 vector5
   397: c01024b8     0 NOTYPE  GLOBAL DEFAULT    1 vector167
   398: c0102428     0 NOTYPE  GLOBAL DEFAULT    1 vector155
   399: c0102890     0 NOTYPE  GLOBAL DEFAULT    1 vector249
   400: c0106a4c     4 OBJECT  GLOBAL DEFAULT    2 vpt
   401: c010289c     0 NOTYPE  GLOBAL DEFAULT    1 vector250
   402: c01022c0     0 NOTYPE  GLOBAL DEFAULT    1 vector124
   403: c0102242     0 NOTYPE  GLOBAL DEFAULT    1 vector110
   404: c0102674     0 NOTYPE  GLOBAL DEFAULT    1 vector204
   405: c0101e67     0 NOTYPE  GLOBAL DEFAULT    1 __trapret
   406: c0100321    53 FUNC    GLOBAL DEFAULT    1 vcprintf
   407: c0102350     0 NOTYPE  GLOBAL DEFAULT    1 vector137
   408: c0100d66    73 FUNC    GLOBAL DEFAULT    1 __warn
   409: c0102878     0 NOTYPE  GLOBAL DEFAULT    1 vector247
   410: c0101f2a     0 NOTYPE  GLOBAL DEFAULT    1 vector22
   411: c010265c     0 NOTYPE  GLOBAL DEFAULT    1 vector202
   412: c01020ec     0 NOTYPE  GLOBAL DEFAULT    1 vector72
   413: c0102053     0 NOTYPE  GLOBAL DEFAULT    1 vector55
   414: c0100394    81 FUNC    GLOBAL DEFAULT    1 cputs
   415: c0118000     0 NOTYPE  GLOBAL DEFAULT    5 bootstacktop
   416: c01022d2     0 NOTYPE  GLOBAL DEFAULT    1 vector126
   417: c01020ad     0 NOTYPE  GLOBAL DEFAULT    1 vector65
   418: c0101f60     0 NOTYPE  GLOBAL DEFAULT    1 vector28
   419: c01024d0     0 NOTYPE  GLOBAL DEFAULT    1 vector169
   420: c01027d0     0 NOTYPE  GLOBAL DEFAULT    1 vector233
   421: c01023c8     0 NOTYPE  GLOBAL DEFAULT    1 vector147
   422: c0116000     0 NOTYPE  GLOBAL DEFAULT    5 bootstack
   423: c0119000     0 NOTYPE  GLOBAL DEFAULT    6 __boot_pgdir
   424: c010220c     0 NOTYPE  GLOBAL DEFAULT    1 vector104
   425: c011be80    12 OBJECT  GLOBAL DEFAULT    7 free_area
   426: c0102278     0 NOTYPE  GLOBAL DEFAULT    1 vector116
   427: c0107250     0 NOTYPE  GLOBAL DEFAULT    3 __STAB_BEGIN__
   428: c0102038     0 NOTYPE  GLOBAL DEFAULT    1 vector52
   429: c0101eff     0 NOTYPE  GLOBAL DEFAULT    1 vector17
   430: c0102584     0 NOTYPE  GLOBAL DEFAULT    1 vector184
   431: c0105a0d    41 FUNC    GLOBAL DEFAULT    1 strlen
   432: c0102698     0 NOTYPE  GLOBAL DEFAULT    1 vector207
   433: c01025cc     0 NOTYPE  GLOBAL DEFAULT    1 vector190
   434: c0102818     0 NOTYPE  GLOBAL DEFAULT    1 vector239
   435: c01021b2     0 NOTYPE  GLOBAL DEFAULT    1 vector94
   436: c01021a9     0 NOTYPE  GLOBAL DEFAULT    1 vector93
   437: c01025b4     0 NOTYPE  GLOBAL DEFAULT    1 vector188
   438: c0105b7b    52 FUNC    GLOBAL DEFAULT    1 strchr
   439: c0102014     0 NOTYPE  GLOBAL DEFAULT    1 vector48
   440: c01000c9    49 FUNC    GLOBAL DEFAULT    1 grade_backtrace1
   441: c0102728     0 NOTYPE  GLOBAL DEFAULT    1 vector219
   442: c01023d4     0 NOTYPE  GLOBAL DEFAULT    1 vector148
   443: c0102740     0 NOTYPE  GLOBAL DEFAULT    1 vector221
   444: c0102134     0 NOTYPE  GLOBAL DEFAULT    1 vector80
   445: c01024e8     0 NOTYPE  GLOBAL DEFAULT    1 vector171
   446: c010241c     0 NOTYPE  GLOBAL DEFAULT    1 vector154
   447: c0101fa8     0 NOTYPE  GLOBAL DEFAULT    1 vector36
   448: c01027e8     0 NOTYPE  GLOBAL DEFAULT    1 vector235
   449: c0102215     0 NOTYPE  GLOBAL DEFAULT    1 vector105
   450: c0100cc0    20 FUNC    GLOBAL DEFAULT    1 mon_kerninfo
   451: c011bea0     4 OBJECT  GLOBAL DEFAULT    7 pages
   452: c01023bc     0 NOTYPE  GLOBAL DEFAULT    1 vector146
   453: c01025d8     0 NOTYPE  GLOBAL DEFAULT    1 vector191
   454: c0102203     0 NOTYPE  GLOBAL DEFAULT    1 vector103
   455: c0100c63    93 FUNC    GLOBAL DEFAULT    1 mon_help
   456: c0101ed1     0 NOTYPE  GLOBAL DEFAULT    1 vector11
   457: c0104692    95 FUNC    GLOBAL DEFAULT    1 tlb_invalidate
   458: c0101ee6     0 NOTYPE  GLOBAL DEFAULT    1 vector14

No version information found in this file.
