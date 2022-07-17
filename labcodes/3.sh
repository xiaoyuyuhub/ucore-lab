
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
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 b0 11 c0 	movl   $0xc011b000,(%esp)
c0100059:	e8 d9 5c 00 00       	call   c0105d37 <memset>

    cons_init();                // init the console
c010005e:	e8 f7 15 00 00       	call   c010165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 e0 5e 10 c0 	movl   $0xc0105ee0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 fc 5e 10 c0 	movl   $0xc0105efc,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 b5 43 00 00       	call   c0104441 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 4a 17 00 00       	call   c01017db <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 ae 18 00 00       	call   c0101944 <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 1e 0d 00 00       	call   c0100db9 <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 99 16 00 00       	call   c0101739 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 10 0c 00 00       	call   c0100cd4 <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 01 5f 10 c0 	movl   $0xc0105f01,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 0f 5f 10 c0 	movl   $0xc0105f0f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 1d 5f 10 c0 	movl   $0xc0105f1d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 2b 5f 10 c0 	movl   $0xc0105f2b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 39 5f 10 c0 	movl   $0xc0105f39,(%esp)
c01001ea:	e8 67 01 00 00       	call   c0100356 <cprintf>
    round ++;
c01001ef:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	90                   	nop
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100208:	90                   	nop
c0100209:	5d                   	pop    %ebp
c010020a:	c3                   	ret    

c010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
c010020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100211:	e8 29 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100216:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 68 5f 10 c0 	movl   $0xc0105f68,(%esp)
c0100233:	e8 1e 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_kernel();
c0100238:	e8 c8 ff ff ff       	call   c0100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023d:	e8 fd fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c0100242:	90                   	nop
c0100243:	89 ec                	mov    %ebp,%esp
c0100245:	5d                   	pop    %ebp
c0100246:	c3                   	ret    

c0100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100247:	55                   	push   %ebp
c0100248:	89 e5                	mov    %esp,%ebp
c010024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100251:	74 13                	je     c0100266 <readline+0x1f>
        cprintf("%s", prompt);
c0100253:	8b 45 08             	mov    0x8(%ebp),%eax
c0100256:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025a:	c7 04 24 87 5f 10 c0 	movl   $0xc0105f87,(%esp)
c0100261:	e8 f0 00 00 00       	call   c0100356 <cprintf>
    }
    int i = 0, c;
c0100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010026d:	e8 73 01 00 00       	call   c01003e5 <getchar>
c0100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100279:	79 07                	jns    c0100282 <readline+0x3b>
            return NULL;
c010027b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100280:	eb 78                	jmp    c01002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100286:	7e 28                	jle    c01002b0 <readline+0x69>
c0100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028f:	7f 1f                	jg     c01002b0 <readline+0x69>
            cputchar(c);
c0100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100294:	89 04 24             	mov    %eax,(%esp)
c0100297:	e8 e2 00 00 00       	call   c010037e <cputchar>
            buf[i ++] = c;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029f:	8d 50 01             	lea    0x1(%eax),%edx
c01002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a8:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c01002ae:	eb 45                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b4:	75 16                	jne    c01002cc <readline+0x85>
c01002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ba:	7e 10                	jle    c01002cc <readline+0x85>
            cputchar(c);
c01002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 b7 00 00 00       	call   c010037e <cputchar>
            i --;
c01002c7:	ff 4d f4             	decl   -0xc(%ebp)
c01002ca:	eb 29                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d0:	74 06                	je     c01002d8 <readline+0x91>
c01002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d6:	75 95                	jne    c010026d <readline+0x26>
            cputchar(c);
c01002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002db:	89 04 24             	mov    %eax,(%esp)
c01002de:	e8 9b 00 00 00       	call   c010037e <cputchar>
            buf[i] = '\0';
c01002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e6:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ee:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002f3:	eb 05                	jmp    c01002fa <readline+0xb3>
        c = getchar();
c01002f5:	e9 73 ff ff ff       	jmp    c010026d <readline+0x26>
        }
    }
}
c01002fa:	89 ec                	mov    %ebp,%esp
c01002fc:	5d                   	pop    %ebp
c01002fd:	c3                   	ret    

c01002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002fe:	55                   	push   %ebp
c01002ff:	89 e5                	mov    %esp,%ebp
c0100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100304:	8b 45 08             	mov    0x8(%ebp),%eax
c0100307:	89 04 24             	mov    %eax,(%esp)
c010030a:	e8 7a 13 00 00       	call   c0101689 <cons_putc>
    (*cnt) ++;
c010030f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100312:	8b 00                	mov    (%eax),%eax
c0100314:	8d 50 01             	lea    0x1(%eax),%edx
c0100317:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031a:	89 10                	mov    %edx,(%eax)
}
c010031c:	90                   	nop
c010031d:	89 ec                	mov    %ebp,%esp
c010031f:	5d                   	pop    %ebp
c0100320:	c3                   	ret    

c0100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100321:	55                   	push   %ebp
c0100322:	89 e5                	mov    %esp,%ebp
c0100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100335:	8b 45 08             	mov    0x8(%ebp),%eax
c0100338:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100343:	c7 04 24 fe 02 10 c0 	movl   $0xc01002fe,(%esp)
c010034a:	e8 13 52 00 00       	call   c0105562 <vprintfmt>
    return cnt;
c010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100352:	89 ec                	mov    %ebp,%esp
c0100354:	5d                   	pop    %ebp
c0100355:	c3                   	ret    

c0100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100356:	55                   	push   %ebp
c0100357:	89 e5                	mov    %esp,%ebp
c0100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100365:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100369:	8b 45 08             	mov    0x8(%ebp),%eax
c010036c:	89 04 24             	mov    %eax,(%esp)
c010036f:	e8 ad ff ff ff       	call   c0100321 <vcprintf>
c0100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037a:	89 ec                	mov    %ebp,%esp
c010037c:	5d                   	pop    %ebp
c010037d:	c3                   	ret    

c010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037e:	55                   	push   %ebp
c010037f:	89 e5                	mov    %esp,%ebp
c0100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	89 04 24             	mov    %eax,(%esp)
c010038a:	e8 fa 12 00 00       	call   c0101689 <cons_putc>
}
c010038f:	90                   	nop
c0100390:	89 ec                	mov    %ebp,%esp
c0100392:	5d                   	pop    %ebp
c0100393:	c3                   	ret    

c0100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100394:	55                   	push   %ebp
c0100395:	89 e5                	mov    %esp,%ebp
c0100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003a1:	eb 13                	jmp    c01003b6 <cputs+0x22>
        cputch(c, &cnt);
c01003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ae:	89 04 24             	mov    %eax,(%esp)
c01003b1:	e8 48 ff ff ff       	call   c01002fe <cputch>
    while ((c = *str ++) != '\0') {
c01003b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b9:	8d 50 01             	lea    0x1(%eax),%edx
c01003bc:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bf:	0f b6 00             	movzbl (%eax),%eax
c01003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c9:	75 d8                	jne    c01003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d9:	e8 20 ff ff ff       	call   c01002fe <cputch>
    return cnt;
c01003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003e1:	89 ec                	mov    %ebp,%esp
c01003e3:	5d                   	pop    %ebp
c01003e4:	c3                   	ret    

c01003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e5:	55                   	push   %ebp
c01003e6:	89 e5                	mov    %esp,%ebp
c01003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003eb:	90                   	nop
c01003ec:	e8 d7 12 00 00       	call   c01016c8 <cons_getc>
c01003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f8:	74 f2                	je     c01003ec <getchar+0x7>
        /* do nothing */;
    return c;
c01003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fd:	89 ec                	mov    %ebp,%esp
c01003ff:	5d                   	pop    %ebp
c0100400:	c3                   	ret    

c0100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100401:	55                   	push   %ebp
c0100402:	89 e5                	mov    %esp,%ebp
c0100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040a:	8b 00                	mov    (%eax),%eax
c010040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010040f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100412:	8b 00                	mov    (%eax),%eax
c0100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010041e:	e9 ca 00 00 00       	jmp    c01004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c0100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100429:	01 d0                	add    %edx,%eax
c010042b:	89 c2                	mov    %eax,%edx
c010042d:	c1 ea 1f             	shr    $0x1f,%edx
c0100430:	01 d0                	add    %edx,%eax
c0100432:	d1 f8                	sar    %eax
c0100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043d:	eb 03                	jmp    c0100442 <stab_binsearch+0x41>
            m --;
c010043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7c 1f                	jl     c0100469 <stab_binsearch+0x68>
c010044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010044d:	89 d0                	mov    %edx,%eax
c010044f:	01 c0                	add    %eax,%eax
c0100451:	01 d0                	add    %edx,%eax
c0100453:	c1 e0 02             	shl    $0x2,%eax
c0100456:	89 c2                	mov    %eax,%edx
c0100458:	8b 45 08             	mov    0x8(%ebp),%eax
c010045b:	01 d0                	add    %edx,%eax
c010045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100461:	0f b6 c0             	movzbl %al,%eax
c0100464:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100467:	75 d6                	jne    c010043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010046f:	7d 09                	jge    c010047a <stab_binsearch+0x79>
            l = true_m + 1;
c0100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100474:	40                   	inc    %eax
c0100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100478:	eb 73                	jmp    c01004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100484:	89 d0                	mov    %edx,%eax
c0100486:	01 c0                	add    %eax,%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	c1 e0 02             	shl    $0x2,%eax
c010048d:	89 c2                	mov    %eax,%edx
c010048f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100492:	01 d0                	add    %edx,%eax
c0100494:	8b 40 08             	mov    0x8(%eax),%eax
c0100497:	39 45 18             	cmp    %eax,0x18(%ebp)
c010049a:	76 11                	jbe    c01004ad <stab_binsearch+0xac>
            *region_left = m;
c010049c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a7:	40                   	inc    %eax
c01004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ab:	eb 40                	jmp    c01004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b0:	89 d0                	mov    %edx,%eax
c01004b2:	01 c0                	add    %eax,%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	c1 e0 02             	shl    $0x2,%eax
c01004b9:	89 c2                	mov    %eax,%edx
c01004bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004be:	01 d0                	add    %edx,%eax
c01004c0:	8b 40 08             	mov    0x8(%eax),%eax
c01004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004c6:	73 14                	jae    c01004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	48                   	dec    %eax
c01004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004da:	eb 11                	jmp    c01004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f3:	0f 8e 2a ff ff ff    	jle    c0100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fd:	75 0f                	jne    c010050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100502:	8b 00                	mov    (%eax),%eax
c0100504:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100507:	8b 45 10             	mov    0x10(%ebp),%eax
c010050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010050c:	eb 3e                	jmp    c010054c <stab_binsearch+0x14b>
        l = *region_right;
c010050e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100516:	eb 03                	jmp    c010051b <stab_binsearch+0x11a>
c0100518:	ff 4d fc             	decl   -0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100523:	7e 1f                	jle    c0100544 <stab_binsearch+0x143>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100542:	75 d4                	jne    c0100518 <stab_binsearch+0x117>
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
}
c010054c:	90                   	nop
c010054d:	89 ec                	mov    %ebp,%esp
c010054f:	5d                   	pop    %ebp
c0100550:	c3                   	ret    

c0100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100551:	55                   	push   %ebp
c0100552:	89 e5                	mov    %esp,%ebp
c0100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 00 8c 5f 10 c0    	movl   $0xc0105f8c,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 8c 5f 10 c0 	movl   $0xc0105f8c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100581:	8b 55 08             	mov    0x8(%ebp),%edx
c0100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100591:	c7 45 f4 50 72 10 c0 	movl   $0xc0107250,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 28 27 11 c0 	movl   $0xc0112728,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec 29 27 11 c0 	movl   $0xc0112729,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 8c 5c 11 c0 	movl   $0xc0115c8c,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b3:	76 0b                	jbe    c01005c0 <debuginfo_eip+0x6f>
c01005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b8:	48                   	dec    %eax
c01005b9:	0f b6 00             	movzbl (%eax),%eax
c01005bc:	84 c0                	test   %al,%al
c01005be:	74 0a                	je     c01005ca <debuginfo_eip+0x79>
        return -1;
c01005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c5:	e9 ab 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005d7:	c1 f8 02             	sar    $0x2,%eax
c01005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e0:	48                   	dec    %eax
c01005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f2:	00 
c01005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100604:	89 04 24             	mov    %eax,(%esp)
c0100607:	e8 f5 fd ff ff       	call   c0100401 <stab_binsearch>
    if (lfile == 0)
c010060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060f:	85 c0                	test   %eax,%eax
c0100611:	75 0a                	jne    c010061d <debuginfo_eip+0xcc>
        return -1;
c0100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100618:	e9 58 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100629:	8b 45 08             	mov    0x8(%ebp),%eax
c010062c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100637:	00 
c0100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100649:	89 04 24             	mov    %eax,(%esp)
c010064c:	e8 b0 fd ff ff       	call   c0100401 <stab_binsearch>

    if (lfun <= rfun) {
c0100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100657:	39 c2                	cmp    %eax,%edx
c0100659:	7f 78                	jg     c01006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	89 d0                	mov    %edx,%eax
c0100662:	01 c0                	add    %eax,%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	c1 e0 02             	shl    $0x2,%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066e:	01 d0                	add    %edx,%eax
c0100670:	8b 10                	mov    (%eax),%edx
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100678:	39 c2                	cmp    %eax,%edx
c010067a:	73 22                	jae    c010069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067f:	89 c2                	mov    %eax,%edx
c0100681:	89 d0                	mov    %edx,%eax
c0100683:	01 c0                	add    %eax,%eax
c0100685:	01 d0                	add    %edx,%eax
c0100687:	c1 e0 02             	shl    $0x2,%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068f:	01 d0                	add    %edx,%eax
c0100691:	8b 10                	mov    (%eax),%edx
c0100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100696:	01 c2                	add    %eax,%edx
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a1:	89 c2                	mov    %eax,%edx
c01006a3:	89 d0                	mov    %edx,%eax
c01006a5:	01 c0                	add    %eax,%eax
c01006a7:	01 d0                	add    %edx,%eax
c01006a9:	c1 e0 02             	shl    $0x2,%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b1:	01 d0                	add    %edx,%eax
c01006b3:	8b 50 08             	mov    0x8(%eax),%edx
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bf:	8b 40 10             	mov    0x10(%eax),%eax
c01006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d1:	eb 15                	jmp    c01006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006eb:	8b 40 08             	mov    0x8(%eax),%eax
c01006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f5:	00 
c01006f6:	89 04 24             	mov    %eax,(%esp)
c01006f9:	e8 b1 54 00 00       	call   c0105baf <strfind>
c01006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100701:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100704:	29 c8                	sub    %ecx,%eax
c0100706:	89 c2                	mov    %eax,%edx
c0100708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100711:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071c:	00 
c010071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100720:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072e:	89 04 24             	mov    %eax,(%esp)
c0100731:	e8 cb fc ff ff       	call   c0100401 <stab_binsearch>
    if (lline <= rline) {
c0100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	39 c2                	cmp    %eax,%edx
c010073e:	7f 23                	jg     c0100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c0100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100743:	89 c2                	mov    %eax,%edx
c0100745:	89 d0                	mov    %edx,%eax
c0100747:	01 c0                	add    %eax,%eax
c0100749:	01 d0                	add    %edx,%eax
c010074b:	c1 e0 02             	shl    $0x2,%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100753:	01 d0                	add    %edx,%eax
c0100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100761:	eb 11                	jmp    c0100774 <debuginfo_eip+0x223>
        return -1;
c0100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100768:	e9 08 01 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100770:	48                   	dec    %eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b5                	jne    c010076d <debuginfo_eip+0x21c>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 99                	je     c010076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 42                	jl     c0100820 <debuginfo_eip+0x2cf>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 46                	jge    c0100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	40                   	inc    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100831:	eb 16                	jmp    c0100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	8b 40 14             	mov    0x14(%eax),%eax
c0100839:	8d 50 01             	lea    0x1(%eax),%edx
c010083c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100845:	40                   	inc    %eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7d 1d                	jge    c0100870 <debuginfo_eip+0x31f>
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c a0                	cmp    $0xa0,%al
c010086e:	74 c3                	je     c0100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100875:	89 ec                	mov    %ebp,%esp
c0100877:	5d                   	pop    %ebp
c0100878:	c3                   	ret    

c0100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100879:	55                   	push   %ebp
c010087a:	89 e5                	mov    %esp,%ebp
c010087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010087f:	c7 04 24 96 5f 10 c0 	movl   $0xc0105f96,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 c3 5e 10 	movl   $0xc0105ec3,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 c7 5f 10 c0 	movl   $0xc0105fc7,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 df 5f 10 c0 	movl   $0xc0105fdf,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c bf 11 	movl   $0xc011bf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 f7 5f 10 c0 	movl   $0xc0105ff7,(%esp)
c01008d6:	e8 7b fa ff ff       	call   c0100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008db:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c01008e0:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f0:	85 c0                	test   %eax,%eax
c01008f2:	0f 48 c2             	cmovs  %edx,%eax
c01008f5:	c1 f8 0a             	sar    $0xa,%eax
c01008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fc:	c7 04 24 10 60 10 c0 	movl   $0xc0106010,(%esp)
c0100903:	e8 4e fa ff ff       	call   c0100356 <cprintf>
}
c0100908:	90                   	nop
c0100909:	89 ec                	mov    %ebp,%esp
c010090b:	5d                   	pop    %ebp
c010090c:	c3                   	ret    

c010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 04 24             	mov    %eax,(%esp)
c0100923:	e8 29 fc ff ff       	call   c0100551 <debuginfo_eip>
c0100928:	85 c0                	test   %eax,%eax
c010092a:	74 15                	je     c0100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100933:	c7 04 24 3a 60 10 c0 	movl   $0xc010603a,(%esp)
c010093a:	e8 17 fa ff ff       	call   c0100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010093f:	eb 6c                	jmp    c01009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100948:	eb 1b                	jmp    c0100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c010094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100950:	01 d0                	add    %edx,%eax
c0100952:	0f b6 10             	movzbl (%eax),%edx
c0100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095e:	01 c8                	add    %ecx,%eax
c0100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100962:	ff 45 f4             	incl   -0xc(%ebp)
c0100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010096b:	7c dd                	jl     c010094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100976:	01 d0                	add    %edx,%eax
c0100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010097e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100981:	29 d0                	sub    %edx,%eax
c0100983:	89 c1                	mov    %eax,%ecx
c0100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100999:	89 54 24 08          	mov    %edx,0x8(%esp)
c010099d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a1:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c01009a8:	e8 a9 f9 ff ff       	call   c0100356 <cprintf>
}
c01009ad:	90                   	nop
c01009ae:	89 ec                	mov    %ebp,%esp
c01009b0:	5d                   	pop    %ebp
c01009b1:	c3                   	ret    

c01009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b2:	55                   	push   %ebp
c01009b3:	89 e5                	mov    %esp,%ebp
c01009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009b8:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c1:	89 ec                	mov    %ebp,%esp
c01009c3:	5d                   	pop    %ebp
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
c01009c8:	83 ec 38             	sub    $0x38,%esp
c01009cb:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009ce:	89 e8                	mov    %ebp,%eax
c01009d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c01009d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp = read_ebp();
c01009d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c01009d9:	e8 d4 ff ff ff       	call   c01009b2 <read_eip>
c01009de:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c01009e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e8:	e9 8e 00 00 00       	jmp    c0100a7b <print_stackframe+0xb6>
        if (ebp == 0) break;
c01009ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009f1:	0f 84 90 00 00 00    	je     c0100a87 <print_stackframe+0xc2>

        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a05:	c7 04 24 68 60 10 c0 	movl   $0xc0106068,(%esp)
c0100a0c:	e8 45 f9 ff ff       	call   c0100356 <cprintf>

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
c0100a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a14:	83 c0 14             	add    $0x14,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
c0100a17:	8b 18                	mov    (%eax),%ebx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
c0100a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1c:	83 c0 10             	add    $0x10,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
c0100a1f:	8b 08                	mov    (%eax),%ecx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
c0100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a24:	83 c0 0c             	add    $0xc,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
c0100a27:	8b 10                	mov    (%eax),%edx
c0100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2c:	83 c0 08             	add    $0x8,%eax
c0100a2f:	8b 00                	mov    (%eax),%eax
c0100a31:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a35:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a39:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a41:	c7 04 24 80 60 10 c0 	movl   $0xc0106080,(%esp)
c0100a48:	e8 09 f9 ff ff       	call   c0100356 <cprintf>

        cprintf("\n");
c0100a4d:	c7 04 24 a1 60 10 c0 	movl   $0xc01060a1,(%esp)
c0100a54:	e8 fd f8 ff ff       	call   c0100356 <cprintf>

        print_debuginfo(eip - 1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	48                   	dec    %eax
c0100a5d:	89 04 24             	mov    %eax,(%esp)
c0100a60:	e8 a8 fe ff ff       	call   c010090d <print_debuginfo>

        eip = *(uint32_t *)(ebp + 4);
c0100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a68:	83 c0 04             	add    $0x4,%eax
c0100a6b:	8b 00                	mov    (%eax),%eax
c0100a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)(ebp);
c0100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a73:	8b 00                	mov    (%eax),%eax
c0100a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a78:	ff 45 ec             	incl   -0x14(%ebp)
c0100a7b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7f:	0f 8e 68 ff ff ff    	jle    c01009ed <print_stackframe+0x28>
        // eip = ((uint32_t *)ebp)[1];
        // ebp = ((uint32_t *)ebp)[0];
    }

}
c0100a85:	eb 01                	jmp    c0100a88 <print_stackframe+0xc3>
        if (ebp == 0) break;
c0100a87:	90                   	nop
}
c0100a88:	90                   	nop
c0100a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a8c:	89 ec                	mov    %ebp,%esp
c0100a8e:	5d                   	pop    %ebp
c0100a8f:	c3                   	ret    

c0100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a90:	55                   	push   %ebp
c0100a91:	89 e5                	mov    %esp,%ebp
c0100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	eb 0c                	jmp    c0100aab <parse+0x1b>
            *buf ++ = '\0';
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aae:	0f b6 00             	movzbl (%eax),%eax
c0100ab1:	84 c0                	test   %al,%al
c0100ab3:	74 1d                	je     c0100ad2 <parse+0x42>
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	0f be c0             	movsbl %al,%eax
c0100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac2:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100ac9:	e8 ad 50 00 00       	call   c0105b7b <strchr>
c0100ace:	85 c0                	test   %eax,%eax
c0100ad0:	75 cd                	jne    c0100a9f <parse+0xf>
        }
        if (*buf == '\0') {
c0100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad5:	0f b6 00             	movzbl (%eax),%eax
c0100ad8:	84 c0                	test   %al,%al
c0100ada:	74 65                	je     c0100b41 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100adc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae0:	75 14                	jne    c0100af6 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae9:	00 
c0100aea:	c7 04 24 29 61 10 c0 	movl   $0xc0106129,(%esp)
c0100af1:	e8 60 f8 ff ff       	call   c0100356 <cprintf>
        }
        argv[argc ++] = buf;
c0100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af9:	8d 50 01             	lea    0x1(%eax),%edx
c0100afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b06:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b09:	01 c2                	add    %eax,%edx
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b10:	eb 03                	jmp    c0100b15 <parse+0x85>
            buf ++;
c0100b12:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b18:	0f b6 00             	movzbl (%eax),%eax
c0100b1b:	84 c0                	test   %al,%al
c0100b1d:	74 8c                	je     c0100aab <parse+0x1b>
c0100b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b22:	0f b6 00             	movzbl (%eax),%eax
c0100b25:	0f be c0             	movsbl %al,%eax
c0100b28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2c:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100b33:	e8 43 50 00 00       	call   c0105b7b <strchr>
c0100b38:	85 c0                	test   %eax,%eax
c0100b3a:	74 d6                	je     c0100b12 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3c:	e9 6a ff ff ff       	jmp    c0100aab <parse+0x1b>
            break;
c0100b41:	90                   	nop
        }
    }
    return argc;
c0100b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b45:	89 ec                	mov    %ebp,%esp
c0100b47:	5d                   	pop    %ebp
c0100b48:	c3                   	ret    

c0100b49 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b49:	55                   	push   %ebp
c0100b4a:	89 e5                	mov    %esp,%ebp
c0100b4c:	83 ec 68             	sub    $0x68,%esp
c0100b4f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b52:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5c:	89 04 24             	mov    %eax,(%esp)
c0100b5f:	e8 2c ff ff ff       	call   c0100a90 <parse>
c0100b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6b:	75 0a                	jne    c0100b77 <runcmd+0x2e>
        return 0;
c0100b6d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b72:	e9 83 00 00 00       	jmp    c0100bfa <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7e:	eb 5a                	jmp    c0100bda <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b80:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b86:	89 c8                	mov    %ecx,%eax
c0100b88:	01 c0                	add    %eax,%eax
c0100b8a:	01 c8                	add    %ecx,%eax
c0100b8c:	c1 e0 02             	shl    $0x2,%eax
c0100b8f:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b94:	8b 00                	mov    (%eax),%eax
c0100b96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9a:	89 04 24             	mov    %eax,(%esp)
c0100b9d:	e8 3d 4f 00 00       	call   c0105adf <strcmp>
c0100ba2:	85 c0                	test   %eax,%eax
c0100ba4:	75 31                	jne    c0100bd7 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba9:	89 d0                	mov    %edx,%eax
c0100bab:	01 c0                	add    %eax,%eax
c0100bad:	01 d0                	add    %edx,%eax
c0100baf:	c1 e0 02             	shl    $0x2,%eax
c0100bb2:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100bb7:	8b 10                	mov    (%eax),%edx
c0100bb9:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bbc:	83 c0 04             	add    $0x4,%eax
c0100bbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bc2:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd0:	89 1c 24             	mov    %ebx,(%esp)
c0100bd3:	ff d2                	call   *%edx
c0100bd5:	eb 23                	jmp    c0100bfa <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd7:	ff 45 f4             	incl   -0xc(%ebp)
c0100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdd:	83 f8 02             	cmp    $0x2,%eax
c0100be0:	76 9e                	jbe    c0100b80 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be9:	c7 04 24 47 61 10 c0 	movl   $0xc0106147,(%esp)
c0100bf0:	e8 61 f7 ff ff       	call   c0100356 <cprintf>
    return 0;
c0100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bfd:	89 ec                	mov    %ebp,%esp
c0100bff:	5d                   	pop    %ebp
c0100c00:	c3                   	ret    

c0100c01 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c01:	55                   	push   %ebp
c0100c02:	89 e5                	mov    %esp,%ebp
c0100c04:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c07:	c7 04 24 60 61 10 c0 	movl   $0xc0106160,(%esp)
c0100c0e:	e8 43 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c13:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c0100c1a:	e8 37 f7 ff ff       	call   c0100356 <cprintf>

    if (tf != NULL) {
c0100c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c23:	74 0b                	je     c0100c30 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c28:	89 04 24             	mov    %eax,(%esp)
c0100c2b:	e8 64 0e 00 00       	call   c0101a94 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c30:	c7 04 24 ad 61 10 c0 	movl   $0xc01061ad,(%esp)
c0100c37:	e8 0b f6 ff ff       	call   c0100247 <readline>
c0100c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c43:	74 eb                	je     c0100c30 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4f:	89 04 24             	mov    %eax,(%esp)
c0100c52:	e8 f2 fe ff ff       	call   c0100b49 <runcmd>
c0100c57:	85 c0                	test   %eax,%eax
c0100c59:	78 02                	js     c0100c5d <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c5b:	eb d3                	jmp    c0100c30 <kmonitor+0x2f>
                break;
c0100c5d:	90                   	nop
            }
        }
    }
}
c0100c5e:	90                   	nop
c0100c5f:	89 ec                	mov    %ebp,%esp
c0100c61:	5d                   	pop    %ebp
c0100c62:	c3                   	ret    

c0100c63 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c63:	55                   	push   %ebp
c0100c64:	89 e5                	mov    %esp,%ebp
c0100c66:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c70:	eb 3d                	jmp    c0100caf <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c75:	89 d0                	mov    %edx,%eax
c0100c77:	01 c0                	add    %eax,%eax
c0100c79:	01 d0                	add    %edx,%eax
c0100c7b:	c1 e0 02             	shl    $0x2,%eax
c0100c7e:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c83:	8b 10                	mov    (%eax),%edx
c0100c85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c88:	89 c8                	mov    %ecx,%eax
c0100c8a:	01 c0                	add    %eax,%eax
c0100c8c:	01 c8                	add    %ecx,%eax
c0100c8e:	c1 e0 02             	shl    $0x2,%eax
c0100c91:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c96:	8b 00                	mov    (%eax),%eax
c0100c98:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca0:	c7 04 24 b1 61 10 c0 	movl   $0xc01061b1,(%esp)
c0100ca7:	e8 aa f6 ff ff       	call   c0100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cac:	ff 45 f4             	incl   -0xc(%ebp)
c0100caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb2:	83 f8 02             	cmp    $0x2,%eax
c0100cb5:	76 bb                	jbe    c0100c72 <mon_help+0xf>
    }
    return 0;
c0100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbc:	89 ec                	mov    %ebp,%esp
c0100cbe:	5d                   	pop    %ebp
c0100cbf:	c3                   	ret    

c0100cc0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc6:	e8 ae fb ff ff       	call   c0100879 <print_kerninfo>
    return 0;
c0100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd0:	89 ec                	mov    %ebp,%esp
c0100cd2:	5d                   	pop    %ebp
c0100cd3:	c3                   	ret    

c0100cd4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cd4:	55                   	push   %ebp
c0100cd5:	89 e5                	mov    %esp,%ebp
c0100cd7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cda:	e8 e6 fc ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce4:	89 ec                	mov    %ebp,%esp
c0100ce6:	5d                   	pop    %ebp
c0100ce7:	c3                   	ret    

c0100ce8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ce8:	55                   	push   %ebp
c0100ce9:	89 e5                	mov    %esp,%ebp
c0100ceb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cee:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100cf3:	85 c0                	test   %eax,%eax
c0100cf5:	75 5b                	jne    c0100d52 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cf7:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100cfe:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d01:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d0a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d15:	c7 04 24 ba 61 10 c0 	movl   $0xc01061ba,(%esp)
c0100d1c:	e8 35 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d28:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2b:	89 04 24             	mov    %eax,(%esp)
c0100d2e:	e8 ee f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d33:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100d3a:	e8 17 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3f:	c7 04 24 d8 61 10 c0 	movl   $0xc01061d8,(%esp)
c0100d46:	e8 0b f6 ff ff       	call   c0100356 <cprintf>
    print_stackframe();
c0100d4b:	e8 75 fc ff ff       	call   c01009c5 <print_stackframe>
c0100d50:	eb 01                	jmp    c0100d53 <__panic+0x6b>
        goto panic_dead;
c0100d52:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d53:	e8 e9 09 00 00       	call   c0101741 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d5f:	e8 9d fe ff ff       	call   c0100c01 <kmonitor>
c0100d64:	eb f2                	jmp    c0100d58 <__panic+0x70>

c0100d66 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d66:	55                   	push   %ebp
c0100d67:	89 e5                	mov    %esp,%ebp
c0100d69:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d6c:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d75:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d79:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d80:	c7 04 24 ea 61 10 c0 	movl   $0xc01061ea,(%esp)
c0100d87:	e8 ca f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d96:	89 04 24             	mov    %eax,(%esp)
c0100d99:	e8 83 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d9e:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100da5:	e8 ac f5 ff ff       	call   c0100356 <cprintf>
    va_end(ap);
}
c0100daa:	90                   	nop
c0100dab:	89 ec                	mov    %ebp,%esp
c0100dad:	5d                   	pop    %ebp
c0100dae:	c3                   	ret    

c0100daf <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100daf:	55                   	push   %ebp
c0100db0:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100db2:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100db7:	5d                   	pop    %ebp
c0100db8:	c3                   	ret    

c0100db9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100db9:	55                   	push   %ebp
c0100dba:	89 e5                	mov    %esp,%ebp
c0100dbc:	83 ec 28             	sub    $0x28,%esp
c0100dbf:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dc5:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd1:	ee                   	out    %al,(%dx)
}
c0100dd2:	90                   	nop
c0100dd3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dd9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ddd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100de1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100de5:	ee                   	out    %al,(%dx)
}
c0100de6:	90                   	nop
c0100de7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100ded:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100df5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100df9:	ee                   	out    %al,(%dx)
}
c0100dfa:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dfb:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100e02:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e05:	c7 04 24 08 62 10 c0 	movl   $0xc0106208,(%esp)
c0100e0c:	e8 45 f5 ff ff       	call   c0100356 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e18:	e8 89 09 00 00       	call   c01017a6 <pic_enable>
}
c0100e1d:	90                   	nop
c0100e1e:	89 ec                	mov    %ebp,%esp
c0100e20:	5d                   	pop    %ebp
c0100e21:	c3                   	ret    

c0100e22 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e28:	9c                   	pushf  
c0100e29:	58                   	pop    %eax
c0100e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e30:	25 00 02 00 00       	and    $0x200,%eax
c0100e35:	85 c0                	test   %eax,%eax
c0100e37:	74 0c                	je     c0100e45 <__intr_save+0x23>
        intr_disable();
c0100e39:	e8 03 09 00 00       	call   c0101741 <intr_disable>
        return 1;
c0100e3e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e43:	eb 05                	jmp    c0100e4a <__intr_save+0x28>
    }
    return 0;
c0100e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e4a:	89 ec                	mov    %ebp,%esp
c0100e4c:	5d                   	pop    %ebp
c0100e4d:	c3                   	ret    

c0100e4e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e4e:	55                   	push   %ebp
c0100e4f:	89 e5                	mov    %esp,%ebp
c0100e51:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e58:	74 05                	je     c0100e5f <__intr_restore+0x11>
        intr_enable();
