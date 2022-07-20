
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
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
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
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
c010003c:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c0100041:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c0100059:	e8 1c 5e 00 00       	call   c0105e7a <memset>

    cons_init();                // init the console
c010005e:	e8 f7 15 00 00       	call   c010165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 20 60 10 c0 	movl   $0xc0106020,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 3c 60 10 c0 	movl   $0xc010603c,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 f8 44 00 00       	call   c0104584 <pmm_init>

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
c010015a:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 41 60 10 c0 	movl   $0xc0106041,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 5d 60 10 c0 	movl   $0xc010605d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 60 10 c0 	movl   $0xc010606b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 79 60 10 c0 	movl   $0xc0106079,(%esp)
c01001ea:	e8 67 01 00 00       	call   c0100356 <cprintf>
    round ++;
c01001ef:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
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
c0100216:	c7 04 24 88 60 10 c0 	movl   $0xc0106088,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 a8 60 10 c0 	movl   $0xc01060a8,(%esp)
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
c010025a:	c7 04 24 c7 60 10 c0 	movl   $0xc01060c7,(%esp)
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
c01002a8:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
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
c01002e6:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c01002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ee:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
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
c010034a:	e8 56 53 00 00       	call   c01056a5 <vprintfmt>
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
c010055a:	c7 00 cc 60 10 c0    	movl   $0xc01060cc,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 cc 60 10 c0 	movl   $0xc01060cc,0x8(%eax)
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
c0100591:	c7 45 f4 a0 73 10 c0 	movl   $0xc01073a0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 48 2b 11 c0 	movl   $0xc0112b48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec 49 2b 11 c0 	movl   $0xc0112b49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 c1 60 11 c0 	movl   $0xc01160c1,-0x18(%ebp)

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
c01006f9:	e8 f4 55 00 00       	call   c0105cf2 <strfind>
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
c010087f:	c7 04 24 d6 60 10 c0 	movl   $0xc01060d6,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 ef 60 10 c0 	movl   $0xc01060ef,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 06 60 10 	movl   $0xc0106006,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 07 61 10 c0 	movl   $0xc0106107,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 1f 61 10 c0 	movl   $0xc010611f,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c cf 11 	movl   $0xc011cf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 37 61 10 c0 	movl   $0xc0106137,(%esp)
c01008d6:	e8 7b fa ff ff       	call   c0100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008db:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c01008e0:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f0:	85 c0                	test   %eax,%eax
c01008f2:	0f 48 c2             	cmovs  %edx,%eax
c01008f5:	c1 f8 0a             	sar    $0xa,%eax
c01008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fc:	c7 04 24 50 61 10 c0 	movl   $0xc0106150,(%esp)
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
c0100933:	c7 04 24 7a 61 10 c0 	movl   $0xc010617a,(%esp)
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
c01009a1:	c7 04 24 96 61 10 c0 	movl   $0xc0106196,(%esp)
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
c0100a05:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
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
c0100a41:	c7 04 24 c0 61 10 c0 	movl   $0xc01061c0,(%esp)
c0100a48:	e8 09 f9 ff ff       	call   c0100356 <cprintf>

        cprintf("\n");
c0100a4d:	c7 04 24 e1 61 10 c0 	movl   $0xc01061e1,(%esp)
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
c0100ac2:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
c0100ac9:	e8 f0 51 00 00       	call   c0105cbe <strchr>
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
c0100aea:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
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
c0100b2c:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
c0100b33:	e8 86 51 00 00       	call   c0105cbe <strchr>
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
c0100b8f:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100b94:	8b 00                	mov    (%eax),%eax
c0100b96:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9a:	89 04 24             	mov    %eax,(%esp)
c0100b9d:	e8 80 50 00 00       	call   c0105c22 <strcmp>
c0100ba2:	85 c0                	test   %eax,%eax
c0100ba4:	75 31                	jne    c0100bd7 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba9:	89 d0                	mov    %edx,%eax
c0100bab:	01 c0                	add    %eax,%eax
c0100bad:	01 d0                	add    %edx,%eax
c0100baf:	c1 e0 02             	shl    $0x2,%eax
c0100bb2:	05 08 90 11 c0       	add    $0xc0119008,%eax
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
c0100be9:	c7 04 24 87 62 10 c0 	movl   $0xc0106287,(%esp)
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
c0100c07:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c0100c0e:	e8 43 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c13:	c7 04 24 c8 62 10 c0 	movl   $0xc01062c8,(%esp)
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
c0100c30:	c7 04 24 ed 62 10 c0 	movl   $0xc01062ed,(%esp)
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
c0100c7e:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100c83:	8b 10                	mov    (%eax),%edx
c0100c85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c88:	89 c8                	mov    %ecx,%eax
c0100c8a:	01 c0                	add    %eax,%eax
c0100c8c:	01 c8                	add    %ecx,%eax
c0100c8e:	c1 e0 02             	shl    $0x2,%eax
c0100c91:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c96:	8b 00                	mov    (%eax),%eax
c0100c98:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca0:	c7 04 24 f1 62 10 c0 	movl   $0xc01062f1,(%esp)
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
c0100cee:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100cf3:	85 c0                	test   %eax,%eax
c0100cf5:	75 5b                	jne    c0100d52 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cf7:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
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
c0100d15:	c7 04 24 fa 62 10 c0 	movl   $0xc01062fa,(%esp)
c0100d1c:	e8 35 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d28:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2b:	89 04 24             	mov    %eax,(%esp)
c0100d2e:	e8 ee f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d33:	c7 04 24 16 63 10 c0 	movl   $0xc0106316,(%esp)
c0100d3a:	e8 17 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3f:	c7 04 24 18 63 10 c0 	movl   $0xc0106318,(%esp)
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
c0100d80:	c7 04 24 2a 63 10 c0 	movl   $0xc010632a,(%esp)
c0100d87:	e8 ca f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d96:	89 04 24             	mov    %eax,(%esp)
c0100d99:	e8 83 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d9e:	c7 04 24 16 63 10 c0 	movl   $0xc0106316,(%esp)
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
c0100db2:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
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
c0100dfb:	c7 05 24 c4 11 c0 00 	movl   $0x0,0xc011c424
c0100e02:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e05:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
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
c0100ee5:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100eec:	b4 03 
c0100eee:	eb 13                	jmp    c0100f03 <cga_init+0x54>
    } else {
        *cp = was;
c0100ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ef7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100efa:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f01:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f03:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f0a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f0e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f12:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f16:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1a:	ee                   	out    %al,(%dx)
}
c0100f1b:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f1c:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
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
c0100f42:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f49:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f51:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f55:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f59:	ee                   	out    %al,(%dx)
}
c0100f5a:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f5b:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
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
c0100f81:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f89:	0f b7 c0             	movzwl %ax,%eax
c0100f8c:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
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
c0101045:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
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
c010106a:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
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
c0101183:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010118a:	85 c0                	test   %eax,%eax
c010118c:	0f 84 af 00 00 00    	je     c0101241 <cga_putc+0xfd>
            crt_pos --;
c0101192:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101199:	48                   	dec    %eax
c010119a:	0f b7 c0             	movzwl %ax,%eax
c010119d:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a6:	98                   	cwtl   
c01011a7:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ac:	98                   	cwtl   
c01011ad:	83 c8 20             	or     $0x20,%eax
c01011b0:	98                   	cwtl   
c01011b1:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c01011b7:	0f b7 15 44 c4 11 c0 	movzwl 0xc011c444,%edx
c01011be:	01 d2                	add    %edx,%edx
c01011c0:	01 ca                	add    %ecx,%edx
c01011c2:	0f b7 c0             	movzwl %ax,%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011c8:	eb 77                	jmp    c0101241 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011ca:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011d1:	83 c0 50             	add    $0x50,%eax
c01011d4:	0f b7 c0             	movzwl %ax,%eax
c01011d7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011dd:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c01011e4:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
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
c010120f:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c0101215:	eb 2b                	jmp    c0101242 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101217:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c010121d:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101224:	8d 50 01             	lea    0x1(%eax),%edx
c0101227:	0f b7 d2             	movzwl %dx,%edx
c010122a:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
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
c0101242:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101249:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c010124e:	76 5e                	jbe    c01012ae <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101250:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101255:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125b:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101260:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101267:	00 
c0101268:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126c:	89 04 24             	mov    %eax,(%esp)
c010126f:	e8 48 4c 00 00       	call   c0105ebc <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101274:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127b:	eb 15                	jmp    c0101292 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c010127d:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
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
c010129b:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012a2:	83 e8 50             	sub    $0x50,%eax
c01012a5:	0f b7 c0             	movzwl %ax,%eax
c01012a8:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012ae:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012b5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012b9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012bd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c5:	ee                   	out    %al,(%dx)
}
c01012c6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012c7:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012ce:	c1 e8 08             	shr    $0x8,%eax
c01012d1:	0f b7 c0             	movzwl %ax,%eax
c01012d4:	0f b6 c0             	movzbl %al,%eax
c01012d7:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
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
c01012f3:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012fa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012fe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101302:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101306:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130a:	ee                   	out    %al,(%dx)
}
c010130b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010130c:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101313:	0f b6 c0             	movzbl %al,%eax
c0101316:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
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
c01013e6:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01013eb:	8d 50 01             	lea    0x1(%eax),%edx
c01013ee:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c01013f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f7:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013fd:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101402:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101407:	75 0a                	jne    c0101413 <cons_intr+0x3b>
                cons.wpos = 0;
c0101409:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
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
c0101486:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
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
c01014e9:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01014ee:	83 c8 40             	or     $0x40,%eax
c01014f1:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c01014f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014fb:	e9 23 01 00 00       	jmp    c0101623 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101500:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101504:	84 c0                	test   %al,%al
c0101506:	79 45                	jns    c010154d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101508:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
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
c0101527:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c010152e:	0c 40                	or     $0x40,%al
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	f7 d0                	not    %eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010153c:	21 d0                	and    %edx,%eax
c010153e:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101543:	b8 00 00 00 00       	mov    $0x0,%eax
c0101548:	e9 d6 00 00 00       	jmp    c0101623 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c010154d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101552:	83 e0 40             	and    $0x40,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 11                	je     c010156a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101559:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010155d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101562:	83 e0 bf             	and    $0xffffffbf,%eax
c0101565:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c010156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156e:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101575:	0f b6 d0             	movzbl %al,%edx
c0101578:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010157d:	09 d0                	or     %edx,%eax
c010157f:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c0101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101588:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c010158f:	0f b6 d0             	movzbl %al,%edx
c0101592:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101597:	31 d0                	xor    %edx,%eax
c0101599:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c010159e:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015a3:	83 e0 03             	and    $0x3,%eax
c01015a6:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b1:	01 d0                	add    %edx,%eax
c01015b3:	0f b6 00             	movzbl (%eax),%eax
c01015b6:	0f b6 c0             	movzbl %al,%eax
c01015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015bc:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
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
c01015ea:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015ef:	f7 d0                	not    %eax
c01015f1:	83 e0 06             	and    $0x6,%eax
c01015f4:	85 c0                	test   %eax,%eax
c01015f6:	75 28                	jne    c0101620 <kbd_proc_data+0x180>
c01015f8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015ff:	75 1f                	jne    c0101620 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101601:	c7 04 24 63 63 10 c0 	movl   $0xc0106363,(%esp)
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
c010166f:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101674:	85 c0                	test   %eax,%eax
c0101676:	75 0c                	jne    c0101684 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101678:	c7 04 24 6f 63 10 c0 	movl   $0xc010636f,(%esp)
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
c01016e7:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c01016ed:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01016f2:	39 c2                	cmp    %eax,%edx
c01016f4:	74 31                	je     c0101727 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016f6:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c01016fb:	8d 50 01             	lea    0x1(%eax),%edx
c01016fe:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c0101704:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c010170b:	0f b6 c0             	movzbl %al,%eax
c010170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101711:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101716:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171b:	75 0a                	jne    c0101727 <cons_getc+0x5f>
                cons.rpos = 0;
c010171d:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
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
c0101759:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c010175f:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
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
c01017c0:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
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
c01017e1:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
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
c0101903:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010190a:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010190f:	74 0f                	je     c0101920 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101911:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
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
c0101933:	c7 04 24 a0 63 10 c0 	movl   $0xc01063a0,(%esp)
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
c010194a:	c7 45 f0 e0 95 11 c0 	movl   $0xc01195e0,-0x10(%ebp)

    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
c0101951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101958:	e9 c4 00 00 00       	jmp    c0101a21 <idt_init+0xdd>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL)
c010195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101960:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101967:	0f b7 d0             	movzwl %ax,%edx
c010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010196d:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c0101974:	c0 
c0101975:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101978:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c010197f:	c0 08 00 
c0101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101985:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c010198c:	c0 
c010198d:	80 e2 e0             	and    $0xe0,%dl
c0101990:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010199a:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019a1:	c0 
c01019a2:	80 e2 1f             	and    $0x1f,%dl
c01019a5:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019af:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019b6:	c0 
c01019b7:	80 e2 f0             	and    $0xf0,%dl
c01019ba:	80 ca 0e             	or     $0xe,%dl
c01019bd:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019c7:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019ce:	c0 
c01019cf:	80 e2 ef             	and    $0xef,%dl
c01019d2:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019dc:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019e3:	c0 
c01019e4:	80 e2 9f             	and    $0x9f,%dl
c01019e7:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f1:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019f8:	c0 
c01019f9:	80 ca 80             	or     $0x80,%dl
c01019fc:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a06:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a0d:	c1 e8 10             	shr    $0x10,%eax
c0101a10:	0f b7 d0             	movzwl %ax,%edx
c0101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a16:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a1d:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
c0101a1e:	ff 45 f4             	incl   -0xc(%ebp)
c0101a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a24:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a29:	0f 86 2e ff ff ff    	jbe    c010195d <idt_init+0x19>
c0101a2f:	c7 45 ec 60 95 11 c0 	movl   $0xc0119560,-0x14(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a39:	0f 01 18             	lidtl  (%eax)
}
c0101a3c:	90                   	nop
    }

    lidt(&idt_pd);

    cprintf("test");
c0101a3d:	c7 04 24 aa 63 10 c0 	movl   $0xc01063aa,(%esp)
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
c0101a5c:	8b 04 85 00 67 10 c0 	mov    -0x3fef9900(,%eax,4),%eax
c0101a63:	eb 18                	jmp    c0101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a69:	7e 0d                	jle    c0101a78 <trapname+0x2a>
c0101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6f:	7f 07                	jg     c0101a78 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a71:	b8 af 63 10 c0       	mov    $0xc01063af,%eax
c0101a76:	eb 05                	jmp    c0101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a78:	b8 c2 63 10 c0       	mov    $0xc01063c2,%eax
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
c0101aa1:	c7 04 24 03 64 10 c0 	movl   $0xc0106403,(%esp)
c0101aa8:	e8 a9 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	89 04 24             	mov    %eax,(%esp)
c0101ab3:	e8 8f 01 00 00       	call   c0101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 14 64 10 c0 	movl   $0xc0106414,(%esp)
c0101aca:	e8 87 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ada:	c7 04 24 27 64 10 c0 	movl   $0xc0106427,(%esp)
c0101ae1:	e8 70 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af1:	c7 04 24 3a 64 10 c0 	movl   $0xc010643a,(%esp)
c0101af8:	e8 59 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b08:	c7 04 24 4d 64 10 c0 	movl   $0xc010644d,(%esp)
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
c0101b30:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101b37:	e8 1a e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	8b 40 34             	mov    0x34(%eax),%eax
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 72 64 10 c0 	movl   $0xc0106472,(%esp)
c0101b4d:	e8 04 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	8b 40 38             	mov    0x38(%eax),%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 81 64 10 c0 	movl   $0xc0106481,(%esp)
c0101b63:	e8 ee e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b73:	c7 04 24 90 64 10 c0 	movl   $0xc0106490,(%esp)
c0101b7a:	e8 d7 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b82:	8b 40 40             	mov    0x40(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 a3 64 10 c0 	movl   $0xc01064a3,(%esp)
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
c0101bb7:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101bbe:	85 c0                	test   %eax,%eax
c0101bc0:	74 1a                	je     c0101bdc <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc5:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd0:	c7 04 24 b2 64 10 c0 	movl   $0xc01064b2,(%esp)
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
c0101bfa:	c7 04 24 b6 64 10 c0 	movl   $0xc01064b6,(%esp)
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
c0101c1f:	c7 04 24 bf 64 10 c0 	movl   $0xc01064bf,(%esp)
c0101c26:	e8 2b e7 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c36:	c7 04 24 ce 64 10 c0 	movl   $0xc01064ce,(%esp)
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
c0101c56:	c7 04 24 e1 64 10 c0 	movl   $0xc01064e1,(%esp)
c0101c5d:	e8 f4 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c65:	8b 40 04             	mov    0x4(%eax),%eax
c0101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6c:	c7 04 24 f0 64 10 c0 	movl   $0xc01064f0,(%esp)
c0101c73:	e8 de e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c82:	c7 04 24 ff 64 10 c0 	movl   $0xc01064ff,(%esp)
c0101c89:	e8 c8 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c98:	c7 04 24 0e 65 10 c0 	movl   $0xc010650e,(%esp)
c0101c9f:	e8 b2 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 10             	mov    0x10(%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 1d 65 10 c0 	movl   $0xc010651d,(%esp)
c0101cb5:	e8 9c e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 2c 65 10 c0 	movl   $0xc010652c,(%esp)
c0101ccb:	e8 86 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 18             	mov    0x18(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 3b 65 10 c0 	movl   $0xc010653b,(%esp)
c0101ce1:	e8 70 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 4a 65 10 c0 	movl   $0xc010654a,(%esp)
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
c0101d4e:	a1 24 c4 11 c0       	mov    0xc011c424,%eax
c0101d53:	40                   	inc    %eax
c0101d54:	a3 24 c4 11 c0       	mov    %eax,0xc011c424
            if (ticks % TICK_NUM == 0){
c0101d59:	8b 0d 24 c4 11 c0    	mov    0xc011c424,%ecx
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
c0101dac:	c7 04 24 59 65 10 c0 	movl   $0xc0106559,(%esp)
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
c0101dd2:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0101dd9:	e8 78 e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101dde:	eb 55                	jmp    c0101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de0:	c7 44 24 08 7a 65 10 	movl   $0xc010657a,0x8(%esp)
c0101de7:	c0 
c0101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101def:	00 
c0101df0:	c7 04 24 8a 65 10 c0 	movl   $0xc010658a,(%esp)
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
c0101e15:	c7 44 24 08 9b 65 10 	movl   $0xc010659b,0x8(%esp)
c0101e1c:	c0 
c0101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0101e24:	00 
c0101e25:	c7 04 24 8a 65 10 c0 	movl   $0xc010658a,(%esp)
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
c01028e7:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
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
c0102933:	c7 45 fc 80 ce 11 c0 	movl   $0xc011ce80,-0x4(%ebp)
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
c010294f:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
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
c010296a:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0102971:	c0 
c0102972:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102979:	c0 
c010297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102981:	00 
c0102982:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102989:	e8 5a e3 ff ff       	call   c0100ce8 <__panic>
    struct Page *p = base;
c010298e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102991:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++) {
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
c01029c2:	c7 44 24 0c 81 67 10 	movl   $0xc0106781,0xc(%esp)
c01029c9:	c0 
c01029ca:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01029d1:	c0 
c01029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01029d9:	00 
c01029da:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
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
    for (; p != base + n; p++) {
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
c0102a53:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102a59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a5c:	01 d0                	add    %edx,%eax
c0102a5e:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
    list_add(&free_list, &(base->page_link));
c0102a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a66:	83 c0 0c             	add    $0xc,%eax
c0102a69:	c7 45 e4 80 ce 11 c0 	movl   $0xc011ce80,-0x1c(%ebp)
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
c0102acc:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0102ad3:	c0 
c0102ad4:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102adb:	c0 
c0102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102ae3:	00 
c0102ae4:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102aeb:	e8 f8 e1 ff ff       	call   c0100ce8 <__panic>
    if (n > nr_free) {
c0102af0:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102af5:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102af8:	76 0a                	jbe    c0102b04 <default_alloc_pages+0x44>
        return NULL;
c0102afa:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aff:	e9 4e 01 00 00       	jmp    c0102c52 <default_alloc_pages+0x192>
    }
    struct Page *page = NULL;
c0102b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b0b:	c7 45 f0 80 ce 11 c0 	movl   $0xc011ce80,-0x10(%ebp)
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
c0102b3f:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102b46:	75 cc                	jne    c0102b14 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0102b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b4c:	0f 84 fd 00 00 00    	je     c0102c4f <default_alloc_pages+0x18f>

        if (page->property > n) {
c0102b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b55:	8b 40 08             	mov    0x8(%eax),%eax
c0102b58:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b5b:	0f 83 9a 00 00 00    	jae    c0102bfb <default_alloc_pages+0x13b>
            struct Page *p = page + n;
c0102b61:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b64:	89 d0                	mov    %edx,%eax
c0102b66:	c1 e0 02             	shl    $0x2,%eax
c0102b69:	01 d0                	add    %edx,%eax
c0102b6b:	c1 e0 02             	shl    $0x2,%eax
c0102b6e:	89 c2                	mov    %eax,%edx
c0102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b73:	01 d0                	add    %edx,%eax
c0102b75:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7b:	8b 40 08             	mov    0x8(%eax),%eax
c0102b7e:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b81:	89 c2                	mov    %eax,%edx
c0102b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b86:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b8c:	83 c0 04             	add    $0x4,%eax
c0102b8f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102b96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b99:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b9c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b9f:	0f ab 10             	bts    %edx,(%eax)
}
c0102ba2:	90                   	nop
            list_add(&free_list, &(p->page_link)); //?
c0102ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ba6:	83 c0 0c             	add    $0xc,%eax
c0102ba9:	c7 45 e0 80 ce 11 c0 	movl   $0xc011ce80,-0x20(%ebp)
c0102bb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102bbf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bc2:	8b 40 04             	mov    0x4(%eax),%eax
c0102bc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102bc8:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102bcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bce:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102bd1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0102bd4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102bd7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102bda:	89 10                	mov    %edx,(%eax)
c0102bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102bdf:	8b 10                	mov    (%eax),%edx
c0102be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102be4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102be7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bea:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bed:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bf3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bf6:	89 10                	mov    %edx,(%eax)
}
c0102bf8:	90                   	nop
}
c0102bf9:	90                   	nop
}
c0102bfa:	90                   	nop
        }
        list_del(&(page->page_link));
c0102bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bfe:	83 c0 0c             	add    $0xc,%eax
c0102c01:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102c04:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c07:	8b 40 04             	mov    0x4(%eax),%eax
c0102c0a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102c0d:	8b 12                	mov    (%edx),%edx
c0102c0f:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102c12:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c15:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c18:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c1b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c1e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102c21:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c24:	89 10                	mov    %edx,(%eax)
}
c0102c26:	90                   	nop
}
c0102c27:	90                   	nop
        nr_free -= n;
