
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	83 ec 04             	sub    $0x4,%esp
c0100049:	50                   	push   %eax
c010004a:	6a 00                	push   $0x0
c010004c:	68 00 b0 11 c0       	push   $0xc011b000
c0100051:	e8 95 58 00 00       	call   c01058eb <memset>
c0100056:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100059:	e8 83 15 00 00       	call   c01015e1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005e:	c7 45 f4 80 5a 10 c0 	movl   $0xc0105a80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100065:	83 ec 08             	sub    $0x8,%esp
c0100068:	ff 75 f4             	push   -0xc(%ebp)
c010006b:	68 9c 5a 10 c0       	push   $0xc0105a9c
c0100070:	e8 bc 02 00 00       	call   c0100331 <cprintf>
c0100075:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100078:	e8 b2 07 00 00       	call   c010082f <print_kerninfo>

    grade_backtrace();
c010007d:	e8 74 00 00 00       	call   c01000f6 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100082:	e8 87 40 00 00       	call   c010410e <pmm_init>

    pic_init();                 // init interrupt controller
c0100087:	e8 d9 16 00 00       	call   c0101765 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008c:	e8 3a 18 00 00       	call   c01018cb <idt_init>

    clock_init();               // init clock interrupt
c0100091:	e8 ce 0c 00 00       	call   c0100d64 <clock_init>
    intr_enable();              // enable irq interrupt
c0100096:	e8 32 16 00 00       	call   c01016cd <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009b:	eb fe                	jmp    c010009b <kern_init+0x65>

c010009d <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009d:	55                   	push   %ebp
c010009e:	89 e5                	mov    %esp,%ebp
c01000a0:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a3:	83 ec 04             	sub    $0x4,%esp
c01000a6:	6a 00                	push   $0x0
c01000a8:	6a 00                	push   $0x0
c01000aa:	6a 00                	push   $0x0
c01000ac:	e8 cd 0b 00 00       	call   c0100c7e <mon_backtrace>
c01000b1:	83 c4 10             	add    $0x10,%esp
}
c01000b4:	90                   	nop
c01000b5:	c9                   	leave  
c01000b6:	c3                   	ret    

c01000b7 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000b7:	55                   	push   %ebp
c01000b8:	89 e5                	mov    %esp,%ebp
c01000ba:	53                   	push   %ebx
c01000bb:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000be:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c4:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ca:	51                   	push   %ecx
c01000cb:	52                   	push   %edx
c01000cc:	53                   	push   %ebx
c01000cd:	50                   	push   %eax
c01000ce:	e8 ca ff ff ff       	call   c010009d <grade_backtrace2>
c01000d3:	83 c4 10             	add    $0x10,%esp
}
c01000d6:	90                   	nop
c01000d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000da:	c9                   	leave  
c01000db:	c3                   	ret    

c01000dc <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000dc:	55                   	push   %ebp
c01000dd:	89 e5                	mov    %esp,%ebp
c01000df:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000e2:	83 ec 08             	sub    $0x8,%esp
c01000e5:	ff 75 10             	push   0x10(%ebp)
c01000e8:	ff 75 08             	push   0x8(%ebp)
c01000eb:	e8 c7 ff ff ff       	call   c01000b7 <grade_backtrace1>
c01000f0:	83 c4 10             	add    $0x10,%esp
}
c01000f3:	90                   	nop
c01000f4:	c9                   	leave  
c01000f5:	c3                   	ret    

c01000f6 <grade_backtrace>:

void
grade_backtrace(void) {
c01000f6:	55                   	push   %ebp
c01000f7:	89 e5                	mov    %esp,%ebp
c01000f9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000fc:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100101:	83 ec 04             	sub    $0x4,%esp
c0100104:	68 00 00 ff ff       	push   $0xffff0000
c0100109:	50                   	push   %eax
c010010a:	6a 00                	push   $0x0
c010010c:	e8 cb ff ff ff       	call   c01000dc <grade_backtrace0>
c0100111:	83 c4 10             	add    $0x10,%esp
}
c0100114:	90                   	nop
c0100115:	c9                   	leave  
c0100116:	c3                   	ret    

c0100117 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010011d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100120:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100123:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100126:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100129:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010012d:	0f b7 c0             	movzwl %ax,%eax
c0100130:	83 e0 03             	and    $0x3,%eax
c0100133:	89 c2                	mov    %eax,%edx
c0100135:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010013a:	83 ec 04             	sub    $0x4,%esp
c010013d:	52                   	push   %edx
c010013e:	50                   	push   %eax
c010013f:	68 a1 5a 10 c0       	push   $0xc0105aa1
c0100144:	e8 e8 01 00 00       	call   c0100331 <cprintf>
c0100149:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100150:	0f b7 d0             	movzwl %ax,%edx
c0100153:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100158:	83 ec 04             	sub    $0x4,%esp
c010015b:	52                   	push   %edx
c010015c:	50                   	push   %eax
c010015d:	68 af 5a 10 c0       	push   $0xc0105aaf
c0100162:	e8 ca 01 00 00       	call   c0100331 <cprintf>
c0100167:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010016a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010016e:	0f b7 d0             	movzwl %ax,%edx
c0100171:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100176:	83 ec 04             	sub    $0x4,%esp
c0100179:	52                   	push   %edx
c010017a:	50                   	push   %eax
c010017b:	68 bd 5a 10 c0       	push   $0xc0105abd
c0100180:	e8 ac 01 00 00       	call   c0100331 <cprintf>
c0100185:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100188:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010018c:	0f b7 d0             	movzwl %ax,%edx
c010018f:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100194:	83 ec 04             	sub    $0x4,%esp
c0100197:	52                   	push   %edx
c0100198:	50                   	push   %eax
c0100199:	68 cb 5a 10 c0       	push   $0xc0105acb
c010019e:	e8 8e 01 00 00       	call   c0100331 <cprintf>
c01001a3:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001aa:	0f b7 d0             	movzwl %ax,%edx
c01001ad:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001b2:	83 ec 04             	sub    $0x4,%esp
c01001b5:	52                   	push   %edx
c01001b6:	50                   	push   %eax
c01001b7:	68 d9 5a 10 c0       	push   $0xc0105ad9
c01001bc:	e8 70 01 00 00       	call   c0100331 <cprintf>
c01001c1:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c4:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001c9:	83 c0 01             	add    $0x1,%eax
c01001cc:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001d1:	90                   	nop
c01001d2:	c9                   	leave  
c01001d3:	c3                   	ret    

c01001d4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d4:	55                   	push   %ebp
c01001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001d7:	90                   	nop
c01001d8:	5d                   	pop    %ebp
c01001d9:	c3                   	ret    

c01001da <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001da:	55                   	push   %ebp
c01001db:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001dd:	90                   	nop
c01001de:	5d                   	pop    %ebp
c01001df:	c3                   	ret    

c01001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e0:	55                   	push   %ebp
c01001e1:	89 e5                	mov    %esp,%ebp
c01001e3:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001e6:	e8 2c ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001eb:	83 ec 0c             	sub    $0xc,%esp
c01001ee:	68 e8 5a 10 c0       	push   $0xc0105ae8
c01001f3:	e8 39 01 00 00       	call   c0100331 <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001fb:	e8 d4 ff ff ff       	call   c01001d4 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100200:	e8 12 ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100205:	83 ec 0c             	sub    $0xc,%esp
c0100208:	68 08 5b 10 c0       	push   $0xc0105b08
c010020d:	e8 1f 01 00 00       	call   c0100331 <cprintf>
c0100212:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100215:	e8 c0 ff ff ff       	call   c01001da <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010021a:	e8 f8 fe ff ff       	call   c0100117 <lab1_print_cur_status>
}
c010021f:	90                   	nop
c0100220:	c9                   	leave  
c0100221:	c3                   	ret    

c0100222 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100222:	55                   	push   %ebp
c0100223:	89 e5                	mov    %esp,%ebp
c0100225:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100228:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010022c:	74 13                	je     c0100241 <readline+0x1f>
        cprintf("%s", prompt);
c010022e:	83 ec 08             	sub    $0x8,%esp
c0100231:	ff 75 08             	push   0x8(%ebp)
c0100234:	68 27 5b 10 c0       	push   $0xc0105b27
c0100239:	e8 f3 00 00 00       	call   c0100331 <cprintf>
c010023e:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100248:	e8 6f 01 00 00       	call   c01003bc <getchar>
c010024d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100254:	79 0a                	jns    c0100260 <readline+0x3e>
            return NULL;
c0100256:	b8 00 00 00 00       	mov    $0x0,%eax
c010025b:	e9 82 00 00 00       	jmp    c01002e2 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100260:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100264:	7e 2b                	jle    c0100291 <readline+0x6f>
c0100266:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010026d:	7f 22                	jg     c0100291 <readline+0x6f>
            cputchar(c);
c010026f:	83 ec 0c             	sub    $0xc,%esp
c0100272:	ff 75 f0             	push   -0x10(%ebp)
c0100275:	e8 dd 00 00 00       	call   c0100357 <cputchar>
c010027a:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100280:	8d 50 01             	lea    0x1(%eax),%edx
c0100283:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100286:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100289:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c010028f:	eb 4c                	jmp    c01002dd <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c0100291:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100295:	75 1a                	jne    c01002b1 <readline+0x8f>
c0100297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010029b:	7e 14                	jle    c01002b1 <readline+0x8f>
            cputchar(c);
c010029d:	83 ec 0c             	sub    $0xc,%esp
c01002a0:	ff 75 f0             	push   -0x10(%ebp)
c01002a3:	e8 af 00 00 00       	call   c0100357 <cputchar>
c01002a8:	83 c4 10             	add    $0x10,%esp
            i --;
c01002ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002af:	eb 2c                	jmp    c01002dd <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01002b1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002b5:	74 06                	je     c01002bd <readline+0x9b>
c01002b7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002bb:	75 8b                	jne    c0100248 <readline+0x26>
            cputchar(c);
c01002bd:	83 ec 0c             	sub    $0xc,%esp
c01002c0:	ff 75 f0             	push   -0x10(%ebp)
c01002c3:	e8 8f 00 00 00       	call   c0100357 <cputchar>
c01002c8:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01002cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ce:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002d3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002d6:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002db:	eb 05                	jmp    c01002e2 <readline+0xc0>
        c = getchar();
c01002dd:	e9 66 ff ff ff       	jmp    c0100248 <readline+0x26>
        }
    }
}
c01002e2:	c9                   	leave  
c01002e3:	c3                   	ret    

c01002e4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e4:	55                   	push   %ebp
c01002e5:	89 e5                	mov    %esp,%ebp
c01002e7:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002ea:	83 ec 0c             	sub    $0xc,%esp
c01002ed:	ff 75 08             	push   0x8(%ebp)
c01002f0:	e8 1d 13 00 00       	call   c0101612 <cons_putc>
c01002f5:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c01002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fb:	8b 00                	mov    (%eax),%eax
c01002fd:	8d 50 01             	lea    0x1(%eax),%edx
c0100300:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100303:	89 10                	mov    %edx,(%eax)
}
c0100305:	90                   	nop
c0100306:	c9                   	leave  
c0100307:	c3                   	ret    

c0100308 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100308:	55                   	push   %ebp
c0100309:	89 e5                	mov    %esp,%ebp
c010030b:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010030e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100315:	ff 75 0c             	push   0xc(%ebp)
c0100318:	ff 75 08             	push   0x8(%ebp)
c010031b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010031e:	50                   	push   %eax
c010031f:	68 e4 02 10 c0       	push   $0xc01002e4
c0100324:	e8 32 4e 00 00       	call   c010515b <vprintfmt>
c0100329:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032f:	c9                   	leave  
c0100330:	c3                   	ret    

c0100331 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100331:	55                   	push   %ebp
c0100332:	89 e5                	mov    %esp,%ebp
c0100334:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100337:	8d 45 0c             	lea    0xc(%ebp),%eax
c010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010033d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100340:	83 ec 08             	sub    $0x8,%esp
c0100343:	50                   	push   %eax
c0100344:	ff 75 08             	push   0x8(%ebp)
c0100347:	e8 bc ff ff ff       	call   c0100308 <vcprintf>
c010034c:	83 c4 10             	add    $0x10,%esp
c010034f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100355:	c9                   	leave  
c0100356:	c3                   	ret    

c0100357 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100357:	55                   	push   %ebp
c0100358:	89 e5                	mov    %esp,%ebp
c010035a:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010035d:	83 ec 0c             	sub    $0xc,%esp
c0100360:	ff 75 08             	push   0x8(%ebp)
c0100363:	e8 aa 12 00 00       	call   c0101612 <cons_putc>
c0100368:	83 c4 10             	add    $0x10,%esp
}
c010036b:	90                   	nop
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010037b:	eb 14                	jmp    c0100391 <cputs+0x23>
        cputch(c, &cnt);
c010037d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100381:	83 ec 08             	sub    $0x8,%esp
c0100384:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100387:	52                   	push   %edx
c0100388:	50                   	push   %eax
c0100389:	e8 56 ff ff ff       	call   c01002e4 <cputch>
c010038e:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c0100391:	8b 45 08             	mov    0x8(%ebp),%eax
c0100394:	8d 50 01             	lea    0x1(%eax),%edx
c0100397:	89 55 08             	mov    %edx,0x8(%ebp)
c010039a:	0f b6 00             	movzbl (%eax),%eax
c010039d:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003a4:	75 d7                	jne    c010037d <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003a6:	83 ec 08             	sub    $0x8,%esp
c01003a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ac:	50                   	push   %eax
c01003ad:	6a 0a                	push   $0xa
c01003af:	e8 30 ff ff ff       	call   c01002e4 <cputch>
c01003b4:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ba:	c9                   	leave  
c01003bb:	c3                   	ret    

c01003bc <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003bc:	55                   	push   %ebp
c01003bd:	89 e5                	mov    %esp,%ebp
c01003bf:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003c2:	90                   	nop
c01003c3:	e8 93 12 00 00       	call   c010165b <cons_getc>
c01003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003cf:	74 f2                	je     c01003c3 <getchar+0x7>
        /* do nothing */;
    return c;
c01003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003d4:	c9                   	leave  
c01003d5:	c3                   	ret    

c01003d6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003d6:	55                   	push   %ebp
c01003d7:	89 e5                	mov    %esp,%ebp
c01003d9:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003df:	8b 00                	mov    (%eax),%eax
c01003e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01003e7:	8b 00                	mov    (%eax),%eax
c01003e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003f3:	e9 d2 00 00 00       	jmp    c01004ca <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01003fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01003fe:	01 d0                	add    %edx,%eax
c0100400:	89 c2                	mov    %eax,%edx
c0100402:	c1 ea 1f             	shr    $0x1f,%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	d1 f8                	sar    %eax
c0100409:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010040c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010040f:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100412:	eb 04                	jmp    c0100418 <stab_binsearch+0x42>
            m --;
c0100414:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100418:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010041b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010041e:	7c 1f                	jl     c010043f <stab_binsearch+0x69>
c0100420:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100423:	89 d0                	mov    %edx,%eax
c0100425:	01 c0                	add    %eax,%eax
c0100427:	01 d0                	add    %edx,%eax
c0100429:	c1 e0 02             	shl    $0x2,%eax
c010042c:	89 c2                	mov    %eax,%edx
c010042e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100431:	01 d0                	add    %edx,%eax
c0100433:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100437:	0f b6 c0             	movzbl %al,%eax
c010043a:	39 45 14             	cmp    %eax,0x14(%ebp)
c010043d:	75 d5                	jne    c0100414 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010043f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100442:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100445:	7d 0b                	jge    c0100452 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010044a:	83 c0 01             	add    $0x1,%eax
c010044d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100450:	eb 78                	jmp    c01004ca <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100452:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010045c:	89 d0                	mov    %edx,%eax
c010045e:	01 c0                	add    %eax,%eax
c0100460:	01 d0                	add    %edx,%eax
c0100462:	c1 e0 02             	shl    $0x2,%eax
c0100465:	89 c2                	mov    %eax,%edx
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	01 d0                	add    %edx,%eax
c010046c:	8b 40 08             	mov    0x8(%eax),%eax
c010046f:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100472:	76 13                	jbe    c0100487 <stab_binsearch+0xb1>
            *region_left = m;
c0100474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010047f:	83 c0 01             	add    $0x1,%eax
c0100482:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100485:	eb 43                	jmp    c01004ca <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048a:	89 d0                	mov    %edx,%eax
c010048c:	01 c0                	add    %eax,%eax
c010048e:	01 d0                	add    %edx,%eax
c0100490:	c1 e0 02             	shl    $0x2,%eax
c0100493:	89 c2                	mov    %eax,%edx
c0100495:	8b 45 08             	mov    0x8(%ebp),%eax
c0100498:	01 d0                	add    %edx,%eax
c010049a:	8b 40 08             	mov    0x8(%eax),%eax
c010049d:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a0:	73 16                	jae    c01004b8 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ab:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b0:	83 e8 01             	sub    $0x1,%eax
c01004b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b6:	eb 12                	jmp    c01004ca <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004be:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004c6:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01004ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d0:	0f 8e 22 ff ff ff    	jle    c01003f8 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004da:	75 0f                	jne    c01004eb <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 00                	mov    (%eax),%eax
c01004e1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e7:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01004e9:	eb 3f                	jmp    c010052a <stab_binsearch+0x154>
        l = *region_right;
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	8b 00                	mov    (%eax),%eax
c01004f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004f3:	eb 04                	jmp    c01004f9 <stab_binsearch+0x123>
c01004f5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fc:	8b 00                	mov    (%eax),%eax
c01004fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100501:	7e 1f                	jle    c0100522 <stab_binsearch+0x14c>
c0100503:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100506:	89 d0                	mov    %edx,%eax
c0100508:	01 c0                	add    %eax,%eax
c010050a:	01 d0                	add    %edx,%eax
c010050c:	c1 e0 02             	shl    $0x2,%eax
c010050f:	89 c2                	mov    %eax,%edx
c0100511:	8b 45 08             	mov    0x8(%ebp),%eax
c0100514:	01 d0                	add    %edx,%eax
c0100516:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010051a:	0f b6 c0             	movzbl %al,%eax
c010051d:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100520:	75 d3                	jne    c01004f5 <stab_binsearch+0x11f>
        *region_left = l;
c0100522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 10                	mov    %edx,(%eax)
}
c010052a:	90                   	nop
c010052b:	c9                   	leave  
c010052c:	c3                   	ret    

c010052d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010052d:	55                   	push   %ebp
c010052e:	89 e5                	mov    %esp,%ebp
c0100530:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100533:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100536:	c7 00 2c 5b 10 c0    	movl   $0xc0105b2c,(%eax)
    info->eip_line = 0;
c010053c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100549:	c7 40 08 2c 5b 10 c0 	movl   $0xc0105b2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010055a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055d:	8b 55 08             	mov    0x8(%ebp),%edx
c0100560:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010056d:	c7 45 f4 a0 6d 10 c0 	movl   $0xc0106da0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100574:	c7 45 f0 3c 25 11 c0 	movl   $0xc011253c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010057b:	c7 45 ec 3d 25 11 c0 	movl   $0xc011253d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100582:	c7 45 e8 d5 5a 11 c0 	movl   $0xc0115ad5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100589:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010058c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010058f:	76 0d                	jbe    c010059e <debuginfo_eip+0x71>
c0100591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100594:	83 e8 01             	sub    $0x1,%eax
c0100597:	0f b6 00             	movzbl (%eax),%eax
c010059a:	84 c0                	test   %al,%al
c010059c:	74 0a                	je     c01005a8 <debuginfo_eip+0x7b>
        return -1;
c010059e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a3:	e9 85 02 00 00       	jmp    c010082d <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b2:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005b5:	c1 f8 02             	sar    $0x2,%eax
c01005b8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005be:	83 e8 01             	sub    $0x1,%eax
c01005c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005c4:	ff 75 08             	push   0x8(%ebp)
c01005c7:	6a 64                	push   $0x64
c01005c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005cc:	50                   	push   %eax
c01005cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005d0:	50                   	push   %eax
c01005d1:	ff 75 f4             	push   -0xc(%ebp)
c01005d4:	e8 fd fd ff ff       	call   c01003d6 <stab_binsearch>
c01005d9:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005df:	85 c0                	test   %eax,%eax
c01005e1:	75 0a                	jne    c01005ed <debuginfo_eip+0xc0>
        return -1;
c01005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005e8:	e9 40 02 00 00       	jmp    c010082d <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01005f9:	ff 75 08             	push   0x8(%ebp)
c01005fc:	6a 24                	push   $0x24
c01005fe:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100601:	50                   	push   %eax
c0100602:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100605:	50                   	push   %eax
c0100606:	ff 75 f4             	push   -0xc(%ebp)
c0100609:	e8 c8 fd ff ff       	call   c01003d6 <stab_binsearch>
c010060e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100617:	39 c2                	cmp    %eax,%edx
c0100619:	7f 78                	jg     c0100693 <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010061e:	89 c2                	mov    %eax,%edx
c0100620:	89 d0                	mov    %edx,%eax
c0100622:	01 c0                	add    %eax,%eax
c0100624:	01 d0                	add    %edx,%eax
c0100626:	c1 e0 02             	shl    $0x2,%eax
c0100629:	89 c2                	mov    %eax,%edx
c010062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010062e:	01 d0                	add    %edx,%eax
c0100630:	8b 10                	mov    (%eax),%edx
c0100632:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100635:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100638:	39 c2                	cmp    %eax,%edx
c010063a:	73 22                	jae    c010065e <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010063c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010063f:	89 c2                	mov    %eax,%edx
c0100641:	89 d0                	mov    %edx,%eax
c0100643:	01 c0                	add    %eax,%eax
c0100645:	01 d0                	add    %edx,%eax
c0100647:	c1 e0 02             	shl    $0x2,%eax
c010064a:	89 c2                	mov    %eax,%edx
c010064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064f:	01 d0                	add    %edx,%eax
c0100651:	8b 10                	mov    (%eax),%edx
c0100653:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100656:	01 c2                	add    %eax,%edx
c0100658:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010065e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100661:	89 c2                	mov    %eax,%edx
c0100663:	89 d0                	mov    %edx,%eax
c0100665:	01 c0                	add    %eax,%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	c1 e0 02             	shl    $0x2,%eax
c010066c:	89 c2                	mov    %eax,%edx
c010066e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100671:	01 d0                	add    %edx,%eax
c0100673:	8b 50 08             	mov    0x8(%eax),%edx
c0100676:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100679:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010067c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067f:	8b 40 10             	mov    0x10(%eax),%eax
c0100682:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100685:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100688:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010068b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010068e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100691:	eb 15                	jmp    c01006a8 <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100696:	8b 55 08             	mov    0x8(%ebp),%edx
c0100699:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010069c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010069f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ab:	8b 40 08             	mov    0x8(%eax),%eax
c01006ae:	83 ec 08             	sub    $0x8,%esp
c01006b1:	6a 3a                	push   $0x3a
c01006b3:	50                   	push   %eax
c01006b4:	e8 a6 50 00 00       	call   c010575f <strfind>
c01006b9:	83 c4 10             	add    $0x10,%esp
c01006bc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01006bf:	8b 4a 08             	mov    0x8(%edx),%ecx
c01006c2:	29 c8                	sub    %ecx,%eax
c01006c4:	89 c2                	mov    %eax,%edx
c01006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006cc:	83 ec 0c             	sub    $0xc,%esp
c01006cf:	ff 75 08             	push   0x8(%ebp)
c01006d2:	6a 44                	push   $0x44
c01006d4:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01006d7:	50                   	push   %eax
c01006d8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01006db:	50                   	push   %eax
c01006dc:	ff 75 f4             	push   -0xc(%ebp)
c01006df:	e8 f2 fc ff ff       	call   c01003d6 <stab_binsearch>
c01006e4:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01006e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01006ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01006ed:	39 c2                	cmp    %eax,%edx
c01006ef:	7f 24                	jg     c0100715 <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
c01006f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01006f4:	89 c2                	mov    %eax,%edx
c01006f6:	89 d0                	mov    %edx,%eax
c01006f8:	01 c0                	add    %eax,%eax
c01006fa:	01 d0                	add    %edx,%eax
c01006fc:	c1 e0 02             	shl    $0x2,%eax
c01006ff:	89 c2                	mov    %eax,%edx
c0100701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100704:	01 d0                	add    %edx,%eax
c0100706:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010070a:	0f b7 d0             	movzwl %ax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100713:	eb 13                	jmp    c0100728 <debuginfo_eip+0x1fb>
        return -1;
c0100715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010071a:	e9 0e 01 00 00       	jmp    c010082d <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100722:	83 e8 01             	sub    $0x1,%eax
c0100725:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100728:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010072b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010072e:	39 c2                	cmp    %eax,%edx
c0100730:	7c 56                	jl     c0100788 <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
c0100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100735:	89 c2                	mov    %eax,%edx
c0100737:	89 d0                	mov    %edx,%eax
c0100739:	01 c0                	add    %eax,%eax
c010073b:	01 d0                	add    %edx,%eax
c010073d:	c1 e0 02             	shl    $0x2,%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100745:	01 d0                	add    %edx,%eax
c0100747:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010074b:	3c 84                	cmp    $0x84,%al
c010074d:	74 39                	je     c0100788 <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010074f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100752:	89 c2                	mov    %eax,%edx
c0100754:	89 d0                	mov    %edx,%eax
c0100756:	01 c0                	add    %eax,%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	c1 e0 02             	shl    $0x2,%eax
c010075d:	89 c2                	mov    %eax,%edx
c010075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100762:	01 d0                	add    %edx,%eax
c0100764:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100768:	3c 64                	cmp    $0x64,%al
c010076a:	75 b3                	jne    c010071f <debuginfo_eip+0x1f2>
c010076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	89 d0                	mov    %edx,%eax
c0100773:	01 c0                	add    %eax,%eax
c0100775:	01 d0                	add    %edx,%eax
c0100777:	c1 e0 02             	shl    $0x2,%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	8b 40 08             	mov    0x8(%eax),%eax
c0100784:	85 c0                	test   %eax,%eax
c0100786:	74 97                	je     c010071f <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010078e:	39 c2                	cmp    %eax,%edx
c0100790:	7c 42                	jl     c01007d4 <debuginfo_eip+0x2a7>
c0100792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100795:	89 c2                	mov    %eax,%edx
c0100797:	89 d0                	mov    %edx,%eax
c0100799:	01 c0                	add    %eax,%eax
c010079b:	01 d0                	add    %edx,%eax
c010079d:	c1 e0 02             	shl    $0x2,%eax
c01007a0:	89 c2                	mov    %eax,%edx
c01007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a5:	01 d0                	add    %edx,%eax
c01007a7:	8b 10                	mov    (%eax),%edx
c01007a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007af:	39 c2                	cmp    %eax,%edx
c01007b1:	73 21                	jae    c01007d4 <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b6:	89 c2                	mov    %eax,%edx
c01007b8:	89 d0                	mov    %edx,%eax
c01007ba:	01 c0                	add    %eax,%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	c1 e0 02             	shl    $0x2,%eax
c01007c1:	89 c2                	mov    %eax,%edx
c01007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c6:	01 d0                	add    %edx,%eax
c01007c8:	8b 10                	mov    (%eax),%edx
c01007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007cd:	01 c2                	add    %eax,%edx
c01007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d2:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7d 4a                	jge    c0100828 <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
c01007de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007e1:	83 c0 01             	add    $0x1,%eax
c01007e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01007e7:	eb 18                	jmp    c0100801 <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ec:	8b 40 14             	mov    0x14(%eax),%eax
c01007ef:	8d 50 01             	lea    0x1(%eax),%edx
c01007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f5:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01007f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007fb:	83 c0 01             	add    $0x1,%eax
c01007fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100801:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100804:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	7d 1d                	jge    c0100828 <debuginfo_eip+0x2fb>
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100824:	3c a0                	cmp    $0xa0,%al
c0100826:	74 c1                	je     c01007e9 <debuginfo_eip+0x2bc>
        }
    }
    return 0;
c0100828:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010082d:	c9                   	leave  
c010082e:	c3                   	ret    

c010082f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010082f:	55                   	push   %ebp
c0100830:	89 e5                	mov    %esp,%ebp
c0100832:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100835:	83 ec 0c             	sub    $0xc,%esp
c0100838:	68 36 5b 10 c0       	push   $0xc0105b36
c010083d:	e8 ef fa ff ff       	call   c0100331 <cprintf>
c0100842:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100845:	83 ec 08             	sub    $0x8,%esp
c0100848:	68 36 00 10 c0       	push   $0xc0100036
c010084d:	68 4f 5b 10 c0       	push   $0xc0105b4f
c0100852:	e8 da fa ff ff       	call   c0100331 <cprintf>
c0100857:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010085a:	83 ec 08             	sub    $0x8,%esp
c010085d:	68 73 5a 10 c0       	push   $0xc0105a73
c0100862:	68 67 5b 10 c0       	push   $0xc0105b67
c0100867:	e8 c5 fa ff ff       	call   c0100331 <cprintf>
c010086c:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010086f:	83 ec 08             	sub    $0x8,%esp
c0100872:	68 00 b0 11 c0       	push   $0xc011b000
c0100877:	68 7f 5b 10 c0       	push   $0xc0105b7f
c010087c:	e8 b0 fa ff ff       	call   c0100331 <cprintf>
c0100881:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100884:	83 ec 08             	sub    $0x8,%esp
c0100887:	68 2c bf 11 c0       	push   $0xc011bf2c
c010088c:	68 97 5b 10 c0       	push   $0xc0105b97
c0100891:	e8 9b fa ff ff       	call   c0100331 <cprintf>
c0100896:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100899:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c010089e:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008a3:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008a8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ae:	85 c0                	test   %eax,%eax
c01008b0:	0f 48 c2             	cmovs  %edx,%eax
c01008b3:	c1 f8 0a             	sar    $0xa,%eax
c01008b6:	83 ec 08             	sub    $0x8,%esp
c01008b9:	50                   	push   %eax
c01008ba:	68 b0 5b 10 c0       	push   $0xc0105bb0
c01008bf:	e8 6d fa ff ff       	call   c0100331 <cprintf>
c01008c4:	83 c4 10             	add    $0x10,%esp
}
c01008c7:	90                   	nop
c01008c8:	c9                   	leave  
c01008c9:	c3                   	ret    

c01008ca <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008ca:	55                   	push   %ebp
c01008cb:	89 e5                	mov    %esp,%ebp
c01008cd:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008d3:	83 ec 08             	sub    $0x8,%esp
c01008d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008d9:	50                   	push   %eax
c01008da:	ff 75 08             	push   0x8(%ebp)
c01008dd:	e8 4b fc ff ff       	call   c010052d <debuginfo_eip>
c01008e2:	83 c4 10             	add    $0x10,%esp
c01008e5:	85 c0                	test   %eax,%eax
c01008e7:	74 15                	je     c01008fe <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01008e9:	83 ec 08             	sub    $0x8,%esp
c01008ec:	ff 75 08             	push   0x8(%ebp)
c01008ef:	68 da 5b 10 c0       	push   $0xc0105bda
c01008f4:	e8 38 fa ff ff       	call   c0100331 <cprintf>
c01008f9:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01008fc:	eb 65                	jmp    c0100963 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100905:	eb 1c                	jmp    c0100923 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010090a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010090d:	01 d0                	add    %edx,%eax
c010090f:	0f b6 00             	movzbl (%eax),%eax
c0100912:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100918:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010091b:	01 ca                	add    %ecx,%edx
c010091d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010091f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100923:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100926:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100929:	7c dc                	jl     c0100907 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010092b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100931:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100934:	01 d0                	add    %edx,%eax
c0100936:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100939:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	29 d0                	sub    %edx,%eax
c0100941:	89 c1                	mov    %eax,%ecx
c0100943:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100946:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100949:	83 ec 0c             	sub    $0xc,%esp
c010094c:	51                   	push   %ecx
c010094d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100953:	51                   	push   %ecx
c0100954:	52                   	push   %edx
c0100955:	50                   	push   %eax
c0100956:	68 f6 5b 10 c0       	push   $0xc0105bf6
c010095b:	e8 d1 f9 ff ff       	call   c0100331 <cprintf>
c0100960:	83 c4 20             	add    $0x20,%esp
}
c0100963:	90                   	nop
c0100964:	c9                   	leave  
c0100965:	c3                   	ret    

c0100966 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100966:	55                   	push   %ebp
c0100967:	89 e5                	mov    %esp,%ebp
c0100969:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c010096c:	8b 45 04             	mov    0x4(%ebp),%eax
c010096f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100972:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100975:	c9                   	leave  
c0100976:	c3                   	ret    

c0100977 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100977:	55                   	push   %ebp
c0100978:	89 e5                	mov    %esp,%ebp
c010097a:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c010097d:	89 e8                	mov    %ebp,%eax
c010097f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100982:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100985:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100988:	e8 d9 ff ff ff       	call   c0100966 <read_eip>
c010098d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100990:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100997:	e9 8d 00 00 00       	jmp    c0100a29 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c010099c:	83 ec 04             	sub    $0x4,%esp
c010099f:	ff 75 f0             	push   -0x10(%ebp)
c01009a2:	ff 75 f4             	push   -0xc(%ebp)
c01009a5:	68 08 5c 10 c0       	push   $0xc0105c08
c01009aa:	e8 82 f9 ff ff       	call   c0100331 <cprintf>
c01009af:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c01009b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009b5:	83 c0 08             	add    $0x8,%eax
c01009b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c01009bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009c2:	eb 26                	jmp    c01009ea <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
c01009c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	8b 00                	mov    (%eax),%eax
c01009d5:	83 ec 08             	sub    $0x8,%esp
c01009d8:	50                   	push   %eax
c01009d9:	68 24 5c 10 c0       	push   $0xc0105c24
c01009de:	e8 4e f9 ff ff       	call   c0100331 <cprintf>
c01009e3:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c01009e6:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c01009ea:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c01009ee:	7e d4                	jle    c01009c4 <print_stackframe+0x4d>
        }
        cprintf("\n");
c01009f0:	83 ec 0c             	sub    $0xc,%esp
c01009f3:	68 2c 5c 10 c0       	push   $0xc0105c2c
c01009f8:	e8 34 f9 ff ff       	call   c0100331 <cprintf>
c01009fd:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a03:	83 e8 01             	sub    $0x1,%eax
c0100a06:	83 ec 0c             	sub    $0xc,%esp
c0100a09:	50                   	push   %eax
c0100a0a:	e8 bb fe ff ff       	call   c01008ca <print_debuginfo>
c0100a0f:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a15:	83 c0 04             	add    $0x4,%eax
c0100a18:	8b 00                	mov    (%eax),%eax
c0100a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a20:	8b 00                	mov    (%eax),%eax
c0100a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a25:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a2d:	74 0a                	je     c0100a39 <print_stackframe+0xc2>
c0100a2f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a33:	0f 8e 63 ff ff ff    	jle    c010099c <print_stackframe+0x25>
    }
}
c0100a39:	90                   	nop
c0100a3a:	c9                   	leave  
c0100a3b:	c3                   	ret    

c0100a3c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a3c:	55                   	push   %ebp
c0100a3d:	89 e5                	mov    %esp,%ebp
c0100a3f:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a49:	eb 0c                	jmp    c0100a57 <parse+0x1b>
            *buf ++ = '\0';
c0100a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4e:	8d 50 01             	lea    0x1(%eax),%edx
c0100a51:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a54:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	84 c0                	test   %al,%al
c0100a5f:	74 1e                	je     c0100a7f <parse+0x43>
c0100a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a64:	0f b6 00             	movzbl (%eax),%eax
c0100a67:	0f be c0             	movsbl %al,%eax
c0100a6a:	83 ec 08             	sub    $0x8,%esp
c0100a6d:	50                   	push   %eax
c0100a6e:	68 b0 5c 10 c0       	push   $0xc0105cb0
c0100a73:	e8 b4 4c 00 00       	call   c010572c <strchr>
c0100a78:	83 c4 10             	add    $0x10,%esp
c0100a7b:	85 c0                	test   %eax,%eax
c0100a7d:	75 cc                	jne    c0100a4b <parse+0xf>
        }
        if (*buf == '\0') {
c0100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a82:	0f b6 00             	movzbl (%eax),%eax
c0100a85:	84 c0                	test   %al,%al
c0100a87:	74 65                	je     c0100aee <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a89:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a8d:	75 12                	jne    c0100aa1 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a8f:	83 ec 08             	sub    $0x8,%esp
c0100a92:	6a 10                	push   $0x10
c0100a94:	68 b5 5c 10 c0       	push   $0xc0105cb5
c0100a99:	e8 93 f8 ff ff       	call   c0100331 <cprintf>
c0100a9e:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aa4:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aaa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ab4:	01 c2                	add    %eax,%edx
c0100ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100abb:	eb 04                	jmp    c0100ac1 <parse+0x85>
            buf ++;
c0100abd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac4:	0f b6 00             	movzbl (%eax),%eax
c0100ac7:	84 c0                	test   %al,%al
c0100ac9:	74 8c                	je     c0100a57 <parse+0x1b>
c0100acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ace:	0f b6 00             	movzbl (%eax),%eax
c0100ad1:	0f be c0             	movsbl %al,%eax
c0100ad4:	83 ec 08             	sub    $0x8,%esp
c0100ad7:	50                   	push   %eax
c0100ad8:	68 b0 5c 10 c0       	push   $0xc0105cb0
c0100add:	e8 4a 4c 00 00       	call   c010572c <strchr>
c0100ae2:	83 c4 10             	add    $0x10,%esp
c0100ae5:	85 c0                	test   %eax,%eax
c0100ae7:	74 d4                	je     c0100abd <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ae9:	e9 69 ff ff ff       	jmp    c0100a57 <parse+0x1b>
            break;
c0100aee:	90                   	nop
        }
    }
    return argc;
c0100aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100af2:	c9                   	leave  
c0100af3:	c3                   	ret    

c0100af4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100af4:	55                   	push   %ebp
c0100af5:	89 e5                	mov    %esp,%ebp
c0100af7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100afa:	83 ec 08             	sub    $0x8,%esp
c0100afd:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b00:	50                   	push   %eax
c0100b01:	ff 75 08             	push   0x8(%ebp)
c0100b04:	e8 33 ff ff ff       	call   c0100a3c <parse>
c0100b09:	83 c4 10             	add    $0x10,%esp
c0100b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b13:	75 0a                	jne    c0100b1f <runcmd+0x2b>
        return 0;
c0100b15:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b1a:	e9 83 00 00 00       	jmp    c0100ba2 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b26:	eb 59                	jmp    c0100b81 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b28:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b2b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b2e:	89 c8                	mov    %ecx,%eax
c0100b30:	01 c0                	add    %eax,%eax
c0100b32:	01 c8                	add    %ecx,%eax
c0100b34:	c1 e0 02             	shl    $0x2,%eax
c0100b37:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b3c:	8b 00                	mov    (%eax),%eax
c0100b3e:	83 ec 08             	sub    $0x8,%esp
c0100b41:	52                   	push   %edx
c0100b42:	50                   	push   %eax
c0100b43:	e8 45 4b 00 00       	call   c010568d <strcmp>
c0100b48:	83 c4 10             	add    $0x10,%esp
c0100b4b:	85 c0                	test   %eax,%eax
c0100b4d:	75 2e                	jne    c0100b7d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b52:	89 d0                	mov    %edx,%eax
c0100b54:	01 c0                	add    %eax,%eax
c0100b56:	01 d0                	add    %edx,%eax
c0100b58:	c1 e0 02             	shl    $0x2,%eax
c0100b5b:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100b60:	8b 10                	mov    (%eax),%edx
c0100b62:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b65:	83 c0 04             	add    $0x4,%eax
c0100b68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100b6b:	83 e9 01             	sub    $0x1,%ecx
c0100b6e:	83 ec 04             	sub    $0x4,%esp
c0100b71:	ff 75 0c             	push   0xc(%ebp)
c0100b74:	50                   	push   %eax
c0100b75:	51                   	push   %ecx
c0100b76:	ff d2                	call   *%edx
c0100b78:	83 c4 10             	add    $0x10,%esp
c0100b7b:	eb 25                	jmp    c0100ba2 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b84:	83 f8 02             	cmp    $0x2,%eax
c0100b87:	76 9f                	jbe    c0100b28 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b89:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b8c:	83 ec 08             	sub    $0x8,%esp
c0100b8f:	50                   	push   %eax
c0100b90:	68 d3 5c 10 c0       	push   $0xc0105cd3
c0100b95:	e8 97 f7 ff ff       	call   c0100331 <cprintf>
c0100b9a:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ba2:	c9                   	leave  
c0100ba3:	c3                   	ret    

c0100ba4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ba4:	55                   	push   %ebp
c0100ba5:	89 e5                	mov    %esp,%ebp
c0100ba7:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100baa:	83 ec 0c             	sub    $0xc,%esp
c0100bad:	68 ec 5c 10 c0       	push   $0xc0105cec
c0100bb2:	e8 7a f7 ff ff       	call   c0100331 <cprintf>
c0100bb7:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100bba:	83 ec 0c             	sub    $0xc,%esp
c0100bbd:	68 14 5d 10 c0       	push   $0xc0105d14
c0100bc2:	e8 6a f7 ff ff       	call   c0100331 <cprintf>
c0100bc7:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bce:	74 0e                	je     c0100bde <kmonitor+0x3a>
        print_trapframe(tf);
c0100bd0:	83 ec 0c             	sub    $0xc,%esp
c0100bd3:	ff 75 08             	push   0x8(%ebp)
c0100bd6:	e8 2b 0e 00 00       	call   c0101a06 <print_trapframe>
c0100bdb:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bde:	83 ec 0c             	sub    $0xc,%esp
c0100be1:	68 39 5d 10 c0       	push   $0xc0105d39
c0100be6:	e8 37 f6 ff ff       	call   c0100222 <readline>
c0100beb:	83 c4 10             	add    $0x10,%esp
c0100bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100bf5:	74 e7                	je     c0100bde <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100bf7:	83 ec 08             	sub    $0x8,%esp
c0100bfa:	ff 75 08             	push   0x8(%ebp)
c0100bfd:	ff 75 f4             	push   -0xc(%ebp)
c0100c00:	e8 ef fe ff ff       	call   c0100af4 <runcmd>
c0100c05:	83 c4 10             	add    $0x10,%esp
c0100c08:	85 c0                	test   %eax,%eax
c0100c0a:	78 02                	js     c0100c0e <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100c0c:	eb d0                	jmp    c0100bde <kmonitor+0x3a>
                break;
c0100c0e:	90                   	nop
            }
        }
    }
}
c0100c0f:	90                   	nop
c0100c10:	c9                   	leave  
c0100c11:	c3                   	ret    

c0100c12 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c12:	55                   	push   %ebp
c0100c13:	89 e5                	mov    %esp,%ebp
c0100c15:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c1f:	eb 3c                	jmp    c0100c5d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c24:	89 d0                	mov    %edx,%eax
c0100c26:	01 c0                	add    %eax,%eax
c0100c28:	01 d0                	add    %edx,%eax
c0100c2a:	c1 e0 02             	shl    $0x2,%eax
c0100c2d:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c32:	8b 10                	mov    (%eax),%edx
c0100c34:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c37:	89 c8                	mov    %ecx,%eax
c0100c39:	01 c0                	add    %eax,%eax
c0100c3b:	01 c8                	add    %ecx,%eax
c0100c3d:	c1 e0 02             	shl    $0x2,%eax
c0100c40:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c45:	8b 00                	mov    (%eax),%eax
c0100c47:	83 ec 04             	sub    $0x4,%esp
c0100c4a:	52                   	push   %edx
c0100c4b:	50                   	push   %eax
c0100c4c:	68 3d 5d 10 c0       	push   $0xc0105d3d
c0100c51:	e8 db f6 ff ff       	call   c0100331 <cprintf>
c0100c56:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c60:	83 f8 02             	cmp    $0x2,%eax
c0100c63:	76 bc                	jbe    c0100c21 <mon_help+0xf>
    }
    return 0;
c0100c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c6a:	c9                   	leave  
c0100c6b:	c3                   	ret    

c0100c6c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c6c:	55                   	push   %ebp
c0100c6d:	89 e5                	mov    %esp,%ebp
c0100c6f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c72:	e8 b8 fb ff ff       	call   c010082f <print_kerninfo>
    return 0;
c0100c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c7c:	c9                   	leave  
c0100c7d:	c3                   	ret    

c0100c7e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c7e:	55                   	push   %ebp
c0100c7f:	89 e5                	mov    %esp,%ebp
c0100c81:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c84:	e8 ee fc ff ff       	call   c0100977 <print_stackframe>
    return 0;
c0100c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c8e:	c9                   	leave  
c0100c8f:	c3                   	ret    

c0100c90 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c90:	55                   	push   %ebp
c0100c91:	89 e5                	mov    %esp,%ebp
c0100c93:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100c96:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100c9b:	85 c0                	test   %eax,%eax
c0100c9d:	75 5f                	jne    c0100cfe <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100c9f:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100ca6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ca9:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100caf:	83 ec 04             	sub    $0x4,%esp
c0100cb2:	ff 75 0c             	push   0xc(%ebp)
c0100cb5:	ff 75 08             	push   0x8(%ebp)
c0100cb8:	68 46 5d 10 c0       	push   $0xc0105d46
c0100cbd:	e8 6f f6 ff ff       	call   c0100331 <cprintf>
c0100cc2:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc8:	83 ec 08             	sub    $0x8,%esp
c0100ccb:	50                   	push   %eax
c0100ccc:	ff 75 10             	push   0x10(%ebp)
c0100ccf:	e8 34 f6 ff ff       	call   c0100308 <vcprintf>
c0100cd4:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100cd7:	83 ec 0c             	sub    $0xc,%esp
c0100cda:	68 62 5d 10 c0       	push   $0xc0105d62
c0100cdf:	e8 4d f6 ff ff       	call   c0100331 <cprintf>
c0100ce4:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100ce7:	83 ec 0c             	sub    $0xc,%esp
c0100cea:	68 64 5d 10 c0       	push   $0xc0105d64
c0100cef:	e8 3d f6 ff ff       	call   c0100331 <cprintf>
c0100cf4:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100cf7:	e8 7b fc ff ff       	call   c0100977 <print_stackframe>
c0100cfc:	eb 01                	jmp    c0100cff <__panic+0x6f>
        goto panic_dead;
c0100cfe:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100cff:	e8 d1 09 00 00       	call   c01016d5 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d04:	83 ec 0c             	sub    $0xc,%esp
c0100d07:	6a 00                	push   $0x0
c0100d09:	e8 96 fe ff ff       	call   c0100ba4 <kmonitor>
c0100d0e:	83 c4 10             	add    $0x10,%esp
c0100d11:	eb f1                	jmp    c0100d04 <__panic+0x74>

c0100d13 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d13:	55                   	push   %ebp
c0100d14:	89 e5                	mov    %esp,%ebp
c0100d16:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d19:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d1f:	83 ec 04             	sub    $0x4,%esp
c0100d22:	ff 75 0c             	push   0xc(%ebp)
c0100d25:	ff 75 08             	push   0x8(%ebp)
c0100d28:	68 76 5d 10 c0       	push   $0xc0105d76
c0100d2d:	e8 ff f5 ff ff       	call   c0100331 <cprintf>
c0100d32:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d38:	83 ec 08             	sub    $0x8,%esp
c0100d3b:	50                   	push   %eax
c0100d3c:	ff 75 10             	push   0x10(%ebp)
c0100d3f:	e8 c4 f5 ff ff       	call   c0100308 <vcprintf>
c0100d44:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100d47:	83 ec 0c             	sub    $0xc,%esp
c0100d4a:	68 62 5d 10 c0       	push   $0xc0105d62
c0100d4f:	e8 dd f5 ff ff       	call   c0100331 <cprintf>
c0100d54:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100d57:	90                   	nop
c0100d58:	c9                   	leave  
c0100d59:	c3                   	ret    

c0100d5a <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d5a:	55                   	push   %ebp
c0100d5b:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d5d:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100d62:	5d                   	pop    %ebp
c0100d63:	c3                   	ret    

c0100d64 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
c0100d67:	83 ec 18             	sub    $0x18,%esp
c0100d6a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d70:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d78:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d7c:	ee                   	out    %al,(%dx)
}
c0100d7d:	90                   	nop
c0100d7e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d84:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d88:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d90:	ee                   	out    %al,(%dx)
}
c0100d91:	90                   	nop
c0100d92:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100d98:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da4:	ee                   	out    %al,(%dx)
}
c0100da5:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100da6:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db0:	83 ec 0c             	sub    $0xc,%esp
c0100db3:	68 94 5d 10 c0       	push   $0xc0105d94
c0100db8:	e8 74 f5 ff ff       	call   c0100331 <cprintf>
c0100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dc0:	83 ec 0c             	sub    $0xc,%esp
c0100dc3:	6a 00                	push   $0x0
c0100dc5:	e8 6e 09 00 00       	call   c0101738 <pic_enable>
c0100dca:	83 c4 10             	add    $0x10,%esp
}
c0100dcd:	90                   	nop
c0100dce:	c9                   	leave  
c0100dcf:	c3                   	ret    

c0100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd6:	9c                   	pushf  
c0100dd7:	58                   	pop    %eax
c0100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dde:	25 00 02 00 00       	and    $0x200,%eax
c0100de3:	85 c0                	test   %eax,%eax
c0100de5:	74 0c                	je     c0100df3 <__intr_save+0x23>
        intr_disable();
c0100de7:	e8 e9 08 00 00       	call   c01016d5 <intr_disable>
        return 1;
c0100dec:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df1:	eb 05                	jmp    c0100df8 <__intr_save+0x28>
    }
    return 0;
c0100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df8:	c9                   	leave  
c0100df9:	c3                   	ret    

c0100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfa:	55                   	push   %ebp
c0100dfb:	89 e5                	mov    %esp,%ebp
c0100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e04:	74 05                	je     c0100e0b <__intr_restore+0x11>
        intr_enable();
c0100e06:	e8 c2 08 00 00       	call   c01016cd <intr_enable>
    }
}
c0100e0b:	90                   	nop
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 10             	sub    $0x10,%esp
c0100e14:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e1e:	89 c2                	mov    %eax,%edx
c0100e20:	ec                   	in     (%dx),%al
c0100e21:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e24:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e2a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e2e:	89 c2                	mov    %eax,%edx
c0100e30:	ec                   	in     (%dx),%al
c0100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e3e:	89 c2                	mov    %eax,%edx
c0100e40:	ec                   	in     (%dx),%al
c0100e41:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e44:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	ec                   	in     (%dx),%al
c0100e51:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e54:	90                   	nop
c0100e55:	c9                   	leave  
c0100e56:	c3                   	ret    

c0100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e67:	0f b7 00             	movzwl (%eax),%eax
c0100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e79:	0f b7 00             	movzwl (%eax),%eax
c0100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e80:	74 12                	je     c0100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e89:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100e90:	b4 03 
c0100e92:	eb 13                	jmp    c0100ea7 <cga_init+0x50>
    } else {
        *cp = was;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e9e:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ea7:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100eae:	0f b7 c0             	movzwl %ax,%eax
c0100eb1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100eb5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ebd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
}
c0100ec2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100ec3:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100eca:	83 c0 01             	add    $0x1,%eax
c0100ecd:	0f b7 c0             	movzwl %ax,%eax
c0100ed0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed8:	89 c2                	mov    %eax,%edx
c0100eda:	ec                   	in     (%dx),%al
c0100edb:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100ede:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee2:	0f b6 c0             	movzbl %al,%eax
c0100ee5:	c1 e0 08             	shl    $0x8,%eax
c0100ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100eeb:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100ef2:	0f b7 c0             	movzwl %ax,%eax
c0100ef5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ef9:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f01:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f05:	ee                   	out    %al,(%dx)
}
c0100f06:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f07:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f0e:	83 c0 01             	add    $0x1,%eax
c0100f11:	0f b7 c0             	movzwl %ax,%eax
c0100f14:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f18:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f1c:	89 c2                	mov    %eax,%edx
c0100f1e:	ec                   	in     (%dx),%al
c0100f1f:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f22:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f26:	0f b6 c0             	movzbl %al,%eax
c0100f29:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2f:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f37:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100f3d:	90                   	nop
c0100f3e:	c9                   	leave  
c0100f3f:	c3                   	ret    

c0100f40 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f40:	55                   	push   %ebp
c0100f41:	89 e5                	mov    %esp,%ebp
c0100f43:	83 ec 38             	sub    $0x38,%esp
c0100f46:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f4c:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f50:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f54:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f58:	ee                   	out    %al,(%dx)
}
c0100f59:	90                   	nop
c0100f5a:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f60:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f64:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f68:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f6c:	ee                   	out    %al,(%dx)
}
c0100f6d:	90                   	nop
c0100f6e:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f74:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f78:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f7c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
}
c0100f81:	90                   	nop
c0100f82:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f88:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f90:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
}
c0100f95:	90                   	nop
c0100f96:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100f9c:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fa4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
}
c0100fa9:	90                   	nop
c0100faa:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fb0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fb4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbc:	ee                   	out    %al,(%dx)
}
c0100fbd:	90                   	nop
c0100fbe:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc4:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fcc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
}
c0100fd1:	90                   	nop
c0100fd2:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fdc:	89 c2                	mov    %eax,%edx
c0100fde:	ec                   	in     (%dx),%al
c0100fdf:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fe2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fe6:	3c ff                	cmp    $0xff,%al
c0100fe8:	0f 95 c0             	setne  %al
c0100feb:	0f b6 c0             	movzbl %al,%eax
c0100fee:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c0100ff3:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ffd:	89 c2                	mov    %eax,%edx
c0100fff:	ec                   	in     (%dx),%al
c0101000:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101003:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101009:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101013:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101018:	85 c0                	test   %eax,%eax
c010101a:	74 0d                	je     c0101029 <serial_init+0xe9>
        pic_enable(IRQ_COM1);
c010101c:	83 ec 0c             	sub    $0xc,%esp
c010101f:	6a 04                	push   $0x4
c0101021:	e8 12 07 00 00       	call   c0101738 <pic_enable>
c0101026:	83 c4 10             	add    $0x10,%esp
    }
}
c0101029:	90                   	nop
c010102a:	c9                   	leave  
c010102b:	c3                   	ret    

c010102c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010102c:	55                   	push   %ebp
c010102d:	89 e5                	mov    %esp,%ebp
c010102f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101039:	eb 09                	jmp    c0101044 <lpt_putc_sub+0x18>
        delay();
c010103b:	e8 ce fd ff ff       	call   c0100e0e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101040:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101044:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010104e:	89 c2                	mov    %eax,%edx
c0101050:	ec                   	in     (%dx),%al
c0101051:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101054:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101058:	84 c0                	test   %al,%al
c010105a:	78 09                	js     c0101065 <lpt_putc_sub+0x39>
c010105c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101063:	7e d6                	jle    c010103b <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101065:	8b 45 08             	mov    0x8(%ebp),%eax
c0101068:	0f b6 c0             	movzbl %al,%eax
c010106b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101071:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101074:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101078:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010107c:	ee                   	out    %al,(%dx)
}
c010107d:	90                   	nop
c010107e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101084:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101088:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010108c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101090:	ee                   	out    %al,(%dx)
}
c0101091:	90                   	nop
c0101092:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101098:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010109c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a4:	ee                   	out    %al,(%dx)
}
c01010a5:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a6:	90                   	nop
c01010a7:	c9                   	leave  
c01010a8:	c3                   	ret    

c01010a9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010a9:	55                   	push   %ebp
c01010aa:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b0:	74 0d                	je     c01010bf <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010b2:	ff 75 08             	push   0x8(%ebp)
c01010b5:	e8 72 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010ba:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010bd:	eb 1e                	jmp    c01010dd <lpt_putc+0x34>
        lpt_putc_sub('\b');
c01010bf:	6a 08                	push   $0x8
c01010c1:	e8 66 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010c6:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010c9:	6a 20                	push   $0x20
c01010cb:	e8 5c ff ff ff       	call   c010102c <lpt_putc_sub>
c01010d0:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010d3:	6a 08                	push   $0x8
c01010d5:	e8 52 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010da:	83 c4 04             	add    $0x4,%esp
}
c01010dd:	90                   	nop
c01010de:	c9                   	leave  
c01010df:	c3                   	ret    

c01010e0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e0:	55                   	push   %ebp
c01010e1:	89 e5                	mov    %esp,%ebp
c01010e3:	53                   	push   %ebx
c01010e4:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ea:	b0 00                	mov    $0x0,%al
c01010ec:	85 c0                	test   %eax,%eax
c01010ee:	75 07                	jne    c01010f7 <cga_putc+0x17>
        c |= 0x0700;
c01010f0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fa:	0f b6 c0             	movzbl %al,%eax
c01010fd:	83 f8 0d             	cmp    $0xd,%eax
c0101100:	74 6b                	je     c010116d <cga_putc+0x8d>
c0101102:	83 f8 0d             	cmp    $0xd,%eax
c0101105:	0f 8f 9c 00 00 00    	jg     c01011a7 <cga_putc+0xc7>
c010110b:	83 f8 08             	cmp    $0x8,%eax
c010110e:	74 0a                	je     c010111a <cga_putc+0x3a>
c0101110:	83 f8 0a             	cmp    $0xa,%eax
c0101113:	74 48                	je     c010115d <cga_putc+0x7d>
c0101115:	e9 8d 00 00 00       	jmp    c01011a7 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c010111a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101121:	66 85 c0             	test   %ax,%ax
c0101124:	0f 84 a3 00 00 00    	je     c01011cd <cga_putc+0xed>
            crt_pos --;
c010112a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101131:	83 e8 01             	sub    $0x1,%eax
c0101134:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113a:	8b 45 08             	mov    0x8(%ebp),%eax
c010113d:	b0 00                	mov    $0x0,%al
c010113f:	83 c8 20             	or     $0x20,%eax
c0101142:	89 c2                	mov    %eax,%edx
c0101144:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010114a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101151:	0f b7 c0             	movzwl %ax,%eax
c0101154:	01 c0                	add    %eax,%eax
c0101156:	01 c8                	add    %ecx,%eax
c0101158:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010115b:	eb 70                	jmp    c01011cd <cga_putc+0xed>
    case '\n':
        crt_pos += CRT_COLS;
c010115d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101164:	83 c0 50             	add    $0x50,%eax
c0101167:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116d:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c0101174:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c010117b:	0f b7 c1             	movzwl %cx,%eax
c010117e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101184:	c1 e8 10             	shr    $0x10,%eax
c0101187:	89 c2                	mov    %eax,%edx
c0101189:	66 c1 ea 06          	shr    $0x6,%dx
c010118d:	89 d0                	mov    %edx,%eax
c010118f:	c1 e0 02             	shl    $0x2,%eax
c0101192:	01 d0                	add    %edx,%eax
c0101194:	c1 e0 04             	shl    $0x4,%eax
c0101197:	29 c1                	sub    %eax,%ecx
c0101199:	89 ca                	mov    %ecx,%edx
c010119b:	89 d8                	mov    %ebx,%eax
c010119d:	29 d0                	sub    %edx,%eax
c010119f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c01011a5:	eb 27                	jmp    c01011ce <cga_putc+0xee>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a7:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011ad:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011b4:	8d 50 01             	lea    0x1(%eax),%edx
c01011b7:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c01011be:	0f b7 c0             	movzwl %ax,%eax
c01011c1:	01 c0                	add    %eax,%eax
c01011c3:	01 c8                	add    %ecx,%eax
c01011c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01011c8:	66 89 10             	mov    %dx,(%eax)
        break;
c01011cb:	eb 01                	jmp    c01011ce <cga_putc+0xee>
        break;
c01011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ce:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d9:	76 5a                	jbe    c0101235 <cga_putc+0x155>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011db:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e6:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01011eb:	83 ec 04             	sub    $0x4,%esp
c01011ee:	68 00 0f 00 00       	push   $0xf00
c01011f3:	52                   	push   %edx
c01011f4:	50                   	push   %eax
c01011f5:	e8 2f 47 00 00       	call   c0105929 <memmove>
c01011fa:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101204:	eb 16                	jmp    c010121c <cga_putc+0x13c>
            crt_buf[i] = 0x0700 | ' ';
c0101206:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c010120c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010120f:	01 c0                	add    %eax,%eax
c0101211:	01 d0                	add    %edx,%eax
c0101213:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101218:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101223:	7e e1                	jle    c0101206 <cga_putc+0x126>
        }
        crt_pos -= CRT_COLS;
c0101225:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010122c:	83 e8 50             	sub    $0x50,%eax
c010122f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101235:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c010123c:	0f b7 c0             	movzwl %ax,%eax
c010123f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101243:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101247:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010124b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010124f:	ee                   	out    %al,(%dx)
}
c0101250:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101251:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101258:	66 c1 e8 08          	shr    $0x8,%ax
c010125c:	0f b6 c0             	movzbl %al,%eax
c010125f:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c0101266:	83 c2 01             	add    $0x1,%edx
c0101269:	0f b7 d2             	movzwl %dx,%edx
c010126c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101270:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101273:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101277:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
}
c010127c:	90                   	nop
    outb(addr_6845, 15);
c010127d:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0101284:	0f b7 c0             	movzwl %ax,%eax
c0101287:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010128b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010128f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101293:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101297:	ee                   	out    %al,(%dx)
}
c0101298:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101299:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012aa:	83 c2 01             	add    $0x1,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012b4:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012bb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
}
c01012c0:	90                   	nop
}
c01012c1:	90                   	nop
c01012c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012c5:	c9                   	leave  
c01012c6:	c3                   	ret    

c01012c7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c7:	55                   	push   %ebp
c01012c8:	89 e5                	mov    %esp,%ebp
c01012ca:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d4:	eb 09                	jmp    c01012df <serial_putc_sub+0x18>
        delay();
c01012d6:	e8 33 fb ff ff       	call   c0100e0e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012df:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e9:	89 c2                	mov    %eax,%edx
c01012eb:	ec                   	in     (%dx),%al
c01012ec:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ef:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f3:	0f b6 c0             	movzbl %al,%eax
c01012f6:	83 e0 20             	and    $0x20,%eax
c01012f9:	85 c0                	test   %eax,%eax
c01012fb:	75 09                	jne    c0101306 <serial_putc_sub+0x3f>
c01012fd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101304:	7e d0                	jle    c01012d6 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101306:	8b 45 08             	mov    0x8(%ebp),%eax
c0101309:	0f b6 c0             	movzbl %al,%eax
c010130c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101312:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101315:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101319:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131d:	ee                   	out    %al,(%dx)
}
c010131e:	90                   	nop
}
c010131f:	90                   	nop
c0101320:	c9                   	leave  
c0101321:	c3                   	ret    

c0101322 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101322:	55                   	push   %ebp
c0101323:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x16>
        serial_putc_sub(c);
c010132b:	ff 75 08             	push   0x8(%ebp)
c010132e:	e8 94 ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101333:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101336:	eb 1e                	jmp    c0101356 <serial_putc+0x34>
        serial_putc_sub('\b');
c0101338:	6a 08                	push   $0x8
c010133a:	e8 88 ff ff ff       	call   c01012c7 <serial_putc_sub>
c010133f:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101342:	6a 20                	push   $0x20
c0101344:	e8 7e ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101349:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010134c:	6a 08                	push   $0x8
c010134e:	e8 74 ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101353:	83 c4 04             	add    $0x4,%esp
}
c0101356:	90                   	nop
c0101357:	c9                   	leave  
c0101358:	c3                   	ret    

c0101359 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101359:	55                   	push   %ebp
c010135a:	89 e5                	mov    %esp,%ebp
c010135c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135f:	eb 33                	jmp    c0101394 <cons_intr+0x3b>
        if (c != 0) {
c0101361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101365:	74 2d                	je     c0101394 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101367:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c010136c:	8d 50 01             	lea    0x1(%eax),%edx
c010136f:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c0101375:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101378:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137e:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101383:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101388:	75 0a                	jne    c0101394 <cons_intr+0x3b>
                cons.wpos = 0;
c010138a:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101391:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101394:	8b 45 08             	mov    0x8(%ebp),%eax
c0101397:	ff d0                	call   *%eax
c0101399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a0:	75 bf                	jne    c0101361 <cons_intr+0x8>
            }
        }
    }
}
c01013a2:	90                   	nop
c01013a3:	90                   	nop
c01013a4:	c9                   	leave  
c01013a5:	c3                   	ret    

c01013a6 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a6:	55                   	push   %ebp
c01013a7:	89 e5                	mov    %esp,%ebp
c01013a9:	83 ec 10             	sub    $0x10,%esp
c01013ac:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b6:	89 c2                	mov    %eax,%edx
c01013b8:	ec                   	in     (%dx),%al
c01013b9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c0:	0f b6 c0             	movzbl %al,%eax
c01013c3:	83 e0 01             	and    $0x1,%eax
c01013c6:	85 c0                	test   %eax,%eax
c01013c8:	75 07                	jne    c01013d1 <serial_proc_data+0x2b>
        return -1;
c01013ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cf:	eb 2a                	jmp    c01013fb <serial_proc_data+0x55>
c01013d1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013db:	89 c2                	mov    %eax,%edx
c01013dd:	ec                   	in     (%dx),%al
c01013de:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e5:	0f b6 c0             	movzbl %al,%eax
c01013e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013eb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ef:	75 07                	jne    c01013f8 <serial_proc_data+0x52>
        c = '\b';
c01013f1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fb:	c9                   	leave  
c01013fc:	c3                   	ret    

c01013fd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fd:	55                   	push   %ebp
c01013fe:	89 e5                	mov    %esp,%ebp
c0101400:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101403:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101408:	85 c0                	test   %eax,%eax
c010140a:	74 10                	je     c010141c <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c010140c:	83 ec 0c             	sub    $0xc,%esp
c010140f:	68 a6 13 10 c0       	push   $0xc01013a6
c0101414:	e8 40 ff ff ff       	call   c0101359 <cons_intr>
c0101419:	83 c4 10             	add    $0x10,%esp
    }
}
c010141c:	90                   	nop
c010141d:	c9                   	leave  
c010141e:	c3                   	ret    

c010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 28             	sub    $0x28,%esp
c0101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2e>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 5e 01 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101457:	89 c2                	mov    %eax,%edx
c0101459:	ec                   	in     (%dx),%al
c010145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101468:	75 17                	jne    c0101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010146f:	83 c8 40             	or     $0x40,%eax
c0101472:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101477:	b8 00 00 00 00       	mov    $0x0,%eax
c010147c:	e9 2a 01 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
    } else if (data & 0x80) {
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	84 c0                	test   %al,%al
c0101487:	79 47                	jns    c01014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101489:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010148e:	83 e0 40             	and    $0x40,%eax
c0101491:	85 c0                	test   %eax,%eax
c0101493:	75 09                	jne    c010149e <kbd_proc_data+0x7f>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	83 e0 7f             	and    $0x7f,%eax
c010149c:	eb 04                	jmp    c01014a2 <kbd_proc_data+0x83>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014b0:	83 c8 40             	or     $0x40,%eax
c01014b3:	0f b6 c0             	movzbl %al,%eax
c01014b6:	f7 d0                	not    %eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014bf:	21 d0                	and    %edx,%eax
c01014c1:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cb:	e9 db 00 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
    } else if (shift & E0ESC) {
c01014d0:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014d5:	83 e0 40             	and    $0x40,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 11                	je     c01014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e0:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e8:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c01014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f1:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014f8:	0f b6 d0             	movzbl %al,%edx
c01014fb:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101500:	09 d0                	or     %edx,%eax
c0101502:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c0101512:	0f b6 d0             	movzbl %al,%edx
c0101515:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010151a:	31 d0                	xor    %edx,%eax
c010151c:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101521:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101526:	83 e0 03             	and    $0x3,%eax
c0101529:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	01 d0                	add    %edx,%eax
c0101536:	0f b6 00             	movzbl (%eax),%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153f:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101544:	83 e0 08             	and    $0x8,%eax
c0101547:	85 c0                	test   %eax,%eax
c0101549:	74 22                	je     c010156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154f:	7e 0c                	jle    c010155d <kbd_proc_data+0x13e>
c0101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101555:	7f 06                	jg     c010155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155b:	eb 10                	jmp    c010156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101561:	7e 0a                	jle    c010156d <kbd_proc_data+0x14e>
c0101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101567:	7f 04                	jg     c010156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101572:	f7 d0                	not    %eax
c0101574:	83 e0 06             	and    $0x6,%eax
c0101577:	85 c0                	test   %eax,%eax
c0101579:	75 2d                	jne    c01015a8 <kbd_proc_data+0x189>
c010157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101582:	75 24                	jne    c01015a8 <kbd_proc_data+0x189>
        cprintf("Rebooting!\n");
c0101584:	83 ec 0c             	sub    $0xc,%esp
c0101587:	68 af 5d 10 c0       	push   $0xc0105daf
c010158c:	e8 a0 ed ff ff       	call   c0100331 <cprintf>
c0101591:	83 c4 10             	add    $0x10,%esp
c0101594:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a6:	ee                   	out    %al,(%dx)
}
c01015a7:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ab:	c9                   	leave  
c01015ac:	c3                   	ret    

c01015ad <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ad:	55                   	push   %ebp
c01015ae:	89 e5                	mov    %esp,%ebp
c01015b0:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c01015b3:	83 ec 0c             	sub    $0xc,%esp
c01015b6:	68 1f 14 10 c0       	push   $0xc010141f
c01015bb:	e8 99 fd ff ff       	call   c0101359 <cons_intr>
c01015c0:	83 c4 10             	add    $0x10,%esp
}
c01015c3:	90                   	nop
c01015c4:	c9                   	leave  
c01015c5:	c3                   	ret    

c01015c6 <kbd_init>:

static void
kbd_init(void) {
c01015c6:	55                   	push   %ebp
c01015c7:	89 e5                	mov    %esp,%ebp
c01015c9:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cc:	e8 dc ff ff ff       	call   c01015ad <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d1:	83 ec 0c             	sub    $0xc,%esp
c01015d4:	6a 01                	push   $0x1
c01015d6:	e8 5d 01 00 00       	call   c0101738 <pic_enable>
c01015db:	83 c4 10             	add    $0x10,%esp
}
c01015de:	90                   	nop
c01015df:	c9                   	leave  
c01015e0:	c3                   	ret    

c01015e1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e1:	55                   	push   %ebp
c01015e2:	89 e5                	mov    %esp,%ebp
c01015e4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015e7:	e8 6b f8 ff ff       	call   c0100e57 <cga_init>
    serial_init();
c01015ec:	e8 4f f9 ff ff       	call   c0100f40 <serial_init>
    kbd_init();
c01015f1:	e8 d0 ff ff ff       	call   c01015c6 <kbd_init>
    if (!serial_exists) {
c01015f6:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01015fb:	85 c0                	test   %eax,%eax
c01015fd:	75 10                	jne    c010160f <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015ff:	83 ec 0c             	sub    $0xc,%esp
c0101602:	68 bb 5d 10 c0       	push   $0xc0105dbb
c0101607:	e8 25 ed ff ff       	call   c0100331 <cprintf>
c010160c:	83 c4 10             	add    $0x10,%esp
    }
}
c010160f:	90                   	nop
c0101610:	c9                   	leave  
c0101611:	c3                   	ret    

c0101612 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101612:	55                   	push   %ebp
c0101613:	89 e5                	mov    %esp,%ebp
c0101615:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101618:	e8 b3 f7 ff ff       	call   c0100dd0 <__intr_save>
c010161d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101620:	83 ec 0c             	sub    $0xc,%esp
c0101623:	ff 75 08             	push   0x8(%ebp)
c0101626:	e8 7e fa ff ff       	call   c01010a9 <lpt_putc>
c010162b:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010162e:	83 ec 0c             	sub    $0xc,%esp
c0101631:	ff 75 08             	push   0x8(%ebp)
c0101634:	e8 a7 fa ff ff       	call   c01010e0 <cga_putc>
c0101639:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010163c:	83 ec 0c             	sub    $0xc,%esp
c010163f:	ff 75 08             	push   0x8(%ebp)
c0101642:	e8 db fc ff ff       	call   c0101322 <serial_putc>
c0101647:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010164a:	83 ec 0c             	sub    $0xc,%esp
c010164d:	ff 75 f4             	push   -0xc(%ebp)
c0101650:	e8 a5 f7 ff ff       	call   c0100dfa <__intr_restore>
c0101655:	83 c4 10             	add    $0x10,%esp
}
c0101658:	90                   	nop
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101668:	e8 63 f7 ff ff       	call   c0100dd0 <__intr_save>
c010166d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101670:	e8 88 fd ff ff       	call   c01013fd <serial_intr>
        kbd_intr();
c0101675:	e8 33 ff ff ff       	call   c01015ad <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167a:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c0101680:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101685:	39 c2                	cmp    %eax,%edx
c0101687:	74 31                	je     c01016ba <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101689:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c010168e:	8d 50 01             	lea    0x1(%eax),%edx
c0101691:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101697:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010169e:	0f b6 c0             	movzbl %al,%eax
c01016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a4:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016a9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016ae:	75 0a                	jne    c01016ba <cons_getc+0x5f>
                cons.rpos = 0;
c01016b0:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c01016b7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016ba:	83 ec 0c             	sub    $0xc,%esp
c01016bd:	ff 75 f0             	push   -0x10(%ebp)
c01016c0:	e8 35 f7 ff ff       	call   c0100dfa <__intr_restore>
c01016c5:	83 c4 10             	add    $0x10,%esp
    return c;
c01016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cb:	c9                   	leave  
c01016cc:	c3                   	ret    

c01016cd <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016cd:	55                   	push   %ebp
c01016ce:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01016d0:	fb                   	sti    
}
c01016d1:	90                   	nop
    sti();
}
c01016d2:	90                   	nop
c01016d3:	5d                   	pop    %ebp
c01016d4:	c3                   	ret    

c01016d5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016d5:	55                   	push   %ebp
c01016d6:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01016d8:	fa                   	cli    
}
c01016d9:	90                   	nop
    cli();
}
c01016da:	90                   	nop
c01016db:	5d                   	pop    %ebp
c01016dc:	c3                   	ret    

c01016dd <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016dd:	55                   	push   %ebp
c01016de:	89 e5                	mov    %esp,%ebp
c01016e0:	83 ec 14             	sub    $0x14,%esp
c01016e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ee:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c01016f4:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c01016f9:	85 c0                	test   %eax,%eax
c01016fb:	74 38                	je     c0101735 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c01016fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101701:	0f b6 c0             	movzbl %al,%eax
c0101704:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c010170a:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010170d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101711:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101715:	ee                   	out    %al,(%dx)
}
c0101716:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101717:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010171b:	66 c1 e8 08          	shr    $0x8,%ax
c010171f:	0f b6 c0             	movzbl %al,%eax
c0101722:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101728:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010172b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010172f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101733:	ee                   	out    %al,(%dx)
}
c0101734:	90                   	nop
    }
}
c0101735:	90                   	nop
c0101736:	c9                   	leave  
c0101737:	c3                   	ret    

c0101738 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101738:	55                   	push   %ebp
c0101739:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c010173b:	8b 45 08             	mov    0x8(%ebp),%eax
c010173e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101743:	89 c1                	mov    %eax,%ecx
c0101745:	d3 e2                	shl    %cl,%edx
c0101747:	89 d0                	mov    %edx,%eax
c0101749:	f7 d0                	not    %eax
c010174b:	89 c2                	mov    %eax,%edx
c010174d:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101754:	21 d0                	and    %edx,%eax
c0101756:	0f b7 c0             	movzwl %ax,%eax
c0101759:	50                   	push   %eax
c010175a:	e8 7e ff ff ff       	call   c01016dd <pic_setmask>
c010175f:	83 c4 04             	add    $0x4,%esp
}
c0101762:	90                   	nop
c0101763:	c9                   	leave  
c0101764:	c3                   	ret    

c0101765 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101765:	55                   	push   %ebp
c0101766:	89 e5                	mov    %esp,%ebp
c0101768:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c010176b:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c0101772:	00 00 00 
c0101775:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010177b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010177f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101783:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101787:	ee                   	out    %al,(%dx)
}
c0101788:	90                   	nop
c0101789:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010178f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101793:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101797:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010179b:	ee                   	out    %al,(%dx)
}
c010179c:	90                   	nop
c010179d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01017a3:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017ab:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
}
c01017b0:	90                   	nop
c01017b1:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01017b7:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017bb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017bf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017c3:	ee                   	out    %al,(%dx)
}
c01017c4:	90                   	nop
c01017c5:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017cb:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017cf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017d3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
}
c01017d8:	90                   	nop
c01017d9:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017df:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
}
c01017ec:	90                   	nop
c01017ed:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017f3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017fb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
}
c0101800:	90                   	nop
c0101801:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101807:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010180f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
}
c0101814:	90                   	nop
c0101815:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c010181b:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010181f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101823:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
}
c0101828:	90                   	nop
c0101829:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010182f:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101833:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101837:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
}
c010183c:	90                   	nop
c010183d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101843:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101847:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010184b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010184f:	ee                   	out    %al,(%dx)
}
c0101850:	90                   	nop
c0101851:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101857:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010185f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101863:	ee                   	out    %al,(%dx)
}
c0101864:	90                   	nop
c0101865:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010186b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101873:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101877:	ee                   	out    %al,(%dx)
}
c0101878:	90                   	nop
c0101879:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010187f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101883:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101887:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010188b:	ee                   	out    %al,(%dx)
}
c010188c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010188d:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101894:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101898:	74 13                	je     c01018ad <pic_init+0x148>
        pic_setmask(irq_mask);
c010189a:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01018a1:	0f b7 c0             	movzwl %ax,%eax
c01018a4:	50                   	push   %eax
c01018a5:	e8 33 fe ff ff       	call   c01016dd <pic_setmask>
c01018aa:	83 c4 04             	add    $0x4,%esp
    }
}
c01018ad:	90                   	nop
c01018ae:	c9                   	leave  
c01018af:	c3                   	ret    

c01018b0 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018b0:	55                   	push   %ebp
c01018b1:	89 e5                	mov    %esp,%ebp
c01018b3:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018b6:	83 ec 08             	sub    $0x8,%esp
c01018b9:	6a 64                	push   $0x64
c01018bb:	68 e0 5d 10 c0       	push   $0xc0105de0
c01018c0:	e8 6c ea ff ff       	call   c0100331 <cprintf>
c01018c5:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018c8:	90                   	nop
c01018c9:	c9                   	leave  
c01018ca:	c3                   	ret    

c01018cb <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018cb:	55                   	push   %ebp
c01018cc:	89 e5                	mov    %esp,%ebp
c01018ce:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018d8:	e9 c3 00 00 00       	jmp    c01019a0 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e0:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c01018e7:	89 c2                	mov    %eax,%edx
c01018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ec:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c01018f3:	c0 
c01018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f7:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c01018fe:	c0 08 00 
c0101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101904:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c010190b:	c0 
c010190c:	83 e2 e0             	and    $0xffffffe0,%edx
c010190f:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c0101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101919:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c0101920:	c0 
c0101921:	83 e2 1f             	and    $0x1f,%edx
c0101924:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c010192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192e:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101935:	c0 
c0101936:	83 e2 f0             	and    $0xfffffff0,%edx
c0101939:	83 ca 0e             	or     $0xe,%edx
c010193c:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c010194d:	c0 
c010194e:	83 e2 ef             	and    $0xffffffef,%edx
c0101951:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101962:	c0 
c0101963:	83 e2 9f             	and    $0xffffff9f,%edx
c0101966:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c010196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101970:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101977:	c0 
c0101978:	83 ca 80             	or     $0xffffff80,%edx
c010197b:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101985:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c010198c:	c1 e8 10             	shr    $0x10,%eax
c010198f:	89 c2                	mov    %eax,%edx
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c010199b:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010199c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019a8:	0f 86 2f ff ff ff    	jbe    c01018dd <idt_init+0x12>
c01019ae:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019b8:	0f 01 18             	lidtl  (%eax)
}
c01019bb:	90                   	nop
    }
    lidt(&idt_pd);
}
c01019bc:	90                   	nop
c01019bd:	c9                   	leave  
c01019be:	c3                   	ret    

c01019bf <trapname>:

static const char *
trapname(int trapno) {
c01019bf:	55                   	push   %ebp
c01019c0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c5:	83 f8 13             	cmp    $0x13,%eax
c01019c8:	77 0c                	ja     c01019d6 <trapname+0x17>
        return excnames[trapno];
c01019ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cd:	8b 04 85 40 61 10 c0 	mov    -0x3fef9ec0(,%eax,4),%eax
c01019d4:	eb 18                	jmp    c01019ee <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019d6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019da:	7e 0d                	jle    c01019e9 <trapname+0x2a>
c01019dc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019e0:	7f 07                	jg     c01019e9 <trapname+0x2a>
        return "Hardware Interrupt";
c01019e2:	b8 ea 5d 10 c0       	mov    $0xc0105dea,%eax
c01019e7:	eb 05                	jmp    c01019ee <trapname+0x2f>
    }
    return "(unknown trap)";
c01019e9:	b8 fd 5d 10 c0       	mov    $0xc0105dfd,%eax
}
c01019ee:	5d                   	pop    %ebp
c01019ef:	c3                   	ret    

c01019f0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019f0:	55                   	push   %ebp
c01019f1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019fa:	66 83 f8 08          	cmp    $0x8,%ax
c01019fe:	0f 94 c0             	sete   %al
c0101a01:	0f b6 c0             	movzbl %al,%eax
}
c0101a04:	5d                   	pop    %ebp
c0101a05:	c3                   	ret    

c0101a06 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a06:	55                   	push   %ebp
c0101a07:	89 e5                	mov    %esp,%ebp
c0101a09:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a0c:	83 ec 08             	sub    $0x8,%esp
c0101a0f:	ff 75 08             	push   0x8(%ebp)
c0101a12:	68 3e 5e 10 c0       	push   $0xc0105e3e
c0101a17:	e8 15 e9 ff ff       	call   c0100331 <cprintf>
c0101a1c:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a22:	83 ec 0c             	sub    $0xc,%esp
c0101a25:	50                   	push   %eax
c0101a26:	e8 b4 01 00 00       	call   c0101bdf <print_regs>
c0101a2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a31:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a35:	0f b7 c0             	movzwl %ax,%eax
c0101a38:	83 ec 08             	sub    $0x8,%esp
c0101a3b:	50                   	push   %eax
c0101a3c:	68 4f 5e 10 c0       	push   $0xc0105e4f
c0101a41:	e8 eb e8 ff ff       	call   c0100331 <cprintf>
c0101a46:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a50:	0f b7 c0             	movzwl %ax,%eax
c0101a53:	83 ec 08             	sub    $0x8,%esp
c0101a56:	50                   	push   %eax
c0101a57:	68 62 5e 10 c0       	push   $0xc0105e62
c0101a5c:	e8 d0 e8 ff ff       	call   c0100331 <cprintf>
c0101a61:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a67:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a6b:	0f b7 c0             	movzwl %ax,%eax
c0101a6e:	83 ec 08             	sub    $0x8,%esp
c0101a71:	50                   	push   %eax
c0101a72:	68 75 5e 10 c0       	push   $0xc0105e75
c0101a77:	e8 b5 e8 ff ff       	call   c0100331 <cprintf>
c0101a7c:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a86:	0f b7 c0             	movzwl %ax,%eax
c0101a89:	83 ec 08             	sub    $0x8,%esp
c0101a8c:	50                   	push   %eax
c0101a8d:	68 88 5e 10 c0       	push   $0xc0105e88
c0101a92:	e8 9a e8 ff ff       	call   c0100331 <cprintf>
c0101a97:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9d:	8b 40 30             	mov    0x30(%eax),%eax
c0101aa0:	83 ec 0c             	sub    $0xc,%esp
c0101aa3:	50                   	push   %eax
c0101aa4:	e8 16 ff ff ff       	call   c01019bf <trapname>
c0101aa9:	83 c4 10             	add    $0x10,%esp
c0101aac:	8b 55 08             	mov    0x8(%ebp),%edx
c0101aaf:	8b 52 30             	mov    0x30(%edx),%edx
c0101ab2:	83 ec 04             	sub    $0x4,%esp
c0101ab5:	50                   	push   %eax
c0101ab6:	52                   	push   %edx
c0101ab7:	68 9b 5e 10 c0       	push   $0xc0105e9b
c0101abc:	e8 70 e8 ff ff       	call   c0100331 <cprintf>
c0101ac1:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac7:	8b 40 34             	mov    0x34(%eax),%eax
c0101aca:	83 ec 08             	sub    $0x8,%esp
c0101acd:	50                   	push   %eax
c0101ace:	68 ad 5e 10 c0       	push   $0xc0105ead
c0101ad3:	e8 59 e8 ff ff       	call   c0100331 <cprintf>
c0101ad8:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ade:	8b 40 38             	mov    0x38(%eax),%eax
c0101ae1:	83 ec 08             	sub    $0x8,%esp
c0101ae4:	50                   	push   %eax
c0101ae5:	68 bc 5e 10 c0       	push   $0xc0105ebc
c0101aea:	e8 42 e8 ff ff       	call   c0100331 <cprintf>
c0101aef:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101af9:	0f b7 c0             	movzwl %ax,%eax
c0101afc:	83 ec 08             	sub    $0x8,%esp
c0101aff:	50                   	push   %eax
c0101b00:	68 cb 5e 10 c0       	push   $0xc0105ecb
c0101b05:	e8 27 e8 ff ff       	call   c0100331 <cprintf>
c0101b0a:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b10:	8b 40 40             	mov    0x40(%eax),%eax
c0101b13:	83 ec 08             	sub    $0x8,%esp
c0101b16:	50                   	push   %eax
c0101b17:	68 de 5e 10 c0       	push   $0xc0105ede
c0101b1c:	e8 10 e8 ff ff       	call   c0100331 <cprintf>
c0101b21:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b32:	eb 3f                	jmp    c0101b73 <print_trapframe+0x16d>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b37:	8b 50 40             	mov    0x40(%eax),%edx
c0101b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b3d:	21 d0                	and    %edx,%eax
c0101b3f:	85 c0                	test   %eax,%eax
c0101b41:	74 29                	je     c0101b6c <print_trapframe+0x166>
c0101b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b46:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101b4d:	85 c0                	test   %eax,%eax
c0101b4f:	74 1b                	je     c0101b6c <print_trapframe+0x166>
            cprintf("%s,", IA32flags[i]);
c0101b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b54:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101b5b:	83 ec 08             	sub    $0x8,%esp
c0101b5e:	50                   	push   %eax
c0101b5f:	68 ed 5e 10 c0       	push   $0xc0105eed
c0101b64:	e8 c8 e7 ff ff       	call   c0100331 <cprintf>
c0101b69:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b70:	d1 65 f0             	shll   -0x10(%ebp)
c0101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b76:	83 f8 17             	cmp    $0x17,%eax
c0101b79:	76 b9                	jbe    c0101b34 <print_trapframe+0x12e>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b81:	c1 e8 0c             	shr    $0xc,%eax
c0101b84:	83 e0 03             	and    $0x3,%eax
c0101b87:	83 ec 08             	sub    $0x8,%esp
c0101b8a:	50                   	push   %eax
c0101b8b:	68 f1 5e 10 c0       	push   $0xc0105ef1
c0101b90:	e8 9c e7 ff ff       	call   c0100331 <cprintf>
c0101b95:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101b98:	83 ec 0c             	sub    $0xc,%esp
c0101b9b:	ff 75 08             	push   0x8(%ebp)
c0101b9e:	e8 4d fe ff ff       	call   c01019f0 <trap_in_kernel>
c0101ba3:	83 c4 10             	add    $0x10,%esp
c0101ba6:	85 c0                	test   %eax,%eax
c0101ba8:	75 32                	jne    c0101bdc <print_trapframe+0x1d6>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bad:	8b 40 44             	mov    0x44(%eax),%eax
c0101bb0:	83 ec 08             	sub    $0x8,%esp
c0101bb3:	50                   	push   %eax
c0101bb4:	68 fa 5e 10 c0       	push   $0xc0105efa
c0101bb9:	e8 73 e7 ff ff       	call   c0100331 <cprintf>
c0101bbe:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bc8:	0f b7 c0             	movzwl %ax,%eax
c0101bcb:	83 ec 08             	sub    $0x8,%esp
c0101bce:	50                   	push   %eax
c0101bcf:	68 09 5f 10 c0       	push   $0xc0105f09
c0101bd4:	e8 58 e7 ff ff       	call   c0100331 <cprintf>
c0101bd9:	83 c4 10             	add    $0x10,%esp
    }
}
c0101bdc:	90                   	nop
c0101bdd:	c9                   	leave  
c0101bde:	c3                   	ret    

c0101bdf <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bdf:	55                   	push   %ebp
c0101be0:	89 e5                	mov    %esp,%ebp
c0101be2:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be8:	8b 00                	mov    (%eax),%eax
c0101bea:	83 ec 08             	sub    $0x8,%esp
c0101bed:	50                   	push   %eax
c0101bee:	68 1c 5f 10 c0       	push   $0xc0105f1c
c0101bf3:	e8 39 e7 ff ff       	call   c0100331 <cprintf>
c0101bf8:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfe:	8b 40 04             	mov    0x4(%eax),%eax
c0101c01:	83 ec 08             	sub    $0x8,%esp
c0101c04:	50                   	push   %eax
c0101c05:	68 2b 5f 10 c0       	push   $0xc0105f2b
c0101c0a:	e8 22 e7 ff ff       	call   c0100331 <cprintf>
c0101c0f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	8b 40 08             	mov    0x8(%eax),%eax
c0101c18:	83 ec 08             	sub    $0x8,%esp
c0101c1b:	50                   	push   %eax
c0101c1c:	68 3a 5f 10 c0       	push   $0xc0105f3a
c0101c21:	e8 0b e7 ff ff       	call   c0100331 <cprintf>
c0101c26:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2c:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c2f:	83 ec 08             	sub    $0x8,%esp
c0101c32:	50                   	push   %eax
c0101c33:	68 49 5f 10 c0       	push   $0xc0105f49
c0101c38:	e8 f4 e6 ff ff       	call   c0100331 <cprintf>
c0101c3d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c43:	8b 40 10             	mov    0x10(%eax),%eax
c0101c46:	83 ec 08             	sub    $0x8,%esp
c0101c49:	50                   	push   %eax
c0101c4a:	68 58 5f 10 c0       	push   $0xc0105f58
c0101c4f:	e8 dd e6 ff ff       	call   c0100331 <cprintf>
c0101c54:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5a:	8b 40 14             	mov    0x14(%eax),%eax
c0101c5d:	83 ec 08             	sub    $0x8,%esp
c0101c60:	50                   	push   %eax
c0101c61:	68 67 5f 10 c0       	push   $0xc0105f67
c0101c66:	e8 c6 e6 ff ff       	call   c0100331 <cprintf>
c0101c6b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c71:	8b 40 18             	mov    0x18(%eax),%eax
c0101c74:	83 ec 08             	sub    $0x8,%esp
c0101c77:	50                   	push   %eax
c0101c78:	68 76 5f 10 c0       	push   $0xc0105f76
c0101c7d:	e8 af e6 ff ff       	call   c0100331 <cprintf>
c0101c82:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c88:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c8b:	83 ec 08             	sub    $0x8,%esp
c0101c8e:	50                   	push   %eax
c0101c8f:	68 85 5f 10 c0       	push   $0xc0105f85
c0101c94:	e8 98 e6 ff ff       	call   c0100331 <cprintf>
c0101c99:	83 c4 10             	add    $0x10,%esp
}
c0101c9c:	90                   	nop
c0101c9d:	c9                   	leave  
c0101c9e:	c3                   	ret    

c0101c9f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c9f:	55                   	push   %ebp
c0101ca0:	89 e5                	mov    %esp,%ebp
c0101ca2:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 40 30             	mov    0x30(%eax),%eax
c0101cab:	83 f8 79             	cmp    $0x79,%eax
c0101cae:	0f 87 d1 00 00 00    	ja     c0101d85 <trap_dispatch+0xe6>
c0101cb4:	83 f8 78             	cmp    $0x78,%eax
c0101cb7:	0f 83 b1 00 00 00    	jae    c0101d6e <trap_dispatch+0xcf>
c0101cbd:	83 f8 2f             	cmp    $0x2f,%eax
c0101cc0:	0f 87 bf 00 00 00    	ja     c0101d85 <trap_dispatch+0xe6>
c0101cc6:	83 f8 2e             	cmp    $0x2e,%eax
c0101cc9:	0f 83 ec 00 00 00    	jae    c0101dbb <trap_dispatch+0x11c>
c0101ccf:	83 f8 24             	cmp    $0x24,%eax
c0101cd2:	74 52                	je     c0101d26 <trap_dispatch+0x87>
c0101cd4:	83 f8 24             	cmp    $0x24,%eax
c0101cd7:	0f 87 a8 00 00 00    	ja     c0101d85 <trap_dispatch+0xe6>
c0101cdd:	83 f8 20             	cmp    $0x20,%eax
c0101ce0:	74 0a                	je     c0101cec <trap_dispatch+0x4d>
c0101ce2:	83 f8 21             	cmp    $0x21,%eax
c0101ce5:	74 63                	je     c0101d4a <trap_dispatch+0xab>
c0101ce7:	e9 99 00 00 00       	jmp    c0101d85 <trap_dispatch+0xe6>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101cec:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101cf1:	83 c0 01             	add    $0x1,%eax
c0101cf4:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks % TICK_NUM == 0) {
c0101cf9:	8b 0d 24 b4 11 c0    	mov    0xc011b424,%ecx
c0101cff:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d04:	89 c8                	mov    %ecx,%eax
c0101d06:	f7 e2                	mul    %edx
c0101d08:	89 d0                	mov    %edx,%eax
c0101d0a:	c1 e8 05             	shr    $0x5,%eax
c0101d0d:	6b d0 64             	imul   $0x64,%eax,%edx
c0101d10:	89 c8                	mov    %ecx,%eax
c0101d12:	29 d0                	sub    %edx,%eax
c0101d14:	85 c0                	test   %eax,%eax
c0101d16:	0f 85 a2 00 00 00    	jne    c0101dbe <trap_dispatch+0x11f>
            print_ticks();
c0101d1c:	e8 8f fb ff ff       	call   c01018b0 <print_ticks>
        }
        break;
c0101d21:	e9 98 00 00 00       	jmp    c0101dbe <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d26:	e8 30 f9 ff ff       	call   c010165b <cons_getc>
c0101d2b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d2e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d32:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d36:	83 ec 04             	sub    $0x4,%esp
c0101d39:	52                   	push   %edx
c0101d3a:	50                   	push   %eax
c0101d3b:	68 94 5f 10 c0       	push   $0xc0105f94
c0101d40:	e8 ec e5 ff ff       	call   c0100331 <cprintf>
c0101d45:	83 c4 10             	add    $0x10,%esp
        break;
c0101d48:	eb 75                	jmp    c0101dbf <trap_dispatch+0x120>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d4a:	e8 0c f9 ff ff       	call   c010165b <cons_getc>
c0101d4f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d52:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d56:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d5a:	83 ec 04             	sub    $0x4,%esp
c0101d5d:	52                   	push   %edx
c0101d5e:	50                   	push   %eax
c0101d5f:	68 a6 5f 10 c0       	push   $0xc0105fa6
c0101d64:	e8 c8 e5 ff ff       	call   c0100331 <cprintf>
c0101d69:	83 c4 10             	add    $0x10,%esp
        break;
c0101d6c:	eb 51                	jmp    c0101dbf <trap_dispatch+0x120>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d6e:	83 ec 04             	sub    $0x4,%esp
c0101d71:	68 b5 5f 10 c0       	push   $0xc0105fb5
c0101d76:	68 ac 00 00 00       	push   $0xac
c0101d7b:	68 c5 5f 10 c0       	push   $0xc0105fc5
c0101d80:	e8 0b ef ff ff       	call   c0100c90 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d8c:	0f b7 c0             	movzwl %ax,%eax
c0101d8f:	83 e0 03             	and    $0x3,%eax
c0101d92:	85 c0                	test   %eax,%eax
c0101d94:	75 29                	jne    c0101dbf <trap_dispatch+0x120>
            print_trapframe(tf);
c0101d96:	83 ec 0c             	sub    $0xc,%esp
c0101d99:	ff 75 08             	push   0x8(%ebp)
c0101d9c:	e8 65 fc ff ff       	call   c0101a06 <print_trapframe>
c0101da1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101da4:	83 ec 04             	sub    $0x4,%esp
c0101da7:	68 d6 5f 10 c0       	push   $0xc0105fd6
c0101dac:	68 b6 00 00 00       	push   $0xb6
c0101db1:	68 c5 5f 10 c0       	push   $0xc0105fc5
c0101db6:	e8 d5 ee ff ff       	call   c0100c90 <__panic>
        break;
c0101dbb:	90                   	nop
c0101dbc:	eb 01                	jmp    c0101dbf <trap_dispatch+0x120>
        break;
c0101dbe:	90                   	nop
        }
    }
}
c0101dbf:	90                   	nop
c0101dc0:	c9                   	leave  
c0101dc1:	c3                   	ret    

c0101dc2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101dc2:	55                   	push   %ebp
c0101dc3:	89 e5                	mov    %esp,%ebp
c0101dc5:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dc8:	83 ec 0c             	sub    $0xc,%esp
c0101dcb:	ff 75 08             	push   0x8(%ebp)
c0101dce:	e8 cc fe ff ff       	call   c0101c9f <trap_dispatch>
c0101dd3:	83 c4 10             	add    $0x10,%esp
}
c0101dd6:	90                   	nop
c0101dd7:	c9                   	leave  
c0101dd8:	c3                   	ret    

c0101dd9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101dd9:	1e                   	push   %ds
    pushl %es
c0101dda:	06                   	push   %es
    pushl %fs
c0101ddb:	0f a0                	push   %fs
    pushl %gs
c0101ddd:	0f a8                	push   %gs
    pushal
c0101ddf:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101de0:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101de5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101de7:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101de9:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101dea:	e8 d3 ff ff ff       	call   c0101dc2 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101def:	5c                   	pop    %esp

c0101df0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101df0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101df1:	0f a9                	pop    %gs
    popl %fs
c0101df3:	0f a1                	pop    %fs
    popl %es
c0101df5:	07                   	pop    %es
    popl %ds
c0101df6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101df7:	83 c4 08             	add    $0x8,%esp
    iret
c0101dfa:	cf                   	iret   

c0101dfb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dfb:	6a 00                	push   $0x0
  pushl $0
c0101dfd:	6a 00                	push   $0x0
  jmp __alltraps
c0101dff:	e9 d5 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e04 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e04:	6a 00                	push   $0x0
  pushl $1
c0101e06:	6a 01                	push   $0x1
  jmp __alltraps
c0101e08:	e9 cc ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e0d <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e0d:	6a 00                	push   $0x0
  pushl $2
c0101e0f:	6a 02                	push   $0x2
  jmp __alltraps
c0101e11:	e9 c3 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e16 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $3
c0101e18:	6a 03                	push   $0x3
  jmp __alltraps
c0101e1a:	e9 ba ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e1f <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $4
c0101e21:	6a 04                	push   $0x4
  jmp __alltraps
c0101e23:	e9 b1 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e28 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e28:	6a 00                	push   $0x0
  pushl $5
c0101e2a:	6a 05                	push   $0x5
  jmp __alltraps
c0101e2c:	e9 a8 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e31 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e31:	6a 00                	push   $0x0
  pushl $6
c0101e33:	6a 06                	push   $0x6
  jmp __alltraps
c0101e35:	e9 9f ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e3a <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e3a:	6a 00                	push   $0x0
  pushl $7
c0101e3c:	6a 07                	push   $0x7
  jmp __alltraps
c0101e3e:	e9 96 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e43 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e43:	6a 08                	push   $0x8
  jmp __alltraps
c0101e45:	e9 8f ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e4a <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e4a:	6a 09                	push   $0x9
  jmp __alltraps
c0101e4c:	e9 88 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e51 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e51:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e53:	e9 81 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e58 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e58:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e5a:	e9 7a ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e5f <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e5f:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e61:	e9 73 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e66 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e66:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e68:	e9 6c ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e6d <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e6d:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e6f:	e9 65 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e74 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e74:	6a 00                	push   $0x0
  pushl $15
c0101e76:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e78:	e9 5c ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e7d <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e7d:	6a 00                	push   $0x0
  pushl $16
c0101e7f:	6a 10                	push   $0x10
  jmp __alltraps
c0101e81:	e9 53 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e86 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e86:	6a 11                	push   $0x11
  jmp __alltraps
c0101e88:	e9 4c ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e8d <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $18
c0101e8f:	6a 12                	push   $0x12
  jmp __alltraps
c0101e91:	e9 43 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e96 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $19
c0101e98:	6a 13                	push   $0x13
  jmp __alltraps
c0101e9a:	e9 3a ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101e9f <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e9f:	6a 00                	push   $0x0
  pushl $20
c0101ea1:	6a 14                	push   $0x14
  jmp __alltraps
c0101ea3:	e9 31 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101ea8 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $21
c0101eaa:	6a 15                	push   $0x15
  jmp __alltraps
c0101eac:	e9 28 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101eb1 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $22
c0101eb3:	6a 16                	push   $0x16
  jmp __alltraps
c0101eb5:	e9 1f ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101eba <vector23>:
.globl vector23
vector23:
  pushl $0
c0101eba:	6a 00                	push   $0x0
  pushl $23
c0101ebc:	6a 17                	push   $0x17
  jmp __alltraps
c0101ebe:	e9 16 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101ec3 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $24
c0101ec5:	6a 18                	push   $0x18
  jmp __alltraps
c0101ec7:	e9 0d ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101ecc <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ecc:	6a 00                	push   $0x0
  pushl $25
c0101ece:	6a 19                	push   $0x19
  jmp __alltraps
c0101ed0:	e9 04 ff ff ff       	jmp    c0101dd9 <__alltraps>

c0101ed5 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ed5:	6a 00                	push   $0x0
  pushl $26
c0101ed7:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ed9:	e9 fb fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101ede <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ede:	6a 00                	push   $0x0
  pushl $27
c0101ee0:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ee2:	e9 f2 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101ee7 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ee7:	6a 00                	push   $0x0
  pushl $28
c0101ee9:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101eeb:	e9 e9 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101ef0 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ef0:	6a 00                	push   $0x0
  pushl $29
c0101ef2:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ef4:	e9 e0 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101ef9 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ef9:	6a 00                	push   $0x0
  pushl $30
c0101efb:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101efd:	e9 d7 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f02 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f02:	6a 00                	push   $0x0
  pushl $31
c0101f04:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f06:	e9 ce fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f0b <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f0b:	6a 00                	push   $0x0
  pushl $32
c0101f0d:	6a 20                	push   $0x20
  jmp __alltraps
c0101f0f:	e9 c5 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f14 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f14:	6a 00                	push   $0x0
  pushl $33
c0101f16:	6a 21                	push   $0x21
  jmp __alltraps
c0101f18:	e9 bc fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f1d <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $34
c0101f1f:	6a 22                	push   $0x22
  jmp __alltraps
c0101f21:	e9 b3 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f26 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $35
c0101f28:	6a 23                	push   $0x23
  jmp __alltraps
c0101f2a:	e9 aa fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f2f <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f2f:	6a 00                	push   $0x0
  pushl $36
c0101f31:	6a 24                	push   $0x24
  jmp __alltraps
c0101f33:	e9 a1 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f38 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $37
c0101f3a:	6a 25                	push   $0x25
  jmp __alltraps
c0101f3c:	e9 98 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f41 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $38
c0101f43:	6a 26                	push   $0x26
  jmp __alltraps
c0101f45:	e9 8f fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f4a <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $39
c0101f4c:	6a 27                	push   $0x27
  jmp __alltraps
c0101f4e:	e9 86 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f53 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $40
c0101f55:	6a 28                	push   $0x28
  jmp __alltraps
c0101f57:	e9 7d fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f5c <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f5c:	6a 00                	push   $0x0
  pushl $41
c0101f5e:	6a 29                	push   $0x29
  jmp __alltraps
c0101f60:	e9 74 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f65 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $42
c0101f67:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f69:	e9 6b fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f6e <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $43
c0101f70:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f72:	e9 62 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f77 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $44
c0101f79:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f7b:	e9 59 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f80 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f80:	6a 00                	push   $0x0
  pushl $45
c0101f82:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f84:	e9 50 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f89 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $46
c0101f8b:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f8d:	e9 47 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f92 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $47
c0101f94:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f96:	e9 3e fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101f9b <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f9b:	6a 00                	push   $0x0
  pushl $48
c0101f9d:	6a 30                	push   $0x30
  jmp __alltraps
c0101f9f:	e9 35 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fa4 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $49
c0101fa6:	6a 31                	push   $0x31
  jmp __alltraps
c0101fa8:	e9 2c fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fad <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $50
c0101faf:	6a 32                	push   $0x32
  jmp __alltraps
c0101fb1:	e9 23 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fb6 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $51
c0101fb8:	6a 33                	push   $0x33
  jmp __alltraps
c0101fba:	e9 1a fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fbf <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $52
c0101fc1:	6a 34                	push   $0x34
  jmp __alltraps
c0101fc3:	e9 11 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fc8 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $53
c0101fca:	6a 35                	push   $0x35
  jmp __alltraps
c0101fcc:	e9 08 fe ff ff       	jmp    c0101dd9 <__alltraps>

c0101fd1 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $54
c0101fd3:	6a 36                	push   $0x36
  jmp __alltraps
c0101fd5:	e9 ff fd ff ff       	jmp    c0101dd9 <__alltraps>

c0101fda <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $55
c0101fdc:	6a 37                	push   $0x37
  jmp __alltraps
c0101fde:	e9 f6 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0101fe3 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $56
c0101fe5:	6a 38                	push   $0x38
  jmp __alltraps
c0101fe7:	e9 ed fd ff ff       	jmp    c0101dd9 <__alltraps>

c0101fec <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $57
c0101fee:	6a 39                	push   $0x39
  jmp __alltraps
c0101ff0:	e9 e4 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0101ff5 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $58
c0101ff7:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101ff9:	e9 db fd ff ff       	jmp    c0101dd9 <__alltraps>

c0101ffe <vector59>:
.globl vector59
vector59:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $59
c0102000:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102002:	e9 d2 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102007 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $60
c0102009:	6a 3c                	push   $0x3c
  jmp __alltraps
c010200b:	e9 c9 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102010 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $61
c0102012:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102014:	e9 c0 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102019 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $62
c010201b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010201d:	e9 b7 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102022 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $63
c0102024:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102026:	e9 ae fd ff ff       	jmp    c0101dd9 <__alltraps>

c010202b <vector64>:
.globl vector64
vector64:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $64
c010202d:	6a 40                	push   $0x40
  jmp __alltraps
c010202f:	e9 a5 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102034 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $65
c0102036:	6a 41                	push   $0x41
  jmp __alltraps
c0102038:	e9 9c fd ff ff       	jmp    c0101dd9 <__alltraps>

c010203d <vector66>:
.globl vector66
vector66:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $66
c010203f:	6a 42                	push   $0x42
  jmp __alltraps
c0102041:	e9 93 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102046 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $67
c0102048:	6a 43                	push   $0x43
  jmp __alltraps
c010204a:	e9 8a fd ff ff       	jmp    c0101dd9 <__alltraps>

c010204f <vector68>:
.globl vector68
vector68:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $68
c0102051:	6a 44                	push   $0x44
  jmp __alltraps
c0102053:	e9 81 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102058 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $69
c010205a:	6a 45                	push   $0x45
  jmp __alltraps
c010205c:	e9 78 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102061 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $70
c0102063:	6a 46                	push   $0x46
  jmp __alltraps
c0102065:	e9 6f fd ff ff       	jmp    c0101dd9 <__alltraps>

c010206a <vector71>:
.globl vector71
vector71:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $71
c010206c:	6a 47                	push   $0x47
  jmp __alltraps
c010206e:	e9 66 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102073 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $72
c0102075:	6a 48                	push   $0x48
  jmp __alltraps
c0102077:	e9 5d fd ff ff       	jmp    c0101dd9 <__alltraps>

c010207c <vector73>:
.globl vector73
vector73:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $73
c010207e:	6a 49                	push   $0x49
  jmp __alltraps
c0102080:	e9 54 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102085 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $74
c0102087:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102089:	e9 4b fd ff ff       	jmp    c0101dd9 <__alltraps>

c010208e <vector75>:
.globl vector75
vector75:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $75
c0102090:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102092:	e9 42 fd ff ff       	jmp    c0101dd9 <__alltraps>

c0102097 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $76
c0102099:	6a 4c                	push   $0x4c
  jmp __alltraps
c010209b:	e9 39 fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020a0 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $77
c01020a2:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020a4:	e9 30 fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020a9 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $78
c01020ab:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020ad:	e9 27 fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020b2 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $79
c01020b4:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020b6:	e9 1e fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020bb <vector80>:
.globl vector80
vector80:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $80
c01020bd:	6a 50                	push   $0x50
  jmp __alltraps
c01020bf:	e9 15 fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020c4 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $81
c01020c6:	6a 51                	push   $0x51
  jmp __alltraps
c01020c8:	e9 0c fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020cd <vector82>:
.globl vector82
vector82:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $82
c01020cf:	6a 52                	push   $0x52
  jmp __alltraps
c01020d1:	e9 03 fd ff ff       	jmp    c0101dd9 <__alltraps>

c01020d6 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $83
c01020d8:	6a 53                	push   $0x53
  jmp __alltraps
c01020da:	e9 fa fc ff ff       	jmp    c0101dd9 <__alltraps>

c01020df <vector84>:
.globl vector84
vector84:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $84
c01020e1:	6a 54                	push   $0x54
  jmp __alltraps
c01020e3:	e9 f1 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01020e8 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $85
c01020ea:	6a 55                	push   $0x55
  jmp __alltraps
c01020ec:	e9 e8 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01020f1 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $86
c01020f3:	6a 56                	push   $0x56
  jmp __alltraps
c01020f5:	e9 df fc ff ff       	jmp    c0101dd9 <__alltraps>

c01020fa <vector87>:
.globl vector87
vector87:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $87
c01020fc:	6a 57                	push   $0x57
  jmp __alltraps
c01020fe:	e9 d6 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102103 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $88
c0102105:	6a 58                	push   $0x58
  jmp __alltraps
c0102107:	e9 cd fc ff ff       	jmp    c0101dd9 <__alltraps>

c010210c <vector89>:
.globl vector89
vector89:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $89
c010210e:	6a 59                	push   $0x59
  jmp __alltraps
c0102110:	e9 c4 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102115 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $90
c0102117:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102119:	e9 bb fc ff ff       	jmp    c0101dd9 <__alltraps>

c010211e <vector91>:
.globl vector91
vector91:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $91
c0102120:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102122:	e9 b2 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102127 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $92
c0102129:	6a 5c                	push   $0x5c
  jmp __alltraps
c010212b:	e9 a9 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102130 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $93
c0102132:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102134:	e9 a0 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102139 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $94
c010213b:	6a 5e                	push   $0x5e
  jmp __alltraps
c010213d:	e9 97 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102142 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $95
c0102144:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102146:	e9 8e fc ff ff       	jmp    c0101dd9 <__alltraps>

c010214b <vector96>:
.globl vector96
vector96:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $96
c010214d:	6a 60                	push   $0x60
  jmp __alltraps
c010214f:	e9 85 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102154 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $97
c0102156:	6a 61                	push   $0x61
  jmp __alltraps
c0102158:	e9 7c fc ff ff       	jmp    c0101dd9 <__alltraps>

c010215d <vector98>:
.globl vector98
vector98:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $98
c010215f:	6a 62                	push   $0x62
  jmp __alltraps
c0102161:	e9 73 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102166 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $99
c0102168:	6a 63                	push   $0x63
  jmp __alltraps
c010216a:	e9 6a fc ff ff       	jmp    c0101dd9 <__alltraps>

c010216f <vector100>:
.globl vector100
vector100:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $100
c0102171:	6a 64                	push   $0x64
  jmp __alltraps
c0102173:	e9 61 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102178 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $101
c010217a:	6a 65                	push   $0x65
  jmp __alltraps
c010217c:	e9 58 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102181 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $102
c0102183:	6a 66                	push   $0x66
  jmp __alltraps
c0102185:	e9 4f fc ff ff       	jmp    c0101dd9 <__alltraps>

c010218a <vector103>:
.globl vector103
vector103:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $103
c010218c:	6a 67                	push   $0x67
  jmp __alltraps
c010218e:	e9 46 fc ff ff       	jmp    c0101dd9 <__alltraps>

c0102193 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $104
c0102195:	6a 68                	push   $0x68
  jmp __alltraps
c0102197:	e9 3d fc ff ff       	jmp    c0101dd9 <__alltraps>

c010219c <vector105>:
.globl vector105
vector105:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $105
c010219e:	6a 69                	push   $0x69
  jmp __alltraps
c01021a0:	e9 34 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021a5 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $106
c01021a7:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021a9:	e9 2b fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021ae <vector107>:
.globl vector107
vector107:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $107
c01021b0:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021b2:	e9 22 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021b7 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $108
c01021b9:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021bb:	e9 19 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021c0 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $109
c01021c2:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021c4:	e9 10 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021c9 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $110
c01021cb:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021cd:	e9 07 fc ff ff       	jmp    c0101dd9 <__alltraps>

c01021d2 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $111
c01021d4:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021d6:	e9 fe fb ff ff       	jmp    c0101dd9 <__alltraps>

c01021db <vector112>:
.globl vector112
vector112:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $112
c01021dd:	6a 70                	push   $0x70
  jmp __alltraps
c01021df:	e9 f5 fb ff ff       	jmp    c0101dd9 <__alltraps>

c01021e4 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $113
c01021e6:	6a 71                	push   $0x71
  jmp __alltraps
c01021e8:	e9 ec fb ff ff       	jmp    c0101dd9 <__alltraps>

c01021ed <vector114>:
.globl vector114
vector114:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $114
c01021ef:	6a 72                	push   $0x72
  jmp __alltraps
c01021f1:	e9 e3 fb ff ff       	jmp    c0101dd9 <__alltraps>

c01021f6 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $115
c01021f8:	6a 73                	push   $0x73
  jmp __alltraps
c01021fa:	e9 da fb ff ff       	jmp    c0101dd9 <__alltraps>

c01021ff <vector116>:
.globl vector116
vector116:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $116
c0102201:	6a 74                	push   $0x74
  jmp __alltraps
c0102203:	e9 d1 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102208 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $117
c010220a:	6a 75                	push   $0x75
  jmp __alltraps
c010220c:	e9 c8 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102211 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $118
c0102213:	6a 76                	push   $0x76
  jmp __alltraps
c0102215:	e9 bf fb ff ff       	jmp    c0101dd9 <__alltraps>

c010221a <vector119>:
.globl vector119
vector119:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $119
c010221c:	6a 77                	push   $0x77
  jmp __alltraps
c010221e:	e9 b6 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102223 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $120
c0102225:	6a 78                	push   $0x78
  jmp __alltraps
c0102227:	e9 ad fb ff ff       	jmp    c0101dd9 <__alltraps>

c010222c <vector121>:
.globl vector121
vector121:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $121
c010222e:	6a 79                	push   $0x79
  jmp __alltraps
c0102230:	e9 a4 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102235 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $122
c0102237:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102239:	e9 9b fb ff ff       	jmp    c0101dd9 <__alltraps>

c010223e <vector123>:
.globl vector123
vector123:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $123
c0102240:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102242:	e9 92 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102247 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $124
c0102249:	6a 7c                	push   $0x7c
  jmp __alltraps
c010224b:	e9 89 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102250 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $125
c0102252:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102254:	e9 80 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102259 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $126
c010225b:	6a 7e                	push   $0x7e
  jmp __alltraps
c010225d:	e9 77 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102262 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $127
c0102264:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102266:	e9 6e fb ff ff       	jmp    c0101dd9 <__alltraps>

c010226b <vector128>:
.globl vector128
vector128:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $128
c010226d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102272:	e9 62 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102277 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102277:	6a 00                	push   $0x0
  pushl $129
c0102279:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010227e:	e9 56 fb ff ff       	jmp    c0101dd9 <__alltraps>

c0102283 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $130
c0102285:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010228a:	e9 4a fb ff ff       	jmp    c0101dd9 <__alltraps>

c010228f <vector131>:
.globl vector131
vector131:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $131
c0102291:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102296:	e9 3e fb ff ff       	jmp    c0101dd9 <__alltraps>

c010229b <vector132>:
.globl vector132
vector132:
  pushl $0
c010229b:	6a 00                	push   $0x0
  pushl $132
c010229d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022a2:	e9 32 fb ff ff       	jmp    c0101dd9 <__alltraps>

c01022a7 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $133
c01022a9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022ae:	e9 26 fb ff ff       	jmp    c0101dd9 <__alltraps>

c01022b3 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $134
c01022b5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022ba:	e9 1a fb ff ff       	jmp    c0101dd9 <__alltraps>

c01022bf <vector135>:
.globl vector135
vector135:
  pushl $0
c01022bf:	6a 00                	push   $0x0
  pushl $135
c01022c1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022c6:	e9 0e fb ff ff       	jmp    c0101dd9 <__alltraps>

c01022cb <vector136>:
.globl vector136
vector136:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $136
c01022cd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022d2:	e9 02 fb ff ff       	jmp    c0101dd9 <__alltraps>

c01022d7 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $137
c01022d9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022de:	e9 f6 fa ff ff       	jmp    c0101dd9 <__alltraps>

c01022e3 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022e3:	6a 00                	push   $0x0
  pushl $138
c01022e5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022ea:	e9 ea fa ff ff       	jmp    c0101dd9 <__alltraps>

c01022ef <vector139>:
.globl vector139
vector139:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $139
c01022f1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022f6:	e9 de fa ff ff       	jmp    c0101dd9 <__alltraps>

c01022fb <vector140>:
.globl vector140
vector140:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $140
c01022fd:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102302:	e9 d2 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102307 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102307:	6a 00                	push   $0x0
  pushl $141
c0102309:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010230e:	e9 c6 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102313 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $142
c0102315:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010231a:	e9 ba fa ff ff       	jmp    c0101dd9 <__alltraps>

c010231f <vector143>:
.globl vector143
vector143:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $143
c0102321:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102326:	e9 ae fa ff ff       	jmp    c0101dd9 <__alltraps>

c010232b <vector144>:
.globl vector144
vector144:
  pushl $0
c010232b:	6a 00                	push   $0x0
  pushl $144
c010232d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102332:	e9 a2 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102337 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $145
c0102339:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010233e:	e9 96 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102343 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $146
c0102345:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010234a:	e9 8a fa ff ff       	jmp    c0101dd9 <__alltraps>

c010234f <vector147>:
.globl vector147
vector147:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $147
c0102351:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102356:	e9 7e fa ff ff       	jmp    c0101dd9 <__alltraps>

c010235b <vector148>:
.globl vector148
vector148:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $148
c010235d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102362:	e9 72 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102367 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $149
c0102369:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010236e:	e9 66 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102373 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $150
c0102375:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010237a:	e9 5a fa ff ff       	jmp    c0101dd9 <__alltraps>

c010237f <vector151>:
.globl vector151
vector151:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $151
c0102381:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102386:	e9 4e fa ff ff       	jmp    c0101dd9 <__alltraps>

c010238b <vector152>:
.globl vector152
vector152:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $152
c010238d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102392:	e9 42 fa ff ff       	jmp    c0101dd9 <__alltraps>

c0102397 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $153
c0102399:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010239e:	e9 36 fa ff ff       	jmp    c0101dd9 <__alltraps>

c01023a3 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $154
c01023a5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023aa:	e9 2a fa ff ff       	jmp    c0101dd9 <__alltraps>

c01023af <vector155>:
.globl vector155
vector155:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $155
c01023b1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023b6:	e9 1e fa ff ff       	jmp    c0101dd9 <__alltraps>

c01023bb <vector156>:
.globl vector156
vector156:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $156
c01023bd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023c2:	e9 12 fa ff ff       	jmp    c0101dd9 <__alltraps>

c01023c7 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $157
c01023c9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023ce:	e9 06 fa ff ff       	jmp    c0101dd9 <__alltraps>

c01023d3 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $158
c01023d5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023da:	e9 fa f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01023df <vector159>:
.globl vector159
vector159:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $159
c01023e1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023e6:	e9 ee f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01023eb <vector160>:
.globl vector160
vector160:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $160
c01023ed:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023f2:	e9 e2 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01023f7 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $161
c01023f9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023fe:	e9 d6 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102403 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $162
c0102405:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010240a:	e9 ca f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010240f <vector163>:
.globl vector163
vector163:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $163
c0102411:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102416:	e9 be f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010241b <vector164>:
.globl vector164
vector164:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $164
c010241d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102422:	e9 b2 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102427 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $165
c0102429:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010242e:	e9 a6 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102433 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $166
c0102435:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010243a:	e9 9a f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010243f <vector167>:
.globl vector167
vector167:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $167
c0102441:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102446:	e9 8e f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010244b <vector168>:
.globl vector168
vector168:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $168
c010244d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102452:	e9 82 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102457 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $169
c0102459:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010245e:	e9 76 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102463 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $170
c0102465:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010246a:	e9 6a f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010246f <vector171>:
.globl vector171
vector171:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $171
c0102471:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102476:	e9 5e f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010247b <vector172>:
.globl vector172
vector172:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $172
c010247d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102482:	e9 52 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102487 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $173
c0102489:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010248e:	e9 46 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c0102493 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $174
c0102495:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010249a:	e9 3a f9 ff ff       	jmp    c0101dd9 <__alltraps>

c010249f <vector175>:
.globl vector175
vector175:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $175
c01024a1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024a6:	e9 2e f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01024ab <vector176>:
.globl vector176
vector176:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $176
c01024ad:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024b2:	e9 22 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01024b7 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $177
c01024b9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024be:	e9 16 f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01024c3 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $178
c01024c5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024ca:	e9 0a f9 ff ff       	jmp    c0101dd9 <__alltraps>

c01024cf <vector179>:
.globl vector179
vector179:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $179
c01024d1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024d6:	e9 fe f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01024db <vector180>:
.globl vector180
vector180:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $180
c01024dd:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024e2:	e9 f2 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01024e7 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $181
c01024e9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024ee:	e9 e6 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01024f3 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $182
c01024f5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024fa:	e9 da f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01024ff <vector183>:
.globl vector183
vector183:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $183
c0102501:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102506:	e9 ce f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010250b <vector184>:
.globl vector184
vector184:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $184
c010250d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102512:	e9 c2 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102517 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $185
c0102519:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010251e:	e9 b6 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102523 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $186
c0102525:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010252a:	e9 aa f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010252f <vector187>:
.globl vector187
vector187:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $187
c0102531:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102536:	e9 9e f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010253b <vector188>:
.globl vector188
vector188:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $188
c010253d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102542:	e9 92 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102547 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $189
c0102549:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010254e:	e9 86 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102553 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $190
c0102555:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010255a:	e9 7a f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010255f <vector191>:
.globl vector191
vector191:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $191
c0102561:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102566:	e9 6e f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010256b <vector192>:
.globl vector192
vector192:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $192
c010256d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102572:	e9 62 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102577 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $193
c0102579:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010257e:	e9 56 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c0102583 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $194
c0102585:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010258a:	e9 4a f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010258f <vector195>:
.globl vector195
vector195:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $195
c0102591:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102596:	e9 3e f8 ff ff       	jmp    c0101dd9 <__alltraps>

c010259b <vector196>:
.globl vector196
vector196:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $196
c010259d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025a2:	e9 32 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01025a7 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $197
c01025a9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025ae:	e9 26 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01025b3 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $198
c01025b5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025ba:	e9 1a f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01025bf <vector199>:
.globl vector199
vector199:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $199
c01025c1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025c6:	e9 0e f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01025cb <vector200>:
.globl vector200
vector200:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $200
c01025cd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025d2:	e9 02 f8 ff ff       	jmp    c0101dd9 <__alltraps>

c01025d7 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $201
c01025d9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025de:	e9 f6 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01025e3 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $202
c01025e5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025ea:	e9 ea f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01025ef <vector203>:
.globl vector203
vector203:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $203
c01025f1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025f6:	e9 de f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01025fb <vector204>:
.globl vector204
vector204:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $204
c01025fd:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102602:	e9 d2 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102607 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $205
c0102609:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010260e:	e9 c6 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102613 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $206
c0102615:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010261a:	e9 ba f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010261f <vector207>:
.globl vector207
vector207:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $207
c0102621:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102626:	e9 ae f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010262b <vector208>:
.globl vector208
vector208:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $208
c010262d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102632:	e9 a2 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102637 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $209
c0102639:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010263e:	e9 96 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102643 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $210
c0102645:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010264a:	e9 8a f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010264f <vector211>:
.globl vector211
vector211:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $211
c0102651:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102656:	e9 7e f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010265b <vector212>:
.globl vector212
vector212:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $212
c010265d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102662:	e9 72 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102667 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $213
c0102669:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010266e:	e9 66 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102673 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $214
c0102675:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010267a:	e9 5a f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010267f <vector215>:
.globl vector215
vector215:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $215
c0102681:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102686:	e9 4e f7 ff ff       	jmp    c0101dd9 <__alltraps>

c010268b <vector216>:
.globl vector216
vector216:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $216
c010268d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102692:	e9 42 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c0102697 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $217
c0102699:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010269e:	e9 36 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01026a3 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $218
c01026a5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026aa:	e9 2a f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01026af <vector219>:
.globl vector219
vector219:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $219
c01026b1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026b6:	e9 1e f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01026bb <vector220>:
.globl vector220
vector220:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $220
c01026bd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026c2:	e9 12 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01026c7 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $221
c01026c9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026ce:	e9 06 f7 ff ff       	jmp    c0101dd9 <__alltraps>

c01026d3 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $222
c01026d5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026da:	e9 fa f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01026df <vector223>:
.globl vector223
vector223:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $223
c01026e1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026e6:	e9 ee f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01026eb <vector224>:
.globl vector224
vector224:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $224
c01026ed:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026f2:	e9 e2 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01026f7 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $225
c01026f9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026fe:	e9 d6 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102703 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $226
c0102705:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010270a:	e9 ca f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010270f <vector227>:
.globl vector227
vector227:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $227
c0102711:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102716:	e9 be f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010271b <vector228>:
.globl vector228
vector228:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $228
c010271d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102722:	e9 b2 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102727 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $229
c0102729:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010272e:	e9 a6 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102733 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $230
c0102735:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010273a:	e9 9a f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010273f <vector231>:
.globl vector231
vector231:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $231
c0102741:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102746:	e9 8e f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010274b <vector232>:
.globl vector232
vector232:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $232
c010274d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102752:	e9 82 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102757 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $233
c0102759:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010275e:	e9 76 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102763 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $234
c0102765:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010276a:	e9 6a f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010276f <vector235>:
.globl vector235
vector235:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $235
c0102771:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102776:	e9 5e f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010277b <vector236>:
.globl vector236
vector236:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $236
c010277d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102782:	e9 52 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102787 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $237
c0102789:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010278e:	e9 46 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c0102793 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $238
c0102795:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010279a:	e9 3a f6 ff ff       	jmp    c0101dd9 <__alltraps>

c010279f <vector239>:
.globl vector239
vector239:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $239
c01027a1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027a6:	e9 2e f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01027ab <vector240>:
.globl vector240
vector240:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $240
c01027ad:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027b2:	e9 22 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01027b7 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $241
c01027b9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027be:	e9 16 f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01027c3 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $242
c01027c5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027ca:	e9 0a f6 ff ff       	jmp    c0101dd9 <__alltraps>

c01027cf <vector243>:
.globl vector243
vector243:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $243
c01027d1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027d6:	e9 fe f5 ff ff       	jmp    c0101dd9 <__alltraps>

c01027db <vector244>:
.globl vector244
vector244:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $244
c01027dd:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027e2:	e9 f2 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c01027e7 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $245
c01027e9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027ee:	e9 e6 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c01027f3 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $246
c01027f5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027fa:	e9 da f5 ff ff       	jmp    c0101dd9 <__alltraps>

c01027ff <vector247>:
.globl vector247
vector247:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $247
c0102801:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102806:	e9 ce f5 ff ff       	jmp    c0101dd9 <__alltraps>

c010280b <vector248>:
.globl vector248
vector248:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $248
c010280d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102812:	e9 c2 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c0102817 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $249
c0102819:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010281e:	e9 b6 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c0102823 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $250
c0102825:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010282a:	e9 aa f5 ff ff       	jmp    c0101dd9 <__alltraps>

c010282f <vector251>:
.globl vector251
vector251:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $251
c0102831:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102836:	e9 9e f5 ff ff       	jmp    c0101dd9 <__alltraps>

c010283b <vector252>:
.globl vector252
vector252:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $252
c010283d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102842:	e9 92 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c0102847 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $253
c0102849:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010284e:	e9 86 f5 ff ff       	jmp    c0101dd9 <__alltraps>

c0102853 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $254
c0102855:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010285a:	e9 7a f5 ff ff       	jmp    c0101dd9 <__alltraps>

c010285f <vector255>:
.globl vector255
vector255:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $255
c0102861:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102866:	e9 6e f5 ff ff       	jmp    c0101dd9 <__alltraps>

c010286b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010286b:	55                   	push   %ebp
c010286c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010286e:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0102874:	8b 45 08             	mov    0x8(%ebp),%eax
c0102877:	29 d0                	sub    %edx,%eax
c0102879:	c1 f8 02             	sar    $0x2,%eax
c010287c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102882:	5d                   	pop    %ebp
c0102883:	c3                   	ret    

c0102884 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102884:	55                   	push   %ebp
c0102885:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102887:	ff 75 08             	push   0x8(%ebp)
c010288a:	e8 dc ff ff ff       	call   c010286b <page2ppn>
c010288f:	83 c4 04             	add    $0x4,%esp
c0102892:	c1 e0 0c             	shl    $0xc,%eax
}
c0102895:	c9                   	leave  
c0102896:	c3                   	ret    

c0102897 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102897:	55                   	push   %ebp
c0102898:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010289a:	8b 45 08             	mov    0x8(%ebp),%eax
c010289d:	8b 00                	mov    (%eax),%eax
}
c010289f:	5d                   	pop    %ebp
c01028a0:	c3                   	ret    

c01028a1 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028a1:	55                   	push   %ebp
c01028a2:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028a7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028aa:	89 10                	mov    %edx,(%eax)
}
c01028ac:	90                   	nop
c01028ad:	5d                   	pop    %ebp
c01028ae:	c3                   	ret    

c01028af <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028af:	55                   	push   %ebp
c01028b0:	89 e5                	mov    %esp,%ebp
c01028b2:	83 ec 10             	sub    $0x10,%esp
c01028b5:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028c2:	89 50 04             	mov    %edx,0x4(%eax)
c01028c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028c8:	8b 50 04             	mov    0x4(%eax),%edx
c01028cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ce:	89 10                	mov    %edx,(%eax)
}
c01028d0:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01028d1:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01028d8:	00 00 00 
}
c01028db:	90                   	nop
c01028dc:	c9                   	leave  
c01028dd:	c3                   	ret    

c01028de <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028de:	55                   	push   %ebp
c01028df:	89 e5                	mov    %esp,%ebp
c01028e1:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c01028e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028e8:	75 16                	jne    c0102900 <default_init_memmap+0x22>
c01028ea:	68 90 61 10 c0       	push   $0xc0106190
c01028ef:	68 96 61 10 c0       	push   $0xc0106196
c01028f4:	6a 6d                	push   $0x6d
c01028f6:	68 ab 61 10 c0       	push   $0xc01061ab
c01028fb:	e8 90 e3 ff ff       	call   c0100c90 <__panic>
    struct Page *p = base;
c0102900:	8b 45 08             	mov    0x8(%ebp),%eax
c0102903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102906:	eb 6c                	jmp    c0102974 <default_init_memmap+0x96>
        assert(PageReserved(p));
c0102908:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010290b:	83 c0 04             	add    $0x4,%eax
c010290e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102915:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102918:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010291b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010291e:	0f a3 10             	bt     %edx,(%eax)
c0102921:	19 c0                	sbb    %eax,%eax
c0102923:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102926:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010292a:	0f 95 c0             	setne  %al
c010292d:	0f b6 c0             	movzbl %al,%eax
c0102930:	85 c0                	test   %eax,%eax
c0102932:	75 16                	jne    c010294a <default_init_memmap+0x6c>
c0102934:	68 c1 61 10 c0       	push   $0xc01061c1
c0102939:	68 96 61 10 c0       	push   $0xc0106196
c010293e:	6a 70                	push   $0x70
c0102940:	68 ab 61 10 c0       	push   $0xc01061ab
c0102945:	e8 46 e3 ff ff       	call   c0100c90 <__panic>
        p->flags = p->property = 0;
c010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102954:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102957:	8b 50 08             	mov    0x8(%eax),%edx
c010295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010295d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102960:	83 ec 08             	sub    $0x8,%esp
c0102963:	6a 00                	push   $0x0
c0102965:	ff 75 f4             	push   -0xc(%ebp)
c0102968:	e8 34 ff ff ff       	call   c01028a1 <set_page_ref>
c010296d:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0102970:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102974:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102977:	89 d0                	mov    %edx,%eax
c0102979:	c1 e0 02             	shl    $0x2,%eax
c010297c:	01 d0                	add    %edx,%eax
c010297e:	c1 e0 02             	shl    $0x2,%eax
c0102981:	89 c2                	mov    %eax,%edx
c0102983:	8b 45 08             	mov    0x8(%ebp),%eax
c0102986:	01 d0                	add    %edx,%eax
c0102988:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010298b:	0f 85 77 ff ff ff    	jne    c0102908 <default_init_memmap+0x2a>
    }
    base->property = n;
c0102991:	8b 45 08             	mov    0x8(%ebp),%eax
c0102994:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102997:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010299a:	8b 45 08             	mov    0x8(%ebp),%eax
c010299d:	83 c0 04             	add    $0x4,%eax
c01029a0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01029a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029ad:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029b0:	0f ab 10             	bts    %edx,(%eax)
}
c01029b3:	90                   	nop
    nr_free += n;
c01029b4:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c01029ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029bd:	01 d0                	add    %edx,%eax
c01029bf:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(&free_list, &(base->page_link));
c01029c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c7:	83 c0 0c             	add    $0xc,%eax
c01029ca:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c01029d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01029d7:	8b 00                	mov    (%eax),%eax
c01029d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01029dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01029df:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01029e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01029e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01029ee:	89 10                	mov    %edx,(%eax)
c01029f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029f3:	8b 10                	mov    (%eax),%edx
c01029f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029f8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a01:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a07:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a0a:	89 10                	mov    %edx,(%eax)
}
c0102a0c:	90                   	nop
}
c0102a0d:	90                   	nop
}
c0102a0e:	90                   	nop
c0102a0f:	c9                   	leave  
c0102a10:	c3                   	ret    

c0102a11 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a11:	55                   	push   %ebp
c0102a12:	89 e5                	mov    %esp,%ebp
c0102a14:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a1b:	75 16                	jne    c0102a33 <default_alloc_pages+0x22>
c0102a1d:	68 90 61 10 c0       	push   $0xc0106190
c0102a22:	68 96 61 10 c0       	push   $0xc0106196
c0102a27:	6a 7c                	push   $0x7c
c0102a29:	68 ab 61 10 c0       	push   $0xc01061ab
c0102a2e:	e8 5d e2 ff ff       	call   c0100c90 <__panic>
    if (n > nr_free) {
c0102a33:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102a38:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a3b:	76 0a                	jbe    c0102a47 <default_alloc_pages+0x36>
        return NULL;
c0102a3d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a42:	e9 43 01 00 00       	jmp    c0102b8a <default_alloc_pages+0x179>
    }
    struct Page *page = NULL;
c0102a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a4e:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a55:	eb 1c                	jmp    c0102a73 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0102a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a5a:	83 e8 0c             	sub    $0xc,%eax
c0102a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a63:	8b 40 08             	mov    0x8(%eax),%eax
c0102a66:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a69:	77 08                	ja     c0102a73 <default_alloc_pages+0x62>
            page = p;
c0102a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a71:	eb 18                	jmp    c0102a8b <default_alloc_pages+0x7a>
c0102a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a7c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a82:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102a89:	75 cc                	jne    c0102a57 <default_alloc_pages+0x46>
        }
    }
    if (page != NULL) {
c0102a8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a8f:	0f 84 f2 00 00 00    	je     c0102b87 <default_alloc_pages+0x176>
        if (page->property > n) {
c0102a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a98:	8b 40 08             	mov    0x8(%eax),%eax
c0102a9b:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a9e:	0f 83 8f 00 00 00    	jae    c0102b33 <default_alloc_pages+0x122>
            struct Page *p = page + n;
c0102aa4:	8b 55 08             	mov    0x8(%ebp),%edx
c0102aa7:	89 d0                	mov    %edx,%eax
c0102aa9:	c1 e0 02             	shl    $0x2,%eax
c0102aac:	01 d0                	add    %edx,%eax
c0102aae:	c1 e0 02             	shl    $0x2,%eax
c0102ab1:	89 c2                	mov    %eax,%edx
c0102ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab6:	01 d0                	add    %edx,%eax
c0102ab8:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abe:	8b 40 08             	mov    0x8(%eax),%eax
c0102ac1:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ac4:	89 c2                	mov    %eax,%edx
c0102ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ac9:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102acf:	83 c0 04             	add    $0x4,%eax
c0102ad2:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102ad9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102adc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102adf:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ae2:	0f ab 10             	bts    %edx,(%eax)
}
c0102ae5:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c0102ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ae9:	83 c0 0c             	add    $0xc,%eax
c0102aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102aef:	83 c2 0c             	add    $0xc,%edx
c0102af2:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0102af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102afb:	8b 40 04             	mov    0x4(%eax),%eax
c0102afe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b01:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102b04:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b07:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b0a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0102b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b10:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b13:	89 10                	mov    %edx,(%eax)
c0102b15:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b18:	8b 10                	mov    (%eax),%edx
c0102b1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b23:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b26:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b2f:	89 10                	mov    %edx,(%eax)
}
c0102b31:	90                   	nop
}
c0102b32:	90                   	nop
        }
        list_del(&(page->page_link));
c0102b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b36:	83 c0 0c             	add    $0xc,%eax
c0102b39:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102b3c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b3f:	8b 40 04             	mov    0x4(%eax),%eax
c0102b42:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b45:	8b 12                	mov    (%edx),%edx
c0102b47:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102b4a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b50:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b53:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b59:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b5c:	89 10                	mov    %edx,(%eax)
}
c0102b5e:	90                   	nop
}
c0102b5f:	90                   	nop
        nr_free -= n;
c0102b60:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102b65:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b68:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b70:	83 c0 04             	add    $0x4,%eax
c0102b73:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102b7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b80:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b83:	0f b3 10             	btr    %edx,(%eax)
}
c0102b86:	90                   	nop
    }
    return page;
c0102b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b8a:	c9                   	leave  
c0102b8b:	c3                   	ret    

c0102b8c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b8c:	55                   	push   %ebp
c0102b8d:	89 e5                	mov    %esp,%ebp
c0102b8f:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102b95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b99:	75 19                	jne    c0102bb4 <default_free_pages+0x28>
c0102b9b:	68 90 61 10 c0       	push   $0xc0106190
c0102ba0:	68 96 61 10 c0       	push   $0xc0106196
c0102ba5:	68 9a 00 00 00       	push   $0x9a
c0102baa:	68 ab 61 10 c0       	push   $0xc01061ab
c0102baf:	e8 dc e0 ff ff       	call   c0100c90 <__panic>
    struct Page *p = base;
c0102bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102bba:	e9 8f 00 00 00       	jmp    c0102c4e <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0102bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc2:	83 c0 04             	add    $0x4,%eax
c0102bc5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102bd5:	0f a3 10             	bt     %edx,(%eax)
c0102bd8:	19 c0                	sbb    %eax,%eax
c0102bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102be1:	0f 95 c0             	setne  %al
c0102be4:	0f b6 c0             	movzbl %al,%eax
c0102be7:	85 c0                	test   %eax,%eax
c0102be9:	75 2c                	jne    c0102c17 <default_free_pages+0x8b>
c0102beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bee:	83 c0 04             	add    $0x4,%eax
c0102bf1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102bf8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c01:	0f a3 10             	bt     %edx,(%eax)
c0102c04:	19 c0                	sbb    %eax,%eax
c0102c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c09:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c0d:	0f 95 c0             	setne  %al
c0102c10:	0f b6 c0             	movzbl %al,%eax
c0102c13:	85 c0                	test   %eax,%eax
c0102c15:	74 19                	je     c0102c30 <default_free_pages+0xa4>
c0102c17:	68 d4 61 10 c0       	push   $0xc01061d4
c0102c1c:	68 96 61 10 c0       	push   $0xc0106196
c0102c21:	68 9d 00 00 00       	push   $0x9d
c0102c26:	68 ab 61 10 c0       	push   $0xc01061ab
c0102c2b:	e8 60 e0 ff ff       	call   c0100c90 <__panic>
        p->flags = 0;
c0102c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c3a:	83 ec 08             	sub    $0x8,%esp
c0102c3d:	6a 00                	push   $0x0
c0102c3f:	ff 75 f4             	push   -0xc(%ebp)
c0102c42:	e8 5a fc ff ff       	call   c01028a1 <set_page_ref>
c0102c47:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0102c4a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c51:	89 d0                	mov    %edx,%eax
c0102c53:	c1 e0 02             	shl    $0x2,%eax
c0102c56:	01 d0                	add    %edx,%eax
c0102c58:	c1 e0 02             	shl    $0x2,%eax
c0102c5b:	89 c2                	mov    %eax,%edx
c0102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c60:	01 d0                	add    %edx,%eax
c0102c62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102c65:	0f 85 54 ff ff ff    	jne    c0102bbf <default_free_pages+0x33>
    }
    base->property = n;
c0102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c71:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c77:	83 c0 04             	add    $0x4,%eax
c0102c7a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102c81:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c84:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c87:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c8a:	0f ab 10             	bts    %edx,(%eax)
}
c0102c8d:	90                   	nop
c0102c8e:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102c95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c98:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102c9e:	e9 0e 01 00 00       	jmp    c0102db1 <default_free_pages+0x225>
        p = le2page(le, page_link);
c0102ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca6:	83 e8 0c             	sub    $0xc,%eax
c0102ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102caf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102cb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cb5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0102cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cbe:	8b 50 08             	mov    0x8(%eax),%edx
c0102cc1:	89 d0                	mov    %edx,%eax
c0102cc3:	c1 e0 02             	shl    $0x2,%eax
c0102cc6:	01 d0                	add    %edx,%eax
c0102cc8:	c1 e0 02             	shl    $0x2,%eax
c0102ccb:	89 c2                	mov    %eax,%edx
c0102ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd0:	01 d0                	add    %edx,%eax
c0102cd2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102cd5:	75 5d                	jne    c0102d34 <default_free_pages+0x1a8>
            base->property += p->property;
c0102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cda:	8b 50 08             	mov    0x8(%eax),%edx
c0102cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce0:	8b 40 08             	mov    0x8(%eax),%eax
c0102ce3:	01 c2                	add    %eax,%edx
c0102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cee:	83 c0 04             	add    $0x4,%eax
c0102cf1:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102cf8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102cfe:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d01:	0f b3 10             	btr    %edx,(%eax)
}
c0102d04:	90                   	nop
            list_del(&(p->page_link));
c0102d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d08:	83 c0 0c             	add    $0xc,%eax
c0102d0b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d11:	8b 40 04             	mov    0x4(%eax),%eax
c0102d14:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d17:	8b 12                	mov    (%edx),%edx
c0102d19:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102d1c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102d1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d22:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d25:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d28:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d2b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d2e:	89 10                	mov    %edx,(%eax)
}
c0102d30:	90                   	nop
}
c0102d31:	90                   	nop
c0102d32:	eb 7d                	jmp    c0102db1 <default_free_pages+0x225>
        }
        else if (p + p->property == base) {
c0102d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d37:	8b 50 08             	mov    0x8(%eax),%edx
c0102d3a:	89 d0                	mov    %edx,%eax
c0102d3c:	c1 e0 02             	shl    $0x2,%eax
c0102d3f:	01 d0                	add    %edx,%eax
c0102d41:	c1 e0 02             	shl    $0x2,%eax
c0102d44:	89 c2                	mov    %eax,%edx
c0102d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d49:	01 d0                	add    %edx,%eax
c0102d4b:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102d4e:	75 61                	jne    c0102db1 <default_free_pages+0x225>
            p->property += base->property;
c0102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d53:	8b 50 08             	mov    0x8(%eax),%edx
c0102d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d59:	8b 40 08             	mov    0x8(%eax),%eax
c0102d5c:	01 c2                	add    %eax,%edx
c0102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d61:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d67:	83 c0 04             	add    $0x4,%eax
c0102d6a:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102d71:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d74:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d77:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d7a:	0f b3 10             	btr    %edx,(%eax)
}
c0102d7d:	90                   	nop
            base = p;
c0102d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d81:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d87:	83 c0 0c             	add    $0xc,%eax
c0102d8a:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d90:	8b 40 04             	mov    0x4(%eax),%eax
c0102d93:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d96:	8b 12                	mov    (%edx),%edx
c0102d98:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102d9b:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102d9e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102da1:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102da4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102da7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102daa:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102dad:	89 10                	mov    %edx,(%eax)
}
c0102daf:	90                   	nop
}
c0102db0:	90                   	nop
    while (le != &free_list) {
c0102db1:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102db8:	0f 85 e5 fe ff ff    	jne    c0102ca3 <default_free_pages+0x117>
        }
    }
    nr_free += n;
c0102dbe:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102dc7:	01 d0                	add    %edx,%eax
c0102dc9:	a3 88 be 11 c0       	mov    %eax,0xc011be88
c0102dce:	c7 45 9c 80 be 11 c0 	movl   $0xc011be80,-0x64(%ebp)
    return listelm->next;
c0102dd5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102dd8:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102dde:	eb 69                	jmp    c0102e49 <default_free_pages+0x2bd>
        p = le2page(le, page_link);
c0102de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de3:	83 e8 0c             	sub    $0xc,%eax
c0102de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102de9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dec:	8b 50 08             	mov    0x8(%eax),%edx
c0102def:	89 d0                	mov    %edx,%eax
c0102df1:	c1 e0 02             	shl    $0x2,%eax
c0102df4:	01 d0                	add    %edx,%eax
c0102df6:	c1 e0 02             	shl    $0x2,%eax
c0102df9:	89 c2                	mov    %eax,%edx
c0102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfe:	01 d0                	add    %edx,%eax
c0102e00:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e03:	72 35                	jb     c0102e3a <default_free_pages+0x2ae>
            assert(base + base->property != p);
c0102e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e08:	8b 50 08             	mov    0x8(%eax),%edx
c0102e0b:	89 d0                	mov    %edx,%eax
c0102e0d:	c1 e0 02             	shl    $0x2,%eax
c0102e10:	01 d0                	add    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	89 c2                	mov    %eax,%edx
c0102e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1a:	01 d0                	add    %edx,%eax
c0102e1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e1f:	75 33                	jne    c0102e54 <default_free_pages+0x2c8>
c0102e21:	68 f9 61 10 c0       	push   $0xc01061f9
c0102e26:	68 96 61 10 c0       	push   $0xc0106196
c0102e2b:	68 b9 00 00 00       	push   $0xb9
c0102e30:	68 ab 61 10 c0       	push   $0xc01061ab
c0102e35:	e8 56 de ff ff       	call   c0100c90 <__panic>
c0102e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e3d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e40:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e43:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0102e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102e49:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102e50:	75 8e                	jne    c0102de0 <default_free_pages+0x254>
c0102e52:	eb 01                	jmp    c0102e55 <default_free_pages+0x2c9>
            break;
c0102e54:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0102e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e58:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e61:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102e64:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e67:	8b 00                	mov    (%eax),%eax
c0102e69:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e6c:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e6f:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e72:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e75:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102e78:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e7b:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e7e:	89 10                	mov    %edx,(%eax)
c0102e80:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e83:	8b 10                	mov    (%eax),%edx
c0102e85:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e88:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e8b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e8e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e91:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e94:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e97:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e9a:	89 10                	mov    %edx,(%eax)
}
c0102e9c:	90                   	nop
}
c0102e9d:	90                   	nop
}
c0102e9e:	90                   	nop
c0102e9f:	c9                   	leave  
c0102ea0:	c3                   	ret    

c0102ea1 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ea1:	55                   	push   %ebp
c0102ea2:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ea4:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0102ea9:	5d                   	pop    %ebp
c0102eaa:	c3                   	ret    

c0102eab <basic_check>:

static void
basic_check(void) {
c0102eab:	55                   	push   %ebp
c0102eac:	89 e5                	mov    %esp,%ebp
c0102eae:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ec4:	83 ec 0c             	sub    $0xc,%esp
c0102ec7:	6a 01                	push   $0x1
c0102ec9:	e8 d5 0c 00 00       	call   c0103ba3 <alloc_pages>
c0102ece:	83 c4 10             	add    $0x10,%esp
c0102ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ed4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ed8:	75 19                	jne    c0102ef3 <basic_check+0x48>
c0102eda:	68 14 62 10 c0       	push   $0xc0106214
c0102edf:	68 96 61 10 c0       	push   $0xc0106196
c0102ee4:	68 ca 00 00 00       	push   $0xca
c0102ee9:	68 ab 61 10 c0       	push   $0xc01061ab
c0102eee:	e8 9d dd ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ef3:	83 ec 0c             	sub    $0xc,%esp
c0102ef6:	6a 01                	push   $0x1
c0102ef8:	e8 a6 0c 00 00       	call   c0103ba3 <alloc_pages>
c0102efd:	83 c4 10             	add    $0x10,%esp
c0102f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f07:	75 19                	jne    c0102f22 <basic_check+0x77>
c0102f09:	68 30 62 10 c0       	push   $0xc0106230
c0102f0e:	68 96 61 10 c0       	push   $0xc0106196
c0102f13:	68 cb 00 00 00       	push   $0xcb
c0102f18:	68 ab 61 10 c0       	push   $0xc01061ab
c0102f1d:	e8 6e dd ff ff       	call   c0100c90 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f22:	83 ec 0c             	sub    $0xc,%esp
c0102f25:	6a 01                	push   $0x1
c0102f27:	e8 77 0c 00 00       	call   c0103ba3 <alloc_pages>
c0102f2c:	83 c4 10             	add    $0x10,%esp
c0102f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f36:	75 19                	jne    c0102f51 <basic_check+0xa6>
c0102f38:	68 4c 62 10 c0       	push   $0xc010624c
c0102f3d:	68 96 61 10 c0       	push   $0xc0106196
c0102f42:	68 cc 00 00 00       	push   $0xcc
c0102f47:	68 ab 61 10 c0       	push   $0xc01061ab
c0102f4c:	e8 3f dd ff ff       	call   c0100c90 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f57:	74 10                	je     c0102f69 <basic_check+0xbe>
c0102f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f5f:	74 08                	je     c0102f69 <basic_check+0xbe>
c0102f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f67:	75 19                	jne    c0102f82 <basic_check+0xd7>
c0102f69:	68 68 62 10 c0       	push   $0xc0106268
c0102f6e:	68 96 61 10 c0       	push   $0xc0106196
c0102f73:	68 ce 00 00 00       	push   $0xce
c0102f78:	68 ab 61 10 c0       	push   $0xc01061ab
c0102f7d:	e8 0e dd ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f82:	83 ec 0c             	sub    $0xc,%esp
c0102f85:	ff 75 ec             	push   -0x14(%ebp)
c0102f88:	e8 0a f9 ff ff       	call   c0102897 <page_ref>
c0102f8d:	83 c4 10             	add    $0x10,%esp
c0102f90:	85 c0                	test   %eax,%eax
c0102f92:	75 24                	jne    c0102fb8 <basic_check+0x10d>
c0102f94:	83 ec 0c             	sub    $0xc,%esp
c0102f97:	ff 75 f0             	push   -0x10(%ebp)
c0102f9a:	e8 f8 f8 ff ff       	call   c0102897 <page_ref>
c0102f9f:	83 c4 10             	add    $0x10,%esp
c0102fa2:	85 c0                	test   %eax,%eax
c0102fa4:	75 12                	jne    c0102fb8 <basic_check+0x10d>
c0102fa6:	83 ec 0c             	sub    $0xc,%esp
c0102fa9:	ff 75 f4             	push   -0xc(%ebp)
c0102fac:	e8 e6 f8 ff ff       	call   c0102897 <page_ref>
c0102fb1:	83 c4 10             	add    $0x10,%esp
c0102fb4:	85 c0                	test   %eax,%eax
c0102fb6:	74 19                	je     c0102fd1 <basic_check+0x126>
c0102fb8:	68 8c 62 10 c0       	push   $0xc010628c
c0102fbd:	68 96 61 10 c0       	push   $0xc0106196
c0102fc2:	68 cf 00 00 00       	push   $0xcf
c0102fc7:	68 ab 61 10 c0       	push   $0xc01061ab
c0102fcc:	e8 bf dc ff ff       	call   c0100c90 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fd1:	83 ec 0c             	sub    $0xc,%esp
c0102fd4:	ff 75 ec             	push   -0x14(%ebp)
c0102fd7:	e8 a8 f8 ff ff       	call   c0102884 <page2pa>
c0102fdc:	83 c4 10             	add    $0x10,%esp
c0102fdf:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0102fe5:	c1 e2 0c             	shl    $0xc,%edx
c0102fe8:	39 d0                	cmp    %edx,%eax
c0102fea:	72 19                	jb     c0103005 <basic_check+0x15a>
c0102fec:	68 c8 62 10 c0       	push   $0xc01062c8
c0102ff1:	68 96 61 10 c0       	push   $0xc0106196
c0102ff6:	68 d1 00 00 00       	push   $0xd1
c0102ffb:	68 ab 61 10 c0       	push   $0xc01061ab
c0103000:	e8 8b dc ff ff       	call   c0100c90 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103005:	83 ec 0c             	sub    $0xc,%esp
c0103008:	ff 75 f0             	push   -0x10(%ebp)
c010300b:	e8 74 f8 ff ff       	call   c0102884 <page2pa>
c0103010:	83 c4 10             	add    $0x10,%esp
c0103013:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103019:	c1 e2 0c             	shl    $0xc,%edx
c010301c:	39 d0                	cmp    %edx,%eax
c010301e:	72 19                	jb     c0103039 <basic_check+0x18e>
c0103020:	68 e5 62 10 c0       	push   $0xc01062e5
c0103025:	68 96 61 10 c0       	push   $0xc0106196
c010302a:	68 d2 00 00 00       	push   $0xd2
c010302f:	68 ab 61 10 c0       	push   $0xc01061ab
c0103034:	e8 57 dc ff ff       	call   c0100c90 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103039:	83 ec 0c             	sub    $0xc,%esp
c010303c:	ff 75 f4             	push   -0xc(%ebp)
c010303f:	e8 40 f8 ff ff       	call   c0102884 <page2pa>
c0103044:	83 c4 10             	add    $0x10,%esp
c0103047:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010304d:	c1 e2 0c             	shl    $0xc,%edx
c0103050:	39 d0                	cmp    %edx,%eax
c0103052:	72 19                	jb     c010306d <basic_check+0x1c2>
c0103054:	68 02 63 10 c0       	push   $0xc0106302
c0103059:	68 96 61 10 c0       	push   $0xc0106196
c010305e:	68 d3 00 00 00       	push   $0xd3
c0103063:	68 ab 61 10 c0       	push   $0xc01061ab
c0103068:	e8 23 dc ff ff       	call   c0100c90 <__panic>

    list_entry_t free_list_store = free_list;
c010306d:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103072:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103078:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010307b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010307e:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103085:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103088:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010308b:	89 50 04             	mov    %edx,0x4(%eax)
c010308e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103091:	8b 50 04             	mov    0x4(%eax),%edx
c0103094:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103097:	89 10                	mov    %edx,(%eax)
}
c0103099:	90                   	nop
c010309a:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c01030a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030a4:	8b 40 04             	mov    0x4(%eax),%eax
c01030a7:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01030aa:	0f 94 c0             	sete   %al
c01030ad:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030b0:	85 c0                	test   %eax,%eax
c01030b2:	75 19                	jne    c01030cd <basic_check+0x222>
c01030b4:	68 1f 63 10 c0       	push   $0xc010631f
c01030b9:	68 96 61 10 c0       	push   $0xc0106196
c01030be:	68 d7 00 00 00       	push   $0xd7
c01030c3:	68 ab 61 10 c0       	push   $0xc01061ab
c01030c8:	e8 c3 db ff ff       	call   c0100c90 <__panic>

    unsigned int nr_free_store = nr_free;
c01030cd:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01030d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030d5:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01030dc:	00 00 00 

    assert(alloc_page() == NULL);
c01030df:	83 ec 0c             	sub    $0xc,%esp
c01030e2:	6a 01                	push   $0x1
c01030e4:	e8 ba 0a 00 00       	call   c0103ba3 <alloc_pages>
c01030e9:	83 c4 10             	add    $0x10,%esp
c01030ec:	85 c0                	test   %eax,%eax
c01030ee:	74 19                	je     c0103109 <basic_check+0x25e>
c01030f0:	68 36 63 10 c0       	push   $0xc0106336
c01030f5:	68 96 61 10 c0       	push   $0xc0106196
c01030fa:	68 dc 00 00 00       	push   $0xdc
c01030ff:	68 ab 61 10 c0       	push   $0xc01061ab
c0103104:	e8 87 db ff ff       	call   c0100c90 <__panic>

    free_page(p0);
c0103109:	83 ec 08             	sub    $0x8,%esp
c010310c:	6a 01                	push   $0x1
c010310e:	ff 75 ec             	push   -0x14(%ebp)
c0103111:	e8 cb 0a 00 00       	call   c0103be1 <free_pages>
c0103116:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0103119:	83 ec 08             	sub    $0x8,%esp
c010311c:	6a 01                	push   $0x1
c010311e:	ff 75 f0             	push   -0x10(%ebp)
c0103121:	e8 bb 0a 00 00       	call   c0103be1 <free_pages>
c0103126:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103129:	83 ec 08             	sub    $0x8,%esp
c010312c:	6a 01                	push   $0x1
c010312e:	ff 75 f4             	push   -0xc(%ebp)
c0103131:	e8 ab 0a 00 00       	call   c0103be1 <free_pages>
c0103136:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0103139:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010313e:	83 f8 03             	cmp    $0x3,%eax
c0103141:	74 19                	je     c010315c <basic_check+0x2b1>
c0103143:	68 4b 63 10 c0       	push   $0xc010634b
c0103148:	68 96 61 10 c0       	push   $0xc0106196
c010314d:	68 e1 00 00 00       	push   $0xe1
c0103152:	68 ab 61 10 c0       	push   $0xc01061ab
c0103157:	e8 34 db ff ff       	call   c0100c90 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010315c:	83 ec 0c             	sub    $0xc,%esp
c010315f:	6a 01                	push   $0x1
c0103161:	e8 3d 0a 00 00       	call   c0103ba3 <alloc_pages>
c0103166:	83 c4 10             	add    $0x10,%esp
c0103169:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010316c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103170:	75 19                	jne    c010318b <basic_check+0x2e0>
c0103172:	68 14 62 10 c0       	push   $0xc0106214
c0103177:	68 96 61 10 c0       	push   $0xc0106196
c010317c:	68 e3 00 00 00       	push   $0xe3
c0103181:	68 ab 61 10 c0       	push   $0xc01061ab
c0103186:	e8 05 db ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010318b:	83 ec 0c             	sub    $0xc,%esp
c010318e:	6a 01                	push   $0x1
c0103190:	e8 0e 0a 00 00       	call   c0103ba3 <alloc_pages>
c0103195:	83 c4 10             	add    $0x10,%esp
c0103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010319b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010319f:	75 19                	jne    c01031ba <basic_check+0x30f>
c01031a1:	68 30 62 10 c0       	push   $0xc0106230
c01031a6:	68 96 61 10 c0       	push   $0xc0106196
c01031ab:	68 e4 00 00 00       	push   $0xe4
c01031b0:	68 ab 61 10 c0       	push   $0xc01061ab
c01031b5:	e8 d6 da ff ff       	call   c0100c90 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031ba:	83 ec 0c             	sub    $0xc,%esp
c01031bd:	6a 01                	push   $0x1
c01031bf:	e8 df 09 00 00       	call   c0103ba3 <alloc_pages>
c01031c4:	83 c4 10             	add    $0x10,%esp
c01031c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031ce:	75 19                	jne    c01031e9 <basic_check+0x33e>
c01031d0:	68 4c 62 10 c0       	push   $0xc010624c
c01031d5:	68 96 61 10 c0       	push   $0xc0106196
c01031da:	68 e5 00 00 00       	push   $0xe5
c01031df:	68 ab 61 10 c0       	push   $0xc01061ab
c01031e4:	e8 a7 da ff ff       	call   c0100c90 <__panic>

    assert(alloc_page() == NULL);
c01031e9:	83 ec 0c             	sub    $0xc,%esp
c01031ec:	6a 01                	push   $0x1
c01031ee:	e8 b0 09 00 00       	call   c0103ba3 <alloc_pages>
c01031f3:	83 c4 10             	add    $0x10,%esp
c01031f6:	85 c0                	test   %eax,%eax
c01031f8:	74 19                	je     c0103213 <basic_check+0x368>
c01031fa:	68 36 63 10 c0       	push   $0xc0106336
c01031ff:	68 96 61 10 c0       	push   $0xc0106196
c0103204:	68 e7 00 00 00       	push   $0xe7
c0103209:	68 ab 61 10 c0       	push   $0xc01061ab
c010320e:	e8 7d da ff ff       	call   c0100c90 <__panic>

    free_page(p0);
c0103213:	83 ec 08             	sub    $0x8,%esp
c0103216:	6a 01                	push   $0x1
c0103218:	ff 75 ec             	push   -0x14(%ebp)
c010321b:	e8 c1 09 00 00       	call   c0103be1 <free_pages>
c0103220:	83 c4 10             	add    $0x10,%esp
c0103223:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c010322a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010322d:	8b 40 04             	mov    0x4(%eax),%eax
c0103230:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103233:	0f 94 c0             	sete   %al
c0103236:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103239:	85 c0                	test   %eax,%eax
c010323b:	74 19                	je     c0103256 <basic_check+0x3ab>
c010323d:	68 58 63 10 c0       	push   $0xc0106358
c0103242:	68 96 61 10 c0       	push   $0xc0106196
c0103247:	68 ea 00 00 00       	push   $0xea
c010324c:	68 ab 61 10 c0       	push   $0xc01061ab
c0103251:	e8 3a da ff ff       	call   c0100c90 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103256:	83 ec 0c             	sub    $0xc,%esp
c0103259:	6a 01                	push   $0x1
c010325b:	e8 43 09 00 00       	call   c0103ba3 <alloc_pages>
c0103260:	83 c4 10             	add    $0x10,%esp
c0103263:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103269:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010326c:	74 19                	je     c0103287 <basic_check+0x3dc>
c010326e:	68 70 63 10 c0       	push   $0xc0106370
c0103273:	68 96 61 10 c0       	push   $0xc0106196
c0103278:	68 ed 00 00 00       	push   $0xed
c010327d:	68 ab 61 10 c0       	push   $0xc01061ab
c0103282:	e8 09 da ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c0103287:	83 ec 0c             	sub    $0xc,%esp
c010328a:	6a 01                	push   $0x1
c010328c:	e8 12 09 00 00       	call   c0103ba3 <alloc_pages>
c0103291:	83 c4 10             	add    $0x10,%esp
c0103294:	85 c0                	test   %eax,%eax
c0103296:	74 19                	je     c01032b1 <basic_check+0x406>
c0103298:	68 36 63 10 c0       	push   $0xc0106336
c010329d:	68 96 61 10 c0       	push   $0xc0106196
c01032a2:	68 ee 00 00 00       	push   $0xee
c01032a7:	68 ab 61 10 c0       	push   $0xc01061ab
c01032ac:	e8 df d9 ff ff       	call   c0100c90 <__panic>

    assert(nr_free == 0);
c01032b1:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01032b6:	85 c0                	test   %eax,%eax
c01032b8:	74 19                	je     c01032d3 <basic_check+0x428>
c01032ba:	68 89 63 10 c0       	push   $0xc0106389
c01032bf:	68 96 61 10 c0       	push   $0xc0106196
c01032c4:	68 f0 00 00 00       	push   $0xf0
c01032c9:	68 ab 61 10 c0       	push   $0xc01061ab
c01032ce:	e8 bd d9 ff ff       	call   c0100c90 <__panic>
    free_list = free_list_store;
c01032d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032d9:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01032de:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c01032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032e7:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c01032ec:	83 ec 08             	sub    $0x8,%esp
c01032ef:	6a 01                	push   $0x1
c01032f1:	ff 75 e4             	push   -0x1c(%ebp)
c01032f4:	e8 e8 08 00 00       	call   c0103be1 <free_pages>
c01032f9:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01032fc:	83 ec 08             	sub    $0x8,%esp
c01032ff:	6a 01                	push   $0x1
c0103301:	ff 75 f0             	push   -0x10(%ebp)
c0103304:	e8 d8 08 00 00       	call   c0103be1 <free_pages>
c0103309:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010330c:	83 ec 08             	sub    $0x8,%esp
c010330f:	6a 01                	push   $0x1
c0103311:	ff 75 f4             	push   -0xc(%ebp)
c0103314:	e8 c8 08 00 00       	call   c0103be1 <free_pages>
c0103319:	83 c4 10             	add    $0x10,%esp
}
c010331c:	90                   	nop
c010331d:	c9                   	leave  
c010331e:	c3                   	ret    

c010331f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010331f:	55                   	push   %ebp
c0103320:	89 e5                	mov    %esp,%ebp
c0103322:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0103328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010332f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103336:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010333d:	eb 60                	jmp    c010339f <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c010333f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103342:	83 e8 0c             	sub    $0xc,%eax
c0103345:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010334b:	83 c0 04             	add    $0x4,%eax
c010334e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103355:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103358:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010335b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010335e:	0f a3 10             	bt     %edx,(%eax)
c0103361:	19 c0                	sbb    %eax,%eax
c0103363:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103366:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010336a:	0f 95 c0             	setne  %al
c010336d:	0f b6 c0             	movzbl %al,%eax
c0103370:	85 c0                	test   %eax,%eax
c0103372:	75 19                	jne    c010338d <default_check+0x6e>
c0103374:	68 96 63 10 c0       	push   $0xc0106396
c0103379:	68 96 61 10 c0       	push   $0xc0106196
c010337e:	68 01 01 00 00       	push   $0x101
c0103383:	68 ab 61 10 c0       	push   $0xc01061ab
c0103388:	e8 03 d9 ff ff       	call   c0100c90 <__panic>
        count ++, total += p->property;
c010338d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103394:	8b 50 08             	mov    0x8(%eax),%edx
c0103397:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010339a:	01 d0                	add    %edx,%eax
c010339c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010339f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01033a5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033a8:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01033ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033ae:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c01033b5:	75 88                	jne    c010333f <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01033b7:	e8 5a 08 00 00       	call   c0103c16 <nr_free_pages>
c01033bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01033bf:	39 d0                	cmp    %edx,%eax
c01033c1:	74 19                	je     c01033dc <default_check+0xbd>
c01033c3:	68 a6 63 10 c0       	push   $0xc01063a6
c01033c8:	68 96 61 10 c0       	push   $0xc0106196
c01033cd:	68 04 01 00 00       	push   $0x104
c01033d2:	68 ab 61 10 c0       	push   $0xc01061ab
c01033d7:	e8 b4 d8 ff ff       	call   c0100c90 <__panic>

    basic_check();
c01033dc:	e8 ca fa ff ff       	call   c0102eab <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01033e1:	83 ec 0c             	sub    $0xc,%esp
c01033e4:	6a 05                	push   $0x5
c01033e6:	e8 b8 07 00 00       	call   c0103ba3 <alloc_pages>
c01033eb:	83 c4 10             	add    $0x10,%esp
c01033ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01033f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01033f5:	75 19                	jne    c0103410 <default_check+0xf1>
c01033f7:	68 bf 63 10 c0       	push   $0xc01063bf
c01033fc:	68 96 61 10 c0       	push   $0xc0106196
c0103401:	68 09 01 00 00       	push   $0x109
c0103406:	68 ab 61 10 c0       	push   $0xc01061ab
c010340b:	e8 80 d8 ff ff       	call   c0100c90 <__panic>
    assert(!PageProperty(p0));
c0103410:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103413:	83 c0 04             	add    $0x4,%eax
c0103416:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010341d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103420:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103423:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103426:	0f a3 10             	bt     %edx,(%eax)
c0103429:	19 c0                	sbb    %eax,%eax
c010342b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010342e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103432:	0f 95 c0             	setne  %al
c0103435:	0f b6 c0             	movzbl %al,%eax
c0103438:	85 c0                	test   %eax,%eax
c010343a:	74 19                	je     c0103455 <default_check+0x136>
c010343c:	68 ca 63 10 c0       	push   $0xc01063ca
c0103441:	68 96 61 10 c0       	push   $0xc0106196
c0103446:	68 0a 01 00 00       	push   $0x10a
c010344b:	68 ab 61 10 c0       	push   $0xc01061ab
c0103450:	e8 3b d8 ff ff       	call   c0100c90 <__panic>

    list_entry_t free_list_store = free_list;
c0103455:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010345a:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103460:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103463:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103466:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c010346d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103470:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103473:	89 50 04             	mov    %edx,0x4(%eax)
c0103476:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103479:	8b 50 04             	mov    0x4(%eax),%edx
c010347c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010347f:	89 10                	mov    %edx,(%eax)
}
c0103481:	90                   	nop
c0103482:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c0103489:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010348c:	8b 40 04             	mov    0x4(%eax),%eax
c010348f:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103492:	0f 94 c0             	sete   %al
c0103495:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103498:	85 c0                	test   %eax,%eax
c010349a:	75 19                	jne    c01034b5 <default_check+0x196>
c010349c:	68 1f 63 10 c0       	push   $0xc010631f
c01034a1:	68 96 61 10 c0       	push   $0xc0106196
c01034a6:	68 0e 01 00 00       	push   $0x10e
c01034ab:	68 ab 61 10 c0       	push   $0xc01061ab
c01034b0:	e8 db d7 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01034b5:	83 ec 0c             	sub    $0xc,%esp
c01034b8:	6a 01                	push   $0x1
c01034ba:	e8 e4 06 00 00       	call   c0103ba3 <alloc_pages>
c01034bf:	83 c4 10             	add    $0x10,%esp
c01034c2:	85 c0                	test   %eax,%eax
c01034c4:	74 19                	je     c01034df <default_check+0x1c0>
c01034c6:	68 36 63 10 c0       	push   $0xc0106336
c01034cb:	68 96 61 10 c0       	push   $0xc0106196
c01034d0:	68 0f 01 00 00       	push   $0x10f
c01034d5:	68 ab 61 10 c0       	push   $0xc01061ab
c01034da:	e8 b1 d7 ff ff       	call   c0100c90 <__panic>

    unsigned int nr_free_store = nr_free;
c01034df:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01034e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01034e7:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01034ee:	00 00 00 

    free_pages(p0 + 2, 3);
c01034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f4:	83 c0 28             	add    $0x28,%eax
c01034f7:	83 ec 08             	sub    $0x8,%esp
c01034fa:	6a 03                	push   $0x3
c01034fc:	50                   	push   %eax
c01034fd:	e8 df 06 00 00       	call   c0103be1 <free_pages>
c0103502:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0103505:	83 ec 0c             	sub    $0xc,%esp
c0103508:	6a 04                	push   $0x4
c010350a:	e8 94 06 00 00       	call   c0103ba3 <alloc_pages>
c010350f:	83 c4 10             	add    $0x10,%esp
c0103512:	85 c0                	test   %eax,%eax
c0103514:	74 19                	je     c010352f <default_check+0x210>
c0103516:	68 dc 63 10 c0       	push   $0xc01063dc
c010351b:	68 96 61 10 c0       	push   $0xc0106196
c0103520:	68 15 01 00 00       	push   $0x115
c0103525:	68 ab 61 10 c0       	push   $0xc01061ab
c010352a:	e8 61 d7 ff ff       	call   c0100c90 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103532:	83 c0 28             	add    $0x28,%eax
c0103535:	83 c0 04             	add    $0x4,%eax
c0103538:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010353f:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103542:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103545:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103548:	0f a3 10             	bt     %edx,(%eax)
c010354b:	19 c0                	sbb    %eax,%eax
c010354d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103550:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103554:	0f 95 c0             	setne  %al
c0103557:	0f b6 c0             	movzbl %al,%eax
c010355a:	85 c0                	test   %eax,%eax
c010355c:	74 0e                	je     c010356c <default_check+0x24d>
c010355e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103561:	83 c0 28             	add    $0x28,%eax
c0103564:	8b 40 08             	mov    0x8(%eax),%eax
c0103567:	83 f8 03             	cmp    $0x3,%eax
c010356a:	74 19                	je     c0103585 <default_check+0x266>
c010356c:	68 f4 63 10 c0       	push   $0xc01063f4
c0103571:	68 96 61 10 c0       	push   $0xc0106196
c0103576:	68 16 01 00 00       	push   $0x116
c010357b:	68 ab 61 10 c0       	push   $0xc01061ab
c0103580:	e8 0b d7 ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103585:	83 ec 0c             	sub    $0xc,%esp
c0103588:	6a 03                	push   $0x3
c010358a:	e8 14 06 00 00       	call   c0103ba3 <alloc_pages>
c010358f:	83 c4 10             	add    $0x10,%esp
c0103592:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103595:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103599:	75 19                	jne    c01035b4 <default_check+0x295>
c010359b:	68 20 64 10 c0       	push   $0xc0106420
c01035a0:	68 96 61 10 c0       	push   $0xc0106196
c01035a5:	68 17 01 00 00       	push   $0x117
c01035aa:	68 ab 61 10 c0       	push   $0xc01061ab
c01035af:	e8 dc d6 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01035b4:	83 ec 0c             	sub    $0xc,%esp
c01035b7:	6a 01                	push   $0x1
c01035b9:	e8 e5 05 00 00       	call   c0103ba3 <alloc_pages>
c01035be:	83 c4 10             	add    $0x10,%esp
c01035c1:	85 c0                	test   %eax,%eax
c01035c3:	74 19                	je     c01035de <default_check+0x2bf>
c01035c5:	68 36 63 10 c0       	push   $0xc0106336
c01035ca:	68 96 61 10 c0       	push   $0xc0106196
c01035cf:	68 18 01 00 00       	push   $0x118
c01035d4:	68 ab 61 10 c0       	push   $0xc01061ab
c01035d9:	e8 b2 d6 ff ff       	call   c0100c90 <__panic>
    assert(p0 + 2 == p1);
c01035de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035e1:	83 c0 28             	add    $0x28,%eax
c01035e4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01035e7:	74 19                	je     c0103602 <default_check+0x2e3>
c01035e9:	68 3e 64 10 c0       	push   $0xc010643e
c01035ee:	68 96 61 10 c0       	push   $0xc0106196
c01035f3:	68 19 01 00 00       	push   $0x119
c01035f8:	68 ab 61 10 c0       	push   $0xc01061ab
c01035fd:	e8 8e d6 ff ff       	call   c0100c90 <__panic>

    p2 = p0 + 1;
c0103602:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103605:	83 c0 14             	add    $0x14,%eax
c0103608:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010360b:	83 ec 08             	sub    $0x8,%esp
c010360e:	6a 01                	push   $0x1
c0103610:	ff 75 e8             	push   -0x18(%ebp)
c0103613:	e8 c9 05 00 00       	call   c0103be1 <free_pages>
c0103618:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c010361b:	83 ec 08             	sub    $0x8,%esp
c010361e:	6a 03                	push   $0x3
c0103620:	ff 75 e0             	push   -0x20(%ebp)
c0103623:	e8 b9 05 00 00       	call   c0103be1 <free_pages>
c0103628:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c010362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010362e:	83 c0 04             	add    $0x4,%eax
c0103631:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103638:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010363b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010363e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103641:	0f a3 10             	bt     %edx,(%eax)
c0103644:	19 c0                	sbb    %eax,%eax
c0103646:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103649:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010364d:	0f 95 c0             	setne  %al
c0103650:	0f b6 c0             	movzbl %al,%eax
c0103653:	85 c0                	test   %eax,%eax
c0103655:	74 0b                	je     c0103662 <default_check+0x343>
c0103657:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010365a:	8b 40 08             	mov    0x8(%eax),%eax
c010365d:	83 f8 01             	cmp    $0x1,%eax
c0103660:	74 19                	je     c010367b <default_check+0x35c>
c0103662:	68 4c 64 10 c0       	push   $0xc010644c
c0103667:	68 96 61 10 c0       	push   $0xc0106196
c010366c:	68 1e 01 00 00       	push   $0x11e
c0103671:	68 ab 61 10 c0       	push   $0xc01061ab
c0103676:	e8 15 d6 ff ff       	call   c0100c90 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010367b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010367e:	83 c0 04             	add    $0x4,%eax
c0103681:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103688:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010368b:	8b 45 90             	mov    -0x70(%ebp),%eax
c010368e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103691:	0f a3 10             	bt     %edx,(%eax)
c0103694:	19 c0                	sbb    %eax,%eax
c0103696:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103699:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010369d:	0f 95 c0             	setne  %al
c01036a0:	0f b6 c0             	movzbl %al,%eax
c01036a3:	85 c0                	test   %eax,%eax
c01036a5:	74 0b                	je     c01036b2 <default_check+0x393>
c01036a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036aa:	8b 40 08             	mov    0x8(%eax),%eax
c01036ad:	83 f8 03             	cmp    $0x3,%eax
c01036b0:	74 19                	je     c01036cb <default_check+0x3ac>
c01036b2:	68 74 64 10 c0       	push   $0xc0106474
c01036b7:	68 96 61 10 c0       	push   $0xc0106196
c01036bc:	68 1f 01 00 00       	push   $0x11f
c01036c1:	68 ab 61 10 c0       	push   $0xc01061ab
c01036c6:	e8 c5 d5 ff ff       	call   c0100c90 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036cb:	83 ec 0c             	sub    $0xc,%esp
c01036ce:	6a 01                	push   $0x1
c01036d0:	e8 ce 04 00 00       	call   c0103ba3 <alloc_pages>
c01036d5:	83 c4 10             	add    $0x10,%esp
c01036d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01036db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036de:	83 e8 14             	sub    $0x14,%eax
c01036e1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01036e4:	74 19                	je     c01036ff <default_check+0x3e0>
c01036e6:	68 9a 64 10 c0       	push   $0xc010649a
c01036eb:	68 96 61 10 c0       	push   $0xc0106196
c01036f0:	68 21 01 00 00       	push   $0x121
c01036f5:	68 ab 61 10 c0       	push   $0xc01061ab
c01036fa:	e8 91 d5 ff ff       	call   c0100c90 <__panic>
    free_page(p0);
c01036ff:	83 ec 08             	sub    $0x8,%esp
c0103702:	6a 01                	push   $0x1
c0103704:	ff 75 e8             	push   -0x18(%ebp)
c0103707:	e8 d5 04 00 00       	call   c0103be1 <free_pages>
c010370c:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010370f:	83 ec 0c             	sub    $0xc,%esp
c0103712:	6a 02                	push   $0x2
c0103714:	e8 8a 04 00 00       	call   c0103ba3 <alloc_pages>
c0103719:	83 c4 10             	add    $0x10,%esp
c010371c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010371f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103722:	83 c0 14             	add    $0x14,%eax
c0103725:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103728:	74 19                	je     c0103743 <default_check+0x424>
c010372a:	68 b8 64 10 c0       	push   $0xc01064b8
c010372f:	68 96 61 10 c0       	push   $0xc0106196
c0103734:	68 23 01 00 00       	push   $0x123
c0103739:	68 ab 61 10 c0       	push   $0xc01061ab
c010373e:	e8 4d d5 ff ff       	call   c0100c90 <__panic>

    free_pages(p0, 2);
c0103743:	83 ec 08             	sub    $0x8,%esp
c0103746:	6a 02                	push   $0x2
c0103748:	ff 75 e8             	push   -0x18(%ebp)
c010374b:	e8 91 04 00 00       	call   c0103be1 <free_pages>
c0103750:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103753:	83 ec 08             	sub    $0x8,%esp
c0103756:	6a 01                	push   $0x1
c0103758:	ff 75 dc             	push   -0x24(%ebp)
c010375b:	e8 81 04 00 00       	call   c0103be1 <free_pages>
c0103760:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0103763:	83 ec 0c             	sub    $0xc,%esp
c0103766:	6a 05                	push   $0x5
c0103768:	e8 36 04 00 00       	call   c0103ba3 <alloc_pages>
c010376d:	83 c4 10             	add    $0x10,%esp
c0103770:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103773:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103777:	75 19                	jne    c0103792 <default_check+0x473>
c0103779:	68 d8 64 10 c0       	push   $0xc01064d8
c010377e:	68 96 61 10 c0       	push   $0xc0106196
c0103783:	68 28 01 00 00       	push   $0x128
c0103788:	68 ab 61 10 c0       	push   $0xc01061ab
c010378d:	e8 fe d4 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c0103792:	83 ec 0c             	sub    $0xc,%esp
c0103795:	6a 01                	push   $0x1
c0103797:	e8 07 04 00 00       	call   c0103ba3 <alloc_pages>
c010379c:	83 c4 10             	add    $0x10,%esp
c010379f:	85 c0                	test   %eax,%eax
c01037a1:	74 19                	je     c01037bc <default_check+0x49d>
c01037a3:	68 36 63 10 c0       	push   $0xc0106336
c01037a8:	68 96 61 10 c0       	push   $0xc0106196
c01037ad:	68 29 01 00 00       	push   $0x129
c01037b2:	68 ab 61 10 c0       	push   $0xc01061ab
c01037b7:	e8 d4 d4 ff ff       	call   c0100c90 <__panic>

    assert(nr_free == 0);
c01037bc:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01037c1:	85 c0                	test   %eax,%eax
c01037c3:	74 19                	je     c01037de <default_check+0x4bf>
c01037c5:	68 89 63 10 c0       	push   $0xc0106389
c01037ca:	68 96 61 10 c0       	push   $0xc0106196
c01037cf:	68 2b 01 00 00       	push   $0x12b
c01037d4:	68 ab 61 10 c0       	push   $0xc01061ab
c01037d9:	e8 b2 d4 ff ff       	call   c0100c90 <__panic>
    nr_free = nr_free_store;
c01037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037e1:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c01037e6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01037e9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01037ec:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01037f1:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c01037f7:	83 ec 08             	sub    $0x8,%esp
c01037fa:	6a 05                	push   $0x5
c01037fc:	ff 75 e8             	push   -0x18(%ebp)
c01037ff:	e8 dd 03 00 00       	call   c0103be1 <free_pages>
c0103804:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0103807:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010380e:	eb 1d                	jmp    c010382d <default_check+0x50e>
        struct Page *p = le2page(le, page_link);
c0103810:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103813:	83 e8 0c             	sub    $0xc,%eax
c0103816:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103819:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010381d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103820:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103823:	8b 48 08             	mov    0x8(%eax),%ecx
c0103826:	89 d0                	mov    %edx,%eax
c0103828:	29 c8                	sub    %ecx,%eax
c010382a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010382d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103830:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103833:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103836:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103839:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010383c:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103843:	75 cb                	jne    c0103810 <default_check+0x4f1>
    }
    assert(count == 0);
c0103845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103849:	74 19                	je     c0103864 <default_check+0x545>
c010384b:	68 f6 64 10 c0       	push   $0xc01064f6
c0103850:	68 96 61 10 c0       	push   $0xc0106196
c0103855:	68 36 01 00 00       	push   $0x136
c010385a:	68 ab 61 10 c0       	push   $0xc01061ab
c010385f:	e8 2c d4 ff ff       	call   c0100c90 <__panic>
    assert(total == 0);
c0103864:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103868:	74 19                	je     c0103883 <default_check+0x564>
c010386a:	68 01 65 10 c0       	push   $0xc0106501
c010386f:	68 96 61 10 c0       	push   $0xc0106196
c0103874:	68 37 01 00 00       	push   $0x137
c0103879:	68 ab 61 10 c0       	push   $0xc01061ab
c010387e:	e8 0d d4 ff ff       	call   c0100c90 <__panic>
}
c0103883:	90                   	nop
c0103884:	c9                   	leave  
c0103885:	c3                   	ret    

c0103886 <page2ppn>:
page2ppn(struct Page *page) {
c0103886:	55                   	push   %ebp
c0103887:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103889:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c010388f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103892:	29 d0                	sub    %edx,%eax
c0103894:	c1 f8 02             	sar    $0x2,%eax
c0103897:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010389d:	5d                   	pop    %ebp
c010389e:	c3                   	ret    

c010389f <page2pa>:
page2pa(struct Page *page) {
c010389f:	55                   	push   %ebp
c01038a0:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01038a2:	ff 75 08             	push   0x8(%ebp)
c01038a5:	e8 dc ff ff ff       	call   c0103886 <page2ppn>
c01038aa:	83 c4 04             	add    $0x4,%esp
c01038ad:	c1 e0 0c             	shl    $0xc,%eax
}
c01038b0:	c9                   	leave  
c01038b1:	c3                   	ret    

c01038b2 <pa2page>:
pa2page(uintptr_t pa) {
c01038b2:	55                   	push   %ebp
c01038b3:	89 e5                	mov    %esp,%ebp
c01038b5:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01038b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01038bb:	c1 e8 0c             	shr    $0xc,%eax
c01038be:	89 c2                	mov    %eax,%edx
c01038c0:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01038c5:	39 c2                	cmp    %eax,%edx
c01038c7:	72 14                	jb     c01038dd <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01038c9:	83 ec 04             	sub    $0x4,%esp
c01038cc:	68 3c 65 10 c0       	push   $0xc010653c
c01038d1:	6a 5a                	push   $0x5a
c01038d3:	68 5b 65 10 c0       	push   $0xc010655b
c01038d8:	e8 b3 d3 ff ff       	call   c0100c90 <__panic>
    return &pages[PPN(pa)];
c01038dd:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c01038e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e6:	c1 e8 0c             	shr    $0xc,%eax
c01038e9:	89 c2                	mov    %eax,%edx
c01038eb:	89 d0                	mov    %edx,%eax
c01038ed:	c1 e0 02             	shl    $0x2,%eax
c01038f0:	01 d0                	add    %edx,%eax
c01038f2:	c1 e0 02             	shl    $0x2,%eax
c01038f5:	01 c8                	add    %ecx,%eax
}
c01038f7:	c9                   	leave  
c01038f8:	c3                   	ret    

c01038f9 <page2kva>:
page2kva(struct Page *page) {
c01038f9:	55                   	push   %ebp
c01038fa:	89 e5                	mov    %esp,%ebp
c01038fc:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01038ff:	ff 75 08             	push   0x8(%ebp)
c0103902:	e8 98 ff ff ff       	call   c010389f <page2pa>
c0103907:	83 c4 04             	add    $0x4,%esp
c010390a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103910:	c1 e8 0c             	shr    $0xc,%eax
c0103913:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103916:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010391b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010391e:	72 14                	jb     c0103934 <page2kva+0x3b>
c0103920:	ff 75 f4             	push   -0xc(%ebp)
c0103923:	68 6c 65 10 c0       	push   $0xc010656c
c0103928:	6a 61                	push   $0x61
c010392a:	68 5b 65 10 c0       	push   $0xc010655b
c010392f:	e8 5c d3 ff ff       	call   c0100c90 <__panic>
c0103934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103937:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010393c:	c9                   	leave  
c010393d:	c3                   	ret    

c010393e <pte2page>:
pte2page(pte_t pte) {
c010393e:	55                   	push   %ebp
c010393f:	89 e5                	mov    %esp,%ebp
c0103941:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0103944:	8b 45 08             	mov    0x8(%ebp),%eax
c0103947:	83 e0 01             	and    $0x1,%eax
c010394a:	85 c0                	test   %eax,%eax
c010394c:	75 14                	jne    c0103962 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010394e:	83 ec 04             	sub    $0x4,%esp
c0103951:	68 90 65 10 c0       	push   $0xc0106590
c0103956:	6a 6c                	push   $0x6c
c0103958:	68 5b 65 10 c0       	push   $0xc010655b
c010395d:	e8 2e d3 ff ff       	call   c0100c90 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103962:	8b 45 08             	mov    0x8(%ebp),%eax
c0103965:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010396a:	83 ec 0c             	sub    $0xc,%esp
c010396d:	50                   	push   %eax
c010396e:	e8 3f ff ff ff       	call   c01038b2 <pa2page>
c0103973:	83 c4 10             	add    $0x10,%esp
}
c0103976:	c9                   	leave  
c0103977:	c3                   	ret    

c0103978 <pde2page>:
pde2page(pde_t pde) {
c0103978:	55                   	push   %ebp
c0103979:	89 e5                	mov    %esp,%ebp
c010397b:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010397e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103981:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103986:	83 ec 0c             	sub    $0xc,%esp
c0103989:	50                   	push   %eax
c010398a:	e8 23 ff ff ff       	call   c01038b2 <pa2page>
c010398f:	83 c4 10             	add    $0x10,%esp
}
c0103992:	c9                   	leave  
c0103993:	c3                   	ret    

c0103994 <page_ref>:
page_ref(struct Page *page) {
c0103994:	55                   	push   %ebp
c0103995:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103997:	8b 45 08             	mov    0x8(%ebp),%eax
c010399a:	8b 00                	mov    (%eax),%eax
}
c010399c:	5d                   	pop    %ebp
c010399d:	c3                   	ret    

c010399e <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010399e:	55                   	push   %ebp
c010399f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01039a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039a7:	89 10                	mov    %edx,(%eax)
}
c01039a9:	90                   	nop
c01039aa:	5d                   	pop    %ebp
c01039ab:	c3                   	ret    

c01039ac <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01039ac:	55                   	push   %ebp
c01039ad:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01039af:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b2:	8b 00                	mov    (%eax),%eax
c01039b4:	8d 50 01             	lea    0x1(%eax),%edx
c01039b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ba:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bf:	8b 00                	mov    (%eax),%eax
}
c01039c1:	5d                   	pop    %ebp
c01039c2:	c3                   	ret    

c01039c3 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01039c3:	55                   	push   %ebp
c01039c4:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01039c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c9:	8b 00                	mov    (%eax),%eax
c01039cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01039ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d1:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d6:	8b 00                	mov    (%eax),%eax
}
c01039d8:	5d                   	pop    %ebp
c01039d9:	c3                   	ret    

c01039da <__intr_save>:
__intr_save(void) {
c01039da:	55                   	push   %ebp
c01039db:	89 e5                	mov    %esp,%ebp
c01039dd:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01039e0:	9c                   	pushf  
c01039e1:	58                   	pop    %eax
c01039e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01039e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01039e8:	25 00 02 00 00       	and    $0x200,%eax
c01039ed:	85 c0                	test   %eax,%eax
c01039ef:	74 0c                	je     c01039fd <__intr_save+0x23>
        intr_disable();
c01039f1:	e8 df dc ff ff       	call   c01016d5 <intr_disable>
        return 1;
c01039f6:	b8 01 00 00 00       	mov    $0x1,%eax
c01039fb:	eb 05                	jmp    c0103a02 <__intr_save+0x28>
    return 0;
c01039fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a02:	c9                   	leave  
c0103a03:	c3                   	ret    

c0103a04 <__intr_restore>:
__intr_restore(bool flag) {
c0103a04:	55                   	push   %ebp
c0103a05:	89 e5                	mov    %esp,%ebp
c0103a07:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a0e:	74 05                	je     c0103a15 <__intr_restore+0x11>
        intr_enable();
c0103a10:	e8 b8 dc ff ff       	call   c01016cd <intr_enable>
}
c0103a15:	90                   	nop
c0103a16:	c9                   	leave  
c0103a17:	c3                   	ret    

c0103a18 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a18:	55                   	push   %ebp
c0103a19:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a21:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a26:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a28:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a2d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a2f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a34:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a36:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a3b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a3d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a42:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a44:	ea 4b 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a4b
}
c0103a4b:	90                   	nop
c0103a4c:	5d                   	pop    %ebp
c0103a4d:	c3                   	ret    

c0103a4e <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a4e:	55                   	push   %ebp
c0103a4f:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a54:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103a59:	90                   	nop
c0103a5a:	5d                   	pop    %ebp
c0103a5b:	c3                   	ret    

c0103a5c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103a5c:	55                   	push   %ebp
c0103a5d:	89 e5                	mov    %esp,%ebp
c0103a5f:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103a62:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103a67:	50                   	push   %eax
c0103a68:	e8 e1 ff ff ff       	call   c0103a4e <load_esp0>
c0103a6d:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0103a70:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103a77:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103a79:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103a80:	68 00 
c0103a82:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103a87:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103a8d:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103a92:	c1 e8 10             	shr    $0x10,%eax
c0103a95:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103a9a:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103aa1:	83 e0 f0             	and    $0xfffffff0,%eax
c0103aa4:	83 c8 09             	or     $0x9,%eax
c0103aa7:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103aac:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ab3:	83 e0 ef             	and    $0xffffffef,%eax
c0103ab6:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103abb:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ac2:	83 e0 9f             	and    $0xffffff9f,%eax
c0103ac5:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103aca:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ad1:	83 c8 80             	or     $0xffffff80,%eax
c0103ad4:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ad9:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ae0:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ae3:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ae8:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103aef:	83 e0 ef             	and    $0xffffffef,%eax
c0103af2:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103af7:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103afe:	83 e0 df             	and    $0xffffffdf,%eax
c0103b01:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b06:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b0d:	83 c8 40             	or     $0x40,%eax
c0103b10:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b15:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b1c:	83 e0 7f             	and    $0x7f,%eax
c0103b1f:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b24:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103b29:	c1 e8 18             	shr    $0x18,%eax
c0103b2c:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b31:	68 30 8a 11 c0       	push   $0xc0118a30
c0103b36:	e8 dd fe ff ff       	call   c0103a18 <lgdt>
c0103b3b:	83 c4 04             	add    $0x4,%esp
c0103b3e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b44:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103b48:	0f 00 d8             	ltr    %ax
}
c0103b4b:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103b4c:	90                   	nop
c0103b4d:	c9                   	leave  
c0103b4e:	c3                   	ret    

c0103b4f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b4f:	55                   	push   %ebp
c0103b50:	89 e5                	mov    %esp,%ebp
c0103b52:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0103b55:	c7 05 ac be 11 c0 20 	movl   $0xc0106520,0xc011beac
c0103b5c:	65 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103b5f:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103b64:	8b 00                	mov    (%eax),%eax
c0103b66:	83 ec 08             	sub    $0x8,%esp
c0103b69:	50                   	push   %eax
c0103b6a:	68 bc 65 10 c0       	push   $0xc01065bc
c0103b6f:	e8 bd c7 ff ff       	call   c0100331 <cprintf>
c0103b74:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0103b77:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103b7c:	8b 40 04             	mov    0x4(%eax),%eax
c0103b7f:	ff d0                	call   *%eax
}
c0103b81:	90                   	nop
c0103b82:	c9                   	leave  
c0103b83:	c3                   	ret    

c0103b84 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103b84:	55                   	push   %ebp
c0103b85:	89 e5                	mov    %esp,%ebp
c0103b87:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0103b8a:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103b8f:	8b 40 08             	mov    0x8(%eax),%eax
c0103b92:	83 ec 08             	sub    $0x8,%esp
c0103b95:	ff 75 0c             	push   0xc(%ebp)
c0103b98:	ff 75 08             	push   0x8(%ebp)
c0103b9b:	ff d0                	call   *%eax
c0103b9d:	83 c4 10             	add    $0x10,%esp
}
c0103ba0:	90                   	nop
c0103ba1:	c9                   	leave  
c0103ba2:	c3                   	ret    

c0103ba3 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103ba3:	55                   	push   %ebp
c0103ba4:	89 e5                	mov    %esp,%ebp
c0103ba6:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0103ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bb0:	e8 25 fe ff ff       	call   c01039da <__intr_save>
c0103bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103bb8:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bbd:	8b 40 0c             	mov    0xc(%eax),%eax
c0103bc0:	83 ec 0c             	sub    $0xc,%esp
c0103bc3:	ff 75 08             	push   0x8(%ebp)
c0103bc6:	ff d0                	call   *%eax
c0103bc8:	83 c4 10             	add    $0x10,%esp
c0103bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103bce:	83 ec 0c             	sub    $0xc,%esp
c0103bd1:	ff 75 f0             	push   -0x10(%ebp)
c0103bd4:	e8 2b fe ff ff       	call   c0103a04 <__intr_restore>
c0103bd9:	83 c4 10             	add    $0x10,%esp
    return page;
c0103bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103bdf:	c9                   	leave  
c0103be0:	c3                   	ret    

c0103be1 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103be1:	55                   	push   %ebp
c0103be2:	89 e5                	mov    %esp,%ebp
c0103be4:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103be7:	e8 ee fd ff ff       	call   c01039da <__intr_save>
c0103bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103bef:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bf4:	8b 40 10             	mov    0x10(%eax),%eax
c0103bf7:	83 ec 08             	sub    $0x8,%esp
c0103bfa:	ff 75 0c             	push   0xc(%ebp)
c0103bfd:	ff 75 08             	push   0x8(%ebp)
c0103c00:	ff d0                	call   *%eax
c0103c02:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0103c05:	83 ec 0c             	sub    $0xc,%esp
c0103c08:	ff 75 f4             	push   -0xc(%ebp)
c0103c0b:	e8 f4 fd ff ff       	call   c0103a04 <__intr_restore>
c0103c10:	83 c4 10             	add    $0x10,%esp
}
c0103c13:	90                   	nop
c0103c14:	c9                   	leave  
c0103c15:	c3                   	ret    

c0103c16 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c16:	55                   	push   %ebp
c0103c17:	89 e5                	mov    %esp,%ebp
c0103c19:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c1c:	e8 b9 fd ff ff       	call   c01039da <__intr_save>
c0103c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c24:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c29:	8b 40 14             	mov    0x14(%eax),%eax
c0103c2c:	ff d0                	call   *%eax
c0103c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c31:	83 ec 0c             	sub    $0xc,%esp
c0103c34:	ff 75 f4             	push   -0xc(%ebp)
c0103c37:	e8 c8 fd ff ff       	call   c0103a04 <__intr_restore>
c0103c3c:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c42:	c9                   	leave  
c0103c43:	c3                   	ret    

c0103c44 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c44:	55                   	push   %ebp
c0103c45:	89 e5                	mov    %esp,%ebp
c0103c47:	57                   	push   %edi
c0103c48:	56                   	push   %esi
c0103c49:	53                   	push   %ebx
c0103c4a:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c4d:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c54:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103c5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103c62:	83 ec 0c             	sub    $0xc,%esp
c0103c65:	68 d3 65 10 c0       	push   $0xc01065d3
c0103c6a:	e8 c2 c6 ff ff       	call   c0100331 <cprintf>
c0103c6f:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c72:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103c79:	e9 f4 00 00 00       	jmp    c0103d72 <page_init+0x12e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103c7e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c81:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c84:	89 d0                	mov    %edx,%eax
c0103c86:	c1 e0 02             	shl    $0x2,%eax
c0103c89:	01 d0                	add    %edx,%eax
c0103c8b:	c1 e0 02             	shl    $0x2,%eax
c0103c8e:	01 c8                	add    %ecx,%eax
c0103c90:	8b 50 08             	mov    0x8(%eax),%edx
c0103c93:	8b 40 04             	mov    0x4(%eax),%eax
c0103c96:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103c99:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103c9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ca2:	89 d0                	mov    %edx,%eax
c0103ca4:	c1 e0 02             	shl    $0x2,%eax
c0103ca7:	01 d0                	add    %edx,%eax
c0103ca9:	c1 e0 02             	shl    $0x2,%eax
c0103cac:	01 c8                	add    %ecx,%eax
c0103cae:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103cb1:	8b 58 10             	mov    0x10(%eax),%ebx
c0103cb4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103cb7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103cba:	01 c8                	add    %ecx,%eax
c0103cbc:	11 da                	adc    %ebx,%edx
c0103cbe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103cc1:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103cc4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cca:	89 d0                	mov    %edx,%eax
c0103ccc:	c1 e0 02             	shl    $0x2,%eax
c0103ccf:	01 d0                	add    %edx,%eax
c0103cd1:	c1 e0 02             	shl    $0x2,%eax
c0103cd4:	01 c8                	add    %ecx,%eax
c0103cd6:	83 c0 14             	add    $0x14,%eax
c0103cd9:	8b 00                	mov    (%eax),%eax
c0103cdb:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103cde:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103ce1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103ce4:	83 c0 ff             	add    $0xffffffff,%eax
c0103ce7:	83 d2 ff             	adc    $0xffffffff,%edx
c0103cea:	89 c1                	mov    %eax,%ecx
c0103cec:	89 d3                	mov    %edx,%ebx
c0103cee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103cf1:	89 55 80             	mov    %edx,-0x80(%ebp)
c0103cf4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cf7:	89 d0                	mov    %edx,%eax
c0103cf9:	c1 e0 02             	shl    $0x2,%eax
c0103cfc:	01 d0                	add    %edx,%eax
c0103cfe:	c1 e0 02             	shl    $0x2,%eax
c0103d01:	03 45 80             	add    -0x80(%ebp),%eax
c0103d04:	8b 50 10             	mov    0x10(%eax),%edx
c0103d07:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d0a:	ff 75 84             	push   -0x7c(%ebp)
c0103d0d:	53                   	push   %ebx
c0103d0e:	51                   	push   %ecx
c0103d0f:	ff 75 a4             	push   -0x5c(%ebp)
c0103d12:	ff 75 a0             	push   -0x60(%ebp)
c0103d15:	52                   	push   %edx
c0103d16:	50                   	push   %eax
c0103d17:	68 e0 65 10 c0       	push   $0xc01065e0
c0103d1c:	e8 10 c6 ff ff       	call   c0100331 <cprintf>
c0103d21:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103d24:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d27:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d2a:	89 d0                	mov    %edx,%eax
c0103d2c:	c1 e0 02             	shl    $0x2,%eax
c0103d2f:	01 d0                	add    %edx,%eax
c0103d31:	c1 e0 02             	shl    $0x2,%eax
c0103d34:	01 c8                	add    %ecx,%eax
c0103d36:	83 c0 14             	add    $0x14,%eax
c0103d39:	8b 00                	mov    (%eax),%eax
c0103d3b:	83 f8 01             	cmp    $0x1,%eax
c0103d3e:	75 2e                	jne    c0103d6e <page_init+0x12a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d46:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103d49:	89 d0                	mov    %edx,%eax
c0103d4b:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0103d4e:	73 1e                	jae    c0103d6e <page_init+0x12a>
c0103d50:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103d55:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d5a:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0103d5d:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103d60:	72 0c                	jb     c0103d6e <page_init+0x12a>
                maxpa = end;
c0103d62:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103d65:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d6e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103d72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d75:	8b 00                	mov    (%eax),%eax
c0103d77:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d7a:	0f 8c fe fe ff ff    	jl     c0103c7e <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103d80:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103d85:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d8a:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103d8d:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103d90:	73 0e                	jae    c0103da0 <page_init+0x15c>
        maxpa = KMEMSIZE;
c0103d92:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103d99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103da3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103da6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103daa:	c1 ea 0c             	shr    $0xc,%edx
c0103dad:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103db2:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0103db9:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0103dbe:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103dc1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103dc4:	01 d0                	add    %edx,%eax
c0103dc6:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103dc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103dcc:	ba 00 00 00 00       	mov    $0x0,%edx
c0103dd1:	f7 75 c0             	divl   -0x40(%ebp)
c0103dd4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103dd7:	29 d0                	sub    %edx,%eax
c0103dd9:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c0103dde:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103de5:	eb 30                	jmp    c0103e17 <page_init+0x1d3>
        SetPageReserved(pages + i);
c0103de7:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103ded:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df0:	89 d0                	mov    %edx,%eax
c0103df2:	c1 e0 02             	shl    $0x2,%eax
c0103df5:	01 d0                	add    %edx,%eax
c0103df7:	c1 e0 02             	shl    $0x2,%eax
c0103dfa:	01 c8                	add    %ecx,%eax
c0103dfc:	83 c0 04             	add    $0x4,%eax
c0103dff:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103e06:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103e09:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103e0c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103e0f:	0f ab 10             	bts    %edx,(%eax)
}
c0103e12:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103e13:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e17:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e1a:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103e1f:	39 c2                	cmp    %eax,%edx
c0103e21:	72 c4                	jb     c0103de7 <page_init+0x1a3>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e23:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103e29:	89 d0                	mov    %edx,%eax
c0103e2b:	c1 e0 02             	shl    $0x2,%eax
c0103e2e:	01 d0                	add    %edx,%eax
c0103e30:	c1 e0 02             	shl    $0x2,%eax
c0103e33:	89 c2                	mov    %eax,%edx
c0103e35:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c0103e3a:	01 d0                	add    %edx,%eax
c0103e3c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e3f:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103e46:	77 17                	ja     c0103e5f <page_init+0x21b>
c0103e48:	ff 75 b8             	push   -0x48(%ebp)
c0103e4b:	68 10 66 10 c0       	push   $0xc0106610
c0103e50:	68 dc 00 00 00       	push   $0xdc
c0103e55:	68 34 66 10 c0       	push   $0xc0106634
c0103e5a:	e8 31 ce ff ff       	call   c0100c90 <__panic>
c0103e5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e62:	05 00 00 00 40       	add    $0x40000000,%eax
c0103e67:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103e6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e71:	e9 53 01 00 00       	jmp    c0103fc9 <page_init+0x385>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e76:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e7c:	89 d0                	mov    %edx,%eax
c0103e7e:	c1 e0 02             	shl    $0x2,%eax
c0103e81:	01 d0                	add    %edx,%eax
c0103e83:	c1 e0 02             	shl    $0x2,%eax
c0103e86:	01 c8                	add    %ecx,%eax
c0103e88:	8b 50 08             	mov    0x8(%eax),%edx
c0103e8b:	8b 40 04             	mov    0x4(%eax),%eax
c0103e8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e91:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e94:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e97:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e9a:	89 d0                	mov    %edx,%eax
c0103e9c:	c1 e0 02             	shl    $0x2,%eax
c0103e9f:	01 d0                	add    %edx,%eax
c0103ea1:	c1 e0 02             	shl    $0x2,%eax
c0103ea4:	01 c8                	add    %ecx,%eax
c0103ea6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ea9:	8b 58 10             	mov    0x10(%eax),%ebx
c0103eac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103eaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103eb2:	01 c8                	add    %ecx,%eax
c0103eb4:	11 da                	adc    %ebx,%edx
c0103eb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103eb9:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ebc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ec2:	89 d0                	mov    %edx,%eax
c0103ec4:	c1 e0 02             	shl    $0x2,%eax
c0103ec7:	01 d0                	add    %edx,%eax
c0103ec9:	c1 e0 02             	shl    $0x2,%eax
c0103ecc:	01 c8                	add    %ecx,%eax
c0103ece:	83 c0 14             	add    $0x14,%eax
c0103ed1:	8b 00                	mov    (%eax),%eax
c0103ed3:	83 f8 01             	cmp    $0x1,%eax
c0103ed6:	0f 85 e9 00 00 00    	jne    c0103fc5 <page_init+0x381>
            if (begin < freemem) {
c0103edc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103edf:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ee4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103ee7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103eea:	19 d1                	sbb    %edx,%ecx
c0103eec:	73 0d                	jae    c0103efb <page_init+0x2b7>
                begin = freemem;
c0103eee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ef1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ef4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103efb:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103f00:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f05:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103f08:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f0b:	73 0e                	jae    c0103f1b <page_init+0x2d7>
                end = KMEMSIZE;
c0103f0d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103f14:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103f1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f21:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f24:	89 d0                	mov    %edx,%eax
c0103f26:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f29:	0f 83 96 00 00 00    	jae    c0103fc5 <page_init+0x381>
                begin = ROUNDUP(begin, PGSIZE);
c0103f2f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103f36:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f39:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f3c:	01 d0                	add    %edx,%eax
c0103f3e:	83 e8 01             	sub    $0x1,%eax
c0103f41:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103f44:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f47:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f4c:	f7 75 b0             	divl   -0x50(%ebp)
c0103f4f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f52:	29 d0                	sub    %edx,%eax
c0103f54:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f59:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f5c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103f5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f62:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f65:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f68:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f6d:	89 c3                	mov    %eax,%ebx
c0103f6f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103f75:	89 de                	mov    %ebx,%esi
c0103f77:	89 d0                	mov    %edx,%eax
c0103f79:	83 e0 00             	and    $0x0,%eax
c0103f7c:	89 c7                	mov    %eax,%edi
c0103f7e:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103f81:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103f84:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f8a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f8d:	89 d0                	mov    %edx,%eax
c0103f8f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f92:	73 31                	jae    c0103fc5 <page_init+0x381>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103f94:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f97:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103f9a:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103f9d:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103fa0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fa4:	c1 ea 0c             	shr    $0xc,%edx
c0103fa7:	89 c3                	mov    %eax,%ebx
c0103fa9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fac:	83 ec 0c             	sub    $0xc,%esp
c0103faf:	50                   	push   %eax
c0103fb0:	e8 fd f8 ff ff       	call   c01038b2 <pa2page>
c0103fb5:	83 c4 10             	add    $0x10,%esp
c0103fb8:	83 ec 08             	sub    $0x8,%esp
c0103fbb:	53                   	push   %ebx
c0103fbc:	50                   	push   %eax
c0103fbd:	e8 c2 fb ff ff       	call   c0103b84 <init_memmap>
c0103fc2:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fc5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103fcc:	8b 00                	mov    (%eax),%eax
c0103fce:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103fd1:	0f 8c 9f fe ff ff    	jl     c0103e76 <page_init+0x232>
                }
            }
        }
    }
}
c0103fd7:	90                   	nop
c0103fd8:	90                   	nop
c0103fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103fdc:	5b                   	pop    %ebx
c0103fdd:	5e                   	pop    %esi
c0103fde:	5f                   	pop    %edi
c0103fdf:	5d                   	pop    %ebp
c0103fe0:	c3                   	ret    

c0103fe1 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103fe1:	55                   	push   %ebp
c0103fe2:	89 e5                	mov    %esp,%ebp
c0103fe4:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fea:	33 45 14             	xor    0x14(%ebp),%eax
c0103fed:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103ff2:	85 c0                	test   %eax,%eax
c0103ff4:	74 19                	je     c010400f <boot_map_segment+0x2e>
c0103ff6:	68 42 66 10 c0       	push   $0xc0106642
c0103ffb:	68 59 66 10 c0       	push   $0xc0106659
c0104000:	68 fa 00 00 00       	push   $0xfa
c0104005:	68 34 66 10 c0       	push   $0xc0106634
c010400a:	e8 81 cc ff ff       	call   c0100c90 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010400f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104016:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104019:	25 ff 0f 00 00       	and    $0xfff,%eax
c010401e:	89 c2                	mov    %eax,%edx
c0104020:	8b 45 10             	mov    0x10(%ebp),%eax
c0104023:	01 c2                	add    %eax,%edx
c0104025:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104028:	01 d0                	add    %edx,%eax
c010402a:	83 e8 01             	sub    $0x1,%eax
c010402d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104030:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104033:	ba 00 00 00 00       	mov    $0x0,%edx
c0104038:	f7 75 f0             	divl   -0x10(%ebp)
c010403b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010403e:	29 d0                	sub    %edx,%eax
c0104040:	c1 e8 0c             	shr    $0xc,%eax
c0104043:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104046:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104049:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010404c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010404f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104054:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104057:	8b 45 14             	mov    0x14(%ebp),%eax
c010405a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104060:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104065:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104068:	eb 57                	jmp    c01040c1 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010406a:	83 ec 04             	sub    $0x4,%esp
c010406d:	6a 01                	push   $0x1
c010406f:	ff 75 0c             	push   0xc(%ebp)
c0104072:	ff 75 08             	push   0x8(%ebp)
c0104075:	e8 54 01 00 00       	call   c01041ce <get_pte>
c010407a:	83 c4 10             	add    $0x10,%esp
c010407d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104080:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104084:	75 19                	jne    c010409f <boot_map_segment+0xbe>
c0104086:	68 6e 66 10 c0       	push   $0xc010666e
c010408b:	68 59 66 10 c0       	push   $0xc0106659
c0104090:	68 00 01 00 00       	push   $0x100
c0104095:	68 34 66 10 c0       	push   $0xc0106634
c010409a:	e8 f1 cb ff ff       	call   c0100c90 <__panic>
        *ptep = pa | PTE_P | perm;
c010409f:	8b 45 14             	mov    0x14(%ebp),%eax
c01040a2:	0b 45 18             	or     0x18(%ebp),%eax
c01040a5:	83 c8 01             	or     $0x1,%eax
c01040a8:	89 c2                	mov    %eax,%edx
c01040aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040ad:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01040af:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01040b3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01040ba:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01040c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040c5:	75 a3                	jne    c010406a <boot_map_segment+0x89>
    }
}
c01040c7:	90                   	nop
c01040c8:	90                   	nop
c01040c9:	c9                   	leave  
c01040ca:	c3                   	ret    

c01040cb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01040cb:	55                   	push   %ebp
c01040cc:	89 e5                	mov    %esp,%ebp
c01040ce:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01040d1:	83 ec 0c             	sub    $0xc,%esp
c01040d4:	6a 01                	push   $0x1
c01040d6:	e8 c8 fa ff ff       	call   c0103ba3 <alloc_pages>
c01040db:	83 c4 10             	add    $0x10,%esp
c01040de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01040e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040e5:	75 17                	jne    c01040fe <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01040e7:	83 ec 04             	sub    $0x4,%esp
c01040ea:	68 7b 66 10 c0       	push   $0xc010667b
c01040ef:	68 0c 01 00 00       	push   $0x10c
c01040f4:	68 34 66 10 c0       	push   $0xc0106634
c01040f9:	e8 92 cb ff ff       	call   c0100c90 <__panic>
    }
    return page2kva(p);
c01040fe:	83 ec 0c             	sub    $0xc,%esp
c0104101:	ff 75 f4             	push   -0xc(%ebp)
c0104104:	e8 f0 f7 ff ff       	call   c01038f9 <page2kva>
c0104109:	83 c4 10             	add    $0x10,%esp
}
c010410c:	c9                   	leave  
c010410d:	c3                   	ret    

c010410e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010410e:	55                   	push   %ebp
c010410f:	89 e5                	mov    %esp,%ebp
c0104111:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104114:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104119:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010411c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104123:	77 17                	ja     c010413c <pmm_init+0x2e>
c0104125:	ff 75 f4             	push   -0xc(%ebp)
c0104128:	68 10 66 10 c0       	push   $0xc0106610
c010412d:	68 16 01 00 00       	push   $0x116
c0104132:	68 34 66 10 c0       	push   $0xc0106634
c0104137:	e8 54 cb ff ff       	call   c0100c90 <__panic>
c010413c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010413f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104144:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104149:	e8 01 fa ff ff       	call   c0103b4f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010414e:	e8 f1 fa ff ff       	call   c0103c44 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104153:	e8 91 03 00 00       	call   c01044e9 <check_alloc_page>

    check_pgdir();
c0104158:	e8 af 03 00 00       	call   c010450c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010415d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104162:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104165:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010416c:	77 17                	ja     c0104185 <pmm_init+0x77>
c010416e:	ff 75 f0             	push   -0x10(%ebp)
c0104171:	68 10 66 10 c0       	push   $0xc0106610
c0104176:	68 2c 01 00 00       	push   $0x12c
c010417b:	68 34 66 10 c0       	push   $0xc0106634
c0104180:	e8 0b cb ff ff       	call   c0100c90 <__panic>
c0104185:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104188:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010418e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104193:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104198:	83 ca 03             	or     $0x3,%edx
c010419b:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010419d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041a2:	83 ec 0c             	sub    $0xc,%esp
c01041a5:	6a 02                	push   $0x2
c01041a7:	6a 00                	push   $0x0
c01041a9:	68 00 00 00 38       	push   $0x38000000
c01041ae:	68 00 00 00 c0       	push   $0xc0000000
c01041b3:	50                   	push   %eax
c01041b4:	e8 28 fe ff ff       	call   c0103fe1 <boot_map_segment>
c01041b9:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01041bc:	e8 9b f8 ff ff       	call   c0103a5c <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01041c1:	e8 ac 08 00 00       	call   c0104a72 <check_boot_pgdir>

    print_pgdir();
c01041c6:	e8 a2 0c 00 00       	call   c0104e6d <print_pgdir>

}
c01041cb:	90                   	nop
c01041cc:	c9                   	leave  
c01041cd:	c3                   	ret    

c01041ce <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041ce:	55                   	push   %ebp
c01041cf:	89 e5                	mov    %esp,%ebp
c01041d1:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01041d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041d7:	c1 e8 16             	shr    $0x16,%eax
c01041da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01041e4:	01 d0                	add    %edx,%eax
c01041e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01041e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ec:	8b 00                	mov    (%eax),%eax
c01041ee:	83 e0 01             	and    $0x1,%eax
c01041f1:	85 c0                	test   %eax,%eax
c01041f3:	0f 85 9f 00 00 00    	jne    c0104298 <get_pte+0xca>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01041f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01041fd:	74 16                	je     c0104215 <get_pte+0x47>
c01041ff:	83 ec 0c             	sub    $0xc,%esp
c0104202:	6a 01                	push   $0x1
c0104204:	e8 9a f9 ff ff       	call   c0103ba3 <alloc_pages>
c0104209:	83 c4 10             	add    $0x10,%esp
c010420c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010420f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104213:	75 0a                	jne    c010421f <get_pte+0x51>
            return NULL;
c0104215:	b8 00 00 00 00       	mov    $0x0,%eax
c010421a:	e9 ca 00 00 00       	jmp    c01042e9 <get_pte+0x11b>
        }
        set_page_ref(page, 1);
c010421f:	83 ec 08             	sub    $0x8,%esp
c0104222:	6a 01                	push   $0x1
c0104224:	ff 75 f0             	push   -0x10(%ebp)
c0104227:	e8 72 f7 ff ff       	call   c010399e <set_page_ref>
c010422c:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c010422f:	83 ec 0c             	sub    $0xc,%esp
c0104232:	ff 75 f0             	push   -0x10(%ebp)
c0104235:	e8 65 f6 ff ff       	call   c010389f <page2pa>
c010423a:	83 c4 10             	add    $0x10,%esp
c010423d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104240:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104243:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104246:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104249:	c1 e8 0c             	shr    $0xc,%eax
c010424c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010424f:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104254:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104257:	72 17                	jb     c0104270 <get_pte+0xa2>
c0104259:	ff 75 e8             	push   -0x18(%ebp)
c010425c:	68 6c 65 10 c0       	push   $0xc010656c
c0104261:	68 72 01 00 00       	push   $0x172
c0104266:	68 34 66 10 c0       	push   $0xc0106634
c010426b:	e8 20 ca ff ff       	call   c0100c90 <__panic>
c0104270:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104273:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104278:	83 ec 04             	sub    $0x4,%esp
c010427b:	68 00 10 00 00       	push   $0x1000
c0104280:	6a 00                	push   $0x0
c0104282:	50                   	push   %eax
c0104283:	e8 63 16 00 00       	call   c01058eb <memset>
c0104288:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010428b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010428e:	83 c8 07             	or     $0x7,%eax
c0104291:	89 c2                	mov    %eax,%edx
c0104293:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104296:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104298:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010429b:	8b 00                	mov    (%eax),%eax
c010429d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01042a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042a8:	c1 e8 0c             	shr    $0xc,%eax
c01042ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01042ae:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01042b3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01042b6:	72 17                	jb     c01042cf <get_pte+0x101>
c01042b8:	ff 75 e0             	push   -0x20(%ebp)
c01042bb:	68 6c 65 10 c0       	push   $0xc010656c
c01042c0:	68 75 01 00 00       	push   $0x175
c01042c5:	68 34 66 10 c0       	push   $0xc0106634
c01042ca:	e8 c1 c9 ff ff       	call   c0100c90 <__panic>
c01042cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042d2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01042d7:	89 c2                	mov    %eax,%edx
c01042d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042dc:	c1 e8 0c             	shr    $0xc,%eax
c01042df:	25 ff 03 00 00       	and    $0x3ff,%eax
c01042e4:	c1 e0 02             	shl    $0x2,%eax
c01042e7:	01 d0                	add    %edx,%eax
}
c01042e9:	c9                   	leave  
c01042ea:	c3                   	ret    

c01042eb <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01042eb:	55                   	push   %ebp
c01042ec:	89 e5                	mov    %esp,%ebp
c01042ee:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01042f1:	83 ec 04             	sub    $0x4,%esp
c01042f4:	6a 00                	push   $0x0
c01042f6:	ff 75 0c             	push   0xc(%ebp)
c01042f9:	ff 75 08             	push   0x8(%ebp)
c01042fc:	e8 cd fe ff ff       	call   c01041ce <get_pte>
c0104301:	83 c4 10             	add    $0x10,%esp
c0104304:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104307:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010430b:	74 08                	je     c0104315 <get_page+0x2a>
        *ptep_store = ptep;
c010430d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104310:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104313:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104319:	74 1f                	je     c010433a <get_page+0x4f>
c010431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431e:	8b 00                	mov    (%eax),%eax
c0104320:	83 e0 01             	and    $0x1,%eax
c0104323:	85 c0                	test   %eax,%eax
c0104325:	74 13                	je     c010433a <get_page+0x4f>
        return pte2page(*ptep);
c0104327:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010432a:	8b 00                	mov    (%eax),%eax
c010432c:	83 ec 0c             	sub    $0xc,%esp
c010432f:	50                   	push   %eax
c0104330:	e8 09 f6 ff ff       	call   c010393e <pte2page>
c0104335:	83 c4 10             	add    $0x10,%esp
c0104338:	eb 05                	jmp    c010433f <get_page+0x54>
    }
    return NULL;
c010433a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010433f:	c9                   	leave  
c0104340:	c3                   	ret    

c0104341 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104341:	55                   	push   %ebp
c0104342:	89 e5                	mov    %esp,%ebp
c0104344:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104347:	8b 45 10             	mov    0x10(%ebp),%eax
c010434a:	8b 00                	mov    (%eax),%eax
c010434c:	83 e0 01             	and    $0x1,%eax
c010434f:	85 c0                	test   %eax,%eax
c0104351:	74 50                	je     c01043a3 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0104353:	8b 45 10             	mov    0x10(%ebp),%eax
c0104356:	8b 00                	mov    (%eax),%eax
c0104358:	83 ec 0c             	sub    $0xc,%esp
c010435b:	50                   	push   %eax
c010435c:	e8 dd f5 ff ff       	call   c010393e <pte2page>
c0104361:	83 c4 10             	add    $0x10,%esp
c0104364:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104367:	83 ec 0c             	sub    $0xc,%esp
c010436a:	ff 75 f4             	push   -0xc(%ebp)
c010436d:	e8 51 f6 ff ff       	call   c01039c3 <page_ref_dec>
c0104372:	83 c4 10             	add    $0x10,%esp
c0104375:	85 c0                	test   %eax,%eax
c0104377:	75 10                	jne    c0104389 <page_remove_pte+0x48>
            free_page(page);
c0104379:	83 ec 08             	sub    $0x8,%esp
c010437c:	6a 01                	push   $0x1
c010437e:	ff 75 f4             	push   -0xc(%ebp)
c0104381:	e8 5b f8 ff ff       	call   c0103be1 <free_pages>
c0104386:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c0104389:	8b 45 10             	mov    0x10(%ebp),%eax
c010438c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104392:	83 ec 08             	sub    $0x8,%esp
c0104395:	ff 75 0c             	push   0xc(%ebp)
c0104398:	ff 75 08             	push   0x8(%ebp)
c010439b:	e8 f8 00 00 00       	call   c0104498 <tlb_invalidate>
c01043a0:	83 c4 10             	add    $0x10,%esp
    }
}
c01043a3:	90                   	nop
c01043a4:	c9                   	leave  
c01043a5:	c3                   	ret    

c01043a6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01043a6:	55                   	push   %ebp
c01043a7:	89 e5                	mov    %esp,%ebp
c01043a9:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01043ac:	83 ec 04             	sub    $0x4,%esp
c01043af:	6a 00                	push   $0x0
c01043b1:	ff 75 0c             	push   0xc(%ebp)
c01043b4:	ff 75 08             	push   0x8(%ebp)
c01043b7:	e8 12 fe ff ff       	call   c01041ce <get_pte>
c01043bc:	83 c4 10             	add    $0x10,%esp
c01043bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01043c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043c6:	74 14                	je     c01043dc <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01043c8:	83 ec 04             	sub    $0x4,%esp
c01043cb:	ff 75 f4             	push   -0xc(%ebp)
c01043ce:	ff 75 0c             	push   0xc(%ebp)
c01043d1:	ff 75 08             	push   0x8(%ebp)
c01043d4:	e8 68 ff ff ff       	call   c0104341 <page_remove_pte>
c01043d9:	83 c4 10             	add    $0x10,%esp
    }
}
c01043dc:	90                   	nop
c01043dd:	c9                   	leave  
c01043de:	c3                   	ret    

c01043df <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01043df:	55                   	push   %ebp
c01043e0:	89 e5                	mov    %esp,%ebp
c01043e2:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01043e5:	83 ec 04             	sub    $0x4,%esp
c01043e8:	6a 01                	push   $0x1
c01043ea:	ff 75 10             	push   0x10(%ebp)
c01043ed:	ff 75 08             	push   0x8(%ebp)
c01043f0:	e8 d9 fd ff ff       	call   c01041ce <get_pte>
c01043f5:	83 c4 10             	add    $0x10,%esp
c01043f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01043fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043ff:	75 0a                	jne    c010440b <page_insert+0x2c>
        return -E_NO_MEM;
c0104401:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104406:	e9 8b 00 00 00       	jmp    c0104496 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010440b:	83 ec 0c             	sub    $0xc,%esp
c010440e:	ff 75 0c             	push   0xc(%ebp)
c0104411:	e8 96 f5 ff ff       	call   c01039ac <page_ref_inc>
c0104416:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0104419:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010441c:	8b 00                	mov    (%eax),%eax
c010441e:	83 e0 01             	and    $0x1,%eax
c0104421:	85 c0                	test   %eax,%eax
c0104423:	74 40                	je     c0104465 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0104425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104428:	8b 00                	mov    (%eax),%eax
c010442a:	83 ec 0c             	sub    $0xc,%esp
c010442d:	50                   	push   %eax
c010442e:	e8 0b f5 ff ff       	call   c010393e <pte2page>
c0104433:	83 c4 10             	add    $0x10,%esp
c0104436:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104439:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010443c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010443f:	75 10                	jne    c0104451 <page_insert+0x72>
            page_ref_dec(page);
c0104441:	83 ec 0c             	sub    $0xc,%esp
c0104444:	ff 75 0c             	push   0xc(%ebp)
c0104447:	e8 77 f5 ff ff       	call   c01039c3 <page_ref_dec>
c010444c:	83 c4 10             	add    $0x10,%esp
c010444f:	eb 14                	jmp    c0104465 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104451:	83 ec 04             	sub    $0x4,%esp
c0104454:	ff 75 f4             	push   -0xc(%ebp)
c0104457:	ff 75 10             	push   0x10(%ebp)
c010445a:	ff 75 08             	push   0x8(%ebp)
c010445d:	e8 df fe ff ff       	call   c0104341 <page_remove_pte>
c0104462:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104465:	83 ec 0c             	sub    $0xc,%esp
c0104468:	ff 75 0c             	push   0xc(%ebp)
c010446b:	e8 2f f4 ff ff       	call   c010389f <page2pa>
c0104470:	83 c4 10             	add    $0x10,%esp
c0104473:	0b 45 14             	or     0x14(%ebp),%eax
c0104476:	83 c8 01             	or     $0x1,%eax
c0104479:	89 c2                	mov    %eax,%edx
c010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010447e:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104480:	83 ec 08             	sub    $0x8,%esp
c0104483:	ff 75 10             	push   0x10(%ebp)
c0104486:	ff 75 08             	push   0x8(%ebp)
c0104489:	e8 0a 00 00 00       	call   c0104498 <tlb_invalidate>
c010448e:	83 c4 10             	add    $0x10,%esp
    return 0;
c0104491:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104496:	c9                   	leave  
c0104497:	c3                   	ret    

c0104498 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104498:	55                   	push   %ebp
c0104499:	89 e5                	mov    %esp,%ebp
c010449b:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010449e:	0f 20 d8             	mov    %cr3,%eax
c01044a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01044a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01044a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01044aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044ad:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044b4:	77 17                	ja     c01044cd <tlb_invalidate+0x35>
c01044b6:	ff 75 f4             	push   -0xc(%ebp)
c01044b9:	68 10 66 10 c0       	push   $0xc0106610
c01044be:	68 d7 01 00 00       	push   $0x1d7
c01044c3:	68 34 66 10 c0       	push   $0xc0106634
c01044c8:	e8 c3 c7 ff ff       	call   c0100c90 <__panic>
c01044cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d0:	05 00 00 00 40       	add    $0x40000000,%eax
c01044d5:	39 d0                	cmp    %edx,%eax
c01044d7:	75 0d                	jne    c01044e6 <tlb_invalidate+0x4e>
        invlpg((void *)la);
c01044d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01044df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044e2:	0f 01 38             	invlpg (%eax)
}
c01044e5:	90                   	nop
    }
}
c01044e6:	90                   	nop
c01044e7:	c9                   	leave  
c01044e8:	c3                   	ret    

c01044e9 <check_alloc_page>:

static void
check_alloc_page(void) {
c01044e9:	55                   	push   %ebp
c01044ea:	89 e5                	mov    %esp,%ebp
c01044ec:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01044ef:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c01044f4:	8b 40 18             	mov    0x18(%eax),%eax
c01044f7:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01044f9:	83 ec 0c             	sub    $0xc,%esp
c01044fc:	68 94 66 10 c0       	push   $0xc0106694
c0104501:	e8 2b be ff ff       	call   c0100331 <cprintf>
c0104506:	83 c4 10             	add    $0x10,%esp
}
c0104509:	90                   	nop
c010450a:	c9                   	leave  
c010450b:	c3                   	ret    

c010450c <check_pgdir>:

static void
check_pgdir(void) {
c010450c:	55                   	push   %ebp
c010450d:	89 e5                	mov    %esp,%ebp
c010450f:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104512:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104517:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010451c:	76 19                	jbe    c0104537 <check_pgdir+0x2b>
c010451e:	68 b3 66 10 c0       	push   $0xc01066b3
c0104523:	68 59 66 10 c0       	push   $0xc0106659
c0104528:	68 e4 01 00 00       	push   $0x1e4
c010452d:	68 34 66 10 c0       	push   $0xc0106634
c0104532:	e8 59 c7 ff ff       	call   c0100c90 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104537:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010453c:	85 c0                	test   %eax,%eax
c010453e:	74 0e                	je     c010454e <check_pgdir+0x42>
c0104540:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104545:	25 ff 0f 00 00       	and    $0xfff,%eax
c010454a:	85 c0                	test   %eax,%eax
c010454c:	74 19                	je     c0104567 <check_pgdir+0x5b>
c010454e:	68 d0 66 10 c0       	push   $0xc01066d0
c0104553:	68 59 66 10 c0       	push   $0xc0106659
c0104558:	68 e5 01 00 00       	push   $0x1e5
c010455d:	68 34 66 10 c0       	push   $0xc0106634
c0104562:	e8 29 c7 ff ff       	call   c0100c90 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104567:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010456c:	83 ec 04             	sub    $0x4,%esp
c010456f:	6a 00                	push   $0x0
c0104571:	6a 00                	push   $0x0
c0104573:	50                   	push   %eax
c0104574:	e8 72 fd ff ff       	call   c01042eb <get_page>
c0104579:	83 c4 10             	add    $0x10,%esp
c010457c:	85 c0                	test   %eax,%eax
c010457e:	74 19                	je     c0104599 <check_pgdir+0x8d>
c0104580:	68 08 67 10 c0       	push   $0xc0106708
c0104585:	68 59 66 10 c0       	push   $0xc0106659
c010458a:	68 e6 01 00 00       	push   $0x1e6
c010458f:	68 34 66 10 c0       	push   $0xc0106634
c0104594:	e8 f7 c6 ff ff       	call   c0100c90 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104599:	83 ec 0c             	sub    $0xc,%esp
c010459c:	6a 01                	push   $0x1
c010459e:	e8 00 f6 ff ff       	call   c0103ba3 <alloc_pages>
c01045a3:	83 c4 10             	add    $0x10,%esp
c01045a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01045a9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045ae:	6a 00                	push   $0x0
c01045b0:	6a 00                	push   $0x0
c01045b2:	ff 75 f4             	push   -0xc(%ebp)
c01045b5:	50                   	push   %eax
c01045b6:	e8 24 fe ff ff       	call   c01043df <page_insert>
c01045bb:	83 c4 10             	add    $0x10,%esp
c01045be:	85 c0                	test   %eax,%eax
c01045c0:	74 19                	je     c01045db <check_pgdir+0xcf>
c01045c2:	68 30 67 10 c0       	push   $0xc0106730
c01045c7:	68 59 66 10 c0       	push   $0xc0106659
c01045cc:	68 ea 01 00 00       	push   $0x1ea
c01045d1:	68 34 66 10 c0       	push   $0xc0106634
c01045d6:	e8 b5 c6 ff ff       	call   c0100c90 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01045db:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045e0:	83 ec 04             	sub    $0x4,%esp
c01045e3:	6a 00                	push   $0x0
c01045e5:	6a 00                	push   $0x0
c01045e7:	50                   	push   %eax
c01045e8:	e8 e1 fb ff ff       	call   c01041ce <get_pte>
c01045ed:	83 c4 10             	add    $0x10,%esp
c01045f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01045f7:	75 19                	jne    c0104612 <check_pgdir+0x106>
c01045f9:	68 5c 67 10 c0       	push   $0xc010675c
c01045fe:	68 59 66 10 c0       	push   $0xc0106659
c0104603:	68 ed 01 00 00       	push   $0x1ed
c0104608:	68 34 66 10 c0       	push   $0xc0106634
c010460d:	e8 7e c6 ff ff       	call   c0100c90 <__panic>
    assert(pte2page(*ptep) == p1);
c0104612:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104615:	8b 00                	mov    (%eax),%eax
c0104617:	83 ec 0c             	sub    $0xc,%esp
c010461a:	50                   	push   %eax
c010461b:	e8 1e f3 ff ff       	call   c010393e <pte2page>
c0104620:	83 c4 10             	add    $0x10,%esp
c0104623:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104626:	74 19                	je     c0104641 <check_pgdir+0x135>
c0104628:	68 89 67 10 c0       	push   $0xc0106789
c010462d:	68 59 66 10 c0       	push   $0xc0106659
c0104632:	68 ee 01 00 00       	push   $0x1ee
c0104637:	68 34 66 10 c0       	push   $0xc0106634
c010463c:	e8 4f c6 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p1) == 1);
c0104641:	83 ec 0c             	sub    $0xc,%esp
c0104644:	ff 75 f4             	push   -0xc(%ebp)
c0104647:	e8 48 f3 ff ff       	call   c0103994 <page_ref>
c010464c:	83 c4 10             	add    $0x10,%esp
c010464f:	83 f8 01             	cmp    $0x1,%eax
c0104652:	74 19                	je     c010466d <check_pgdir+0x161>
c0104654:	68 9f 67 10 c0       	push   $0xc010679f
c0104659:	68 59 66 10 c0       	push   $0xc0106659
c010465e:	68 ef 01 00 00       	push   $0x1ef
c0104663:	68 34 66 10 c0       	push   $0xc0106634
c0104668:	e8 23 c6 ff ff       	call   c0100c90 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010466d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104672:	8b 00                	mov    (%eax),%eax
c0104674:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104679:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010467c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010467f:	c1 e8 0c             	shr    $0xc,%eax
c0104682:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104685:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010468a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010468d:	72 17                	jb     c01046a6 <check_pgdir+0x19a>
c010468f:	ff 75 ec             	push   -0x14(%ebp)
c0104692:	68 6c 65 10 c0       	push   $0xc010656c
c0104697:	68 f1 01 00 00       	push   $0x1f1
c010469c:	68 34 66 10 c0       	push   $0xc0106634
c01046a1:	e8 ea c5 ff ff       	call   c0100c90 <__panic>
c01046a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046a9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046ae:	83 c0 04             	add    $0x4,%eax
c01046b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01046b4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046b9:	83 ec 04             	sub    $0x4,%esp
c01046bc:	6a 00                	push   $0x0
c01046be:	68 00 10 00 00       	push   $0x1000
c01046c3:	50                   	push   %eax
c01046c4:	e8 05 fb ff ff       	call   c01041ce <get_pte>
c01046c9:	83 c4 10             	add    $0x10,%esp
c01046cc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01046cf:	74 19                	je     c01046ea <check_pgdir+0x1de>
c01046d1:	68 b4 67 10 c0       	push   $0xc01067b4
c01046d6:	68 59 66 10 c0       	push   $0xc0106659
c01046db:	68 f2 01 00 00       	push   $0x1f2
c01046e0:	68 34 66 10 c0       	push   $0xc0106634
c01046e5:	e8 a6 c5 ff ff       	call   c0100c90 <__panic>

    p2 = alloc_page();
c01046ea:	83 ec 0c             	sub    $0xc,%esp
c01046ed:	6a 01                	push   $0x1
c01046ef:	e8 af f4 ff ff       	call   c0103ba3 <alloc_pages>
c01046f4:	83 c4 10             	add    $0x10,%esp
c01046f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01046fa:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046ff:	6a 06                	push   $0x6
c0104701:	68 00 10 00 00       	push   $0x1000
c0104706:	ff 75 e4             	push   -0x1c(%ebp)
c0104709:	50                   	push   %eax
c010470a:	e8 d0 fc ff ff       	call   c01043df <page_insert>
c010470f:	83 c4 10             	add    $0x10,%esp
c0104712:	85 c0                	test   %eax,%eax
c0104714:	74 19                	je     c010472f <check_pgdir+0x223>
c0104716:	68 dc 67 10 c0       	push   $0xc01067dc
c010471b:	68 59 66 10 c0       	push   $0xc0106659
c0104720:	68 f5 01 00 00       	push   $0x1f5
c0104725:	68 34 66 10 c0       	push   $0xc0106634
c010472a:	e8 61 c5 ff ff       	call   c0100c90 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010472f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104734:	83 ec 04             	sub    $0x4,%esp
c0104737:	6a 00                	push   $0x0
c0104739:	68 00 10 00 00       	push   $0x1000
c010473e:	50                   	push   %eax
c010473f:	e8 8a fa ff ff       	call   c01041ce <get_pte>
c0104744:	83 c4 10             	add    $0x10,%esp
c0104747:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010474a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010474e:	75 19                	jne    c0104769 <check_pgdir+0x25d>
c0104750:	68 14 68 10 c0       	push   $0xc0106814
c0104755:	68 59 66 10 c0       	push   $0xc0106659
c010475a:	68 f6 01 00 00       	push   $0x1f6
c010475f:	68 34 66 10 c0       	push   $0xc0106634
c0104764:	e8 27 c5 ff ff       	call   c0100c90 <__panic>
    assert(*ptep & PTE_U);
c0104769:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476c:	8b 00                	mov    (%eax),%eax
c010476e:	83 e0 04             	and    $0x4,%eax
c0104771:	85 c0                	test   %eax,%eax
c0104773:	75 19                	jne    c010478e <check_pgdir+0x282>
c0104775:	68 44 68 10 c0       	push   $0xc0106844
c010477a:	68 59 66 10 c0       	push   $0xc0106659
c010477f:	68 f7 01 00 00       	push   $0x1f7
c0104784:	68 34 66 10 c0       	push   $0xc0106634
c0104789:	e8 02 c5 ff ff       	call   c0100c90 <__panic>
    assert(*ptep & PTE_W);
c010478e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104791:	8b 00                	mov    (%eax),%eax
c0104793:	83 e0 02             	and    $0x2,%eax
c0104796:	85 c0                	test   %eax,%eax
c0104798:	75 19                	jne    c01047b3 <check_pgdir+0x2a7>
c010479a:	68 52 68 10 c0       	push   $0xc0106852
c010479f:	68 59 66 10 c0       	push   $0xc0106659
c01047a4:	68 f8 01 00 00       	push   $0x1f8
c01047a9:	68 34 66 10 c0       	push   $0xc0106634
c01047ae:	e8 dd c4 ff ff       	call   c0100c90 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01047b3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01047b8:	8b 00                	mov    (%eax),%eax
c01047ba:	83 e0 04             	and    $0x4,%eax
c01047bd:	85 c0                	test   %eax,%eax
c01047bf:	75 19                	jne    c01047da <check_pgdir+0x2ce>
c01047c1:	68 60 68 10 c0       	push   $0xc0106860
c01047c6:	68 59 66 10 c0       	push   $0xc0106659
c01047cb:	68 f9 01 00 00       	push   $0x1f9
c01047d0:	68 34 66 10 c0       	push   $0xc0106634
c01047d5:	e8 b6 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 1);
c01047da:	83 ec 0c             	sub    $0xc,%esp
c01047dd:	ff 75 e4             	push   -0x1c(%ebp)
c01047e0:	e8 af f1 ff ff       	call   c0103994 <page_ref>
c01047e5:	83 c4 10             	add    $0x10,%esp
c01047e8:	83 f8 01             	cmp    $0x1,%eax
c01047eb:	74 19                	je     c0104806 <check_pgdir+0x2fa>
c01047ed:	68 76 68 10 c0       	push   $0xc0106876
c01047f2:	68 59 66 10 c0       	push   $0xc0106659
c01047f7:	68 fa 01 00 00       	push   $0x1fa
c01047fc:	68 34 66 10 c0       	push   $0xc0106634
c0104801:	e8 8a c4 ff ff       	call   c0100c90 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104806:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010480b:	6a 00                	push   $0x0
c010480d:	68 00 10 00 00       	push   $0x1000
c0104812:	ff 75 f4             	push   -0xc(%ebp)
c0104815:	50                   	push   %eax
c0104816:	e8 c4 fb ff ff       	call   c01043df <page_insert>
c010481b:	83 c4 10             	add    $0x10,%esp
c010481e:	85 c0                	test   %eax,%eax
c0104820:	74 19                	je     c010483b <check_pgdir+0x32f>
c0104822:	68 88 68 10 c0       	push   $0xc0106888
c0104827:	68 59 66 10 c0       	push   $0xc0106659
c010482c:	68 fc 01 00 00       	push   $0x1fc
c0104831:	68 34 66 10 c0       	push   $0xc0106634
c0104836:	e8 55 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p1) == 2);
c010483b:	83 ec 0c             	sub    $0xc,%esp
c010483e:	ff 75 f4             	push   -0xc(%ebp)
c0104841:	e8 4e f1 ff ff       	call   c0103994 <page_ref>
c0104846:	83 c4 10             	add    $0x10,%esp
c0104849:	83 f8 02             	cmp    $0x2,%eax
c010484c:	74 19                	je     c0104867 <check_pgdir+0x35b>
c010484e:	68 b4 68 10 c0       	push   $0xc01068b4
c0104853:	68 59 66 10 c0       	push   $0xc0106659
c0104858:	68 fd 01 00 00       	push   $0x1fd
c010485d:	68 34 66 10 c0       	push   $0xc0106634
c0104862:	e8 29 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c0104867:	83 ec 0c             	sub    $0xc,%esp
c010486a:	ff 75 e4             	push   -0x1c(%ebp)
c010486d:	e8 22 f1 ff ff       	call   c0103994 <page_ref>
c0104872:	83 c4 10             	add    $0x10,%esp
c0104875:	85 c0                	test   %eax,%eax
c0104877:	74 19                	je     c0104892 <check_pgdir+0x386>
c0104879:	68 c6 68 10 c0       	push   $0xc01068c6
c010487e:	68 59 66 10 c0       	push   $0xc0106659
c0104883:	68 fe 01 00 00       	push   $0x1fe
c0104888:	68 34 66 10 c0       	push   $0xc0106634
c010488d:	e8 fe c3 ff ff       	call   c0100c90 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104892:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104897:	83 ec 04             	sub    $0x4,%esp
c010489a:	6a 00                	push   $0x0
c010489c:	68 00 10 00 00       	push   $0x1000
c01048a1:	50                   	push   %eax
c01048a2:	e8 27 f9 ff ff       	call   c01041ce <get_pte>
c01048a7:	83 c4 10             	add    $0x10,%esp
c01048aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048b1:	75 19                	jne    c01048cc <check_pgdir+0x3c0>
c01048b3:	68 14 68 10 c0       	push   $0xc0106814
c01048b8:	68 59 66 10 c0       	push   $0xc0106659
c01048bd:	68 ff 01 00 00       	push   $0x1ff
c01048c2:	68 34 66 10 c0       	push   $0xc0106634
c01048c7:	e8 c4 c3 ff ff       	call   c0100c90 <__panic>
    assert(pte2page(*ptep) == p1);
c01048cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048cf:	8b 00                	mov    (%eax),%eax
c01048d1:	83 ec 0c             	sub    $0xc,%esp
c01048d4:	50                   	push   %eax
c01048d5:	e8 64 f0 ff ff       	call   c010393e <pte2page>
c01048da:	83 c4 10             	add    $0x10,%esp
c01048dd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01048e0:	74 19                	je     c01048fb <check_pgdir+0x3ef>
c01048e2:	68 89 67 10 c0       	push   $0xc0106789
c01048e7:	68 59 66 10 c0       	push   $0xc0106659
c01048ec:	68 00 02 00 00       	push   $0x200
c01048f1:	68 34 66 10 c0       	push   $0xc0106634
c01048f6:	e8 95 c3 ff ff       	call   c0100c90 <__panic>
    assert((*ptep & PTE_U) == 0);
c01048fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048fe:	8b 00                	mov    (%eax),%eax
c0104900:	83 e0 04             	and    $0x4,%eax
c0104903:	85 c0                	test   %eax,%eax
c0104905:	74 19                	je     c0104920 <check_pgdir+0x414>
c0104907:	68 d8 68 10 c0       	push   $0xc01068d8
c010490c:	68 59 66 10 c0       	push   $0xc0106659
c0104911:	68 01 02 00 00       	push   $0x201
c0104916:	68 34 66 10 c0       	push   $0xc0106634
c010491b:	e8 70 c3 ff ff       	call   c0100c90 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104920:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104925:	83 ec 08             	sub    $0x8,%esp
c0104928:	6a 00                	push   $0x0
c010492a:	50                   	push   %eax
c010492b:	e8 76 fa ff ff       	call   c01043a6 <page_remove>
c0104930:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0104933:	83 ec 0c             	sub    $0xc,%esp
c0104936:	ff 75 f4             	push   -0xc(%ebp)
c0104939:	e8 56 f0 ff ff       	call   c0103994 <page_ref>
c010493e:	83 c4 10             	add    $0x10,%esp
c0104941:	83 f8 01             	cmp    $0x1,%eax
c0104944:	74 19                	je     c010495f <check_pgdir+0x453>
c0104946:	68 9f 67 10 c0       	push   $0xc010679f
c010494b:	68 59 66 10 c0       	push   $0xc0106659
c0104950:	68 04 02 00 00       	push   $0x204
c0104955:	68 34 66 10 c0       	push   $0xc0106634
c010495a:	e8 31 c3 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c010495f:	83 ec 0c             	sub    $0xc,%esp
c0104962:	ff 75 e4             	push   -0x1c(%ebp)
c0104965:	e8 2a f0 ff ff       	call   c0103994 <page_ref>
c010496a:	83 c4 10             	add    $0x10,%esp
c010496d:	85 c0                	test   %eax,%eax
c010496f:	74 19                	je     c010498a <check_pgdir+0x47e>
c0104971:	68 c6 68 10 c0       	push   $0xc01068c6
c0104976:	68 59 66 10 c0       	push   $0xc0106659
c010497b:	68 05 02 00 00       	push   $0x205
c0104980:	68 34 66 10 c0       	push   $0xc0106634
c0104985:	e8 06 c3 ff ff       	call   c0100c90 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010498a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010498f:	83 ec 08             	sub    $0x8,%esp
c0104992:	68 00 10 00 00       	push   $0x1000
c0104997:	50                   	push   %eax
c0104998:	e8 09 fa ff ff       	call   c01043a6 <page_remove>
c010499d:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c01049a0:	83 ec 0c             	sub    $0xc,%esp
c01049a3:	ff 75 f4             	push   -0xc(%ebp)
c01049a6:	e8 e9 ef ff ff       	call   c0103994 <page_ref>
c01049ab:	83 c4 10             	add    $0x10,%esp
c01049ae:	85 c0                	test   %eax,%eax
c01049b0:	74 19                	je     c01049cb <check_pgdir+0x4bf>
c01049b2:	68 ed 68 10 c0       	push   $0xc01068ed
c01049b7:	68 59 66 10 c0       	push   $0xc0106659
c01049bc:	68 08 02 00 00       	push   $0x208
c01049c1:	68 34 66 10 c0       	push   $0xc0106634
c01049c6:	e8 c5 c2 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c01049cb:	83 ec 0c             	sub    $0xc,%esp
c01049ce:	ff 75 e4             	push   -0x1c(%ebp)
c01049d1:	e8 be ef ff ff       	call   c0103994 <page_ref>
c01049d6:	83 c4 10             	add    $0x10,%esp
c01049d9:	85 c0                	test   %eax,%eax
c01049db:	74 19                	je     c01049f6 <check_pgdir+0x4ea>
c01049dd:	68 c6 68 10 c0       	push   $0xc01068c6
c01049e2:	68 59 66 10 c0       	push   $0xc0106659
c01049e7:	68 09 02 00 00       	push   $0x209
c01049ec:	68 34 66 10 c0       	push   $0xc0106634
c01049f1:	e8 9a c2 ff ff       	call   c0100c90 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01049f6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049fb:	8b 00                	mov    (%eax),%eax
c01049fd:	83 ec 0c             	sub    $0xc,%esp
c0104a00:	50                   	push   %eax
c0104a01:	e8 72 ef ff ff       	call   c0103978 <pde2page>
c0104a06:	83 c4 10             	add    $0x10,%esp
c0104a09:	83 ec 0c             	sub    $0xc,%esp
c0104a0c:	50                   	push   %eax
c0104a0d:	e8 82 ef ff ff       	call   c0103994 <page_ref>
c0104a12:	83 c4 10             	add    $0x10,%esp
c0104a15:	83 f8 01             	cmp    $0x1,%eax
c0104a18:	74 19                	je     c0104a33 <check_pgdir+0x527>
c0104a1a:	68 00 69 10 c0       	push   $0xc0106900
c0104a1f:	68 59 66 10 c0       	push   $0xc0106659
c0104a24:	68 0b 02 00 00       	push   $0x20b
c0104a29:	68 34 66 10 c0       	push   $0xc0106634
c0104a2e:	e8 5d c2 ff ff       	call   c0100c90 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104a33:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a38:	8b 00                	mov    (%eax),%eax
c0104a3a:	83 ec 0c             	sub    $0xc,%esp
c0104a3d:	50                   	push   %eax
c0104a3e:	e8 35 ef ff ff       	call   c0103978 <pde2page>
c0104a43:	83 c4 10             	add    $0x10,%esp
c0104a46:	83 ec 08             	sub    $0x8,%esp
c0104a49:	6a 01                	push   $0x1
c0104a4b:	50                   	push   %eax
c0104a4c:	e8 90 f1 ff ff       	call   c0103be1 <free_pages>
c0104a51:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104a54:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104a5f:	83 ec 0c             	sub    $0xc,%esp
c0104a62:	68 27 69 10 c0       	push   $0xc0106927
c0104a67:	e8 c5 b8 ff ff       	call   c0100331 <cprintf>
c0104a6c:	83 c4 10             	add    $0x10,%esp
}
c0104a6f:	90                   	nop
c0104a70:	c9                   	leave  
c0104a71:	c3                   	ret    

c0104a72 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104a72:	55                   	push   %ebp
c0104a73:	89 e5                	mov    %esp,%ebp
c0104a75:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a7f:	e9 a3 00 00 00       	jmp    c0104b27 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a8d:	c1 e8 0c             	shr    $0xc,%eax
c0104a90:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104a93:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104a98:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104a9b:	72 17                	jb     c0104ab4 <check_boot_pgdir+0x42>
c0104a9d:	ff 75 e4             	push   -0x1c(%ebp)
c0104aa0:	68 6c 65 10 c0       	push   $0xc010656c
c0104aa5:	68 17 02 00 00       	push   $0x217
c0104aaa:	68 34 66 10 c0       	push   $0xc0106634
c0104aaf:	e8 dc c1 ff ff       	call   c0100c90 <__panic>
c0104ab4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ab7:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104abc:	89 c2                	mov    %eax,%edx
c0104abe:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ac3:	83 ec 04             	sub    $0x4,%esp
c0104ac6:	6a 00                	push   $0x0
c0104ac8:	52                   	push   %edx
c0104ac9:	50                   	push   %eax
c0104aca:	e8 ff f6 ff ff       	call   c01041ce <get_pte>
c0104acf:	83 c4 10             	add    $0x10,%esp
c0104ad2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ad5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104ad9:	75 19                	jne    c0104af4 <check_boot_pgdir+0x82>
c0104adb:	68 44 69 10 c0       	push   $0xc0106944
c0104ae0:	68 59 66 10 c0       	push   $0xc0106659
c0104ae5:	68 17 02 00 00       	push   $0x217
c0104aea:	68 34 66 10 c0       	push   $0xc0106634
c0104aef:	e8 9c c1 ff ff       	call   c0100c90 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104af7:	8b 00                	mov    (%eax),%eax
c0104af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104afe:	89 c2                	mov    %eax,%edx
c0104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b03:	39 c2                	cmp    %eax,%edx
c0104b05:	74 19                	je     c0104b20 <check_boot_pgdir+0xae>
c0104b07:	68 81 69 10 c0       	push   $0xc0106981
c0104b0c:	68 59 66 10 c0       	push   $0xc0106659
c0104b11:	68 18 02 00 00       	push   $0x218
c0104b16:	68 34 66 10 c0       	push   $0xc0106634
c0104b1b:	e8 70 c1 ff ff       	call   c0100c90 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104b20:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104b27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b2a:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104b2f:	39 c2                	cmp    %eax,%edx
c0104b31:	0f 82 4d ff ff ff    	jb     c0104a84 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104b37:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b3c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104b41:	8b 00                	mov    (%eax),%eax
c0104b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b48:	89 c2                	mov    %eax,%edx
c0104b4a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b52:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104b59:	77 17                	ja     c0104b72 <check_boot_pgdir+0x100>
c0104b5b:	ff 75 f0             	push   -0x10(%ebp)
c0104b5e:	68 10 66 10 c0       	push   $0xc0106610
c0104b63:	68 1b 02 00 00       	push   $0x21b
c0104b68:	68 34 66 10 c0       	push   $0xc0106634
c0104b6d:	e8 1e c1 ff ff       	call   c0100c90 <__panic>
c0104b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b75:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b7a:	39 d0                	cmp    %edx,%eax
c0104b7c:	74 19                	je     c0104b97 <check_boot_pgdir+0x125>
c0104b7e:	68 98 69 10 c0       	push   $0xc0106998
c0104b83:	68 59 66 10 c0       	push   $0xc0106659
c0104b88:	68 1b 02 00 00       	push   $0x21b
c0104b8d:	68 34 66 10 c0       	push   $0xc0106634
c0104b92:	e8 f9 c0 ff ff       	call   c0100c90 <__panic>

    assert(boot_pgdir[0] == 0);
c0104b97:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b9c:	8b 00                	mov    (%eax),%eax
c0104b9e:	85 c0                	test   %eax,%eax
c0104ba0:	74 19                	je     c0104bbb <check_boot_pgdir+0x149>
c0104ba2:	68 cc 69 10 c0       	push   $0xc01069cc
c0104ba7:	68 59 66 10 c0       	push   $0xc0106659
c0104bac:	68 1d 02 00 00       	push   $0x21d
c0104bb1:	68 34 66 10 c0       	push   $0xc0106634
c0104bb6:	e8 d5 c0 ff ff       	call   c0100c90 <__panic>

    struct Page *p;
    p = alloc_page();
c0104bbb:	83 ec 0c             	sub    $0xc,%esp
c0104bbe:	6a 01                	push   $0x1
c0104bc0:	e8 de ef ff ff       	call   c0103ba3 <alloc_pages>
c0104bc5:	83 c4 10             	add    $0x10,%esp
c0104bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104bcb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bd0:	6a 02                	push   $0x2
c0104bd2:	68 00 01 00 00       	push   $0x100
c0104bd7:	ff 75 ec             	push   -0x14(%ebp)
c0104bda:	50                   	push   %eax
c0104bdb:	e8 ff f7 ff ff       	call   c01043df <page_insert>
c0104be0:	83 c4 10             	add    $0x10,%esp
c0104be3:	85 c0                	test   %eax,%eax
c0104be5:	74 19                	je     c0104c00 <check_boot_pgdir+0x18e>
c0104be7:	68 e0 69 10 c0       	push   $0xc01069e0
c0104bec:	68 59 66 10 c0       	push   $0xc0106659
c0104bf1:	68 21 02 00 00       	push   $0x221
c0104bf6:	68 34 66 10 c0       	push   $0xc0106634
c0104bfb:	e8 90 c0 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p) == 1);
c0104c00:	83 ec 0c             	sub    $0xc,%esp
c0104c03:	ff 75 ec             	push   -0x14(%ebp)
c0104c06:	e8 89 ed ff ff       	call   c0103994 <page_ref>
c0104c0b:	83 c4 10             	add    $0x10,%esp
c0104c0e:	83 f8 01             	cmp    $0x1,%eax
c0104c11:	74 19                	je     c0104c2c <check_boot_pgdir+0x1ba>
c0104c13:	68 0e 6a 10 c0       	push   $0xc0106a0e
c0104c18:	68 59 66 10 c0       	push   $0xc0106659
c0104c1d:	68 22 02 00 00       	push   $0x222
c0104c22:	68 34 66 10 c0       	push   $0xc0106634
c0104c27:	e8 64 c0 ff ff       	call   c0100c90 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104c2c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c31:	6a 02                	push   $0x2
c0104c33:	68 00 11 00 00       	push   $0x1100
c0104c38:	ff 75 ec             	push   -0x14(%ebp)
c0104c3b:	50                   	push   %eax
c0104c3c:	e8 9e f7 ff ff       	call   c01043df <page_insert>
c0104c41:	83 c4 10             	add    $0x10,%esp
c0104c44:	85 c0                	test   %eax,%eax
c0104c46:	74 19                	je     c0104c61 <check_boot_pgdir+0x1ef>
c0104c48:	68 20 6a 10 c0       	push   $0xc0106a20
c0104c4d:	68 59 66 10 c0       	push   $0xc0106659
c0104c52:	68 23 02 00 00       	push   $0x223
c0104c57:	68 34 66 10 c0       	push   $0xc0106634
c0104c5c:	e8 2f c0 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p) == 2);
c0104c61:	83 ec 0c             	sub    $0xc,%esp
c0104c64:	ff 75 ec             	push   -0x14(%ebp)
c0104c67:	e8 28 ed ff ff       	call   c0103994 <page_ref>
c0104c6c:	83 c4 10             	add    $0x10,%esp
c0104c6f:	83 f8 02             	cmp    $0x2,%eax
c0104c72:	74 19                	je     c0104c8d <check_boot_pgdir+0x21b>
c0104c74:	68 57 6a 10 c0       	push   $0xc0106a57
c0104c79:	68 59 66 10 c0       	push   $0xc0106659
c0104c7e:	68 24 02 00 00       	push   $0x224
c0104c83:	68 34 66 10 c0       	push   $0xc0106634
c0104c88:	e8 03 c0 ff ff       	call   c0100c90 <__panic>

    const char *str = "ucore: Hello world!!";
c0104c8d:	c7 45 e8 68 6a 10 c0 	movl   $0xc0106a68,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104c94:	83 ec 08             	sub    $0x8,%esp
c0104c97:	ff 75 e8             	push   -0x18(%ebp)
c0104c9a:	68 00 01 00 00       	push   $0x100
c0104c9f:	e8 70 09 00 00       	call   c0105614 <strcpy>
c0104ca4:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104ca7:	83 ec 08             	sub    $0x8,%esp
c0104caa:	68 00 11 00 00       	push   $0x1100
c0104caf:	68 00 01 00 00       	push   $0x100
c0104cb4:	e8 d4 09 00 00       	call   c010568d <strcmp>
c0104cb9:	83 c4 10             	add    $0x10,%esp
c0104cbc:	85 c0                	test   %eax,%eax
c0104cbe:	74 19                	je     c0104cd9 <check_boot_pgdir+0x267>
c0104cc0:	68 80 6a 10 c0       	push   $0xc0106a80
c0104cc5:	68 59 66 10 c0       	push   $0xc0106659
c0104cca:	68 28 02 00 00       	push   $0x228
c0104ccf:	68 34 66 10 c0       	push   $0xc0106634
c0104cd4:	e8 b7 bf ff ff       	call   c0100c90 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104cd9:	83 ec 0c             	sub    $0xc,%esp
c0104cdc:	ff 75 ec             	push   -0x14(%ebp)
c0104cdf:	e8 15 ec ff ff       	call   c01038f9 <page2kva>
c0104ce4:	83 c4 10             	add    $0x10,%esp
c0104ce7:	05 00 01 00 00       	add    $0x100,%eax
c0104cec:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104cef:	83 ec 0c             	sub    $0xc,%esp
c0104cf2:	68 00 01 00 00       	push   $0x100
c0104cf7:	e8 c0 08 00 00       	call   c01055bc <strlen>
c0104cfc:	83 c4 10             	add    $0x10,%esp
c0104cff:	85 c0                	test   %eax,%eax
c0104d01:	74 19                	je     c0104d1c <check_boot_pgdir+0x2aa>
c0104d03:	68 b8 6a 10 c0       	push   $0xc0106ab8
c0104d08:	68 59 66 10 c0       	push   $0xc0106659
c0104d0d:	68 2b 02 00 00       	push   $0x22b
c0104d12:	68 34 66 10 c0       	push   $0xc0106634
c0104d17:	e8 74 bf ff ff       	call   c0100c90 <__panic>

    free_page(p);
c0104d1c:	83 ec 08             	sub    $0x8,%esp
c0104d1f:	6a 01                	push   $0x1
c0104d21:	ff 75 ec             	push   -0x14(%ebp)
c0104d24:	e8 b8 ee ff ff       	call   c0103be1 <free_pages>
c0104d29:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104d2c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d31:	8b 00                	mov    (%eax),%eax
c0104d33:	83 ec 0c             	sub    $0xc,%esp
c0104d36:	50                   	push   %eax
c0104d37:	e8 3c ec ff ff       	call   c0103978 <pde2page>
c0104d3c:	83 c4 10             	add    $0x10,%esp
c0104d3f:	83 ec 08             	sub    $0x8,%esp
c0104d42:	6a 01                	push   $0x1
c0104d44:	50                   	push   %eax
c0104d45:	e8 97 ee ff ff       	call   c0103be1 <free_pages>
c0104d4a:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104d4d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104d58:	83 ec 0c             	sub    $0xc,%esp
c0104d5b:	68 dc 6a 10 c0       	push   $0xc0106adc
c0104d60:	e8 cc b5 ff ff       	call   c0100331 <cprintf>
c0104d65:	83 c4 10             	add    $0x10,%esp
}
c0104d68:	90                   	nop
c0104d69:	c9                   	leave  
c0104d6a:	c3                   	ret    

c0104d6b <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104d6b:	55                   	push   %ebp
c0104d6c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d71:	83 e0 04             	and    $0x4,%eax
c0104d74:	85 c0                	test   %eax,%eax
c0104d76:	74 07                	je     c0104d7f <perm2str+0x14>
c0104d78:	b8 75 00 00 00       	mov    $0x75,%eax
c0104d7d:	eb 05                	jmp    c0104d84 <perm2str+0x19>
c0104d7f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104d84:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0104d89:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104d90:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d93:	83 e0 02             	and    $0x2,%eax
c0104d96:	85 c0                	test   %eax,%eax
c0104d98:	74 07                	je     c0104da1 <perm2str+0x36>
c0104d9a:	b8 77 00 00 00       	mov    $0x77,%eax
c0104d9f:	eb 05                	jmp    c0104da6 <perm2str+0x3b>
c0104da1:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104da6:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0104dab:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c0104db2:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c0104db7:	5d                   	pop    %ebp
c0104db8:	c3                   	ret    

c0104db9 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104db9:	55                   	push   %ebp
c0104dba:	89 e5                	mov    %esp,%ebp
c0104dbc:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104dbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0104dc2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104dc5:	72 0e                	jb     c0104dd5 <get_pgtable_items+0x1c>
        return 0;
c0104dc7:	b8 00 00 00 00       	mov    $0x0,%eax
c0104dcc:	e9 9a 00 00 00       	jmp    c0104e6b <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104dd1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104dd5:	8b 45 10             	mov    0x10(%ebp),%eax
c0104dd8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104ddb:	73 18                	jae    c0104df5 <get_pgtable_items+0x3c>
c0104ddd:	8b 45 10             	mov    0x10(%ebp),%eax
c0104de0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104de7:	8b 45 14             	mov    0x14(%ebp),%eax
c0104dea:	01 d0                	add    %edx,%eax
c0104dec:	8b 00                	mov    (%eax),%eax
c0104dee:	83 e0 01             	and    $0x1,%eax
c0104df1:	85 c0                	test   %eax,%eax
c0104df3:	74 dc                	je     c0104dd1 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104df5:	8b 45 10             	mov    0x10(%ebp),%eax
c0104df8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104dfb:	73 69                	jae    c0104e66 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0104dfd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104e01:	74 08                	je     c0104e0b <get_pgtable_items+0x52>
            *left_store = start;
c0104e03:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e06:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e09:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104e0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e0e:	8d 50 01             	lea    0x1(%eax),%edx
c0104e11:	89 55 10             	mov    %edx,0x10(%ebp)
c0104e14:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e1b:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e1e:	01 d0                	add    %edx,%eax
c0104e20:	8b 00                	mov    (%eax),%eax
c0104e22:	83 e0 07             	and    $0x7,%eax
c0104e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e28:	eb 04                	jmp    c0104e2e <get_pgtable_items+0x75>
            start ++;
c0104e2a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e2e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e31:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e34:	73 1d                	jae    c0104e53 <get_pgtable_items+0x9a>
c0104e36:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e40:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e43:	01 d0                	add    %edx,%eax
c0104e45:	8b 00                	mov    (%eax),%eax
c0104e47:	83 e0 07             	and    $0x7,%eax
c0104e4a:	89 c2                	mov    %eax,%edx
c0104e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104e4f:	39 c2                	cmp    %eax,%edx
c0104e51:	74 d7                	je     c0104e2a <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
c0104e53:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104e57:	74 08                	je     c0104e61 <get_pgtable_items+0xa8>
            *right_store = start;
c0104e59:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104e5c:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e5f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104e64:	eb 05                	jmp    c0104e6b <get_pgtable_items+0xb2>
    }
    return 0;
c0104e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104e6b:	c9                   	leave  
c0104e6c:	c3                   	ret    

c0104e6d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104e6d:	55                   	push   %ebp
c0104e6e:	89 e5                	mov    %esp,%ebp
c0104e70:	57                   	push   %edi
c0104e71:	56                   	push   %esi
c0104e72:	53                   	push   %ebx
c0104e73:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104e76:	83 ec 0c             	sub    $0xc,%esp
c0104e79:	68 fc 6a 10 c0       	push   $0xc0106afc
c0104e7e:	e8 ae b4 ff ff       	call   c0100331 <cprintf>
c0104e83:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104e86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104e8d:	e9 d9 00 00 00       	jmp    c0104f6b <print_pgdir+0xfe>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e95:	83 ec 0c             	sub    $0xc,%esp
c0104e98:	50                   	push   %eax
c0104e99:	e8 cd fe ff ff       	call   c0104d6b <perm2str>
c0104e9e:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104ea1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ea4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104ea7:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104ea9:	89 d6                	mov    %edx,%esi
c0104eab:	c1 e6 16             	shl    $0x16,%esi
c0104eae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104eb1:	89 d3                	mov    %edx,%ebx
c0104eb3:	c1 e3 16             	shl    $0x16,%ebx
c0104eb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104eb9:	89 d1                	mov    %edx,%ecx
c0104ebb:	c1 e1 16             	shl    $0x16,%ecx
c0104ebe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ec1:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0104ec4:	29 fa                	sub    %edi,%edx
c0104ec6:	83 ec 08             	sub    $0x8,%esp
c0104ec9:	50                   	push   %eax
c0104eca:	56                   	push   %esi
c0104ecb:	53                   	push   %ebx
c0104ecc:	51                   	push   %ecx
c0104ecd:	52                   	push   %edx
c0104ece:	68 2d 6b 10 c0       	push   $0xc0106b2d
c0104ed3:	e8 59 b4 ff ff       	call   c0100331 <cprintf>
c0104ed8:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ede:	c1 e0 0a             	shl    $0xa,%eax
c0104ee1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104ee4:	eb 49                	jmp    c0104f2f <print_pgdir+0xc2>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ee9:	83 ec 0c             	sub    $0xc,%esp
c0104eec:	50                   	push   %eax
c0104eed:	e8 79 fe ff ff       	call   c0104d6b <perm2str>
c0104ef2:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104ef5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ef8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0104efb:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104efd:	89 d6                	mov    %edx,%esi
c0104eff:	c1 e6 0c             	shl    $0xc,%esi
c0104f02:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f05:	89 d3                	mov    %edx,%ebx
c0104f07:	c1 e3 0c             	shl    $0xc,%ebx
c0104f0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f0d:	89 d1                	mov    %edx,%ecx
c0104f0f:	c1 e1 0c             	shl    $0xc,%ecx
c0104f12:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f15:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0104f18:	29 fa                	sub    %edi,%edx
c0104f1a:	83 ec 08             	sub    $0x8,%esp
c0104f1d:	50                   	push   %eax
c0104f1e:	56                   	push   %esi
c0104f1f:	53                   	push   %ebx
c0104f20:	51                   	push   %ecx
c0104f21:	52                   	push   %edx
c0104f22:	68 4c 6b 10 c0       	push   $0xc0106b4c
c0104f27:	e8 05 b4 ff ff       	call   c0100331 <cprintf>
c0104f2c:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f2f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104f37:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f3a:	89 d3                	mov    %edx,%ebx
c0104f3c:	c1 e3 0a             	shl    $0xa,%ebx
c0104f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f42:	89 d1                	mov    %edx,%ecx
c0104f44:	c1 e1 0a             	shl    $0xa,%ecx
c0104f47:	83 ec 08             	sub    $0x8,%esp
c0104f4a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104f4d:	52                   	push   %edx
c0104f4e:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104f51:	52                   	push   %edx
c0104f52:	56                   	push   %esi
c0104f53:	50                   	push   %eax
c0104f54:	53                   	push   %ebx
c0104f55:	51                   	push   %ecx
c0104f56:	e8 5e fe ff ff       	call   c0104db9 <get_pgtable_items>
c0104f5b:	83 c4 20             	add    $0x20,%esp
c0104f5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f65:	0f 85 7b ff ff ff    	jne    c0104ee6 <print_pgdir+0x79>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104f6b:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f73:	83 ec 08             	sub    $0x8,%esp
c0104f76:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104f79:	52                   	push   %edx
c0104f7a:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104f7d:	52                   	push   %edx
c0104f7e:	51                   	push   %ecx
c0104f7f:	50                   	push   %eax
c0104f80:	68 00 04 00 00       	push   $0x400
c0104f85:	6a 00                	push   $0x0
c0104f87:	e8 2d fe ff ff       	call   c0104db9 <get_pgtable_items>
c0104f8c:	83 c4 20             	add    $0x20,%esp
c0104f8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f96:	0f 85 f6 fe ff ff    	jne    c0104e92 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104f9c:	83 ec 0c             	sub    $0xc,%esp
c0104f9f:	68 70 6b 10 c0       	push   $0xc0106b70
c0104fa4:	e8 88 b3 ff ff       	call   c0100331 <cprintf>
c0104fa9:	83 c4 10             	add    $0x10,%esp
}
c0104fac:	90                   	nop
c0104fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104fb0:	5b                   	pop    %ebx
c0104fb1:	5e                   	pop    %esi
c0104fb2:	5f                   	pop    %edi
c0104fb3:	5d                   	pop    %ebp
c0104fb4:	c3                   	ret    

c0104fb5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0104fb5:	55                   	push   %ebp
c0104fb6:	89 e5                	mov    %esp,%ebp
c0104fb8:	83 ec 38             	sub    $0x38,%esp
c0104fbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104fc1:	8b 45 14             	mov    0x14(%ebp),%eax
c0104fc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0104fc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104fca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104fcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0104fd3:	8b 45 18             	mov    0x18(%ebp),%eax
c0104fd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104fdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104fe2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0104fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104fef:	74 1c                	je     c010500d <printnum+0x58>
c0104ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ff4:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ff9:	f7 75 e4             	divl   -0x1c(%ebp)
c0104ffc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0104fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105002:	ba 00 00 00 00       	mov    $0x0,%edx
c0105007:	f7 75 e4             	divl   -0x1c(%ebp)
c010500a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010500d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105010:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105013:	f7 75 e4             	divl   -0x1c(%ebp)
c0105016:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105019:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010501c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010501f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105022:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105025:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105028:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010502b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010502e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105031:	ba 00 00 00 00       	mov    $0x0,%edx
c0105036:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105039:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010503c:	19 d1                	sbb    %edx,%ecx
c010503e:	72 37                	jb     c0105077 <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105040:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105043:	83 e8 01             	sub    $0x1,%eax
c0105046:	83 ec 04             	sub    $0x4,%esp
c0105049:	ff 75 20             	push   0x20(%ebp)
c010504c:	50                   	push   %eax
c010504d:	ff 75 18             	push   0x18(%ebp)
c0105050:	ff 75 ec             	push   -0x14(%ebp)
c0105053:	ff 75 e8             	push   -0x18(%ebp)
c0105056:	ff 75 0c             	push   0xc(%ebp)
c0105059:	ff 75 08             	push   0x8(%ebp)
c010505c:	e8 54 ff ff ff       	call   c0104fb5 <printnum>
c0105061:	83 c4 20             	add    $0x20,%esp
c0105064:	eb 1b                	jmp    c0105081 <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105066:	83 ec 08             	sub    $0x8,%esp
c0105069:	ff 75 0c             	push   0xc(%ebp)
c010506c:	ff 75 20             	push   0x20(%ebp)
c010506f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105072:	ff d0                	call   *%eax
c0105074:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0105077:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010507b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010507f:	7f e5                	jg     c0105066 <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105081:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105084:	05 24 6c 10 c0       	add    $0xc0106c24,%eax
c0105089:	0f b6 00             	movzbl (%eax),%eax
c010508c:	0f be c0             	movsbl %al,%eax
c010508f:	83 ec 08             	sub    $0x8,%esp
c0105092:	ff 75 0c             	push   0xc(%ebp)
c0105095:	50                   	push   %eax
c0105096:	8b 45 08             	mov    0x8(%ebp),%eax
c0105099:	ff d0                	call   *%eax
c010509b:	83 c4 10             	add    $0x10,%esp
}
c010509e:	90                   	nop
c010509f:	c9                   	leave  
c01050a0:	c3                   	ret    

c01050a1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01050a1:	55                   	push   %ebp
c01050a2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01050a4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01050a8:	7e 14                	jle    c01050be <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01050aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ad:	8b 00                	mov    (%eax),%eax
c01050af:	8d 48 08             	lea    0x8(%eax),%ecx
c01050b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01050b5:	89 0a                	mov    %ecx,(%edx)
c01050b7:	8b 50 04             	mov    0x4(%eax),%edx
c01050ba:	8b 00                	mov    (%eax),%eax
c01050bc:	eb 30                	jmp    c01050ee <getuint+0x4d>
    }
    else if (lflag) {
c01050be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01050c2:	74 16                	je     c01050da <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01050c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c7:	8b 00                	mov    (%eax),%eax
c01050c9:	8d 48 04             	lea    0x4(%eax),%ecx
c01050cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01050cf:	89 0a                	mov    %ecx,(%edx)
c01050d1:	8b 00                	mov    (%eax),%eax
c01050d3:	ba 00 00 00 00       	mov    $0x0,%edx
c01050d8:	eb 14                	jmp    c01050ee <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01050da:	8b 45 08             	mov    0x8(%ebp),%eax
c01050dd:	8b 00                	mov    (%eax),%eax
c01050df:	8d 48 04             	lea    0x4(%eax),%ecx
c01050e2:	8b 55 08             	mov    0x8(%ebp),%edx
c01050e5:	89 0a                	mov    %ecx,(%edx)
c01050e7:	8b 00                	mov    (%eax),%eax
c01050e9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01050ee:	5d                   	pop    %ebp
c01050ef:	c3                   	ret    

c01050f0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01050f0:	55                   	push   %ebp
c01050f1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01050f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01050f7:	7e 14                	jle    c010510d <getint+0x1d>
        return va_arg(*ap, long long);
c01050f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050fc:	8b 00                	mov    (%eax),%eax
c01050fe:	8d 48 08             	lea    0x8(%eax),%ecx
c0105101:	8b 55 08             	mov    0x8(%ebp),%edx
c0105104:	89 0a                	mov    %ecx,(%edx)
c0105106:	8b 50 04             	mov    0x4(%eax),%edx
c0105109:	8b 00                	mov    (%eax),%eax
c010510b:	eb 28                	jmp    c0105135 <getint+0x45>
    }
    else if (lflag) {
c010510d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105111:	74 12                	je     c0105125 <getint+0x35>
        return va_arg(*ap, long);
c0105113:	8b 45 08             	mov    0x8(%ebp),%eax
c0105116:	8b 00                	mov    (%eax),%eax
c0105118:	8d 48 04             	lea    0x4(%eax),%ecx
c010511b:	8b 55 08             	mov    0x8(%ebp),%edx
c010511e:	89 0a                	mov    %ecx,(%edx)
c0105120:	8b 00                	mov    (%eax),%eax
c0105122:	99                   	cltd   
c0105123:	eb 10                	jmp    c0105135 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105125:	8b 45 08             	mov    0x8(%ebp),%eax
c0105128:	8b 00                	mov    (%eax),%eax
c010512a:	8d 48 04             	lea    0x4(%eax),%ecx
c010512d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105130:	89 0a                	mov    %ecx,(%edx)
c0105132:	8b 00                	mov    (%eax),%eax
c0105134:	99                   	cltd   
    }
}
c0105135:	5d                   	pop    %ebp
c0105136:	c3                   	ret    

c0105137 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105137:	55                   	push   %ebp
c0105138:	89 e5                	mov    %esp,%ebp
c010513a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010513d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105140:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105143:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105146:	50                   	push   %eax
c0105147:	ff 75 10             	push   0x10(%ebp)
c010514a:	ff 75 0c             	push   0xc(%ebp)
c010514d:	ff 75 08             	push   0x8(%ebp)
c0105150:	e8 06 00 00 00       	call   c010515b <vprintfmt>
c0105155:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105158:	90                   	nop
c0105159:	c9                   	leave  
c010515a:	c3                   	ret    

c010515b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010515b:	55                   	push   %ebp
c010515c:	89 e5                	mov    %esp,%ebp
c010515e:	56                   	push   %esi
c010515f:	53                   	push   %ebx
c0105160:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105163:	eb 17                	jmp    c010517c <vprintfmt+0x21>
            if (ch == '\0') {
c0105165:	85 db                	test   %ebx,%ebx
c0105167:	0f 84 8e 03 00 00    	je     c01054fb <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010516d:	83 ec 08             	sub    $0x8,%esp
c0105170:	ff 75 0c             	push   0xc(%ebp)
c0105173:	53                   	push   %ebx
c0105174:	8b 45 08             	mov    0x8(%ebp),%eax
c0105177:	ff d0                	call   *%eax
c0105179:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010517c:	8b 45 10             	mov    0x10(%ebp),%eax
c010517f:	8d 50 01             	lea    0x1(%eax),%edx
c0105182:	89 55 10             	mov    %edx,0x10(%ebp)
c0105185:	0f b6 00             	movzbl (%eax),%eax
c0105188:	0f b6 d8             	movzbl %al,%ebx
c010518b:	83 fb 25             	cmp    $0x25,%ebx
c010518e:	75 d5                	jne    c0105165 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105190:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105194:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010519b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010519e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01051a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01051a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051ab:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01051ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01051b1:	8d 50 01             	lea    0x1(%eax),%edx
c01051b4:	89 55 10             	mov    %edx,0x10(%ebp)
c01051b7:	0f b6 00             	movzbl (%eax),%eax
c01051ba:	0f b6 d8             	movzbl %al,%ebx
c01051bd:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01051c0:	83 f8 55             	cmp    $0x55,%eax
c01051c3:	0f 87 05 03 00 00    	ja     c01054ce <vprintfmt+0x373>
c01051c9:	8b 04 85 48 6c 10 c0 	mov    -0x3fef93b8(,%eax,4),%eax
c01051d0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01051d2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01051d6:	eb d6                	jmp    c01051ae <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01051d8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01051dc:	eb d0                	jmp    c01051ae <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01051de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01051e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01051e8:	89 d0                	mov    %edx,%eax
c01051ea:	c1 e0 02             	shl    $0x2,%eax
c01051ed:	01 d0                	add    %edx,%eax
c01051ef:	01 c0                	add    %eax,%eax
c01051f1:	01 d8                	add    %ebx,%eax
c01051f3:	83 e8 30             	sub    $0x30,%eax
c01051f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01051f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01051fc:	0f b6 00             	movzbl (%eax),%eax
c01051ff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105202:	83 fb 2f             	cmp    $0x2f,%ebx
c0105205:	7e 39                	jle    c0105240 <vprintfmt+0xe5>
c0105207:	83 fb 39             	cmp    $0x39,%ebx
c010520a:	7f 34                	jg     c0105240 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
c010520c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105210:	eb d3                	jmp    c01051e5 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105212:	8b 45 14             	mov    0x14(%ebp),%eax
c0105215:	8d 50 04             	lea    0x4(%eax),%edx
c0105218:	89 55 14             	mov    %edx,0x14(%ebp)
c010521b:	8b 00                	mov    (%eax),%eax
c010521d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105220:	eb 1f                	jmp    c0105241 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105222:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105226:	79 86                	jns    c01051ae <vprintfmt+0x53>
                width = 0;
c0105228:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010522f:	e9 7a ff ff ff       	jmp    c01051ae <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105234:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010523b:	e9 6e ff ff ff       	jmp    c01051ae <vprintfmt+0x53>
            goto process_precision;
c0105240:	90                   	nop

        process_precision:
            if (width < 0)
c0105241:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105245:	0f 89 63 ff ff ff    	jns    c01051ae <vprintfmt+0x53>
                width = precision, precision = -1;
c010524b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010524e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105251:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105258:	e9 51 ff ff ff       	jmp    c01051ae <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010525d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105261:	e9 48 ff ff ff       	jmp    c01051ae <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105266:	8b 45 14             	mov    0x14(%ebp),%eax
c0105269:	8d 50 04             	lea    0x4(%eax),%edx
c010526c:	89 55 14             	mov    %edx,0x14(%ebp)
c010526f:	8b 00                	mov    (%eax),%eax
c0105271:	83 ec 08             	sub    $0x8,%esp
c0105274:	ff 75 0c             	push   0xc(%ebp)
c0105277:	50                   	push   %eax
c0105278:	8b 45 08             	mov    0x8(%ebp),%eax
c010527b:	ff d0                	call   *%eax
c010527d:	83 c4 10             	add    $0x10,%esp
            break;
c0105280:	e9 71 02 00 00       	jmp    c01054f6 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105285:	8b 45 14             	mov    0x14(%ebp),%eax
c0105288:	8d 50 04             	lea    0x4(%eax),%edx
c010528b:	89 55 14             	mov    %edx,0x14(%ebp)
c010528e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105290:	85 db                	test   %ebx,%ebx
c0105292:	79 02                	jns    c0105296 <vprintfmt+0x13b>
                err = -err;
c0105294:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105296:	83 fb 06             	cmp    $0x6,%ebx
c0105299:	7f 0b                	jg     c01052a6 <vprintfmt+0x14b>
c010529b:	8b 34 9d 08 6c 10 c0 	mov    -0x3fef93f8(,%ebx,4),%esi
c01052a2:	85 f6                	test   %esi,%esi
c01052a4:	75 19                	jne    c01052bf <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01052a6:	53                   	push   %ebx
c01052a7:	68 35 6c 10 c0       	push   $0xc0106c35
c01052ac:	ff 75 0c             	push   0xc(%ebp)
c01052af:	ff 75 08             	push   0x8(%ebp)
c01052b2:	e8 80 fe ff ff       	call   c0105137 <printfmt>
c01052b7:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01052ba:	e9 37 02 00 00       	jmp    c01054f6 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
c01052bf:	56                   	push   %esi
c01052c0:	68 3e 6c 10 c0       	push   $0xc0106c3e
c01052c5:	ff 75 0c             	push   0xc(%ebp)
c01052c8:	ff 75 08             	push   0x8(%ebp)
c01052cb:	e8 67 fe ff ff       	call   c0105137 <printfmt>
c01052d0:	83 c4 10             	add    $0x10,%esp
            break;
c01052d3:	e9 1e 02 00 00       	jmp    c01054f6 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01052d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01052db:	8d 50 04             	lea    0x4(%eax),%edx
c01052de:	89 55 14             	mov    %edx,0x14(%ebp)
c01052e1:	8b 30                	mov    (%eax),%esi
c01052e3:	85 f6                	test   %esi,%esi
c01052e5:	75 05                	jne    c01052ec <vprintfmt+0x191>
                p = "(null)";
c01052e7:	be 41 6c 10 c0       	mov    $0xc0106c41,%esi
            }
            if (width > 0 && padc != '-') {
c01052ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052f0:	7e 76                	jle    c0105368 <vprintfmt+0x20d>
c01052f2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01052f6:	74 70                	je     c0105368 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01052f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052fb:	83 ec 08             	sub    $0x8,%esp
c01052fe:	50                   	push   %eax
c01052ff:	56                   	push   %esi
c0105300:	e8 df 02 00 00       	call   c01055e4 <strnlen>
c0105305:	83 c4 10             	add    $0x10,%esp
c0105308:	89 c2                	mov    %eax,%edx
c010530a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010530d:	29 d0                	sub    %edx,%eax
c010530f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105312:	eb 17                	jmp    c010532b <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105314:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105318:	83 ec 08             	sub    $0x8,%esp
c010531b:	ff 75 0c             	push   0xc(%ebp)
c010531e:	50                   	push   %eax
c010531f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105322:	ff d0                	call   *%eax
c0105324:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105327:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010532b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010532f:	7f e3                	jg     c0105314 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105331:	eb 35                	jmp    c0105368 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105333:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105337:	74 1c                	je     c0105355 <vprintfmt+0x1fa>
c0105339:	83 fb 1f             	cmp    $0x1f,%ebx
c010533c:	7e 05                	jle    c0105343 <vprintfmt+0x1e8>
c010533e:	83 fb 7e             	cmp    $0x7e,%ebx
c0105341:	7e 12                	jle    c0105355 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105343:	83 ec 08             	sub    $0x8,%esp
c0105346:	ff 75 0c             	push   0xc(%ebp)
c0105349:	6a 3f                	push   $0x3f
c010534b:	8b 45 08             	mov    0x8(%ebp),%eax
c010534e:	ff d0                	call   *%eax
c0105350:	83 c4 10             	add    $0x10,%esp
c0105353:	eb 0f                	jmp    c0105364 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105355:	83 ec 08             	sub    $0x8,%esp
c0105358:	ff 75 0c             	push   0xc(%ebp)
c010535b:	53                   	push   %ebx
c010535c:	8b 45 08             	mov    0x8(%ebp),%eax
c010535f:	ff d0                	call   *%eax
c0105361:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105364:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105368:	89 f0                	mov    %esi,%eax
c010536a:	8d 70 01             	lea    0x1(%eax),%esi
c010536d:	0f b6 00             	movzbl (%eax),%eax
c0105370:	0f be d8             	movsbl %al,%ebx
c0105373:	85 db                	test   %ebx,%ebx
c0105375:	74 26                	je     c010539d <vprintfmt+0x242>
c0105377:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010537b:	78 b6                	js     c0105333 <vprintfmt+0x1d8>
c010537d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105381:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105385:	79 ac                	jns    c0105333 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
c0105387:	eb 14                	jmp    c010539d <vprintfmt+0x242>
                putch(' ', putdat);
c0105389:	83 ec 08             	sub    $0x8,%esp
c010538c:	ff 75 0c             	push   0xc(%ebp)
c010538f:	6a 20                	push   $0x20
c0105391:	8b 45 08             	mov    0x8(%ebp),%eax
c0105394:	ff d0                	call   *%eax
c0105396:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105399:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010539d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053a1:	7f e6                	jg     c0105389 <vprintfmt+0x22e>
            }
            break;
c01053a3:	e9 4e 01 00 00       	jmp    c01054f6 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01053a8:	83 ec 08             	sub    $0x8,%esp
c01053ab:	ff 75 e0             	push   -0x20(%ebp)
c01053ae:	8d 45 14             	lea    0x14(%ebp),%eax
c01053b1:	50                   	push   %eax
c01053b2:	e8 39 fd ff ff       	call   c01050f0 <getint>
c01053b7:	83 c4 10             	add    $0x10,%esp
c01053ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01053c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053c6:	85 d2                	test   %edx,%edx
c01053c8:	79 23                	jns    c01053ed <vprintfmt+0x292>
                putch('-', putdat);
c01053ca:	83 ec 08             	sub    $0x8,%esp
c01053cd:	ff 75 0c             	push   0xc(%ebp)
c01053d0:	6a 2d                	push   $0x2d
c01053d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d5:	ff d0                	call   *%eax
c01053d7:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01053da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053e0:	f7 d8                	neg    %eax
c01053e2:	83 d2 00             	adc    $0x0,%edx
c01053e5:	f7 da                	neg    %edx
c01053e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01053ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01053f4:	e9 9f 00 00 00       	jmp    c0105498 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01053f9:	83 ec 08             	sub    $0x8,%esp
c01053fc:	ff 75 e0             	push   -0x20(%ebp)
c01053ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0105402:	50                   	push   %eax
c0105403:	e8 99 fc ff ff       	call   c01050a1 <getuint>
c0105408:	83 c4 10             	add    $0x10,%esp
c010540b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010540e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105411:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105418:	eb 7e                	jmp    c0105498 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010541a:	83 ec 08             	sub    $0x8,%esp
c010541d:	ff 75 e0             	push   -0x20(%ebp)
c0105420:	8d 45 14             	lea    0x14(%ebp),%eax
c0105423:	50                   	push   %eax
c0105424:	e8 78 fc ff ff       	call   c01050a1 <getuint>
c0105429:	83 c4 10             	add    $0x10,%esp
c010542c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010542f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105432:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105439:	eb 5d                	jmp    c0105498 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c010543b:	83 ec 08             	sub    $0x8,%esp
c010543e:	ff 75 0c             	push   0xc(%ebp)
c0105441:	6a 30                	push   $0x30
c0105443:	8b 45 08             	mov    0x8(%ebp),%eax
c0105446:	ff d0                	call   *%eax
c0105448:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c010544b:	83 ec 08             	sub    $0x8,%esp
c010544e:	ff 75 0c             	push   0xc(%ebp)
c0105451:	6a 78                	push   $0x78
c0105453:	8b 45 08             	mov    0x8(%ebp),%eax
c0105456:	ff d0                	call   *%eax
c0105458:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010545b:	8b 45 14             	mov    0x14(%ebp),%eax
c010545e:	8d 50 04             	lea    0x4(%eax),%edx
c0105461:	89 55 14             	mov    %edx,0x14(%ebp)
c0105464:	8b 00                	mov    (%eax),%eax
c0105466:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105470:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105477:	eb 1f                	jmp    c0105498 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105479:	83 ec 08             	sub    $0x8,%esp
c010547c:	ff 75 e0             	push   -0x20(%ebp)
c010547f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105482:	50                   	push   %eax
c0105483:	e8 19 fc ff ff       	call   c01050a1 <getuint>
c0105488:	83 c4 10             	add    $0x10,%esp
c010548b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010548e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105491:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105498:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010549c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010549f:	83 ec 04             	sub    $0x4,%esp
c01054a2:	52                   	push   %edx
c01054a3:	ff 75 e8             	push   -0x18(%ebp)
c01054a6:	50                   	push   %eax
c01054a7:	ff 75 f4             	push   -0xc(%ebp)
c01054aa:	ff 75 f0             	push   -0x10(%ebp)
c01054ad:	ff 75 0c             	push   0xc(%ebp)
c01054b0:	ff 75 08             	push   0x8(%ebp)
c01054b3:	e8 fd fa ff ff       	call   c0104fb5 <printnum>
c01054b8:	83 c4 20             	add    $0x20,%esp
            break;
c01054bb:	eb 39                	jmp    c01054f6 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01054bd:	83 ec 08             	sub    $0x8,%esp
c01054c0:	ff 75 0c             	push   0xc(%ebp)
c01054c3:	53                   	push   %ebx
c01054c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c7:	ff d0                	call   *%eax
c01054c9:	83 c4 10             	add    $0x10,%esp
            break;
c01054cc:	eb 28                	jmp    c01054f6 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01054ce:	83 ec 08             	sub    $0x8,%esp
c01054d1:	ff 75 0c             	push   0xc(%ebp)
c01054d4:	6a 25                	push   $0x25
c01054d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d9:	ff d0                	call   *%eax
c01054db:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01054de:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01054e2:	eb 04                	jmp    c01054e8 <vprintfmt+0x38d>
c01054e4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01054e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01054eb:	83 e8 01             	sub    $0x1,%eax
c01054ee:	0f b6 00             	movzbl (%eax),%eax
c01054f1:	3c 25                	cmp    $0x25,%al
c01054f3:	75 ef                	jne    c01054e4 <vprintfmt+0x389>
                /* do nothing */;
            break;
c01054f5:	90                   	nop
    while (1) {
c01054f6:	e9 68 fc ff ff       	jmp    c0105163 <vprintfmt+0x8>
                return;
c01054fb:	90                   	nop
        }
    }
}
c01054fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01054ff:	5b                   	pop    %ebx
c0105500:	5e                   	pop    %esi
c0105501:	5d                   	pop    %ebp
c0105502:	c3                   	ret    

c0105503 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105503:	55                   	push   %ebp
c0105504:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105506:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105509:	8b 40 08             	mov    0x8(%eax),%eax
c010550c:	8d 50 01             	lea    0x1(%eax),%edx
c010550f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105512:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105515:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105518:	8b 10                	mov    (%eax),%edx
c010551a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010551d:	8b 40 04             	mov    0x4(%eax),%eax
c0105520:	39 c2                	cmp    %eax,%edx
c0105522:	73 12                	jae    c0105536 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105524:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105527:	8b 00                	mov    (%eax),%eax
c0105529:	8d 48 01             	lea    0x1(%eax),%ecx
c010552c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010552f:	89 0a                	mov    %ecx,(%edx)
c0105531:	8b 55 08             	mov    0x8(%ebp),%edx
c0105534:	88 10                	mov    %dl,(%eax)
    }
}
c0105536:	90                   	nop
c0105537:	5d                   	pop    %ebp
c0105538:	c3                   	ret    

c0105539 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105539:	55                   	push   %ebp
c010553a:	89 e5                	mov    %esp,%ebp
c010553c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010553f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105542:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105545:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105548:	50                   	push   %eax
c0105549:	ff 75 10             	push   0x10(%ebp)
c010554c:	ff 75 0c             	push   0xc(%ebp)
c010554f:	ff 75 08             	push   0x8(%ebp)
c0105552:	e8 0b 00 00 00       	call   c0105562 <vsnprintf>
c0105557:	83 c4 10             	add    $0x10,%esp
c010555a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010555d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105560:	c9                   	leave  
c0105561:	c3                   	ret    

c0105562 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105562:	55                   	push   %ebp
c0105563:	89 e5                	mov    %esp,%ebp
c0105565:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105568:	8b 45 08             	mov    0x8(%ebp),%eax
c010556b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105571:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105574:	8b 45 08             	mov    0x8(%ebp),%eax
c0105577:	01 d0                	add    %edx,%eax
c0105579:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010557c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105583:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105587:	74 0a                	je     c0105593 <vsnprintf+0x31>
c0105589:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010558c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010558f:	39 c2                	cmp    %eax,%edx
c0105591:	76 07                	jbe    c010559a <vsnprintf+0x38>
        return -E_INVAL;
c0105593:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105598:	eb 20                	jmp    c01055ba <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010559a:	ff 75 14             	push   0x14(%ebp)
c010559d:	ff 75 10             	push   0x10(%ebp)
c01055a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01055a3:	50                   	push   %eax
c01055a4:	68 03 55 10 c0       	push   $0xc0105503
c01055a9:	e8 ad fb ff ff       	call   c010515b <vprintfmt>
c01055ae:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01055b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055b4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01055b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01055ba:	c9                   	leave  
c01055bb:	c3                   	ret    

c01055bc <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01055bc:	55                   	push   %ebp
c01055bd:	89 e5                	mov    %esp,%ebp
c01055bf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055c9:	eb 04                	jmp    c01055cf <strlen+0x13>
        cnt ++;
c01055cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d2:	8d 50 01             	lea    0x1(%eax),%edx
c01055d5:	89 55 08             	mov    %edx,0x8(%ebp)
c01055d8:	0f b6 00             	movzbl (%eax),%eax
c01055db:	84 c0                	test   %al,%al
c01055dd:	75 ec                	jne    c01055cb <strlen+0xf>
    }
    return cnt;
c01055df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055e2:	c9                   	leave  
c01055e3:	c3                   	ret    

c01055e4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01055e4:	55                   	push   %ebp
c01055e5:	89 e5                	mov    %esp,%ebp
c01055e7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055f1:	eb 04                	jmp    c01055f7 <strnlen+0x13>
        cnt ++;
c01055f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01055fd:	73 10                	jae    c010560f <strnlen+0x2b>
c01055ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105602:	8d 50 01             	lea    0x1(%eax),%edx
c0105605:	89 55 08             	mov    %edx,0x8(%ebp)
c0105608:	0f b6 00             	movzbl (%eax),%eax
c010560b:	84 c0                	test   %al,%al
c010560d:	75 e4                	jne    c01055f3 <strnlen+0xf>
    }
    return cnt;
c010560f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105612:	c9                   	leave  
c0105613:	c3                   	ret    

c0105614 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105614:	55                   	push   %ebp
c0105615:	89 e5                	mov    %esp,%ebp
c0105617:	57                   	push   %edi
c0105618:	56                   	push   %esi
c0105619:	83 ec 20             	sub    $0x20,%esp
c010561c:	8b 45 08             	mov    0x8(%ebp),%eax
c010561f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105622:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105625:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105628:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010562b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010562e:	89 d1                	mov    %edx,%ecx
c0105630:	89 c2                	mov    %eax,%edx
c0105632:	89 ce                	mov    %ecx,%esi
c0105634:	89 d7                	mov    %edx,%edi
c0105636:	ac                   	lods   %ds:(%esi),%al
c0105637:	aa                   	stos   %al,%es:(%edi)
c0105638:	84 c0                	test   %al,%al
c010563a:	75 fa                	jne    c0105636 <strcpy+0x22>
c010563c:	89 fa                	mov    %edi,%edx
c010563e:	89 f1                	mov    %esi,%ecx
c0105640:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105643:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105649:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010564c:	83 c4 20             	add    $0x20,%esp
c010564f:	5e                   	pop    %esi
c0105650:	5f                   	pop    %edi
c0105651:	5d                   	pop    %ebp
c0105652:	c3                   	ret    

c0105653 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105653:	55                   	push   %ebp
c0105654:	89 e5                	mov    %esp,%ebp
c0105656:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105659:	8b 45 08             	mov    0x8(%ebp),%eax
c010565c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010565f:	eb 21                	jmp    c0105682 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105661:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105664:	0f b6 10             	movzbl (%eax),%edx
c0105667:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010566a:	88 10                	mov    %dl,(%eax)
c010566c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010566f:	0f b6 00             	movzbl (%eax),%eax
c0105672:	84 c0                	test   %al,%al
c0105674:	74 04                	je     c010567a <strncpy+0x27>
            src ++;
c0105676:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010567a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010567e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105682:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105686:	75 d9                	jne    c0105661 <strncpy+0xe>
    }
    return dst;
c0105688:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010568b:	c9                   	leave  
c010568c:	c3                   	ret    

c010568d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010568d:	55                   	push   %ebp
c010568e:	89 e5                	mov    %esp,%ebp
c0105690:	57                   	push   %edi
c0105691:	56                   	push   %esi
c0105692:	83 ec 20             	sub    $0x20,%esp
c0105695:	8b 45 08             	mov    0x8(%ebp),%eax
c0105698:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010569b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01056a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a7:	89 d1                	mov    %edx,%ecx
c01056a9:	89 c2                	mov    %eax,%edx
c01056ab:	89 ce                	mov    %ecx,%esi
c01056ad:	89 d7                	mov    %edx,%edi
c01056af:	ac                   	lods   %ds:(%esi),%al
c01056b0:	ae                   	scas   %es:(%edi),%al
c01056b1:	75 08                	jne    c01056bb <strcmp+0x2e>
c01056b3:	84 c0                	test   %al,%al
c01056b5:	75 f8                	jne    c01056af <strcmp+0x22>
c01056b7:	31 c0                	xor    %eax,%eax
c01056b9:	eb 04                	jmp    c01056bf <strcmp+0x32>
c01056bb:	19 c0                	sbb    %eax,%eax
c01056bd:	0c 01                	or     $0x1,%al
c01056bf:	89 fa                	mov    %edi,%edx
c01056c1:	89 f1                	mov    %esi,%ecx
c01056c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056c6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01056c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01056cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01056cf:	83 c4 20             	add    $0x20,%esp
c01056d2:	5e                   	pop    %esi
c01056d3:	5f                   	pop    %edi
c01056d4:	5d                   	pop    %ebp
c01056d5:	c3                   	ret    

c01056d6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01056d6:	55                   	push   %ebp
c01056d7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056d9:	eb 0c                	jmp    c01056e7 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01056db:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01056df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01056e3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056eb:	74 1a                	je     c0105707 <strncmp+0x31>
c01056ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f0:	0f b6 00             	movzbl (%eax),%eax
c01056f3:	84 c0                	test   %al,%al
c01056f5:	74 10                	je     c0105707 <strncmp+0x31>
c01056f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fa:	0f b6 10             	movzbl (%eax),%edx
c01056fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105700:	0f b6 00             	movzbl (%eax),%eax
c0105703:	38 c2                	cmp    %al,%dl
c0105705:	74 d4                	je     c01056db <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105707:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010570b:	74 18                	je     c0105725 <strncmp+0x4f>
c010570d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105710:	0f b6 00             	movzbl (%eax),%eax
c0105713:	0f b6 d0             	movzbl %al,%edx
c0105716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105719:	0f b6 00             	movzbl (%eax),%eax
c010571c:	0f b6 c8             	movzbl %al,%ecx
c010571f:	89 d0                	mov    %edx,%eax
c0105721:	29 c8                	sub    %ecx,%eax
c0105723:	eb 05                	jmp    c010572a <strncmp+0x54>
c0105725:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010572a:	5d                   	pop    %ebp
c010572b:	c3                   	ret    

c010572c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010572c:	55                   	push   %ebp
c010572d:	89 e5                	mov    %esp,%ebp
c010572f:	83 ec 04             	sub    $0x4,%esp
c0105732:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105735:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105738:	eb 14                	jmp    c010574e <strchr+0x22>
        if (*s == c) {
c010573a:	8b 45 08             	mov    0x8(%ebp),%eax
c010573d:	0f b6 00             	movzbl (%eax),%eax
c0105740:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105743:	75 05                	jne    c010574a <strchr+0x1e>
            return (char *)s;
c0105745:	8b 45 08             	mov    0x8(%ebp),%eax
c0105748:	eb 13                	jmp    c010575d <strchr+0x31>
        }
        s ++;
c010574a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010574e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105751:	0f b6 00             	movzbl (%eax),%eax
c0105754:	84 c0                	test   %al,%al
c0105756:	75 e2                	jne    c010573a <strchr+0xe>
    }
    return NULL;
c0105758:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010575d:	c9                   	leave  
c010575e:	c3                   	ret    

c010575f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010575f:	55                   	push   %ebp
c0105760:	89 e5                	mov    %esp,%ebp
c0105762:	83 ec 04             	sub    $0x4,%esp
c0105765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105768:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010576b:	eb 0f                	jmp    c010577c <strfind+0x1d>
        if (*s == c) {
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	0f b6 00             	movzbl (%eax),%eax
c0105773:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105776:	74 10                	je     c0105788 <strfind+0x29>
            break;
        }
        s ++;
c0105778:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010577c:	8b 45 08             	mov    0x8(%ebp),%eax
c010577f:	0f b6 00             	movzbl (%eax),%eax
c0105782:	84 c0                	test   %al,%al
c0105784:	75 e7                	jne    c010576d <strfind+0xe>
c0105786:	eb 01                	jmp    c0105789 <strfind+0x2a>
            break;
c0105788:	90                   	nop
    }
    return (char *)s;
c0105789:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010578c:	c9                   	leave  
c010578d:	c3                   	ret    

c010578e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010578e:	55                   	push   %ebp
c010578f:	89 e5                	mov    %esp,%ebp
c0105791:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105794:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010579b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01057a2:	eb 04                	jmp    c01057a8 <strtol+0x1a>
        s ++;
c01057a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01057a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ab:	0f b6 00             	movzbl (%eax),%eax
c01057ae:	3c 20                	cmp    $0x20,%al
c01057b0:	74 f2                	je     c01057a4 <strtol+0x16>
c01057b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b5:	0f b6 00             	movzbl (%eax),%eax
c01057b8:	3c 09                	cmp    $0x9,%al
c01057ba:	74 e8                	je     c01057a4 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01057bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bf:	0f b6 00             	movzbl (%eax),%eax
c01057c2:	3c 2b                	cmp    $0x2b,%al
c01057c4:	75 06                	jne    c01057cc <strtol+0x3e>
        s ++;
c01057c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057ca:	eb 15                	jmp    c01057e1 <strtol+0x53>
    }
    else if (*s == '-') {
c01057cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cf:	0f b6 00             	movzbl (%eax),%eax
c01057d2:	3c 2d                	cmp    $0x2d,%al
c01057d4:	75 0b                	jne    c01057e1 <strtol+0x53>
        s ++, neg = 1;
c01057d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01057e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057e5:	74 06                	je     c01057ed <strtol+0x5f>
c01057e7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01057eb:	75 24                	jne    c0105811 <strtol+0x83>
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	0f b6 00             	movzbl (%eax),%eax
c01057f3:	3c 30                	cmp    $0x30,%al
c01057f5:	75 1a                	jne    c0105811 <strtol+0x83>
c01057f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fa:	83 c0 01             	add    $0x1,%eax
c01057fd:	0f b6 00             	movzbl (%eax),%eax
c0105800:	3c 78                	cmp    $0x78,%al
c0105802:	75 0d                	jne    c0105811 <strtol+0x83>
        s += 2, base = 16;
c0105804:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105808:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010580f:	eb 2a                	jmp    c010583b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105811:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105815:	75 17                	jne    c010582e <strtol+0xa0>
c0105817:	8b 45 08             	mov    0x8(%ebp),%eax
c010581a:	0f b6 00             	movzbl (%eax),%eax
c010581d:	3c 30                	cmp    $0x30,%al
c010581f:	75 0d                	jne    c010582e <strtol+0xa0>
        s ++, base = 8;
c0105821:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105825:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010582c:	eb 0d                	jmp    c010583b <strtol+0xad>
    }
    else if (base == 0) {
c010582e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105832:	75 07                	jne    c010583b <strtol+0xad>
        base = 10;
c0105834:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010583b:	8b 45 08             	mov    0x8(%ebp),%eax
c010583e:	0f b6 00             	movzbl (%eax),%eax
c0105841:	3c 2f                	cmp    $0x2f,%al
c0105843:	7e 1b                	jle    c0105860 <strtol+0xd2>
c0105845:	8b 45 08             	mov    0x8(%ebp),%eax
c0105848:	0f b6 00             	movzbl (%eax),%eax
c010584b:	3c 39                	cmp    $0x39,%al
c010584d:	7f 11                	jg     c0105860 <strtol+0xd2>
            dig = *s - '0';
c010584f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105852:	0f b6 00             	movzbl (%eax),%eax
c0105855:	0f be c0             	movsbl %al,%eax
c0105858:	83 e8 30             	sub    $0x30,%eax
c010585b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010585e:	eb 48                	jmp    c01058a8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105860:	8b 45 08             	mov    0x8(%ebp),%eax
c0105863:	0f b6 00             	movzbl (%eax),%eax
c0105866:	3c 60                	cmp    $0x60,%al
c0105868:	7e 1b                	jle    c0105885 <strtol+0xf7>
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	0f b6 00             	movzbl (%eax),%eax
c0105870:	3c 7a                	cmp    $0x7a,%al
c0105872:	7f 11                	jg     c0105885 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	0f b6 00             	movzbl (%eax),%eax
c010587a:	0f be c0             	movsbl %al,%eax
c010587d:	83 e8 57             	sub    $0x57,%eax
c0105880:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105883:	eb 23                	jmp    c01058a8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105885:	8b 45 08             	mov    0x8(%ebp),%eax
c0105888:	0f b6 00             	movzbl (%eax),%eax
c010588b:	3c 40                	cmp    $0x40,%al
c010588d:	7e 3c                	jle    c01058cb <strtol+0x13d>
c010588f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105892:	0f b6 00             	movzbl (%eax),%eax
c0105895:	3c 5a                	cmp    $0x5a,%al
c0105897:	7f 32                	jg     c01058cb <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105899:	8b 45 08             	mov    0x8(%ebp),%eax
c010589c:	0f b6 00             	movzbl (%eax),%eax
c010589f:	0f be c0             	movsbl %al,%eax
c01058a2:	83 e8 37             	sub    $0x37,%eax
c01058a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01058a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ab:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058ae:	7d 1a                	jge    c01058ca <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01058b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058b7:	0f af 45 10          	imul   0x10(%ebp),%eax
c01058bb:	89 c2                	mov    %eax,%edx
c01058bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058c0:	01 d0                	add    %edx,%eax
c01058c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01058c5:	e9 71 ff ff ff       	jmp    c010583b <strtol+0xad>
            break;
c01058ca:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01058cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058cf:	74 08                	je     c01058d9 <strtol+0x14b>
        *endptr = (char *) s;
c01058d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01058d7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01058d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01058dd:	74 07                	je     c01058e6 <strtol+0x158>
c01058df:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058e2:	f7 d8                	neg    %eax
c01058e4:	eb 03                	jmp    c01058e9 <strtol+0x15b>
c01058e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01058e9:	c9                   	leave  
c01058ea:	c3                   	ret    

c01058eb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01058eb:	55                   	push   %ebp
c01058ec:	89 e5                	mov    %esp,%ebp
c01058ee:	57                   	push   %edi
c01058ef:	83 ec 24             	sub    $0x24,%esp
c01058f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01058f8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01058fc:	8b 55 08             	mov    0x8(%ebp),%edx
c01058ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105902:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105905:	8b 45 10             	mov    0x10(%ebp),%eax
c0105908:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010590b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010590e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105912:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105915:	89 d7                	mov    %edx,%edi
c0105917:	f3 aa                	rep stos %al,%es:(%edi)
c0105919:	89 fa                	mov    %edi,%edx
c010591b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010591e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105921:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105924:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105927:	c9                   	leave  
c0105928:	c3                   	ret    

c0105929 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105929:	55                   	push   %ebp
c010592a:	89 e5                	mov    %esp,%ebp
c010592c:	57                   	push   %edi
c010592d:	56                   	push   %esi
c010592e:	53                   	push   %ebx
c010592f:	83 ec 30             	sub    $0x30,%esp
c0105932:	8b 45 08             	mov    0x8(%ebp),%eax
c0105935:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105938:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010593e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105941:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105947:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010594a:	73 42                	jae    c010598e <memmove+0x65>
c010594c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010594f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105952:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105955:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105958:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010595b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010595e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105961:	c1 e8 02             	shr    $0x2,%eax
c0105964:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105966:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105969:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010596c:	89 d7                	mov    %edx,%edi
c010596e:	89 c6                	mov    %eax,%esi
c0105970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105972:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105975:	83 e1 03             	and    $0x3,%ecx
c0105978:	74 02                	je     c010597c <memmove+0x53>
c010597a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010597c:	89 f0                	mov    %esi,%eax
c010597e:	89 fa                	mov    %edi,%edx
c0105980:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105983:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105986:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c010598c:	eb 36                	jmp    c01059c4 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010598e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105991:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105994:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105997:	01 c2                	add    %eax,%edx
c0105999:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010599c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010599f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059a2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01059a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059a8:	89 c1                	mov    %eax,%ecx
c01059aa:	89 d8                	mov    %ebx,%eax
c01059ac:	89 d6                	mov    %edx,%esi
c01059ae:	89 c7                	mov    %eax,%edi
c01059b0:	fd                   	std    
c01059b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059b3:	fc                   	cld    
c01059b4:	89 f8                	mov    %edi,%eax
c01059b6:	89 f2                	mov    %esi,%edx
c01059b8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01059bb:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01059be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01059c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01059c4:	83 c4 30             	add    $0x30,%esp
c01059c7:	5b                   	pop    %ebx
c01059c8:	5e                   	pop    %esi
c01059c9:	5f                   	pop    %edi
c01059ca:	5d                   	pop    %ebp
c01059cb:	c3                   	ret    

c01059cc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01059cc:	55                   	push   %ebp
c01059cd:	89 e5                	mov    %esp,%ebp
c01059cf:	57                   	push   %edi
c01059d0:	56                   	push   %esi
c01059d1:	83 ec 20             	sub    $0x20,%esp
c01059d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01059e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059e9:	c1 e8 02             	shr    $0x2,%eax
c01059ec:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01059ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059f4:	89 d7                	mov    %edx,%edi
c01059f6:	89 c6                	mov    %eax,%esi
c01059f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01059fa:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01059fd:	83 e1 03             	and    $0x3,%ecx
c0105a00:	74 02                	je     c0105a04 <memcpy+0x38>
c0105a02:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a04:	89 f0                	mov    %esi,%eax
c0105a06:	89 fa                	mov    %edi,%edx
c0105a08:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105a0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105a14:	83 c4 20             	add    $0x20,%esp
c0105a17:	5e                   	pop    %esi
c0105a18:	5f                   	pop    %edi
c0105a19:	5d                   	pop    %ebp
c0105a1a:	c3                   	ret    

c0105a1b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105a1b:	55                   	push   %ebp
c0105a1c:	89 e5                	mov    %esp,%ebp
c0105a1e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105a21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a24:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105a27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105a2d:	eb 30                	jmp    c0105a5f <memcmp+0x44>
        if (*s1 != *s2) {
c0105a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a32:	0f b6 10             	movzbl (%eax),%edx
c0105a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a38:	0f b6 00             	movzbl (%eax),%eax
c0105a3b:	38 c2                	cmp    %al,%dl
c0105a3d:	74 18                	je     c0105a57 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a42:	0f b6 00             	movzbl (%eax),%eax
c0105a45:	0f b6 d0             	movzbl %al,%edx
c0105a48:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a4b:	0f b6 00             	movzbl (%eax),%eax
c0105a4e:	0f b6 c8             	movzbl %al,%ecx
c0105a51:	89 d0                	mov    %edx,%eax
c0105a53:	29 c8                	sub    %ecx,%eax
c0105a55:	eb 1a                	jmp    c0105a71 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105a57:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a5b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105a5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a62:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a65:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a68:	85 c0                	test   %eax,%eax
c0105a6a:	75 c3                	jne    c0105a2f <memcmp+0x14>
    }
    return 0;
c0105a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a71:	c9                   	leave  
c0105a72:	c3                   	ret    