c0100e5a:	e8 da 08 00 00       	call   c0101739 <intr_enable>
    }
}
c0100e5f:	90                   	nop
c0100e60:	89 ec                	mov    %ebp,%esp
c0100e62:	5d                   	pop    %ebp
c0100e63:	c3                   	ret    

c0100e64 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 10             	sub    $0x10,%esp
c0100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e74:	89 c2                	mov    %eax,%edx
c0100e76:	ec                   	in     (%dx),%al
c0100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e7a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e80:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e84:	89 c2                	mov    %eax,%edx
c0100e86:	ec                   	in     (%dx),%al
c0100e87:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e8a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e90:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e94:	89 c2                	mov    %eax,%edx
c0100e96:	ec                   	in     (%dx),%al
c0100e97:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e9a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ea0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ea4:	89 c2                	mov    %eax,%edx
c0100ea6:	ec                   	in     (%dx),%al
c0100ea7:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eaa:	90                   	nop
c0100eab:	89 ec                	mov    %ebp,%esp
c0100ead:	5d                   	pop    %ebp
c0100eae:	c3                   	ret    

c0100eaf <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eaf:	55                   	push   %ebp
c0100eb0:	89 e5                	mov    %esp,%ebp
c0100eb2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100eb5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebf:	0f b7 00             	movzwl (%eax),%eax
c0100ec2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed1:	0f b7 00             	movzwl (%eax),%eax
c0100ed4:	0f b7 c0             	movzwl %ax,%eax
c0100ed7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100edc:	74 12                	je     c0100ef0 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ede:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ee5:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100eec:	b4 03 
c0100eee:	eb 13                	jmp    c0100f03 <cga_init+0x54>
    } else {
        *cp = was;
c0100ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ef7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100efa:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100f01:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f03:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f0a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f0e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f12:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f16:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1a:	ee                   	out    %al,(%dx)
}
c0100f1b:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f1c:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f23:	40                   	inc    %eax
c0100f24:	0f b7 c0             	movzwl %ax,%eax
c0100f27:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f2f:	89 c2                	mov    %eax,%edx
c0100f31:	ec                   	in     (%dx),%al
c0100f32:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f35:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f39:	0f b6 c0             	movzbl %al,%eax
c0100f3c:	c1 e0 08             	shl    $0x8,%eax
c0100f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f42:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f49:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f51:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f55:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f59:	ee                   	out    %al,(%dx)
}
c0100f5a:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f5b:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f62:	40                   	inc    %eax
c0100f63:	0f b7 c0             	movzwl %ax,%eax
c0100f66:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f6e:	89 c2                	mov    %eax,%edx
c0100f70:	ec                   	in     (%dx),%al
c0100f71:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f74:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f78:	0f b6 c0             	movzbl %al,%eax
c0100f7b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f81:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f89:	0f b7 c0             	movzwl %ax,%eax
c0100f8c:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100f92:	90                   	nop
c0100f93:	89 ec                	mov    %ebp,%esp
c0100f95:	5d                   	pop    %ebp
c0100f96:	c3                   	ret    

c0100f97 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f97:	55                   	push   %ebp
c0100f98:	89 e5                	mov    %esp,%ebp
c0100f9a:	83 ec 48             	sub    $0x48,%esp
c0100f9d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fa3:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fab:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100faf:	ee                   	out    %al,(%dx)
}
c0100fb0:	90                   	nop
c0100fb1:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fb7:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fbb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fbf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fc3:	ee                   	out    %al,(%dx)
}
c0100fc4:	90                   	nop
c0100fc5:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fcb:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fcf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fd3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fd7:	ee                   	out    %al,(%dx)
}
c0100fd8:	90                   	nop
c0100fd9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdf:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100feb:	ee                   	out    %al,(%dx)
}
c0100fec:	90                   	nop
c0100fed:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ff3:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100ffb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fff:	ee                   	out    %al,(%dx)
}
c0101000:	90                   	nop
c0101001:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101007:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010100b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010100f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101013:	ee                   	out    %al,(%dx)
}
c0101014:	90                   	nop
c0101015:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010101b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101023:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101027:	ee                   	out    %al,(%dx)
}
c0101028:	90                   	nop
c0101029:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101033:	89 c2                	mov    %eax,%edx
c0101035:	ec                   	in     (%dx),%al
c0101036:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101039:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010103d:	3c ff                	cmp    $0xff,%al
c010103f:	0f 95 c0             	setne  %al
c0101042:	0f b6 c0             	movzbl %al,%eax
c0101045:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c010104a:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101050:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101054:	89 c2                	mov    %eax,%edx
c0101056:	ec                   	in     (%dx),%al
c0101057:	88 45 f1             	mov    %al,-0xf(%ebp)
c010105a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101060:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101064:	89 c2                	mov    %eax,%edx
c0101066:	ec                   	in     (%dx),%al
c0101067:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010106a:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010106f:	85 c0                	test   %eax,%eax
c0101071:	74 0c                	je     c010107f <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101073:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010107a:	e8 27 07 00 00       	call   c01017a6 <pic_enable>
    }
}
c010107f:	90                   	nop
c0101080:	89 ec                	mov    %ebp,%esp
c0101082:	5d                   	pop    %ebp
c0101083:	c3                   	ret    

c0101084 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101084:	55                   	push   %ebp
c0101085:	89 e5                	mov    %esp,%ebp
c0101087:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101091:	eb 08                	jmp    c010109b <lpt_putc_sub+0x17>
        delay();
c0101093:	e8 cc fd ff ff       	call   c0100e64 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101098:	ff 45 fc             	incl   -0x4(%ebp)
c010109b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010a1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010a5:	89 c2                	mov    %eax,%edx
c01010a7:	ec                   	in     (%dx),%al
c01010a8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010ab:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010af:	84 c0                	test   %al,%al
c01010b1:	78 09                	js     c01010bc <lpt_putc_sub+0x38>
c01010b3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010ba:	7e d7                	jle    c0101093 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bf:	0f b6 c0             	movzbl %al,%eax
c01010c2:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010c8:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010cb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010cf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d3:	ee                   	out    %al,(%dx)
}
c01010d4:	90                   	nop
c01010d5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010db:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010df:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010e7:	ee                   	out    %al,(%dx)
}
c01010e8:	90                   	nop
c01010e9:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010ef:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010f7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010fb:	ee                   	out    %al,(%dx)
}
c01010fc:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010fd:	90                   	nop
c01010fe:	89 ec                	mov    %ebp,%esp
c0101100:	5d                   	pop    %ebp
c0101101:	c3                   	ret    

c0101102 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101108:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010110c:	74 0d                	je     c010111b <lpt_putc+0x19>
        lpt_putc_sub(c);
c010110e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101111:	89 04 24             	mov    %eax,(%esp)
c0101114:	e8 6b ff ff ff       	call   c0101084 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101119:	eb 24                	jmp    c010113f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010111b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101122:	e8 5d ff ff ff       	call   c0101084 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101127:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010112e:	e8 51 ff ff ff       	call   c0101084 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101133:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010113a:	e8 45 ff ff ff       	call   c0101084 <lpt_putc_sub>
}
c010113f:	90                   	nop
c0101140:	89 ec                	mov    %ebp,%esp
c0101142:	5d                   	pop    %ebp
c0101143:	c3                   	ret    

c0101144 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101144:	55                   	push   %ebp
c0101145:	89 e5                	mov    %esp,%ebp
c0101147:	83 ec 38             	sub    $0x38,%esp
c010114a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c010114d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101150:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101155:	85 c0                	test   %eax,%eax
c0101157:	75 07                	jne    c0101160 <cga_putc+0x1c>
        c |= 0x0700;
c0101159:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101160:	8b 45 08             	mov    0x8(%ebp),%eax
c0101163:	0f b6 c0             	movzbl %al,%eax
c0101166:	83 f8 0d             	cmp    $0xd,%eax
c0101169:	74 72                	je     c01011dd <cga_putc+0x99>
c010116b:	83 f8 0d             	cmp    $0xd,%eax
c010116e:	0f 8f a3 00 00 00    	jg     c0101217 <cga_putc+0xd3>
c0101174:	83 f8 08             	cmp    $0x8,%eax
c0101177:	74 0a                	je     c0101183 <cga_putc+0x3f>
c0101179:	83 f8 0a             	cmp    $0xa,%eax
c010117c:	74 4c                	je     c01011ca <cga_putc+0x86>
c010117e:	e9 94 00 00 00       	jmp    c0101217 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c0101183:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010118a:	85 c0                	test   %eax,%eax
c010118c:	0f 84 af 00 00 00    	je     c0101241 <cga_putc+0xfd>
            crt_pos --;
c0101192:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101199:	48                   	dec    %eax
c010119a:	0f b7 c0             	movzwl %ax,%eax
c010119d:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a6:	98                   	cwtl   
c01011a7:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ac:	98                   	cwtl   
c01011ad:	83 c8 20             	or     $0x20,%eax
c01011b0:	98                   	cwtl   
c01011b1:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011b7:	0f b7 15 44 b4 11 c0 	movzwl 0xc011b444,%edx
c01011be:	01 d2                	add    %edx,%edx
c01011c0:	01 ca                	add    %ecx,%edx
c01011c2:	0f b7 c0             	movzwl %ax,%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011c8:	eb 77                	jmp    c0101241 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011ca:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011d1:	83 c0 50             	add    $0x50,%eax
c01011d4:	0f b7 c0             	movzwl %ax,%eax
c01011d7:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011dd:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c01011e4:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c01011eb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011f0:	89 c8                	mov    %ecx,%eax
c01011f2:	f7 e2                	mul    %edx
c01011f4:	c1 ea 06             	shr    $0x6,%edx
c01011f7:	89 d0                	mov    %edx,%eax
c01011f9:	c1 e0 02             	shl    $0x2,%eax
c01011fc:	01 d0                	add    %edx,%eax
c01011fe:	c1 e0 04             	shl    $0x4,%eax
c0101201:	29 c1                	sub    %eax,%ecx
c0101203:	89 ca                	mov    %ecx,%edx
c0101205:	0f b7 d2             	movzwl %dx,%edx
c0101208:	89 d8                	mov    %ebx,%eax
c010120a:	29 d0                	sub    %edx,%eax
c010120c:	0f b7 c0             	movzwl %ax,%eax
c010120f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101215:	eb 2b                	jmp    c0101242 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101217:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010121d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101224:	8d 50 01             	lea    0x1(%eax),%edx
c0101227:	0f b7 d2             	movzwl %dx,%edx
c010122a:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c0101231:	01 c0                	add    %eax,%eax
c0101233:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101236:	8b 45 08             	mov    0x8(%ebp),%eax
c0101239:	0f b7 c0             	movzwl %ax,%eax
c010123c:	66 89 02             	mov    %ax,(%edx)
        break;
c010123f:	eb 01                	jmp    c0101242 <cga_putc+0xfe>
        break;
c0101241:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101242:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101249:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c010124e:	76 5e                	jbe    c01012ae <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101250:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101255:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125b:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101260:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101267:	00 
c0101268:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126c:	89 04 24             	mov    %eax,(%esp)
c010126f:	e8 05 4b 00 00       	call   c0105d79 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101274:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127b:	eb 15                	jmp    c0101292 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c010127d:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c0101283:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101286:	01 c0                	add    %eax,%eax
c0101288:	01 d0                	add    %edx,%eax
c010128a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010128f:	ff 45 f4             	incl   -0xc(%ebp)
c0101292:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101299:	7e e2                	jle    c010127d <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c010129b:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012a2:	83 e8 50             	sub    $0x50,%eax
c01012a5:	0f b7 c0             	movzwl %ax,%eax
c01012a8:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012ae:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012b5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012b9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012bd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c5:	ee                   	out    %al,(%dx)
}
c01012c6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012c7:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012ce:	c1 e8 08             	shr    $0x8,%eax
c01012d1:	0f b7 c0             	movzwl %ax,%eax
c01012d4:	0f b6 c0             	movzbl %al,%eax
c01012d7:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012de:	42                   	inc    %edx
c01012df:	0f b7 d2             	movzwl %dx,%edx
c01012e2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012e6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012e9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ed:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012f1:	ee                   	out    %al,(%dx)
}
c01012f2:	90                   	nop
    outb(addr_6845, 15);
c01012f3:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012fa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012fe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101302:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101306:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130a:	ee                   	out    %al,(%dx)
}
c010130b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010130c:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101313:	0f b6 c0             	movzbl %al,%eax
c0101316:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c010131d:	42                   	inc    %edx
c010131e:	0f b7 d2             	movzwl %dx,%edx
c0101321:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101325:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101328:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010132c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101330:	ee                   	out    %al,(%dx)
}
c0101331:	90                   	nop
}
c0101332:	90                   	nop
c0101333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101336:	89 ec                	mov    %ebp,%esp
c0101338:	5d                   	pop    %ebp
c0101339:	c3                   	ret    

c010133a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010133a:	55                   	push   %ebp
c010133b:	89 e5                	mov    %esp,%ebp
c010133d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101347:	eb 08                	jmp    c0101351 <serial_putc_sub+0x17>
        delay();
c0101349:	e8 16 fb ff ff       	call   c0100e64 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010134e:	ff 45 fc             	incl   -0x4(%ebp)
c0101351:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101357:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010135b:	89 c2                	mov    %eax,%edx
c010135d:	ec                   	in     (%dx),%al
c010135e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101361:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101365:	0f b6 c0             	movzbl %al,%eax
c0101368:	83 e0 20             	and    $0x20,%eax
c010136b:	85 c0                	test   %eax,%eax
c010136d:	75 09                	jne    c0101378 <serial_putc_sub+0x3e>
c010136f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101376:	7e d1                	jle    c0101349 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101378:	8b 45 08             	mov    0x8(%ebp),%eax
c010137b:	0f b6 c0             	movzbl %al,%eax
c010137e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101384:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101387:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010138b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010138f:	ee                   	out    %al,(%dx)
}
c0101390:	90                   	nop
}
c0101391:	90                   	nop
c0101392:	89 ec                	mov    %ebp,%esp
c0101394:	5d                   	pop    %ebp
c0101395:	c3                   	ret    

c0101396 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101396:	55                   	push   %ebp
c0101397:	89 e5                	mov    %esp,%ebp
c0101399:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010139c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a0:	74 0d                	je     c01013af <serial_putc+0x19>
        serial_putc_sub(c);
c01013a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a5:	89 04 24             	mov    %eax,(%esp)
c01013a8:	e8 8d ff ff ff       	call   c010133a <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013ad:	eb 24                	jmp    c01013d3 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013af:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013b6:	e8 7f ff ff ff       	call   c010133a <serial_putc_sub>
        serial_putc_sub(' ');
c01013bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013c2:	e8 73 ff ff ff       	call   c010133a <serial_putc_sub>
        serial_putc_sub('\b');
c01013c7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013ce:	e8 67 ff ff ff       	call   c010133a <serial_putc_sub>
}
c01013d3:	90                   	nop
c01013d4:	89 ec                	mov    %ebp,%esp
c01013d6:	5d                   	pop    %ebp
c01013d7:	c3                   	ret    

c01013d8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013d8:	55                   	push   %ebp
c01013d9:	89 e5                	mov    %esp,%ebp
c01013db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013de:	eb 33                	jmp    c0101413 <cons_intr+0x3b>
        if (c != 0) {
c01013e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e4:	74 2d                	je     c0101413 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013e6:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013eb:	8d 50 01             	lea    0x1(%eax),%edx
c01013ee:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c01013f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f7:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013fd:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101402:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101407:	75 0a                	jne    c0101413 <cons_intr+0x3b>
                cons.wpos = 0;
c0101409:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101410:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101413:	8b 45 08             	mov    0x8(%ebp),%eax
c0101416:	ff d0                	call   *%eax
c0101418:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010141b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010141f:	75 bf                	jne    c01013e0 <cons_intr+0x8>
            }
        }
    }
}
c0101421:	90                   	nop
c0101422:	90                   	nop
c0101423:	89 ec                	mov    %ebp,%esp
c0101425:	5d                   	pop    %ebp
c0101426:	c3                   	ret    

c0101427 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 10             	sub    $0x10,%esp
c010142d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101433:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101437:	89 c2                	mov    %eax,%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010143d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101441:	0f b6 c0             	movzbl %al,%eax
c0101444:	83 e0 01             	and    $0x1,%eax
c0101447:	85 c0                	test   %eax,%eax
c0101449:	75 07                	jne    c0101452 <serial_proc_data+0x2b>
        return -1;
c010144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101450:	eb 2a                	jmp    c010147c <serial_proc_data+0x55>
c0101452:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101458:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010145c:	89 c2                	mov    %eax,%edx
c010145e:	ec                   	in     (%dx),%al
c010145f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101462:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101466:	0f b6 c0             	movzbl %al,%eax
c0101469:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010146c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101470:	75 07                	jne    c0101479 <serial_proc_data+0x52>
        c = '\b';
c0101472:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101479:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010147c:	89 ec                	mov    %ebp,%esp
c010147e:	5d                   	pop    %ebp
c010147f:	c3                   	ret    

c0101480 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101480:	55                   	push   %ebp
c0101481:	89 e5                	mov    %esp,%ebp
c0101483:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101486:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010148b:	85 c0                	test   %eax,%eax
c010148d:	74 0c                	je     c010149b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010148f:	c7 04 24 27 14 10 c0 	movl   $0xc0101427,(%esp)
c0101496:	e8 3d ff ff ff       	call   c01013d8 <cons_intr>
    }
}
c010149b:	90                   	nop
c010149c:	89 ec                	mov    %ebp,%esp
c010149e:	5d                   	pop    %ebp
c010149f:	c3                   	ret    

c01014a0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a0:	55                   	push   %ebp
c01014a1:	89 e5                	mov    %esp,%ebp
c01014a3:	83 ec 38             	sub    $0x38,%esp
c01014a6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	ec                   	in     (%dx),%al
c01014b2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014b9:	0f b6 c0             	movzbl %al,%eax
c01014bc:	83 e0 01             	and    $0x1,%eax
c01014bf:	85 c0                	test   %eax,%eax
c01014c1:	75 0a                	jne    c01014cd <kbd_proc_data+0x2d>
        return -1;
c01014c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014c8:	e9 56 01 00 00       	jmp    c0101623 <kbd_proc_data+0x183>
c01014cd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014d6:	89 c2                	mov    %eax,%edx
c01014d8:	ec                   	in     (%dx),%al
c01014d9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014dc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014e3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014e7:	75 17                	jne    c0101500 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014e9:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014ee:	83 c8 40             	or     $0x40,%eax
c01014f1:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014fb:	e9 23 01 00 00       	jmp    c0101623 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101500:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101504:	84 c0                	test   %al,%al
c0101506:	79 45                	jns    c010154d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101508:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010150d:	83 e0 40             	and    $0x40,%eax
c0101510:	85 c0                	test   %eax,%eax
c0101512:	75 08                	jne    c010151c <kbd_proc_data+0x7c>
c0101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101518:	24 7f                	and    $0x7f,%al
c010151a:	eb 04                	jmp    c0101520 <kbd_proc_data+0x80>
c010151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101520:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101523:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101527:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c010152e:	0c 40                	or     $0x40,%al
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	f7 d0                	not    %eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010153c:	21 d0                	and    %edx,%eax
c010153e:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101543:	b8 00 00 00 00       	mov    $0x0,%eax
c0101548:	e9 d6 00 00 00       	jmp    c0101623 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c010154d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101552:	83 e0 40             	and    $0x40,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 11                	je     c010156a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101559:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010155d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101562:	83 e0 bf             	and    $0xffffffbf,%eax
c0101565:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c010156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156e:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101575:	0f b6 d0             	movzbl %al,%edx
c0101578:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010157d:	09 d0                	or     %edx,%eax
c010157f:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101588:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c010158f:	0f b6 d0             	movzbl %al,%edx
c0101592:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101597:	31 d0                	xor    %edx,%eax
c0101599:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c010159e:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015a3:	83 e0 03             	and    $0x3,%eax
c01015a6:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01015ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b1:	01 d0                	add    %edx,%eax
c01015b3:	0f b6 00             	movzbl (%eax),%eax
c01015b6:	0f b6 c0             	movzbl %al,%eax
c01015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015bc:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015c1:	83 e0 08             	and    $0x8,%eax
c01015c4:	85 c0                	test   %eax,%eax
c01015c6:	74 22                	je     c01015ea <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015c8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015cc:	7e 0c                	jle    c01015da <kbd_proc_data+0x13a>
c01015ce:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015d2:	7f 06                	jg     c01015da <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015d4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015d8:	eb 10                	jmp    c01015ea <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015da:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015de:	7e 0a                	jle    c01015ea <kbd_proc_data+0x14a>
c01015e0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015e4:	7f 04                	jg     c01015ea <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015e6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015ea:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015ef:	f7 d0                	not    %eax
c01015f1:	83 e0 06             	and    $0x6,%eax
c01015f4:	85 c0                	test   %eax,%eax
c01015f6:	75 28                	jne    c0101620 <kbd_proc_data+0x180>
c01015f8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015ff:	75 1f                	jne    c0101620 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101601:	c7 04 24 23 62 10 c0 	movl   $0xc0106223,(%esp)
c0101608:	e8 49 ed ff ff       	call   c0100356 <cprintf>
c010160d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101613:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101617:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010161b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010161e:	ee                   	out    %al,(%dx)
}
c010161f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101620:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101623:	89 ec                	mov    %ebp,%esp
c0101625:	5d                   	pop    %ebp
c0101626:	c3                   	ret    

c0101627 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101627:	55                   	push   %ebp
c0101628:	89 e5                	mov    %esp,%ebp
c010162a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010162d:	c7 04 24 a0 14 10 c0 	movl   $0xc01014a0,(%esp)
c0101634:	e8 9f fd ff ff       	call   c01013d8 <cons_intr>
}
c0101639:	90                   	nop
c010163a:	89 ec                	mov    %ebp,%esp
c010163c:	5d                   	pop    %ebp
c010163d:	c3                   	ret    

c010163e <kbd_init>:

static void
kbd_init(void) {
c010163e:	55                   	push   %ebp
c010163f:	89 e5                	mov    %esp,%ebp
c0101641:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101644:	e8 de ff ff ff       	call   c0101627 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101649:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101650:	e8 51 01 00 00       	call   c01017a6 <pic_enable>
}
c0101655:	90                   	nop
c0101656:	89 ec                	mov    %ebp,%esp
c0101658:	5d                   	pop    %ebp
c0101659:	c3                   	ret    

c010165a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010165a:	55                   	push   %ebp
c010165b:	89 e5                	mov    %esp,%ebp
c010165d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101660:	e8 4a f8 ff ff       	call   c0100eaf <cga_init>
    serial_init();
c0101665:	e8 2d f9 ff ff       	call   c0100f97 <serial_init>
    kbd_init();
c010166a:	e8 cf ff ff ff       	call   c010163e <kbd_init>
    if (!serial_exists) {
c010166f:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101674:	85 c0                	test   %eax,%eax
c0101676:	75 0c                	jne    c0101684 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101678:	c7 04 24 2f 62 10 c0 	movl   $0xc010622f,(%esp)
c010167f:	e8 d2 ec ff ff       	call   c0100356 <cprintf>
    }
}
c0101684:	90                   	nop
c0101685:	89 ec                	mov    %ebp,%esp
c0101687:	5d                   	pop    %ebp
c0101688:	c3                   	ret    

c0101689 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101689:	55                   	push   %ebp
c010168a:	89 e5                	mov    %esp,%ebp
c010168c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010168f:	e8 8e f7 ff ff       	call   c0100e22 <__intr_save>
c0101694:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101697:	8b 45 08             	mov    0x8(%ebp),%eax
c010169a:	89 04 24             	mov    %eax,(%esp)
c010169d:	e8 60 fa ff ff       	call   c0101102 <lpt_putc>
        cga_putc(c);
c01016a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a5:	89 04 24             	mov    %eax,(%esp)
c01016a8:	e8 97 fa ff ff       	call   c0101144 <cga_putc>
        serial_putc(c);
c01016ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b0:	89 04 24             	mov    %eax,(%esp)
c01016b3:	e8 de fc ff ff       	call   c0101396 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016bb:	89 04 24             	mov    %eax,(%esp)
c01016be:	e8 8b f7 ff ff       	call   c0100e4e <__intr_restore>
}
c01016c3:	90                   	nop
c01016c4:	89 ec                	mov    %ebp,%esp
c01016c6:	5d                   	pop    %ebp
c01016c7:	c3                   	ret    

c01016c8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016c8:	55                   	push   %ebp
c01016c9:	89 e5                	mov    %esp,%ebp
c01016cb:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016d5:	e8 48 f7 ff ff       	call   c0100e22 <__intr_save>
c01016da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016dd:	e8 9e fd ff ff       	call   c0101480 <serial_intr>
        kbd_intr();
c01016e2:	e8 40 ff ff ff       	call   c0101627 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016e7:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c01016ed:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01016f2:	39 c2                	cmp    %eax,%edx
c01016f4:	74 31                	je     c0101727 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016f6:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016fb:	8d 50 01             	lea    0x1(%eax),%edx
c01016fe:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101704:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010170b:	0f b6 c0             	movzbl %al,%eax
c010170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101711:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101716:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171b:	75 0a                	jne    c0101727 <cons_getc+0x5f>
                cons.rpos = 0;
c010171d:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c0101724:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101727:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010172a:	89 04 24             	mov    %eax,(%esp)
c010172d:	e8 1c f7 ff ff       	call   c0100e4e <__intr_restore>
    return c;
c0101732:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101735:	89 ec                	mov    %ebp,%esp
c0101737:	5d                   	pop    %ebp
c0101738:	c3                   	ret    

c0101739 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101739:	55                   	push   %ebp
c010173a:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010173c:	fb                   	sti    
}
c010173d:	90                   	nop
    sti();
}
c010173e:	90                   	nop
c010173f:	5d                   	pop    %ebp
c0101740:	c3                   	ret    

c0101741 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101741:	55                   	push   %ebp
c0101742:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101744:	fa                   	cli    
}
c0101745:	90                   	nop
    cli();
}
c0101746:	90                   	nop
c0101747:	5d                   	pop    %ebp
c0101748:	c3                   	ret    

c0101749 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101749:	55                   	push   %ebp
c010174a:	89 e5                	mov    %esp,%ebp
c010174c:	83 ec 14             	sub    $0x14,%esp
c010174f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101752:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101756:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101759:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c010175f:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c0101764:	85 c0                	test   %eax,%eax
c0101766:	74 39                	je     c01017a1 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101768:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010176b:	0f b6 c0             	movzbl %al,%eax
c010176e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101774:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101777:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010177b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010177f:	ee                   	out    %al,(%dx)
}
c0101780:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101781:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101785:	c1 e8 08             	shr    $0x8,%eax
c0101788:	0f b7 c0             	movzwl %ax,%eax
c010178b:	0f b6 c0             	movzbl %al,%eax
c010178e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101794:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101797:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010179b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010179f:	ee                   	out    %al,(%dx)
}
c01017a0:	90                   	nop
    }
}
c01017a1:	90                   	nop
c01017a2:	89 ec                	mov    %ebp,%esp
c01017a4:	5d                   	pop    %ebp
c01017a5:	c3                   	ret    

c01017a6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017a6:	55                   	push   %ebp
c01017a7:	89 e5                	mov    %esp,%ebp
c01017a9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01017af:	ba 01 00 00 00       	mov    $0x1,%edx
c01017b4:	88 c1                	mov    %al,%cl
c01017b6:	d3 e2                	shl    %cl,%edx
c01017b8:	89 d0                	mov    %edx,%eax
c01017ba:	98                   	cwtl   
c01017bb:	f7 d0                	not    %eax
c01017bd:	0f bf d0             	movswl %ax,%edx
c01017c0:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01017c7:	98                   	cwtl   
c01017c8:	21 d0                	and    %edx,%eax
c01017ca:	98                   	cwtl   
c01017cb:	0f b7 c0             	movzwl %ax,%eax
c01017ce:	89 04 24             	mov    %eax,(%esp)
c01017d1:	e8 73 ff ff ff       	call   c0101749 <pic_setmask>
}
c01017d6:	90                   	nop
c01017d7:	89 ec                	mov    %ebp,%esp
c01017d9:	5d                   	pop    %ebp
c01017da:	c3                   	ret    

c01017db <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017db:	55                   	push   %ebp
c01017dc:	89 e5                	mov    %esp,%ebp
c01017de:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017e1:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c01017e8:	00 00 00 
c01017eb:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017f1:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f5:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f9:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
}
c01017fe:	90                   	nop
c01017ff:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101805:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101809:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010180d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101811:	ee                   	out    %al,(%dx)
}
c0101812:	90                   	nop
c0101813:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101819:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010181d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101821:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101825:	ee                   	out    %al,(%dx)
}
c0101826:	90                   	nop
c0101827:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010182d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101831:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101835:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101839:	ee                   	out    %al,(%dx)
}
c010183a:	90                   	nop
c010183b:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101841:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101845:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101849:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010184d:	ee                   	out    %al,(%dx)
}
c010184e:	90                   	nop
c010184f:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101855:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101859:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010185d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101861:	ee                   	out    %al,(%dx)
}
c0101862:	90                   	nop
c0101863:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101869:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101871:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101875:	ee                   	out    %al,(%dx)
}
c0101876:	90                   	nop
c0101877:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c010187d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101881:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101885:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101889:	ee                   	out    %al,(%dx)
}
c010188a:	90                   	nop
c010188b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101891:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101895:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101899:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010189d:	ee                   	out    %al,(%dx)
}
c010189e:	90                   	nop
c010189f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018a5:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018ad:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018b1:	ee                   	out    %al,(%dx)
}
c01018b2:	90                   	nop
c01018b3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018b9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018bd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018c1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018c5:	ee                   	out    %al,(%dx)
}
c01018c6:	90                   	nop
c01018c7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018cd:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018d5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018d9:	ee                   	out    %al,(%dx)
}
c01018da:	90                   	nop
c01018db:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018e1:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018e9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018ed:	ee                   	out    %al,(%dx)
}
c01018ee:	90                   	nop
c01018ef:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018f5:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01018fd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101901:	ee                   	out    %al,(%dx)
}
c0101902:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101903:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c010190a:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010190f:	74 0f                	je     c0101920 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101911:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101918:	89 04 24             	mov    %eax,(%esp)
c010191b:	e8 29 fe ff ff       	call   c0101749 <pic_setmask>
    }
}
c0101920:	90                   	nop
c0101921:	89 ec                	mov    %ebp,%esp
c0101923:	5d                   	pop    %ebp
c0101924:	c3                   	ret    

c0101925 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101925:	55                   	push   %ebp
c0101926:	89 e5                	mov    %esp,%ebp
c0101928:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010192b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101932:	00 
c0101933:	c7 04 24 60 62 10 c0 	movl   $0xc0106260,(%esp)
c010193a:	e8 17 ea ff ff       	call   c0100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010193f:	90                   	nop
c0101940:	89 ec                	mov    %ebp,%esp
c0101942:	5d                   	pop    %ebp
c0101943:	c3                   	ret    

c0101944 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101944:	55                   	push   %ebp
c0101945:	89 e5                	mov    %esp,%ebp
c0101947:	83 ec 28             	sub    $0x28,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */

    extern uintptr_t __vectors[];

    uintptr_t a = __vectors;
c010194a:	c7 45 f0 e0 85 11 c0 	movl   $0xc01185e0,-0x10(%ebp)

    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
c0101951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101958:	e9 c4 00 00 00       	jmp    c0101a21 <idt_init+0xdd>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL)
c010195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101960:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101967:	0f b7 d0             	movzwl %ax,%edx
c010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010196d:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c0101974:	c0 
c0101975:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101978:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c010197f:	c0 08 00 
c0101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101985:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c010198c:	c0 
c010198d:	80 e2 e0             	and    $0xe0,%dl
c0101990:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c0101997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010199a:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019a1:	c0 
c01019a2:	80 e2 1f             	and    $0x1f,%dl
c01019a5:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019af:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019b6:	c0 
c01019b7:	80 e2 f0             	and    $0xf0,%dl
c01019ba:	80 ca 0e             	or     $0xe,%dl
c01019bd:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019c7:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019ce:	c0 
c01019cf:	80 e2 ef             	and    $0xef,%dl
c01019d2:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019dc:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019e3:	c0 
c01019e4:	80 e2 9f             	and    $0x9f,%dl
c01019e7:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f1:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019f8:	c0 
c01019f9:	80 ca 80             	or     $0x80,%dl
c01019fc:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a06:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101a0d:	c1 e8 10             	shr    $0x10,%eax
c0101a10:	0f b7 d0             	movzwl %ax,%edx
c0101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a16:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c0101a1d:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
c0101a1e:	ff 45 f4             	incl   -0xc(%ebp)
c0101a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a24:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a29:	0f 86 2e ff ff ff    	jbe    c010195d <idt_init+0x19>
c0101a2f:	c7 45 ec 60 85 11 c0 	movl   $0xc0118560,-0x14(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a39:	0f 01 18             	lidtl  (%eax)
}
c0101a3c:	90                   	nop
    }

    lidt(&idt_pd);

    cprintf("test");
c0101a3d:	c7 04 24 6a 62 10 c0 	movl   $0xc010626a,(%esp)
c0101a44:	e8 0d e9 ff ff       	call   c0100356 <cprintf>
}
c0101a49:	90                   	nop
c0101a4a:	89 ec                	mov    %ebp,%esp
c0101a4c:	5d                   	pop    %ebp
c0101a4d:	c3                   	ret    

c0101a4e <trapname>:

static const char *
trapname(int trapno) {
c0101a4e:	55                   	push   %ebp
c0101a4f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a54:	83 f8 13             	cmp    $0x13,%eax
c0101a57:	77 0c                	ja     c0101a65 <trapname+0x17>
        return excnames[trapno];
c0101a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5c:	8b 04 85 c0 65 10 c0 	mov    -0x3fef9a40(,%eax,4),%eax
c0101a63:	eb 18                	jmp    c0101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a69:	7e 0d                	jle    c0101a78 <trapname+0x2a>
c0101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6f:	7f 07                	jg     c0101a78 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a71:	b8 6f 62 10 c0       	mov    $0xc010626f,%eax
c0101a76:	eb 05                	jmp    c0101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a78:	b8 82 62 10 c0       	mov    $0xc0106282,%eax
}
c0101a7d:	5d                   	pop    %ebp
c0101a7e:	c3                   	ret    