c0102c28:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102c2d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c30:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
        ClearPageProperty(page);
c0102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c38:	83 c0 04             	add    $0x4,%eax
c0102c3b:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102c42:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c45:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c48:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c4b:	0f b3 10             	btr    %edx,(%eax)
}
c0102c4e:	90                   	nop
    }
    return page;
c0102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c52:	89 ec                	mov    %ebp,%esp
c0102c54:	5d                   	pop    %ebp
c0102c55:	c3                   	ret    

c0102c56 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c56:	55                   	push   %ebp
c0102c57:	89 e5                	mov    %esp,%ebp
c0102c59:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
c0102c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c63:	75 24                	jne    c0102c89 <default_free_pages+0x33>
c0102c65:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0102c6c:	c0 
c0102c6d:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102c74:	c0 
c0102c75:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0102c7c:	00 
c0102c7d:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102c84:	e8 5f e0 ff ff       	call   c0100ce8 <__panic>
c0102c89:	c7 45 e4 80 ce 11 c0 	movl   $0xc011ce80,-0x1c(%ebp)
    return listelm->next;
c0102c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c93:	8b 40 04             	mov    0x4(%eax),%eax
    struct Page *p1;

    list_entry_t *le1 = list_next(&free_list);
c0102c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c0102c99:	eb 32                	jmp    c0102ccd <default_free_pages+0x77>
        p1 = le2page(le1, page_link);
c0102c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c9e:	83 e8 0c             	sub    $0xc,%eax
c0102ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cad:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c0102cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , p1);
c0102cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cb6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cc1:	c7 04 24 91 67 10 c0 	movl   $0xc0106791,(%esp)
c0102cc8:	e8 89 d6 ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c0102ccd:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c0102cd4:	75 c5                	jne    c0102c9b <default_free_pages+0x45>
    }
    cprintf("\n\n");
c0102cd6:	c7 04 24 9f 67 10 c0 	movl   $0xc010679f,(%esp)
c0102cdd:	e8 74 d6 ff ff       	call   c0100356 <cprintf>

    struct Page *p = base;
c0102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (; p != base + n; p++) {
c0102ce8:	e9 9d 00 00 00       	jmp    c0102d8a <default_free_pages+0x134>
        assert(!PageReserved(p) && !PageProperty(p));
c0102ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cf0:	83 c0 04             	add    $0x4,%eax
c0102cf3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102cfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d00:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d03:	0f a3 10             	bt     %edx,(%eax)
c0102d06:	19 c0                	sbb    %eax,%eax
c0102d08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102d0b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102d0f:	0f 95 c0             	setne  %al
c0102d12:	0f b6 c0             	movzbl %al,%eax
c0102d15:	85 c0                	test   %eax,%eax
c0102d17:	75 2c                	jne    c0102d45 <default_free_pages+0xef>
c0102d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d1c:	83 c0 04             	add    $0x4,%eax
c0102d1f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102d26:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d29:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d2c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d2f:	0f a3 10             	bt     %edx,(%eax)
c0102d32:	19 c0                	sbb    %eax,%eax
c0102d34:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0102d37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0102d3b:	0f 95 c0             	setne  %al
c0102d3e:	0f b6 c0             	movzbl %al,%eax
c0102d41:	85 c0                	test   %eax,%eax
c0102d43:	74 24                	je     c0102d69 <default_free_pages+0x113>
c0102d45:	c7 44 24 0c a4 67 10 	movl   $0xc01067a4,0xc(%esp)
c0102d4c:	c0 
c0102d4d:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102d54:	c0 
c0102d55:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0102d5c:	00 
c0102d5d:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102d64:	e8 7f df ff ff       	call   c0100ce8 <__panic>
        p->flags = 0;
c0102d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d7a:	00 
c0102d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d7e:	89 04 24             	mov    %eax,(%esp)
c0102d81:	e8 99 fb ff ff       	call   c010291f <set_page_ref>
    for (; p != base + n; p++) {
c0102d86:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d8d:	89 d0                	mov    %edx,%eax
c0102d8f:	c1 e0 02             	shl    $0x2,%eax
c0102d92:	01 d0                	add    %edx,%eax
c0102d94:	c1 e0 02             	shl    $0x2,%eax
c0102d97:	89 c2                	mov    %eax,%edx
c0102d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9c:	01 d0                	add    %edx,%eax
c0102d9e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102da1:	0f 85 46 ff ff ff    	jne    c0102ced <default_free_pages+0x97>
    }
    base->property = n;
c0102da7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102daa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102dad:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102db0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db3:	83 c0 04             	add    $0x4,%eax
c0102db6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102dbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dc0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dc3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102dc6:	0f ab 10             	bts    %edx,(%eax)
}
c0102dc9:	90                   	nop
c0102dca:	c7 45 c4 80 ce 11 c0 	movl   $0xc011ce80,-0x3c(%ebp)
c0102dd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102dd4:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102dd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list) {
c0102dda:	e9 0e 01 00 00       	jmp    c0102eed <default_free_pages+0x297>
        p = le2page(le, page_link);
c0102ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102de2:	83 e8 0c             	sub    $0xc,%eax
c0102de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102deb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102dee:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102df1:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102df4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (base + base->property == p) {
c0102df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfa:	8b 50 08             	mov    0x8(%eax),%edx
c0102dfd:	89 d0                	mov    %edx,%eax
c0102dff:	c1 e0 02             	shl    $0x2,%eax
c0102e02:	01 d0                	add    %edx,%eax
c0102e04:	c1 e0 02             	shl    $0x2,%eax
c0102e07:	89 c2                	mov    %eax,%edx
c0102e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0c:	01 d0                	add    %edx,%eax
c0102e0e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102e11:	75 5d                	jne    c0102e70 <default_free_pages+0x21a>
            base->property += p->property;
c0102e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e16:	8b 50 08             	mov    0x8(%eax),%edx
c0102e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e1c:	8b 40 08             	mov    0x8(%eax),%eax
c0102e1f:	01 c2                	add    %eax,%edx
c0102e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e24:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e2a:	83 c0 04             	add    $0x4,%eax
c0102e2d:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0102e34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e3a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e3d:	0f b3 10             	btr    %edx,(%eax)
}
c0102e40:	90                   	nop
            list_del(&(p->page_link));
c0102e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e44:	83 c0 0c             	add    $0xc,%eax
c0102e47:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e4a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e4d:	8b 40 04             	mov    0x4(%eax),%eax
c0102e50:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e53:	8b 12                	mov    (%edx),%edx
c0102e55:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102e58:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
c0102e5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e61:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e64:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e67:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e6a:	89 10                	mov    %edx,(%eax)
}
c0102e6c:	90                   	nop
}
c0102e6d:	90                   	nop
c0102e6e:	eb 7d                	jmp    c0102eed <default_free_pages+0x297>
        } else if (p + p->property == base) {
c0102e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e73:	8b 50 08             	mov    0x8(%eax),%edx
c0102e76:	89 d0                	mov    %edx,%eax
c0102e78:	c1 e0 02             	shl    $0x2,%eax
c0102e7b:	01 d0                	add    %edx,%eax
c0102e7d:	c1 e0 02             	shl    $0x2,%eax
c0102e80:	89 c2                	mov    %eax,%edx
c0102e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e85:	01 d0                	add    %edx,%eax
c0102e87:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e8a:	75 61                	jne    c0102eed <default_free_pages+0x297>
            p->property += base->property;
c0102e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e8f:	8b 50 08             	mov    0x8(%eax),%edx
c0102e92:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e95:	8b 40 08             	mov    0x8(%eax),%eax
c0102e98:	01 c2                	add    %eax,%edx
c0102e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e9d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea3:	83 c0 04             	add    $0x4,%eax
c0102ea6:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0102ead:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102eb0:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102eb3:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102eb6:	0f b3 10             	btr    %edx,(%eax)
}
c0102eb9:	90                   	nop
            base = p;//?
c0102eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ebd:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec3:	83 c0 0c             	add    $0xc,%eax
c0102ec6:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102ec9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ecc:	8b 40 04             	mov    0x4(%eax),%eax
c0102ecf:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102ed2:	8b 12                	mov    (%edx),%edx
c0102ed4:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0102ed7:	89 45 98             	mov    %eax,-0x68(%ebp)
    prev->next = next;
c0102eda:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102edd:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102ee0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ee3:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ee6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102ee9:	89 10                	mov    %edx,(%eax)
}
c0102eeb:	90                   	nop
}
c0102eec:	90                   	nop
    while (le != &free_list) {
c0102eed:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0102ef4:	0f 85 e5 fe ff ff    	jne    c0102ddf <default_free_pages+0x189>
        }
    }



    nr_free += n;
c0102efa:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102f00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f03:	01 d0                	add    %edx,%eax
c0102f05:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
c0102f0a:	c7 45 8c 80 ce 11 c0 	movl   $0xc011ce80,-0x74(%ebp)
    return listelm->next;
c0102f11:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f14:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102f17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list) {
c0102f1a:	eb 34                	jmp    c0102f50 <default_free_pages+0x2fa>
        p = le2page(le, page_link);
c0102f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f1f:	83 e8 0c             	sub    $0xc,%eax
c0102f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f28:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102f2b:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f2e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (base + base->property < p) {
c0102f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f37:	8b 50 08             	mov    0x8(%eax),%edx
c0102f3a:	89 d0                	mov    %edx,%eax
c0102f3c:	c1 e0 02             	shl    $0x2,%eax
c0102f3f:	01 d0                	add    %edx,%eax
c0102f41:	c1 e0 02             	shl    $0x2,%eax
c0102f44:	89 c2                	mov    %eax,%edx
c0102f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f49:	01 d0                	add    %edx,%eax
c0102f4b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102f4e:	77 0b                	ja     c0102f5b <default_free_pages+0x305>
    while (le != &free_list) {
c0102f50:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0102f57:	75 c3                	jne    c0102f1c <default_free_pages+0x2c6>
c0102f59:	eb 01                	jmp    c0102f5c <default_free_pages+0x306>
            break;
c0102f5b:	90                   	nop
        }

    }
//    list_add_before(le, &(base->page_link));
    list_add(le,&(base->page_link));
c0102f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f5f:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f65:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102f68:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102f6b:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f6e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102f74:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102f77:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102f7d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102f83:	8b 40 04             	mov    0x4(%eax),%eax
c0102f86:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0102f8c:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
c0102f92:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102f98:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0102f9e:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
    prev->next = next->prev = elm;
c0102fa4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0102faa:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0102fb0:	89 10                	mov    %edx,(%eax)
c0102fb2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0102fb8:	8b 10                	mov    (%eax),%edx
c0102fba:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0102fc0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102fc3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102fc9:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c0102fcf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102fd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102fd8:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0102fde:	89 10                	mov    %edx,(%eax)
}
c0102fe0:	90                   	nop
}
c0102fe1:	90                   	nop
}
c0102fe2:	90                   	nop

}
c0102fe3:	90                   	nop
c0102fe4:	89 ec                	mov    %ebp,%esp
c0102fe6:	5d                   	pop    %ebp
c0102fe7:	c3                   	ret    

c0102fe8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102fe8:	55                   	push   %ebp
c0102fe9:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102feb:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
}
c0102ff0:	5d                   	pop    %ebp
c0102ff1:	c3                   	ret    

c0102ff2 <basic_check>:

static void
basic_check(void) {
c0102ff2:	55                   	push   %ebp
c0102ff3:	89 e5                	mov    %esp,%ebp
c0102ff5:	83 ec 58             	sub    $0x58,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ff8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103002:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103005:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103008:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010300b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103012:	e8 91 0f 00 00       	call   c0103fa8 <alloc_pages>
c0103017:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010301a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010301e:	75 24                	jne    c0103044 <basic_check+0x52>
c0103020:	c7 44 24 0c c9 67 10 	movl   $0xc01067c9,0xc(%esp)
c0103027:	c0 
c0103028:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010302f:	c0 
c0103030:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103037:	00 
c0103038:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010303f:	e8 a4 dc ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010304b:	e8 58 0f 00 00       	call   c0103fa8 <alloc_pages>
c0103050:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103057:	75 24                	jne    c010307d <basic_check+0x8b>
c0103059:	c7 44 24 0c e5 67 10 	movl   $0xc01067e5,0xc(%esp)
c0103060:	c0 
c0103061:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103068:	c0 
c0103069:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0103070:	00 
c0103071:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103078:	e8 6b dc ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010307d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103084:	e8 1f 0f 00 00       	call   c0103fa8 <alloc_pages>
c0103089:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010308c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103090:	75 24                	jne    c01030b6 <basic_check+0xc4>
c0103092:	c7 44 24 0c 01 68 10 	movl   $0xc0106801,0xc(%esp)
c0103099:	c0 
c010309a:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01030a1:	c0 
c01030a2:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01030a9:	00 
c01030aa:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01030b1:	e8 32 dc ff ff       	call   c0100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01030bc:	74 10                	je     c01030ce <basic_check+0xdc>
c01030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030c4:	74 08                	je     c01030ce <basic_check+0xdc>
c01030c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030cc:	75 24                	jne    c01030f2 <basic_check+0x100>
c01030ce:	c7 44 24 0c 20 68 10 	movl   $0xc0106820,0xc(%esp)
c01030d5:	c0 
c01030d6:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01030dd:	c0 
c01030de:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01030e5:	00 
c01030e6:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01030ed:	e8 f6 db ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030f5:	89 04 24             	mov    %eax,(%esp)
c01030f8:	e8 18 f8 ff ff       	call   c0102915 <page_ref>
c01030fd:	85 c0                	test   %eax,%eax
c01030ff:	75 1e                	jne    c010311f <basic_check+0x12d>
c0103101:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103104:	89 04 24             	mov    %eax,(%esp)
c0103107:	e8 09 f8 ff ff       	call   c0102915 <page_ref>
c010310c:	85 c0                	test   %eax,%eax
c010310e:	75 0f                	jne    c010311f <basic_check+0x12d>
c0103110:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103113:	89 04 24             	mov    %eax,(%esp)
c0103116:	e8 fa f7 ff ff       	call   c0102915 <page_ref>
c010311b:	85 c0                	test   %eax,%eax
c010311d:	74 24                	je     c0103143 <basic_check+0x151>
c010311f:	c7 44 24 0c 44 68 10 	movl   $0xc0106844,0xc(%esp)
c0103126:	c0 
c0103127:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010312e:	c0 
c010312f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103136:	00 
c0103137:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010313e:	e8 a5 db ff ff       	call   c0100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103143:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103146:	89 04 24             	mov    %eax,(%esp)
c0103149:	e8 af f7 ff ff       	call   c01028fd <page2pa>
c010314e:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103154:	c1 e2 0c             	shl    $0xc,%edx
c0103157:	39 d0                	cmp    %edx,%eax
c0103159:	72 24                	jb     c010317f <basic_check+0x18d>
c010315b:	c7 44 24 0c 80 68 10 	movl   $0xc0106880,0xc(%esp)
c0103162:	c0 
c0103163:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010316a:	c0 
c010316b:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103172:	00 
c0103173:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010317a:	e8 69 db ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010317f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103182:	89 04 24             	mov    %eax,(%esp)
c0103185:	e8 73 f7 ff ff       	call   c01028fd <page2pa>
c010318a:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103190:	c1 e2 0c             	shl    $0xc,%edx
c0103193:	39 d0                	cmp    %edx,%eax
c0103195:	72 24                	jb     c01031bb <basic_check+0x1c9>
c0103197:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c010319e:	c0 
c010319f:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01031a6:	c0 
c01031a7:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c01031ae:	00 
c01031af:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01031b6:	e8 2d db ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031be:	89 04 24             	mov    %eax,(%esp)
c01031c1:	e8 37 f7 ff ff       	call   c01028fd <page2pa>
c01031c6:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01031cc:	c1 e2 0c             	shl    $0xc,%edx
c01031cf:	39 d0                	cmp    %edx,%eax
c01031d1:	72 24                	jb     c01031f7 <basic_check+0x205>
c01031d3:	c7 44 24 0c ba 68 10 	movl   $0xc01068ba,0xc(%esp)
c01031da:	c0 
c01031db:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01031e2:	c0 
c01031e3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01031ea:	00 
c01031eb:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01031f2:	e8 f1 da ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c01031f7:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01031fc:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c0103202:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103205:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103208:	c7 45 d4 80 ce 11 c0 	movl   $0xc011ce80,-0x2c(%ebp)
    elm->prev = elm->next = elm;
c010320f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103212:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103215:	89 50 04             	mov    %edx,0x4(%eax)
c0103218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010321b:	8b 50 04             	mov    0x4(%eax),%edx
c010321e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103221:	89 10                	mov    %edx,(%eax)
}
c0103223:	90                   	nop
c0103224:	c7 45 d8 80 ce 11 c0 	movl   $0xc011ce80,-0x28(%ebp)
    return list->next == list;
c010322b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010322e:	8b 40 04             	mov    0x4(%eax),%eax
c0103231:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103234:	0f 94 c0             	sete   %al
c0103237:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010323a:	85 c0                	test   %eax,%eax
c010323c:	75 24                	jne    c0103262 <basic_check+0x270>
c010323e:	c7 44 24 0c d7 68 10 	movl   $0xc01068d7,0xc(%esp)
c0103245:	c0 
c0103246:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010324d:	c0 
c010324e:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103255:	00 
c0103256:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010325d:	e8 86 da ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103262:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010326a:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c0103271:	00 00 00 

    assert(alloc_page() == NULL);
c0103274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010327b:	e8 28 0d 00 00       	call   c0103fa8 <alloc_pages>
c0103280:	85 c0                	test   %eax,%eax
c0103282:	74 24                	je     c01032a8 <basic_check+0x2b6>
c0103284:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c010328b:	c0 
c010328c:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103293:	c0 
c0103294:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010329b:	00 
c010329c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01032a3:	e8 40 da ff ff       	call   c0100ce8 <__panic>

    free_page(p0);
c01032a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032af:	00 
c01032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032b3:	89 04 24             	mov    %eax,(%esp)
c01032b6:	e8 27 0d 00 00       	call   c0103fe2 <free_pages>
    free_page(p1);
c01032bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032c2:	00 
c01032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c6:	89 04 24             	mov    %eax,(%esp)
c01032c9:	e8 14 0d 00 00       	call   c0103fe2 <free_pages>
    free_page(p2);
c01032ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032d5:	00 
c01032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d9:	89 04 24             	mov    %eax,(%esp)
c01032dc:	e8 01 0d 00 00       	call   c0103fe2 <free_pages>
    assert(nr_free == 3);
c01032e1:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01032e6:	83 f8 03             	cmp    $0x3,%eax
c01032e9:	74 24                	je     c010330f <basic_check+0x31d>
c01032eb:	c7 44 24 0c 03 69 10 	movl   $0xc0106903,0xc(%esp)
c01032f2:	c0 
c01032f3:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01032fa:	c0 
c01032fb:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103302:	00 
c0103303:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010330a:	e8 d9 d9 ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010330f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103316:	e8 8d 0c 00 00       	call   c0103fa8 <alloc_pages>
c010331b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010331e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103322:	75 24                	jne    c0103348 <basic_check+0x356>
c0103324:	c7 44 24 0c c9 67 10 	movl   $0xc01067c9,0xc(%esp)
c010332b:	c0 
c010332c:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103333:	c0 
c0103334:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010333b:	00 
c010333c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103343:	e8 a0 d9 ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103348:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010334f:	e8 54 0c 00 00       	call   c0103fa8 <alloc_pages>
c0103354:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103357:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010335b:	75 24                	jne    c0103381 <basic_check+0x38f>
c010335d:	c7 44 24 0c e5 67 10 	movl   $0xc01067e5,0xc(%esp)
c0103364:	c0 
c0103365:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010336c:	c0 
c010336d:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103374:	00 
c0103375:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010337c:	e8 67 d9 ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103388:	e8 1b 0c 00 00       	call   c0103fa8 <alloc_pages>
c010338d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103394:	75 24                	jne    c01033ba <basic_check+0x3c8>
c0103396:	c7 44 24 0c 01 68 10 	movl   $0xc0106801,0xc(%esp)
c010339d:	c0 
c010339e:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01033a5:	c0 
c01033a6:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01033ad:	00 
c01033ae:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01033b5:	e8 2e d9 ff ff       	call   c0100ce8 <__panic>

    assert(alloc_page() == NULL);
c01033ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033c1:	e8 e2 0b 00 00       	call   c0103fa8 <alloc_pages>
c01033c6:	85 c0                	test   %eax,%eax
c01033c8:	74 24                	je     c01033ee <basic_check+0x3fc>
c01033ca:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c01033d1:	c0 
c01033d2:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01033d9:	c0 
c01033da:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01033e1:	00 
c01033e2:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01033e9:	e8 fa d8 ff ff       	call   c0100ce8 <__panic>
c01033ee:	c7 45 d0 80 ce 11 c0 	movl   $0xc011ce80,-0x30(%ebp)
    return listelm->next;
c01033f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033f8:	8b 40 04             	mov    0x4(%eax),%eax

    struct Page *pp1;

    list_entry_t *le1 = list_next(&free_list);
c01033fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c01033fe:	eb 32                	jmp    c0103432 <basic_check+0x440>
        pp1 = le2page(le1, page_link);
c0103400:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103403:	83 e8 0c             	sub    $0xc,%eax
c0103406:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103409:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010340f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103412:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c0103415:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c0103418:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010341b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103422:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103426:	c7 04 24 91 67 10 c0 	movl   $0xc0106791,(%esp)
c010342d:	e8 24 cf ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c0103432:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c0103439:	75 c5                	jne    c0103400 <basic_check+0x40e>
    }
    cprintf("\n\n");