c0101a7f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a7f:	55                   	push   %ebp
c0101a80:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a89:	83 f8 08             	cmp    $0x8,%eax
c0101a8c:	0f 94 c0             	sete   %al
c0101a8f:	0f b6 c0             	movzbl %al,%eax
}
c0101a92:	5d                   	pop    %ebp
c0101a93:	c3                   	ret    

c0101a94 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a94:	55                   	push   %ebp
c0101a95:	89 e5                	mov    %esp,%ebp
c0101a97:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa1:	c7 04 24 c3 62 10 c0 	movl   $0xc01062c3,(%esp)
c0101aa8:	e8 a9 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	89 04 24             	mov    %eax,(%esp)
c0101ab3:	e8 8f 01 00 00       	call   c0101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 d4 62 10 c0 	movl   $0xc01062d4,(%esp)
c0101aca:	e8 87 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ada:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0101ae1:	e8 70 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af1:	c7 04 24 fa 62 10 c0 	movl   $0xc01062fa,(%esp)
c0101af8:	e8 59 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b08:	c7 04 24 0d 63 10 c0 	movl   $0xc010630d,(%esp)
c0101b0f:	e8 42 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b17:	8b 40 30             	mov    0x30(%eax),%eax
c0101b1a:	89 04 24             	mov    %eax,(%esp)
c0101b1d:	e8 2c ff ff ff       	call   c0101a4e <trapname>
c0101b22:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b25:	8b 52 30             	mov    0x30(%edx),%edx
c0101b28:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b2c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b30:	c7 04 24 20 63 10 c0 	movl   $0xc0106320,(%esp)
c0101b37:	e8 1a e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	8b 40 34             	mov    0x34(%eax),%eax
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 32 63 10 c0 	movl   $0xc0106332,(%esp)
c0101b4d:	e8 04 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	8b 40 38             	mov    0x38(%eax),%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 41 63 10 c0 	movl   $0xc0106341,(%esp)
c0101b63:	e8 ee e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b73:	c7 04 24 50 63 10 c0 	movl   $0xc0106350,(%esp)
c0101b7a:	e8 d7 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b82:	8b 40 40             	mov    0x40(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 63 63 10 c0 	movl   $0xc0106363,(%esp)
c0101b90:	e8 c1 e7 ff ff       	call   c0100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b9c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ba3:	eb 3d                	jmp    c0101be2 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	8b 50 40             	mov    0x40(%eax),%edx
c0101bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bae:	21 d0                	and    %edx,%eax
c0101bb0:	85 c0                	test   %eax,%eax
c0101bb2:	74 28                	je     c0101bdc <print_trapframe+0x148>
c0101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb7:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101bbe:	85 c0                	test   %eax,%eax
c0101bc0:	74 1a                	je     c0101bdc <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc5:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd0:	c7 04 24 72 63 10 c0 	movl   $0xc0106372,(%esp)
c0101bd7:	e8 7a e7 ff ff       	call   c0100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bdc:	ff 45 f4             	incl   -0xc(%ebp)
c0101bdf:	d1 65 f0             	shll   -0x10(%ebp)
c0101be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be5:	83 f8 17             	cmp    $0x17,%eax
c0101be8:	76 bb                	jbe    c0101ba5 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bed:	8b 40 40             	mov    0x40(%eax),%eax
c0101bf0:	c1 e8 0c             	shr    $0xc,%eax
c0101bf3:	83 e0 03             	and    $0x3,%eax
c0101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfa:	c7 04 24 76 63 10 c0 	movl   $0xc0106376,(%esp)
c0101c01:	e8 50 e7 ff ff       	call   c0100356 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c09:	89 04 24             	mov    %eax,(%esp)
c0101c0c:	e8 6e fe ff ff       	call   c0101a7f <trap_in_kernel>
c0101c11:	85 c0                	test   %eax,%eax
c0101c13:	75 2d                	jne    c0101c42 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c18:	8b 40 44             	mov    0x44(%eax),%eax
c0101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1f:	c7 04 24 7f 63 10 c0 	movl   $0xc010637f,(%esp)
c0101c26:	e8 2b e7 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c36:	c7 04 24 8e 63 10 c0 	movl   $0xc010638e,(%esp)
c0101c3d:	e8 14 e7 ff ff       	call   c0100356 <cprintf>
    }
}
c0101c42:	90                   	nop
c0101c43:	89 ec                	mov    %ebp,%esp
c0101c45:	5d                   	pop    %ebp
c0101c46:	c3                   	ret    

c0101c47 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c47:	55                   	push   %ebp
c0101c48:	89 e5                	mov    %esp,%ebp
c0101c4a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c50:	8b 00                	mov    (%eax),%eax
c0101c52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c56:	c7 04 24 a1 63 10 c0 	movl   $0xc01063a1,(%esp)
c0101c5d:	e8 f4 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c65:	8b 40 04             	mov    0x4(%eax),%eax
c0101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6c:	c7 04 24 b0 63 10 c0 	movl   $0xc01063b0,(%esp)
c0101c73:	e8 de e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c82:	c7 04 24 bf 63 10 c0 	movl   $0xc01063bf,(%esp)
c0101c89:	e8 c8 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c98:	c7 04 24 ce 63 10 c0 	movl   $0xc01063ce,(%esp)
c0101c9f:	e8 b2 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 10             	mov    0x10(%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 dd 63 10 c0 	movl   $0xc01063dd,(%esp)
c0101cb5:	e8 9c e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 ec 63 10 c0 	movl   $0xc01063ec,(%esp)
c0101ccb:	e8 86 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 18             	mov    0x18(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 fb 63 10 c0 	movl   $0xc01063fb,(%esp)
c0101ce1:	e8 70 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 0a 64 10 c0 	movl   $0xc010640a,(%esp)
c0101cf7:	e8 5a e6 ff ff       	call   c0100356 <cprintf>
}
c0101cfc:	90                   	nop
c0101cfd:	89 ec                	mov    %ebp,%esp
c0101cff:	5d                   	pop    %ebp
c0101d00:	c3                   	ret    

c0101d01 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d01:	55                   	push   %ebp
c0101d02:	89 e5                	mov    %esp,%ebp
c0101d04:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0a:	8b 40 30             	mov    0x30(%eax),%eax
c0101d0d:	83 f8 79             	cmp    $0x79,%eax
c0101d10:	0f 87 e6 00 00 00    	ja     c0101dfc <trap_dispatch+0xfb>
c0101d16:	83 f8 78             	cmp    $0x78,%eax
c0101d19:	0f 83 c1 00 00 00    	jae    c0101de0 <trap_dispatch+0xdf>
c0101d1f:	83 f8 2f             	cmp    $0x2f,%eax
c0101d22:	0f 87 d4 00 00 00    	ja     c0101dfc <trap_dispatch+0xfb>
c0101d28:	83 f8 2e             	cmp    $0x2e,%eax
c0101d2b:	0f 83 00 01 00 00    	jae    c0101e31 <trap_dispatch+0x130>
c0101d31:	83 f8 24             	cmp    $0x24,%eax
c0101d34:	74 5e                	je     c0101d94 <trap_dispatch+0x93>
c0101d36:	83 f8 24             	cmp    $0x24,%eax
c0101d39:	0f 87 bd 00 00 00    	ja     c0101dfc <trap_dispatch+0xfb>
c0101d3f:	83 f8 20             	cmp    $0x20,%eax
c0101d42:	74 0a                	je     c0101d4e <trap_dispatch+0x4d>
c0101d44:	83 f8 21             	cmp    $0x21,%eax
c0101d47:	74 71                	je     c0101dba <trap_dispatch+0xb9>
c0101d49:	e9 ae 00 00 00       	jmp    c0101dfc <trap_dispatch+0xfb>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

        extern volatile size_t ticks;
            ticks++;
c0101d4e:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101d53:	40                   	inc    %eax
c0101d54:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
            if (ticks % TICK_NUM == 0){
c0101d59:	8b 0d 24 b4 11 c0    	mov    0xc011b424,%ecx
c0101d5f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d64:	89 c8                	mov    %ecx,%eax
c0101d66:	f7 e2                	mul    %edx
c0101d68:	c1 ea 05             	shr    $0x5,%edx
c0101d6b:	89 d0                	mov    %edx,%eax
c0101d6d:	c1 e0 02             	shl    $0x2,%eax
c0101d70:	01 d0                	add    %edx,%eax
c0101d72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d79:	01 d0                	add    %edx,%eax
c0101d7b:	c1 e0 02             	shl    $0x2,%eax
c0101d7e:	29 c1                	sub    %eax,%ecx
c0101d80:	89 ca                	mov    %ecx,%edx
c0101d82:	85 d2                	test   %edx,%edx
c0101d84:	0f 85 aa 00 00 00    	jne    c0101e34 <trap_dispatch+0x133>
                print_ticks();
c0101d8a:	e8 96 fb ff ff       	call   c0101925 <print_ticks>
            }


            break;
c0101d8f:	e9 a0 00 00 00       	jmp    c0101e34 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d94:	e8 2f f9 ff ff       	call   c01016c8 <cons_getc>
c0101d99:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d9c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dac:	c7 04 24 19 64 10 c0 	movl   $0xc0106419,(%esp)
c0101db3:	e8 9e e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101db8:	eb 7b                	jmp    c0101e35 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dba:	e8 09 f9 ff ff       	call   c01016c8 <cons_getc>
c0101dbf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dc2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dc6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dca:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd2:	c7 04 24 2b 64 10 c0 	movl   $0xc010642b,(%esp)
c0101dd9:	e8 78 e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101dde:	eb 55                	jmp    c0101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de0:	c7 44 24 08 3a 64 10 	movl   $0xc010643a,0x8(%esp)
c0101de7:	c0 
c0101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101def:	00 
c0101df0:	c7 04 24 4a 64 10 c0 	movl   $0xc010644a,(%esp)
c0101df7:	e8 ec ee ff ff       	call   c0100ce8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e03:	83 e0 03             	and    $0x3,%eax
c0101e06:	85 c0                	test   %eax,%eax
c0101e08:	75 2b                	jne    c0101e35 <trap_dispatch+0x134>
            print_trapframe(tf);
c0101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0d:	89 04 24             	mov    %eax,(%esp)
c0101e10:	e8 7f fc ff ff       	call   c0101a94 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e15:	c7 44 24 08 5b 64 10 	movl   $0xc010645b,0x8(%esp)
c0101e1c:	c0 
c0101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0101e24:	00 
c0101e25:	c7 04 24 4a 64 10 c0 	movl   $0xc010644a,(%esp)
c0101e2c:	e8 b7 ee ff ff       	call   c0100ce8 <__panic>
        break;
c0101e31:	90                   	nop
c0101e32:	eb 01                	jmp    c0101e35 <trap_dispatch+0x134>
            break;
c0101e34:	90                   	nop
        }
    }
}
c0101e35:	90                   	nop
c0101e36:	89 ec                	mov    %ebp,%esp
c0101e38:	5d                   	pop    %ebp
c0101e39:	c3                   	ret    

c0101e3a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e3a:	55                   	push   %ebp
c0101e3b:	89 e5                	mov    %esp,%ebp
c0101e3d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	89 04 24             	mov    %eax,(%esp)
c0101e46:	e8 b6 fe ff ff       	call   c0101d01 <trap_dispatch>
}
c0101e4b:	90                   	nop
c0101e4c:	89 ec                	mov    %ebp,%esp
c0101e4e:	5d                   	pop    %ebp
c0101e4f:	c3                   	ret    

c0101e50 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e50:	1e                   	push   %ds
    pushl %es
c0101e51:	06                   	push   %es
    pushl %fs
c0101e52:	0f a0                	push   %fs
    pushl %gs
c0101e54:	0f a8                	push   %gs
    pushal
c0101e56:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e57:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e5c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e5e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e60:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e61:	e8 d4 ff ff ff       	call   c0101e3a <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e66:	5c                   	pop    %esp

c0101e67 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e67:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e68:	0f a9                	pop    %gs
    popl %fs
c0101e6a:	0f a1                	pop    %fs
    popl %es
c0101e6c:	07                   	pop    %es
    popl %ds
c0101e6d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e6e:	83 c4 08             	add    $0x8,%esp
    iret
c0101e71:	cf                   	iret   

c0101e72 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e72:	6a 00                	push   $0x0
  pushl $0
c0101e74:	6a 00                	push   $0x0
  jmp __alltraps
c0101e76:	e9 d5 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101e7b <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e7b:	6a 00                	push   $0x0
  pushl $1
c0101e7d:	6a 01                	push   $0x1
  jmp __alltraps
c0101e7f:	e9 cc ff ff ff       	jmp    c0101e50 <__alltraps>

c0101e84 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e84:	6a 00                	push   $0x0
  pushl $2
c0101e86:	6a 02                	push   $0x2
  jmp __alltraps
c0101e88:	e9 c3 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101e8d <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $3
c0101e8f:	6a 03                	push   $0x3
  jmp __alltraps
c0101e91:	e9 ba ff ff ff       	jmp    c0101e50 <__alltraps>

c0101e96 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $4
c0101e98:	6a 04                	push   $0x4
  jmp __alltraps
c0101e9a:	e9 b1 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101e9f <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e9f:	6a 00                	push   $0x0
  pushl $5
c0101ea1:	6a 05                	push   $0x5
  jmp __alltraps
c0101ea3:	e9 a8 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ea8 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $6
c0101eaa:	6a 06                	push   $0x6
  jmp __alltraps
c0101eac:	e9 9f ff ff ff       	jmp    c0101e50 <__alltraps>

c0101eb1 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $7
c0101eb3:	6a 07                	push   $0x7
  jmp __alltraps
c0101eb5:	e9 96 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101eba <vector8>:
.globl vector8
vector8:
  pushl $8
c0101eba:	6a 08                	push   $0x8
  jmp __alltraps
c0101ebc:	e9 8f ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ec1 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101ec1:	6a 00                	push   $0x0
  pushl $9
c0101ec3:	6a 09                	push   $0x9
  jmp __alltraps
c0101ec5:	e9 86 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101eca <vector10>:
.globl vector10
vector10:
  pushl $10
c0101eca:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ecc:	e9 7f ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ed1 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ed1:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ed3:	e9 78 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ed8 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ed8:	6a 0c                	push   $0xc
  jmp __alltraps
c0101eda:	e9 71 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101edf <vector13>:
.globl vector13
vector13:
  pushl $13
c0101edf:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ee1:	e9 6a ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ee6 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ee6:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ee8:	e9 63 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101eed <vector15>:
.globl vector15
vector15:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $15
c0101eef:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ef1:	e9 5a ff ff ff       	jmp    c0101e50 <__alltraps>

c0101ef6 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $16
c0101ef8:	6a 10                	push   $0x10
  jmp __alltraps
c0101efa:	e9 51 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101eff <vector17>:
.globl vector17
vector17:
  pushl $17
c0101eff:	6a 11                	push   $0x11
  jmp __alltraps
c0101f01:	e9 4a ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f06 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $18
c0101f08:	6a 12                	push   $0x12
  jmp __alltraps
c0101f0a:	e9 41 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f0f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f0f:	6a 00                	push   $0x0
  pushl $19
c0101f11:	6a 13                	push   $0x13
  jmp __alltraps
c0101f13:	e9 38 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f18 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f18:	6a 00                	push   $0x0
  pushl $20
c0101f1a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f1c:	e9 2f ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f21 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f21:	6a 00                	push   $0x0
  pushl $21
c0101f23:	6a 15                	push   $0x15
  jmp __alltraps
c0101f25:	e9 26 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f2a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $22
c0101f2c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f2e:	e9 1d ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f33 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f33:	6a 00                	push   $0x0
  pushl $23
c0101f35:	6a 17                	push   $0x17
  jmp __alltraps
c0101f37:	e9 14 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f3c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f3c:	6a 00                	push   $0x0
  pushl $24
c0101f3e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f40:	e9 0b ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f45 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f45:	6a 00                	push   $0x0
  pushl $25
c0101f47:	6a 19                	push   $0x19
  jmp __alltraps
c0101f49:	e9 02 ff ff ff       	jmp    c0101e50 <__alltraps>

c0101f4e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f4e:	6a 00                	push   $0x0
  pushl $26
c0101f50:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f52:	e9 f9 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f57 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f57:	6a 00                	push   $0x0
  pushl $27
c0101f59:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f5b:	e9 f0 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f60 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f60:	6a 00                	push   $0x0
  pushl $28
c0101f62:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f64:	e9 e7 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f69 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f69:	6a 00                	push   $0x0
  pushl $29
c0101f6b:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f6d:	e9 de fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f72 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f72:	6a 00                	push   $0x0
  pushl $30
c0101f74:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f76:	e9 d5 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f7b <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f7b:	6a 00                	push   $0x0
  pushl $31
c0101f7d:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f7f:	e9 cc fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f84 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f84:	6a 00                	push   $0x0
  pushl $32
c0101f86:	6a 20                	push   $0x20
  jmp __alltraps
c0101f88:	e9 c3 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f8d <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f8d:	6a 00                	push   $0x0
  pushl $33
c0101f8f:	6a 21                	push   $0x21
  jmp __alltraps
c0101f91:	e9 ba fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f96 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f96:	6a 00                	push   $0x0
  pushl $34
c0101f98:	6a 22                	push   $0x22
  jmp __alltraps
c0101f9a:	e9 b1 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101f9f <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  pushl $35
c0101fa1:	6a 23                	push   $0x23
  jmp __alltraps
c0101fa3:	e9 a8 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fa8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fa8:	6a 00                	push   $0x0
  pushl $36
c0101faa:	6a 24                	push   $0x24
  jmp __alltraps
c0101fac:	e9 9f fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fb1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fb1:	6a 00                	push   $0x0
  pushl $37
c0101fb3:	6a 25                	push   $0x25
  jmp __alltraps
c0101fb5:	e9 96 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fba <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fba:	6a 00                	push   $0x0
  pushl $38
c0101fbc:	6a 26                	push   $0x26
  jmp __alltraps
c0101fbe:	e9 8d fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fc3 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  pushl $39
c0101fc5:	6a 27                	push   $0x27
  jmp __alltraps
c0101fc7:	e9 84 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fcc <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fcc:	6a 00                	push   $0x0
  pushl $40
c0101fce:	6a 28                	push   $0x28
  jmp __alltraps
c0101fd0:	e9 7b fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fd5 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fd5:	6a 00                	push   $0x0
  pushl $41
c0101fd7:	6a 29                	push   $0x29
  jmp __alltraps
c0101fd9:	e9 72 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fde <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $42
c0101fe0:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fe2:	e9 69 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101fe7 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $43
c0101fe9:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101feb:	e9 60 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101ff0 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $44
c0101ff2:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101ff4:	e9 57 fe ff ff       	jmp    c0101e50 <__alltraps>

c0101ff9 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $45
c0101ffb:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101ffd:	e9 4e fe ff ff       	jmp    c0101e50 <__alltraps>

c0102002 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $46
c0102004:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102006:	e9 45 fe ff ff       	jmp    c0101e50 <__alltraps>

c010200b <vector47>:
.globl vector47
vector47:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $47
c010200d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010200f:	e9 3c fe ff ff       	jmp    c0101e50 <__alltraps>

c0102014 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $48
c0102016:	6a 30                	push   $0x30
  jmp __alltraps
c0102018:	e9 33 fe ff ff       	jmp    c0101e50 <__alltraps>

c010201d <vector49>:
.globl vector49
vector49:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $49
c010201f:	6a 31                	push   $0x31
  jmp __alltraps
c0102021:	e9 2a fe ff ff       	jmp    c0101e50 <__alltraps>

c0102026 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102026:	6a 00                	push   $0x0
  pushl $50
c0102028:	6a 32                	push   $0x32
  jmp __alltraps
c010202a:	e9 21 fe ff ff       	jmp    c0101e50 <__alltraps>

c010202f <vector51>:
.globl vector51
vector51:
  pushl $0
c010202f:	6a 00                	push   $0x0
  pushl $51
c0102031:	6a 33                	push   $0x33
  jmp __alltraps
c0102033:	e9 18 fe ff ff       	jmp    c0101e50 <__alltraps>

c0102038 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102038:	6a 00                	push   $0x0
  pushl $52
c010203a:	6a 34                	push   $0x34
  jmp __alltraps
c010203c:	e9 0f fe ff ff       	jmp    c0101e50 <__alltraps>

c0102041 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102041:	6a 00                	push   $0x0
  pushl $53
c0102043:	6a 35                	push   $0x35
  jmp __alltraps
c0102045:	e9 06 fe ff ff       	jmp    c0101e50 <__alltraps>

c010204a <vector54>:
.globl vector54
vector54:
  pushl $0
c010204a:	6a 00                	push   $0x0
  pushl $54
c010204c:	6a 36                	push   $0x36
  jmp __alltraps
c010204e:	e9 fd fd ff ff       	jmp    c0101e50 <__alltraps>

c0102053 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $55
c0102055:	6a 37                	push   $0x37
  jmp __alltraps
c0102057:	e9 f4 fd ff ff       	jmp    c0101e50 <__alltraps>

c010205c <vector56>:
.globl vector56
vector56:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $56
c010205e:	6a 38                	push   $0x38
  jmp __alltraps
c0102060:	e9 eb fd ff ff       	jmp    c0101e50 <__alltraps>

c0102065 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $57
c0102067:	6a 39                	push   $0x39
  jmp __alltraps
c0102069:	e9 e2 fd ff ff       	jmp    c0101e50 <__alltraps>

c010206e <vector58>:
.globl vector58
vector58:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $58
c0102070:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102072:	e9 d9 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102077 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $59
c0102079:	6a 3b                	push   $0x3b
  jmp __alltraps
c010207b:	e9 d0 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102080 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $60
c0102082:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102084:	e9 c7 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102089 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $61
c010208b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010208d:	e9 be fd ff ff       	jmp    c0101e50 <__alltraps>

c0102092 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $62
c0102094:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102096:	e9 b5 fd ff ff       	jmp    c0101e50 <__alltraps>

c010209b <vector63>:
.globl vector63
vector63:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $63
c010209d:	6a 3f                	push   $0x3f
  jmp __alltraps
c010209f:	e9 ac fd ff ff       	jmp    c0101e50 <__alltraps>

c01020a4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $64
c01020a6:	6a 40                	push   $0x40
  jmp __alltraps
c01020a8:	e9 a3 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020ad <vector65>:
.globl vector65
vector65:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $65
c01020af:	6a 41                	push   $0x41
  jmp __alltraps
c01020b1:	e9 9a fd ff ff       	jmp    c0101e50 <__alltraps>

c01020b6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $66
c01020b8:	6a 42                	push   $0x42
  jmp __alltraps
c01020ba:	e9 91 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020bf <vector67>:
.globl vector67
vector67:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $67
c01020c1:	6a 43                	push   $0x43
  jmp __alltraps
c01020c3:	e9 88 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020c8 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $68
c01020ca:	6a 44                	push   $0x44
  jmp __alltraps
c01020cc:	e9 7f fd ff ff       	jmp    c0101e50 <__alltraps>

c01020d1 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $69
c01020d3:	6a 45                	push   $0x45
  jmp __alltraps
c01020d5:	e9 76 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020da <vector70>:
.globl vector70
vector70:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $70
c01020dc:	6a 46                	push   $0x46
  jmp __alltraps
c01020de:	e9 6d fd ff ff       	jmp    c0101e50 <__alltraps>

c01020e3 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $71
c01020e5:	6a 47                	push   $0x47
  jmp __alltraps
c01020e7:	e9 64 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020ec <vector72>:
.globl vector72
vector72:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $72
c01020ee:	6a 48                	push   $0x48
  jmp __alltraps
c01020f0:	e9 5b fd ff ff       	jmp    c0101e50 <__alltraps>

c01020f5 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $73
c01020f7:	6a 49                	push   $0x49
  jmp __alltraps
c01020f9:	e9 52 fd ff ff       	jmp    c0101e50 <__alltraps>

c01020fe <vector74>:
.globl vector74
vector74:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $74
c0102100:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102102:	e9 49 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102107 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $75
c0102109:	6a 4b                	push   $0x4b
  jmp __alltraps
c010210b:	e9 40 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102110 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $76
c0102112:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102114:	e9 37 fd ff ff       	jmp    c0101e50 <__alltraps>

c0102119 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $77
c010211b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010211d:	e9 2e fd ff ff       	jmp    c0101e50 <__alltraps>

c0102122 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $78
c0102124:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102126:	e9 25 fd ff ff       	jmp    c0101e50 <__alltraps>

c010212b <vector79>:
.globl vector79
vector79:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $79
c010212d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010212f:	e9 1c fd ff ff       	jmp    c0101e50 <__alltraps>

c0102134 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $80
c0102136:	6a 50                	push   $0x50
  jmp __alltraps
c0102138:	e9 13 fd ff ff       	jmp    c0101e50 <__alltraps>

c010213d <vector81>:
.globl vector81
vector81:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $81
c010213f:	6a 51                	push   $0x51
  jmp __alltraps
c0102141:	e9 0a fd ff ff       	jmp    c0101e50 <__alltraps>

c0102146 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $82
c0102148:	6a 52                	push   $0x52
  jmp __alltraps
c010214a:	e9 01 fd ff ff       	jmp    c0101e50 <__alltraps>

c010214f <vector83>:
.globl vector83
vector83:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $83
c0102151:	6a 53                	push   $0x53
  jmp __alltraps
c0102153:	e9 f8 fc ff ff       	jmp    c0101e50 <__alltraps>

c0102158 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $84
c010215a:	6a 54                	push   $0x54
  jmp __alltraps
c010215c:	e9 ef fc ff ff       	jmp    c0101e50 <__alltraps>

c0102161 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $85
c0102163:	6a 55                	push   $0x55
  jmp __alltraps
c0102165:	e9 e6 fc ff ff       	jmp    c0101e50 <__alltraps>

c010216a <vector86>:
.globl vector86
vector86:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $86
c010216c:	6a 56                	push   $0x56
  jmp __alltraps
c010216e:	e9 dd fc ff ff       	jmp    c0101e50 <__alltraps>

c0102173 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $87
c0102175:	6a 57                	push   $0x57
  jmp __alltraps
c0102177:	e9 d4 fc ff ff       	jmp    c0101e50 <__alltraps>

c010217c <vector88>:
.globl vector88
vector88:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $88
c010217e:	6a 58                	push   $0x58
  jmp __alltraps
c0102180:	e9 cb fc ff ff       	jmp    c0101e50 <__alltraps>

c0102185 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $89
c0102187:	6a 59                	push   $0x59
  jmp __alltraps
c0102189:	e9 c2 fc ff ff       	jmp    c0101e50 <__alltraps>

c010218e <vector90>:
.globl vector90
vector90:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $90
c0102190:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102192:	e9 b9 fc ff ff       	jmp    c0101e50 <__alltraps>

c0102197 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $91
c0102199:	6a 5b                	push   $0x5b
  jmp __alltraps
c010219b:	e9 b0 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021a0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $92
c01021a2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021a4:	e9 a7 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021a9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $93
c01021ab:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021ad:	e9 9e fc ff ff       	jmp    c0101e50 <__alltraps>

c01021b2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $94
c01021b4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021b6:	e9 95 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021bb <vector95>:
.globl vector95
vector95:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $95
c01021bd:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021bf:	e9 8c fc ff ff       	jmp    c0101e50 <__alltraps>

c01021c4 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $96
c01021c6:	6a 60                	push   $0x60
  jmp __alltraps
c01021c8:	e9 83 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021cd <vector97>:
.globl vector97
vector97:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $97
c01021cf:	6a 61                	push   $0x61
  jmp __alltraps
c01021d1:	e9 7a fc ff ff       	jmp    c0101e50 <__alltraps>

c01021d6 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $98
c01021d8:	6a 62                	push   $0x62
  jmp __alltraps
c01021da:	e9 71 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021df <vector99>:
.globl vector99
vector99:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $99
c01021e1:	6a 63                	push   $0x63
  jmp __alltraps
c01021e3:	e9 68 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021e8 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $100
c01021ea:	6a 64                	push   $0x64
  jmp __alltraps
c01021ec:	e9 5f fc ff ff       	jmp    c0101e50 <__alltraps>

c01021f1 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $101
c01021f3:	6a 65                	push   $0x65
  jmp __alltraps
c01021f5:	e9 56 fc ff ff       	jmp    c0101e50 <__alltraps>

c01021fa <vector102>:
.globl vector102
vector102:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $102
c01021fc:	6a 66                	push   $0x66
  jmp __alltraps
c01021fe:	e9 4d fc ff ff       	jmp    c0101e50 <__alltraps>

c0102203 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102203:	6a 00                	push   $0x0
  pushl $103
c0102205:	6a 67                	push   $0x67
  jmp __alltraps
c0102207:	e9 44 fc ff ff       	jmp    c0101e50 <__alltraps>

c010220c <vector104>:
.globl vector104
vector104:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $104
c010220e:	6a 68                	push   $0x68
  jmp __alltraps
c0102210:	e9 3b fc ff ff       	jmp    c0101e50 <__alltraps>

c0102215 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102215:	6a 00                	push   $0x0
  pushl $105
c0102217:	6a 69                	push   $0x69
  jmp __alltraps
c0102219:	e9 32 fc ff ff       	jmp    c0101e50 <__alltraps>

c010221e <vector106>:
.globl vector106
vector106:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $106
c0102220:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102222:	e9 29 fc ff ff       	jmp    c0101e50 <__alltraps>

c0102227 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102227:	6a 00                	push   $0x0
  pushl $107
c0102229:	6a 6b                	push   $0x6b
  jmp __alltraps
c010222b:	e9 20 fc ff ff       	jmp    c0101e50 <__alltraps>

c0102230 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $108
c0102232:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102234:	e9 17 fc ff ff       	jmp    c0101e50 <__alltraps>

c0102239 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $109
c010223b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010223d:	e9 0e fc ff ff       	jmp    c0101e50 <__alltraps>

c0102242 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $110
c0102244:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102246:	e9 05 fc ff ff       	jmp    c0101e50 <__alltraps>

c010224b <vector111>:
.globl vector111
vector111:
  pushl $0
c010224b:	6a 00                	push   $0x0
  pushl $111
c010224d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010224f:	e9 fc fb ff ff       	jmp    c0101e50 <__alltraps>

c0102254 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $112
c0102256:	6a 70                	push   $0x70
  jmp __alltraps
c0102258:	e9 f3 fb ff ff       	jmp    c0101e50 <__alltraps>

c010225d <vector113>:
.globl vector113
vector113:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $113
c010225f:	6a 71                	push   $0x71
  jmp __alltraps
c0102261:	e9 ea fb ff ff       	jmp    c0101e50 <__alltraps>

c0102266 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $114
c0102268:	6a 72                	push   $0x72
  jmp __alltraps
c010226a:	e9 e1 fb ff ff       	jmp    c0101e50 <__alltraps>

c010226f <vector115>:
.globl vector115
vector115:
  pushl $0
c010226f:	6a 00                	push   $0x0
  pushl $115
c0102271:	6a 73                	push   $0x73
  jmp __alltraps
c0102273:	e9 d8 fb ff ff       	jmp    c0101e50 <__alltraps>

c0102278 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $116
c010227a:	6a 74                	push   $0x74
  jmp __alltraps
c010227c:	e9 cf fb ff ff       	jmp    c0101e50 <__alltraps>

c0102281 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $117
c0102283:	6a 75                	push   $0x75
  jmp __alltraps
c0102285:	e9 c6 fb ff ff       	jmp    c0101e50 <__alltraps>

c010228a <vector118>:
.globl vector118
vector118:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $118
c010228c:	6a 76                	push   $0x76
  jmp __alltraps
c010228e:	e9 bd fb ff ff       	jmp    c0101e50 <__alltraps>

c0102293 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $119
c0102295:	6a 77                	push   $0x77
  jmp __alltraps
c0102297:	e9 b4 fb ff ff       	jmp    c0101e50 <__alltraps>

c010229c <vector120>:
.globl vector120
vector120:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $120
c010229e:	6a 78                	push   $0x78
  jmp __alltraps
c01022a0:	e9 ab fb ff ff       	jmp    c0101e50 <__alltraps>

c01022a5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $121
c01022a7:	6a 79                	push   $0x79
  jmp __alltraps
c01022a9:	e9 a2 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022ae <vector122>:
.globl vector122
vector122:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $122
c01022b0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022b2:	e9 99 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022b7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $123
c01022b9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022bb:	e9 90 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022c0 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $124
c01022c2:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022c4:	e9 87 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022c9 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $125
c01022cb:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022cd:	e9 7e fb ff ff       	jmp    c0101e50 <__alltraps>

c01022d2 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $126
c01022d4:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022d6:	e9 75 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022db <vector127>:
.globl vector127
vector127:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $127
c01022dd:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022df:	e9 6c fb ff ff       	jmp    c0101e50 <__alltraps>

c01022e4 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $128
c01022e6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022eb:	e9 60 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022f0 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $129
c01022f2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022f7:	e9 54 fb ff ff       	jmp    c0101e50 <__alltraps>

c01022fc <vector130>:
.globl vector130
vector130:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $130
c01022fe:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102303:	e9 48 fb ff ff       	jmp    c0101e50 <__alltraps>

c0102308 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $131
c010230a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010230f:	e9 3c fb ff ff       	jmp    c0101e50 <__alltraps>

c0102314 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $132
c0102316:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010231b:	e9 30 fb ff ff       	jmp    c0101e50 <__alltraps>

c0102320 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $133
c0102322:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102327:	e9 24 fb ff ff       	jmp    c0101e50 <__alltraps>