c010343b:	c7 04 24 9f 67 10 c0 	movl   $0xc010679f,(%esp)
c0103442:	e8 0f cf ff ff       	call   c0100356 <cprintf>

    free_page(p0);
c0103447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010344e:	00 
c010344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103452:	89 04 24             	mov    %eax,(%esp)
c0103455:	e8 88 0b 00 00       	call   c0103fe2 <free_pages>
c010345a:	c7 45 c8 80 ce 11 c0 	movl   $0xc011ce80,-0x38(%ebp)
c0103461:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103464:	8b 40 04             	mov    0x4(%eax),%eax

    le1 = list_next(&free_list);
c0103467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c010346a:	eb 32                	jmp    c010349e <basic_check+0x4ac>
        pp1 = le2page(le1, page_link);
c010346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010346f:	83 e8 0c             	sub    $0xc,%eax
c0103472:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103475:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103478:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010347b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010347e:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c0103481:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c0103484:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103487:	89 44 24 08          	mov    %eax,0x8(%esp)
c010348b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010348e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103492:	c7 04 24 91 67 10 c0 	movl   $0xc0106791,(%esp)
c0103499:	e8 b8 ce ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c010349e:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c01034a5:	75 c5                	jne    c010346c <basic_check+0x47a>
    }
    cprintf("\n\n");
c01034a7:	c7 04 24 9f 67 10 c0 	movl   $0xc010679f,(%esp)
c01034ae:	e8 a3 ce ff ff       	call   c0100356 <cprintf>
c01034b3:	c7 45 c0 80 ce 11 c0 	movl   $0xc011ce80,-0x40(%ebp)
    return list->next == list;
c01034ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01034bd:	8b 40 04             	mov    0x4(%eax),%eax
c01034c0:	39 45 c0             	cmp    %eax,-0x40(%ebp)
c01034c3:	0f 94 c0             	sete   %al
c01034c6:	0f b6 c0             	movzbl %al,%eax


    assert(!list_empty(&free_list));
c01034c9:	85 c0                	test   %eax,%eax
c01034cb:	74 24                	je     c01034f1 <basic_check+0x4ff>
c01034cd:	c7 44 24 0c 10 69 10 	movl   $0xc0106910,0xc(%esp)
c01034d4:	c0 
c01034d5:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01034dc:	c0 
c01034dd:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01034e4:	00 
c01034e5:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01034ec:	e8 f7 d7 ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034f8:	e8 ab 0a 00 00       	call   c0103fa8 <alloc_pages>
c01034fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103500:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103503:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103506:	74 24                	je     c010352c <basic_check+0x53a>
c0103508:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c010350f:	c0 
c0103510:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103517:	c0 
c0103518:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010351f:	00 
c0103520:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103527:	e8 bc d7 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c010352c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103533:	e8 70 0a 00 00       	call   c0103fa8 <alloc_pages>
c0103538:	85 c0                	test   %eax,%eax
c010353a:	74 24                	je     c0103560 <basic_check+0x56e>
c010353c:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c0103543:	c0 
c0103544:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010354b:	c0 
c010354c:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103553:	00 
c0103554:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010355b:	e8 88 d7 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c0103560:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103565:	85 c0                	test   %eax,%eax
c0103567:	74 24                	je     c010358d <basic_check+0x59b>
c0103569:	c7 44 24 0c 41 69 10 	movl   $0xc0106941,0xc(%esp)
c0103570:	c0 
c0103571:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103578:	c0 
c0103579:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103580:	00 
c0103581:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103588:	e8 5b d7 ff ff       	call   c0100ce8 <__panic>
    free_list = free_list_store;
c010358d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103590:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103593:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103598:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    nr_free = nr_free_store;
c010359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035a1:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_page(p);
c01035a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035ad:	00 
c01035ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b1:	89 04 24             	mov    %eax,(%esp)
c01035b4:	e8 29 0a 00 00       	call   c0103fe2 <free_pages>
    free_page(p1);
c01035b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035c0:	00 
c01035c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c4:	89 04 24             	mov    %eax,(%esp)
c01035c7:	e8 16 0a 00 00       	call   c0103fe2 <free_pages>
    free_page(p2);
c01035cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035d3:	00 
c01035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035d7:	89 04 24             	mov    %eax,(%esp)
c01035da:	e8 03 0a 00 00       	call   c0103fe2 <free_pages>
}
c01035df:	90                   	nop
c01035e0:	89 ec                	mov    %ebp,%esp
c01035e2:	5d                   	pop    %ebp
c01035e3:	c3                   	ret    

c01035e4 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01035e4:	55                   	push   %ebp
c01035e5:	89 e5                	mov    %esp,%ebp
c01035e7:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01035ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035fb:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103602:	eb 6a                	jmp    c010366e <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0103604:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103607:	83 e8 0c             	sub    $0xc,%eax
c010360a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c010360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103610:	83 c0 04             	add    $0x4,%eax
c0103613:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010361a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010361d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103620:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103623:	0f a3 10             	bt     %edx,(%eax)
c0103626:	19 c0                	sbb    %eax,%eax
c0103628:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010362b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010362f:	0f 95 c0             	setne  %al
c0103632:	0f b6 c0             	movzbl %al,%eax
c0103635:	85 c0                	test   %eax,%eax
c0103637:	75 24                	jne    c010365d <default_check+0x79>
c0103639:	c7 44 24 0c 4e 69 10 	movl   $0xc010694e,0xc(%esp)
c0103640:	c0 
c0103641:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103648:	c0 
c0103649:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103650:	00 
c0103651:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103658:	e8 8b d6 ff ff       	call   c0100ce8 <__panic>
        count++, total += p->property;
c010365d:	ff 45 f4             	incl   -0xc(%ebp)
c0103660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103663:	8b 50 08             	mov    0x8(%eax),%edx
c0103666:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103669:	01 d0                	add    %edx,%eax
c010366b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103671:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103674:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103677:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010367a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010367d:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103684:	0f 85 7a ff ff ff    	jne    c0103604 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010368a:	e8 88 09 00 00       	call   c0104017 <nr_free_pages>
c010368f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103692:	39 d0                	cmp    %edx,%eax
c0103694:	74 24                	je     c01036ba <default_check+0xd6>
c0103696:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c010369d:	c0 
c010369e:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01036a5:	c0 
c01036a6:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c01036ad:	00 
c01036ae:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01036b5:	e8 2e d6 ff ff       	call   c0100ce8 <__panic>

    basic_check();
c01036ba:	e8 33 f9 ff ff       	call   c0102ff2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01036bf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01036c6:	e8 dd 08 00 00       	call   c0103fa8 <alloc_pages>
c01036cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01036ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01036d2:	75 24                	jne    c01036f8 <default_check+0x114>
c01036d4:	c7 44 24 0c 77 69 10 	movl   $0xc0106977,0xc(%esp)
c01036db:	c0 
c01036dc:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01036e3:	c0 
c01036e4:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01036eb:	00 
c01036ec:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01036f3:	e8 f0 d5 ff ff       	call   c0100ce8 <__panic>
    assert(!PageProperty(p0));
c01036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036fb:	83 c0 04             	add    $0x4,%eax
c01036fe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103705:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103708:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010370b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010370e:	0f a3 10             	bt     %edx,(%eax)
c0103711:	19 c0                	sbb    %eax,%eax
c0103713:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103716:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010371a:	0f 95 c0             	setne  %al
c010371d:	0f b6 c0             	movzbl %al,%eax
c0103720:	85 c0                	test   %eax,%eax
c0103722:	74 24                	je     c0103748 <default_check+0x164>
c0103724:	c7 44 24 0c 82 69 10 	movl   $0xc0106982,0xc(%esp)
c010372b:	c0 
c010372c:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103733:	c0 
c0103734:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c010373b:	00 
c010373c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103743:	e8 a0 d5 ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c0103748:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010374d:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c0103753:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103756:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103759:	c7 45 b0 80 ce 11 c0 	movl   $0xc011ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103760:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103763:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103766:	89 50 04             	mov    %edx,0x4(%eax)
c0103769:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010376c:	8b 50 04             	mov    0x4(%eax),%edx
c010376f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103772:	89 10                	mov    %edx,(%eax)
}
c0103774:	90                   	nop
c0103775:	c7 45 b4 80 ce 11 c0 	movl   $0xc011ce80,-0x4c(%ebp)
    return list->next == list;
c010377c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010377f:	8b 40 04             	mov    0x4(%eax),%eax
c0103782:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103785:	0f 94 c0             	sete   %al
c0103788:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010378b:	85 c0                	test   %eax,%eax
c010378d:	75 24                	jne    c01037b3 <default_check+0x1cf>
c010378f:	c7 44 24 0c d7 68 10 	movl   $0xc01068d7,0xc(%esp)
c0103796:	c0 
c0103797:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010379e:	c0 
c010379f:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01037a6:	00 
c01037a7:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01037ae:	e8 35 d5 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c01037b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037ba:	e8 e9 07 00 00       	call   c0103fa8 <alloc_pages>
c01037bf:	85 c0                	test   %eax,%eax
c01037c1:	74 24                	je     c01037e7 <default_check+0x203>
c01037c3:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c01037ca:	c0 
c01037cb:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01037d2:	c0 
c01037d3:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01037da:	00 
c01037db:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01037e2:	e8 01 d5 ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c01037e7:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01037ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01037ef:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c01037f6:	00 00 00 

    free_pages(p0 + 2, 3);
c01037f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037fc:	83 c0 28             	add    $0x28,%eax
c01037ff:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103806:	00 
c0103807:	89 04 24             	mov    %eax,(%esp)
c010380a:	e8 d3 07 00 00       	call   c0103fe2 <free_pages>
    assert(alloc_pages(4) == NULL);
c010380f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103816:	e8 8d 07 00 00       	call   c0103fa8 <alloc_pages>
c010381b:	85 c0                	test   %eax,%eax
c010381d:	74 24                	je     c0103843 <default_check+0x25f>
c010381f:	c7 44 24 0c 94 69 10 	movl   $0xc0106994,0xc(%esp)
c0103826:	c0 
c0103827:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010382e:	c0 
c010382f:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103836:	00 
c0103837:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010383e:	e8 a5 d4 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103843:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103846:	83 c0 28             	add    $0x28,%eax
c0103849:	83 c0 04             	add    $0x4,%eax
c010384c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103853:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103856:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103859:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010385c:	0f a3 10             	bt     %edx,(%eax)
c010385f:	19 c0                	sbb    %eax,%eax
c0103861:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103864:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103868:	0f 95 c0             	setne  %al
c010386b:	0f b6 c0             	movzbl %al,%eax
c010386e:	85 c0                	test   %eax,%eax
c0103870:	74 0e                	je     c0103880 <default_check+0x29c>
c0103872:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103875:	83 c0 28             	add    $0x28,%eax
c0103878:	8b 40 08             	mov    0x8(%eax),%eax
c010387b:	83 f8 03             	cmp    $0x3,%eax
c010387e:	74 24                	je     c01038a4 <default_check+0x2c0>
c0103880:	c7 44 24 0c ac 69 10 	movl   $0xc01069ac,0xc(%esp)
c0103887:	c0 
c0103888:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010388f:	c0 
c0103890:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103897:	00 
c0103898:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010389f:	e8 44 d4 ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01038a4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01038ab:	e8 f8 06 00 00       	call   c0103fa8 <alloc_pages>
c01038b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01038b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01038b7:	75 24                	jne    c01038dd <default_check+0x2f9>
c01038b9:	c7 44 24 0c d8 69 10 	movl   $0xc01069d8,0xc(%esp)
c01038c0:	c0 
c01038c1:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01038c8:	c0 
c01038c9:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01038d0:	00 
c01038d1:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01038d8:	e8 0b d4 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c01038dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038e4:	e8 bf 06 00 00       	call   c0103fa8 <alloc_pages>
c01038e9:	85 c0                	test   %eax,%eax
c01038eb:	74 24                	je     c0103911 <default_check+0x32d>
c01038ed:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c01038f4:	c0 
c01038f5:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01038fc:	c0 
c01038fd:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103904:	00 
c0103905:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010390c:	e8 d7 d3 ff ff       	call   c0100ce8 <__panic>
    assert(p0 + 2 == p1);
c0103911:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103914:	83 c0 28             	add    $0x28,%eax
c0103917:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010391a:	74 24                	je     c0103940 <default_check+0x35c>
c010391c:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c0103923:	c0 
c0103924:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010392b:	c0 
c010392c:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c0103933:	00 
c0103934:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010393b:	e8 a8 d3 ff ff       	call   c0100ce8 <__panic>

    p2 = p0 + 1;
c0103940:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103943:	83 c0 14             	add    $0x14,%eax
c0103946:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0103949:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103950:	00 
c0103951:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103954:	89 04 24             	mov    %eax,(%esp)
c0103957:	e8 86 06 00 00       	call   c0103fe2 <free_pages>
    free_pages(p1, 3);
c010395c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103963:	00 
c0103964:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103967:	89 04 24             	mov    %eax,(%esp)
c010396a:	e8 73 06 00 00       	call   c0103fe2 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103972:	83 c0 04             	add    $0x4,%eax
c0103975:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010397c:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010397f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103982:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103985:	0f a3 10             	bt     %edx,(%eax)
c0103988:	19 c0                	sbb    %eax,%eax
c010398a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010398d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103991:	0f 95 c0             	setne  %al
c0103994:	0f b6 c0             	movzbl %al,%eax
c0103997:	85 c0                	test   %eax,%eax
c0103999:	74 0b                	je     c01039a6 <default_check+0x3c2>
c010399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010399e:	8b 40 08             	mov    0x8(%eax),%eax
c01039a1:	83 f8 01             	cmp    $0x1,%eax
c01039a4:	74 24                	je     c01039ca <default_check+0x3e6>
c01039a6:	c7 44 24 0c 04 6a 10 	movl   $0xc0106a04,0xc(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01039b5:	c0 
c01039b6:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c01039bd:	00 
c01039be:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01039c5:	e8 1e d3 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01039ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039cd:	83 c0 04             	add    $0x4,%eax
c01039d0:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01039d7:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01039da:	8b 45 90             	mov    -0x70(%ebp),%eax
c01039dd:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01039e0:	0f a3 10             	bt     %edx,(%eax)
c01039e3:	19 c0                	sbb    %eax,%eax
c01039e5:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01039e8:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01039ec:	0f 95 c0             	setne  %al
c01039ef:	0f b6 c0             	movzbl %al,%eax
c01039f2:	85 c0                	test   %eax,%eax
c01039f4:	74 0b                	je     c0103a01 <default_check+0x41d>
c01039f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039f9:	8b 40 08             	mov    0x8(%eax),%eax
c01039fc:	83 f8 03             	cmp    $0x3,%eax
c01039ff:	74 24                	je     c0103a25 <default_check+0x441>
c0103a01:	c7 44 24 0c 2c 6a 10 	movl   $0xc0106a2c,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103a20:	e8 c3 d2 ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a2c:	e8 77 05 00 00       	call   c0103fa8 <alloc_pages>
c0103a31:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a34:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a37:	83 e8 14             	sub    $0x14,%eax
c0103a3a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a3d:	74 24                	je     c0103a63 <default_check+0x47f>
c0103a3f:	c7 44 24 0c 52 6a 10 	movl   $0xc0106a52,0xc(%esp)
c0103a46:	c0 
c0103a47:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103a56:	00 
c0103a57:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103a5e:	e8 85 d2 ff ff       	call   c0100ce8 <__panic>
    free_page(p0);
c0103a63:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a6a:	00 
c0103a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a6e:	89 04 24             	mov    %eax,(%esp)
c0103a71:	e8 6c 05 00 00       	call   c0103fe2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a76:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a7d:	e8 26 05 00 00       	call   c0103fa8 <alloc_pages>
c0103a82:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a88:	83 c0 14             	add    $0x14,%eax
c0103a8b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a8e:	74 24                	je     c0103ab4 <default_check+0x4d0>
c0103a90:	c7 44 24 0c 70 6a 10 	movl   $0xc0106a70,0xc(%esp)
c0103a97:	c0 
c0103a98:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103a9f:	c0 
c0103aa0:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c0103aa7:	00 
c0103aa8:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103aaf:	e8 34 d2 ff ff       	call   c0100ce8 <__panic>

    free_pages(p0, 2);
c0103ab4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103abb:	00 
c0103abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103abf:	89 04 24             	mov    %eax,(%esp)
c0103ac2:	e8 1b 05 00 00       	call   c0103fe2 <free_pages>
    free_page(p2);
c0103ac7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ace:	00 
c0103acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ad2:	89 04 24             	mov    %eax,(%esp)
c0103ad5:	e8 08 05 00 00       	call   c0103fe2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103ada:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103ae1:	e8 c2 04 00 00       	call   c0103fa8 <alloc_pages>
c0103ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103ae9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103aed:	75 24                	jne    c0103b13 <default_check+0x52f>
c0103aef:	c7 44 24 0c 90 6a 10 	movl   $0xc0106a90,0xc(%esp)
c0103af6:	c0 
c0103af7:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103afe:	c0 
c0103aff:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0103b06:	00 
c0103b07:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103b0e:	e8 d5 d1 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103b13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b1a:	e8 89 04 00 00       	call   c0103fa8 <alloc_pages>
c0103b1f:	85 c0                	test   %eax,%eax
c0103b21:	74 24                	je     c0103b47 <default_check+0x563>
c0103b23:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c0103b2a:	c0 
c0103b2b:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103b32:	c0 
c0103b33:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c0103b3a:	00 
c0103b3b:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103b42:	e8 a1 d1 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c0103b47:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103b4c:	85 c0                	test   %eax,%eax
c0103b4e:	74 24                	je     c0103b74 <default_check+0x590>
c0103b50:	c7 44 24 0c 41 69 10 	movl   $0xc0106941,0xc(%esp)
c0103b57:	c0 
c0103b58:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103b5f:	c0 
c0103b60:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0103b67:	00 
c0103b68:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103b6f:	e8 74 d1 ff ff       	call   c0100ce8 <__panic>
    nr_free = nr_free_store;
c0103b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b77:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_list = free_list_store;
c0103b7c:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b7f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b82:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103b87:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    free_pages(p0, 5);
c0103b8d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b94:	00 
c0103b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b98:	89 04 24             	mov    %eax,(%esp)
c0103b9b:	e8 42 04 00 00       	call   c0103fe2 <free_pages>

    le = &free_list;
c0103ba0:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ba7:	eb 5a                	jmp    c0103c03 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bac:	8b 40 04             	mov    0x4(%eax),%eax
c0103baf:	8b 00                	mov    (%eax),%eax
c0103bb1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103bb4:	75 0d                	jne    c0103bc3 <default_check+0x5df>
c0103bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bb9:	8b 00                	mov    (%eax),%eax
c0103bbb:	8b 40 04             	mov    0x4(%eax),%eax
c0103bbe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103bc1:	74 24                	je     c0103be7 <default_check+0x603>
c0103bc3:	c7 44 24 0c b0 6a 10 	movl   $0xc0106ab0,0xc(%esp)
c0103bca:	c0 
c0103bcb:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103bd2:	c0 
c0103bd3:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c0103bda:	00 
c0103bdb:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103be2:	e8 01 d1 ff ff       	call   c0100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
c0103be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bea:	83 e8 0c             	sub    $0xc,%eax
c0103bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103bf0:	ff 4d f4             	decl   -0xc(%ebp)
c0103bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bf9:	8b 48 08             	mov    0x8(%eax),%ecx
c0103bfc:	89 d0                	mov    %edx,%eax
c0103bfe:	29 c8                	sub    %ecx,%eax
c0103c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c06:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103c09:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103c0c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c12:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103c19:	75 8e                	jne    c0103ba9 <default_check+0x5c5>
    }
    assert(count == 0);
c0103c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c1f:	74 24                	je     c0103c45 <default_check+0x661>
c0103c21:	c7 44 24 0c dd 6a 10 	movl   $0xc0106add,0xc(%esp)
c0103c28:	c0 
c0103c29:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103c30:	c0 
c0103c31:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
c0103c38:	00 
c0103c39:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103c40:	e8 a3 d0 ff ff       	call   c0100ce8 <__panic>
    assert(total == 0);
c0103c45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c49:	74 24                	je     c0103c6f <default_check+0x68b>
c0103c4b:	c7 44 24 0c e8 6a 10 	movl   $0xc0106ae8,0xc(%esp)
c0103c52:	c0 
c0103c53:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103c5a:	c0 
c0103c5b:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
c0103c62:	00 
c0103c63:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103c6a:	e8 79 d0 ff ff       	call   c0100ce8 <__panic>
}
c0103c6f:	90                   	nop
c0103c70:	89 ec                	mov    %ebp,%esp
c0103c72:	5d                   	pop    %ebp
c0103c73:	c3                   	ret    