c010232c <vector134>:
.globl vector134
vector134:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $134
c010232e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102333:	e9 18 fb ff ff       	jmp    c0101e50 <__alltraps>

c0102338 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $135
c010233a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010233f:	e9 0c fb ff ff       	jmp    c0101e50 <__alltraps>

c0102344 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $136
c0102346:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010234b:	e9 00 fb ff ff       	jmp    c0101e50 <__alltraps>

c0102350 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $137
c0102352:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102357:	e9 f4 fa ff ff       	jmp    c0101e50 <__alltraps>

c010235c <vector138>:
.globl vector138
vector138:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $138
c010235e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102363:	e9 e8 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102368 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $139
c010236a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010236f:	e9 dc fa ff ff       	jmp    c0101e50 <__alltraps>

c0102374 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $140
c0102376:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010237b:	e9 d0 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102380 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $141
c0102382:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102387:	e9 c4 fa ff ff       	jmp    c0101e50 <__alltraps>

c010238c <vector142>:
.globl vector142
vector142:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $142
c010238e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102393:	e9 b8 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102398 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $143
c010239a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010239f:	e9 ac fa ff ff       	jmp    c0101e50 <__alltraps>

c01023a4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $144
c01023a6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023ab:	e9 a0 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023b0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $145
c01023b2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023b7:	e9 94 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023bc <vector146>:
.globl vector146
vector146:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $146
c01023be:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023c3:	e9 88 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023c8 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $147
c01023ca:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023cf:	e9 7c fa ff ff       	jmp    c0101e50 <__alltraps>

c01023d4 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $148
c01023d6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023db:	e9 70 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023e0 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $149
c01023e2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023e7:	e9 64 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023ec <vector150>:
.globl vector150
vector150:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $150
c01023ee:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023f3:	e9 58 fa ff ff       	jmp    c0101e50 <__alltraps>

c01023f8 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $151
c01023fa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023ff:	e9 4c fa ff ff       	jmp    c0101e50 <__alltraps>

c0102404 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $152
c0102406:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010240b:	e9 40 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102410 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $153
c0102412:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102417:	e9 34 fa ff ff       	jmp    c0101e50 <__alltraps>

c010241c <vector154>:
.globl vector154
vector154:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $154
c010241e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102423:	e9 28 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102428 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $155
c010242a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010242f:	e9 1c fa ff ff       	jmp    c0101e50 <__alltraps>

c0102434 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $156
c0102436:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010243b:	e9 10 fa ff ff       	jmp    c0101e50 <__alltraps>

c0102440 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $157
c0102442:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102447:	e9 04 fa ff ff       	jmp    c0101e50 <__alltraps>

c010244c <vector158>:
.globl vector158
vector158:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $158
c010244e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102453:	e9 f8 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102458 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $159
c010245a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010245f:	e9 ec f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102464 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $160
c0102466:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010246b:	e9 e0 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102470 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $161
c0102472:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102477:	e9 d4 f9 ff ff       	jmp    c0101e50 <__alltraps>

c010247c <vector162>:
.globl vector162
vector162:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $162
c010247e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102483:	e9 c8 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102488 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $163
c010248a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010248f:	e9 bc f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102494 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $164
c0102496:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010249b:	e9 b0 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024a0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $165
c01024a2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024a7:	e9 a4 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024ac <vector166>:
.globl vector166
vector166:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $166
c01024ae:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024b3:	e9 98 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024b8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $167
c01024ba:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024bf:	e9 8c f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024c4 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $168
c01024c6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024cb:	e9 80 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024d0 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $169
c01024d2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024d7:	e9 74 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024dc <vector170>:
.globl vector170
vector170:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $170
c01024de:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024e3:	e9 68 f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024e8 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $171
c01024ea:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024ef:	e9 5c f9 ff ff       	jmp    c0101e50 <__alltraps>

c01024f4 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $172
c01024f6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024fb:	e9 50 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102500 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $173
c0102502:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102507:	e9 44 f9 ff ff       	jmp    c0101e50 <__alltraps>

c010250c <vector174>:
.globl vector174
vector174:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $174
c010250e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102513:	e9 38 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102518 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $175
c010251a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010251f:	e9 2c f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102524 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $176
c0102526:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010252b:	e9 20 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102530 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $177
c0102532:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102537:	e9 14 f9 ff ff       	jmp    c0101e50 <__alltraps>

c010253c <vector178>:
.globl vector178
vector178:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $178
c010253e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102543:	e9 08 f9 ff ff       	jmp    c0101e50 <__alltraps>

c0102548 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $179
c010254a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010254f:	e9 fc f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102554 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $180
c0102556:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010255b:	e9 f0 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102560 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $181
c0102562:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102567:	e9 e4 f8 ff ff       	jmp    c0101e50 <__alltraps>

c010256c <vector182>:
.globl vector182
vector182:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $182
c010256e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102573:	e9 d8 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102578 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $183
c010257a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010257f:	e9 cc f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102584 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $184
c0102586:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010258b:	e9 c0 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102590 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $185
c0102592:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102597:	e9 b4 f8 ff ff       	jmp    c0101e50 <__alltraps>

c010259c <vector186>:
.globl vector186
vector186:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $186
c010259e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025a3:	e9 a8 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025a8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $187
c01025aa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025af:	e9 9c f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025b4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $188
c01025b6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025bb:	e9 90 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025c0 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $189
c01025c2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025c7:	e9 84 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025cc <vector190>:
.globl vector190
vector190:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $190
c01025ce:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025d3:	e9 78 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025d8 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $191
c01025da:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025df:	e9 6c f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025e4 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $192
c01025e6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025eb:	e9 60 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025f0 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $193
c01025f2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025f7:	e9 54 f8 ff ff       	jmp    c0101e50 <__alltraps>

c01025fc <vector194>:
.globl vector194
vector194:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $194
c01025fe:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102603:	e9 48 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102608 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $195
c010260a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010260f:	e9 3c f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102614 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $196
c0102616:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010261b:	e9 30 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102620 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $197
c0102622:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102627:	e9 24 f8 ff ff       	jmp    c0101e50 <__alltraps>

c010262c <vector198>:
.globl vector198
vector198:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $198
c010262e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102633:	e9 18 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102638 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $199
c010263a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010263f:	e9 0c f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102644 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $200
c0102646:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010264b:	e9 00 f8 ff ff       	jmp    c0101e50 <__alltraps>

c0102650 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $201
c0102652:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102657:	e9 f4 f7 ff ff       	jmp    c0101e50 <__alltraps>

c010265c <vector202>:
.globl vector202
vector202:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $202
c010265e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102663:	e9 e8 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102668 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $203
c010266a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010266f:	e9 dc f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102674 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $204
c0102676:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010267b:	e9 d0 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102680 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $205
c0102682:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102687:	e9 c4 f7 ff ff       	jmp    c0101e50 <__alltraps>

c010268c <vector206>:
.globl vector206
vector206:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $206
c010268e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102693:	e9 b8 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102698 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $207
c010269a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010269f:	e9 ac f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026a4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $208
c01026a6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026ab:	e9 a0 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026b0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $209
c01026b2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026b7:	e9 94 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026bc <vector210>:
.globl vector210
vector210:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $210
c01026be:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026c3:	e9 88 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026c8 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $211
c01026ca:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026cf:	e9 7c f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026d4 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $212
c01026d6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026db:	e9 70 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026e0 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $213
c01026e2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026e7:	e9 64 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026ec <vector214>:
.globl vector214
vector214:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $214
c01026ee:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026f3:	e9 58 f7 ff ff       	jmp    c0101e50 <__alltraps>

c01026f8 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $215
c01026fa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026ff:	e9 4c f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102704 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $216
c0102706:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010270b:	e9 40 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102710 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $217
c0102712:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102717:	e9 34 f7 ff ff       	jmp    c0101e50 <__alltraps>

c010271c <vector218>:
.globl vector218
vector218:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $218
c010271e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102723:	e9 28 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102728 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $219
c010272a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010272f:	e9 1c f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102734 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $220
c0102736:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010273b:	e9 10 f7 ff ff       	jmp    c0101e50 <__alltraps>

c0102740 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $221
c0102742:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102747:	e9 04 f7 ff ff       	jmp    c0101e50 <__alltraps>

c010274c <vector222>:
.globl vector222
vector222:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $222
c010274e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102753:	e9 f8 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102758 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $223
c010275a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010275f:	e9 ec f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102764 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $224
c0102766:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010276b:	e9 e0 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102770 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $225
c0102772:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102777:	e9 d4 f6 ff ff       	jmp    c0101e50 <__alltraps>

c010277c <vector226>:
.globl vector226
vector226:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $226
c010277e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102783:	e9 c8 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102788 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $227
c010278a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010278f:	e9 bc f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102794 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $228
c0102796:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010279b:	e9 b0 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027a0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $229
c01027a2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027a7:	e9 a4 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027ac <vector230>:
.globl vector230
vector230:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $230
c01027ae:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027b3:	e9 98 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027b8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $231
c01027ba:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027bf:	e9 8c f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027c4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $232
c01027c6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027cb:	e9 80 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027d0 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $233
c01027d2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027d7:	e9 74 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027dc <vector234>:
.globl vector234
vector234:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $234
c01027de:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027e3:	e9 68 f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027e8 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $235
c01027ea:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027ef:	e9 5c f6 ff ff       	jmp    c0101e50 <__alltraps>

c01027f4 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $236
c01027f6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027fb:	e9 50 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102800 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $237
c0102802:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102807:	e9 44 f6 ff ff       	jmp    c0101e50 <__alltraps>

c010280c <vector238>:
.globl vector238
vector238:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $238
c010280e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102813:	e9 38 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102818 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $239
c010281a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010281f:	e9 2c f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102824 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $240
c0102826:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010282b:	e9 20 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102830 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $241
c0102832:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102837:	e9 14 f6 ff ff       	jmp    c0101e50 <__alltraps>

c010283c <vector242>:
.globl vector242
vector242:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $242
c010283e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102843:	e9 08 f6 ff ff       	jmp    c0101e50 <__alltraps>

c0102848 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $243
c010284a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010284f:	e9 fc f5 ff ff       	jmp    c0101e50 <__alltraps>

c0102854 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $244
c0102856:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010285b:	e9 f0 f5 ff ff       	jmp    c0101e50 <__alltraps>

c0102860 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $245
c0102862:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102867:	e9 e4 f5 ff ff       	jmp    c0101e50 <__alltraps>

c010286c <vector246>:
.globl vector246
vector246:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $246
c010286e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102873:	e9 d8 f5 ff ff       	jmp    c0101e50 <__alltraps>

c0102878 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $247
c010287a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010287f:	e9 cc f5 ff ff       	jmp    c0101e50 <__alltraps>

c0102884 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $248
c0102886:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010288b:	e9 c0 f5 ff ff       	jmp    c0101e50 <__alltraps>

c0102890 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $249
c0102892:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102897:	e9 b4 f5 ff ff       	jmp    c0101e50 <__alltraps>

c010289c <vector250>:
.globl vector250
vector250:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $250
c010289e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028a3:	e9 a8 f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028a8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $251
c01028aa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028af:	e9 9c f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028b4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $252
c01028b6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028bb:	e9 90 f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028c0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $253
c01028c2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028c7:	e9 84 f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028cc <vector254>:
.globl vector254
vector254:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $254
c01028ce:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028d3:	e9 78 f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028d8 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $255
c01028da:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028df:	e9 6c f5 ff ff       	jmp    c0101e50 <__alltraps>

c01028e4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028e4:	55                   	push   %ebp
c01028e5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028e7:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01028ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f0:	29 d0                	sub    %edx,%eax
c01028f2:	c1 f8 02             	sar    $0x2,%eax
c01028f5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028fb:	5d                   	pop    %ebp
c01028fc:	c3                   	ret    

c01028fd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028fd:	55                   	push   %ebp
c01028fe:	89 e5                	mov    %esp,%ebp
c0102900:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102903:	8b 45 08             	mov    0x8(%ebp),%eax
c0102906:	89 04 24             	mov    %eax,(%esp)
c0102909:	e8 d6 ff ff ff       	call   c01028e4 <page2ppn>
c010290e:	c1 e0 0c             	shl    $0xc,%eax
}
c0102911:	89 ec                	mov    %ebp,%esp
c0102913:	5d                   	pop    %ebp
c0102914:	c3                   	ret    

c0102915 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102915:	55                   	push   %ebp
c0102916:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102918:	8b 45 08             	mov    0x8(%ebp),%eax
c010291b:	8b 00                	mov    (%eax),%eax
}
c010291d:	5d                   	pop    %ebp
c010291e:	c3                   	ret    

c010291f <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010291f:	55                   	push   %ebp
c0102920:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102922:	8b 45 08             	mov    0x8(%ebp),%eax
c0102925:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102928:	89 10                	mov    %edx,(%eax)
}
c010292a:	90                   	nop
c010292b:	5d                   	pop    %ebp
c010292c:	c3                   	ret    

c010292d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010292d:	55                   	push   %ebp
c010292e:	89 e5                	mov    %esp,%ebp
c0102930:	83 ec 10             	sub    $0x10,%esp
c0102933:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010293a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102940:	89 50 04             	mov    %edx,0x4(%eax)
c0102943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102946:	8b 50 04             	mov    0x4(%eax),%edx
c0102949:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010294c:	89 10                	mov    %edx,(%eax)
}
c010294e:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c010294f:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102956:	00 00 00 
}
c0102959:	90                   	nop
c010295a:	89 ec                	mov    %ebp,%esp
c010295c:	5d                   	pop    %ebp
c010295d:	c3                   	ret    

c010295e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010295e:	55                   	push   %ebp
c010295f:	89 e5                	mov    %esp,%ebp
c0102961:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102968:	75 24                	jne    c010298e <default_init_memmap+0x30>
c010296a:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102971:	c0 
c0102972:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102979:	c0 
c010297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102981:	00 
c0102982:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102989:	e8 5a e3 ff ff       	call   c0100ce8 <__panic>
    struct Page *p = base;
c010298e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102991:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102994:	eb 7d                	jmp    c0102a13 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102999:	83 c0 04             	add    $0x4,%eax
c010299c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029ac:	0f a3 10             	bt     %edx,(%eax)
c01029af:	19 c0                	sbb    %eax,%eax
c01029b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029b8:	0f 95 c0             	setne  %al
c01029bb:	0f b6 c0             	movzbl %al,%eax
c01029be:	85 c0                	test   %eax,%eax
c01029c0:	75 24                	jne    c01029e6 <default_init_memmap+0x88>
c01029c2:	c7 44 24 0c 41 66 10 	movl   $0xc0106641,0xc(%esp)
c01029c9:	c0 
c01029ca:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01029d1:	c0 
c01029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01029d9:	00 
c01029da:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01029e1:	e8 02 e3 ff ff       	call   c0100ce8 <__panic>
        p->flags = p->property = 0;
c01029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f3:	8b 50 08             	mov    0x8(%eax),%edx
c01029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f9:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a03:	00 
c0102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a07:	89 04 24             	mov    %eax,(%esp)
c0102a0a:	e8 10 ff ff ff       	call   c010291f <set_page_ref>
    for (; p != base + n; p ++) {
c0102a0f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a13:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a16:	89 d0                	mov    %edx,%eax
c0102a18:	c1 e0 02             	shl    $0x2,%eax
c0102a1b:	01 d0                	add    %edx,%eax
c0102a1d:	c1 e0 02             	shl    $0x2,%eax
c0102a20:	89 c2                	mov    %eax,%edx
c0102a22:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a25:	01 d0                	add    %edx,%eax
c0102a27:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102a2a:	0f 85 66 ff ff ff    	jne    c0102996 <default_init_memmap+0x38>
    }
    base->property = n;
c0102a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a33:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a36:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3c:	83 c0 04             	add    $0x4,%eax
c0102a3f:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102a46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a4c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a4f:	0f ab 10             	bts    %edx,(%eax)
}
c0102a52:	90                   	nop
    nr_free += n;
c0102a53:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102a59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a5c:	01 d0                	add    %edx,%eax
c0102a5e:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add(&free_list, &(base->page_link));
c0102a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a66:	83 c0 0c             	add    $0xc,%eax
c0102a69:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c0102a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a76:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a82:	8b 40 04             	mov    0x4(%eax),%eax
c0102a85:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a8e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102a91:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a9a:	89 10                	mov    %edx,(%eax)
c0102a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a9f:	8b 10                	mov    (%eax),%edx
c0102aa1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102aa4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102aaa:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102aad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ab0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ab3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102ab6:	89 10                	mov    %edx,(%eax)
}
c0102ab8:	90                   	nop
}
c0102ab9:	90                   	nop
}
c0102aba:	90                   	nop
}
c0102abb:	90                   	nop
c0102abc:	89 ec                	mov    %ebp,%esp
c0102abe:	5d                   	pop    %ebp
c0102abf:	c3                   	ret    

c0102ac0 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102ac0:	55                   	push   %ebp
c0102ac1:	89 e5                	mov    %esp,%ebp
c0102ac3:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aca:	75 24                	jne    c0102af0 <default_alloc_pages+0x30>
c0102acc:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102ad3:	c0 
c0102ad4:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102adb:	c0 
c0102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102ae3:	00 
c0102ae4:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102aeb:	e8 f8 e1 ff ff       	call   c0100ce8 <__panic>
    if (n > nr_free) {
c0102af0:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102af5:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102af8:	76 0a                	jbe    c0102b04 <default_alloc_pages+0x44>
        return NULL;
c0102afa:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aff:	e9 34 01 00 00       	jmp    c0102c38 <default_alloc_pages+0x178>
    }
    struct Page *page = NULL;
c0102b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b0b:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102b12:	eb 1c                	jmp    c0102b30 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b17:	83 e8 0c             	sub    $0xc,%eax
c0102b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b20:	8b 40 08             	mov    0x8(%eax),%eax
c0102b23:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b26:	77 08                	ja     c0102b30 <default_alloc_pages+0x70>
            page = p;
c0102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b2e:	eb 18                	jmp    c0102b48 <default_alloc_pages+0x88>
c0102b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b39:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b3f:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102b46:	75 cc                	jne    c0102b14 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0102b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b4c:	0f 84 e3 00 00 00    	je     c0102c35 <default_alloc_pages+0x175>
        list_del(&(page->page_link));
c0102b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b55:	83 c0 0c             	add    $0xc,%eax
c0102b58:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b5e:	8b 40 04             	mov    0x4(%eax),%eax
c0102b61:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b64:	8b 12                	mov    (%edx),%edx
c0102b66:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b69:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b72:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b78:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b7b:	89 10                	mov    %edx,(%eax)
}
c0102b7d:	90                   	nop
}
c0102b7e:	90                   	nop
        if (page->property > n) {
c0102b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b82:	8b 40 08             	mov    0x8(%eax),%eax
c0102b85:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b88:	0f 83 80 00 00 00    	jae    c0102c0e <default_alloc_pages+0x14e>
            struct Page *p = page + n;
c0102b8e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b91:	89 d0                	mov    %edx,%eax
c0102b93:	c1 e0 02             	shl    $0x2,%eax
c0102b96:	01 d0                	add    %edx,%eax
c0102b98:	c1 e0 02             	shl    $0x2,%eax
c0102b9b:	89 c2                	mov    %eax,%edx
c0102b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba0:	01 d0                	add    %edx,%eax
c0102ba2:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba8:	8b 40 08             	mov    0x8(%eax),%eax
c0102bab:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bae:	89 c2                	mov    %eax,%edx
c0102bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bb3:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bb9:	83 c0 0c             	add    $0xc,%eax
c0102bbc:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
c0102bc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bc9:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102bcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102bd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bd5:	8b 40 04             	mov    0x4(%eax),%eax
c0102bd8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bdb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102bde:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102be1:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102be4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c0102be7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bed:	89 10                	mov    %edx,(%eax)
c0102bef:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bf2:	8b 10                	mov    (%eax),%edx
c0102bf4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102bf7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bfa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bfd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c00:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c06:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c09:	89 10                	mov    %edx,(%eax)
}
c0102c0b:	90                   	nop
}
c0102c0c:	90                   	nop
}
c0102c0d:	90                   	nop
    }
        nr_free -= n;
c0102c0e:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102c13:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c16:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c1e:	83 c0 04             	add    $0x4,%eax
c0102c21:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102c28:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c2e:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c31:	0f b3 10             	btr    %edx,(%eax)
}
c0102c34:	90                   	nop
    }
    return page;
c0102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c38:	89 ec                	mov    %ebp,%esp
c0102c3a:	5d                   	pop    %ebp
c0102c3b:	c3                   	ret    

c0102c3c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c3c:	55                   	push   %ebp
c0102c3d:	89 e5                	mov    %esp,%ebp
c0102c3f:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c49:	75 24                	jne    c0102c6f <default_free_pages+0x33>
c0102c4b:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102c52:	c0 
c0102c53:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102c5a:	c0 
c0102c5b:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102c62:	00 
c0102c63:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102c6a:	e8 79 e0 ff ff       	call   c0100ce8 <__panic>
    struct Page *p = base;
c0102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c75:	e9 9d 00 00 00       	jmp    c0102d17 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c7d:	83 c0 04             	add    $0x4,%eax
c0102c80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c87:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c90:	0f a3 10             	bt     %edx,(%eax)
c0102c93:	19 c0                	sbb    %eax,%eax
c0102c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c9c:	0f 95 c0             	setne  %al
c0102c9f:	0f b6 c0             	movzbl %al,%eax
c0102ca2:	85 c0                	test   %eax,%eax
c0102ca4:	75 2c                	jne    c0102cd2 <default_free_pages+0x96>
c0102ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca9:	83 c0 04             	add    $0x4,%eax
c0102cac:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102cb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cbc:	0f a3 10             	bt     %edx,(%eax)
c0102cbf:	19 c0                	sbb    %eax,%eax
c0102cc1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102cc4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102cc8:	0f 95 c0             	setne  %al
c0102ccb:	0f b6 c0             	movzbl %al,%eax
c0102cce:	85 c0                	test   %eax,%eax
c0102cd0:	74 24                	je     c0102cf6 <default_free_pages+0xba>
c0102cd2:	c7 44 24 0c 54 66 10 	movl   $0xc0106654,0xc(%esp)
c0102cd9:	c0 
c0102cda:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102ce1:	c0 
c0102ce2:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102ce9:	00 
c0102cea:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102cf1:	e8 f2 df ff ff       	call   c0100ce8 <__panic>
        p->flags = 0;
c0102cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d07:	00 
c0102d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0b:	89 04 24             	mov    %eax,(%esp)
c0102d0e:	e8 0c fc ff ff       	call   c010291f <set_page_ref>
    for (; p != base + n; p ++) {
c0102d13:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d1a:	89 d0                	mov    %edx,%eax
c0102d1c:	c1 e0 02             	shl    $0x2,%eax
c0102d1f:	01 d0                	add    %edx,%eax
c0102d21:	c1 e0 02             	shl    $0x2,%eax
c0102d24:	89 c2                	mov    %eax,%edx
c0102d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d29:	01 d0                	add    %edx,%eax
c0102d2b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102d2e:	0f 85 46 ff ff ff    	jne    c0102c7a <default_free_pages+0x3e>
    }
    base->property = n;
c0102d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d37:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d3a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d40:	83 c0 04             	add    $0x4,%eax
c0102d43:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102d4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d50:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d53:	0f ab 10             	bts    %edx,(%eax)
}
c0102d56:	90                   	nop
c0102d57:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102d5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d61:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d67:	e9 0e 01 00 00       	jmp    c0102e7a <default_free_pages+0x23e>
        p = le2page(le, page_link);
c0102d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d6f:	83 e8 0c             	sub    $0xc,%eax
c0102d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d78:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d7e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d87:	8b 50 08             	mov    0x8(%eax),%edx
c0102d8a:	89 d0                	mov    %edx,%eax
c0102d8c:	c1 e0 02             	shl    $0x2,%eax
c0102d8f:	01 d0                	add    %edx,%eax
c0102d91:	c1 e0 02             	shl    $0x2,%eax
c0102d94:	89 c2                	mov    %eax,%edx
c0102d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d99:	01 d0                	add    %edx,%eax
c0102d9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102d9e:	75 5d                	jne    c0102dfd <default_free_pages+0x1c1>
            base->property += p->property;
c0102da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da3:	8b 50 08             	mov    0x8(%eax),%edx
c0102da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da9:	8b 40 08             	mov    0x8(%eax),%eax
c0102dac:	01 c2                	add    %eax,%edx
c0102dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db7:	83 c0 04             	add    $0x4,%eax
c0102dba:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102dc1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dc4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102dc7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102dca:	0f b3 10             	btr    %edx,(%eax)
}
c0102dcd:	90                   	nop
            list_del(&(p->page_link));
c0102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd1:	83 c0 0c             	add    $0xc,%eax
c0102dd4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102dd7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102dda:	8b 40 04             	mov    0x4(%eax),%eax
c0102ddd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102de0:	8b 12                	mov    (%edx),%edx
c0102de2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102de5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102de8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102deb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dee:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102df1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102df4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102df7:	89 10                	mov    %edx,(%eax)
}
c0102df9:	90                   	nop
}
c0102dfa:	90                   	nop
c0102dfb:	eb 7d                	jmp    c0102e7a <default_free_pages+0x23e>
        }
        else if (p + p->property == base) {
c0102dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e00:	8b 50 08             	mov    0x8(%eax),%edx
c0102e03:	89 d0                	mov    %edx,%eax
c0102e05:	c1 e0 02             	shl    $0x2,%eax
c0102e08:	01 d0                	add    %edx,%eax
c0102e0a:	c1 e0 02             	shl    $0x2,%eax
c0102e0d:	89 c2                	mov    %eax,%edx
c0102e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e12:	01 d0                	add    %edx,%eax
c0102e14:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e17:	75 61                	jne    c0102e7a <default_free_pages+0x23e>
            p->property += base->property;
c0102e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1c:	8b 50 08             	mov    0x8(%eax),%edx
c0102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e22:	8b 40 08             	mov    0x8(%eax),%eax
c0102e25:	01 c2                	add    %eax,%edx
c0102e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e30:	83 c0 04             	add    $0x4,%eax
c0102e33:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102e3a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e3d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e40:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e43:	0f b3 10             	btr    %edx,(%eax)
}
c0102e46:	90                   	nop
            base = p;
c0102e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e4a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e50:	83 c0 0c             	add    $0xc,%eax
c0102e53:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e56:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e59:	8b 40 04             	mov    0x4(%eax),%eax
c0102e5c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e5f:	8b 12                	mov    (%edx),%edx
c0102e61:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102e64:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102e67:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e6a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e6d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e70:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e73:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e76:	89 10                	mov    %edx,(%eax)
}
c0102e78:	90                   	nop
}
c0102e79:	90                   	nop
    while (le != &free_list) {
c0102e7a:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102e81:	0f 85 e5 fe ff ff    	jne    c0102d6c <default_free_pages+0x130>
        }
    }
    nr_free += n;
c0102e87:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e90:	01 d0                	add    %edx,%eax
c0102e92:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add(&free_list, &(base->page_link));
c0102e97:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9a:	83 c0 0c             	add    $0xc,%eax
c0102e9d:	c7 45 9c 80 be 11 c0 	movl   $0xc011be80,-0x64(%ebp)
c0102ea4:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102ea7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102eaa:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102ead:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102eb0:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102eb3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102eb6:	8b 40 04             	mov    0x4(%eax),%eax
c0102eb9:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102ebc:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102ebf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102ec2:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102ec5:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102ec8:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102ecb:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102ece:	89 10                	mov    %edx,(%eax)
c0102ed0:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102ed3:	8b 10                	mov    (%eax),%edx
c0102ed5:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102ed8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102edb:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ede:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ee1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ee4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ee7:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102eea:	89 10                	mov    %edx,(%eax)
}
c0102eec:	90                   	nop
}
c0102eed:	90                   	nop
}
c0102eee:	90                   	nop
}
c0102eef:	90                   	nop
c0102ef0:	89 ec                	mov    %ebp,%esp
c0102ef2:	5d                   	pop    %ebp
c0102ef3:	c3                   	ret    

c0102ef4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ef4:	55                   	push   %ebp
c0102ef5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ef7:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0102efc:	5d                   	pop    %ebp
c0102efd:	c3                   	ret    

c0102efe <basic_check>:

static void
basic_check(void) {
c0102efe:	55                   	push   %ebp
c0102eff:	89 e5                	mov    %esp,%ebp
c0102f01:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f1e:	e8 df 0e 00 00       	call   c0103e02 <alloc_pages>
c0102f23:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f2a:	75 24                	jne    c0102f50 <basic_check+0x52>
c0102f2c:	c7 44 24 0c 79 66 10 	movl   $0xc0106679,0xc(%esp)
c0102f33:	c0 
c0102f34:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102f3b:	c0 
c0102f3c:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0102f43:	00 
c0102f44:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102f4b:	e8 98 dd ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f57:	e8 a6 0e 00 00       	call   c0103e02 <alloc_pages>
c0102f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f63:	75 24                	jne    c0102f89 <basic_check+0x8b>
c0102f65:	c7 44 24 0c 95 66 10 	movl   $0xc0106695,0xc(%esp)
c0102f6c:	c0 
c0102f6d:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102f74:	c0 
c0102f75:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0102f7c:	00 
c0102f7d:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102f84:	e8 5f dd ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f90:	e8 6d 0e 00 00       	call   c0103e02 <alloc_pages>
c0102f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f9c:	75 24                	jne    c0102fc2 <basic_check+0xc4>
c0102f9e:	c7 44 24 0c b1 66 10 	movl   $0xc01066b1,0xc(%esp)
c0102fa5:	c0 
c0102fa6:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102fad:	c0 
c0102fae:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0102fb5:	00 
c0102fb6:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102fbd:	e8 26 dd ff ff       	call   c0100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fc8:	74 10                	je     c0102fda <basic_check+0xdc>
c0102fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fcd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fd0:	74 08                	je     c0102fda <basic_check+0xdc>
c0102fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fd5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fd8:	75 24                	jne    c0102ffe <basic_check+0x100>
c0102fda:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102fe1:	c0 
c0102fe2:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102fe9:	c0 
c0102fea:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0102ff1:	00 
c0102ff2:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102ff9:	e8 ea dc ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103001:	89 04 24             	mov    %eax,(%esp)
c0103004:	e8 0c f9 ff ff       	call   c0102915 <page_ref>
c0103009:	85 c0                	test   %eax,%eax
c010300b:	75 1e                	jne    c010302b <basic_check+0x12d>
c010300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103010:	89 04 24             	mov    %eax,(%esp)
c0103013:	e8 fd f8 ff ff       	call   c0102915 <page_ref>
c0103018:	85 c0                	test   %eax,%eax
c010301a:	75 0f                	jne    c010302b <basic_check+0x12d>
c010301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010301f:	89 04 24             	mov    %eax,(%esp)
c0103022:	e8 ee f8 ff ff       	call   c0102915 <page_ref>
c0103027:	85 c0                	test   %eax,%eax
c0103029:	74 24                	je     c010304f <basic_check+0x151>
c010302b:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c0103032:	c0 
c0103033:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010303a:	c0 
c010303b:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103042:	00 
c0103043:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010304a:	e8 99 dc ff ff       	call   c0100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103052:	89 04 24             	mov    %eax,(%esp)
c0103055:	e8 a3 f8 ff ff       	call   c01028fd <page2pa>
c010305a:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103060:	c1 e2 0c             	shl    $0xc,%edx
c0103063:	39 d0                	cmp    %edx,%eax
c0103065:	72 24                	jb     c010308b <basic_check+0x18d>
c0103067:	c7 44 24 0c 30 67 10 	movl   $0xc0106730,0xc(%esp)
c010306e:	c0 
c010306f:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103076:	c0 
c0103077:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c010307e:	00 
c010307f:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103086:	e8 5d dc ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010308b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010308e:	89 04 24             	mov    %eax,(%esp)
c0103091:	e8 67 f8 ff ff       	call   c01028fd <page2pa>
c0103096:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010309c:	c1 e2 0c             	shl    $0xc,%edx
c010309f:	39 d0                	cmp    %edx,%eax
c01030a1:	72 24                	jb     c01030c7 <basic_check+0x1c9>
c01030a3:	c7 44 24 0c 4d 67 10 	movl   $0xc010674d,0xc(%esp)
c01030aa:	c0 
c01030ab:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01030b2:	c0 
c01030b3:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01030ba:	00 
c01030bb:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01030c2:	e8 21 dc ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030ca:	89 04 24             	mov    %eax,(%esp)
c01030cd:	e8 2b f8 ff ff       	call   c01028fd <page2pa>
c01030d2:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01030d8:	c1 e2 0c             	shl    $0xc,%edx
c01030db:	39 d0                	cmp    %edx,%eax
c01030dd:	72 24                	jb     c0103103 <basic_check+0x205>
c01030df:	c7 44 24 0c 6a 67 10 	movl   $0xc010676a,0xc(%esp)
c01030e6:	c0 
c01030e7:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01030ee:	c0 
c01030ef:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01030f6:	00 
c01030f7:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01030fe:	e8 e5 db ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c0103103:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103108:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c010310e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103111:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103114:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c010311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010311e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103121:	89 50 04             	mov    %edx,0x4(%eax)
c0103124:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103127:	8b 50 04             	mov    0x4(%eax),%edx
c010312a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010312d:	89 10                	mov    %edx,(%eax)
}
c010312f:	90                   	nop
c0103130:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c0103137:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010313a:	8b 40 04             	mov    0x4(%eax),%eax
c010313d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103140:	0f 94 c0             	sete   %al
c0103143:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103146:	85 c0                	test   %eax,%eax
c0103148:	75 24                	jne    c010316e <basic_check+0x270>
c010314a:	c7 44 24 0c 87 67 10 	movl   $0xc0106787,0xc(%esp)
c0103151:	c0 
c0103152:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103159:	c0 
c010315a:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103161:	00 
c0103162:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103169:	e8 7a db ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c010316e:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103173:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103176:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c010317d:	00 00 00 

    assert(alloc_page() == NULL);