c0103c74 <page2ppn>:
page2ppn(struct Page *page) {
c0103c74:	55                   	push   %ebp
c0103c75:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c77:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0103c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c80:	29 d0                	sub    %edx,%eax
c0103c82:	c1 f8 02             	sar    $0x2,%eax
c0103c85:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c8b:	5d                   	pop    %ebp
c0103c8c:	c3                   	ret    

c0103c8d <page2pa>:
page2pa(struct Page *page) {
c0103c8d:	55                   	push   %ebp
c0103c8e:	89 e5                	mov    %esp,%ebp
c0103c90:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c96:	89 04 24             	mov    %eax,(%esp)
c0103c99:	e8 d6 ff ff ff       	call   c0103c74 <page2ppn>
c0103c9e:	c1 e0 0c             	shl    $0xc,%eax
}
c0103ca1:	89 ec                	mov    %ebp,%esp
c0103ca3:	5d                   	pop    %ebp
c0103ca4:	c3                   	ret    

c0103ca5 <pa2page>:
pa2page(uintptr_t pa) {
c0103ca5:	55                   	push   %ebp
c0103ca6:	89 e5                	mov    %esp,%ebp
c0103ca8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cae:	c1 e8 0c             	shr    $0xc,%eax
c0103cb1:	89 c2                	mov    %eax,%edx
c0103cb3:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103cb8:	39 c2                	cmp    %eax,%edx
c0103cba:	72 1c                	jb     c0103cd8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103cbc:	c7 44 24 08 24 6b 10 	movl   $0xc0106b24,0x8(%esp)
c0103cc3:	c0 
c0103cc4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103ccb:	00 
c0103ccc:	c7 04 24 43 6b 10 c0 	movl   $0xc0106b43,(%esp)
c0103cd3:	e8 10 d0 ff ff       	call   c0100ce8 <__panic>
    return &pages[PPN(pa)];
c0103cd8:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0103cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce1:	c1 e8 0c             	shr    $0xc,%eax
c0103ce4:	89 c2                	mov    %eax,%edx
c0103ce6:	89 d0                	mov    %edx,%eax
c0103ce8:	c1 e0 02             	shl    $0x2,%eax
c0103ceb:	01 d0                	add    %edx,%eax
c0103ced:	c1 e0 02             	shl    $0x2,%eax
c0103cf0:	01 c8                	add    %ecx,%eax
}
c0103cf2:	89 ec                	mov    %ebp,%esp
c0103cf4:	5d                   	pop    %ebp
c0103cf5:	c3                   	ret    

c0103cf6 <page2kva>:
page2kva(struct Page *page) {
c0103cf6:	55                   	push   %ebp
c0103cf7:	89 e5                	mov    %esp,%ebp
c0103cf9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cff:	89 04 24             	mov    %eax,(%esp)
c0103d02:	e8 86 ff ff ff       	call   c0103c8d <page2pa>
c0103d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d0d:	c1 e8 0c             	shr    $0xc,%eax
c0103d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d13:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103d18:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103d1b:	72 23                	jb     c0103d40 <page2kva+0x4a>
c0103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d20:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d24:	c7 44 24 08 54 6b 10 	movl   $0xc0106b54,0x8(%esp)
c0103d2b:	c0 
c0103d2c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103d33:	00 
c0103d34:	c7 04 24 43 6b 10 c0 	movl   $0xc0106b43,(%esp)
c0103d3b:	e8 a8 cf ff ff       	call   c0100ce8 <__panic>
c0103d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d43:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103d48:	89 ec                	mov    %ebp,%esp
c0103d4a:	5d                   	pop    %ebp
c0103d4b:	c3                   	ret    

c0103d4c <pte2page>:
pte2page(pte_t pte) {
c0103d4c:	55                   	push   %ebp
c0103d4d:	89 e5                	mov    %esp,%ebp
c0103d4f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d55:	83 e0 01             	and    $0x1,%eax
c0103d58:	85 c0                	test   %eax,%eax
c0103d5a:	75 1c                	jne    c0103d78 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103d5c:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c0103d63:	c0 
c0103d64:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103d6b:	00 
c0103d6c:	c7 04 24 43 6b 10 c0 	movl   $0xc0106b43,(%esp)
c0103d73:	e8 70 cf ff ff       	call   c0100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d80:	89 04 24             	mov    %eax,(%esp)
c0103d83:	e8 1d ff ff ff       	call   c0103ca5 <pa2page>
}
c0103d88:	89 ec                	mov    %ebp,%esp
c0103d8a:	5d                   	pop    %ebp
c0103d8b:	c3                   	ret    

c0103d8c <pde2page>:
pde2page(pde_t pde) {
c0103d8c:	55                   	push   %ebp
c0103d8d:	89 e5                	mov    %esp,%ebp
c0103d8f:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d9a:	89 04 24             	mov    %eax,(%esp)
c0103d9d:	e8 03 ff ff ff       	call   c0103ca5 <pa2page>
}
c0103da2:	89 ec                	mov    %ebp,%esp
c0103da4:	5d                   	pop    %ebp
c0103da5:	c3                   	ret    

c0103da6 <page_ref>:
page_ref(struct Page *page) {
c0103da6:	55                   	push   %ebp
c0103da7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103da9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dac:	8b 00                	mov    (%eax),%eax
}
c0103dae:	5d                   	pop    %ebp
c0103daf:	c3                   	ret    

c0103db0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103db0:	55                   	push   %ebp
c0103db1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103db3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db6:	8b 00                	mov    (%eax),%eax
c0103db8:	8d 50 01             	lea    0x1(%eax),%edx
c0103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dbe:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc3:	8b 00                	mov    (%eax),%eax
}
c0103dc5:	5d                   	pop    %ebp
c0103dc6:	c3                   	ret    

c0103dc7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103dc7:	55                   	push   %ebp
c0103dc8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dcd:	8b 00                	mov    (%eax),%eax
c0103dcf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dd5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dda:	8b 00                	mov    (%eax),%eax
}
c0103ddc:	5d                   	pop    %ebp
c0103ddd:	c3                   	ret    

c0103dde <__intr_save>:
__intr_save(void) {
c0103dde:	55                   	push   %ebp
c0103ddf:	89 e5                	mov    %esp,%ebp
c0103de1:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103de4:	9c                   	pushf  
c0103de5:	58                   	pop    %eax
c0103de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103dec:	25 00 02 00 00       	and    $0x200,%eax
c0103df1:	85 c0                	test   %eax,%eax
c0103df3:	74 0c                	je     c0103e01 <__intr_save+0x23>
        intr_disable();
c0103df5:	e8 47 d9 ff ff       	call   c0101741 <intr_disable>
        return 1;
c0103dfa:	b8 01 00 00 00       	mov    $0x1,%eax
c0103dff:	eb 05                	jmp    c0103e06 <__intr_save+0x28>
    return 0;
c0103e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103e06:	89 ec                	mov    %ebp,%esp
c0103e08:	5d                   	pop    %ebp
c0103e09:	c3                   	ret    

c0103e0a <__intr_restore>:
__intr_restore(bool flag) {
c0103e0a:	55                   	push   %ebp
c0103e0b:	89 e5                	mov    %esp,%ebp
c0103e0d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103e10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103e14:	74 05                	je     c0103e1b <__intr_restore+0x11>
        intr_enable();
c0103e16:	e8 1e d9 ff ff       	call   c0101739 <intr_enable>
}
c0103e1b:	90                   	nop
c0103e1c:	89 ec                	mov    %ebp,%esp
c0103e1e:	5d                   	pop    %ebp
c0103e1f:	c3                   	ret    

c0103e20 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103e20:	55                   	push   %ebp
c0103e21:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e26:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103e29:	b8 23 00 00 00       	mov    $0x23,%eax
c0103e2e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103e30:	b8 23 00 00 00       	mov    $0x23,%eax
c0103e35:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103e37:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e3c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103e3e:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e43:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103e45:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e4a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103e4c:	ea 53 3e 10 c0 08 00 	ljmp   $0x8,$0xc0103e53
}
c0103e53:	90                   	nop
c0103e54:	5d                   	pop    %ebp
c0103e55:	c3                   	ret    

c0103e56 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103e56:	55                   	push   %ebp
c0103e57:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e5c:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0103e61:	90                   	nop
c0103e62:	5d                   	pop    %ebp
c0103e63:	c3                   	ret    

c0103e64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e64:	55                   	push   %ebp
c0103e65:	89 e5                	mov    %esp,%ebp
c0103e67:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103e6a:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0103e6f:	89 04 24             	mov    %eax,(%esp)
c0103e72:	e8 df ff ff ff       	call   c0103e56 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e77:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0103e7e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e80:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0103e87:	68 00 
c0103e89:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e8e:	0f b7 c0             	movzwl %ax,%eax
c0103e91:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0103e97:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e9c:	c1 e8 10             	shr    $0x10,%eax
c0103e9f:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0103ea4:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103eab:	24 f0                	and    $0xf0,%al
c0103ead:	0c 09                	or     $0x9,%al
c0103eaf:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103eb4:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103ebb:	24 ef                	and    $0xef,%al
c0103ebd:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103ec2:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103ec9:	24 9f                	and    $0x9f,%al
c0103ecb:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103ed0:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103ed7:	0c 80                	or     $0x80,%al
c0103ed9:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103ede:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ee5:	24 f0                	and    $0xf0,%al
c0103ee7:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103eec:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ef3:	24 ef                	and    $0xef,%al
c0103ef5:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103efa:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103f01:	24 df                	and    $0xdf,%al
c0103f03:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103f08:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103f0f:	0c 40                	or     $0x40,%al
c0103f11:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103f16:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103f1d:	24 7f                	and    $0x7f,%al
c0103f1f:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103f24:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103f29:	c1 e8 18             	shr    $0x18,%eax
c0103f2c:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103f31:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0103f38:	e8 e3 fe ff ff       	call   c0103e20 <lgdt>
c0103f3d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103f43:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103f47:	0f 00 d8             	ltr    %ax
}
c0103f4a:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103f4b:	90                   	nop
c0103f4c:	89 ec                	mov    %ebp,%esp
c0103f4e:	5d                   	pop    %ebp
c0103f4f:	c3                   	ret    

c0103f50 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103f50:	55                   	push   %ebp
c0103f51:	89 e5                	mov    %esp,%ebp
c0103f53:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103f56:	c7 05 ac ce 11 c0 08 	movl   $0xc0106b08,0xc011ceac
c0103f5d:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f60:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f65:	8b 00                	mov    (%eax),%eax
c0103f67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f6b:	c7 04 24 a4 6b 10 c0 	movl   $0xc0106ba4,(%esp)
c0103f72:	e8 df c3 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103f77:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f7c:	8b 40 04             	mov    0x4(%eax),%eax
c0103f7f:	ff d0                	call   *%eax
}
c0103f81:	90                   	nop
c0103f82:	89 ec                	mov    %ebp,%esp
c0103f84:	5d                   	pop    %ebp
c0103f85:	c3                   	ret    

c0103f86 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f86:	55                   	push   %ebp
c0103f87:	89 e5                	mov    %esp,%ebp
c0103f89:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f8c:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f91:	8b 40 08             	mov    0x8(%eax),%eax
c0103f94:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f97:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f9b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f9e:	89 14 24             	mov    %edx,(%esp)
c0103fa1:	ff d0                	call   *%eax
}
c0103fa3:	90                   	nop
c0103fa4:	89 ec                	mov    %ebp,%esp
c0103fa6:	5d                   	pop    %ebp
c0103fa7:	c3                   	ret    

c0103fa8 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103fa8:	55                   	push   %ebp
c0103fa9:	89 e5                	mov    %esp,%ebp
c0103fab:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fb5:	e8 24 fe ff ff       	call   c0103dde <__intr_save>
c0103fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103fbd:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103fc2:	8b 40 0c             	mov    0xc(%eax),%eax
c0103fc5:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fc8:	89 14 24             	mov    %edx,(%esp)
c0103fcb:	ff d0                	call   *%eax
c0103fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fd3:	89 04 24             	mov    %eax,(%esp)
c0103fd6:	e8 2f fe ff ff       	call   c0103e0a <__intr_restore>
    return page;
c0103fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103fde:	89 ec                	mov    %ebp,%esp
c0103fe0:	5d                   	pop    %ebp
c0103fe1:	c3                   	ret    

c0103fe2 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103fe2:	55                   	push   %ebp
c0103fe3:	89 e5                	mov    %esp,%ebp
c0103fe5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fe8:	e8 f1 fd ff ff       	call   c0103dde <__intr_save>
c0103fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103ff0:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103ff5:	8b 40 10             	mov    0x10(%eax),%eax
c0103ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fff:	8b 55 08             	mov    0x8(%ebp),%edx
c0104002:	89 14 24             	mov    %edx,(%esp)
c0104005:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104007:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010400a:	89 04 24             	mov    %eax,(%esp)
c010400d:	e8 f8 fd ff ff       	call   c0103e0a <__intr_restore>
}
c0104012:	90                   	nop
c0104013:	89 ec                	mov    %ebp,%esp
c0104015:	5d                   	pop    %ebp
c0104016:	c3                   	ret    

c0104017 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104017:	55                   	push   %ebp
c0104018:	89 e5                	mov    %esp,%ebp
c010401a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010401d:	e8 bc fd ff ff       	call   c0103dde <__intr_save>
c0104022:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104025:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c010402a:	8b 40 14             	mov    0x14(%eax),%eax
c010402d:	ff d0                	call   *%eax
c010402f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104032:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104035:	89 04 24             	mov    %eax,(%esp)
c0104038:	e8 cd fd ff ff       	call   c0103e0a <__intr_restore>
    return ret;
c010403d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104040:	89 ec                	mov    %ebp,%esp
c0104042:	5d                   	pop    %ebp
c0104043:	c3                   	ret    

c0104044 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104044:	55                   	push   %ebp
c0104045:	89 e5                	mov    %esp,%ebp
c0104047:	57                   	push   %edi
c0104048:	56                   	push   %esi
c0104049:	53                   	push   %ebx
c010404a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104050:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
c0104057:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010405e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104065:	c7 04 24 bb 6b 10 c0 	movl   $0xc0106bbb,(%esp)
c010406c:	e8 e5 c2 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104071:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104078:	e9 0c 01 00 00       	jmp    c0104189 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010407d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104080:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104083:	89 d0                	mov    %edx,%eax
c0104085:	c1 e0 02             	shl    $0x2,%eax
c0104088:	01 d0                	add    %edx,%eax
c010408a:	c1 e0 02             	shl    $0x2,%eax
c010408d:	01 c8                	add    %ecx,%eax
c010408f:	8b 50 08             	mov    0x8(%eax),%edx
c0104092:	8b 40 04             	mov    0x4(%eax),%eax
c0104095:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104098:	89 55 ac             	mov    %edx,-0x54(%ebp)
c010409b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010409e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a1:	89 d0                	mov    %edx,%eax
c01040a3:	c1 e0 02             	shl    $0x2,%eax
c01040a6:	01 d0                	add    %edx,%eax
c01040a8:	c1 e0 02             	shl    $0x2,%eax
c01040ab:	01 c8                	add    %ecx,%eax
c01040ad:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040b0:	8b 58 10             	mov    0x10(%eax),%ebx
c01040b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01040b6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01040b9:	01 c8                	add    %ecx,%eax
c01040bb:	11 da                	adc    %ebx,%edx
c01040bd:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01040c0:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01040c3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01040c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040c9:	89 d0                	mov    %edx,%eax
c01040cb:	c1 e0 02             	shl    $0x2,%eax
c01040ce:	01 d0                	add    %edx,%eax
c01040d0:	c1 e0 02             	shl    $0x2,%eax
c01040d3:	01 c8                	add    %ecx,%eax
c01040d5:	83 c0 14             	add    $0x14,%eax
c01040d8:	8b 00                	mov    (%eax),%eax
c01040da:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01040e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040e3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040e6:	83 c0 ff             	add    $0xffffffff,%eax
c01040e9:	83 d2 ff             	adc    $0xffffffff,%edx
c01040ec:	89 c6                	mov    %eax,%esi
c01040ee:	89 d7                	mov    %edx,%edi
c01040f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040f6:	89 d0                	mov    %edx,%eax
c01040f8:	c1 e0 02             	shl    $0x2,%eax
c01040fb:	01 d0                	add    %edx,%eax
c01040fd:	c1 e0 02             	shl    $0x2,%eax
c0104100:	01 c8                	add    %ecx,%eax
c0104102:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104105:	8b 58 10             	mov    0x10(%eax),%ebx
c0104108:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010410e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104112:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104116:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010411a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010411d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104120:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104124:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104128:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010412c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104130:	c7 04 24 c8 6b 10 c0 	movl   $0xc0106bc8,(%esp)
c0104137:	e8 1a c2 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010413c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010413f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104142:	89 d0                	mov    %edx,%eax
c0104144:	c1 e0 02             	shl    $0x2,%eax
c0104147:	01 d0                	add    %edx,%eax
c0104149:	c1 e0 02             	shl    $0x2,%eax
c010414c:	01 c8                	add    %ecx,%eax
c010414e:	83 c0 14             	add    $0x14,%eax
c0104151:	8b 00                	mov    (%eax),%eax
c0104153:	83 f8 01             	cmp    $0x1,%eax
c0104156:	75 2e                	jne    c0104186 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0104158:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010415b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010415e:	3b 45 a0             	cmp    -0x60(%ebp),%eax
c0104161:	89 d0                	mov    %edx,%eax
c0104163:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104166:	73 1e                	jae    c0104186 <page_init+0x142>
c0104168:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c010416d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104172:	3b 55 a8             	cmp    -0x58(%ebp),%edx
c0104175:	1b 45 ac             	sbb    -0x54(%ebp),%eax
c0104178:	72 0c                	jb     c0104186 <page_init+0x142>
                maxpa = end;
c010417a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010417d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104180:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104183:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104186:	ff 45 dc             	incl   -0x24(%ebp)
c0104189:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010418c:	8b 00                	mov    (%eax),%eax
c010418e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104191:	0f 8c e6 fe ff ff    	jl     c010407d <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104197:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010419c:	b8 00 00 00 00       	mov    $0x0,%eax
c01041a1:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c01041a4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c01041a7:	73 0e                	jae    c01041b7 <page_init+0x173>
        maxpa = KMEMSIZE;
c01041a9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01041b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01041b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01041bd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041c1:	c1 ea 0c             	shr    $0xc,%edx
c01041c4:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01041c9:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
c01041d0:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c01041d5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01041d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041db:	01 d0                	add    %edx,%eax
c01041dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01041e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e8:	f7 75 c8             	divl   -0x38(%ebp)
c01041eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041ee:	29 d0                	sub    %edx,%eax
c01041f0:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0

    for (i = 0; i < npage; i ++) {
c01041f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041fc:	eb 2f                	jmp    c010422d <page_init+0x1e9>
        SetPageReserved(pages + i);
c01041fe:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0104204:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104207:	89 d0                	mov    %edx,%eax
c0104209:	c1 e0 02             	shl    $0x2,%eax
c010420c:	01 d0                	add    %edx,%eax
c010420e:	c1 e0 02             	shl    $0x2,%eax
c0104211:	01 c8                	add    %ecx,%eax
c0104213:	83 c0 04             	add    $0x4,%eax
c0104216:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
c010421d:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104220:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104223:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104226:	0f ab 10             	bts    %edx,(%eax)
}
c0104229:	90                   	nop
    for (i = 0; i < npage; i ++) {
c010422a:	ff 45 dc             	incl   -0x24(%ebp)
c010422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104230:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104235:	39 c2                	cmp    %eax,%edx
c0104237:	72 c5                	jb     c01041fe <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104239:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c010423f:	89 d0                	mov    %edx,%eax
c0104241:	c1 e0 02             	shl    $0x2,%eax
c0104244:	01 d0                	add    %edx,%eax
c0104246:	c1 e0 02             	shl    $0x2,%eax
c0104249:	89 c2                	mov    %eax,%edx
c010424b:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0104250:	01 d0                	add    %edx,%eax
c0104252:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104255:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
c010425c:	77 23                	ja     c0104281 <page_init+0x23d>
c010425e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104261:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104265:	c7 44 24 08 f8 6b 10 	movl   $0xc0106bf8,0x8(%esp)
c010426c:	c0 
c010426d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104274:	00 
c0104275:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010427c:	e8 67 ca ff ff       	call   c0100ce8 <__panic>
c0104281:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104284:	05 00 00 00 40       	add    $0x40000000,%eax
c0104289:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010428c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104293:	e9 85 01 00 00       	jmp    c010441d <page_init+0x3d9>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104298:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010429b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010429e:	89 d0                	mov    %edx,%eax
c01042a0:	c1 e0 02             	shl    $0x2,%eax
c01042a3:	01 d0                	add    %edx,%eax
c01042a5:	c1 e0 02             	shl    $0x2,%eax
c01042a8:	01 c8                	add    %ecx,%eax
c01042aa:	8b 50 08             	mov    0x8(%eax),%edx
c01042ad:	8b 40 04             	mov    0x4(%eax),%eax
c01042b0:	89 45 90             	mov    %eax,-0x70(%ebp)
c01042b3:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01042b6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01042b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042bc:	89 d0                	mov    %edx,%eax
c01042be:	c1 e0 02             	shl    $0x2,%eax
c01042c1:	01 d0                	add    %edx,%eax
c01042c3:	c1 e0 02             	shl    $0x2,%eax
c01042c6:	01 c8                	add    %ecx,%eax
c01042c8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01042cb:	8b 58 10             	mov    0x10(%eax),%ebx
c01042ce:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042d1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042d4:	01 c8                	add    %ecx,%eax
c01042d6:	11 da                	adc    %ebx,%edx
c01042d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042db:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01042de:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01042e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042e4:	89 d0                	mov    %edx,%eax
c01042e6:	c1 e0 02             	shl    $0x2,%eax
c01042e9:	01 d0                	add    %edx,%eax
c01042eb:	c1 e0 02             	shl    $0x2,%eax
c01042ee:	01 c8                	add    %ecx,%eax
c01042f0:	83 c0 14             	add    $0x14,%eax
c01042f3:	8b 00                	mov    (%eax),%eax
c01042f5:	83 f8 01             	cmp    $0x1,%eax
c01042f8:	0f 85 1c 01 00 00    	jne    c010441a <page_init+0x3d6>
            if (begin < freemem) {
c01042fe:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0104301:	bb 00 00 00 00       	mov    $0x0,%ebx
c0104306:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104309:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010430c:	39 c8                	cmp    %ecx,%eax
c010430e:	89 d0                	mov    %edx,%eax
c0104310:	19 d8                	sbb    %ebx,%eax
c0104312:	73 0e                	jae    c0104322 <page_init+0x2de>
                begin = freemem;
c0104314:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104317:	ba 00 00 00 00       	mov    $0x0,%edx
c010431c:	89 45 90             	mov    %eax,-0x70(%ebp)
c010431f:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104322:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104327:	b8 00 00 00 00       	mov    $0x0,%eax
c010432c:	3b 55 d0             	cmp    -0x30(%ebp),%edx
c010432f:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c0104332:	73 0e                	jae    c0104342 <page_init+0x2fe>
                end = KMEMSIZE;
c0104334:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
c010433b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
c0104342:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104345:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104348:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010434b:	89 d0                	mov    %edx,%eax
c010434d:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c0104350:	0f 83 c4 00 00 00    	jae    c010441a <page_init+0x3d6>
                begin = ROUNDUP(begin, PGSIZE);
c0104356:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
c010435d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104360:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104363:	89 c2                	mov    %eax,%edx
c0104365:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104368:	01 d0                	add    %edx,%eax
c010436a:	48                   	dec    %eax
c010436b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010436e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104371:	ba 00 00 00 00       	mov    $0x0,%edx
c0104376:	f7 75 b8             	divl   -0x48(%ebp)
c0104379:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010437c:	29 d0                	sub    %edx,%eax
c010437e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104383:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104386:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104389:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010438c:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010438f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104392:	ba 00 00 00 00       	mov    $0x0,%edx
c0104397:	89 c7                	mov    %eax,%edi
c0104399:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010439f:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01043a2:	89 d0                	mov    %edx,%eax
c01043a4:	83 e0 00             	and    $0x0,%eax
c01043a7:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01043aa:	8b 45 80             	mov    -0x80(%ebp),%eax
c01043ad:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01043b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01043b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                if (begin < end) {
c01043b6:	8b 45 90             	mov    -0x70(%ebp),%eax
c01043b9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01043bc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01043bf:	89 d0                	mov    %edx,%eax
c01043c1:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01043c4:	73 54                	jae    c010441a <page_init+0x3d6>

                    cprintf("memory: %08llx,%08llx\n",begin,&begin);
c01043c6:	8b 45 90             	mov    -0x70(%ebp),%eax
c01043c9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01043cc:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c01043cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01043d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043d7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01043db:	c7 04 24 2a 6c 10 c0 	movl   $0xc0106c2a,(%esp)
c01043e2:	e8 6f bf ff ff       	call   c0100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01043e7:	8b 4d 90             	mov    -0x70(%ebp),%ecx
c01043ea:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
c01043ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043f3:	29 c8                	sub    %ecx,%eax
c01043f5:	19 da                	sbb    %ebx,%edx
c01043f7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01043fb:	c1 ea 0c             	shr    $0xc,%edx
c01043fe:	89 c3                	mov    %eax,%ebx
c0104400:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104403:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104406:	89 04 24             	mov    %eax,(%esp)
c0104409:	e8 97 f8 ff ff       	call   c0103ca5 <pa2page>
c010440e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104412:	89 04 24             	mov    %eax,(%esp)
c0104415:	e8 6c fb ff ff       	call   c0103f86 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010441a:	ff 45 dc             	incl   -0x24(%ebp)
c010441d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104420:	8b 00                	mov    (%eax),%eax
c0104422:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104425:	0f 8c 6d fe ff ff    	jl     c0104298 <page_init+0x254>
                }
            }
        }
    }
}
c010442b:	90                   	nop
c010442c:	90                   	nop
c010442d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104433:	5b                   	pop    %ebx
c0104434:	5e                   	pop    %esi
c0104435:	5f                   	pop    %edi
c0104436:	5d                   	pop    %ebp
c0104437:	c3                   	ret    