c0103180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103187:	e8 76 0c 00 00       	call   c0103e02 <alloc_pages>
c010318c:	85 c0                	test   %eax,%eax
c010318e:	74 24                	je     c01031b4 <basic_check+0x2b6>
c0103190:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c0103197:	c0 
c0103198:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010319f:	c0 
c01031a0:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01031a7:	00 
c01031a8:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01031af:	e8 34 db ff ff       	call   c0100ce8 <__panic>

    free_page(p0);
c01031b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031bb:	00 
c01031bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031bf:	89 04 24             	mov    %eax,(%esp)
c01031c2:	e8 75 0c 00 00       	call   c0103e3c <free_pages>
    free_page(p1);
c01031c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031ce:	00 
c01031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d2:	89 04 24             	mov    %eax,(%esp)
c01031d5:	e8 62 0c 00 00       	call   c0103e3c <free_pages>
    free_page(p2);
c01031da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031e1:	00 
c01031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031e5:	89 04 24             	mov    %eax,(%esp)
c01031e8:	e8 4f 0c 00 00       	call   c0103e3c <free_pages>
    assert(nr_free == 3);
c01031ed:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01031f2:	83 f8 03             	cmp    $0x3,%eax
c01031f5:	74 24                	je     c010321b <basic_check+0x31d>
c01031f7:	c7 44 24 0c b3 67 10 	movl   $0xc01067b3,0xc(%esp)
c01031fe:	c0 
c01031ff:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103206:	c0 
c0103207:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010320e:	00 
c010320f:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103216:	e8 cd da ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010321b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103222:	e8 db 0b 00 00       	call   c0103e02 <alloc_pages>
c0103227:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010322a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010322e:	75 24                	jne    c0103254 <basic_check+0x356>
c0103230:	c7 44 24 0c 79 66 10 	movl   $0xc0106679,0xc(%esp)
c0103237:	c0 
c0103238:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010323f:	c0 
c0103240:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103247:	00 
c0103248:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010324f:	e8 94 da ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103254:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010325b:	e8 a2 0b 00 00       	call   c0103e02 <alloc_pages>
c0103260:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103267:	75 24                	jne    c010328d <basic_check+0x38f>
c0103269:	c7 44 24 0c 95 66 10 	movl   $0xc0106695,0xc(%esp)
c0103270:	c0 
c0103271:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103278:	c0 
c0103279:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0103280:	00 
c0103281:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103288:	e8 5b da ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103294:	e8 69 0b 00 00       	call   c0103e02 <alloc_pages>
c0103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032a0:	75 24                	jne    c01032c6 <basic_check+0x3c8>
c01032a2:	c7 44 24 0c b1 66 10 	movl   $0xc01066b1,0xc(%esp)
c01032a9:	c0 
c01032aa:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01032b1:	c0 
c01032b2:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01032b9:	00 
c01032ba:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01032c1:	e8 22 da ff ff       	call   c0100ce8 <__panic>

    assert(alloc_page() == NULL);
c01032c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032cd:	e8 30 0b 00 00       	call   c0103e02 <alloc_pages>
c01032d2:	85 c0                	test   %eax,%eax
c01032d4:	74 24                	je     c01032fa <basic_check+0x3fc>
c01032d6:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c01032dd:	c0 
c01032de:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01032e5:	c0 
c01032e6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01032ed:	00 
c01032ee:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01032f5:	e8 ee d9 ff ff       	call   c0100ce8 <__panic>

    free_page(p0);
c01032fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103301:	00 
c0103302:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103305:	89 04 24             	mov    %eax,(%esp)
c0103308:	e8 2f 0b 00 00       	call   c0103e3c <free_pages>
c010330d:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c0103314:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103317:	8b 40 04             	mov    0x4(%eax),%eax
c010331a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010331d:	0f 94 c0             	sete   %al
c0103320:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103323:	85 c0                	test   %eax,%eax
c0103325:	74 24                	je     c010334b <basic_check+0x44d>
c0103327:	c7 44 24 0c c0 67 10 	movl   $0xc01067c0,0xc(%esp)
c010332e:	c0 
c010332f:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103336:	c0 
c0103337:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010333e:	00 
c010333f:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103346:	e8 9d d9 ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010334b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103352:	e8 ab 0a 00 00       	call   c0103e02 <alloc_pages>
c0103357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010335a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010335d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103360:	74 24                	je     c0103386 <basic_check+0x488>
c0103362:	c7 44 24 0c d8 67 10 	movl   $0xc01067d8,0xc(%esp)
c0103369:	c0 
c010336a:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103371:	c0 
c0103372:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103379:	00 
c010337a:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103381:	e8 62 d9 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103386:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010338d:	e8 70 0a 00 00       	call   c0103e02 <alloc_pages>
c0103392:	85 c0                	test   %eax,%eax
c0103394:	74 24                	je     c01033ba <basic_check+0x4bc>
c0103396:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c010339d:	c0 
c010339e:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01033a5:	c0 
c01033a6:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01033ad:	00 
c01033ae:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01033b5:	e8 2e d9 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c01033ba:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01033bf:	85 c0                	test   %eax,%eax
c01033c1:	74 24                	je     c01033e7 <basic_check+0x4e9>
c01033c3:	c7 44 24 0c f1 67 10 	movl   $0xc01067f1,0xc(%esp)
c01033ca:	c0 
c01033cb:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01033d2:	c0 
c01033d3:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01033da:	00 
c01033db:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01033e2:	e8 01 d9 ff ff       	call   c0100ce8 <__panic>
    free_list = free_list_store;
c01033e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033ed:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01033f2:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c01033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033fb:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c0103400:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103407:	00 
c0103408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010340b:	89 04 24             	mov    %eax,(%esp)
c010340e:	e8 29 0a 00 00       	call   c0103e3c <free_pages>
    free_page(p1);
c0103413:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010341a:	00 
c010341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010341e:	89 04 24             	mov    %eax,(%esp)
c0103421:	e8 16 0a 00 00       	call   c0103e3c <free_pages>
    free_page(p2);
c0103426:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010342d:	00 
c010342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103431:	89 04 24             	mov    %eax,(%esp)
c0103434:	e8 03 0a 00 00       	call   c0103e3c <free_pages>
}
c0103439:	90                   	nop
c010343a:	89 ec                	mov    %ebp,%esp
c010343c:	5d                   	pop    %ebp
c010343d:	c3                   	ret    

c010343e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010343e:	55                   	push   %ebp
c010343f:	89 e5                	mov    %esp,%ebp
c0103441:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103447:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010344e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103455:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010345c:	eb 6a                	jmp    c01034c8 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010345e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103461:	83 e8 0c             	sub    $0xc,%eax
c0103464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010346a:	83 c0 04             	add    $0x4,%eax
c010346d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103474:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103477:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010347a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010347d:	0f a3 10             	bt     %edx,(%eax)
c0103480:	19 c0                	sbb    %eax,%eax
c0103482:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103485:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103489:	0f 95 c0             	setne  %al
c010348c:	0f b6 c0             	movzbl %al,%eax
c010348f:	85 c0                	test   %eax,%eax
c0103491:	75 24                	jne    c01034b7 <default_check+0x79>
c0103493:	c7 44 24 0c fe 67 10 	movl   $0xc01067fe,0xc(%esp)
c010349a:	c0 
c010349b:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01034a2:	c0 
c01034a3:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01034aa:	00 
c01034ab:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01034b2:	e8 31 d8 ff ff       	call   c0100ce8 <__panic>
        count ++, total += p->property;
c01034b7:	ff 45 f4             	incl   -0xc(%ebp)
c01034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034bd:	8b 50 08             	mov    0x8(%eax),%edx
c01034c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034c3:	01 d0                	add    %edx,%eax
c01034c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01034ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034d1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01034d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034d7:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c01034de:	0f 85 7a ff ff ff    	jne    c010345e <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01034e4:	e8 88 09 00 00       	call   c0103e71 <nr_free_pages>
c01034e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01034ec:	39 d0                	cmp    %edx,%eax
c01034ee:	74 24                	je     c0103514 <default_check+0xd6>
c01034f0:	c7 44 24 0c 0e 68 10 	movl   $0xc010680e,0xc(%esp)
c01034f7:	c0 
c01034f8:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01034ff:	c0 
c0103500:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103507:	00 
c0103508:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010350f:	e8 d4 d7 ff ff       	call   c0100ce8 <__panic>

    basic_check();
c0103514:	e8 e5 f9 ff ff       	call   c0102efe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103519:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103520:	e8 dd 08 00 00       	call   c0103e02 <alloc_pages>
c0103525:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103528:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010352c:	75 24                	jne    c0103552 <default_check+0x114>
c010352e:	c7 44 24 0c 27 68 10 	movl   $0xc0106827,0xc(%esp)
c0103535:	c0 
c0103536:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010353d:	c0 
c010353e:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103545:	00 
c0103546:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010354d:	e8 96 d7 ff ff       	call   c0100ce8 <__panic>
    assert(!PageProperty(p0));
c0103552:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103555:	83 c0 04             	add    $0x4,%eax
c0103558:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010355f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103562:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103565:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103568:	0f a3 10             	bt     %edx,(%eax)
c010356b:	19 c0                	sbb    %eax,%eax
c010356d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103570:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103574:	0f 95 c0             	setne  %al
c0103577:	0f b6 c0             	movzbl %al,%eax
c010357a:	85 c0                	test   %eax,%eax
c010357c:	74 24                	je     c01035a2 <default_check+0x164>
c010357e:	c7 44 24 0c 32 68 10 	movl   $0xc0106832,0xc(%esp)
c0103585:	c0 
c0103586:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010358d:	c0 
c010358e:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103595:	00 
c0103596:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010359d:	e8 46 d7 ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c01035a2:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01035a7:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c01035ad:	89 45 80             	mov    %eax,-0x80(%ebp)
c01035b0:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01035b3:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01035ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035bd:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01035c0:	89 50 04             	mov    %edx,0x4(%eax)
c01035c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035c6:	8b 50 04             	mov    0x4(%eax),%edx
c01035c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035cc:	89 10                	mov    %edx,(%eax)
}
c01035ce:	90                   	nop
c01035cf:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c01035d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035d9:	8b 40 04             	mov    0x4(%eax),%eax
c01035dc:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01035df:	0f 94 c0             	sete   %al
c01035e2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01035e5:	85 c0                	test   %eax,%eax
c01035e7:	75 24                	jne    c010360d <default_check+0x1cf>
c01035e9:	c7 44 24 0c 87 67 10 	movl   $0xc0106787,0xc(%esp)
c01035f0:	c0 
c01035f1:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01035f8:	c0 
c01035f9:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103600:	00 
c0103601:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103608:	e8 db d6 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c010360d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103614:	e8 e9 07 00 00       	call   c0103e02 <alloc_pages>
c0103619:	85 c0                	test   %eax,%eax
c010361b:	74 24                	je     c0103641 <default_check+0x203>
c010361d:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c0103624:	c0 
c0103625:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010362c:	c0 
c010362d:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103634:	00 
c0103635:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010363c:	e8 a7 d6 ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103641:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103649:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0103650:	00 00 00 

    free_pages(p0 + 2, 3);
c0103653:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103656:	83 c0 28             	add    $0x28,%eax
c0103659:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103660:	00 
c0103661:	89 04 24             	mov    %eax,(%esp)
c0103664:	e8 d3 07 00 00       	call   c0103e3c <free_pages>
    assert(alloc_pages(4) == NULL);
c0103669:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103670:	e8 8d 07 00 00       	call   c0103e02 <alloc_pages>
c0103675:	85 c0                	test   %eax,%eax
c0103677:	74 24                	je     c010369d <default_check+0x25f>
c0103679:	c7 44 24 0c 44 68 10 	movl   $0xc0106844,0xc(%esp)
c0103680:	c0 
c0103681:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103688:	c0 
c0103689:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103690:	00 
c0103691:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103698:	e8 4b d6 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010369d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036a0:	83 c0 28             	add    $0x28,%eax
c01036a3:	83 c0 04             	add    $0x4,%eax
c01036a6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01036ad:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01036b3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01036b6:	0f a3 10             	bt     %edx,(%eax)
c01036b9:	19 c0                	sbb    %eax,%eax
c01036bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01036be:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01036c2:	0f 95 c0             	setne  %al
c01036c5:	0f b6 c0             	movzbl %al,%eax
c01036c8:	85 c0                	test   %eax,%eax
c01036ca:	74 0e                	je     c01036da <default_check+0x29c>
c01036cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036cf:	83 c0 28             	add    $0x28,%eax
c01036d2:	8b 40 08             	mov    0x8(%eax),%eax
c01036d5:	83 f8 03             	cmp    $0x3,%eax
c01036d8:	74 24                	je     c01036fe <default_check+0x2c0>
c01036da:	c7 44 24 0c 5c 68 10 	movl   $0xc010685c,0xc(%esp)
c01036e1:	c0 
c01036e2:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01036e9:	c0 
c01036ea:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01036f1:	00 
c01036f2:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01036f9:	e8 ea d5 ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01036fe:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103705:	e8 f8 06 00 00       	call   c0103e02 <alloc_pages>
c010370a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010370d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103711:	75 24                	jne    c0103737 <default_check+0x2f9>
c0103713:	c7 44 24 0c 88 68 10 	movl   $0xc0106888,0xc(%esp)
c010371a:	c0 
c010371b:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103722:	c0 
c0103723:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010372a:	00 
c010372b:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103732:	e8 b1 d5 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103737:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010373e:	e8 bf 06 00 00       	call   c0103e02 <alloc_pages>
c0103743:	85 c0                	test   %eax,%eax
c0103745:	74 24                	je     c010376b <default_check+0x32d>
c0103747:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c010374e:	c0 
c010374f:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103756:	c0 
c0103757:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010375e:	00 
c010375f:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103766:	e8 7d d5 ff ff       	call   c0100ce8 <__panic>
    assert(p0 + 2 == p1);
c010376b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010376e:	83 c0 28             	add    $0x28,%eax
c0103771:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103774:	74 24                	je     c010379a <default_check+0x35c>
c0103776:	c7 44 24 0c a6 68 10 	movl   $0xc01068a6,0xc(%esp)
c010377d:	c0 
c010377e:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103785:	c0 
c0103786:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010378d:	00 
c010378e:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103795:	e8 4e d5 ff ff       	call   c0100ce8 <__panic>

    p2 = p0 + 1;
c010379a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010379d:	83 c0 14             	add    $0x14,%eax
c01037a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01037a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037aa:	00 
c01037ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037ae:	89 04 24             	mov    %eax,(%esp)
c01037b1:	e8 86 06 00 00       	call   c0103e3c <free_pages>
    free_pages(p1, 3);
c01037b6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037bd:	00 
c01037be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037c1:	89 04 24             	mov    %eax,(%esp)
c01037c4:	e8 73 06 00 00       	call   c0103e3c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01037c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037cc:	83 c0 04             	add    $0x4,%eax
c01037cf:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037d6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037dc:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037df:	0f a3 10             	bt     %edx,(%eax)
c01037e2:	19 c0                	sbb    %eax,%eax
c01037e4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01037e7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01037eb:	0f 95 c0             	setne  %al
c01037ee:	0f b6 c0             	movzbl %al,%eax
c01037f1:	85 c0                	test   %eax,%eax
c01037f3:	74 0b                	je     c0103800 <default_check+0x3c2>
c01037f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037f8:	8b 40 08             	mov    0x8(%eax),%eax
c01037fb:	83 f8 01             	cmp    $0x1,%eax
c01037fe:	74 24                	je     c0103824 <default_check+0x3e6>
c0103800:	c7 44 24 0c b4 68 10 	movl   $0xc01068b4,0xc(%esp)
c0103807:	c0 
c0103808:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010380f:	c0 
c0103810:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103817:	00 
c0103818:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010381f:	e8 c4 d4 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103824:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103827:	83 c0 04             	add    $0x4,%eax
c010382a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103831:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103834:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103837:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010383a:	0f a3 10             	bt     %edx,(%eax)
c010383d:	19 c0                	sbb    %eax,%eax
c010383f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103842:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103846:	0f 95 c0             	setne  %al
c0103849:	0f b6 c0             	movzbl %al,%eax
c010384c:	85 c0                	test   %eax,%eax
c010384e:	74 0b                	je     c010385b <default_check+0x41d>
c0103850:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103853:	8b 40 08             	mov    0x8(%eax),%eax
c0103856:	83 f8 03             	cmp    $0x3,%eax
c0103859:	74 24                	je     c010387f <default_check+0x441>
c010385b:	c7 44 24 0c dc 68 10 	movl   $0xc01068dc,0xc(%esp)
c0103862:	c0 
c0103863:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010386a:	c0 
c010386b:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0103872:	00 
c0103873:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010387a:	e8 69 d4 ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010387f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103886:	e8 77 05 00 00       	call   c0103e02 <alloc_pages>
c010388b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010388e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103891:	83 e8 14             	sub    $0x14,%eax
c0103894:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103897:	74 24                	je     c01038bd <default_check+0x47f>
c0103899:	c7 44 24 0c 02 69 10 	movl   $0xc0106902,0xc(%esp)
c01038a0:	c0 
c01038a1:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01038a8:	c0 
c01038a9:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01038b0:	00 
c01038b1:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01038b8:	e8 2b d4 ff ff       	call   c0100ce8 <__panic>
    free_page(p0);
c01038bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038c4:	00 
c01038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038c8:	89 04 24             	mov    %eax,(%esp)
c01038cb:	e8 6c 05 00 00       	call   c0103e3c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01038d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01038d7:	e8 26 05 00 00       	call   c0103e02 <alloc_pages>
c01038dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01038df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038e2:	83 c0 14             	add    $0x14,%eax
c01038e5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01038e8:	74 24                	je     c010390e <default_check+0x4d0>
c01038ea:	c7 44 24 0c 20 69 10 	movl   $0xc0106920,0xc(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01038f9:	c0 
c01038fa:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103901:	00 
c0103902:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103909:	e8 da d3 ff ff       	call   c0100ce8 <__panic>

    free_pages(p0, 2);
c010390e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103915:	00 
c0103916:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103919:	89 04 24             	mov    %eax,(%esp)
c010391c:	e8 1b 05 00 00       	call   c0103e3c <free_pages>
    free_page(p2);
c0103921:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103928:	00 
c0103929:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010392c:	89 04 24             	mov    %eax,(%esp)
c010392f:	e8 08 05 00 00       	call   c0103e3c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103934:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010393b:	e8 c2 04 00 00       	call   c0103e02 <alloc_pages>
c0103940:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103943:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103947:	75 24                	jne    c010396d <default_check+0x52f>
c0103949:	c7 44 24 0c 40 69 10 	movl   $0xc0106940,0xc(%esp)
c0103950:	c0 
c0103951:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103958:	c0 
c0103959:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0103960:	00 
c0103961:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103968:	e8 7b d3 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c010396d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103974:	e8 89 04 00 00       	call   c0103e02 <alloc_pages>
c0103979:	85 c0                	test   %eax,%eax
c010397b:	74 24                	je     c01039a1 <default_check+0x563>
c010397d:	c7 44 24 0c 9e 67 10 	movl   $0xc010679e,0xc(%esp)
c0103984:	c0 
c0103985:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010398c:	c0 
c010398d:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103994:	00 
c0103995:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010399c:	e8 47 d3 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c01039a1:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01039a6:	85 c0                	test   %eax,%eax
c01039a8:	74 24                	je     c01039ce <default_check+0x590>
c01039aa:	c7 44 24 0c f1 67 10 	movl   $0xc01067f1,0xc(%esp)
c01039b1:	c0 
c01039b2:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01039b9:	c0 
c01039ba:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01039c1:	00 
c01039c2:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01039c9:	e8 1a d3 ff ff       	call   c0100ce8 <__panic>
    nr_free = nr_free_store;
c01039ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039d1:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c01039d6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01039d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039dc:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01039e1:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c01039e7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01039ee:	00 
c01039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039f2:	89 04 24             	mov    %eax,(%esp)
c01039f5:	e8 42 04 00 00       	call   c0103e3c <free_pages>

    le = &free_list;
c01039fa:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103a01:	eb 5a                	jmp    c0103a5d <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a06:	8b 40 04             	mov    0x4(%eax),%eax
c0103a09:	8b 00                	mov    (%eax),%eax
c0103a0b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103a0e:	75 0d                	jne    c0103a1d <default_check+0x5df>
c0103a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a13:	8b 00                	mov    (%eax),%eax
c0103a15:	8b 40 04             	mov    0x4(%eax),%eax
c0103a18:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103a1b:	74 24                	je     c0103a41 <default_check+0x603>
c0103a1d:	c7 44 24 0c 60 69 10 	movl   $0xc0106960,0xc(%esp)
c0103a24:	c0 
c0103a25:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103a2c:	c0 
c0103a2d:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0103a34:	00 
c0103a35:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103a3c:	e8 a7 d2 ff ff       	call   c0100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
c0103a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a44:	83 e8 0c             	sub    $0xc,%eax
c0103a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103a4a:	ff 4d f4             	decl   -0xc(%ebp)
c0103a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a53:	8b 48 08             	mov    0x8(%eax),%ecx
c0103a56:	89 d0                	mov    %edx,%eax
c0103a58:	29 c8                	sub    %ecx,%eax
c0103a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a60:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103a63:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103a66:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a6c:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103a73:	75 8e                	jne    c0103a03 <default_check+0x5c5>
    }
    assert(count == 0);
c0103a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a79:	74 24                	je     c0103a9f <default_check+0x661>
c0103a7b:	c7 44 24 0c 8d 69 10 	movl   $0xc010698d,0xc(%esp)
c0103a82:	c0 
c0103a83:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103a8a:	c0 
c0103a8b:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0103a92:	00 
c0103a93:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103a9a:	e8 49 d2 ff ff       	call   c0100ce8 <__panic>
    assert(total == 0);
c0103a9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aa3:	74 24                	je     c0103ac9 <default_check+0x68b>
c0103aa5:	c7 44 24 0c 98 69 10 	movl   $0xc0106998,0xc(%esp)
c0103aac:	c0 
c0103aad:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103ab4:	c0 
c0103ab5:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103abc:	00 
c0103abd:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103ac4:	e8 1f d2 ff ff       	call   c0100ce8 <__panic>
}
c0103ac9:	90                   	nop
c0103aca:	89 ec                	mov    %ebp,%esp
c0103acc:	5d                   	pop    %ebp
c0103acd:	c3                   	ret    

c0103ace <page2ppn>:
page2ppn(struct Page *page) {
c0103ace:	55                   	push   %ebp
c0103acf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103ad1:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0103ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ada:	29 d0                	sub    %edx,%eax
c0103adc:	c1 f8 02             	sar    $0x2,%eax
c0103adf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103ae5:	5d                   	pop    %ebp
c0103ae6:	c3                   	ret    

c0103ae7 <page2pa>:
page2pa(struct Page *page) {
c0103ae7:	55                   	push   %ebp
c0103ae8:	89 e5                	mov    %esp,%ebp
c0103aea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af0:	89 04 24             	mov    %eax,(%esp)
c0103af3:	e8 d6 ff ff ff       	call   c0103ace <page2ppn>
c0103af8:	c1 e0 0c             	shl    $0xc,%eax
}
c0103afb:	89 ec                	mov    %ebp,%esp
c0103afd:	5d                   	pop    %ebp
c0103afe:	c3                   	ret    

c0103aff <pa2page>:
pa2page(uintptr_t pa) {
c0103aff:	55                   	push   %ebp
c0103b00:	89 e5                	mov    %esp,%ebp
c0103b02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b08:	c1 e8 0c             	shr    $0xc,%eax
c0103b0b:	89 c2                	mov    %eax,%edx
c0103b0d:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103b12:	39 c2                	cmp    %eax,%edx
c0103b14:	72 1c                	jb     c0103b32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103b16:	c7 44 24 08 d4 69 10 	movl   $0xc01069d4,0x8(%esp)
c0103b1d:	c0 
c0103b1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103b25:	00 
c0103b26:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0103b2d:	e8 b6 d1 ff ff       	call   c0100ce8 <__panic>
    return &pages[PPN(pa)];
c0103b32:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3b:	c1 e8 0c             	shr    $0xc,%eax
c0103b3e:	89 c2                	mov    %eax,%edx
c0103b40:	89 d0                	mov    %edx,%eax
c0103b42:	c1 e0 02             	shl    $0x2,%eax
c0103b45:	01 d0                	add    %edx,%eax
c0103b47:	c1 e0 02             	shl    $0x2,%eax
c0103b4a:	01 c8                	add    %ecx,%eax
}
c0103b4c:	89 ec                	mov    %ebp,%esp
c0103b4e:	5d                   	pop    %ebp
c0103b4f:	c3                   	ret    

c0103b50 <page2kva>:
page2kva(struct Page *page) {
c0103b50:	55                   	push   %ebp
c0103b51:	89 e5                	mov    %esp,%ebp
c0103b53:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b59:	89 04 24             	mov    %eax,(%esp)
c0103b5c:	e8 86 ff ff ff       	call   c0103ae7 <page2pa>
c0103b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b67:	c1 e8 0c             	shr    $0xc,%eax
c0103b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b6d:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103b72:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b75:	72 23                	jb     c0103b9a <page2kva+0x4a>
c0103b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b7e:	c7 44 24 08 04 6a 10 	movl   $0xc0106a04,0x8(%esp)
c0103b85:	c0 
c0103b86:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b8d:	00 
c0103b8e:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0103b95:	e8 4e d1 ff ff       	call   c0100ce8 <__panic>
c0103b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b9d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ba2:	89 ec                	mov    %ebp,%esp
c0103ba4:	5d                   	pop    %ebp
c0103ba5:	c3                   	ret    

c0103ba6 <pte2page>:
pte2page(pte_t pte) {
c0103ba6:	55                   	push   %ebp
c0103ba7:	89 e5                	mov    %esp,%ebp
c0103ba9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0103baf:	83 e0 01             	and    $0x1,%eax
c0103bb2:	85 c0                	test   %eax,%eax
c0103bb4:	75 1c                	jne    c0103bd2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103bb6:	c7 44 24 08 28 6a 10 	movl   $0xc0106a28,0x8(%esp)
c0103bbd:	c0 
c0103bbe:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103bc5:	00 
c0103bc6:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0103bcd:	e8 16 d1 ff ff       	call   c0100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bda:	89 04 24             	mov    %eax,(%esp)
c0103bdd:	e8 1d ff ff ff       	call   c0103aff <pa2page>
}
c0103be2:	89 ec                	mov    %ebp,%esp
c0103be4:	5d                   	pop    %ebp
c0103be5:	c3                   	ret    

c0103be6 <pde2page>:
pde2page(pde_t pde) {
c0103be6:	55                   	push   %ebp
c0103be7:	89 e5                	mov    %esp,%ebp
c0103be9:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bf4:	89 04 24             	mov    %eax,(%esp)
c0103bf7:	e8 03 ff ff ff       	call   c0103aff <pa2page>
}
c0103bfc:	89 ec                	mov    %ebp,%esp
c0103bfe:	5d                   	pop    %ebp
c0103bff:	c3                   	ret    

c0103c00 <page_ref>:
page_ref(struct Page *page) {
c0103c00:	55                   	push   %ebp
c0103c01:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c06:	8b 00                	mov    (%eax),%eax
}
c0103c08:	5d                   	pop    %ebp
c0103c09:	c3                   	ret    

c0103c0a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103c0a:	55                   	push   %ebp
c0103c0b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c10:	8b 00                	mov    (%eax),%eax
c0103c12:	8d 50 01             	lea    0x1(%eax),%edx
c0103c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c18:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c1d:	8b 00                	mov    (%eax),%eax
}
c0103c1f:	5d                   	pop    %ebp
c0103c20:	c3                   	ret    

c0103c21 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103c21:	55                   	push   %ebp
c0103c22:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c27:	8b 00                	mov    (%eax),%eax
c0103c29:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c2f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c34:	8b 00                	mov    (%eax),%eax
}
c0103c36:	5d                   	pop    %ebp
c0103c37:	c3                   	ret    

c0103c38 <__intr_save>:
__intr_save(void) {
c0103c38:	55                   	push   %ebp
c0103c39:	89 e5                	mov    %esp,%ebp
c0103c3b:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103c3e:	9c                   	pushf  
c0103c3f:	58                   	pop    %eax
c0103c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103c46:	25 00 02 00 00       	and    $0x200,%eax
c0103c4b:	85 c0                	test   %eax,%eax
c0103c4d:	74 0c                	je     c0103c5b <__intr_save+0x23>
        intr_disable();
c0103c4f:	e8 ed da ff ff       	call   c0101741 <intr_disable>
        return 1;
c0103c54:	b8 01 00 00 00       	mov    $0x1,%eax
c0103c59:	eb 05                	jmp    c0103c60 <__intr_save+0x28>
    return 0;
c0103c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103c60:	89 ec                	mov    %ebp,%esp
c0103c62:	5d                   	pop    %ebp
c0103c63:	c3                   	ret    

c0103c64 <__intr_restore>:
__intr_restore(bool flag) {
c0103c64:	55                   	push   %ebp
c0103c65:	89 e5                	mov    %esp,%ebp
c0103c67:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103c6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103c6e:	74 05                	je     c0103c75 <__intr_restore+0x11>
        intr_enable();
c0103c70:	e8 c4 da ff ff       	call   c0101739 <intr_enable>
}
c0103c75:	90                   	nop
c0103c76:	89 ec                	mov    %ebp,%esp
c0103c78:	5d                   	pop    %ebp
c0103c79:	c3                   	ret    

c0103c7a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c7a:	55                   	push   %ebp
c0103c7b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c80:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c83:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c88:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c8a:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c8f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c91:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c96:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c98:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c9d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c9f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ca4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103ca6:	ea ad 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103cad
}
c0103cad:	90                   	nop
c0103cae:	5d                   	pop    %ebp
c0103caf:	c3                   	ret    

c0103cb0 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103cb0:	55                   	push   %ebp
c0103cb1:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103cb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cb6:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103cbb:	90                   	nop
c0103cbc:	5d                   	pop    %ebp
c0103cbd:	c3                   	ret    

c0103cbe <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103cbe:	55                   	push   %ebp
c0103cbf:	89 e5                	mov    %esp,%ebp
c0103cc1:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103cc4:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103cc9:	89 04 24             	mov    %eax,(%esp)
c0103ccc:	e8 df ff ff ff       	call   c0103cb0 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103cd1:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103cd8:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103cda:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103ce1:	68 00 
c0103ce3:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103ce8:	0f b7 c0             	movzwl %ax,%eax
c0103ceb:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103cf1:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103cf6:	c1 e8 10             	shr    $0x10,%eax
c0103cf9:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103cfe:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d05:	24 f0                	and    $0xf0,%al
c0103d07:	0c 09                	or     $0x9,%al
c0103d09:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d0e:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d15:	24 ef                	and    $0xef,%al
c0103d17:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d1c:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d23:	24 9f                	and    $0x9f,%al
c0103d25:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d2a:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d31:	0c 80                	or     $0x80,%al
c0103d33:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d38:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d3f:	24 f0                	and    $0xf0,%al
c0103d41:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d46:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d4d:	24 ef                	and    $0xef,%al
c0103d4f:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d54:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d5b:	24 df                	and    $0xdf,%al
c0103d5d:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d62:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d69:	0c 40                	or     $0x40,%al
c0103d6b:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d70:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d77:	24 7f                	and    $0x7f,%al
c0103d79:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d7e:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103d83:	c1 e8 18             	shr    $0x18,%eax
c0103d86:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d8b:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103d92:	e8 e3 fe ff ff       	call   c0103c7a <lgdt>
c0103d97:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d9d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103da1:	0f 00 d8             	ltr    %ax
}
c0103da4:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103da5:	90                   	nop
c0103da6:	89 ec                	mov    %ebp,%esp
c0103da8:	5d                   	pop    %ebp
c0103da9:	c3                   	ret    

c0103daa <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103daa:	55                   	push   %ebp
c0103dab:	89 e5                	mov    %esp,%ebp
c0103dad:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103db0:	c7 05 ac be 11 c0 b8 	movl   $0xc01069b8,0xc011beac
c0103db7:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103dba:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103dbf:	8b 00                	mov    (%eax),%eax
c0103dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dc5:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0103dcc:	e8 85 c5 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103dd1:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103dd6:	8b 40 04             	mov    0x4(%eax),%eax
c0103dd9:	ff d0                	call   *%eax
}
c0103ddb:	90                   	nop
c0103ddc:	89 ec                	mov    %ebp,%esp
c0103dde:	5d                   	pop    %ebp
c0103ddf:	c3                   	ret    

c0103de0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103de0:	55                   	push   %ebp
c0103de1:	89 e5                	mov    %esp,%ebp
c0103de3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103de6:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103deb:	8b 40 08             	mov    0x8(%eax),%eax
c0103dee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103df1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103df5:	8b 55 08             	mov    0x8(%ebp),%edx
c0103df8:	89 14 24             	mov    %edx,(%esp)
c0103dfb:	ff d0                	call   *%eax
}
c0103dfd:	90                   	nop
c0103dfe:	89 ec                	mov    %ebp,%esp
c0103e00:	5d                   	pop    %ebp
c0103e01:	c3                   	ret    

c0103e02 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103e02:	55                   	push   %ebp
c0103e03:	89 e5                	mov    %esp,%ebp
c0103e05:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103e08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e0f:	e8 24 fe ff ff       	call   c0103c38 <__intr_save>
c0103e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103e17:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e1c:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e1f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e22:	89 14 24             	mov    %edx,(%esp)
c0103e25:	ff d0                	call   *%eax
c0103e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e2d:	89 04 24             	mov    %eax,(%esp)
c0103e30:	e8 2f fe ff ff       	call   c0103c64 <__intr_restore>
    return page;
c0103e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103e38:	89 ec                	mov    %ebp,%esp
c0103e3a:	5d                   	pop    %ebp
c0103e3b:	c3                   	ret    

c0103e3c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103e3c:	55                   	push   %ebp
c0103e3d:	89 e5                	mov    %esp,%ebp
c0103e3f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e42:	e8 f1 fd ff ff       	call   c0103c38 <__intr_save>
c0103e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103e4a:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e4f:	8b 40 10             	mov    0x10(%eax),%eax
c0103e52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e55:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e59:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e5c:	89 14 24             	mov    %edx,(%esp)
c0103e5f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e64:	89 04 24             	mov    %eax,(%esp)
c0103e67:	e8 f8 fd ff ff       	call   c0103c64 <__intr_restore>
}
c0103e6c:	90                   	nop
c0103e6d:	89 ec                	mov    %ebp,%esp
c0103e6f:	5d                   	pop    %ebp
c0103e70:	c3                   	ret    

c0103e71 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103e71:	55                   	push   %ebp
c0103e72:	89 e5                	mov    %esp,%ebp
c0103e74:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e77:	e8 bc fd ff ff       	call   c0103c38 <__intr_save>
c0103e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103e7f:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e84:	8b 40 14             	mov    0x14(%eax),%eax
c0103e87:	ff d0                	call   *%eax
c0103e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e8f:	89 04 24             	mov    %eax,(%esp)
c0103e92:	e8 cd fd ff ff       	call   c0103c64 <__intr_restore>
    return ret;
c0103e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e9a:	89 ec                	mov    %ebp,%esp
c0103e9c:	5d                   	pop    %ebp
c0103e9d:	c3                   	ret    

c0103e9e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e9e:	55                   	push   %ebp
c0103e9f:	89 e5                	mov    %esp,%ebp
c0103ea1:	57                   	push   %edi
c0103ea2:	56                   	push   %esi
c0103ea3:	53                   	push   %ebx
c0103ea4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103eaa:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
c0103eb1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103eb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103ebf:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103ec6:	e8 8b c4 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ecb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ed2:	e9 0c 01 00 00       	jmp    c0103fe3 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103ed7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103edd:	89 d0                	mov    %edx,%eax
c0103edf:	c1 e0 02             	shl    $0x2,%eax
c0103ee2:	01 d0                	add    %edx,%eax
c0103ee4:	c1 e0 02             	shl    $0x2,%eax
c0103ee7:	01 c8                	add    %ecx,%eax
c0103ee9:	8b 50 08             	mov    0x8(%eax),%edx
c0103eec:	8b 40 04             	mov    0x4(%eax),%eax
c0103eef:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103ef2:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103ef5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103ef8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103efb:	89 d0                	mov    %edx,%eax
c0103efd:	c1 e0 02             	shl    $0x2,%eax
c0103f00:	01 d0                	add    %edx,%eax
c0103f02:	c1 e0 02             	shl    $0x2,%eax
c0103f05:	01 c8                	add    %ecx,%eax
c0103f07:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f0a:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f0d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f10:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f13:	01 c8                	add    %ecx,%eax
c0103f15:	11 da                	adc    %ebx,%edx
c0103f17:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103f1a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103f1d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103f20:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f23:	89 d0                	mov    %edx,%eax
c0103f25:	c1 e0 02             	shl    $0x2,%eax
c0103f28:	01 d0                	add    %edx,%eax
c0103f2a:	c1 e0 02             	shl    $0x2,%eax
c0103f2d:	01 c8                	add    %ecx,%eax
c0103f2f:	83 c0 14             	add    $0x14,%eax
c0103f32:	8b 00                	mov    (%eax),%eax
c0103f34:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103f3a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f3d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103f40:	83 c0 ff             	add    $0xffffffff,%eax
c0103f43:	83 d2 ff             	adc    $0xffffffff,%edx
c0103f46:	89 c6                	mov    %eax,%esi
c0103f48:	89 d7                	mov    %edx,%edi
c0103f4a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103f4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f50:	89 d0                	mov    %edx,%eax
c0103f52:	c1 e0 02             	shl    $0x2,%eax
c0103f55:	01 d0                	add    %edx,%eax
c0103f57:	c1 e0 02             	shl    $0x2,%eax
c0103f5a:	01 c8                	add    %ecx,%eax
c0103f5c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f5f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f62:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103f68:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103f6c:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103f70:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103f74:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f77:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f7e:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f86:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f8a:	c7 04 24 78 6a 10 c0 	movl   $0xc0106a78,(%esp)
c0103f91:	e8 c0 c3 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f96:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103f99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f9c:	89 d0                	mov    %edx,%eax
c0103f9e:	c1 e0 02             	shl    $0x2,%eax
c0103fa1:	01 d0                	add    %edx,%eax
c0103fa3:	c1 e0 02             	shl    $0x2,%eax
c0103fa6:	01 c8                	add    %ecx,%eax
c0103fa8:	83 c0 14             	add    $0x14,%eax
c0103fab:	8b 00                	mov    (%eax),%eax
c0103fad:	83 f8 01             	cmp    $0x1,%eax
c0103fb0:	75 2e                	jne    c0103fe0 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0103fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fb8:	3b 45 a0             	cmp    -0x60(%ebp),%eax
c0103fbb:	89 d0                	mov    %edx,%eax
c0103fbd:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103fc0:	73 1e                	jae    c0103fe0 <page_init+0x142>
c0103fc2:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103fc7:	b8 00 00 00 00       	mov    $0x0,%eax
c0103fcc:	3b 55 a8             	cmp    -0x58(%ebp),%edx
c0103fcf:	1b 45 ac             	sbb    -0x54(%ebp),%eax
c0103fd2:	72 0c                	jb     c0103fe0 <page_init+0x142>
                maxpa = end;
c0103fd4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103fd7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103fda:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103fdd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fe0:	ff 45 dc             	incl   -0x24(%ebp)
c0103fe3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103fe6:	8b 00                	mov    (%eax),%eax
c0103fe8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103feb:	0f 8c e6 fe ff ff    	jl     c0103ed7 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103ff1:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103ff6:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ffb:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103ffe:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104001:	73 0e                	jae    c0104011 <page_init+0x173>
        maxpa = KMEMSIZE;
c0104003:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010400a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104011:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104014:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104017:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010401b:	c1 ea 0c             	shr    $0xc,%edx
c010401e:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104023:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
c010402a:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c010402f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104032:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104035:	01 d0                	add    %edx,%eax
c0104037:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010403a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010403d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104042:	f7 75 c8             	divl   -0x38(%ebp)
c0104045:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104048:	29 d0                	sub    %edx,%eax
c010404a:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c010404f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104056:	eb 2f                	jmp    c0104087 <page_init+0x1e9>
        SetPageReserved(pages + i);
c0104058:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c010405e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104061:	89 d0                	mov    %edx,%eax
c0104063:	c1 e0 02             	shl    $0x2,%eax
c0104066:	01 d0                	add    %edx,%eax
c0104068:	c1 e0 02             	shl    $0x2,%eax
c010406b:	01 c8                	add    %ecx,%eax
c010406d:	83 c0 04             	add    $0x4,%eax
c0104070:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
c0104077:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010407a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010407d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104080:	0f ab 10             	bts    %edx,(%eax)
}
c0104083:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104084:	ff 45 dc             	incl   -0x24(%ebp)
c0104087:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010408a:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010408f:	39 c2                	cmp    %eax,%edx
c0104091:	72 c5                	jb     c0104058 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104093:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0104099:	89 d0                	mov    %edx,%eax
c010409b:	c1 e0 02             	shl    $0x2,%eax
c010409e:	01 d0                	add    %edx,%eax
c01040a0:	c1 e0 02             	shl    $0x2,%eax
c01040a3:	89 c2                	mov    %eax,%edx
c01040a5:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c01040aa:	01 d0                	add    %edx,%eax
c01040ac:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01040af:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
c01040b6:	77 23                	ja     c01040db <page_init+0x23d>
c01040b8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01040bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040bf:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c01040c6:	c0 
c01040c7:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01040ce:	00 
c01040cf:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01040d6:	e8 0d cc ff ff       	call   c0100ce8 <__panic>
c01040db:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01040de:	05 00 00 00 40       	add    $0x40000000,%eax
c01040e3:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01040e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01040ed:	e9 e8 01 00 00       	jmp    c01042da <page_init+0x43c>

        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01040f2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01040f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040f8:	89 d0                	mov    %edx,%eax
c01040fa:	c1 e0 02             	shl    $0x2,%eax
c01040fd:	01 d0                	add    %edx,%eax
c01040ff:	c1 e0 02             	shl    $0x2,%eax
c0104102:	01 c8                	add    %ecx,%eax
c0104104:	8b 50 08             	mov    0x8(%eax),%edx
c0104107:	8b 40 04             	mov    0x4(%eax),%eax
c010410a:	89 45 90             	mov    %eax,-0x70(%ebp)
c010410d:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0104110:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104113:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104116:	89 d0                	mov    %edx,%eax
c0104118:	c1 e0 02             	shl    $0x2,%eax
c010411b:	01 d0                	add    %edx,%eax
c010411d:	c1 e0 02             	shl    $0x2,%eax
c0104120:	01 c8                	add    %ecx,%eax
c0104122:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104125:	8b 58 10             	mov    0x10(%eax),%ebx
c0104128:	8b 45 90             	mov    -0x70(%ebp),%eax
c010412b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010412e:	01 c8                	add    %ecx,%eax
c0104130:	11 da                	adc    %ebx,%edx
c0104132:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104135:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        cprintf("memory: %08llx,%08llx\n",begin,&begin);
c0104138:	8b 45 90             	mov    -0x70(%ebp),%eax
c010413b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010413e:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c0104141:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104145:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104149:	89 54 24 08          	mov    %edx,0x8(%esp)
c010414d:	c7 04 24 da 6a 10 c0 	movl   $0xc0106ada,(%esp)
c0104154:	e8 fd c1 ff ff       	call   c0100356 <cprintf>
        if (memmap->map[i].type == E820_ARM) {
c0104159:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010415c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010415f:	89 d0                	mov    %edx,%eax
c0104161:	c1 e0 02             	shl    $0x2,%eax
c0104164:	01 d0                	add    %edx,%eax
c0104166:	c1 e0 02             	shl    $0x2,%eax
c0104169:	01 c8                	add    %ecx,%eax
c010416b:	83 c0 14             	add    $0x14,%eax
c010416e:	8b 00                	mov    (%eax),%eax
c0104170:	83 f8 01             	cmp    $0x1,%eax
c0104173:	0f 85 5e 01 00 00    	jne    c01042d7 <page_init+0x439>
            if (begin < freemem) {
c0104179:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c010417c:	bb 00 00 00 00       	mov    $0x0,%ebx
c0104181:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104184:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104187:	39 c8                	cmp    %ecx,%eax
c0104189:	89 d0                	mov    %edx,%eax
c010418b:	19 d8                	sbb    %ebx,%eax
c010418d:	73 0e                	jae    c010419d <page_init+0x2ff>
                begin = freemem;
c010418f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104192:	ba 00 00 00 00       	mov    $0x0,%edx
c0104197:	89 45 90             	mov    %eax,-0x70(%ebp)
c010419a:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
c010419d:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01041a2:	b8 00 00 00 00       	mov    $0x0,%eax
c01041a7:	3b 55 d0             	cmp    -0x30(%ebp),%edx
c01041aa:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01041ad:	73 0e                	jae    c01041bd <page_init+0x31f>
                end = KMEMSIZE;
c01041af:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
c01041b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
c01041bd:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01041c6:	89 d0                	mov    %edx,%eax
c01041c8:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01041cb:	0f 83 06 01 00 00    	jae    c01042d7 <page_init+0x439>
                cprintf("memory: %08llx,%08llx\n",begin,&begin);
c01041d1:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041d4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041d7:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c01041da:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01041de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01041e6:	c7 04 24 da 6a 10 c0 	movl   $0xc0106ada,(%esp)
c01041ed:	e8 64 c1 ff ff       	call   c0100356 <cprintf>
                begin = ROUNDUP(begin, PGSIZE);
c01041f2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
c01041f9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041fc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041ff:	89 c2                	mov    %eax,%edx
c0104201:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104204:	01 d0                	add    %edx,%eax
c0104206:	48                   	dec    %eax
c0104207:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010420a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010420d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104212:	f7 75 b8             	divl   -0x48(%ebp)
c0104215:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104218:	29 d0                	sub    %edx,%eax
c010421a:	ba 00 00 00 00       	mov    $0x0,%edx
c010421f:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104222:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104225:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104228:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010422b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010422e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104233:	89 c7                	mov    %eax,%edi
c0104235:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010423b:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010423e:	89 d0                	mov    %edx,%eax
c0104240:	83 e0 00             	and    $0x0,%eax
c0104243:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104246:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104249:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010424c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010424f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                cprintf("memory: %08llx,%08llx\n",begin,&begin);
c0104252:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104255:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104258:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c010425b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010425f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104263:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104267:	c7 04 24 da 6a 10 c0 	movl   $0xc0106ada,(%esp)
c010426e:	e8 e3 c0 ff ff       	call   c0100356 <cprintf>
                if (begin < end) {
c0104273:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104276:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104279:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010427c:	89 d0                	mov    %edx,%eax
c010427e:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c0104281:	73 54                	jae    c01042d7 <page_init+0x439>

                    cprintf("memory: %08llx,%08llx\n",begin,&begin);
c0104283:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104286:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104289:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c010428c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104290:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104294:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104298:	c7 04 24 da 6a 10 c0 	movl   $0xc0106ada,(%esp)
c010429f:	e8 b2 c0 ff ff       	call   c0100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01042a4:	8b 4d 90             	mov    -0x70(%ebp),%ecx
c01042a7:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
c01042aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042b0:	29 c8                	sub    %ecx,%eax
c01042b2:	19 da                	sbb    %ebx,%edx
c01042b4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01042b8:	c1 ea 0c             	shr    $0xc,%edx
c01042bb:	89 c3                	mov    %eax,%ebx
c01042bd:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042c3:	89 04 24             	mov    %eax,(%esp)
c01042c6:	e8 34 f8 ff ff       	call   c0103aff <pa2page>
c01042cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01042cf:	89 04 24             	mov    %eax,(%esp)
c01042d2:	e8 09 fb ff ff       	call   c0103de0 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01042d7:	ff 45 dc             	incl   -0x24(%ebp)
c01042da:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01042dd:	8b 00                	mov    (%eax),%eax
c01042df:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01042e2:	0f 8c 0a fe ff ff    	jl     c01040f2 <page_init+0x254>
                }
            }
        }
    }
}
c01042e8:	90                   	nop
c01042e9:	90                   	nop
c01042ea:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01042f0:	5b                   	pop    %ebx
c01042f1:	5e                   	pop    %esi
c01042f2:	5f                   	pop    %edi
c01042f3:	5d                   	pop    %ebp
c01042f4:	c3                   	ret    

c01042f5 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01042f5:	55                   	push   %ebp
c01042f6:	89 e5                	mov    %esp,%ebp
c01042f8:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01042fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fe:	33 45 14             	xor    0x14(%ebp),%eax
c0104301:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104306:	85 c0                	test   %eax,%eax
c0104308:	74 24                	je     c010432e <boot_map_segment+0x39>
c010430a:	c7 44 24 0c f1 6a 10 	movl   $0xc0106af1,0xc(%esp)
c0104311:	c0 
c0104312:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104319:	c0 
c010431a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104321:	00 
c0104322:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104329:	e8 ba c9 ff ff       	call   c0100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010432e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104335:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104338:	25 ff 0f 00 00       	and    $0xfff,%eax
c010433d:	89 c2                	mov    %eax,%edx
c010433f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104342:	01 c2                	add    %eax,%edx
c0104344:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104347:	01 d0                	add    %edx,%eax
c0104349:	48                   	dec    %eax
c010434a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010434d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104350:	ba 00 00 00 00       	mov    $0x0,%edx
c0104355:	f7 75 f0             	divl   -0x10(%ebp)
c0104358:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010435b:	29 d0                	sub    %edx,%eax
c010435d:	c1 e8 0c             	shr    $0xc,%eax
c0104360:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104363:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104366:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104369:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010436c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104371:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104374:	8b 45 14             	mov    0x14(%ebp),%eax
c0104377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010437a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010437d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104382:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104385:	eb 68                	jmp    c01043ef <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104387:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010438e:	00 
c010438f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104392:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104396:	8b 45 08             	mov    0x8(%ebp),%eax
c0104399:	89 04 24             	mov    %eax,(%esp)
c010439c:	e8 88 01 00 00       	call   c0104529 <get_pte>
c01043a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01043a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01043a8:	75 24                	jne    c01043ce <boot_map_segment+0xd9>
c01043aa:	c7 44 24 0c 1d 6b 10 	movl   $0xc0106b1d,0xc(%esp)
c01043b1:	c0 
c01043b2:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c01043b9:	c0 
c01043ba:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01043c1:	00 
c01043c2:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01043c9:	e8 1a c9 ff ff       	call   c0100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
c01043ce:	8b 45 14             	mov    0x14(%ebp),%eax
c01043d1:	0b 45 18             	or     0x18(%ebp),%eax
c01043d4:	83 c8 01             	or     $0x1,%eax
c01043d7:	89 c2                	mov    %eax,%edx
c01043d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043dc:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01043de:	ff 4d f4             	decl   -0xc(%ebp)
c01043e1:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01043e8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01043ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043f3:	75 92                	jne    c0104387 <boot_map_segment+0x92>
    }
}
c01043f5:	90                   	nop
c01043f6:	90                   	nop
c01043f7:	89 ec                	mov    %ebp,%esp
c01043f9:	5d                   	pop    %ebp
c01043fa:	c3                   	ret    

c01043fb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01043fb:	55                   	push   %ebp
c01043fc:	89 e5                	mov    %esp,%ebp
c01043fe:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104401:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104408:	e8 f5 f9 ff ff       	call   c0103e02 <alloc_pages>
c010440d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104414:	75 1c                	jne    c0104432 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104416:	c7 44 24 08 2a 6b 10 	movl   $0xc0106b2a,0x8(%esp)
c010441d:	c0 
c010441e:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104425:	00 
c0104426:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010442d:	e8 b6 c8 ff ff       	call   c0100ce8 <__panic>
    }
    return page2kva(p);
c0104432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104435:	89 04 24             	mov    %eax,(%esp)
c0104438:	e8 13 f7 ff ff       	call   c0103b50 <page2kva>
}
c010443d:	89 ec                	mov    %ebp,%esp
c010443f:	5d                   	pop    %ebp
c0104440:	c3                   	ret    

c0104441 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104441:	55                   	push   %ebp
c0104442:	89 e5                	mov    %esp,%ebp
c0104444:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104447:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010444c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010444f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104456:	77 23                	ja     c010447b <pmm_init+0x3a>
c0104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010445f:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c0104466:	c0 
c0104467:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010446e:	00 
c010446f:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104476:	e8 6d c8 ff ff       	call   c0100ce8 <__panic>
c010447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010447e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104483:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104488:	e8 1d f9 ff ff       	call   c0103daa <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010448d:	e8 0c fa ff ff       	call   c0103e9e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104492:	e8 5a 02 00 00       	call   c01046f1 <check_alloc_page>

    check_pgdir();
c0104497:	e8 76 02 00 00       	call   c0104712 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010449c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044a4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01044ab:	77 23                	ja     c01044d0 <pmm_init+0x8f>
c01044ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044b4:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c01044bb:	c0 
c01044bc:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01044c3:	00 
c01044c4:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01044cb:	e8 18 c8 ff ff       	call   c0100ce8 <__panic>
c01044d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044d3:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01044d9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044de:	05 ac 0f 00 00       	add    $0xfac,%eax
c01044e3:	83 ca 03             	or     $0x3,%edx
c01044e6:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01044e8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044ed:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01044f4:	00 
c01044f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01044fc:	00 
c01044fd:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104504:	38 
c0104505:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010450c:	c0 
c010450d:	89 04 24             	mov    %eax,(%esp)
c0104510:	e8 e0 fd ff ff       	call   c01042f5 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104515:	e8 a4 f7 ff ff       	call   c0103cbe <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010451a:	e8 91 08 00 00       	call   c0104db0 <check_boot_pgdir>

    print_pgdir();
c010451f:	e8 0e 0d 00 00       	call   c0105232 <print_pgdir>

}
c0104524:	90                   	nop
c0104525:	89 ec                	mov    %ebp,%esp
c0104527:	5d                   	pop    %ebp
c0104528:	c3                   	ret    

c0104529 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104529:	55                   	push   %ebp
c010452a:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010452c:	90                   	nop
c010452d:	5d                   	pop    %ebp
c010452e:	c3                   	ret    

c010452f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010452f:	55                   	push   %ebp
c0104530:	89 e5                	mov    %esp,%ebp
c0104532:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104535:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010453c:	00 
c010453d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104540:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104544:	8b 45 08             	mov    0x8(%ebp),%eax
c0104547:	89 04 24             	mov    %eax,(%esp)
c010454a:	e8 da ff ff ff       	call   c0104529 <get_pte>
c010454f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104552:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104556:	74 08                	je     c0104560 <get_page+0x31>
        *ptep_store = ptep;
c0104558:	8b 45 10             	mov    0x10(%ebp),%eax
c010455b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010455e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104564:	74 1b                	je     c0104581 <get_page+0x52>
c0104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104569:	8b 00                	mov    (%eax),%eax
c010456b:	83 e0 01             	and    $0x1,%eax
c010456e:	85 c0                	test   %eax,%eax
c0104570:	74 0f                	je     c0104581 <get_page+0x52>
        return pte2page(*ptep);
c0104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104575:	8b 00                	mov    (%eax),%eax
c0104577:	89 04 24             	mov    %eax,(%esp)
c010457a:	e8 27 f6 ff ff       	call   c0103ba6 <pte2page>
c010457f:	eb 05                	jmp    c0104586 <get_page+0x57>
    }
    return NULL;
c0104581:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104586:	89 ec                	mov    %ebp,%esp
c0104588:	5d                   	pop    %ebp
c0104589:	c3                   	ret    

c010458a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010458a:	55                   	push   %ebp
c010458b:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c010458d:	90                   	nop
c010458e:	5d                   	pop    %ebp
c010458f:	c3                   	ret    

c0104590 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104590:	55                   	push   %ebp
c0104591:	89 e5                	mov    %esp,%ebp
c0104593:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104596:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010459d:	00 
c010459e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a8:	89 04 24             	mov    %eax,(%esp)
c01045ab:	e8 79 ff ff ff       	call   c0104529 <get_pte>
c01045b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01045b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01045b7:	74 19                	je     c01045d2 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01045b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045bc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ca:	89 04 24             	mov    %eax,(%esp)
c01045cd:	e8 b8 ff ff ff       	call   c010458a <page_remove_pte>
    }
}
c01045d2:	90                   	nop
c01045d3:	89 ec                	mov    %ebp,%esp
c01045d5:	5d                   	pop    %ebp
c01045d6:	c3                   	ret    

c01045d7 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01045d7:	55                   	push   %ebp
c01045d8:	89 e5                	mov    %esp,%ebp
c01045da:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01045dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045e4:	00 
c01045e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01045e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ef:	89 04 24             	mov    %eax,(%esp)
c01045f2:	e8 32 ff ff ff       	call   c0104529 <get_pte>
c01045f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01045fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045fe:	75 0a                	jne    c010460a <page_insert+0x33>
        return -E_NO_MEM;
c0104600:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104605:	e9 84 00 00 00       	jmp    c010468e <page_insert+0xb7>
    }
    page_ref_inc(page);
c010460a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010460d:	89 04 24             	mov    %eax,(%esp)
c0104610:	e8 f5 f5 ff ff       	call   c0103c0a <page_ref_inc>
    if (*ptep & PTE_P) {
c0104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104618:	8b 00                	mov    (%eax),%eax
c010461a:	83 e0 01             	and    $0x1,%eax
c010461d:	85 c0                	test   %eax,%eax
c010461f:	74 3e                	je     c010465f <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104624:	8b 00                	mov    (%eax),%eax
c0104626:	89 04 24             	mov    %eax,(%esp)
c0104629:	e8 78 f5 ff ff       	call   c0103ba6 <pte2page>
c010462e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104631:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104634:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104637:	75 0d                	jne    c0104646 <page_insert+0x6f>
            page_ref_dec(page);
c0104639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010463c:	89 04 24             	mov    %eax,(%esp)
c010463f:	e8 dd f5 ff ff       	call   c0103c21 <page_ref_dec>
c0104644:	eb 19                	jmp    c010465f <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104649:	89 44 24 08          	mov    %eax,0x8(%esp)
c010464d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104650:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104654:	8b 45 08             	mov    0x8(%ebp),%eax
c0104657:	89 04 24             	mov    %eax,(%esp)
c010465a:	e8 2b ff ff ff       	call   c010458a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010465f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104662:	89 04 24             	mov    %eax,(%esp)
c0104665:	e8 7d f4 ff ff       	call   c0103ae7 <page2pa>
c010466a:	0b 45 14             	or     0x14(%ebp),%eax
c010466d:	83 c8 01             	or     $0x1,%eax
c0104670:	89 c2                	mov    %eax,%edx
c0104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104675:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104677:	8b 45 10             	mov    0x10(%ebp),%eax
c010467a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010467e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104681:	89 04 24             	mov    %eax,(%esp)
c0104684:	e8 09 00 00 00       	call   c0104692 <tlb_invalidate>
    return 0;
c0104689:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010468e:	89 ec                	mov    %ebp,%esp
c0104690:	5d                   	pop    %ebp
c0104691:	c3                   	ret    

c0104692 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104692:	55                   	push   %ebp
c0104693:	89 e5                	mov    %esp,%ebp
c0104695:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104698:	0f 20 d8             	mov    %cr3,%eax
c010469b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010469e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01046a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046a7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01046ae:	77 23                	ja     c01046d3 <tlb_invalidate+0x41>
c01046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046b7:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c01046be:	c0 
c01046bf:	c7 44 24 04 c9 01 00 	movl   $0x1c9,0x4(%esp)
c01046c6:	00 
c01046c7:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01046ce:	e8 15 c6 ff ff       	call   c0100ce8 <__panic>
c01046d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d6:	05 00 00 00 40       	add    $0x40000000,%eax
c01046db:	39 d0                	cmp    %edx,%eax
c01046dd:	75 0d                	jne    c01046ec <tlb_invalidate+0x5a>
        invlpg((void *)la);
c01046df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01046e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046e8:	0f 01 38             	invlpg (%eax)
}
c01046eb:	90                   	nop
    }
}
c01046ec:	90                   	nop
c01046ed:	89 ec                	mov    %ebp,%esp
c01046ef:	5d                   	pop    %ebp
c01046f0:	c3                   	ret    

c01046f1 <check_alloc_page>:

static void
check_alloc_page(void) {
c01046f1:	55                   	push   %ebp
c01046f2:	89 e5                	mov    %esp,%ebp
c01046f4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01046f7:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c01046fc:	8b 40 18             	mov    0x18(%eax),%eax
c01046ff:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104701:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104708:	e8 49 bc ff ff       	call   c0100356 <cprintf>
}
c010470d:	90                   	nop
c010470e:	89 ec                	mov    %ebp,%esp
c0104710:	5d                   	pop    %ebp
c0104711:	c3                   	ret    

c0104712 <check_pgdir>:

static void
check_pgdir(void) {
c0104712:	55                   	push   %ebp
c0104713:	89 e5                	mov    %esp,%ebp
c0104715:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104718:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010471d:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104722:	76 24                	jbe    c0104748 <check_pgdir+0x36>
c0104724:	c7 44 24 0c 63 6b 10 	movl   $0xc0106b63,0xc(%esp)
c010472b:	c0 
c010472c:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104733:	c0 
c0104734:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c010473b:	00 
c010473c:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104743:	e8 a0 c5 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104748:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010474d:	85 c0                	test   %eax,%eax
c010474f:	74 0e                	je     c010475f <check_pgdir+0x4d>
c0104751:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104756:	25 ff 0f 00 00       	and    $0xfff,%eax
c010475b:	85 c0                	test   %eax,%eax
c010475d:	74 24                	je     c0104783 <check_pgdir+0x71>
c010475f:	c7 44 24 0c 80 6b 10 	movl   $0xc0106b80,0xc(%esp)
c0104766:	c0 
c0104767:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c010476e:	c0 
c010476f:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c0104776:	00 
c0104777:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010477e:	e8 65 c5 ff ff       	call   c0100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104783:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104788:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010478f:	00 
c0104790:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104797:	00 
c0104798:	89 04 24             	mov    %eax,(%esp)
c010479b:	e8 8f fd ff ff       	call   c010452f <get_page>
c01047a0:	85 c0                	test   %eax,%eax
c01047a2:	74 24                	je     c01047c8 <check_pgdir+0xb6>
c01047a4:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c01047ab:	c0 
c01047ac:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c01047b3:	c0 
c01047b4:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c01047bb:	00 
c01047bc:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01047c3:	e8 20 c5 ff ff       	call   c0100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01047c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047cf:	e8 2e f6 ff ff       	call   c0103e02 <alloc_pages>
c01047d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01047d7:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01047dc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01047e3:	00 
c01047e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047eb:	00 
c01047ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047f3:	89 04 24             	mov    %eax,(%esp)
c01047f6:	e8 dc fd ff ff       	call   c01045d7 <page_insert>
c01047fb:	85 c0                	test   %eax,%eax
c01047fd:	74 24                	je     c0104823 <check_pgdir+0x111>
c01047ff:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c0104806:	c0 
c0104807:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c010480e:	c0 
c010480f:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0104816:	00 
c0104817:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010481e:	e8 c5 c4 ff ff       	call   c0100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104823:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104828:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010482f:	00 
c0104830:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104837:	00 
c0104838:	89 04 24             	mov    %eax,(%esp)
c010483b:	e8 e9 fc ff ff       	call   c0104529 <get_pte>
c0104840:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104847:	75 24                	jne    c010486d <check_pgdir+0x15b>
c0104849:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c0104850:	c0 
c0104851:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104858:	c0 
c0104859:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c0104860:	00 
c0104861:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104868:	e8 7b c4 ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c010486d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104870:	8b 00                	mov    (%eax),%eax
c0104872:	89 04 24             	mov    %eax,(%esp)
c0104875:	e8 2c f3 ff ff       	call   c0103ba6 <pte2page>
c010487a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010487d:	74 24                	je     c01048a3 <check_pgdir+0x191>
c010487f:	c7 44 24 0c 39 6c 10 	movl   $0xc0106c39,0xc(%esp)
c0104886:	c0 
c0104887:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c010488e:	c0 
c010488f:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c0104896:	00 
c0104897:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010489e:	e8 45 c4 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 1);
c01048a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a6:	89 04 24             	mov    %eax,(%esp)
c01048a9:	e8 52 f3 ff ff       	call   c0103c00 <page_ref>
c01048ae:	83 f8 01             	cmp    $0x1,%eax
c01048b1:	74 24                	je     c01048d7 <check_pgdir+0x1c5>
c01048b3:	c7 44 24 0c 4f 6c 10 	movl   $0xc0106c4f,0xc(%esp)
c01048ba:	c0 
c01048bb:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c01048c2:	c0 
c01048c3:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c01048ca:	00 
c01048cb:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01048d2:	e8 11 c4 ff ff       	call   c0100ce8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01048d7:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048dc:	8b 00                	mov    (%eax),%eax
c01048de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048e9:	c1 e8 0c             	shr    $0xc,%eax
c01048ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01048ef:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01048f4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01048f7:	72 23                	jb     c010491c <check_pgdir+0x20a>
c01048f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104900:	c7 44 24 08 04 6a 10 	movl   $0xc0106a04,0x8(%esp)
c0104907:	c0 
c0104908:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c010490f:	00 
c0104910:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104917:	e8 cc c3 ff ff       	call   c0100ce8 <__panic>
c010491c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010491f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104924:	83 c0 04             	add    $0x4,%eax
c0104927:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010492a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010492f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104936:	00 
c0104937:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010493e:	00 
c010493f:	89 04 24             	mov    %eax,(%esp)
c0104942:	e8 e2 fb ff ff       	call   c0104529 <get_pte>
c0104947:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010494a:	74 24                	je     c0104970 <check_pgdir+0x25e>
c010494c:	c7 44 24 0c 64 6c 10 	movl   $0xc0106c64,0xc(%esp)
c0104953:	c0 
c0104954:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c010495b:	c0 
c010495c:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104963:	00 
c0104964:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010496b:	e8 78 c3 ff ff       	call   c0100ce8 <__panic>

    p2 = alloc_page();