c0104438 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104438:	55                   	push   %ebp
c0104439:	89 e5                	mov    %esp,%ebp
c010443b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010443e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104441:	33 45 14             	xor    0x14(%ebp),%eax
c0104444:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104449:	85 c0                	test   %eax,%eax
c010444b:	74 24                	je     c0104471 <boot_map_segment+0x39>
c010444d:	c7 44 24 0c 41 6c 10 	movl   $0xc0106c41,0xc(%esp)
c0104454:	c0 
c0104455:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c010445c:	c0 
c010445d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104464:	00 
c0104465:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010446c:	e8 77 c8 ff ff       	call   c0100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104471:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010447b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104480:	89 c2                	mov    %eax,%edx
c0104482:	8b 45 10             	mov    0x10(%ebp),%eax
c0104485:	01 c2                	add    %eax,%edx
c0104487:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010448a:	01 d0                	add    %edx,%eax
c010448c:	48                   	dec    %eax
c010448d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104493:	ba 00 00 00 00       	mov    $0x0,%edx
c0104498:	f7 75 f0             	divl   -0x10(%ebp)
c010449b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010449e:	29 d0                	sub    %edx,%eax
c01044a0:	c1 e8 0c             	shr    $0xc,%eax
c01044a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01044a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044b4:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01044b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01044ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044c5:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044c8:	eb 68                	jmp    c0104532 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01044ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01044d1:	00 
c01044d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044dc:	89 04 24             	mov    %eax,(%esp)
c01044df:	e8 88 01 00 00       	call   c010466c <get_pte>
c01044e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01044e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01044eb:	75 24                	jne    c0104511 <boot_map_segment+0xd9>
c01044ed:	c7 44 24 0c 6d 6c 10 	movl   $0xc0106c6d,0xc(%esp)
c01044f4:	c0 
c01044f5:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01044fc:	c0 
c01044fd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104504:	00 
c0104505:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010450c:	e8 d7 c7 ff ff       	call   c0100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
c0104511:	8b 45 14             	mov    0x14(%ebp),%eax
c0104514:	0b 45 18             	or     0x18(%ebp),%eax
c0104517:	83 c8 01             	or     $0x1,%eax
c010451a:	89 c2                	mov    %eax,%edx
c010451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104521:	ff 4d f4             	decl   -0xc(%ebp)
c0104524:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010452b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104536:	75 92                	jne    c01044ca <boot_map_segment+0x92>
    }
}
c0104538:	90                   	nop
c0104539:	90                   	nop
c010453a:	89 ec                	mov    %ebp,%esp
c010453c:	5d                   	pop    %ebp
c010453d:	c3                   	ret    

c010453e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010453e:	55                   	push   %ebp
c010453f:	89 e5                	mov    %esp,%ebp
c0104541:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104544:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010454b:	e8 58 fa ff ff       	call   c0103fa8 <alloc_pages>
c0104550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104557:	75 1c                	jne    c0104575 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104559:	c7 44 24 08 7a 6c 10 	movl   $0xc0106c7a,0x8(%esp)
c0104560:	c0 
c0104561:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104568:	00 
c0104569:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104570:	e8 73 c7 ff ff       	call   c0100ce8 <__panic>
    }
    return page2kva(p);
c0104575:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104578:	89 04 24             	mov    %eax,(%esp)
c010457b:	e8 76 f7 ff ff       	call   c0103cf6 <page2kva>
}
c0104580:	89 ec                	mov    %ebp,%esp
c0104582:	5d                   	pop    %ebp
c0104583:	c3                   	ret    

c0104584 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104584:	55                   	push   %ebp
c0104585:	89 e5                	mov    %esp,%ebp
c0104587:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010458a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010458f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104592:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104599:	77 23                	ja     c01045be <pmm_init+0x3a>
c010459b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045a2:	c7 44 24 08 f8 6b 10 	movl   $0xc0106bf8,0x8(%esp)
c01045a9:	c0 
c01045aa:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01045b1:	00 
c01045b2:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01045b9:	e8 2a c7 ff ff       	call   c0100ce8 <__panic>
c01045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c1:	05 00 00 00 40       	add    $0x40000000,%eax
c01045c6:	a3 a8 ce 11 c0       	mov    %eax,0xc011cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01045cb:	e8 80 f9 ff ff       	call   c0103f50 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01045d0:	e8 6f fa ff ff       	call   c0104044 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01045d5:	e8 5a 02 00 00       	call   c0104834 <check_alloc_page>

    check_pgdir();
c01045da:	e8 76 02 00 00       	call   c0104855 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01045df:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045e7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01045ee:	77 23                	ja     c0104613 <pmm_init+0x8f>
c01045f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045f7:	c7 44 24 08 f8 6b 10 	movl   $0xc0106bf8,0x8(%esp)
c01045fe:	c0 
c01045ff:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0104606:	00 
c0104607:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010460e:	e8 d5 c6 ff ff       	call   c0100ce8 <__panic>
c0104613:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104616:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010461c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104621:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104626:	83 ca 03             	or     $0x3,%edx
c0104629:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010462b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104630:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104637:	00 
c0104638:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010463f:	00 
c0104640:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104647:	38 
c0104648:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010464f:	c0 
c0104650:	89 04 24             	mov    %eax,(%esp)
c0104653:	e8 e0 fd ff ff       	call   c0104438 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104658:	e8 07 f8 ff ff       	call   c0103e64 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010465d:	e8 91 08 00 00       	call   c0104ef3 <check_boot_pgdir>

    print_pgdir();
c0104662:	e8 0e 0d 00 00       	call   c0105375 <print_pgdir>

}
c0104667:	90                   	nop
c0104668:	89 ec                	mov    %ebp,%esp
c010466a:	5d                   	pop    %ebp
c010466b:	c3                   	ret    

c010466c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010466c:	55                   	push   %ebp
c010466d:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010466f:	90                   	nop
c0104670:	5d                   	pop    %ebp
c0104671:	c3                   	ret    

c0104672 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104672:	55                   	push   %ebp
c0104673:	89 e5                	mov    %esp,%ebp
c0104675:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104678:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010467f:	00 
c0104680:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104683:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104687:	8b 45 08             	mov    0x8(%ebp),%eax
c010468a:	89 04 24             	mov    %eax,(%esp)
c010468d:	e8 da ff ff ff       	call   c010466c <get_pte>
c0104692:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104695:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104699:	74 08                	je     c01046a3 <get_page+0x31>
        *ptep_store = ptep;
c010469b:	8b 45 10             	mov    0x10(%ebp),%eax
c010469e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046a1:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01046a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046a7:	74 1b                	je     c01046c4 <get_page+0x52>
c01046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ac:	8b 00                	mov    (%eax),%eax
c01046ae:	83 e0 01             	and    $0x1,%eax
c01046b1:	85 c0                	test   %eax,%eax
c01046b3:	74 0f                	je     c01046c4 <get_page+0x52>
        return pte2page(*ptep);
c01046b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b8:	8b 00                	mov    (%eax),%eax
c01046ba:	89 04 24             	mov    %eax,(%esp)
c01046bd:	e8 8a f6 ff ff       	call   c0103d4c <pte2page>
c01046c2:	eb 05                	jmp    c01046c9 <get_page+0x57>
    }
    return NULL;
c01046c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046c9:	89 ec                	mov    %ebp,%esp
c01046cb:	5d                   	pop    %ebp
c01046cc:	c3                   	ret    

c01046cd <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01046cd:	55                   	push   %ebp
c01046ce:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01046d0:	90                   	nop
c01046d1:	5d                   	pop    %ebp
c01046d2:	c3                   	ret    

c01046d3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01046d3:	55                   	push   %ebp
c01046d4:	89 e5                	mov    %esp,%ebp
c01046d6:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01046d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046e0:	00 
c01046e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046eb:	89 04 24             	mov    %eax,(%esp)
c01046ee:	e8 79 ff ff ff       	call   c010466c <get_pte>
c01046f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01046f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01046fa:	74 19                	je     c0104715 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01046ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104703:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104706:	89 44 24 04          	mov    %eax,0x4(%esp)
c010470a:	8b 45 08             	mov    0x8(%ebp),%eax
c010470d:	89 04 24             	mov    %eax,(%esp)
c0104710:	e8 b8 ff ff ff       	call   c01046cd <page_remove_pte>
    }
}
c0104715:	90                   	nop
c0104716:	89 ec                	mov    %ebp,%esp
c0104718:	5d                   	pop    %ebp
c0104719:	c3                   	ret    

c010471a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010471a:	55                   	push   %ebp
c010471b:	89 e5                	mov    %esp,%ebp
c010471d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104720:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104727:	00 
c0104728:	8b 45 10             	mov    0x10(%ebp),%eax
c010472b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010472f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104732:	89 04 24             	mov    %eax,(%esp)
c0104735:	e8 32 ff ff ff       	call   c010466c <get_pte>
c010473a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010473d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104741:	75 0a                	jne    c010474d <page_insert+0x33>
        return -E_NO_MEM;
c0104743:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104748:	e9 84 00 00 00       	jmp    c01047d1 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010474d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104750:	89 04 24             	mov    %eax,(%esp)
c0104753:	e8 58 f6 ff ff       	call   c0103db0 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475b:	8b 00                	mov    (%eax),%eax
c010475d:	83 e0 01             	and    $0x1,%eax
c0104760:	85 c0                	test   %eax,%eax
c0104762:	74 3e                	je     c01047a2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104767:	8b 00                	mov    (%eax),%eax
c0104769:	89 04 24             	mov    %eax,(%esp)
c010476c:	e8 db f5 ff ff       	call   c0103d4c <pte2page>
c0104771:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104774:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104777:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010477a:	75 0d                	jne    c0104789 <page_insert+0x6f>
            page_ref_dec(page);
c010477c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010477f:	89 04 24             	mov    %eax,(%esp)
c0104782:	e8 40 f6 ff ff       	call   c0103dc7 <page_ref_dec>
c0104787:	eb 19                	jmp    c01047a2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104790:	8b 45 10             	mov    0x10(%ebp),%eax
c0104793:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104797:	8b 45 08             	mov    0x8(%ebp),%eax
c010479a:	89 04 24             	mov    %eax,(%esp)
c010479d:	e8 2b ff ff ff       	call   c01046cd <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047a5:	89 04 24             	mov    %eax,(%esp)
c01047a8:	e8 e0 f4 ff ff       	call   c0103c8d <page2pa>
c01047ad:	0b 45 14             	or     0x14(%ebp),%eax
c01047b0:	83 c8 01             	or     $0x1,%eax
c01047b3:	89 c2                	mov    %eax,%edx
c01047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01047ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01047bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c4:	89 04 24             	mov    %eax,(%esp)
c01047c7:	e8 09 00 00 00       	call   c01047d5 <tlb_invalidate>
    return 0;
c01047cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047d1:	89 ec                	mov    %ebp,%esp
c01047d3:	5d                   	pop    %ebp
c01047d4:	c3                   	ret    

c01047d5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01047d5:	55                   	push   %ebp
c01047d6:	89 e5                	mov    %esp,%ebp
c01047d8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01047db:	0f 20 d8             	mov    %cr3,%eax
c01047de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01047e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01047e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047ea:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047f1:	77 23                	ja     c0104816 <tlb_invalidate+0x41>
c01047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047fa:	c7 44 24 08 f8 6b 10 	movl   $0xc0106bf8,0x8(%esp)
c0104801:	c0 
c0104802:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
c0104809:	00 
c010480a:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104811:	e8 d2 c4 ff ff       	call   c0100ce8 <__panic>
c0104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104819:	05 00 00 00 40       	add    $0x40000000,%eax
c010481e:	39 d0                	cmp    %edx,%eax
c0104820:	75 0d                	jne    c010482f <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0104822:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104825:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104828:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010482b:	0f 01 38             	invlpg (%eax)
}
c010482e:	90                   	nop
    }
}
c010482f:	90                   	nop
c0104830:	89 ec                	mov    %ebp,%esp
c0104832:	5d                   	pop    %ebp
c0104833:	c3                   	ret    

c0104834 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104834:	55                   	push   %ebp
c0104835:	89 e5                	mov    %esp,%ebp
c0104837:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010483a:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c010483f:	8b 40 18             	mov    0x18(%eax),%eax
c0104842:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104844:	c7 04 24 94 6c 10 c0 	movl   $0xc0106c94,(%esp)
c010484b:	e8 06 bb ff ff       	call   c0100356 <cprintf>
}
c0104850:	90                   	nop
c0104851:	89 ec                	mov    %ebp,%esp
c0104853:	5d                   	pop    %ebp
c0104854:	c3                   	ret    

c0104855 <check_pgdir>:

static void
check_pgdir(void) {
c0104855:	55                   	push   %ebp
c0104856:	89 e5                	mov    %esp,%ebp
c0104858:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010485b:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104860:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104865:	76 24                	jbe    c010488b <check_pgdir+0x36>
c0104867:	c7 44 24 0c b3 6c 10 	movl   $0xc0106cb3,0xc(%esp)
c010486e:	c0 
c010486f:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104876:	c0 
c0104877:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c010487e:	00 
c010487f:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104886:	e8 5d c4 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010488b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104890:	85 c0                	test   %eax,%eax
c0104892:	74 0e                	je     c01048a2 <check_pgdir+0x4d>
c0104894:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104899:	25 ff 0f 00 00       	and    $0xfff,%eax
c010489e:	85 c0                	test   %eax,%eax
c01048a0:	74 24                	je     c01048c6 <check_pgdir+0x71>
c01048a2:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c01048a9:	c0 
c01048aa:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01048b1:	c0 
c01048b2:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
c01048b9:	00 
c01048ba:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01048c1:	e8 22 c4 ff ff       	call   c0100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01048c6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01048cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048d2:	00 
c01048d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048da:	00 
c01048db:	89 04 24             	mov    %eax,(%esp)
c01048de:	e8 8f fd ff ff       	call   c0104672 <get_page>
c01048e3:	85 c0                	test   %eax,%eax
c01048e5:	74 24                	je     c010490b <check_pgdir+0xb6>
c01048e7:	c7 44 24 0c 08 6d 10 	movl   $0xc0106d08,0xc(%esp)
c01048ee:	c0 
c01048ef:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01048f6:	c0 
c01048f7:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c01048fe:	00 
c01048ff:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104906:	e8 dd c3 ff ff       	call   c0100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010490b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104912:	e8 91 f6 ff ff       	call   c0103fa8 <alloc_pages>
c0104917:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010491a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010491f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104926:	00 
c0104927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010492e:	00 
c010492f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104932:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104936:	89 04 24             	mov    %eax,(%esp)
c0104939:	e8 dc fd ff ff       	call   c010471a <page_insert>
c010493e:	85 c0                	test   %eax,%eax
c0104940:	74 24                	je     c0104966 <check_pgdir+0x111>
c0104942:	c7 44 24 0c 30 6d 10 	movl   $0xc0106d30,0xc(%esp)
c0104949:	c0 
c010494a:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104951:	c0 
c0104952:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0104959:	00 
c010495a:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104961:	e8 82 c3 ff ff       	call   c0100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104966:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010496b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104972:	00 
c0104973:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010497a:	00 
c010497b:	89 04 24             	mov    %eax,(%esp)
c010497e:	e8 e9 fc ff ff       	call   c010466c <get_pte>
c0104983:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010498a:	75 24                	jne    c01049b0 <check_pgdir+0x15b>
c010498c:	c7 44 24 0c 5c 6d 10 	movl   $0xc0106d5c,0xc(%esp)
c0104993:	c0 
c0104994:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c010499b:	c0 
c010499c:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c01049a3:	00 
c01049a4:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01049ab:	e8 38 c3 ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c01049b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b3:	8b 00                	mov    (%eax),%eax
c01049b5:	89 04 24             	mov    %eax,(%esp)
c01049b8:	e8 8f f3 ff ff       	call   c0103d4c <pte2page>
c01049bd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01049c0:	74 24                	je     c01049e6 <check_pgdir+0x191>
c01049c2:	c7 44 24 0c 89 6d 10 	movl   $0xc0106d89,0xc(%esp)
c01049c9:	c0 
c01049ca:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01049d1:	c0 
c01049d2:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c01049d9:	00 
c01049da:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01049e1:	e8 02 c3 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 1);
c01049e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e9:	89 04 24             	mov    %eax,(%esp)
c01049ec:	e8 b5 f3 ff ff       	call   c0103da6 <page_ref>
c01049f1:	83 f8 01             	cmp    $0x1,%eax
c01049f4:	74 24                	je     c0104a1a <check_pgdir+0x1c5>
c01049f6:	c7 44 24 0c 9f 6d 10 	movl   $0xc0106d9f,0xc(%esp)
c01049fd:	c0 
c01049fe:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104a05:	c0 
c0104a06:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104a0d:	00 
c0104a0e:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104a15:	e8 ce c2 ff ff       	call   c0100ce8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104a1a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a1f:	8b 00                	mov    (%eax),%eax
c0104a21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a26:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a2c:	c1 e8 0c             	shr    $0xc,%eax
c0104a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a32:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104a37:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a3a:	72 23                	jb     c0104a5f <check_pgdir+0x20a>
c0104a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a43:	c7 44 24 08 54 6b 10 	movl   $0xc0106b54,0x8(%esp)
c0104a4a:	c0 
c0104a4b:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c0104a52:	00 
c0104a53:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104a5a:	e8 89 c2 ff ff       	call   c0100ce8 <__panic>
c0104a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a62:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a67:	83 c0 04             	add    $0x4,%eax
c0104a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a6d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a79:	00 
c0104a7a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a81:	00 
c0104a82:	89 04 24             	mov    %eax,(%esp)
c0104a85:	e8 e2 fb ff ff       	call   c010466c <get_pte>
c0104a8a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a8d:	74 24                	je     c0104ab3 <check_pgdir+0x25e>
c0104a8f:	c7 44 24 0c b4 6d 10 	movl   $0xc0106db4,0xc(%esp)
c0104a96:	c0 
c0104a97:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104a9e:	c0 
c0104a9f:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c0104aa6:	00 
c0104aa7:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104aae:	e8 35 c2 ff ff       	call   c0100ce8 <__panic>

    p2 = alloc_page();