c0104970:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104977:	e8 86 f4 ff ff       	call   c0103e02 <alloc_pages>
c010497c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010497f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104984:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010498b:	00 
c010498c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104993:	00 
c0104994:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104997:	89 54 24 04          	mov    %edx,0x4(%esp)
c010499b:	89 04 24             	mov    %eax,(%esp)
c010499e:	e8 34 fc ff ff       	call   c01045d7 <page_insert>
c01049a3:	85 c0                	test   %eax,%eax
c01049a5:	74 24                	je     c01049cb <check_pgdir+0x2b9>
c01049a7:	c7 44 24 0c 8c 6c 10 	movl   $0xc0106c8c,0xc(%esp)
c01049ae:	c0 
c01049af:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c01049b6:	c0 
c01049b7:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c01049be:	00 
c01049bf:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01049c6:	e8 1d c3 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01049cb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049d7:	00 
c01049d8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049df:	00 
c01049e0:	89 04 24             	mov    %eax,(%esp)
c01049e3:	e8 41 fb ff ff       	call   c0104529 <get_pte>
c01049e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049ef:	75 24                	jne    c0104a15 <check_pgdir+0x303>
c01049f1:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c01049f8:	c0 
c01049f9:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104a00:	c0 
c0104a01:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104a08:	00 
c0104a09:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104a10:	e8 d3 c2 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_U);
c0104a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a18:	8b 00                	mov    (%eax),%eax
c0104a1a:	83 e0 04             	and    $0x4,%eax
c0104a1d:	85 c0                	test   %eax,%eax
c0104a1f:	75 24                	jne    c0104a45 <check_pgdir+0x333>
c0104a21:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104a28:	c0 
c0104a29:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104a30:	c0 
c0104a31:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104a38:	00 
c0104a39:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104a40:	e8 a3 c2 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_W);
c0104a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a48:	8b 00                	mov    (%eax),%eax
c0104a4a:	83 e0 02             	and    $0x2,%eax
c0104a4d:	85 c0                	test   %eax,%eax
c0104a4f:	75 24                	jne    c0104a75 <check_pgdir+0x363>
c0104a51:	c7 44 24 0c 02 6d 10 	movl   $0xc0106d02,0xc(%esp)
c0104a58:	c0 
c0104a59:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104a60:	c0 
c0104a61:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104a68:	00 
c0104a69:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104a70:	e8 73 c2 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a75:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a7a:	8b 00                	mov    (%eax),%eax
c0104a7c:	83 e0 04             	and    $0x4,%eax
c0104a7f:	85 c0                	test   %eax,%eax
c0104a81:	75 24                	jne    c0104aa7 <check_pgdir+0x395>
c0104a83:	c7 44 24 0c 10 6d 10 	movl   $0xc0106d10,0xc(%esp)
c0104a8a:	c0 
c0104a8b:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104a92:	c0 
c0104a93:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104a9a:	00 
c0104a9b:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104aa2:	e8 41 c2 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 1);
c0104aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104aaa:	89 04 24             	mov    %eax,(%esp)
c0104aad:	e8 4e f1 ff ff       	call   c0103c00 <page_ref>
c0104ab2:	83 f8 01             	cmp    $0x1,%eax
c0104ab5:	74 24                	je     c0104adb <check_pgdir+0x3c9>
c0104ab7:	c7 44 24 0c 26 6d 10 	movl   $0xc0106d26,0xc(%esp)
c0104abe:	c0 
c0104abf:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104ac6:	c0 
c0104ac7:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104ace:	00 
c0104acf:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104ad6:	e8 0d c2 ff ff       	call   c0100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104adb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ae0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104ae7:	00 
c0104ae8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104aef:	00 
c0104af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104af3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104af7:	89 04 24             	mov    %eax,(%esp)
c0104afa:	e8 d8 fa ff ff       	call   c01045d7 <page_insert>
c0104aff:	85 c0                	test   %eax,%eax
c0104b01:	74 24                	je     c0104b27 <check_pgdir+0x415>
c0104b03:	c7 44 24 0c 38 6d 10 	movl   $0xc0106d38,0xc(%esp)
c0104b0a:	c0 
c0104b0b:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104b12:	c0 
c0104b13:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104b1a:	00 
c0104b1b:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104b22:	e8 c1 c1 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 2);
c0104b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b2a:	89 04 24             	mov    %eax,(%esp)
c0104b2d:	e8 ce f0 ff ff       	call   c0103c00 <page_ref>
c0104b32:	83 f8 02             	cmp    $0x2,%eax
c0104b35:	74 24                	je     c0104b5b <check_pgdir+0x449>
c0104b37:	c7 44 24 0c 64 6d 10 	movl   $0xc0106d64,0xc(%esp)
c0104b3e:	c0 
c0104b3f:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104b4e:	00 
c0104b4f:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104b56:	e8 8d c1 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b5e:	89 04 24             	mov    %eax,(%esp)
c0104b61:	e8 9a f0 ff ff       	call   c0103c00 <page_ref>
c0104b66:	85 c0                	test   %eax,%eax
c0104b68:	74 24                	je     c0104b8e <check_pgdir+0x47c>
c0104b6a:	c7 44 24 0c 76 6d 10 	movl   $0xc0106d76,0xc(%esp)
c0104b71:	c0 
c0104b72:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104b79:	c0 
c0104b7a:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104b81:	00 
c0104b82:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104b89:	e8 5a c1 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b8e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b9a:	00 
c0104b9b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ba2:	00 
c0104ba3:	89 04 24             	mov    %eax,(%esp)
c0104ba6:	e8 7e f9 ff ff       	call   c0104529 <get_pte>
c0104bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bb2:	75 24                	jne    c0104bd8 <check_pgdir+0x4c6>
c0104bb4:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104bbb:	c0 
c0104bbc:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104bc3:	c0 
c0104bc4:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104bcb:	00 
c0104bcc:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104bd3:	e8 10 c1 ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bdb:	8b 00                	mov    (%eax),%eax
c0104bdd:	89 04 24             	mov    %eax,(%esp)
c0104be0:	e8 c1 ef ff ff       	call   c0103ba6 <pte2page>
c0104be5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104be8:	74 24                	je     c0104c0e <check_pgdir+0x4fc>
c0104bea:	c7 44 24 0c 39 6c 10 	movl   $0xc0106c39,0xc(%esp)
c0104bf1:	c0 
c0104bf2:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104bf9:	c0 
c0104bfa:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104c01:	00 
c0104c02:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104c09:	e8 da c0 ff ff       	call   c0100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c11:	8b 00                	mov    (%eax),%eax
c0104c13:	83 e0 04             	and    $0x4,%eax
c0104c16:	85 c0                	test   %eax,%eax
c0104c18:	74 24                	je     c0104c3e <check_pgdir+0x52c>
c0104c1a:	c7 44 24 0c 88 6d 10 	movl   $0xc0106d88,0xc(%esp)
c0104c21:	c0 
c0104c22:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104c29:	c0 
c0104c2a:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104c31:	00 
c0104c32:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104c39:	e8 aa c0 ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c3e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c4a:	00 
c0104c4b:	89 04 24             	mov    %eax,(%esp)
c0104c4e:	e8 3d f9 ff ff       	call   c0104590 <page_remove>
    assert(page_ref(p1) == 1);
c0104c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c56:	89 04 24             	mov    %eax,(%esp)
c0104c59:	e8 a2 ef ff ff       	call   c0103c00 <page_ref>
c0104c5e:	83 f8 01             	cmp    $0x1,%eax
c0104c61:	74 24                	je     c0104c87 <check_pgdir+0x575>
c0104c63:	c7 44 24 0c 4f 6c 10 	movl   $0xc0106c4f,0xc(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104c72:	c0 
c0104c73:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104c7a:	00 
c0104c7b:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104c82:	e8 61 c0 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c8a:	89 04 24             	mov    %eax,(%esp)
c0104c8d:	e8 6e ef ff ff       	call   c0103c00 <page_ref>
c0104c92:	85 c0                	test   %eax,%eax
c0104c94:	74 24                	je     c0104cba <check_pgdir+0x5a8>
c0104c96:	c7 44 24 0c 76 6d 10 	movl   $0xc0106d76,0xc(%esp)
c0104c9d:	c0 
c0104c9e:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104ca5:	c0 
c0104ca6:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104cad:	00 
c0104cae:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104cb5:	e8 2e c0 ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104cba:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104cbf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cc6:	00 
c0104cc7:	89 04 24             	mov    %eax,(%esp)
c0104cca:	e8 c1 f8 ff ff       	call   c0104590 <page_remove>
    assert(page_ref(p1) == 0);
c0104ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd2:	89 04 24             	mov    %eax,(%esp)
c0104cd5:	e8 26 ef ff ff       	call   c0103c00 <page_ref>
c0104cda:	85 c0                	test   %eax,%eax
c0104cdc:	74 24                	je     c0104d02 <check_pgdir+0x5f0>
c0104cde:	c7 44 24 0c 9d 6d 10 	movl   $0xc0106d9d,0xc(%esp)
c0104ce5:	c0 
c0104ce6:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104ced:	c0 
c0104cee:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104cf5:	00 
c0104cf6:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104cfd:	e8 e6 bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d05:	89 04 24             	mov    %eax,(%esp)
c0104d08:	e8 f3 ee ff ff       	call   c0103c00 <page_ref>
c0104d0d:	85 c0                	test   %eax,%eax
c0104d0f:	74 24                	je     c0104d35 <check_pgdir+0x623>
c0104d11:	c7 44 24 0c 76 6d 10 	movl   $0xc0106d76,0xc(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104d20:	c0 
c0104d21:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104d28:	00 
c0104d29:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104d30:	e8 b3 bf ff ff       	call   c0100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104d35:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d3a:	8b 00                	mov    (%eax),%eax
c0104d3c:	89 04 24             	mov    %eax,(%esp)
c0104d3f:	e8 a2 ee ff ff       	call   c0103be6 <pde2page>
c0104d44:	89 04 24             	mov    %eax,(%esp)
c0104d47:	e8 b4 ee ff ff       	call   c0103c00 <page_ref>
c0104d4c:	83 f8 01             	cmp    $0x1,%eax
c0104d4f:	74 24                	je     c0104d75 <check_pgdir+0x663>
c0104d51:	c7 44 24 0c b0 6d 10 	movl   $0xc0106db0,0xc(%esp)
c0104d58:	c0 
c0104d59:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104d60:	c0 
c0104d61:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104d68:	00 
c0104d69:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104d70:	e8 73 bf ff ff       	call   c0100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104d75:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d7a:	8b 00                	mov    (%eax),%eax
c0104d7c:	89 04 24             	mov    %eax,(%esp)
c0104d7f:	e8 62 ee ff ff       	call   c0103be6 <pde2page>
c0104d84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d8b:	00 
c0104d8c:	89 04 24             	mov    %eax,(%esp)
c0104d8f:	e8 a8 f0 ff ff       	call   c0103e3c <free_pages>
    boot_pgdir[0] = 0;
c0104d94:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104d9f:	c7 04 24 d7 6d 10 c0 	movl   $0xc0106dd7,(%esp)
c0104da6:	e8 ab b5 ff ff       	call   c0100356 <cprintf>
}
c0104dab:	90                   	nop
c0104dac:	89 ec                	mov    %ebp,%esp
c0104dae:	5d                   	pop    %ebp
c0104daf:	c3                   	ret    

c0104db0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104db0:	55                   	push   %ebp
c0104db1:	89 e5                	mov    %esp,%ebp
c0104db3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104dbd:	e9 ca 00 00 00       	jmp    c0104e8c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dcb:	c1 e8 0c             	shr    $0xc,%eax
c0104dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104dd1:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104dd6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104dd9:	72 23                	jb     c0104dfe <check_boot_pgdir+0x4e>
c0104ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dde:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104de2:	c7 44 24 08 04 6a 10 	movl   $0xc0106a04,0x8(%esp)
c0104de9:	c0 
c0104dea:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104df1:	00 
c0104df2:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104df9:	e8 ea be ff ff       	call   c0100ce8 <__panic>
c0104dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e01:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e06:	89 c2                	mov    %eax,%edx
c0104e08:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e14:	00 
c0104e15:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e19:	89 04 24             	mov    %eax,(%esp)
c0104e1c:	e8 08 f7 ff ff       	call   c0104529 <get_pte>
c0104e21:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104e28:	75 24                	jne    c0104e4e <check_boot_pgdir+0x9e>
c0104e2a:	c7 44 24 0c f4 6d 10 	movl   $0xc0106df4,0xc(%esp)
c0104e31:	c0 
c0104e32:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104e39:	c0 
c0104e3a:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104e41:	00 
c0104e42:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104e49:	e8 9a be ff ff       	call   c0100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e51:	8b 00                	mov    (%eax),%eax
c0104e53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e58:	89 c2                	mov    %eax,%edx
c0104e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e5d:	39 c2                	cmp    %eax,%edx
c0104e5f:	74 24                	je     c0104e85 <check_boot_pgdir+0xd5>
c0104e61:	c7 44 24 0c 31 6e 10 	movl   $0xc0106e31,0xc(%esp)
c0104e68:	c0 
c0104e69:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104e70:	c0 
c0104e71:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104e78:	00 
c0104e79:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104e80:	e8 63 be ff ff       	call   c0100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104e85:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e8f:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104e94:	39 c2                	cmp    %eax,%edx
c0104e96:	0f 82 26 ff ff ff    	jb     c0104dc2 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104e9c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ea1:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104ea6:	8b 00                	mov    (%eax),%eax
c0104ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ead:	89 c2                	mov    %eax,%edx
c0104eaf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eb7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104ebe:	77 23                	ja     c0104ee3 <check_boot_pgdir+0x133>
c0104ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ec3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ec7:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c0104ece:	c0 
c0104ecf:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ed6:	00 
c0104ed7:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104ede:	e8 05 be ff ff       	call   c0100ce8 <__panic>
c0104ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee6:	05 00 00 00 40       	add    $0x40000000,%eax
c0104eeb:	39 d0                	cmp    %edx,%eax
c0104eed:	74 24                	je     c0104f13 <check_boot_pgdir+0x163>
c0104eef:	c7 44 24 0c 48 6e 10 	movl   $0xc0106e48,0xc(%esp)
c0104ef6:	c0 
c0104ef7:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104efe:	c0 
c0104eff:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104f06:	00 
c0104f07:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104f0e:	e8 d5 bd ff ff       	call   c0100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
c0104f13:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f18:	8b 00                	mov    (%eax),%eax
c0104f1a:	85 c0                	test   %eax,%eax
c0104f1c:	74 24                	je     c0104f42 <check_boot_pgdir+0x192>
c0104f1e:	c7 44 24 0c 7c 6e 10 	movl   $0xc0106e7c,0xc(%esp)
c0104f25:	c0 
c0104f26:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104f2d:	c0 
c0104f2e:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104f35:	00 
c0104f36:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104f3d:	e8 a6 bd ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
c0104f42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f49:	e8 b4 ee ff ff       	call   c0103e02 <alloc_pages>
c0104f4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104f51:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f56:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f5d:	00 
c0104f5e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104f65:	00 
c0104f66:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104f69:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f6d:	89 04 24             	mov    %eax,(%esp)
c0104f70:	e8 62 f6 ff ff       	call   c01045d7 <page_insert>
c0104f75:	85 c0                	test   %eax,%eax
c0104f77:	74 24                	je     c0104f9d <check_boot_pgdir+0x1ed>
c0104f79:	c7 44 24 0c 90 6e 10 	movl   $0xc0106e90,0xc(%esp)
c0104f80:	c0 
c0104f81:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104f88:	c0 
c0104f89:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104f90:	00 
c0104f91:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104f98:	e8 4b bd ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 1);
c0104f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fa0:	89 04 24             	mov    %eax,(%esp)
c0104fa3:	e8 58 ec ff ff       	call   c0103c00 <page_ref>
c0104fa8:	83 f8 01             	cmp    $0x1,%eax
c0104fab:	74 24                	je     c0104fd1 <check_boot_pgdir+0x221>
c0104fad:	c7 44 24 0c be 6e 10 	movl   $0xc0106ebe,0xc(%esp)
c0104fb4:	c0 
c0104fb5:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0104fbc:	c0 
c0104fbd:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104fc4:	00 
c0104fc5:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0104fcc:	e8 17 bd ff ff       	call   c0100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104fd1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104fd6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fdd:	00 
c0104fde:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104fe5:	00 
c0104fe6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104fe9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fed:	89 04 24             	mov    %eax,(%esp)
c0104ff0:	e8 e2 f5 ff ff       	call   c01045d7 <page_insert>
c0104ff5:	85 c0                	test   %eax,%eax
c0104ff7:	74 24                	je     c010501d <check_boot_pgdir+0x26d>
c0104ff9:	c7 44 24 0c d0 6e 10 	movl   $0xc0106ed0,0xc(%esp)
c0105000:	c0 
c0105001:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0105008:	c0 
c0105009:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0105010:	00 
c0105011:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0105018:	e8 cb bc ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 2);
c010501d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105020:	89 04 24             	mov    %eax,(%esp)
c0105023:	e8 d8 eb ff ff       	call   c0103c00 <page_ref>
c0105028:	83 f8 02             	cmp    $0x2,%eax
c010502b:	74 24                	je     c0105051 <check_boot_pgdir+0x2a1>
c010502d:	c7 44 24 0c 07 6f 10 	movl   $0xc0106f07,0xc(%esp)
c0105034:	c0 
c0105035:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c010503c:	c0 
c010503d:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105044:	00 
c0105045:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c010504c:	e8 97 bc ff ff       	call   c0100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
c0105051:	c7 45 e8 18 6f 10 c0 	movl   $0xc0106f18,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105058:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010505b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010505f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105066:	e8 fc 09 00 00       	call   c0105a67 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010506b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105072:	00 
c0105073:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010507a:	e8 60 0a 00 00       	call   c0105adf <strcmp>
c010507f:	85 c0                	test   %eax,%eax
c0105081:	74 24                	je     c01050a7 <check_boot_pgdir+0x2f7>
c0105083:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c010508a:	c0 
c010508b:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0105092:	c0 
c0105093:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c010509a:	00 
c010509b:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01050a2:	e8 41 bc ff ff       	call   c0100ce8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01050a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050aa:	89 04 24             	mov    %eax,(%esp)
c01050ad:	e8 9e ea ff ff       	call   c0103b50 <page2kva>
c01050b2:	05 00 01 00 00       	add    $0x100,%eax
c01050b7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01050ba:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050c1:	e8 47 09 00 00       	call   c0105a0d <strlen>
c01050c6:	85 c0                	test   %eax,%eax
c01050c8:	74 24                	je     c01050ee <check_boot_pgdir+0x33e>
c01050ca:	c7 44 24 0c 68 6f 10 	movl   $0xc0106f68,0xc(%esp)
c01050d1:	c0 
c01050d2:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c01050d9:	c0 
c01050da:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01050e1:	00 
c01050e2:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c01050e9:	e8 fa bb ff ff       	call   c0100ce8 <__panic>

    free_page(p);
c01050ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050f5:	00 
c01050f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050f9:	89 04 24             	mov    %eax,(%esp)
c01050fc:	e8 3b ed ff ff       	call   c0103e3c <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105101:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105106:	8b 00                	mov    (%eax),%eax
c0105108:	89 04 24             	mov    %eax,(%esp)
c010510b:	e8 d6 ea ff ff       	call   c0103be6 <pde2page>
c0105110:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105117:	00 
c0105118:	89 04 24             	mov    %eax,(%esp)
c010511b:	e8 1c ed ff ff       	call   c0103e3c <free_pages>
    boot_pgdir[0] = 0;
c0105120:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010512b:	c7 04 24 8c 6f 10 c0 	movl   $0xc0106f8c,(%esp)
c0105132:	e8 1f b2 ff ff       	call   c0100356 <cprintf>
}
c0105137:	90                   	nop
c0105138:	89 ec                	mov    %ebp,%esp
c010513a:	5d                   	pop    %ebp
c010513b:	c3                   	ret    

c010513c <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010513c:	55                   	push   %ebp
c010513d:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010513f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105142:	83 e0 04             	and    $0x4,%eax
c0105145:	85 c0                	test   %eax,%eax
c0105147:	74 04                	je     c010514d <perm2str+0x11>
c0105149:	b0 75                	mov    $0x75,%al
c010514b:	eb 02                	jmp    c010514f <perm2str+0x13>
c010514d:	b0 2d                	mov    $0x2d,%al
c010514f:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0105154:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010515b:	8b 45 08             	mov    0x8(%ebp),%eax
c010515e:	83 e0 02             	and    $0x2,%eax
c0105161:	85 c0                	test   %eax,%eax
c0105163:	74 04                	je     c0105169 <perm2str+0x2d>
c0105165:	b0 77                	mov    $0x77,%al
c0105167:	eb 02                	jmp    c010516b <perm2str+0x2f>
c0105169:	b0 2d                	mov    $0x2d,%al
c010516b:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0105170:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c0105177:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c010517c:	5d                   	pop    %ebp
c010517d:	c3                   	ret    

c010517e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010517e:	55                   	push   %ebp
c010517f:	89 e5                	mov    %esp,%ebp
c0105181:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105184:	8b 45 10             	mov    0x10(%ebp),%eax
c0105187:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010518a:	72 0d                	jb     c0105199 <get_pgtable_items+0x1b>
        return 0;
c010518c:	b8 00 00 00 00       	mov    $0x0,%eax
c0105191:	e9 98 00 00 00       	jmp    c010522e <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105196:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0105199:	8b 45 10             	mov    0x10(%ebp),%eax
c010519c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010519f:	73 18                	jae    c01051b9 <get_pgtable_items+0x3b>
c01051a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051ab:	8b 45 14             	mov    0x14(%ebp),%eax
c01051ae:	01 d0                	add    %edx,%eax
c01051b0:	8b 00                	mov    (%eax),%eax
c01051b2:	83 e0 01             	and    $0x1,%eax
c01051b5:	85 c0                	test   %eax,%eax
c01051b7:	74 dd                	je     c0105196 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01051b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01051bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051bf:	73 68                	jae    c0105229 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01051c1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01051c5:	74 08                	je     c01051cf <get_pgtable_items+0x51>
            *left_store = start;
c01051c7:	8b 45 18             	mov    0x18(%ebp),%eax
c01051ca:	8b 55 10             	mov    0x10(%ebp),%edx
c01051cd:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01051cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01051d2:	8d 50 01             	lea    0x1(%eax),%edx
c01051d5:	89 55 10             	mov    %edx,0x10(%ebp)
c01051d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051df:	8b 45 14             	mov    0x14(%ebp),%eax
c01051e2:	01 d0                	add    %edx,%eax
c01051e4:	8b 00                	mov    (%eax),%eax
c01051e6:	83 e0 07             	and    $0x7,%eax
c01051e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051ec:	eb 03                	jmp    c01051f1 <get_pgtable_items+0x73>
            start ++;
c01051ee:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01051f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051f7:	73 1d                	jae    c0105216 <get_pgtable_items+0x98>
c01051f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01051fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105203:	8b 45 14             	mov    0x14(%ebp),%eax
c0105206:	01 d0                	add    %edx,%eax
c0105208:	8b 00                	mov    (%eax),%eax
c010520a:	83 e0 07             	and    $0x7,%eax
c010520d:	89 c2                	mov    %eax,%edx
c010520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105212:	39 c2                	cmp    %eax,%edx
c0105214:	74 d8                	je     c01051ee <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105216:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010521a:	74 08                	je     c0105224 <get_pgtable_items+0xa6>
            *right_store = start;
c010521c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010521f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105222:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105224:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105227:	eb 05                	jmp    c010522e <get_pgtable_items+0xb0>
    }
    return 0;
c0105229:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010522e:	89 ec                	mov    %ebp,%esp
c0105230:	5d                   	pop    %ebp
c0105231:	c3                   	ret    

c0105232 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105232:	55                   	push   %ebp
c0105233:	89 e5                	mov    %esp,%ebp
c0105235:	57                   	push   %edi
c0105236:	56                   	push   %esi
c0105237:	53                   	push   %ebx
c0105238:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010523b:	c7 04 24 ac 6f 10 c0 	movl   $0xc0106fac,(%esp)
c0105242:	e8 0f b1 ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c0105247:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010524e:	e9 f2 00 00 00       	jmp    c0105345 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105256:	89 04 24             	mov    %eax,(%esp)
c0105259:	e8 de fe ff ff       	call   c010513c <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010525e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105261:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105264:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105266:	89 d6                	mov    %edx,%esi
c0105268:	c1 e6 16             	shl    $0x16,%esi
c010526b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010526e:	89 d3                	mov    %edx,%ebx
c0105270:	c1 e3 16             	shl    $0x16,%ebx
c0105273:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105276:	89 d1                	mov    %edx,%ecx
c0105278:	c1 e1 16             	shl    $0x16,%ecx
c010527b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010527e:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105281:	29 fa                	sub    %edi,%edx
c0105283:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105287:	89 74 24 10          	mov    %esi,0x10(%esp)
c010528b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010528f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105293:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105297:	c7 04 24 dd 6f 10 c0 	movl   $0xc0106fdd,(%esp)
c010529e:	e8 b3 b0 ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01052a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052a6:	c1 e0 0a             	shl    $0xa,%eax
c01052a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052ac:	eb 50                	jmp    c01052fe <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052b1:	89 04 24             	mov    %eax,(%esp)
c01052b4:	e8 83 fe ff ff       	call   c010513c <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01052b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052bc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01052bf:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052c1:	89 d6                	mov    %edx,%esi
c01052c3:	c1 e6 0c             	shl    $0xc,%esi
c01052c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052c9:	89 d3                	mov    %edx,%ebx
c01052cb:	c1 e3 0c             	shl    $0xc,%ebx
c01052ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052d1:	89 d1                	mov    %edx,%ecx
c01052d3:	c1 e1 0c             	shl    $0xc,%ecx
c01052d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052d9:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01052dc:	29 fa                	sub    %edi,%edx
c01052de:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052e2:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052ea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052f2:	c7 04 24 fc 6f 10 c0 	movl   $0xc0106ffc,(%esp)
c01052f9:	e8 58 b0 ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052fe:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105303:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105306:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105309:	89 d3                	mov    %edx,%ebx
c010530b:	c1 e3 0a             	shl    $0xa,%ebx
c010530e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105311:	89 d1                	mov    %edx,%ecx
c0105313:	c1 e1 0a             	shl    $0xa,%ecx
c0105316:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0105319:	89 54 24 14          	mov    %edx,0x14(%esp)
c010531d:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105320:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105324:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105328:	89 44 24 08          	mov    %eax,0x8(%esp)
c010532c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105330:	89 0c 24             	mov    %ecx,(%esp)
c0105333:	e8 46 fe ff ff       	call   c010517e <get_pgtable_items>
c0105338:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010533b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010533f:	0f 85 69 ff ff ff    	jne    c01052ae <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105345:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010534a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010534d:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105350:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105354:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0105357:	89 54 24 10          	mov    %edx,0x10(%esp)
c010535b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010535f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105363:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010536a:	00 
c010536b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105372:	e8 07 fe ff ff       	call   c010517e <get_pgtable_items>
c0105377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010537a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010537e:	0f 85 cf fe ff ff    	jne    c0105253 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105384:	c7 04 24 20 70 10 c0 	movl   $0xc0107020,(%esp)
c010538b:	e8 c6 af ff ff       	call   c0100356 <cprintf>
}
c0105390:	90                   	nop
c0105391:	83 c4 4c             	add    $0x4c,%esp
c0105394:	5b                   	pop    %ebx
c0105395:	5e                   	pop    %esi
c0105396:	5f                   	pop    %edi
c0105397:	5d                   	pop    %ebp
c0105398:	c3                   	ret    

c0105399 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105399:	55                   	push   %ebp
c010539a:	89 e5                	mov    %esp,%ebp
c010539c:	83 ec 58             	sub    $0x58,%esp
c010539f:	8b 45 10             	mov    0x10(%ebp),%eax
c01053a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053a5:	8b 45 14             	mov    0x14(%ebp),%eax
c01053a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01053ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053b4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01053b7:	8b 45 18             	mov    0x18(%ebp),%eax
c01053ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053c6:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01053c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053d3:	74 1c                	je     c01053f1 <printnum+0x58>
c01053d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01053dd:	f7 75 e4             	divl   -0x1c(%ebp)
c01053e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01053e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053e6:	ba 00 00 00 00       	mov    $0x0,%edx
c01053eb:	f7 75 e4             	divl   -0x1c(%ebp)
c01053ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053f7:	f7 75 e4             	divl   -0x1c(%ebp)
c01053fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105400:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105403:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105406:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105409:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010540c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010540f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105412:	8b 45 18             	mov    0x18(%ebp),%eax
c0105415:	ba 00 00 00 00       	mov    $0x0,%edx
c010541a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010541d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105420:	19 d1                	sbb    %edx,%ecx
c0105422:	72 4c                	jb     c0105470 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105424:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105427:	8d 50 ff             	lea    -0x1(%eax),%edx
c010542a:	8b 45 20             	mov    0x20(%ebp),%eax
c010542d:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105431:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105435:	8b 45 18             	mov    0x18(%ebp),%eax
c0105438:	89 44 24 10          	mov    %eax,0x10(%esp)
c010543c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010543f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105442:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105446:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010544a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010544d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105451:	8b 45 08             	mov    0x8(%ebp),%eax
c0105454:	89 04 24             	mov    %eax,(%esp)
c0105457:	e8 3d ff ff ff       	call   c0105399 <printnum>
c010545c:	eb 1b                	jmp    c0105479 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010545e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105461:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105465:	8b 45 20             	mov    0x20(%ebp),%eax
c0105468:	89 04 24             	mov    %eax,(%esp)
c010546b:	8b 45 08             	mov    0x8(%ebp),%eax
c010546e:	ff d0                	call   *%eax
        while (-- width > 0)
c0105470:	ff 4d 1c             	decl   0x1c(%ebp)
c0105473:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105477:	7f e5                	jg     c010545e <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105479:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010547c:	05 d4 70 10 c0       	add    $0xc01070d4,%eax
c0105481:	0f b6 00             	movzbl (%eax),%eax
c0105484:	0f be c0             	movsbl %al,%eax
c0105487:	8b 55 0c             	mov    0xc(%ebp),%edx
c010548a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010548e:	89 04 24             	mov    %eax,(%esp)
c0105491:	8b 45 08             	mov    0x8(%ebp),%eax
c0105494:	ff d0                	call   *%eax
}
c0105496:	90                   	nop
c0105497:	89 ec                	mov    %ebp,%esp
c0105499:	5d                   	pop    %ebp
c010549a:	c3                   	ret    

c010549b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010549b:	55                   	push   %ebp
c010549c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010549e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054a2:	7e 14                	jle    c01054b8 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01054a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a7:	8b 00                	mov    (%eax),%eax
c01054a9:	8d 48 08             	lea    0x8(%eax),%ecx
c01054ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01054af:	89 0a                	mov    %ecx,(%edx)
c01054b1:	8b 50 04             	mov    0x4(%eax),%edx
c01054b4:	8b 00                	mov    (%eax),%eax
c01054b6:	eb 30                	jmp    c01054e8 <getuint+0x4d>
    }
    else if (lflag) {
c01054b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054bc:	74 16                	je     c01054d4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01054be:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c1:	8b 00                	mov    (%eax),%eax
c01054c3:	8d 48 04             	lea    0x4(%eax),%ecx
c01054c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01054c9:	89 0a                	mov    %ecx,(%edx)
c01054cb:	8b 00                	mov    (%eax),%eax
c01054cd:	ba 00 00 00 00       	mov    $0x0,%edx
c01054d2:	eb 14                	jmp    c01054e8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01054d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d7:	8b 00                	mov    (%eax),%eax
c01054d9:	8d 48 04             	lea    0x4(%eax),%ecx
c01054dc:	8b 55 08             	mov    0x8(%ebp),%edx
c01054df:	89 0a                	mov    %ecx,(%edx)
c01054e1:	8b 00                	mov    (%eax),%eax
c01054e3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01054e8:	5d                   	pop    %ebp
c01054e9:	c3                   	ret    

c01054ea <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01054ea:	55                   	push   %ebp
c01054eb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054f1:	7e 14                	jle    c0105507 <getint+0x1d>
        return va_arg(*ap, long long);
c01054f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f6:	8b 00                	mov    (%eax),%eax
c01054f8:	8d 48 08             	lea    0x8(%eax),%ecx
c01054fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01054fe:	89 0a                	mov    %ecx,(%edx)
c0105500:	8b 50 04             	mov    0x4(%eax),%edx
c0105503:	8b 00                	mov    (%eax),%eax
c0105505:	eb 28                	jmp    c010552f <getint+0x45>
    }
    else if (lflag) {
c0105507:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010550b:	74 12                	je     c010551f <getint+0x35>
        return va_arg(*ap, long);
c010550d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105510:	8b 00                	mov    (%eax),%eax
c0105512:	8d 48 04             	lea    0x4(%eax),%ecx
c0105515:	8b 55 08             	mov    0x8(%ebp),%edx
c0105518:	89 0a                	mov    %ecx,(%edx)
c010551a:	8b 00                	mov    (%eax),%eax
c010551c:	99                   	cltd   
c010551d:	eb 10                	jmp    c010552f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010551f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105522:	8b 00                	mov    (%eax),%eax
c0105524:	8d 48 04             	lea    0x4(%eax),%ecx
c0105527:	8b 55 08             	mov    0x8(%ebp),%edx
c010552a:	89 0a                	mov    %ecx,(%edx)
c010552c:	8b 00                	mov    (%eax),%eax
c010552e:	99                   	cltd   
    }
}
c010552f:	5d                   	pop    %ebp
c0105530:	c3                   	ret    

c0105531 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105531:	55                   	push   %ebp
c0105532:	89 e5                	mov    %esp,%ebp
c0105534:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105537:	8d 45 14             	lea    0x14(%ebp),%eax
c010553a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010553d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105540:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105544:	8b 45 10             	mov    0x10(%ebp),%eax
c0105547:	89 44 24 08          	mov    %eax,0x8(%esp)
c010554b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010554e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105552:	8b 45 08             	mov    0x8(%ebp),%eax
c0105555:	89 04 24             	mov    %eax,(%esp)
c0105558:	e8 05 00 00 00       	call   c0105562 <vprintfmt>
    va_end(ap);
}
c010555d:	90                   	nop
c010555e:	89 ec                	mov    %ebp,%esp
c0105560:	5d                   	pop    %ebp
c0105561:	c3                   	ret    

c0105562 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105562:	55                   	push   %ebp
c0105563:	89 e5                	mov    %esp,%ebp
c0105565:	56                   	push   %esi
c0105566:	53                   	push   %ebx
c0105567:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010556a:	eb 17                	jmp    c0105583 <vprintfmt+0x21>
            if (ch == '\0') {
c010556c:	85 db                	test   %ebx,%ebx
c010556e:	0f 84 bf 03 00 00    	je     c0105933 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105577:	89 44 24 04          	mov    %eax,0x4(%esp)
c010557b:	89 1c 24             	mov    %ebx,(%esp)
c010557e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105581:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105583:	8b 45 10             	mov    0x10(%ebp),%eax
c0105586:	8d 50 01             	lea    0x1(%eax),%edx
c0105589:	89 55 10             	mov    %edx,0x10(%ebp)
c010558c:	0f b6 00             	movzbl (%eax),%eax
c010558f:	0f b6 d8             	movzbl %al,%ebx
c0105592:	83 fb 25             	cmp    $0x25,%ebx
c0105595:	75 d5                	jne    c010556c <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105597:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010559b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01055a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01055a8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01055af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01055b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b8:	8d 50 01             	lea    0x1(%eax),%edx
c01055bb:	89 55 10             	mov    %edx,0x10(%ebp)
c01055be:	0f b6 00             	movzbl (%eax),%eax
c01055c1:	0f b6 d8             	movzbl %al,%ebx
c01055c4:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01055c7:	83 f8 55             	cmp    $0x55,%eax
c01055ca:	0f 87 37 03 00 00    	ja     c0105907 <vprintfmt+0x3a5>
c01055d0:	8b 04 85 f8 70 10 c0 	mov    -0x3fef8f08(,%eax,4),%eax
c01055d7:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055d9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01055dd:	eb d6                	jmp    c01055b5 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01055df:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01055e3:	eb d0                	jmp    c01055b5 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01055ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055ef:	89 d0                	mov    %edx,%eax
c01055f1:	c1 e0 02             	shl    $0x2,%eax
c01055f4:	01 d0                	add    %edx,%eax
c01055f6:	01 c0                	add    %eax,%eax
c01055f8:	01 d8                	add    %ebx,%eax
c01055fa:	83 e8 30             	sub    $0x30,%eax
c01055fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105600:	8b 45 10             	mov    0x10(%ebp),%eax
c0105603:	0f b6 00             	movzbl (%eax),%eax
c0105606:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105609:	83 fb 2f             	cmp    $0x2f,%ebx
c010560c:	7e 38                	jle    c0105646 <vprintfmt+0xe4>
c010560e:	83 fb 39             	cmp    $0x39,%ebx
c0105611:	7f 33                	jg     c0105646 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105613:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105616:	eb d4                	jmp    c01055ec <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105618:	8b 45 14             	mov    0x14(%ebp),%eax
c010561b:	8d 50 04             	lea    0x4(%eax),%edx
c010561e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105621:	8b 00                	mov    (%eax),%eax
c0105623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105626:	eb 1f                	jmp    c0105647 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105628:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010562c:	79 87                	jns    c01055b5 <vprintfmt+0x53>
                width = 0;
c010562e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105635:	e9 7b ff ff ff       	jmp    c01055b5 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010563a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105641:	e9 6f ff ff ff       	jmp    c01055b5 <vprintfmt+0x53>
            goto process_precision;
c0105646:	90                   	nop

        process_precision:
            if (width < 0)
c0105647:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010564b:	0f 89 64 ff ff ff    	jns    c01055b5 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105654:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105657:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010565e:	e9 52 ff ff ff       	jmp    c01055b5 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105663:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105666:	e9 4a ff ff ff       	jmp    c01055b5 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010566b:	8b 45 14             	mov    0x14(%ebp),%eax
c010566e:	8d 50 04             	lea    0x4(%eax),%edx
c0105671:	89 55 14             	mov    %edx,0x14(%ebp)
c0105674:	8b 00                	mov    (%eax),%eax
c0105676:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105679:	89 54 24 04          	mov    %edx,0x4(%esp)
c010567d:	89 04 24             	mov    %eax,(%esp)
c0105680:	8b 45 08             	mov    0x8(%ebp),%eax
c0105683:	ff d0                	call   *%eax
            break;
c0105685:	e9 a4 02 00 00       	jmp    c010592e <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010568a:	8b 45 14             	mov    0x14(%ebp),%eax
c010568d:	8d 50 04             	lea    0x4(%eax),%edx
c0105690:	89 55 14             	mov    %edx,0x14(%ebp)
c0105693:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105695:	85 db                	test   %ebx,%ebx
c0105697:	79 02                	jns    c010569b <vprintfmt+0x139>
                err = -err;
c0105699:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010569b:	83 fb 06             	cmp    $0x6,%ebx
c010569e:	7f 0b                	jg     c01056ab <vprintfmt+0x149>
c01056a0:	8b 34 9d b8 70 10 c0 	mov    -0x3fef8f48(,%ebx,4),%esi
c01056a7:	85 f6                	test   %esi,%esi
c01056a9:	75 23                	jne    c01056ce <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01056ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01056af:	c7 44 24 08 e5 70 10 	movl   $0xc01070e5,0x8(%esp)
c01056b6:	c0 
c01056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056be:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c1:	89 04 24             	mov    %eax,(%esp)
c01056c4:	e8 68 fe ff ff       	call   c0105531 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056c9:	e9 60 02 00 00       	jmp    c010592e <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01056ce:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01056d2:	c7 44 24 08 ee 70 10 	movl   $0xc01070ee,0x8(%esp)
c01056d9:	c0 
c01056da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e4:	89 04 24             	mov    %eax,(%esp)
c01056e7:	e8 45 fe ff ff       	call   c0105531 <printfmt>
            break;
c01056ec:	e9 3d 02 00 00       	jmp    c010592e <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01056f1:	8b 45 14             	mov    0x14(%ebp),%eax
c01056f4:	8d 50 04             	lea    0x4(%eax),%edx
c01056f7:	89 55 14             	mov    %edx,0x14(%ebp)
c01056fa:	8b 30                	mov    (%eax),%esi
c01056fc:	85 f6                	test   %esi,%esi
c01056fe:	75 05                	jne    c0105705 <vprintfmt+0x1a3>
                p = "(null)";
c0105700:	be f1 70 10 c0       	mov    $0xc01070f1,%esi
            }
            if (width > 0 && padc != '-') {
c0105705:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105709:	7e 76                	jle    c0105781 <vprintfmt+0x21f>
c010570b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010570f:	74 70                	je     c0105781 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105718:	89 34 24             	mov    %esi,(%esp)
c010571b:	e8 16 03 00 00       	call   c0105a36 <strnlen>
c0105720:	89 c2                	mov    %eax,%edx
c0105722:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105725:	29 d0                	sub    %edx,%eax
c0105727:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010572a:	eb 16                	jmp    c0105742 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010572c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105730:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105733:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105737:	89 04 24             	mov    %eax,(%esp)
c010573a:	8b 45 08             	mov    0x8(%ebp),%eax
c010573d:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c010573f:	ff 4d e8             	decl   -0x18(%ebp)
c0105742:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105746:	7f e4                	jg     c010572c <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105748:	eb 37                	jmp    c0105781 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010574a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010574e:	74 1f                	je     c010576f <vprintfmt+0x20d>
c0105750:	83 fb 1f             	cmp    $0x1f,%ebx
c0105753:	7e 05                	jle    c010575a <vprintfmt+0x1f8>
c0105755:	83 fb 7e             	cmp    $0x7e,%ebx
c0105758:	7e 15                	jle    c010576f <vprintfmt+0x20d>
                    putch('?', putdat);
c010575a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010575d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105761:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105768:	8b 45 08             	mov    0x8(%ebp),%eax
c010576b:	ff d0                	call   *%eax
c010576d:	eb 0f                	jmp    c010577e <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c010576f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105772:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105776:	89 1c 24             	mov    %ebx,(%esp)
c0105779:	8b 45 08             	mov    0x8(%ebp),%eax
c010577c:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010577e:	ff 4d e8             	decl   -0x18(%ebp)
c0105781:	89 f0                	mov    %esi,%eax
c0105783:	8d 70 01             	lea    0x1(%eax),%esi
c0105786:	0f b6 00             	movzbl (%eax),%eax
c0105789:	0f be d8             	movsbl %al,%ebx
c010578c:	85 db                	test   %ebx,%ebx
c010578e:	74 27                	je     c01057b7 <vprintfmt+0x255>
c0105790:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105794:	78 b4                	js     c010574a <vprintfmt+0x1e8>
c0105796:	ff 4d e4             	decl   -0x1c(%ebp)
c0105799:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010579d:	79 ab                	jns    c010574a <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c010579f:	eb 16                	jmp    c01057b7 <vprintfmt+0x255>
                putch(' ', putdat);
c01057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01057af:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b2:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01057b4:	ff 4d e8             	decl   -0x18(%ebp)
c01057b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057bb:	7f e4                	jg     c01057a1 <vprintfmt+0x23f>
            }
            break;
c01057bd:	e9 6c 01 00 00       	jmp    c010592e <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c9:	8d 45 14             	lea    0x14(%ebp),%eax
c01057cc:	89 04 24             	mov    %eax,(%esp)
c01057cf:	e8 16 fd ff ff       	call   c01054ea <getint>
c01057d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01057da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057e0:	85 d2                	test   %edx,%edx
c01057e2:	79 26                	jns    c010580a <vprintfmt+0x2a8>
                putch('-', putdat);
c01057e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057eb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01057f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f5:	ff d0                	call   *%eax
                num = -(long long)num;
c01057f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057fd:	f7 d8                	neg    %eax
c01057ff:	83 d2 00             	adc    $0x0,%edx
c0105802:	f7 da                	neg    %edx
c0105804:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105807:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010580a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105811:	e9 a8 00 00 00       	jmp    c01058be <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105816:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105820:	89 04 24             	mov    %eax,(%esp)
c0105823:	e8 73 fc ff ff       	call   c010549b <getuint>
c0105828:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010582b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010582e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105835:	e9 84 00 00 00       	jmp    c01058be <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010583a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010583d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105841:	8d 45 14             	lea    0x14(%ebp),%eax
c0105844:	89 04 24             	mov    %eax,(%esp)
c0105847:	e8 4f fc ff ff       	call   c010549b <getuint>
c010584c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010584f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105852:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105859:	eb 63                	jmp    c01058be <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010585b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105862:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105869:	8b 45 08             	mov    0x8(%ebp),%eax
c010586c:	ff d0                	call   *%eax
            putch('x', putdat);
c010586e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105871:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105875:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010587c:	8b 45 08             	mov    0x8(%ebp),%eax
c010587f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105881:	8b 45 14             	mov    0x14(%ebp),%eax
c0105884:	8d 50 04             	lea    0x4(%eax),%edx
c0105887:	89 55 14             	mov    %edx,0x14(%ebp)
c010588a:	8b 00                	mov    (%eax),%eax
c010588c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010588f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105896:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010589d:	eb 1f                	jmp    c01058be <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010589f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a6:	8d 45 14             	lea    0x14(%ebp),%eax
c01058a9:	89 04 24             	mov    %eax,(%esp)
c01058ac:	e8 ea fb ff ff       	call   c010549b <getuint>
c01058b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01058b7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058be:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058c5:	89 54 24 18          	mov    %edx,0x18(%esp)
c01058c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058cc:	89 54 24 14          	mov    %edx,0x14(%esp)
c01058d0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01058d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058da:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058de:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01058e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ec:	89 04 24             	mov    %eax,(%esp)
c01058ef:	e8 a5 fa ff ff       	call   c0105399 <printnum>
            break;
c01058f4:	eb 38                	jmp    c010592e <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fd:	89 1c 24             	mov    %ebx,(%esp)
c0105900:	8b 45 08             	mov    0x8(%ebp),%eax
c0105903:	ff d0                	call   *%eax
            break;
c0105905:	eb 27                	jmp    c010592e <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105907:	8b 45 0c             	mov    0xc(%ebp),%eax
c010590a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010590e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105915:	8b 45 08             	mov    0x8(%ebp),%eax
c0105918:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010591a:	ff 4d 10             	decl   0x10(%ebp)
c010591d:	eb 03                	jmp    c0105922 <vprintfmt+0x3c0>
c010591f:	ff 4d 10             	decl   0x10(%ebp)
c0105922:	8b 45 10             	mov    0x10(%ebp),%eax
c0105925:	48                   	dec    %eax
c0105926:	0f b6 00             	movzbl (%eax),%eax
c0105929:	3c 25                	cmp    $0x25,%al
c010592b:	75 f2                	jne    c010591f <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c010592d:	90                   	nop
    while (1) {
c010592e:	e9 37 fc ff ff       	jmp    c010556a <vprintfmt+0x8>
                return;
c0105933:	90                   	nop
        }
    }
}
c0105934:	83 c4 40             	add    $0x40,%esp
c0105937:	5b                   	pop    %ebx
c0105938:	5e                   	pop    %esi
c0105939:	5d                   	pop    %ebp
c010593a:	c3                   	ret    

c010593b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010593b:	55                   	push   %ebp
c010593c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010593e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105941:	8b 40 08             	mov    0x8(%eax),%eax
c0105944:	8d 50 01             	lea    0x1(%eax),%edx
c0105947:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010594d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105950:	8b 10                	mov    (%eax),%edx
c0105952:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105955:	8b 40 04             	mov    0x4(%eax),%eax
c0105958:	39 c2                	cmp    %eax,%edx
c010595a:	73 12                	jae    c010596e <sprintputch+0x33>
        *b->buf ++ = ch;
c010595c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595f:	8b 00                	mov    (%eax),%eax
c0105961:	8d 48 01             	lea    0x1(%eax),%ecx
c0105964:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105967:	89 0a                	mov    %ecx,(%edx)
c0105969:	8b 55 08             	mov    0x8(%ebp),%edx
c010596c:	88 10                	mov    %dl,(%eax)
    }
}
c010596e:	90                   	nop
c010596f:	5d                   	pop    %ebp
c0105970:	c3                   	ret    

c0105971 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105971:	55                   	push   %ebp
c0105972:	89 e5                	mov    %esp,%ebp
c0105974:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105977:	8d 45 14             	lea    0x14(%ebp),%eax
c010597a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010597d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105980:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105984:	8b 45 10             	mov    0x10(%ebp),%eax
c0105987:	89 44 24 08          	mov    %eax,0x8(%esp)
c010598b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105992:	8b 45 08             	mov    0x8(%ebp),%eax
c0105995:	89 04 24             	mov    %eax,(%esp)
c0105998:	e8 0a 00 00 00       	call   c01059a7 <vsnprintf>
c010599d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01059a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059a3:	89 ec                	mov    %ebp,%esp
c01059a5:	5d                   	pop    %ebp
c01059a6:	c3                   	ret    

c01059a7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01059a7:	55                   	push   %ebp
c01059a8:	89 e5                	mov    %esp,%ebp
c01059aa:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01059ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bc:	01 d0                	add    %edx,%eax
c01059be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059cc:	74 0a                	je     c01059d8 <vsnprintf+0x31>
c01059ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01059d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059d4:	39 c2                	cmp    %eax,%edx
c01059d6:	76 07                	jbe    c01059df <vsnprintf+0x38>
        return -E_INVAL;
c01059d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01059dd:	eb 2a                	jmp    c0105a09 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01059df:	8b 45 14             	mov    0x14(%ebp),%eax
c01059e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01059f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f4:	c7 04 24 3b 59 10 c0 	movl   $0xc010593b,(%esp)
c01059fb:	e8 62 fb ff ff       	call   c0105562 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a03:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a09:	89 ec                	mov    %ebp,%esp
c0105a0b:	5d                   	pop    %ebp
c0105a0c:	c3                   	ret    

c0105a0d <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a0d:	55                   	push   %ebp
c0105a0e:	89 e5                	mov    %esp,%ebp
c0105a10:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a1a:	eb 03                	jmp    c0105a1f <strlen+0x12>
        cnt ++;
c0105a1c:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a22:	8d 50 01             	lea    0x1(%eax),%edx
c0105a25:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a28:	0f b6 00             	movzbl (%eax),%eax
c0105a2b:	84 c0                	test   %al,%al
c0105a2d:	75 ed                	jne    c0105a1c <strlen+0xf>
    }
    return cnt;
c0105a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a32:	89 ec                	mov    %ebp,%esp
c0105a34:	5d                   	pop    %ebp
c0105a35:	c3                   	ret    

c0105a36 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a36:	55                   	push   %ebp
c0105a37:	89 e5                	mov    %esp,%ebp
c0105a39:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a43:	eb 03                	jmp    c0105a48 <strnlen+0x12>
        cnt ++;
c0105a45:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a4e:	73 10                	jae    c0105a60 <strnlen+0x2a>
c0105a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a53:	8d 50 01             	lea    0x1(%eax),%edx
c0105a56:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a59:	0f b6 00             	movzbl (%eax),%eax
c0105a5c:	84 c0                	test   %al,%al
c0105a5e:	75 e5                	jne    c0105a45 <strnlen+0xf>
    }
    return cnt;
c0105a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a63:	89 ec                	mov    %ebp,%esp
c0105a65:	5d                   	pop    %ebp
c0105a66:	c3                   	ret    

c0105a67 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a67:	55                   	push   %ebp
c0105a68:	89 e5                	mov    %esp,%ebp
c0105a6a:	57                   	push   %edi
c0105a6b:	56                   	push   %esi
c0105a6c:	83 ec 20             	sub    $0x20,%esp
c0105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a81:	89 d1                	mov    %edx,%ecx
c0105a83:	89 c2                	mov    %eax,%edx
c0105a85:	89 ce                	mov    %ecx,%esi
c0105a87:	89 d7                	mov    %edx,%edi
c0105a89:	ac                   	lods   %ds:(%esi),%al
c0105a8a:	aa                   	stos   %al,%es:(%edi)
c0105a8b:	84 c0                	test   %al,%al
c0105a8d:	75 fa                	jne    c0105a89 <strcpy+0x22>
c0105a8f:	89 fa                	mov    %edi,%edx
c0105a91:	89 f1                	mov    %esi,%ecx
c0105a93:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a96:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a9f:	83 c4 20             	add    $0x20,%esp
c0105aa2:	5e                   	pop    %esi
c0105aa3:	5f                   	pop    %edi
c0105aa4:	5d                   	pop    %ebp
c0105aa5:	c3                   	ret    

c0105aa6 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105aa6:	55                   	push   %ebp
c0105aa7:	89 e5                	mov    %esp,%ebp
c0105aa9:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105ab2:	eb 1e                	jmp    c0105ad2 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab7:	0f b6 10             	movzbl (%eax),%edx
c0105aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105abd:	88 10                	mov    %dl,(%eax)
c0105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ac2:	0f b6 00             	movzbl (%eax),%eax
c0105ac5:	84 c0                	test   %al,%al
c0105ac7:	74 03                	je     c0105acc <strncpy+0x26>
            src ++;
c0105ac9:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105acc:	ff 45 fc             	incl   -0x4(%ebp)
c0105acf:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105ad2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ad6:	75 dc                	jne    c0105ab4 <strncpy+0xe>
    }
    return dst;
c0105ad8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105adb:	89 ec                	mov    %ebp,%esp
c0105add:	5d                   	pop    %ebp
c0105ade:	c3                   	ret    

c0105adf <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105adf:	55                   	push   %ebp
c0105ae0:	89 e5                	mov    %esp,%ebp
c0105ae2:	57                   	push   %edi
c0105ae3:	56                   	push   %esi
c0105ae4:	83 ec 20             	sub    $0x20,%esp
c0105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af9:	89 d1                	mov    %edx,%ecx
c0105afb:	89 c2                	mov    %eax,%edx
c0105afd:	89 ce                	mov    %ecx,%esi
c0105aff:	89 d7                	mov    %edx,%edi
c0105b01:	ac                   	lods   %ds:(%esi),%al
c0105b02:	ae                   	scas   %es:(%edi),%al
c0105b03:	75 08                	jne    c0105b0d <strcmp+0x2e>
c0105b05:	84 c0                	test   %al,%al
c0105b07:	75 f8                	jne    c0105b01 <strcmp+0x22>
c0105b09:	31 c0                	xor    %eax,%eax
c0105b0b:	eb 04                	jmp    c0105b11 <strcmp+0x32>
c0105b0d:	19 c0                	sbb    %eax,%eax
c0105b0f:	0c 01                	or     $0x1,%al
c0105b11:	89 fa                	mov    %edi,%edx
c0105b13:	89 f1                	mov    %esi,%ecx
c0105b15:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b18:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b21:	83 c4 20             	add    $0x20,%esp
c0105b24:	5e                   	pop    %esi
c0105b25:	5f                   	pop    %edi
c0105b26:	5d                   	pop    %ebp
c0105b27:	c3                   	ret    

c0105b28 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b28:	55                   	push   %ebp
c0105b29:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b2b:	eb 09                	jmp    c0105b36 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105b2d:	ff 4d 10             	decl   0x10(%ebp)
c0105b30:	ff 45 08             	incl   0x8(%ebp)
c0105b33:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b3a:	74 1a                	je     c0105b56 <strncmp+0x2e>
c0105b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3f:	0f b6 00             	movzbl (%eax),%eax
c0105b42:	84 c0                	test   %al,%al
c0105b44:	74 10                	je     c0105b56 <strncmp+0x2e>
c0105b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b49:	0f b6 10             	movzbl (%eax),%edx
c0105b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4f:	0f b6 00             	movzbl (%eax),%eax
c0105b52:	38 c2                	cmp    %al,%dl
c0105b54:	74 d7                	je     c0105b2d <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b5a:	74 18                	je     c0105b74 <strncmp+0x4c>
c0105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5f:	0f b6 00             	movzbl (%eax),%eax
c0105b62:	0f b6 d0             	movzbl %al,%edx
c0105b65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b68:	0f b6 00             	movzbl (%eax),%eax
c0105b6b:	0f b6 c8             	movzbl %al,%ecx
c0105b6e:	89 d0                	mov    %edx,%eax
c0105b70:	29 c8                	sub    %ecx,%eax
c0105b72:	eb 05                	jmp    c0105b79 <strncmp+0x51>
c0105b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b79:	5d                   	pop    %ebp
c0105b7a:	c3                   	ret    

c0105b7b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b7b:	55                   	push   %ebp
c0105b7c:	89 e5                	mov    %esp,%ebp
c0105b7e:	83 ec 04             	sub    $0x4,%esp
c0105b81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b84:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b87:	eb 13                	jmp    c0105b9c <strchr+0x21>
        if (*s == c) {
c0105b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8c:	0f b6 00             	movzbl (%eax),%eax
c0105b8f:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105b92:	75 05                	jne    c0105b99 <strchr+0x1e>
            return (char *)s;
c0105b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b97:	eb 12                	jmp    c0105bab <strchr+0x30>
        }
        s ++;
c0105b99:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9f:	0f b6 00             	movzbl (%eax),%eax
c0105ba2:	84 c0                	test   %al,%al
c0105ba4:	75 e3                	jne    c0105b89 <strchr+0xe>
    }
    return NULL;
c0105ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bab:	89 ec                	mov    %ebp,%esp
c0105bad:	5d                   	pop    %ebp
c0105bae:	c3                   	ret    

c0105baf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105baf:	55                   	push   %ebp
c0105bb0:	89 e5                	mov    %esp,%ebp
c0105bb2:	83 ec 04             	sub    $0x4,%esp
c0105bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bbb:	eb 0e                	jmp    c0105bcb <strfind+0x1c>
        if (*s == c) {
c0105bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc0:	0f b6 00             	movzbl (%eax),%eax
c0105bc3:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105bc6:	74 0f                	je     c0105bd7 <strfind+0x28>
            break;
        }
        s ++;
c0105bc8:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bce:	0f b6 00             	movzbl (%eax),%eax
c0105bd1:	84 c0                	test   %al,%al
c0105bd3:	75 e8                	jne    c0105bbd <strfind+0xe>
c0105bd5:	eb 01                	jmp    c0105bd8 <strfind+0x29>
            break;
c0105bd7:	90                   	nop
    }
    return (char *)s;
c0105bd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bdb:	89 ec                	mov    %ebp,%esp
c0105bdd:	5d                   	pop    %ebp
c0105bde:	c3                   	ret    

c0105bdf <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105bdf:	55                   	push   %ebp
c0105be0:	89 e5                	mov    %esp,%ebp
c0105be2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105bec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bf3:	eb 03                	jmp    c0105bf8 <strtol+0x19>
        s ++;
c0105bf5:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfb:	0f b6 00             	movzbl (%eax),%eax
c0105bfe:	3c 20                	cmp    $0x20,%al
c0105c00:	74 f3                	je     c0105bf5 <strtol+0x16>
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	0f b6 00             	movzbl (%eax),%eax
c0105c08:	3c 09                	cmp    $0x9,%al
c0105c0a:	74 e9                	je     c0105bf5 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0f:	0f b6 00             	movzbl (%eax),%eax
c0105c12:	3c 2b                	cmp    $0x2b,%al
c0105c14:	75 05                	jne    c0105c1b <strtol+0x3c>
        s ++;
c0105c16:	ff 45 08             	incl   0x8(%ebp)
c0105c19:	eb 14                	jmp    c0105c2f <strtol+0x50>
    }
    else if (*s == '-') {
c0105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1e:	0f b6 00             	movzbl (%eax),%eax
c0105c21:	3c 2d                	cmp    $0x2d,%al
c0105c23:	75 0a                	jne    c0105c2f <strtol+0x50>
        s ++, neg = 1;
c0105c25:	ff 45 08             	incl   0x8(%ebp)
c0105c28:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c33:	74 06                	je     c0105c3b <strtol+0x5c>
c0105c35:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c39:	75 22                	jne    c0105c5d <strtol+0x7e>
c0105c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3e:	0f b6 00             	movzbl (%eax),%eax
c0105c41:	3c 30                	cmp    $0x30,%al
c0105c43:	75 18                	jne    c0105c5d <strtol+0x7e>
c0105c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c48:	40                   	inc    %eax
c0105c49:	0f b6 00             	movzbl (%eax),%eax
c0105c4c:	3c 78                	cmp    $0x78,%al
c0105c4e:	75 0d                	jne    c0105c5d <strtol+0x7e>
        s += 2, base = 16;
c0105c50:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c54:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c5b:	eb 29                	jmp    c0105c86 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105c5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c61:	75 16                	jne    c0105c79 <strtol+0x9a>
c0105c63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c66:	0f b6 00             	movzbl (%eax),%eax
c0105c69:	3c 30                	cmp    $0x30,%al
c0105c6b:	75 0c                	jne    c0105c79 <strtol+0x9a>
        s ++, base = 8;
c0105c6d:	ff 45 08             	incl   0x8(%ebp)
c0105c70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c77:	eb 0d                	jmp    c0105c86 <strtol+0xa7>
    }
    else if (base == 0) {
c0105c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c7d:	75 07                	jne    c0105c86 <strtol+0xa7>
        base = 10;
c0105c7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c89:	0f b6 00             	movzbl (%eax),%eax
c0105c8c:	3c 2f                	cmp    $0x2f,%al
c0105c8e:	7e 1b                	jle    c0105cab <strtol+0xcc>
c0105c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c93:	0f b6 00             	movzbl (%eax),%eax
c0105c96:	3c 39                	cmp    $0x39,%al
c0105c98:	7f 11                	jg     c0105cab <strtol+0xcc>
            dig = *s - '0';
c0105c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9d:	0f b6 00             	movzbl (%eax),%eax
c0105ca0:	0f be c0             	movsbl %al,%eax
c0105ca3:	83 e8 30             	sub    $0x30,%eax
c0105ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ca9:	eb 48                	jmp    c0105cf3 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cae:	0f b6 00             	movzbl (%eax),%eax
c0105cb1:	3c 60                	cmp    $0x60,%al
c0105cb3:	7e 1b                	jle    c0105cd0 <strtol+0xf1>
c0105cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb8:	0f b6 00             	movzbl (%eax),%eax
c0105cbb:	3c 7a                	cmp    $0x7a,%al
c0105cbd:	7f 11                	jg     c0105cd0 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc2:	0f b6 00             	movzbl (%eax),%eax
c0105cc5:	0f be c0             	movsbl %al,%eax
c0105cc8:	83 e8 57             	sub    $0x57,%eax
c0105ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cce:	eb 23                	jmp    c0105cf3 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd3:	0f b6 00             	movzbl (%eax),%eax
c0105cd6:	3c 40                	cmp    $0x40,%al
c0105cd8:	7e 3b                	jle    c0105d15 <strtol+0x136>
c0105cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdd:	0f b6 00             	movzbl (%eax),%eax
c0105ce0:	3c 5a                	cmp    $0x5a,%al
c0105ce2:	7f 31                	jg     c0105d15 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce7:	0f b6 00             	movzbl (%eax),%eax
c0105cea:	0f be c0             	movsbl %al,%eax
c0105ced:	83 e8 37             	sub    $0x37,%eax
c0105cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf6:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cf9:	7d 19                	jge    c0105d14 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105cfb:	ff 45 08             	incl   0x8(%ebp)
c0105cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d01:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d05:	89 c2                	mov    %eax,%edx
c0105d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d0a:	01 d0                	add    %edx,%eax
c0105d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105d0f:	e9 72 ff ff ff       	jmp    c0105c86 <strtol+0xa7>
            break;
c0105d14:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105d15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d19:	74 08                	je     c0105d23 <strtol+0x144>
        *endptr = (char *) s;
c0105d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d21:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d27:	74 07                	je     c0105d30 <strtol+0x151>
c0105d29:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d2c:	f7 d8                	neg    %eax
c0105d2e:	eb 03                	jmp    c0105d33 <strtol+0x154>
c0105d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d33:	89 ec                	mov    %ebp,%esp
c0105d35:	5d                   	pop    %ebp
c0105d36:	c3                   	ret    

c0105d37 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d37:	55                   	push   %ebp
c0105d38:	89 e5                	mov    %esp,%ebp
c0105d3a:	83 ec 28             	sub    $0x28,%esp
c0105d3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105d40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d43:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d46:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105d50:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105d53:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d5c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d60:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d63:	89 d7                	mov    %edx,%edi
c0105d65:	f3 aa                	rep stos %al,%es:(%edi)
c0105d67:	89 fa                	mov    %edi,%edx
c0105d69:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d6c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d72:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105d75:	89 ec                	mov    %ebp,%esp
c0105d77:	5d                   	pop    %ebp
c0105d78:	c3                   	ret    

c0105d79 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d79:	55                   	push   %ebp
c0105d7a:	89 e5                	mov    %esp,%ebp
c0105d7c:	57                   	push   %edi
c0105d7d:	56                   	push   %esi
c0105d7e:	53                   	push   %ebx
c0105d7f:	83 ec 30             	sub    $0x30,%esp
c0105d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d91:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d9a:	73 42                	jae    c0105dde <memmove+0x65>
c0105d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105da5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dab:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105db1:	c1 e8 02             	shr    $0x2,%eax
c0105db4:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105db6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dbc:	89 d7                	mov    %edx,%edi
c0105dbe:	89 c6                	mov    %eax,%esi
c0105dc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dc2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105dc5:	83 e1 03             	and    $0x3,%ecx
c0105dc8:	74 02                	je     c0105dcc <memmove+0x53>
c0105dca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dcc:	89 f0                	mov    %esi,%eax
c0105dce:	89 fa                	mov    %edi,%edx
c0105dd0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105dd3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dd6:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105ddc:	eb 36                	jmp    c0105e14 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105de1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105de7:	01 c2                	add    %eax,%edx
c0105de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dec:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105df2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105df8:	89 c1                	mov    %eax,%ecx
c0105dfa:	89 d8                	mov    %ebx,%eax
c0105dfc:	89 d6                	mov    %edx,%esi
c0105dfe:	89 c7                	mov    %eax,%edi
c0105e00:	fd                   	std    
c0105e01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e03:	fc                   	cld    
c0105e04:	89 f8                	mov    %edi,%eax
c0105e06:	89 f2                	mov    %esi,%edx
c0105e08:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e0b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e14:	83 c4 30             	add    $0x30,%esp
c0105e17:	5b                   	pop    %ebx
c0105e18:	5e                   	pop    %esi
c0105e19:	5f                   	pop    %edi
c0105e1a:	5d                   	pop    %ebp
c0105e1b:	c3                   	ret    

c0105e1c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e1c:	55                   	push   %ebp
c0105e1d:	89 e5                	mov    %esp,%ebp
c0105e1f:	57                   	push   %edi
c0105e20:	56                   	push   %esi
c0105e21:	83 ec 20             	sub    $0x20,%esp
c0105e24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e30:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e33:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e39:	c1 e8 02             	shr    $0x2,%eax
c0105e3c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e44:	89 d7                	mov    %edx,%edi
c0105e46:	89 c6                	mov    %eax,%esi
c0105e48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e4a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e4d:	83 e1 03             	and    $0x3,%ecx
c0105e50:	74 02                	je     c0105e54 <memcpy+0x38>
c0105e52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e54:	89 f0                	mov    %esi,%eax
c0105e56:	89 fa                	mov    %edi,%edx
c0105e58:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e64:	83 c4 20             	add    $0x20,%esp
c0105e67:	5e                   	pop    %esi
c0105e68:	5f                   	pop    %edi
c0105e69:	5d                   	pop    %ebp
c0105e6a:	c3                   	ret    

c0105e6b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e6b:	55                   	push   %ebp
c0105e6c:	89 e5                	mov    %esp,%ebp
c0105e6e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e7d:	eb 2e                	jmp    c0105ead <memcmp+0x42>
        if (*s1 != *s2) {
c0105e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e82:	0f b6 10             	movzbl (%eax),%edx
c0105e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e88:	0f b6 00             	movzbl (%eax),%eax
c0105e8b:	38 c2                	cmp    %al,%dl
c0105e8d:	74 18                	je     c0105ea7 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e92:	0f b6 00             	movzbl (%eax),%eax
c0105e95:	0f b6 d0             	movzbl %al,%edx
c0105e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e9b:	0f b6 00             	movzbl (%eax),%eax
c0105e9e:	0f b6 c8             	movzbl %al,%ecx
c0105ea1:	89 d0                	mov    %edx,%eax
c0105ea3:	29 c8                	sub    %ecx,%eax
c0105ea5:	eb 18                	jmp    c0105ebf <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105ea7:	ff 45 fc             	incl   -0x4(%ebp)
c0105eaa:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105ead:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eb0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eb3:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eb6:	85 c0                	test   %eax,%eax
c0105eb8:	75 c5                	jne    c0105e7f <memcmp+0x14>
    }
    return 0;
c0105eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ebf:	89 ec                	mov    %ebp,%esp
c0105ec1:	5d                   	pop    %ebp
c0105ec2:	c3                   	ret    