c0104ab3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104aba:	e8 e9 f4 ff ff       	call   c0103fa8 <alloc_pages>
c0104abf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104ac2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ac7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ace:	00 
c0104acf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ad6:	00 
c0104ad7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ada:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ade:	89 04 24             	mov    %eax,(%esp)
c0104ae1:	e8 34 fc ff ff       	call   c010471a <page_insert>
c0104ae6:	85 c0                	test   %eax,%eax
c0104ae8:	74 24                	je     c0104b0e <check_pgdir+0x2b9>
c0104aea:	c7 44 24 0c dc 6d 10 	movl   $0xc0106ddc,0xc(%esp)
c0104af1:	c0 
c0104af2:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104af9:	c0 
c0104afa:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104b01:	00 
c0104b02:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104b09:	e8 da c1 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b0e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b1a:	00 
c0104b1b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b22:	00 
c0104b23:	89 04 24             	mov    %eax,(%esp)
c0104b26:	e8 41 fb ff ff       	call   c010466c <get_pte>
c0104b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b32:	75 24                	jne    c0104b58 <check_pgdir+0x303>
c0104b34:	c7 44 24 0c 14 6e 10 	movl   $0xc0106e14,0xc(%esp)
c0104b3b:	c0 
c0104b3c:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104b43:	c0 
c0104b44:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104b4b:	00 
c0104b4c:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104b53:	e8 90 c1 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_U);
c0104b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5b:	8b 00                	mov    (%eax),%eax
c0104b5d:	83 e0 04             	and    $0x4,%eax
c0104b60:	85 c0                	test   %eax,%eax
c0104b62:	75 24                	jne    c0104b88 <check_pgdir+0x333>
c0104b64:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104b73:	c0 
c0104b74:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104b7b:	00 
c0104b7c:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104b83:	e8 60 c1 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_W);
c0104b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8b:	8b 00                	mov    (%eax),%eax
c0104b8d:	83 e0 02             	and    $0x2,%eax
c0104b90:	85 c0                	test   %eax,%eax
c0104b92:	75 24                	jne    c0104bb8 <check_pgdir+0x363>
c0104b94:	c7 44 24 0c 52 6e 10 	movl   $0xc0106e52,0xc(%esp)
c0104b9b:	c0 
c0104b9c:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104ba3:	c0 
c0104ba4:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104bab:	00 
c0104bac:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104bb3:	e8 30 c1 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104bb8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104bbd:	8b 00                	mov    (%eax),%eax
c0104bbf:	83 e0 04             	and    $0x4,%eax
c0104bc2:	85 c0                	test   %eax,%eax
c0104bc4:	75 24                	jne    c0104bea <check_pgdir+0x395>
c0104bc6:	c7 44 24 0c 60 6e 10 	movl   $0xc0106e60,0xc(%esp)
c0104bcd:	c0 
c0104bce:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104bd5:	c0 
c0104bd6:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0104bdd:	00 
c0104bde:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104be5:	e8 fe c0 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 1);
c0104bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bed:	89 04 24             	mov    %eax,(%esp)
c0104bf0:	e8 b1 f1 ff ff       	call   c0103da6 <page_ref>
c0104bf5:	83 f8 01             	cmp    $0x1,%eax
c0104bf8:	74 24                	je     c0104c1e <check_pgdir+0x3c9>
c0104bfa:	c7 44 24 0c 76 6e 10 	movl   $0xc0106e76,0xc(%esp)
c0104c01:	c0 
c0104c02:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104c09:	c0 
c0104c0a:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104c11:	00 
c0104c12:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104c19:	e8 ca c0 ff ff       	call   c0100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104c1e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104c23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104c2a:	00 
c0104c2b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c32:	00 
c0104c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c36:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c3a:	89 04 24             	mov    %eax,(%esp)
c0104c3d:	e8 d8 fa ff ff       	call   c010471a <page_insert>
c0104c42:	85 c0                	test   %eax,%eax
c0104c44:	74 24                	je     c0104c6a <check_pgdir+0x415>
c0104c46:	c7 44 24 0c 88 6e 10 	movl   $0xc0106e88,0xc(%esp)
c0104c4d:	c0 
c0104c4e:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104c55:	c0 
c0104c56:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104c5d:	00 
c0104c5e:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104c65:	e8 7e c0 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 2);
c0104c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6d:	89 04 24             	mov    %eax,(%esp)
c0104c70:	e8 31 f1 ff ff       	call   c0103da6 <page_ref>
c0104c75:	83 f8 02             	cmp    $0x2,%eax
c0104c78:	74 24                	je     c0104c9e <check_pgdir+0x449>
c0104c7a:	c7 44 24 0c b4 6e 10 	movl   $0xc0106eb4,0xc(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104c89:	c0 
c0104c8a:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104c91:	00 
c0104c92:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104c99:	e8 4a c0 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ca1:	89 04 24             	mov    %eax,(%esp)
c0104ca4:	e8 fd f0 ff ff       	call   c0103da6 <page_ref>
c0104ca9:	85 c0                	test   %eax,%eax
c0104cab:	74 24                	je     c0104cd1 <check_pgdir+0x47c>
c0104cad:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c0104cb4:	c0 
c0104cb5:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104cbc:	c0 
c0104cbd:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104cc4:	00 
c0104cc5:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104ccc:	e8 17 c0 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104cd1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104cd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cdd:	00 
c0104cde:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ce5:	00 
c0104ce6:	89 04 24             	mov    %eax,(%esp)
c0104ce9:	e8 7e f9 ff ff       	call   c010466c <get_pte>
c0104cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cf5:	75 24                	jne    c0104d1b <check_pgdir+0x4c6>
c0104cf7:	c7 44 24 0c 14 6e 10 	movl   $0xc0106e14,0xc(%esp)
c0104cfe:	c0 
c0104cff:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104d06:	c0 
c0104d07:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104d0e:	00 
c0104d0f:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104d16:	e8 cd bf ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d1e:	8b 00                	mov    (%eax),%eax
c0104d20:	89 04 24             	mov    %eax,(%esp)
c0104d23:	e8 24 f0 ff ff       	call   c0103d4c <pte2page>
c0104d28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104d2b:	74 24                	je     c0104d51 <check_pgdir+0x4fc>
c0104d2d:	c7 44 24 0c 89 6d 10 	movl   $0xc0106d89,0xc(%esp)
c0104d34:	c0 
c0104d35:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104d3c:	c0 
c0104d3d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104d44:	00 
c0104d45:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104d4c:	e8 97 bf ff ff       	call   c0100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d54:	8b 00                	mov    (%eax),%eax
c0104d56:	83 e0 04             	and    $0x4,%eax
c0104d59:	85 c0                	test   %eax,%eax
c0104d5b:	74 24                	je     c0104d81 <check_pgdir+0x52c>
c0104d5d:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104d64:	c0 
c0104d65:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104d6c:	c0 
c0104d6d:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104d74:	00 
c0104d75:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104d7c:	e8 67 bf ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d81:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104d86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d8d:	00 
c0104d8e:	89 04 24             	mov    %eax,(%esp)
c0104d91:	e8 3d f9 ff ff       	call   c01046d3 <page_remove>
    assert(page_ref(p1) == 1);
c0104d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d99:	89 04 24             	mov    %eax,(%esp)
c0104d9c:	e8 05 f0 ff ff       	call   c0103da6 <page_ref>
c0104da1:	83 f8 01             	cmp    $0x1,%eax
c0104da4:	74 24                	je     c0104dca <check_pgdir+0x575>
c0104da6:	c7 44 24 0c 9f 6d 10 	movl   $0xc0106d9f,0xc(%esp)
c0104dad:	c0 
c0104dae:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104db5:	c0 
c0104db6:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104dbd:	00 
c0104dbe:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104dc5:	e8 1e bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dcd:	89 04 24             	mov    %eax,(%esp)
c0104dd0:	e8 d1 ef ff ff       	call   c0103da6 <page_ref>
c0104dd5:	85 c0                	test   %eax,%eax
c0104dd7:	74 24                	je     c0104dfd <check_pgdir+0x5a8>
c0104dd9:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c0104de0:	c0 
c0104de1:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104de8:	c0 
c0104de9:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104df0:	00 
c0104df1:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104df8:	e8 eb be ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104dfd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e02:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e09:	00 
c0104e0a:	89 04 24             	mov    %eax,(%esp)
c0104e0d:	e8 c1 f8 ff ff       	call   c01046d3 <page_remove>
    assert(page_ref(p1) == 0);
c0104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e15:	89 04 24             	mov    %eax,(%esp)
c0104e18:	e8 89 ef ff ff       	call   c0103da6 <page_ref>
c0104e1d:	85 c0                	test   %eax,%eax
c0104e1f:	74 24                	je     c0104e45 <check_pgdir+0x5f0>
c0104e21:	c7 44 24 0c ed 6e 10 	movl   $0xc0106eed,0xc(%esp)
c0104e28:	c0 
c0104e29:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104e30:	c0 
c0104e31:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104e38:	00 
c0104e39:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104e40:	e8 a3 be ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e48:	89 04 24             	mov    %eax,(%esp)
c0104e4b:	e8 56 ef ff ff       	call   c0103da6 <page_ref>
c0104e50:	85 c0                	test   %eax,%eax
c0104e52:	74 24                	je     c0104e78 <check_pgdir+0x623>
c0104e54:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c0104e5b:	c0 
c0104e5c:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104e63:	c0 
c0104e64:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104e6b:	00 
c0104e6c:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104e73:	e8 70 be ff ff       	call   c0100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104e78:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e7d:	8b 00                	mov    (%eax),%eax
c0104e7f:	89 04 24             	mov    %eax,(%esp)
c0104e82:	e8 05 ef ff ff       	call   c0103d8c <pde2page>
c0104e87:	89 04 24             	mov    %eax,(%esp)
c0104e8a:	e8 17 ef ff ff       	call   c0103da6 <page_ref>
c0104e8f:	83 f8 01             	cmp    $0x1,%eax
c0104e92:	74 24                	je     c0104eb8 <check_pgdir+0x663>
c0104e94:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104e9b:	c0 
c0104e9c:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104ea3:	c0 
c0104ea4:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104eab:	00 
c0104eac:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104eb3:	e8 30 be ff ff       	call   c0100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104eb8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ebd:	8b 00                	mov    (%eax),%eax
c0104ebf:	89 04 24             	mov    %eax,(%esp)
c0104ec2:	e8 c5 ee ff ff       	call   c0103d8c <pde2page>
c0104ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ece:	00 
c0104ecf:	89 04 24             	mov    %eax,(%esp)
c0104ed2:	e8 0b f1 ff ff       	call   c0103fe2 <free_pages>
    boot_pgdir[0] = 0;
c0104ed7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104edc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104ee2:	c7 04 24 27 6f 10 c0 	movl   $0xc0106f27,(%esp)
c0104ee9:	e8 68 b4 ff ff       	call   c0100356 <cprintf>
}
c0104eee:	90                   	nop
c0104eef:	89 ec                	mov    %ebp,%esp
c0104ef1:	5d                   	pop    %ebp
c0104ef2:	c3                   	ret    

c0104ef3 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104ef3:	55                   	push   %ebp
c0104ef4:	89 e5                	mov    %esp,%ebp
c0104ef6:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104f00:	e9 ca 00 00 00       	jmp    c0104fcf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f0e:	c1 e8 0c             	shr    $0xc,%eax
c0104f11:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f14:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104f19:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104f1c:	72 23                	jb     c0104f41 <check_boot_pgdir+0x4e>
c0104f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f21:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f25:	c7 44 24 08 54 6b 10 	movl   $0xc0106b54,0x8(%esp)
c0104f2c:	c0 
c0104f2d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104f34:	00 
c0104f35:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104f3c:	e8 a7 bd ff ff       	call   c0100ce8 <__panic>
c0104f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f44:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f49:	89 c2                	mov    %eax,%edx
c0104f4b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f57:	00 
c0104f58:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f5c:	89 04 24             	mov    %eax,(%esp)
c0104f5f:	e8 08 f7 ff ff       	call   c010466c <get_pte>
c0104f64:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104f6b:	75 24                	jne    c0104f91 <check_boot_pgdir+0x9e>
c0104f6d:	c7 44 24 0c 44 6f 10 	movl   $0xc0106f44,0xc(%esp)
c0104f74:	c0 
c0104f75:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104f7c:	c0 
c0104f7d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104f84:	00 
c0104f85:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104f8c:	e8 57 bd ff ff       	call   c0100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f94:	8b 00                	mov    (%eax),%eax
c0104f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f9b:	89 c2                	mov    %eax,%edx
c0104f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fa0:	39 c2                	cmp    %eax,%edx
c0104fa2:	74 24                	je     c0104fc8 <check_boot_pgdir+0xd5>
c0104fa4:	c7 44 24 0c 81 6f 10 	movl   $0xc0106f81,0xc(%esp)
c0104fab:	c0 
c0104fac:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0104fb3:	c0 
c0104fb4:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104fbb:	00 
c0104fbc:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0104fc3:	e8 20 bd ff ff       	call   c0100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104fc8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fd2:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104fd7:	39 c2                	cmp    %eax,%edx
c0104fd9:	0f 82 26 ff ff ff    	jb     c0104f05 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104fdf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fe4:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104fe9:	8b 00                	mov    (%eax),%eax
c0104feb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ff0:	89 c2                	mov    %eax,%edx
c0104ff2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ffa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105001:	77 23                	ja     c0105026 <check_boot_pgdir+0x133>
c0105003:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105006:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010500a:	c7 44 24 08 f8 6b 10 	movl   $0xc0106bf8,0x8(%esp)
c0105011:	c0 
c0105012:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0105019:	00 
c010501a:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0105021:	e8 c2 bc ff ff       	call   c0100ce8 <__panic>
c0105026:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105029:	05 00 00 00 40       	add    $0x40000000,%eax
c010502e:	39 d0                	cmp    %edx,%eax
c0105030:	74 24                	je     c0105056 <check_boot_pgdir+0x163>
c0105032:	c7 44 24 0c 98 6f 10 	movl   $0xc0106f98,0xc(%esp)
c0105039:	c0 
c010503a:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0105041:	c0 
c0105042:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0105049:	00 
c010504a:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0105051:	e8 92 bc ff ff       	call   c0100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
c0105056:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010505b:	8b 00                	mov    (%eax),%eax
c010505d:	85 c0                	test   %eax,%eax
c010505f:	74 24                	je     c0105085 <check_boot_pgdir+0x192>
c0105061:	c7 44 24 0c cc 6f 10 	movl   $0xc0106fcc,0xc(%esp)
c0105068:	c0 
c0105069:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0105070:	c0 
c0105071:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0105078:	00 
c0105079:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c0105080:	e8 63 bc ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
c0105085:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010508c:	e8 17 ef ff ff       	call   c0103fa8 <alloc_pages>
c0105091:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105094:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105099:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050a0:	00 
c01050a1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01050a8:	00 
c01050a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050ac:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050b0:	89 04 24             	mov    %eax,(%esp)
c01050b3:	e8 62 f6 ff ff       	call   c010471a <page_insert>
c01050b8:	85 c0                	test   %eax,%eax
c01050ba:	74 24                	je     c01050e0 <check_boot_pgdir+0x1ed>
c01050bc:	c7 44 24 0c e0 6f 10 	movl   $0xc0106fe0,0xc(%esp)
c01050c3:	c0 
c01050c4:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01050cb:	c0 
c01050cc:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c01050d3:	00 
c01050d4:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01050db:	e8 08 bc ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 1);
c01050e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050e3:	89 04 24             	mov    %eax,(%esp)
c01050e6:	e8 bb ec ff ff       	call   c0103da6 <page_ref>
c01050eb:	83 f8 01             	cmp    $0x1,%eax
c01050ee:	74 24                	je     c0105114 <check_boot_pgdir+0x221>
c01050f0:	c7 44 24 0c 0e 70 10 	movl   $0xc010700e,0xc(%esp)
c01050f7:	c0 
c01050f8:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01050ff:	c0 
c0105100:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105107:	00 
c0105108:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010510f:	e8 d4 bb ff ff       	call   c0100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105114:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105119:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105120:	00 
c0105121:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105128:	00 
c0105129:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010512c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105130:	89 04 24             	mov    %eax,(%esp)
c0105133:	e8 e2 f5 ff ff       	call   c010471a <page_insert>
c0105138:	85 c0                	test   %eax,%eax
c010513a:	74 24                	je     c0105160 <check_boot_pgdir+0x26d>
c010513c:	c7 44 24 0c 20 70 10 	movl   $0xc0107020,0xc(%esp)
c0105143:	c0 
c0105144:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c010514b:	c0 
c010514c:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105153:	00 
c0105154:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010515b:	e8 88 bb ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 2);
c0105160:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105163:	89 04 24             	mov    %eax,(%esp)
c0105166:	e8 3b ec ff ff       	call   c0103da6 <page_ref>
c010516b:	83 f8 02             	cmp    $0x2,%eax
c010516e:	74 24                	je     c0105194 <check_boot_pgdir+0x2a1>
c0105170:	c7 44 24 0c 57 70 10 	movl   $0xc0107057,0xc(%esp)
c0105177:	c0 
c0105178:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c010517f:	c0 
c0105180:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0105187:	00 
c0105188:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010518f:	e8 54 bb ff ff       	call   c0100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
c0105194:	c7 45 e8 68 70 10 c0 	movl   $0xc0107068,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010519b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010519e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051a9:	e8 fc 09 00 00       	call   c0105baa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01051ae:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01051b5:	00 
c01051b6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051bd:	e8 60 0a 00 00       	call   c0105c22 <strcmp>
c01051c2:	85 c0                	test   %eax,%eax
c01051c4:	74 24                	je     c01051ea <check_boot_pgdir+0x2f7>
c01051c6:	c7 44 24 0c 80 70 10 	movl   $0xc0107080,0xc(%esp)
c01051cd:	c0 
c01051ce:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c01051d5:	c0 
c01051d6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01051dd:	00 
c01051de:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c01051e5:	e8 fe ba ff ff       	call   c0100ce8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01051ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051ed:	89 04 24             	mov    %eax,(%esp)
c01051f0:	e8 01 eb ff ff       	call   c0103cf6 <page2kva>
c01051f5:	05 00 01 00 00       	add    $0x100,%eax
c01051fa:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01051fd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105204:	e8 47 09 00 00       	call   c0105b50 <strlen>
c0105209:	85 c0                	test   %eax,%eax
c010520b:	74 24                	je     c0105231 <check_boot_pgdir+0x33e>
c010520d:	c7 44 24 0c b8 70 10 	movl   $0xc01070b8,0xc(%esp)
c0105214:	c0 
c0105215:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c010521c:	c0 
c010521d:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0105224:	00 
c0105225:	c7 04 24 1c 6c 10 c0 	movl   $0xc0106c1c,(%esp)
c010522c:	e8 b7 ba ff ff       	call   c0100ce8 <__panic>

    free_page(p);
c0105231:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105238:	00 
c0105239:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010523c:	89 04 24             	mov    %eax,(%esp)
c010523f:	e8 9e ed ff ff       	call   c0103fe2 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105244:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105249:	8b 00                	mov    (%eax),%eax
c010524b:	89 04 24             	mov    %eax,(%esp)
c010524e:	e8 39 eb ff ff       	call   c0103d8c <pde2page>
c0105253:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010525a:	00 
c010525b:	89 04 24             	mov    %eax,(%esp)
c010525e:	e8 7f ed ff ff       	call   c0103fe2 <free_pages>
    boot_pgdir[0] = 0;
c0105263:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010526e:	c7 04 24 dc 70 10 c0 	movl   $0xc01070dc,(%esp)
c0105275:	e8 dc b0 ff ff       	call   c0100356 <cprintf>
}
c010527a:	90                   	nop
c010527b:	89 ec                	mov    %ebp,%esp
c010527d:	5d                   	pop    %ebp
c010527e:	c3                   	ret    

c010527f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010527f:	55                   	push   %ebp
c0105280:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105282:	8b 45 08             	mov    0x8(%ebp),%eax
c0105285:	83 e0 04             	and    $0x4,%eax
c0105288:	85 c0                	test   %eax,%eax
c010528a:	74 04                	je     c0105290 <perm2str+0x11>
c010528c:	b0 75                	mov    $0x75,%al
c010528e:	eb 02                	jmp    c0105292 <perm2str+0x13>
c0105290:	b0 2d                	mov    $0x2d,%al
c0105292:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c0105297:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010529e:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a1:	83 e0 02             	and    $0x2,%eax
c01052a4:	85 c0                	test   %eax,%eax
c01052a6:	74 04                	je     c01052ac <perm2str+0x2d>
c01052a8:	b0 77                	mov    $0x77,%al
c01052aa:	eb 02                	jmp    c01052ae <perm2str+0x2f>
c01052ac:	b0 2d                	mov    $0x2d,%al
c01052ae:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c01052b3:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c01052ba:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c01052bf:	5d                   	pop    %ebp
c01052c0:	c3                   	ret    

c01052c1 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01052c1:	55                   	push   %ebp
c01052c2:	89 e5                	mov    %esp,%ebp
c01052c4:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01052c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052cd:	72 0d                	jb     c01052dc <get_pgtable_items+0x1b>
        return 0;
c01052cf:	b8 00 00 00 00       	mov    $0x0,%eax
c01052d4:	e9 98 00 00 00       	jmp    c0105371 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01052d9:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01052dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01052df:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052e2:	73 18                	jae    c01052fc <get_pgtable_items+0x3b>
c01052e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01052e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01052f1:	01 d0                	add    %edx,%eax
c01052f3:	8b 00                	mov    (%eax),%eax
c01052f5:	83 e0 01             	and    $0x1,%eax
c01052f8:	85 c0                	test   %eax,%eax
c01052fa:	74 dd                	je     c01052d9 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01052fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105302:	73 68                	jae    c010536c <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105304:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105308:	74 08                	je     c0105312 <get_pgtable_items+0x51>
            *left_store = start;
c010530a:	8b 45 18             	mov    0x18(%ebp),%eax
c010530d:	8b 55 10             	mov    0x10(%ebp),%edx
c0105310:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105312:	8b 45 10             	mov    0x10(%ebp),%eax
c0105315:	8d 50 01             	lea    0x1(%eax),%edx
c0105318:	89 55 10             	mov    %edx,0x10(%ebp)
c010531b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105322:	8b 45 14             	mov    0x14(%ebp),%eax
c0105325:	01 d0                	add    %edx,%eax
c0105327:	8b 00                	mov    (%eax),%eax
c0105329:	83 e0 07             	and    $0x7,%eax
c010532c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010532f:	eb 03                	jmp    c0105334 <get_pgtable_items+0x73>
            start ++;
c0105331:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105334:	8b 45 10             	mov    0x10(%ebp),%eax
c0105337:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010533a:	73 1d                	jae    c0105359 <get_pgtable_items+0x98>
c010533c:	8b 45 10             	mov    0x10(%ebp),%eax
c010533f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105346:	8b 45 14             	mov    0x14(%ebp),%eax
c0105349:	01 d0                	add    %edx,%eax
c010534b:	8b 00                	mov    (%eax),%eax
c010534d:	83 e0 07             	and    $0x7,%eax
c0105350:	89 c2                	mov    %eax,%edx
c0105352:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105355:	39 c2                	cmp    %eax,%edx
c0105357:	74 d8                	je     c0105331 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105359:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010535d:	74 08                	je     c0105367 <get_pgtable_items+0xa6>
            *right_store = start;
c010535f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105362:	8b 55 10             	mov    0x10(%ebp),%edx
c0105365:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105367:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010536a:	eb 05                	jmp    c0105371 <get_pgtable_items+0xb0>
    }
    return 0;
c010536c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105371:	89 ec                	mov    %ebp,%esp
c0105373:	5d                   	pop    %ebp
c0105374:	c3                   	ret    

c0105375 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105375:	55                   	push   %ebp
c0105376:	89 e5                	mov    %esp,%ebp
c0105378:	57                   	push   %edi
c0105379:	56                   	push   %esi
c010537a:	53                   	push   %ebx
c010537b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010537e:	c7 04 24 fc 70 10 c0 	movl   $0xc01070fc,(%esp)
c0105385:	e8 cc af ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c010538a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105391:	e9 f2 00 00 00       	jmp    c0105488 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105399:	89 04 24             	mov    %eax,(%esp)
c010539c:	e8 de fe ff ff       	call   c010527f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01053a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053a7:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01053a9:	89 d6                	mov    %edx,%esi
c01053ab:	c1 e6 16             	shl    $0x16,%esi
c01053ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053b1:	89 d3                	mov    %edx,%ebx
c01053b3:	c1 e3 16             	shl    $0x16,%ebx
c01053b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053b9:	89 d1                	mov    %edx,%ecx
c01053bb:	c1 e1 16             	shl    $0x16,%ecx
c01053be:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053c1:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01053c4:	29 fa                	sub    %edi,%edx
c01053c6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053ca:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053da:	c7 04 24 2d 71 10 c0 	movl   $0xc010712d,(%esp)
c01053e1:	e8 70 af ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01053e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053e9:	c1 e0 0a             	shl    $0xa,%eax
c01053ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053ef:	eb 50                	jmp    c0105441 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053f4:	89 04 24             	mov    %eax,(%esp)
c01053f7:	e8 83 fe ff ff       	call   c010527f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105402:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105404:	89 d6                	mov    %edx,%esi
c0105406:	c1 e6 0c             	shl    $0xc,%esi
c0105409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010540c:	89 d3                	mov    %edx,%ebx
c010540e:	c1 e3 0c             	shl    $0xc,%ebx
c0105411:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105414:	89 d1                	mov    %edx,%ecx
c0105416:	c1 e1 0c             	shl    $0xc,%ecx
c0105419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010541c:	8b 7d d8             	mov    -0x28(%ebp),%edi
c010541f:	29 fa                	sub    %edi,%edx
c0105421:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105425:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105429:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010542d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105431:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105435:	c7 04 24 4c 71 10 c0 	movl   $0xc010714c,(%esp)
c010543c:	e8 15 af ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105441:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105449:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010544c:	89 d3                	mov    %edx,%ebx
c010544e:	c1 e3 0a             	shl    $0xa,%ebx
c0105451:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105454:	89 d1                	mov    %edx,%ecx
c0105456:	c1 e1 0a             	shl    $0xa,%ecx
c0105459:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010545c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105460:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105463:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105467:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010546b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010546f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105473:	89 0c 24             	mov    %ecx,(%esp)
c0105476:	e8 46 fe ff ff       	call   c01052c1 <get_pgtable_items>
c010547b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010547e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105482:	0f 85 69 ff ff ff    	jne    c01053f1 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105488:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010548d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105490:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105493:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105497:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010549a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010549e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01054ad:	00 
c01054ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01054b5:	e8 07 fe ff ff       	call   c01052c1 <get_pgtable_items>
c01054ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054c1:	0f 85 cf fe ff ff    	jne    c0105396 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01054c7:	c7 04 24 70 71 10 c0 	movl   $0xc0107170,(%esp)
c01054ce:	e8 83 ae ff ff       	call   c0100356 <cprintf>
}
c01054d3:	90                   	nop
c01054d4:	83 c4 4c             	add    $0x4c,%esp
c01054d7:	5b                   	pop    %ebx
c01054d8:	5e                   	pop    %esi
c01054d9:	5f                   	pop    %edi
c01054da:	5d                   	pop    %ebp
c01054db:	c3                   	ret    

c01054dc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01054dc:	55                   	push   %ebp
c01054dd:	89 e5                	mov    %esp,%ebp
c01054df:	83 ec 58             	sub    $0x58,%esp
c01054e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01054e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054e8:	8b 45 14             	mov    0x14(%ebp),%eax
c01054eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054f7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01054fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105500:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105503:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105506:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105509:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010550c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010550f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105516:	74 1c                	je     c0105534 <printnum+0x58>
c0105518:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010551b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105520:	f7 75 e4             	divl   -0x1c(%ebp)
c0105523:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105526:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105529:	ba 00 00 00 00       	mov    $0x0,%edx
c010552e:	f7 75 e4             	divl   -0x1c(%ebp)
c0105531:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105534:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105537:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010553a:	f7 75 e4             	divl   -0x1c(%ebp)
c010553d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105540:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105543:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105546:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105549:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010554c:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010554f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105552:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105555:	8b 45 18             	mov    0x18(%ebp),%eax
c0105558:	ba 00 00 00 00       	mov    $0x0,%edx
c010555d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105560:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105563:	19 d1                	sbb    %edx,%ecx
c0105565:	72 4c                	jb     c01055b3 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105567:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010556a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010556d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105570:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105574:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105578:	8b 45 18             	mov    0x18(%ebp),%eax
c010557b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010557f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105582:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105585:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105589:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010558d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105590:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105594:	8b 45 08             	mov    0x8(%ebp),%eax
c0105597:	89 04 24             	mov    %eax,(%esp)
c010559a:	e8 3d ff ff ff       	call   c01054dc <printnum>
c010559f:	eb 1b                	jmp    c01055bc <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01055a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055a8:	8b 45 20             	mov    0x20(%ebp),%eax
c01055ab:	89 04 24             	mov    %eax,(%esp)
c01055ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b1:	ff d0                	call   *%eax
        while (-- width > 0)
c01055b3:	ff 4d 1c             	decl   0x1c(%ebp)
c01055b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055ba:	7f e5                	jg     c01055a1 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01055bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01055bf:	05 24 72 10 c0       	add    $0xc0107224,%eax
c01055c4:	0f b6 00             	movzbl (%eax),%eax
c01055c7:	0f be c0             	movsbl %al,%eax
c01055ca:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055cd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055d1:	89 04 24             	mov    %eax,(%esp)
c01055d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d7:	ff d0                	call   *%eax
}
c01055d9:	90                   	nop
c01055da:	89 ec                	mov    %ebp,%esp
c01055dc:	5d                   	pop    %ebp
c01055dd:	c3                   	ret    

c01055de <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01055de:	55                   	push   %ebp
c01055df:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055e5:	7e 14                	jle    c01055fb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ea:	8b 00                	mov    (%eax),%eax
c01055ec:	8d 48 08             	lea    0x8(%eax),%ecx
c01055ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01055f2:	89 0a                	mov    %ecx,(%edx)
c01055f4:	8b 50 04             	mov    0x4(%eax),%edx
c01055f7:	8b 00                	mov    (%eax),%eax
c01055f9:	eb 30                	jmp    c010562b <getuint+0x4d>
    }
    else if (lflag) {
c01055fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055ff:	74 16                	je     c0105617 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105601:	8b 45 08             	mov    0x8(%ebp),%eax
c0105604:	8b 00                	mov    (%eax),%eax
c0105606:	8d 48 04             	lea    0x4(%eax),%ecx
c0105609:	8b 55 08             	mov    0x8(%ebp),%edx
c010560c:	89 0a                	mov    %ecx,(%edx)
c010560e:	8b 00                	mov    (%eax),%eax
c0105610:	ba 00 00 00 00       	mov    $0x0,%edx
c0105615:	eb 14                	jmp    c010562b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105617:	8b 45 08             	mov    0x8(%ebp),%eax
c010561a:	8b 00                	mov    (%eax),%eax
c010561c:	8d 48 04             	lea    0x4(%eax),%ecx
c010561f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105622:	89 0a                	mov    %ecx,(%edx)
c0105624:	8b 00                	mov    (%eax),%eax
c0105626:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010562b:	5d                   	pop    %ebp
c010562c:	c3                   	ret    

c010562d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010562d:	55                   	push   %ebp
c010562e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105630:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105634:	7e 14                	jle    c010564a <getint+0x1d>
        return va_arg(*ap, long long);
c0105636:	8b 45 08             	mov    0x8(%ebp),%eax
c0105639:	8b 00                	mov    (%eax),%eax
c010563b:	8d 48 08             	lea    0x8(%eax),%ecx
c010563e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105641:	89 0a                	mov    %ecx,(%edx)
c0105643:	8b 50 04             	mov    0x4(%eax),%edx
c0105646:	8b 00                	mov    (%eax),%eax
c0105648:	eb 28                	jmp    c0105672 <getint+0x45>
    }
    else if (lflag) {
c010564a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010564e:	74 12                	je     c0105662 <getint+0x35>
        return va_arg(*ap, long);
c0105650:	8b 45 08             	mov    0x8(%ebp),%eax
c0105653:	8b 00                	mov    (%eax),%eax
c0105655:	8d 48 04             	lea    0x4(%eax),%ecx
c0105658:	8b 55 08             	mov    0x8(%ebp),%edx
c010565b:	89 0a                	mov    %ecx,(%edx)
c010565d:	8b 00                	mov    (%eax),%eax
c010565f:	99                   	cltd   
c0105660:	eb 10                	jmp    c0105672 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105662:	8b 45 08             	mov    0x8(%ebp),%eax
c0105665:	8b 00                	mov    (%eax),%eax
c0105667:	8d 48 04             	lea    0x4(%eax),%ecx
c010566a:	8b 55 08             	mov    0x8(%ebp),%edx
c010566d:	89 0a                	mov    %ecx,(%edx)
c010566f:	8b 00                	mov    (%eax),%eax
c0105671:	99                   	cltd   
    }
}
c0105672:	5d                   	pop    %ebp
c0105673:	c3                   	ret    

c0105674 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105674:	55                   	push   %ebp
c0105675:	89 e5                	mov    %esp,%ebp
c0105677:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010567a:	8d 45 14             	lea    0x14(%ebp),%eax
c010567d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105683:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105687:	8b 45 10             	mov    0x10(%ebp),%eax
c010568a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010568e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105691:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105695:	8b 45 08             	mov    0x8(%ebp),%eax
c0105698:	89 04 24             	mov    %eax,(%esp)
c010569b:	e8 05 00 00 00       	call   c01056a5 <vprintfmt>
    va_end(ap);
}
c01056a0:	90                   	nop
c01056a1:	89 ec                	mov    %ebp,%esp
c01056a3:	5d                   	pop    %ebp
c01056a4:	c3                   	ret    

c01056a5 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01056a5:	55                   	push   %ebp
c01056a6:	89 e5                	mov    %esp,%ebp
c01056a8:	56                   	push   %esi
c01056a9:	53                   	push   %ebx
c01056aa:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056ad:	eb 17                	jmp    c01056c6 <vprintfmt+0x21>
            if (ch == '\0') {
c01056af:	85 db                	test   %ebx,%ebx
c01056b1:	0f 84 bf 03 00 00    	je     c0105a76 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056be:	89 1c 24             	mov    %ebx,(%esp)
c01056c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c4:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c9:	8d 50 01             	lea    0x1(%eax),%edx
c01056cc:	89 55 10             	mov    %edx,0x10(%ebp)
c01056cf:	0f b6 00             	movzbl (%eax),%eax
c01056d2:	0f b6 d8             	movzbl %al,%ebx
c01056d5:	83 fb 25             	cmp    $0x25,%ebx
c01056d8:	75 d5                	jne    c01056af <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01056da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01056de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01056fb:	8d 50 01             	lea    0x1(%eax),%edx
c01056fe:	89 55 10             	mov    %edx,0x10(%ebp)
c0105701:	0f b6 00             	movzbl (%eax),%eax
c0105704:	0f b6 d8             	movzbl %al,%ebx
c0105707:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010570a:	83 f8 55             	cmp    $0x55,%eax
c010570d:	0f 87 37 03 00 00    	ja     c0105a4a <vprintfmt+0x3a5>
c0105713:	8b 04 85 48 72 10 c0 	mov    -0x3fef8db8(,%eax,4),%eax
c010571a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010571c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105720:	eb d6                	jmp    c01056f8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105722:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105726:	eb d0                	jmp    c01056f8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010572f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105732:	89 d0                	mov    %edx,%eax
c0105734:	c1 e0 02             	shl    $0x2,%eax
c0105737:	01 d0                	add    %edx,%eax
c0105739:	01 c0                	add    %eax,%eax
c010573b:	01 d8                	add    %ebx,%eax
c010573d:	83 e8 30             	sub    $0x30,%eax
c0105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105743:	8b 45 10             	mov    0x10(%ebp),%eax
c0105746:	0f b6 00             	movzbl (%eax),%eax
c0105749:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010574c:	83 fb 2f             	cmp    $0x2f,%ebx
c010574f:	7e 38                	jle    c0105789 <vprintfmt+0xe4>
c0105751:	83 fb 39             	cmp    $0x39,%ebx
c0105754:	7f 33                	jg     c0105789 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105756:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105759:	eb d4                	jmp    c010572f <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010575b:	8b 45 14             	mov    0x14(%ebp),%eax
c010575e:	8d 50 04             	lea    0x4(%eax),%edx
c0105761:	89 55 14             	mov    %edx,0x14(%ebp)
c0105764:	8b 00                	mov    (%eax),%eax
c0105766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105769:	eb 1f                	jmp    c010578a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010576b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010576f:	79 87                	jns    c01056f8 <vprintfmt+0x53>
                width = 0;
c0105771:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105778:	e9 7b ff ff ff       	jmp    c01056f8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010577d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105784:	e9 6f ff ff ff       	jmp    c01056f8 <vprintfmt+0x53>
            goto process_precision;
c0105789:	90                   	nop

        process_precision:
            if (width < 0)
c010578a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010578e:	0f 89 64 ff ff ff    	jns    c01056f8 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105797:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010579a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01057a1:	e9 52 ff ff ff       	jmp    c01056f8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01057a6:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01057a9:	e9 4a ff ff ff       	jmp    c01056f8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01057ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b1:	8d 50 04             	lea    0x4(%eax),%edx
c01057b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01057b7:	8b 00                	mov    (%eax),%eax
c01057b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057c0:	89 04 24             	mov    %eax,(%esp)
c01057c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c6:	ff d0                	call   *%eax
            break;
c01057c8:	e9 a4 02 00 00       	jmp    c0105a71 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01057cd:	8b 45 14             	mov    0x14(%ebp),%eax
c01057d0:	8d 50 04             	lea    0x4(%eax),%edx
c01057d3:	89 55 14             	mov    %edx,0x14(%ebp)
c01057d6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01057d8:	85 db                	test   %ebx,%ebx
c01057da:	79 02                	jns    c01057de <vprintfmt+0x139>
                err = -err;
c01057dc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01057de:	83 fb 06             	cmp    $0x6,%ebx
c01057e1:	7f 0b                	jg     c01057ee <vprintfmt+0x149>
c01057e3:	8b 34 9d 08 72 10 c0 	mov    -0x3fef8df8(,%ebx,4),%esi
c01057ea:	85 f6                	test   %esi,%esi
c01057ec:	75 23                	jne    c0105811 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01057ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057f2:	c7 44 24 08 35 72 10 	movl   $0xc0107235,0x8(%esp)
c01057f9:	c0 
c01057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105801:	8b 45 08             	mov    0x8(%ebp),%eax
c0105804:	89 04 24             	mov    %eax,(%esp)
c0105807:	e8 68 fe ff ff       	call   c0105674 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010580c:	e9 60 02 00 00       	jmp    c0105a71 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105811:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105815:	c7 44 24 08 3e 72 10 	movl   $0xc010723e,0x8(%esp)
c010581c:	c0 
c010581d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105820:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105824:	8b 45 08             	mov    0x8(%ebp),%eax
c0105827:	89 04 24             	mov    %eax,(%esp)
c010582a:	e8 45 fe ff ff       	call   c0105674 <printfmt>
            break;
c010582f:	e9 3d 02 00 00       	jmp    c0105a71 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105834:	8b 45 14             	mov    0x14(%ebp),%eax
c0105837:	8d 50 04             	lea    0x4(%eax),%edx
c010583a:	89 55 14             	mov    %edx,0x14(%ebp)
c010583d:	8b 30                	mov    (%eax),%esi
c010583f:	85 f6                	test   %esi,%esi
c0105841:	75 05                	jne    c0105848 <vprintfmt+0x1a3>
                p = "(null)";
c0105843:	be 41 72 10 c0       	mov    $0xc0107241,%esi
            }
            if (width > 0 && padc != '-') {
c0105848:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010584c:	7e 76                	jle    c01058c4 <vprintfmt+0x21f>
c010584e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105852:	74 70                	je     c01058c4 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105857:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585b:	89 34 24             	mov    %esi,(%esp)
c010585e:	e8 16 03 00 00       	call   c0105b79 <strnlen>
c0105863:	89 c2                	mov    %eax,%edx
c0105865:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105868:	29 d0                	sub    %edx,%eax
c010586a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010586d:	eb 16                	jmp    c0105885 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010586f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105873:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105876:	89 54 24 04          	mov    %edx,0x4(%esp)
c010587a:	89 04 24             	mov    %eax,(%esp)
c010587d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105880:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105882:	ff 4d e8             	decl   -0x18(%ebp)
c0105885:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105889:	7f e4                	jg     c010586f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010588b:	eb 37                	jmp    c01058c4 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010588d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105891:	74 1f                	je     c01058b2 <vprintfmt+0x20d>
c0105893:	83 fb 1f             	cmp    $0x1f,%ebx
c0105896:	7e 05                	jle    c010589d <vprintfmt+0x1f8>
c0105898:	83 fb 7e             	cmp    $0x7e,%ebx
c010589b:	7e 15                	jle    c01058b2 <vprintfmt+0x20d>
                    putch('?', putdat);
c010589d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01058ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ae:	ff d0                	call   *%eax
c01058b0:	eb 0f                	jmp    c01058c1 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01058b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b9:	89 1c 24             	mov    %ebx,(%esp)
c01058bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bf:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058c1:	ff 4d e8             	decl   -0x18(%ebp)
c01058c4:	89 f0                	mov    %esi,%eax
c01058c6:	8d 70 01             	lea    0x1(%eax),%esi
c01058c9:	0f b6 00             	movzbl (%eax),%eax
c01058cc:	0f be d8             	movsbl %al,%ebx
c01058cf:	85 db                	test   %ebx,%ebx
c01058d1:	74 27                	je     c01058fa <vprintfmt+0x255>
c01058d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058d7:	78 b4                	js     c010588d <vprintfmt+0x1e8>
c01058d9:	ff 4d e4             	decl   -0x1c(%ebp)
c01058dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058e0:	79 ab                	jns    c010588d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01058e2:	eb 16                	jmp    c01058fa <vprintfmt+0x255>
                putch(' ', putdat);
c01058e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01058f7:	ff 4d e8             	decl   -0x18(%ebp)
c01058fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058fe:	7f e4                	jg     c01058e4 <vprintfmt+0x23f>
            }
            break;
c0105900:	e9 6c 01 00 00       	jmp    c0105a71 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105905:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105908:	89 44 24 04          	mov    %eax,0x4(%esp)
c010590c:	8d 45 14             	lea    0x14(%ebp),%eax
c010590f:	89 04 24             	mov    %eax,(%esp)
c0105912:	e8 16 fd ff ff       	call   c010562d <getint>
c0105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010591a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010591d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105920:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105923:	85 d2                	test   %edx,%edx
c0105925:	79 26                	jns    c010594d <vprintfmt+0x2a8>
                putch('-', putdat);
c0105927:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105935:	8b 45 08             	mov    0x8(%ebp),%eax
c0105938:	ff d0                	call   *%eax
                num = -(long long)num;
c010593a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010593d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105940:	f7 d8                	neg    %eax
c0105942:	83 d2 00             	adc    $0x0,%edx
c0105945:	f7 da                	neg    %edx
c0105947:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010594a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010594d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105954:	e9 a8 00 00 00       	jmp    c0105a01 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105959:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010595c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105960:	8d 45 14             	lea    0x14(%ebp),%eax
c0105963:	89 04 24             	mov    %eax,(%esp)
c0105966:	e8 73 fc ff ff       	call   c01055de <getuint>
c010596b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105971:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105978:	e9 84 00 00 00       	jmp    c0105a01 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010597d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105980:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105984:	8d 45 14             	lea    0x14(%ebp),%eax
c0105987:	89 04 24             	mov    %eax,(%esp)
c010598a:	e8 4f fc ff ff       	call   c01055de <getuint>
c010598f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105992:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105995:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010599c:	eb 63                	jmp    c0105a01 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010599e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01059ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01059af:	ff d0                	call   *%eax
            putch('x', putdat);
c01059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01059bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c2:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01059c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01059c7:	8d 50 04             	lea    0x4(%eax),%edx
c01059ca:	89 55 14             	mov    %edx,0x14(%ebp)
c01059cd:	8b 00                	mov    (%eax),%eax
c01059cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01059d9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059e0:	eb 1f                	jmp    c0105a01 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e9:	8d 45 14             	lea    0x14(%ebp),%eax
c01059ec:	89 04 24             	mov    %eax,(%esp)
c01059ef:	e8 ea fb ff ff       	call   c01055de <getuint>
c01059f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01059fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a01:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a08:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105a0f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a13:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a21:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2f:	89 04 24             	mov    %eax,(%esp)
c0105a32:	e8 a5 fa ff ff       	call   c01054dc <printnum>
            break;
c0105a37:	eb 38                	jmp    c0105a71 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a40:	89 1c 24             	mov    %ebx,(%esp)
c0105a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a46:	ff d0                	call   *%eax
            break;
c0105a48:	eb 27                	jmp    c0105a71 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a51:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a5d:	ff 4d 10             	decl   0x10(%ebp)
c0105a60:	eb 03                	jmp    c0105a65 <vprintfmt+0x3c0>
c0105a62:	ff 4d 10             	decl   0x10(%ebp)
c0105a65:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a68:	48                   	dec    %eax
c0105a69:	0f b6 00             	movzbl (%eax),%eax
c0105a6c:	3c 25                	cmp    $0x25,%al
c0105a6e:	75 f2                	jne    c0105a62 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105a70:	90                   	nop
    while (1) {
c0105a71:	e9 37 fc ff ff       	jmp    c01056ad <vprintfmt+0x8>
                return;
c0105a76:	90                   	nop
        }
    }
}
c0105a77:	83 c4 40             	add    $0x40,%esp
c0105a7a:	5b                   	pop    %ebx
c0105a7b:	5e                   	pop    %esi
c0105a7c:	5d                   	pop    %ebp
c0105a7d:	c3                   	ret    

c0105a7e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a7e:	55                   	push   %ebp
c0105a7f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a84:	8b 40 08             	mov    0x8(%eax),%eax
c0105a87:	8d 50 01             	lea    0x1(%eax),%edx
c0105a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a93:	8b 10                	mov    (%eax),%edx
c0105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a98:	8b 40 04             	mov    0x4(%eax),%eax
c0105a9b:	39 c2                	cmp    %eax,%edx
c0105a9d:	73 12                	jae    c0105ab1 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa2:	8b 00                	mov    (%eax),%eax
c0105aa4:	8d 48 01             	lea    0x1(%eax),%ecx
c0105aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105aaa:	89 0a                	mov    %ecx,(%edx)
c0105aac:	8b 55 08             	mov    0x8(%ebp),%edx
c0105aaf:	88 10                	mov    %dl,(%eax)
    }
}
c0105ab1:	90                   	nop
c0105ab2:	5d                   	pop    %ebp
c0105ab3:	c3                   	ret    

c0105ab4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105ab4:	55                   	push   %ebp
c0105ab5:	89 e5                	mov    %esp,%ebp
c0105ab7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105aba:	8d 45 14             	lea    0x14(%ebp),%eax
c0105abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aca:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ace:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad8:	89 04 24             	mov    %eax,(%esp)
c0105adb:	e8 0a 00 00 00       	call   c0105aea <vsnprintf>
c0105ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ae6:	89 ec                	mov    %ebp,%esp
c0105ae8:	5d                   	pop    %ebp
c0105ae9:	c3                   	ret    

c0105aea <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105aea:	55                   	push   %ebp
c0105aeb:	89 e5                	mov    %esp,%ebp
c0105aed:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aff:	01 d0                	add    %edx,%eax
c0105b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b0f:	74 0a                	je     c0105b1b <vsnprintf+0x31>
c0105b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b17:	39 c2                	cmp    %eax,%edx
c0105b19:	76 07                	jbe    c0105b22 <vsnprintf+0x38>
        return -E_INVAL;
c0105b1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b20:	eb 2a                	jmp    c0105b4c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b22:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b25:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b29:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b30:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b37:	c7 04 24 7e 5a 10 c0 	movl   $0xc0105a7e,(%esp)
c0105b3e:	e8 62 fb ff ff       	call   c01056a5 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b46:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b4c:	89 ec                	mov    %ebp,%esp
c0105b4e:	5d                   	pop    %ebp
c0105b4f:	c3                   	ret    

c0105b50 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b50:	55                   	push   %ebp
c0105b51:	89 e5                	mov    %esp,%ebp
c0105b53:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b5d:	eb 03                	jmp    c0105b62 <strlen+0x12>
        cnt ++;
c0105b5f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b65:	8d 50 01             	lea    0x1(%eax),%edx
c0105b68:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b6b:	0f b6 00             	movzbl (%eax),%eax
c0105b6e:	84 c0                	test   %al,%al
c0105b70:	75 ed                	jne    c0105b5f <strlen+0xf>
    }
    return cnt;
c0105b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b75:	89 ec                	mov    %ebp,%esp
c0105b77:	5d                   	pop    %ebp
c0105b78:	c3                   	ret    

c0105b79 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b79:	55                   	push   %ebp
c0105b7a:	89 e5                	mov    %esp,%ebp
c0105b7c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b86:	eb 03                	jmp    c0105b8b <strnlen+0x12>
        cnt ++;
c0105b88:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b91:	73 10                	jae    c0105ba3 <strnlen+0x2a>
c0105b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b96:	8d 50 01             	lea    0x1(%eax),%edx
c0105b99:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b9c:	0f b6 00             	movzbl (%eax),%eax
c0105b9f:	84 c0                	test   %al,%al
c0105ba1:	75 e5                	jne    c0105b88 <strnlen+0xf>
    }
    return cnt;
c0105ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ba6:	89 ec                	mov    %ebp,%esp
c0105ba8:	5d                   	pop    %ebp
c0105ba9:	c3                   	ret    

c0105baa <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105baa:	55                   	push   %ebp
c0105bab:	89 e5                	mov    %esp,%ebp
c0105bad:	57                   	push   %edi
c0105bae:	56                   	push   %esi
c0105baf:	83 ec 20             	sub    $0x20,%esp
c0105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc4:	89 d1                	mov    %edx,%ecx
c0105bc6:	89 c2                	mov    %eax,%edx
c0105bc8:	89 ce                	mov    %ecx,%esi
c0105bca:	89 d7                	mov    %edx,%edi
c0105bcc:	ac                   	lods   %ds:(%esi),%al
c0105bcd:	aa                   	stos   %al,%es:(%edi)
c0105bce:	84 c0                	test   %al,%al
c0105bd0:	75 fa                	jne    c0105bcc <strcpy+0x22>
c0105bd2:	89 fa                	mov    %edi,%edx
c0105bd4:	89 f1                	mov    %esi,%ecx
c0105bd6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105bd9:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105be2:	83 c4 20             	add    $0x20,%esp
c0105be5:	5e                   	pop    %esi
c0105be6:	5f                   	pop    %edi
c0105be7:	5d                   	pop    %ebp
c0105be8:	c3                   	ret    

c0105be9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105be9:	55                   	push   %ebp
c0105bea:	89 e5                	mov    %esp,%ebp
c0105bec:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bf5:	eb 1e                	jmp    c0105c15 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfa:	0f b6 10             	movzbl (%eax),%edx
c0105bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c00:	88 10                	mov    %dl,(%eax)
c0105c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c05:	0f b6 00             	movzbl (%eax),%eax
c0105c08:	84 c0                	test   %al,%al
c0105c0a:	74 03                	je     c0105c0f <strncpy+0x26>
            src ++;
c0105c0c:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105c0f:	ff 45 fc             	incl   -0x4(%ebp)
c0105c12:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105c15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c19:	75 dc                	jne    c0105bf7 <strncpy+0xe>
    }
    return dst;
c0105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c1e:	89 ec                	mov    %ebp,%esp
c0105c20:	5d                   	pop    %ebp
c0105c21:	c3                   	ret    

c0105c22 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105c22:	55                   	push   %ebp
c0105c23:	89 e5                	mov    %esp,%ebp
c0105c25:	57                   	push   %edi
c0105c26:	56                   	push   %esi
c0105c27:	83 ec 20             	sub    $0x20,%esp
c0105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c3c:	89 d1                	mov    %edx,%ecx
c0105c3e:	89 c2                	mov    %eax,%edx
c0105c40:	89 ce                	mov    %ecx,%esi
c0105c42:	89 d7                	mov    %edx,%edi
c0105c44:	ac                   	lods   %ds:(%esi),%al
c0105c45:	ae                   	scas   %es:(%edi),%al
c0105c46:	75 08                	jne    c0105c50 <strcmp+0x2e>
c0105c48:	84 c0                	test   %al,%al
c0105c4a:	75 f8                	jne    c0105c44 <strcmp+0x22>
c0105c4c:	31 c0                	xor    %eax,%eax
c0105c4e:	eb 04                	jmp    c0105c54 <strcmp+0x32>
c0105c50:	19 c0                	sbb    %eax,%eax
c0105c52:	0c 01                	or     $0x1,%al
c0105c54:	89 fa                	mov    %edi,%edx
c0105c56:	89 f1                	mov    %esi,%ecx
c0105c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c5b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c64:	83 c4 20             	add    $0x20,%esp
c0105c67:	5e                   	pop    %esi
c0105c68:	5f                   	pop    %edi
c0105c69:	5d                   	pop    %ebp
c0105c6a:	c3                   	ret    

c0105c6b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c6b:	55                   	push   %ebp
c0105c6c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c6e:	eb 09                	jmp    c0105c79 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105c70:	ff 4d 10             	decl   0x10(%ebp)
c0105c73:	ff 45 08             	incl   0x8(%ebp)
c0105c76:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c7d:	74 1a                	je     c0105c99 <strncmp+0x2e>
c0105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c82:	0f b6 00             	movzbl (%eax),%eax
c0105c85:	84 c0                	test   %al,%al
c0105c87:	74 10                	je     c0105c99 <strncmp+0x2e>
c0105c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8c:	0f b6 10             	movzbl (%eax),%edx
c0105c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c92:	0f b6 00             	movzbl (%eax),%eax
c0105c95:	38 c2                	cmp    %al,%dl
c0105c97:	74 d7                	je     c0105c70 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c9d:	74 18                	je     c0105cb7 <strncmp+0x4c>
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	0f b6 00             	movzbl (%eax),%eax
c0105ca5:	0f b6 d0             	movzbl %al,%edx
c0105ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cab:	0f b6 00             	movzbl (%eax),%eax
c0105cae:	0f b6 c8             	movzbl %al,%ecx
c0105cb1:	89 d0                	mov    %edx,%eax
c0105cb3:	29 c8                	sub    %ecx,%eax
c0105cb5:	eb 05                	jmp    c0105cbc <strncmp+0x51>
c0105cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cbc:	5d                   	pop    %ebp
c0105cbd:	c3                   	ret    

c0105cbe <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105cbe:	55                   	push   %ebp
c0105cbf:	89 e5                	mov    %esp,%ebp
c0105cc1:	83 ec 04             	sub    $0x4,%esp
c0105cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105cca:	eb 13                	jmp    c0105cdf <strchr+0x21>
        if (*s == c) {
c0105ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccf:	0f b6 00             	movzbl (%eax),%eax
c0105cd2:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105cd5:	75 05                	jne    c0105cdc <strchr+0x1e>
            return (char *)s;
c0105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cda:	eb 12                	jmp    c0105cee <strchr+0x30>
        }
        s ++;
c0105cdc:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce2:	0f b6 00             	movzbl (%eax),%eax
c0105ce5:	84 c0                	test   %al,%al
c0105ce7:	75 e3                	jne    c0105ccc <strchr+0xe>
    }
    return NULL;
c0105ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cee:	89 ec                	mov    %ebp,%esp
c0105cf0:	5d                   	pop    %ebp
c0105cf1:	c3                   	ret    

c0105cf2 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105cf2:	55                   	push   %ebp
c0105cf3:	89 e5                	mov    %esp,%ebp
c0105cf5:	83 ec 04             	sub    $0x4,%esp
c0105cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105cfe:	eb 0e                	jmp    c0105d0e <strfind+0x1c>
        if (*s == c) {
c0105d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d03:	0f b6 00             	movzbl (%eax),%eax
c0105d06:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105d09:	74 0f                	je     c0105d1a <strfind+0x28>
            break;
        }
        s ++;
c0105d0b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d11:	0f b6 00             	movzbl (%eax),%eax
c0105d14:	84 c0                	test   %al,%al
c0105d16:	75 e8                	jne    c0105d00 <strfind+0xe>
c0105d18:	eb 01                	jmp    c0105d1b <strfind+0x29>
            break;
c0105d1a:	90                   	nop
    }
    return (char *)s;
c0105d1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d1e:	89 ec                	mov    %ebp,%esp
c0105d20:	5d                   	pop    %ebp
c0105d21:	c3                   	ret    

c0105d22 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105d22:	55                   	push   %ebp
c0105d23:	89 e5                	mov    %esp,%ebp
c0105d25:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105d2f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d36:	eb 03                	jmp    c0105d3b <strtol+0x19>
        s ++;
c0105d38:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3e:	0f b6 00             	movzbl (%eax),%eax
c0105d41:	3c 20                	cmp    $0x20,%al
c0105d43:	74 f3                	je     c0105d38 <strtol+0x16>
c0105d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d48:	0f b6 00             	movzbl (%eax),%eax
c0105d4b:	3c 09                	cmp    $0x9,%al
c0105d4d:	74 e9                	je     c0105d38 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d52:	0f b6 00             	movzbl (%eax),%eax
c0105d55:	3c 2b                	cmp    $0x2b,%al
c0105d57:	75 05                	jne    c0105d5e <strtol+0x3c>
        s ++;
c0105d59:	ff 45 08             	incl   0x8(%ebp)
c0105d5c:	eb 14                	jmp    c0105d72 <strtol+0x50>
    }
    else if (*s == '-') {
c0105d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d61:	0f b6 00             	movzbl (%eax),%eax
c0105d64:	3c 2d                	cmp    $0x2d,%al
c0105d66:	75 0a                	jne    c0105d72 <strtol+0x50>
        s ++, neg = 1;
c0105d68:	ff 45 08             	incl   0x8(%ebp)
c0105d6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d76:	74 06                	je     c0105d7e <strtol+0x5c>
c0105d78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d7c:	75 22                	jne    c0105da0 <strtol+0x7e>
c0105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d81:	0f b6 00             	movzbl (%eax),%eax
c0105d84:	3c 30                	cmp    $0x30,%al
c0105d86:	75 18                	jne    c0105da0 <strtol+0x7e>
c0105d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8b:	40                   	inc    %eax
c0105d8c:	0f b6 00             	movzbl (%eax),%eax
c0105d8f:	3c 78                	cmp    $0x78,%al
c0105d91:	75 0d                	jne    c0105da0 <strtol+0x7e>
        s += 2, base = 16;
c0105d93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d9e:	eb 29                	jmp    c0105dc9 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105da4:	75 16                	jne    c0105dbc <strtol+0x9a>
c0105da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da9:	0f b6 00             	movzbl (%eax),%eax
c0105dac:	3c 30                	cmp    $0x30,%al
c0105dae:	75 0c                	jne    c0105dbc <strtol+0x9a>
        s ++, base = 8;
c0105db0:	ff 45 08             	incl   0x8(%ebp)
c0105db3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105dba:	eb 0d                	jmp    c0105dc9 <strtol+0xa7>
    }
    else if (base == 0) {
c0105dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dc0:	75 07                	jne    c0105dc9 <strtol+0xa7>
        base = 10;
c0105dc2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dcc:	0f b6 00             	movzbl (%eax),%eax
c0105dcf:	3c 2f                	cmp    $0x2f,%al
c0105dd1:	7e 1b                	jle    c0105dee <strtol+0xcc>
c0105dd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd6:	0f b6 00             	movzbl (%eax),%eax
c0105dd9:	3c 39                	cmp    $0x39,%al
c0105ddb:	7f 11                	jg     c0105dee <strtol+0xcc>
            dig = *s - '0';
c0105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de0:	0f b6 00             	movzbl (%eax),%eax
c0105de3:	0f be c0             	movsbl %al,%eax
c0105de6:	83 e8 30             	sub    $0x30,%eax
c0105de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dec:	eb 48                	jmp    c0105e36 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df1:	0f b6 00             	movzbl (%eax),%eax
c0105df4:	3c 60                	cmp    $0x60,%al
c0105df6:	7e 1b                	jle    c0105e13 <strtol+0xf1>
c0105df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfb:	0f b6 00             	movzbl (%eax),%eax
c0105dfe:	3c 7a                	cmp    $0x7a,%al
c0105e00:	7f 11                	jg     c0105e13 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105e02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e05:	0f b6 00             	movzbl (%eax),%eax
c0105e08:	0f be c0             	movsbl %al,%eax
c0105e0b:	83 e8 57             	sub    $0x57,%eax
c0105e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e11:	eb 23                	jmp    c0105e36 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e16:	0f b6 00             	movzbl (%eax),%eax
c0105e19:	3c 40                	cmp    $0x40,%al
c0105e1b:	7e 3b                	jle    c0105e58 <strtol+0x136>
c0105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e20:	0f b6 00             	movzbl (%eax),%eax
c0105e23:	3c 5a                	cmp    $0x5a,%al
c0105e25:	7f 31                	jg     c0105e58 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2a:	0f b6 00             	movzbl (%eax),%eax
c0105e2d:	0f be c0             	movsbl %al,%eax
c0105e30:	83 e8 37             	sub    $0x37,%eax
c0105e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e39:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e3c:	7d 19                	jge    c0105e57 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105e3e:	ff 45 08             	incl   0x8(%ebp)
c0105e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e44:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e48:	89 c2                	mov    %eax,%edx
c0105e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e4d:	01 d0                	add    %edx,%eax
c0105e4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105e52:	e9 72 ff ff ff       	jmp    c0105dc9 <strtol+0xa7>
            break;
c0105e57:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105e58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e5c:	74 08                	je     c0105e66 <strtol+0x144>
        *endptr = (char *) s;
c0105e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e61:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e64:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105e66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105e6a:	74 07                	je     c0105e73 <strtol+0x151>
c0105e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e6f:	f7 d8                	neg    %eax
c0105e71:	eb 03                	jmp    c0105e76 <strtol+0x154>
c0105e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e76:	89 ec                	mov    %ebp,%esp
c0105e78:	5d                   	pop    %ebp
c0105e79:	c3                   	ret    

c0105e7a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e7a:	55                   	push   %ebp
c0105e7b:	89 e5                	mov    %esp,%ebp
c0105e7d:	83 ec 28             	sub    $0x28,%esp
c0105e80:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105e83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e86:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e89:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105e8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e90:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105e93:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105e96:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ea3:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105ea6:	89 d7                	mov    %edx,%edi
c0105ea8:	f3 aa                	rep stos %al,%es:(%edi)
c0105eaa:	89 fa                	mov    %edi,%edx
c0105eac:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105eaf:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105eb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105eb8:	89 ec                	mov    %ebp,%esp
c0105eba:	5d                   	pop    %ebp
c0105ebb:	c3                   	ret    

c0105ebc <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105ebc:	55                   	push   %ebp
c0105ebd:	89 e5                	mov    %esp,%ebp
c0105ebf:	57                   	push   %edi
c0105ec0:	56                   	push   %esi
c0105ec1:	53                   	push   %ebx
c0105ec2:	83 ec 30             	sub    $0x30,%esp
c0105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ed1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105edd:	73 42                	jae    c0105f21 <memmove+0x65>
c0105edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eee:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ef4:	c1 e8 02             	shr    $0x2,%eax
c0105ef7:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105ef9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105eff:	89 d7                	mov    %edx,%edi
c0105f01:	89 c6                	mov    %eax,%esi
c0105f03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f05:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f08:	83 e1 03             	and    $0x3,%ecx
c0105f0b:	74 02                	je     c0105f0f <memmove+0x53>
c0105f0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f0f:	89 f0                	mov    %esi,%eax
c0105f11:	89 fa                	mov    %edi,%edx
c0105f13:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105f16:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f19:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105f1f:	eb 36                	jmp    c0105f57 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f24:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f2a:	01 c2                	add    %eax,%edx
c0105f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f2f:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f35:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f3b:	89 c1                	mov    %eax,%ecx
c0105f3d:	89 d8                	mov    %ebx,%eax
c0105f3f:	89 d6                	mov    %edx,%esi
c0105f41:	89 c7                	mov    %eax,%edi
c0105f43:	fd                   	std    
c0105f44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f46:	fc                   	cld    
c0105f47:	89 f8                	mov    %edi,%eax
c0105f49:	89 f2                	mov    %esi,%edx
c0105f4b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f4e:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f51:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f57:	83 c4 30             	add    $0x30,%esp
c0105f5a:	5b                   	pop    %ebx
c0105f5b:	5e                   	pop    %esi
c0105f5c:	5f                   	pop    %edi
c0105f5d:	5d                   	pop    %ebp
c0105f5e:	c3                   	ret    

c0105f5f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105f5f:	55                   	push   %ebp
c0105f60:	89 e5                	mov    %esp,%ebp
c0105f62:	57                   	push   %edi
c0105f63:	56                   	push   %esi
c0105f64:	83 ec 20             	sub    $0x20,%esp
c0105f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f73:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f7c:	c1 e8 02             	shr    $0x2,%eax
c0105f7f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f87:	89 d7                	mov    %edx,%edi
c0105f89:	89 c6                	mov    %eax,%esi
c0105f8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f8d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f90:	83 e1 03             	and    $0x3,%ecx
c0105f93:	74 02                	je     c0105f97 <memcpy+0x38>
c0105f95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f97:	89 f0                	mov    %esi,%eax
c0105f99:	89 fa                	mov    %edi,%edx
c0105f9b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105fa7:	83 c4 20             	add    $0x20,%esp
c0105faa:	5e                   	pop    %esi
c0105fab:	5f                   	pop    %edi
c0105fac:	5d                   	pop    %ebp
c0105fad:	c3                   	ret    

c0105fae <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105fae:	55                   	push   %ebp
c0105faf:	89 e5                	mov    %esp,%ebp
c0105fb1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105fb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105fba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105fc0:	eb 2e                	jmp    c0105ff0 <memcmp+0x42>
        if (*s1 != *s2) {
c0105fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fc5:	0f b6 10             	movzbl (%eax),%edx
c0105fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fcb:	0f b6 00             	movzbl (%eax),%eax
c0105fce:	38 c2                	cmp    %al,%dl
c0105fd0:	74 18                	je     c0105fea <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fd5:	0f b6 00             	movzbl (%eax),%eax
c0105fd8:	0f b6 d0             	movzbl %al,%edx
c0105fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fde:	0f b6 00             	movzbl (%eax),%eax
c0105fe1:	0f b6 c8             	movzbl %al,%ecx
c0105fe4:	89 d0                	mov    %edx,%eax
c0105fe6:	29 c8                	sub    %ecx,%eax
c0105fe8:	eb 18                	jmp    c0106002 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105fea:	ff 45 fc             	incl   -0x4(%ebp)
c0105fed:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105ff0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ff3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ff6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ff9:	85 c0                	test   %eax,%eax
c0105ffb:	75 c5                	jne    c0105fc2 <memcmp+0x14>
    }
    return 0;
c0105ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106002:	89 ec                	mov    %ebp,%esp
c0106004:	5d                   	pop    %ebp
c0106005:	c3                   	ret    
