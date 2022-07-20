
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  100041:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  100059:	e8 1c 5e 00 00       	call   105e7a <memset>

    cons_init();                // init the console
  10005e:	e8 f7 15 00 00       	call   10165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 20 60 10 00 	movl   $0x106020,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 3c 60 10 00 	movl   $0x10603c,(%esp)
  100078:	e8 d9 02 00 00       	call   100356 <cprintf>

    print_kerninfo();
  10007d:	e8 f7 07 00 00       	call   100879 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 f8 44 00 00       	call   104584 <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 4a 17 00 00       	call   1017db <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 ae 18 00 00       	call   101944 <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 1e 0d 00 00       	call   100db9 <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 99 16 00 00       	call   101739 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 10 0c 00 00       	call   100cd4 <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 41 60 10 00 	movl   $0x106041,(%esp)
  10016e:	e8 e3 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  10018d:	e8 c4 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 5d 60 10 00 	movl   $0x10605d,(%esp)
  1001ac:	e8 a5 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 6b 60 10 00 	movl   $0x10606b,(%esp)
  1001cb:	e8 86 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 79 60 10 00 	movl   $0x106079,(%esp)
  1001ea:	e8 67 01 00 00       	call   100356 <cprintf>
    round ++;
  1001ef:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100202:	90                   	nop
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100208:	90                   	nop
  100209:	5d                   	pop    %ebp
  10020a:	c3                   	ret    

0010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020b:	55                   	push   %ebp
  10020c:	89 e5                	mov    %esp,%ebp
  10020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100211:	e8 29 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100216:	c7 04 24 88 60 10 00 	movl   $0x106088,(%esp)
  10021d:	e8 34 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_user();
  100222:	e8 d8 ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100227:	e8 13 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022c:	c7 04 24 a8 60 10 00 	movl   $0x1060a8,(%esp)
  100233:	e8 1e 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_kernel();
  100238:	e8 c8 ff ff ff       	call   100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023d:	e8 fd fe ff ff       	call   10013f <lab1_print_cur_status>
}
  100242:	90                   	nop
  100243:	89 ec                	mov    %ebp,%esp
  100245:	5d                   	pop    %ebp
  100246:	c3                   	ret    

00100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100247:	55                   	push   %ebp
  100248:	89 e5                	mov    %esp,%ebp
  10024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100251:	74 13                	je     100266 <readline+0x1f>
        cprintf("%s", prompt);
  100253:	8b 45 08             	mov    0x8(%ebp),%eax
  100256:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025a:	c7 04 24 c7 60 10 00 	movl   $0x1060c7,(%esp)
  100261:	e8 f0 00 00 00       	call   100356 <cprintf>
    }
    int i = 0, c;
  100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10026d:	e8 73 01 00 00       	call   1003e5 <getchar>
  100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100279:	79 07                	jns    100282 <readline+0x3b>
            return NULL;
  10027b:	b8 00 00 00 00       	mov    $0x0,%eax
  100280:	eb 78                	jmp    1002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100286:	7e 28                	jle    1002b0 <readline+0x69>
  100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10028f:	7f 1f                	jg     1002b0 <readline+0x69>
            cputchar(c);
  100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100294:	89 04 24             	mov    %eax,(%esp)
  100297:	e8 e2 00 00 00       	call   10037e <cputchar>
            buf[i ++] = c;
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029f:	8d 50 01             	lea    0x1(%eax),%edx
  1002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a8:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1002ae:	eb 45                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002b4:	75 16                	jne    1002cc <readline+0x85>
  1002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ba:	7e 10                	jle    1002cc <readline+0x85>
            cputchar(c);
  1002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002bf:	89 04 24             	mov    %eax,(%esp)
  1002c2:	e8 b7 00 00 00       	call   10037e <cputchar>
            i --;
  1002c7:	ff 4d f4             	decl   -0xc(%ebp)
  1002ca:	eb 29                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002d0:	74 06                	je     1002d8 <readline+0x91>
  1002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002d6:	75 95                	jne    10026d <readline+0x26>
            cputchar(c);
  1002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002db:	89 04 24             	mov    %eax,(%esp)
  1002de:	e8 9b 00 00 00       	call   10037e <cputchar>
            buf[i] = '\0';
  1002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002e6:	05 20 c0 11 00       	add    $0x11c020,%eax
  1002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002ee:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  1002f3:	eb 05                	jmp    1002fa <readline+0xb3>
        c = getchar();
  1002f5:	e9 73 ff ff ff       	jmp    10026d <readline+0x26>
        }
    }
}
  1002fa:	89 ec                	mov    %ebp,%esp
  1002fc:	5d                   	pop    %ebp
  1002fd:	c3                   	ret    

001002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100304:	8b 45 08             	mov    0x8(%ebp),%eax
  100307:	89 04 24             	mov    %eax,(%esp)
  10030a:	e8 7a 13 00 00       	call   101689 <cons_putc>
    (*cnt) ++;
  10030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100312:	8b 00                	mov    (%eax),%eax
  100314:	8d 50 01             	lea    0x1(%eax),%edx
  100317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031a:	89 10                	mov    %edx,(%eax)
}
  10031c:	90                   	nop
  10031d:	89 ec                	mov    %ebp,%esp
  10031f:	5d                   	pop    %ebp
  100320:	c3                   	ret    

00100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100321:	55                   	push   %ebp
  100322:	89 e5                	mov    %esp,%ebp
  100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 44 24 08          	mov    %eax,0x8(%esp)
  10033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	c7 04 24 fe 02 10 00 	movl   $0x1002fe,(%esp)
  10034a:	e8 56 53 00 00       	call   1056a5 <vprintfmt>
    return cnt;
  10034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100352:	89 ec                	mov    %ebp,%esp
  100354:	5d                   	pop    %ebp
  100355:	c3                   	ret    

00100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100365:	89 44 24 04          	mov    %eax,0x4(%esp)
  100369:	8b 45 08             	mov    0x8(%ebp),%eax
  10036c:	89 04 24             	mov    %eax,(%esp)
  10036f:	e8 ad ff ff ff       	call   100321 <vcprintf>
  100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037a:	89 ec                	mov    %ebp,%esp
  10037c:	5d                   	pop    %ebp
  10037d:	c3                   	ret    

0010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10037e:	55                   	push   %ebp
  10037f:	89 e5                	mov    %esp,%ebp
  100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100384:	8b 45 08             	mov    0x8(%ebp),%eax
  100387:	89 04 24             	mov    %eax,(%esp)
  10038a:	e8 fa 12 00 00       	call   101689 <cons_putc>
}
  10038f:	90                   	nop
  100390:	89 ec                	mov    %ebp,%esp
  100392:	5d                   	pop    %ebp
  100393:	c3                   	ret    

00100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100394:	55                   	push   %ebp
  100395:	89 e5                	mov    %esp,%ebp
  100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003a1:	eb 13                	jmp    1003b6 <cputs+0x22>
        cputch(c, &cnt);
  1003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003ae:	89 04 24             	mov    %eax,(%esp)
  1003b1:	e8 48 ff ff ff       	call   1002fe <cputch>
    while ((c = *str ++) != '\0') {
  1003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b9:	8d 50 01             	lea    0x1(%eax),%edx
  1003bc:	89 55 08             	mov    %edx,0x8(%ebp)
  1003bf:	0f b6 00             	movzbl (%eax),%eax
  1003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003c9:	75 d8                	jne    1003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003d9:	e8 20 ff ff ff       	call   1002fe <cputch>
    return cnt;
  1003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003e1:	89 ec                	mov    %ebp,%esp
  1003e3:	5d                   	pop    %ebp
  1003e4:	c3                   	ret    

001003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003e5:	55                   	push   %ebp
  1003e6:	89 e5                	mov    %esp,%ebp
  1003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003eb:	90                   	nop
  1003ec:	e8 d7 12 00 00       	call   1016c8 <cons_getc>
  1003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f8:	74 f2                	je     1003ec <getchar+0x7>
        /* do nothing */;
    return c;
  1003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003fd:	89 ec                	mov    %ebp,%esp
  1003ff:	5d                   	pop    %ebp
  100400:	c3                   	ret    

00100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100401:	55                   	push   %ebp
  100402:	89 e5                	mov    %esp,%ebp
  100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040a:	8b 00                	mov    (%eax),%eax
  10040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10040f:	8b 45 10             	mov    0x10(%ebp),%eax
  100412:	8b 00                	mov    (%eax),%eax
  100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10041e:	e9 ca 00 00 00       	jmp    1004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100429:	01 d0                	add    %edx,%eax
  10042b:	89 c2                	mov    %eax,%edx
  10042d:	c1 ea 1f             	shr    $0x1f,%edx
  100430:	01 d0                	add    %edx,%eax
  100432:	d1 f8                	sar    %eax
  100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10043d:	eb 03                	jmp    100442 <stab_binsearch+0x41>
            m --;
  10043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100448:	7c 1f                	jl     100469 <stab_binsearch+0x68>
  10044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044d:	89 d0                	mov    %edx,%eax
  10044f:	01 c0                	add    %eax,%eax
  100451:	01 d0                	add    %edx,%eax
  100453:	c1 e0 02             	shl    $0x2,%eax
  100456:	89 c2                	mov    %eax,%edx
  100458:	8b 45 08             	mov    0x8(%ebp),%eax
  10045b:	01 d0                	add    %edx,%eax
  10045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100461:	0f b6 c0             	movzbl %al,%eax
  100464:	39 45 14             	cmp    %eax,0x14(%ebp)
  100467:	75 d6                	jne    10043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10046f:	7d 09                	jge    10047a <stab_binsearch+0x79>
            l = true_m + 1;
  100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100474:	40                   	inc    %eax
  100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100478:	eb 73                	jmp    1004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100484:	89 d0                	mov    %edx,%eax
  100486:	01 c0                	add    %eax,%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	c1 e0 02             	shl    $0x2,%eax
  10048d:	89 c2                	mov    %eax,%edx
  10048f:	8b 45 08             	mov    0x8(%ebp),%eax
  100492:	01 d0                	add    %edx,%eax
  100494:	8b 40 08             	mov    0x8(%eax),%eax
  100497:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049a:	76 11                	jbe    1004ad <stab_binsearch+0xac>
            *region_left = m;
  10049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a7:	40                   	inc    %eax
  1004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ab:	eb 40                	jmp    1004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b0:	89 d0                	mov    %edx,%eax
  1004b2:	01 c0                	add    %eax,%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	c1 e0 02             	shl    $0x2,%eax
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004be:	01 d0                	add    %edx,%eax
  1004c0:	8b 40 08             	mov    0x8(%eax),%eax
  1004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004c6:	73 14                	jae    1004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	48                   	dec    %eax
  1004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004da:	eb 11                	jmp    1004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e2:	89 10                	mov    %edx,(%eax)
            l = m;
  1004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004f3:	0f 8e 2a ff ff ff    	jle    100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004fd:	75 0f                	jne    10050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 00                	mov    (%eax),%eax
  100504:	8d 50 ff             	lea    -0x1(%eax),%edx
  100507:	8b 45 10             	mov    0x10(%ebp),%eax
  10050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10050c:	eb 3e                	jmp    10054c <stab_binsearch+0x14b>
        l = *region_right;
  10050e:	8b 45 10             	mov    0x10(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100516:	eb 03                	jmp    10051b <stab_binsearch+0x11a>
  100518:	ff 4d fc             	decl   -0x4(%ebp)
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 00                	mov    (%eax),%eax
  100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100523:	7e 1f                	jle    100544 <stab_binsearch+0x143>
  100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100528:	89 d0                	mov    %edx,%eax
  10052a:	01 c0                	add    %eax,%eax
  10052c:	01 d0                	add    %edx,%eax
  10052e:	c1 e0 02             	shl    $0x2,%eax
  100531:	89 c2                	mov    %eax,%edx
  100533:	8b 45 08             	mov    0x8(%ebp),%eax
  100536:	01 d0                	add    %edx,%eax
  100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053c:	0f b6 c0             	movzbl %al,%eax
  10053f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100542:	75 d4                	jne    100518 <stab_binsearch+0x117>
        *region_left = l;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
}
  10054c:	90                   	nop
  10054d:	89 ec                	mov    %ebp,%esp
  10054f:	5d                   	pop    %ebp
  100550:	c3                   	ret    

00100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 00 cc 60 10 00    	movl   $0x1060cc,(%eax)
    info->eip_line = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	c7 40 08 cc 60 10 00 	movl   $0x1060cc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 55 08             	mov    0x8(%ebp),%edx
  100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100591:	c7 45 f4 a0 73 10 00 	movl   $0x1073a0,-0xc(%ebp)
    stab_end = __STAB_END__;
  100598:	c7 45 f0 48 2b 11 00 	movl   $0x112b48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10059f:	c7 45 ec 49 2b 11 00 	movl   $0x112b49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005a6:	c7 45 e8 c1 60 11 00 	movl   $0x1160c1,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005b3:	76 0b                	jbe    1005c0 <debuginfo_eip+0x6f>
  1005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b8:	48                   	dec    %eax
  1005b9:	0f b6 00             	movzbl (%eax),%eax
  1005bc:	84 c0                	test   %al,%al
  1005be:	74 0a                	je     1005ca <debuginfo_eip+0x79>
        return -1;
  1005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c5:	e9 ab 02 00 00       	jmp    100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005d7:	c1 f8 02             	sar    $0x2,%eax
  1005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005e0:	48                   	dec    %eax
  1005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005f2:	00 
  1005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100604:	89 04 24             	mov    %eax,(%esp)
  100607:	e8 f5 fd ff ff       	call   100401 <stab_binsearch>
    if (lfile == 0)
  10060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060f:	85 c0                	test   %eax,%eax
  100611:	75 0a                	jne    10061d <debuginfo_eip+0xcc>
        return -1;
  100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100618:	e9 58 02 00 00       	jmp    100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100629:	8b 45 08             	mov    0x8(%ebp),%eax
  10062c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100637:	00 
  100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10063b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100642:	89 44 24 04          	mov    %eax,0x4(%esp)
  100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100649:	89 04 24             	mov    %eax,(%esp)
  10064c:	e8 b0 fd ff ff       	call   100401 <stab_binsearch>

    if (lfun <= rfun) {
  100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100657:	39 c2                	cmp    %eax,%edx
  100659:	7f 78                	jg     1006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	01 c0                	add    %eax,%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	c1 e0 02             	shl    $0x2,%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066e:	01 d0                	add    %edx,%eax
  100670:	8b 10                	mov    (%eax),%edx
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100678:	39 c2                	cmp    %eax,%edx
  10067a:	73 22                	jae    10069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067f:	89 c2                	mov    %eax,%edx
  100681:	89 d0                	mov    %edx,%eax
  100683:	01 c0                	add    %eax,%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	c1 e0 02             	shl    $0x2,%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068f:	01 d0                	add    %edx,%eax
  100691:	8b 10                	mov    (%eax),%edx
  100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100696:	01 c2                	add    %eax,%edx
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	89 d0                	mov    %edx,%eax
  1006a5:	01 c0                	add    %eax,%eax
  1006a7:	01 d0                	add    %edx,%eax
  1006a9:	c1 e0 02             	shl    $0x2,%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b1:	01 d0                	add    %edx,%eax
  1006b3:	8b 50 08             	mov    0x8(%eax),%edx
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 10             	mov    0x10(%eax),%eax
  1006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006d1:	eb 15                	jmp    1006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006eb:	8b 40 08             	mov    0x8(%eax),%eax
  1006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f5:	00 
  1006f6:	89 04 24             	mov    %eax,(%esp)
  1006f9:	e8 f4 55 00 00       	call   105cf2 <strfind>
  1006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  100701:	8b 4a 08             	mov    0x8(%edx),%ecx
  100704:	29 c8                	sub    %ecx,%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070e:	8b 45 08             	mov    0x8(%ebp),%eax
  100711:	89 44 24 10          	mov    %eax,0x10(%esp)
  100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071c:	00 
  10071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100720:	89 44 24 08          	mov    %eax,0x8(%esp)
  100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072e:	89 04 24             	mov    %eax,(%esp)
  100731:	e8 cb fc ff ff       	call   100401 <stab_binsearch>
    if (lline <= rline) {
  100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	39 c2                	cmp    %eax,%edx
  10073e:	7f 23                	jg     100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	89 d0                	mov    %edx,%eax
  100747:	01 c0                	add    %eax,%eax
  100749:	01 d0                	add    %edx,%eax
  10074b:	c1 e0 02             	shl    $0x2,%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100761:	eb 11                	jmp    100774 <debuginfo_eip+0x223>
        return -1;
  100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100768:	e9 08 01 00 00       	jmp    100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	48                   	dec    %eax
  100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10077a:	39 c2                	cmp    %eax,%edx
  10077c:	7c 56                	jl     1007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  10077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100797:	3c 84                	cmp    $0x84,%al
  100799:	74 39                	je     1007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079e:	89 c2                	mov    %eax,%edx
  1007a0:	89 d0                	mov    %edx,%eax
  1007a2:	01 c0                	add    %eax,%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	c1 e0 02             	shl    $0x2,%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b4:	3c 64                	cmp    $0x64,%al
  1007b6:	75 b5                	jne    10076d <debuginfo_eip+0x21c>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 40 08             	mov    0x8(%eax),%eax
  1007d0:	85 c0                	test   %eax,%eax
  1007d2:	74 99                	je     10076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	7c 42                	jl     100820 <debuginfo_eip+0x2cf>
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f1:	01 d0                	add    %edx,%eax
  1007f3:	8b 10                	mov    (%eax),%edx
  1007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 46                	jge    100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	40                   	inc    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100831:	eb 16                	jmp    100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	8b 40 14             	mov    0x14(%eax),%eax
  100839:	8d 50 01             	lea    0x1(%eax),%edx
  10083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100845:	40                   	inc    %eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7d 1d                	jge    100870 <debuginfo_eip+0x31f>
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c a0                	cmp    $0xa0,%al
  10086e:	74 c3                	je     100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100875:	89 ec                	mov    %ebp,%esp
  100877:	5d                   	pop    %ebp
  100878:	c3                   	ret    

00100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100879:	55                   	push   %ebp
  10087a:	89 e5                	mov    %esp,%ebp
  10087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10087f:	c7 04 24 d6 60 10 00 	movl   $0x1060d6,(%esp)
  100886:	e8 cb fa ff ff       	call   100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 ef 60 10 00 	movl   $0x1060ef,(%esp)
  10089a:	e8 b7 fa ff ff       	call   100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089f:	c7 44 24 04 06 60 10 	movl   $0x106006,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 07 61 10 00 	movl   $0x106107,(%esp)
  1008ae:	e8 a3 fa ff ff       	call   100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b3:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1008ba:	00 
  1008bb:	c7 04 24 1f 61 10 00 	movl   $0x10611f,(%esp)
  1008c2:	e8 8f fa ff ff       	call   100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c7:	c7 44 24 04 2c cf 11 	movl   $0x11cf2c,0x4(%esp)
  1008ce:	00 
  1008cf:	c7 04 24 37 61 10 00 	movl   $0x106137,(%esp)
  1008d6:	e8 7b fa ff ff       	call   100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008db:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  1008e0:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f0:	85 c0                	test   %eax,%eax
  1008f2:	0f 48 c2             	cmovs  %edx,%eax
  1008f5:	c1 f8 0a             	sar    $0xa,%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	c7 04 24 50 61 10 00 	movl   $0x106150,(%esp)
  100903:	e8 4e fa ff ff       	call   100356 <cprintf>
}
  100908:	90                   	nop
  100909:	89 ec                	mov    %ebp,%esp
  10090b:	5d                   	pop    %ebp
  10090c:	c3                   	ret    

0010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10090d:	55                   	push   %ebp
  10090e:	89 e5                	mov    %esp,%ebp
  100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091d:	8b 45 08             	mov    0x8(%ebp),%eax
  100920:	89 04 24             	mov    %eax,(%esp)
  100923:	e8 29 fc ff ff       	call   100551 <debuginfo_eip>
  100928:	85 c0                	test   %eax,%eax
  10092a:	74 15                	je     100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100933:	c7 04 24 7a 61 10 00 	movl   $0x10617a,(%esp)
  10093a:	e8 17 fa ff ff       	call   100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10093f:	eb 6c                	jmp    1009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100948:	eb 1b                	jmp    100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  10094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	0f b6 10             	movzbl (%eax),%edx
  100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095e:	01 c8                	add    %ecx,%eax
  100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100962:	ff 45 f4             	incl   -0xc(%ebp)
  100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10096b:	7c dd                	jl     10094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100976:	01 d0                	add    %edx,%eax
  100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10097e:	8b 45 08             	mov    0x8(%ebp),%eax
  100981:	29 d0                	sub    %edx,%eax
  100983:	89 c1                	mov    %eax,%ecx
  100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100999:	89 54 24 08          	mov    %edx,0x8(%esp)
  10099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a1:	c7 04 24 96 61 10 00 	movl   $0x106196,(%esp)
  1009a8:	e8 a9 f9 ff ff       	call   100356 <cprintf>
}
  1009ad:	90                   	nop
  1009ae:	89 ec                	mov    %ebp,%esp
  1009b0:	5d                   	pop    %ebp
  1009b1:	c3                   	ret    

001009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b2:	55                   	push   %ebp
  1009b3:	89 e5                	mov    %esp,%ebp
  1009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009b8:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c1:	89 ec                	mov    %ebp,%esp
  1009c3:	5d                   	pop    %ebp
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
  1009cb:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009ce:	89 e8                	mov    %ebp,%eax
  1009d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  1009d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp = read_ebp();
  1009d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  1009d9:	e8 d4 ff ff ff       	call   1009b2 <read_eip>
  1009de:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  1009e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e8:	e9 8e 00 00 00       	jmp    100a7b <print_stackframe+0xb6>
        if (ebp == 0) break;
  1009ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009f1:	0f 84 90 00 00 00    	je     100a87 <print_stackframe+0xc2>

        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a05:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  100a0c:	e8 45 f9 ff ff       	call   100356 <cprintf>

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a14:	83 c0 14             	add    $0x14,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  100a17:	8b 18                	mov    (%eax),%ebx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1c:	83 c0 10             	add    $0x10,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  100a1f:	8b 08                	mov    (%eax),%ecx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a24:	83 c0 0c             	add    $0xc,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  100a27:	8b 10                	mov    (%eax),%edx
  100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2c:	83 c0 08             	add    $0x8,%eax
  100a2f:	8b 00                	mov    (%eax),%eax
  100a31:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a35:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a39:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a41:	c7 04 24 c0 61 10 00 	movl   $0x1061c0,(%esp)
  100a48:	e8 09 f9 ff ff       	call   100356 <cprintf>

        cprintf("\n");
  100a4d:	c7 04 24 e1 61 10 00 	movl   $0x1061e1,(%esp)
  100a54:	e8 fd f8 ff ff       	call   100356 <cprintf>

        print_debuginfo(eip - 1);
  100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5c:	48                   	dec    %eax
  100a5d:	89 04 24             	mov    %eax,(%esp)
  100a60:	e8 a8 fe ff ff       	call   10090d <print_debuginfo>

        eip = *(uint32_t *)(ebp + 4);
  100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a68:	83 c0 04             	add    $0x4,%eax
  100a6b:	8b 00                	mov    (%eax),%eax
  100a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)(ebp);
  100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a73:	8b 00                	mov    (%eax),%eax
  100a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a78:	ff 45 ec             	incl   -0x14(%ebp)
  100a7b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7f:	0f 8e 68 ff ff ff    	jle    1009ed <print_stackframe+0x28>
        // eip = ((uint32_t *)ebp)[1];
        // ebp = ((uint32_t *)ebp)[0];
    }

}
  100a85:	eb 01                	jmp    100a88 <print_stackframe+0xc3>
        if (ebp == 0) break;
  100a87:	90                   	nop
}
  100a88:	90                   	nop
  100a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a8c:	89 ec                	mov    %ebp,%esp
  100a8e:	5d                   	pop    %ebp
  100a8f:	c3                   	ret    

00100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a90:	55                   	push   %ebp
  100a91:	89 e5                	mov    %esp,%ebp
  100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9d:	eb 0c                	jmp    100aab <parse+0x1b>
            *buf ++ = '\0';
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	8d 50 01             	lea    0x1(%eax),%edx
  100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
  100aa8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aab:	8b 45 08             	mov    0x8(%ebp),%eax
  100aae:	0f b6 00             	movzbl (%eax),%eax
  100ab1:	84 c0                	test   %al,%al
  100ab3:	74 1d                	je     100ad2 <parse+0x42>
  100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab8:	0f b6 00             	movzbl (%eax),%eax
  100abb:	0f be c0             	movsbl %al,%eax
  100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac2:	c7 04 24 64 62 10 00 	movl   $0x106264,(%esp)
  100ac9:	e8 f0 51 00 00       	call   105cbe <strchr>
  100ace:	85 c0                	test   %eax,%eax
  100ad0:	75 cd                	jne    100a9f <parse+0xf>
        }
        if (*buf == '\0') {
  100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad5:	0f b6 00             	movzbl (%eax),%eax
  100ad8:	84 c0                	test   %al,%al
  100ada:	74 65                	je     100b41 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100adc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae0:	75 14                	jne    100af6 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ae9:	00 
  100aea:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  100af1:	e8 60 f8 ff ff       	call   100356 <cprintf>
        }
        argv[argc ++] = buf;
  100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af9:	8d 50 01             	lea    0x1(%eax),%edx
  100afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b09:	01 c2                	add    %eax,%edx
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b10:	eb 03                	jmp    100b15 <parse+0x85>
            buf ++;
  100b12:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b15:	8b 45 08             	mov    0x8(%ebp),%eax
  100b18:	0f b6 00             	movzbl (%eax),%eax
  100b1b:	84 c0                	test   %al,%al
  100b1d:	74 8c                	je     100aab <parse+0x1b>
  100b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b22:	0f b6 00             	movzbl (%eax),%eax
  100b25:	0f be c0             	movsbl %al,%eax
  100b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2c:	c7 04 24 64 62 10 00 	movl   $0x106264,(%esp)
  100b33:	e8 86 51 00 00       	call   105cbe <strchr>
  100b38:	85 c0                	test   %eax,%eax
  100b3a:	74 d6                	je     100b12 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3c:	e9 6a ff ff ff       	jmp    100aab <parse+0x1b>
            break;
  100b41:	90                   	nop
        }
    }
    return argc;
  100b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b45:	89 ec                	mov    %ebp,%esp
  100b47:	5d                   	pop    %ebp
  100b48:	c3                   	ret    

00100b49 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b49:	55                   	push   %ebp
  100b4a:	89 e5                	mov    %esp,%ebp
  100b4c:	83 ec 68             	sub    $0x68,%esp
  100b4f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b52:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b59:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5c:	89 04 24             	mov    %eax,(%esp)
  100b5f:	e8 2c ff ff ff       	call   100a90 <parse>
  100b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b6b:	75 0a                	jne    100b77 <runcmd+0x2e>
        return 0;
  100b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b72:	e9 83 00 00 00       	jmp    100bfa <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b7e:	eb 5a                	jmp    100bda <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b80:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b86:	89 c8                	mov    %ecx,%eax
  100b88:	01 c0                	add    %eax,%eax
  100b8a:	01 c8                	add    %ecx,%eax
  100b8c:	c1 e0 02             	shl    $0x2,%eax
  100b8f:	05 00 90 11 00       	add    $0x119000,%eax
  100b94:	8b 00                	mov    (%eax),%eax
  100b96:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9a:	89 04 24             	mov    %eax,(%esp)
  100b9d:	e8 80 50 00 00       	call   105c22 <strcmp>
  100ba2:	85 c0                	test   %eax,%eax
  100ba4:	75 31                	jne    100bd7 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ba9:	89 d0                	mov    %edx,%eax
  100bab:	01 c0                	add    %eax,%eax
  100bad:	01 d0                	add    %edx,%eax
  100baf:	c1 e0 02             	shl    $0x2,%eax
  100bb2:	05 08 90 11 00       	add    $0x119008,%eax
  100bb7:	8b 10                	mov    (%eax),%edx
  100bb9:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bbc:	83 c0 04             	add    $0x4,%eax
  100bbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bc2:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd0:	89 1c 24             	mov    %ebx,(%esp)
  100bd3:	ff d2                	call   *%edx
  100bd5:	eb 23                	jmp    100bfa <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd7:	ff 45 f4             	incl   -0xc(%ebp)
  100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdd:	83 f8 02             	cmp    $0x2,%eax
  100be0:	76 9e                	jbe    100b80 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be9:	c7 04 24 87 62 10 00 	movl   $0x106287,(%esp)
  100bf0:	e8 61 f7 ff ff       	call   100356 <cprintf>
    return 0;
  100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bfd:	89 ec                	mov    %ebp,%esp
  100bff:	5d                   	pop    %ebp
  100c00:	c3                   	ret    

00100c01 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c01:	55                   	push   %ebp
  100c02:	89 e5                	mov    %esp,%ebp
  100c04:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c07:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
  100c0e:	e8 43 f7 ff ff       	call   100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c13:	c7 04 24 c8 62 10 00 	movl   $0x1062c8,(%esp)
  100c1a:	e8 37 f7 ff ff       	call   100356 <cprintf>

    if (tf != NULL) {
  100c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c23:	74 0b                	je     100c30 <kmonitor+0x2f>
        print_trapframe(tf);
  100c25:	8b 45 08             	mov    0x8(%ebp),%eax
  100c28:	89 04 24             	mov    %eax,(%esp)
  100c2b:	e8 64 0e 00 00       	call   101a94 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c30:	c7 04 24 ed 62 10 00 	movl   $0x1062ed,(%esp)
  100c37:	e8 0b f6 ff ff       	call   100247 <readline>
  100c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c43:	74 eb                	je     100c30 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c45:	8b 45 08             	mov    0x8(%ebp),%eax
  100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4f:	89 04 24             	mov    %eax,(%esp)
  100c52:	e8 f2 fe ff ff       	call   100b49 <runcmd>
  100c57:	85 c0                	test   %eax,%eax
  100c59:	78 02                	js     100c5d <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c5b:	eb d3                	jmp    100c30 <kmonitor+0x2f>
                break;
  100c5d:	90                   	nop
            }
        }
    }
}
  100c5e:	90                   	nop
  100c5f:	89 ec                	mov    %ebp,%esp
  100c61:	5d                   	pop    %ebp
  100c62:	c3                   	ret    

00100c63 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c63:	55                   	push   %ebp
  100c64:	89 e5                	mov    %esp,%ebp
  100c66:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c70:	eb 3d                	jmp    100caf <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c75:	89 d0                	mov    %edx,%eax
  100c77:	01 c0                	add    %eax,%eax
  100c79:	01 d0                	add    %edx,%eax
  100c7b:	c1 e0 02             	shl    $0x2,%eax
  100c7e:	05 04 90 11 00       	add    $0x119004,%eax
  100c83:	8b 10                	mov    (%eax),%edx
  100c85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c88:	89 c8                	mov    %ecx,%eax
  100c8a:	01 c0                	add    %eax,%eax
  100c8c:	01 c8                	add    %ecx,%eax
  100c8e:	c1 e0 02             	shl    $0x2,%eax
  100c91:	05 00 90 11 00       	add    $0x119000,%eax
  100c96:	8b 00                	mov    (%eax),%eax
  100c98:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca0:	c7 04 24 f1 62 10 00 	movl   $0x1062f1,(%esp)
  100ca7:	e8 aa f6 ff ff       	call   100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cac:	ff 45 f4             	incl   -0xc(%ebp)
  100caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb2:	83 f8 02             	cmp    $0x2,%eax
  100cb5:	76 bb                	jbe    100c72 <mon_help+0xf>
    }
    return 0;
  100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbc:	89 ec                	mov    %ebp,%esp
  100cbe:	5d                   	pop    %ebp
  100cbf:	c3                   	ret    

00100cc0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cc6:	e8 ae fb ff ff       	call   100879 <print_kerninfo>
    return 0;
  100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd0:	89 ec                	mov    %ebp,%esp
  100cd2:	5d                   	pop    %ebp
  100cd3:	c3                   	ret    

00100cd4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cd4:	55                   	push   %ebp
  100cd5:	89 e5                	mov    %esp,%ebp
  100cd7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cda:	e8 e6 fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ce4:	89 ec                	mov    %ebp,%esp
  100ce6:	5d                   	pop    %ebp
  100ce7:	c3                   	ret    

00100ce8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ce8:	55                   	push   %ebp
  100ce9:	89 e5                	mov    %esp,%ebp
  100ceb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cee:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100cf3:	85 c0                	test   %eax,%eax
  100cf5:	75 5b                	jne    100d52 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cf7:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100cfe:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d01:	8d 45 14             	lea    0x14(%ebp),%eax
  100d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d15:	c7 04 24 fa 62 10 00 	movl   $0x1062fa,(%esp)
  100d1c:	e8 35 f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d28:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2b:	89 04 24             	mov    %eax,(%esp)
  100d2e:	e8 ee f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d33:	c7 04 24 16 63 10 00 	movl   $0x106316,(%esp)
  100d3a:	e8 17 f6 ff ff       	call   100356 <cprintf>
    
    cprintf("stack trackback:\n");
  100d3f:	c7 04 24 18 63 10 00 	movl   $0x106318,(%esp)
  100d46:	e8 0b f6 ff ff       	call   100356 <cprintf>
    print_stackframe();
  100d4b:	e8 75 fc ff ff       	call   1009c5 <print_stackframe>
  100d50:	eb 01                	jmp    100d53 <__panic+0x6b>
        goto panic_dead;
  100d52:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d53:	e8 e9 09 00 00       	call   101741 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d5f:	e8 9d fe ff ff       	call   100c01 <kmonitor>
  100d64:	eb f2                	jmp    100d58 <__panic+0x70>

00100d66 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d66:	55                   	push   %ebp
  100d67:	89 e5                	mov    %esp,%ebp
  100d69:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d6c:	8d 45 14             	lea    0x14(%ebp),%eax
  100d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d75:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d79:	8b 45 08             	mov    0x8(%ebp),%eax
  100d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d80:	c7 04 24 2a 63 10 00 	movl   $0x10632a,(%esp)
  100d87:	e8 ca f5 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d93:	8b 45 10             	mov    0x10(%ebp),%eax
  100d96:	89 04 24             	mov    %eax,(%esp)
  100d99:	e8 83 f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d9e:	c7 04 24 16 63 10 00 	movl   $0x106316,(%esp)
  100da5:	e8 ac f5 ff ff       	call   100356 <cprintf>
    va_end(ap);
}
  100daa:	90                   	nop
  100dab:	89 ec                	mov    %ebp,%esp
  100dad:	5d                   	pop    %ebp
  100dae:	c3                   	ret    

00100daf <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100daf:	55                   	push   %ebp
  100db0:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100db2:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  100db7:	5d                   	pop    %ebp
  100db8:	c3                   	ret    

00100db9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100db9:	55                   	push   %ebp
  100dba:	89 e5                	mov    %esp,%ebp
  100dbc:	83 ec 28             	sub    $0x28,%esp
  100dbf:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dc5:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd1:	ee                   	out    %al,(%dx)
}
  100dd2:	90                   	nop
  100dd3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dd9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ddd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100de5:	ee                   	out    %al,(%dx)
}
  100de6:	90                   	nop
  100de7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100ded:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100df1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100df5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100df9:	ee                   	out    %al,(%dx)
}
  100dfa:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dfb:	c7 05 24 c4 11 00 00 	movl   $0x0,0x11c424
  100e02:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e05:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  100e0c:	e8 45 f5 ff ff       	call   100356 <cprintf>
    pic_enable(IRQ_TIMER);
  100e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e18:	e8 89 09 00 00       	call   1017a6 <pic_enable>
}
  100e1d:	90                   	nop
  100e1e:	89 ec                	mov    %ebp,%esp
  100e20:	5d                   	pop    %ebp
  100e21:	c3                   	ret    

00100e22 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e28:	9c                   	pushf  
  100e29:	58                   	pop    %eax
  100e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e30:	25 00 02 00 00       	and    $0x200,%eax
  100e35:	85 c0                	test   %eax,%eax
  100e37:	74 0c                	je     100e45 <__intr_save+0x23>
        intr_disable();
  100e39:	e8 03 09 00 00       	call   101741 <intr_disable>
        return 1;
  100e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  100e43:	eb 05                	jmp    100e4a <__intr_save+0x28>
    }
    return 0;
  100e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e4a:	89 ec                	mov    %ebp,%esp
  100e4c:	5d                   	pop    %ebp
  100e4d:	c3                   	ret    

00100e4e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e4e:	55                   	push   %ebp
  100e4f:	89 e5                	mov    %esp,%ebp
  100e51:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e58:	74 05                	je     100e5f <__intr_restore+0x11>
        intr_enable();
  100e5a:	e8 da 08 00 00       	call   101739 <intr_enable>
    }
}
  100e5f:	90                   	nop
  100e60:	89 ec                	mov    %ebp,%esp
  100e62:	5d                   	pop    %ebp
  100e63:	c3                   	ret    

00100e64 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 10             	sub    $0x10,%esp
  100e6a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e7a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e80:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e84:	89 c2                	mov    %eax,%edx
  100e86:	ec                   	in     (%dx),%al
  100e87:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e8a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e90:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e94:	89 c2                	mov    %eax,%edx
  100e96:	ec                   	in     (%dx),%al
  100e97:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e9a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ea0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ea4:	89 c2                	mov    %eax,%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eaa:	90                   	nop
  100eab:	89 ec                	mov    %ebp,%esp
  100ead:	5d                   	pop    %ebp
  100eae:	c3                   	ret    

00100eaf <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eaf:	55                   	push   %ebp
  100eb0:	89 e5                	mov    %esp,%ebp
  100eb2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100eb5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebf:	0f b7 00             	movzwl (%eax),%eax
  100ec2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed1:	0f b7 00             	movzwl (%eax),%eax
  100ed4:	0f b7 c0             	movzwl %ax,%eax
  100ed7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100edc:	74 12                	je     100ef0 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ede:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ee5:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100eec:	b4 03 
  100eee:	eb 13                	jmp    100f03 <cga_init+0x54>
    } else {
        *cp = was;
  100ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ef7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100efa:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f01:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f03:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f0a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f0e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f12:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f16:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f1a:	ee                   	out    %al,(%dx)
}
  100f1b:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f1c:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f23:	40                   	inc    %eax
  100f24:	0f b7 c0             	movzwl %ax,%eax
  100f27:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f2f:	89 c2                	mov    %eax,%edx
  100f31:	ec                   	in     (%dx),%al
  100f32:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f35:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f39:	0f b6 c0             	movzbl %al,%eax
  100f3c:	c1 e0 08             	shl    $0x8,%eax
  100f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f42:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f49:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f4d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f51:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f55:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f59:	ee                   	out    %al,(%dx)
}
  100f5a:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f5b:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f62:	40                   	inc    %eax
  100f63:	0f b7 c0             	movzwl %ax,%eax
  100f66:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f6e:	89 c2                	mov    %eax,%edx
  100f70:	ec                   	in     (%dx),%al
  100f71:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f74:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f78:	0f b6 c0             	movzbl %al,%eax
  100f7b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f81:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f89:	0f b7 c0             	movzwl %ax,%eax
  100f8c:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100f92:	90                   	nop
  100f93:	89 ec                	mov    %ebp,%esp
  100f95:	5d                   	pop    %ebp
  100f96:	c3                   	ret    

00100f97 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f97:	55                   	push   %ebp
  100f98:	89 e5                	mov    %esp,%ebp
  100f9a:	83 ec 48             	sub    $0x48,%esp
  100f9d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fa3:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fa7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fab:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100faf:	ee                   	out    %al,(%dx)
}
  100fb0:	90                   	nop
  100fb1:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fb7:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fbb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fbf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fc3:	ee                   	out    %al,(%dx)
}
  100fc4:	90                   	nop
  100fc5:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fcb:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fcf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fd3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fd7:	ee                   	out    %al,(%dx)
}
  100fd8:	90                   	nop
  100fd9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fdf:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100feb:	ee                   	out    %al,(%dx)
}
  100fec:	90                   	nop
  100fed:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100ff3:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100ffb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fff:	ee                   	out    %al,(%dx)
}
  101000:	90                   	nop
  101001:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101007:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10100b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10100f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101013:	ee                   	out    %al,(%dx)
}
  101014:	90                   	nop
  101015:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10101b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10101f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101023:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101027:	ee                   	out    %al,(%dx)
}
  101028:	90                   	nop
  101029:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10102f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101033:	89 c2                	mov    %eax,%edx
  101035:	ec                   	in     (%dx),%al
  101036:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101039:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10103d:	3c ff                	cmp    $0xff,%al
  10103f:	0f 95 c0             	setne  %al
  101042:	0f b6 c0             	movzbl %al,%eax
  101045:	a3 48 c4 11 00       	mov    %eax,0x11c448
  10104a:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101050:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101054:	89 c2                	mov    %eax,%edx
  101056:	ec                   	in     (%dx),%al
  101057:	88 45 f1             	mov    %al,-0xf(%ebp)
  10105a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101060:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101064:	89 c2                	mov    %eax,%edx
  101066:	ec                   	in     (%dx),%al
  101067:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10106a:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10106f:	85 c0                	test   %eax,%eax
  101071:	74 0c                	je     10107f <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  101073:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10107a:	e8 27 07 00 00       	call   1017a6 <pic_enable>
    }
}
  10107f:	90                   	nop
  101080:	89 ec                	mov    %ebp,%esp
  101082:	5d                   	pop    %ebp
  101083:	c3                   	ret    

00101084 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101084:	55                   	push   %ebp
  101085:	89 e5                	mov    %esp,%ebp
  101087:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101091:	eb 08                	jmp    10109b <lpt_putc_sub+0x17>
        delay();
  101093:	e8 cc fd ff ff       	call   100e64 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101098:	ff 45 fc             	incl   -0x4(%ebp)
  10109b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010a1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010a5:	89 c2                	mov    %eax,%edx
  1010a7:	ec                   	in     (%dx),%al
  1010a8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010ab:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010af:	84 c0                	test   %al,%al
  1010b1:	78 09                	js     1010bc <lpt_putc_sub+0x38>
  1010b3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010ba:	7e d7                	jle    101093 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	0f b6 c0             	movzbl %al,%eax
  1010c2:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010c8:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010cb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010cf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d3:	ee                   	out    %al,(%dx)
}
  1010d4:	90                   	nop
  1010d5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010db:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010df:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010e7:	ee                   	out    %al,(%dx)
}
  1010e8:	90                   	nop
  1010e9:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010ef:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010f7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010fb:	ee                   	out    %al,(%dx)
}
  1010fc:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010fd:	90                   	nop
  1010fe:	89 ec                	mov    %ebp,%esp
  101100:	5d                   	pop    %ebp
  101101:	c3                   	ret    

00101102 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101102:	55                   	push   %ebp
  101103:	89 e5                	mov    %esp,%ebp
  101105:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101108:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10110c:	74 0d                	je     10111b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10110e:	8b 45 08             	mov    0x8(%ebp),%eax
  101111:	89 04 24             	mov    %eax,(%esp)
  101114:	e8 6b ff ff ff       	call   101084 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101119:	eb 24                	jmp    10113f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10111b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101122:	e8 5d ff ff ff       	call   101084 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101127:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10112e:	e8 51 ff ff ff       	call   101084 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101133:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10113a:	e8 45 ff ff ff       	call   101084 <lpt_putc_sub>
}
  10113f:	90                   	nop
  101140:	89 ec                	mov    %ebp,%esp
  101142:	5d                   	pop    %ebp
  101143:	c3                   	ret    

00101144 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101144:	55                   	push   %ebp
  101145:	89 e5                	mov    %esp,%ebp
  101147:	83 ec 38             	sub    $0x38,%esp
  10114a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  10114d:	8b 45 08             	mov    0x8(%ebp),%eax
  101150:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101155:	85 c0                	test   %eax,%eax
  101157:	75 07                	jne    101160 <cga_putc+0x1c>
        c |= 0x0700;
  101159:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101160:	8b 45 08             	mov    0x8(%ebp),%eax
  101163:	0f b6 c0             	movzbl %al,%eax
  101166:	83 f8 0d             	cmp    $0xd,%eax
  101169:	74 72                	je     1011dd <cga_putc+0x99>
  10116b:	83 f8 0d             	cmp    $0xd,%eax
  10116e:	0f 8f a3 00 00 00    	jg     101217 <cga_putc+0xd3>
  101174:	83 f8 08             	cmp    $0x8,%eax
  101177:	74 0a                	je     101183 <cga_putc+0x3f>
  101179:	83 f8 0a             	cmp    $0xa,%eax
  10117c:	74 4c                	je     1011ca <cga_putc+0x86>
  10117e:	e9 94 00 00 00       	jmp    101217 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101183:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10118a:	85 c0                	test   %eax,%eax
  10118c:	0f 84 af 00 00 00    	je     101241 <cga_putc+0xfd>
            crt_pos --;
  101192:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101199:	48                   	dec    %eax
  10119a:	0f b7 c0             	movzwl %ax,%eax
  10119d:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a6:	98                   	cwtl   
  1011a7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ac:	98                   	cwtl   
  1011ad:	83 c8 20             	or     $0x20,%eax
  1011b0:	98                   	cwtl   
  1011b1:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  1011b7:	0f b7 15 44 c4 11 00 	movzwl 0x11c444,%edx
  1011be:	01 d2                	add    %edx,%edx
  1011c0:	01 ca                	add    %ecx,%edx
  1011c2:	0f b7 c0             	movzwl %ax,%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011c8:	eb 77                	jmp    101241 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011ca:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011d1:	83 c0 50             	add    $0x50,%eax
  1011d4:	0f b7 c0             	movzwl %ax,%eax
  1011d7:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011dd:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  1011e4:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  1011eb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011f0:	89 c8                	mov    %ecx,%eax
  1011f2:	f7 e2                	mul    %edx
  1011f4:	c1 ea 06             	shr    $0x6,%edx
  1011f7:	89 d0                	mov    %edx,%eax
  1011f9:	c1 e0 02             	shl    $0x2,%eax
  1011fc:	01 d0                	add    %edx,%eax
  1011fe:	c1 e0 04             	shl    $0x4,%eax
  101201:	29 c1                	sub    %eax,%ecx
  101203:	89 ca                	mov    %ecx,%edx
  101205:	0f b7 d2             	movzwl %dx,%edx
  101208:	89 d8                	mov    %ebx,%eax
  10120a:	29 d0                	sub    %edx,%eax
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  101215:	eb 2b                	jmp    101242 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101217:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  10121d:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101224:	8d 50 01             	lea    0x1(%eax),%edx
  101227:	0f b7 d2             	movzwl %dx,%edx
  10122a:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  101231:	01 c0                	add    %eax,%eax
  101233:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101236:	8b 45 08             	mov    0x8(%ebp),%eax
  101239:	0f b7 c0             	movzwl %ax,%eax
  10123c:	66 89 02             	mov    %ax,(%edx)
        break;
  10123f:	eb 01                	jmp    101242 <cga_putc+0xfe>
        break;
  101241:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101242:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101249:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10124e:	76 5e                	jbe    1012ae <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101250:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101255:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10125b:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101260:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101267:	00 
  101268:	89 54 24 04          	mov    %edx,0x4(%esp)
  10126c:	89 04 24             	mov    %eax,(%esp)
  10126f:	e8 48 4c 00 00       	call   105ebc <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101274:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10127b:	eb 15                	jmp    101292 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  10127d:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  101283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101286:	01 c0                	add    %eax,%eax
  101288:	01 d0                	add    %edx,%eax
  10128a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10128f:	ff 45 f4             	incl   -0xc(%ebp)
  101292:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101299:	7e e2                	jle    10127d <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10129b:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012a2:	83 e8 50             	sub    $0x50,%eax
  1012a5:	0f b7 c0             	movzwl %ax,%eax
  1012a8:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012ae:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012b5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012b9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012bd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c5:	ee                   	out    %al,(%dx)
}
  1012c6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012c7:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012ce:	c1 e8 08             	shr    $0x8,%eax
  1012d1:	0f b7 c0             	movzwl %ax,%eax
  1012d4:	0f b6 c0             	movzbl %al,%eax
  1012d7:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  1012de:	42                   	inc    %edx
  1012df:	0f b7 d2             	movzwl %dx,%edx
  1012e2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012e6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012e9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ed:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f1:	ee                   	out    %al,(%dx)
}
  1012f2:	90                   	nop
    outb(addr_6845, 15);
  1012f3:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012fa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012fe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101302:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101306:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10130a:	ee                   	out    %al,(%dx)
}
  10130b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10130c:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101313:	0f b6 c0             	movzbl %al,%eax
  101316:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  10131d:	42                   	inc    %edx
  10131e:	0f b7 d2             	movzwl %dx,%edx
  101321:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101325:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101328:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10132c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101330:	ee                   	out    %al,(%dx)
}
  101331:	90                   	nop
}
  101332:	90                   	nop
  101333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101336:	89 ec                	mov    %ebp,%esp
  101338:	5d                   	pop    %ebp
  101339:	c3                   	ret    

0010133a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10133a:	55                   	push   %ebp
  10133b:	89 e5                	mov    %esp,%ebp
  10133d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101347:	eb 08                	jmp    101351 <serial_putc_sub+0x17>
        delay();
  101349:	e8 16 fb ff ff       	call   100e64 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10134e:	ff 45 fc             	incl   -0x4(%ebp)
  101351:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101357:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135b:	89 c2                	mov    %eax,%edx
  10135d:	ec                   	in     (%dx),%al
  10135e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101361:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101365:	0f b6 c0             	movzbl %al,%eax
  101368:	83 e0 20             	and    $0x20,%eax
  10136b:	85 c0                	test   %eax,%eax
  10136d:	75 09                	jne    101378 <serial_putc_sub+0x3e>
  10136f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101376:	7e d1                	jle    101349 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101378:	8b 45 08             	mov    0x8(%ebp),%eax
  10137b:	0f b6 c0             	movzbl %al,%eax
  10137e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101384:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101387:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10138b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10138f:	ee                   	out    %al,(%dx)
}
  101390:	90                   	nop
}
  101391:	90                   	nop
  101392:	89 ec                	mov    %ebp,%esp
  101394:	5d                   	pop    %ebp
  101395:	c3                   	ret    

00101396 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101396:	55                   	push   %ebp
  101397:	89 e5                	mov    %esp,%ebp
  101399:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10139c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a0:	74 0d                	je     1013af <serial_putc+0x19>
        serial_putc_sub(c);
  1013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a5:	89 04 24             	mov    %eax,(%esp)
  1013a8:	e8 8d ff ff ff       	call   10133a <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013ad:	eb 24                	jmp    1013d3 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013af:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b6:	e8 7f ff ff ff       	call   10133a <serial_putc_sub>
        serial_putc_sub(' ');
  1013bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c2:	e8 73 ff ff ff       	call   10133a <serial_putc_sub>
        serial_putc_sub('\b');
  1013c7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013ce:	e8 67 ff ff ff       	call   10133a <serial_putc_sub>
}
  1013d3:	90                   	nop
  1013d4:	89 ec                	mov    %ebp,%esp
  1013d6:	5d                   	pop    %ebp
  1013d7:	c3                   	ret    

001013d8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013d8:	55                   	push   %ebp
  1013d9:	89 e5                	mov    %esp,%ebp
  1013db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013de:	eb 33                	jmp    101413 <cons_intr+0x3b>
        if (c != 0) {
  1013e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e4:	74 2d                	je     101413 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013e6:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1013eb:	8d 50 01             	lea    0x1(%eax),%edx
  1013ee:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  1013f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013f7:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013fd:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101402:	3d 00 02 00 00       	cmp    $0x200,%eax
  101407:	75 0a                	jne    101413 <cons_intr+0x3b>
                cons.wpos = 0;
  101409:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101410:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101413:	8b 45 08             	mov    0x8(%ebp),%eax
  101416:	ff d0                	call   *%eax
  101418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10141b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10141f:	75 bf                	jne    1013e0 <cons_intr+0x8>
            }
        }
    }
}
  101421:	90                   	nop
  101422:	90                   	nop
  101423:	89 ec                	mov    %ebp,%esp
  101425:	5d                   	pop    %ebp
  101426:	c3                   	ret    

00101427 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101427:	55                   	push   %ebp
  101428:	89 e5                	mov    %esp,%ebp
  10142a:	83 ec 10             	sub    $0x10,%esp
  10142d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101433:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101437:	89 c2                	mov    %eax,%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10143d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	83 e0 01             	and    $0x1,%eax
  101447:	85 c0                	test   %eax,%eax
  101449:	75 07                	jne    101452 <serial_proc_data+0x2b>
        return -1;
  10144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101450:	eb 2a                	jmp    10147c <serial_proc_data+0x55>
  101452:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101458:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10145c:	89 c2                	mov    %eax,%edx
  10145e:	ec                   	in     (%dx),%al
  10145f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101462:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101466:	0f b6 c0             	movzbl %al,%eax
  101469:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10146c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101470:	75 07                	jne    101479 <serial_proc_data+0x52>
        c = '\b';
  101472:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101479:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10147c:	89 ec                	mov    %ebp,%esp
  10147e:	5d                   	pop    %ebp
  10147f:	c3                   	ret    

00101480 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101480:	55                   	push   %ebp
  101481:	89 e5                	mov    %esp,%ebp
  101483:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101486:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10148b:	85 c0                	test   %eax,%eax
  10148d:	74 0c                	je     10149b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10148f:	c7 04 24 27 14 10 00 	movl   $0x101427,(%esp)
  101496:	e8 3d ff ff ff       	call   1013d8 <cons_intr>
    }
}
  10149b:	90                   	nop
  10149c:	89 ec                	mov    %ebp,%esp
  10149e:	5d                   	pop    %ebp
  10149f:	c3                   	ret    

001014a0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a0:	55                   	push   %ebp
  1014a1:	89 e5                	mov    %esp,%ebp
  1014a3:	83 ec 38             	sub    $0x38,%esp
  1014a6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	ec                   	in     (%dx),%al
  1014b2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014b9:	0f b6 c0             	movzbl %al,%eax
  1014bc:	83 e0 01             	and    $0x1,%eax
  1014bf:	85 c0                	test   %eax,%eax
  1014c1:	75 0a                	jne    1014cd <kbd_proc_data+0x2d>
        return -1;
  1014c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014c8:	e9 56 01 00 00       	jmp    101623 <kbd_proc_data+0x183>
  1014cd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014d6:	89 c2                	mov    %eax,%edx
  1014d8:	ec                   	in     (%dx),%al
  1014d9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014dc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014e3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014e7:	75 17                	jne    101500 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014e9:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1014ee:	83 c8 40             	or     $0x40,%eax
  1014f1:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  1014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014fb:	e9 23 01 00 00       	jmp    101623 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101500:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101504:	84 c0                	test   %al,%al
  101506:	79 45                	jns    10154d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101508:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10150d:	83 e0 40             	and    $0x40,%eax
  101510:	85 c0                	test   %eax,%eax
  101512:	75 08                	jne    10151c <kbd_proc_data+0x7c>
  101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101518:	24 7f                	and    $0x7f,%al
  10151a:	eb 04                	jmp    101520 <kbd_proc_data+0x80>
  10151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101520:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101523:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101527:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  10152e:	0c 40                	or     $0x40,%al
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	f7 d0                	not    %eax
  101535:	89 c2                	mov    %eax,%edx
  101537:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10153c:	21 d0                	and    %edx,%eax
  10153e:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101543:	b8 00 00 00 00       	mov    $0x0,%eax
  101548:	e9 d6 00 00 00       	jmp    101623 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  10154d:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101552:	83 e0 40             	and    $0x40,%eax
  101555:	85 c0                	test   %eax,%eax
  101557:	74 11                	je     10156a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101559:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10155d:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101562:	83 e0 bf             	and    $0xffffffbf,%eax
  101565:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  10156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156e:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101575:	0f b6 d0             	movzbl %al,%edx
  101578:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10157d:	09 d0                	or     %edx,%eax
  10157f:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101588:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  10158f:	0f b6 d0             	movzbl %al,%edx
  101592:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101597:	31 d0                	xor    %edx,%eax
  101599:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  10159e:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015a3:	83 e0 03             	and    $0x3,%eax
  1015a6:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  1015ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b1:	01 d0                	add    %edx,%eax
  1015b3:	0f b6 00             	movzbl (%eax),%eax
  1015b6:	0f b6 c0             	movzbl %al,%eax
  1015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015bc:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015c1:	83 e0 08             	and    $0x8,%eax
  1015c4:	85 c0                	test   %eax,%eax
  1015c6:	74 22                	je     1015ea <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015c8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015cc:	7e 0c                	jle    1015da <kbd_proc_data+0x13a>
  1015ce:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015d2:	7f 06                	jg     1015da <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015d4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015d8:	eb 10                	jmp    1015ea <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015da:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015de:	7e 0a                	jle    1015ea <kbd_proc_data+0x14a>
  1015e0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015e4:	7f 04                	jg     1015ea <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015e6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015ea:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015ef:	f7 d0                	not    %eax
  1015f1:	83 e0 06             	and    $0x6,%eax
  1015f4:	85 c0                	test   %eax,%eax
  1015f6:	75 28                	jne    101620 <kbd_proc_data+0x180>
  1015f8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ff:	75 1f                	jne    101620 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101601:	c7 04 24 63 63 10 00 	movl   $0x106363,(%esp)
  101608:	e8 49 ed ff ff       	call   100356 <cprintf>
  10160d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101613:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101617:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10161b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10161e:	ee                   	out    %al,(%dx)
}
  10161f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101620:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101623:	89 ec                	mov    %ebp,%esp
  101625:	5d                   	pop    %ebp
  101626:	c3                   	ret    

00101627 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101627:	55                   	push   %ebp
  101628:	89 e5                	mov    %esp,%ebp
  10162a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10162d:	c7 04 24 a0 14 10 00 	movl   $0x1014a0,(%esp)
  101634:	e8 9f fd ff ff       	call   1013d8 <cons_intr>
}
  101639:	90                   	nop
  10163a:	89 ec                	mov    %ebp,%esp
  10163c:	5d                   	pop    %ebp
  10163d:	c3                   	ret    

0010163e <kbd_init>:

static void
kbd_init(void) {
  10163e:	55                   	push   %ebp
  10163f:	89 e5                	mov    %esp,%ebp
  101641:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101644:	e8 de ff ff ff       	call   101627 <kbd_intr>
    pic_enable(IRQ_KBD);
  101649:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101650:	e8 51 01 00 00       	call   1017a6 <pic_enable>
}
  101655:	90                   	nop
  101656:	89 ec                	mov    %ebp,%esp
  101658:	5d                   	pop    %ebp
  101659:	c3                   	ret    

0010165a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10165a:	55                   	push   %ebp
  10165b:	89 e5                	mov    %esp,%ebp
  10165d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101660:	e8 4a f8 ff ff       	call   100eaf <cga_init>
    serial_init();
  101665:	e8 2d f9 ff ff       	call   100f97 <serial_init>
    kbd_init();
  10166a:	e8 cf ff ff ff       	call   10163e <kbd_init>
    if (!serial_exists) {
  10166f:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101674:	85 c0                	test   %eax,%eax
  101676:	75 0c                	jne    101684 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101678:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  10167f:	e8 d2 ec ff ff       	call   100356 <cprintf>
    }
}
  101684:	90                   	nop
  101685:	89 ec                	mov    %ebp,%esp
  101687:	5d                   	pop    %ebp
  101688:	c3                   	ret    

00101689 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101689:	55                   	push   %ebp
  10168a:	89 e5                	mov    %esp,%ebp
  10168c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10168f:	e8 8e f7 ff ff       	call   100e22 <__intr_save>
  101694:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101697:	8b 45 08             	mov    0x8(%ebp),%eax
  10169a:	89 04 24             	mov    %eax,(%esp)
  10169d:	e8 60 fa ff ff       	call   101102 <lpt_putc>
        cga_putc(c);
  1016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a5:	89 04 24             	mov    %eax,(%esp)
  1016a8:	e8 97 fa ff ff       	call   101144 <cga_putc>
        serial_putc(c);
  1016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b0:	89 04 24             	mov    %eax,(%esp)
  1016b3:	e8 de fc ff ff       	call   101396 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016bb:	89 04 24             	mov    %eax,(%esp)
  1016be:	e8 8b f7 ff ff       	call   100e4e <__intr_restore>
}
  1016c3:	90                   	nop
  1016c4:	89 ec                	mov    %ebp,%esp
  1016c6:	5d                   	pop    %ebp
  1016c7:	c3                   	ret    

001016c8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016c8:	55                   	push   %ebp
  1016c9:	89 e5                	mov    %esp,%ebp
  1016cb:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016d5:	e8 48 f7 ff ff       	call   100e22 <__intr_save>
  1016da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016dd:	e8 9e fd ff ff       	call   101480 <serial_intr>
        kbd_intr();
  1016e2:	e8 40 ff ff ff       	call   101627 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016e7:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  1016ed:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1016f2:	39 c2                	cmp    %eax,%edx
  1016f4:	74 31                	je     101727 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016f6:	a1 60 c6 11 00       	mov    0x11c660,%eax
  1016fb:	8d 50 01             	lea    0x1(%eax),%edx
  1016fe:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  101704:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  10170b:	0f b6 c0             	movzbl %al,%eax
  10170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101711:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101716:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171b:	75 0a                	jne    101727 <cons_getc+0x5f>
                cons.rpos = 0;
  10171d:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  101724:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10172a:	89 04 24             	mov    %eax,(%esp)
  10172d:	e8 1c f7 ff ff       	call   100e4e <__intr_restore>
    return c;
  101732:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101735:	89 ec                	mov    %ebp,%esp
  101737:	5d                   	pop    %ebp
  101738:	c3                   	ret    

00101739 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101739:	55                   	push   %ebp
  10173a:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10173c:	fb                   	sti    
}
  10173d:	90                   	nop
    sti();
}
  10173e:	90                   	nop
  10173f:	5d                   	pop    %ebp
  101740:	c3                   	ret    

00101741 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101741:	55                   	push   %ebp
  101742:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101744:	fa                   	cli    
}
  101745:	90                   	nop
    cli();
}
  101746:	90                   	nop
  101747:	5d                   	pop    %ebp
  101748:	c3                   	ret    

00101749 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101749:	55                   	push   %ebp
  10174a:	89 e5                	mov    %esp,%ebp
  10174c:	83 ec 14             	sub    $0x14,%esp
  10174f:	8b 45 08             	mov    0x8(%ebp),%eax
  101752:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101759:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  10175f:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  101764:	85 c0                	test   %eax,%eax
  101766:	74 39                	je     1017a1 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  101768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10176b:	0f b6 c0             	movzbl %al,%eax
  10176e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101774:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101777:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10177b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
}
  101780:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101781:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101785:	c1 e8 08             	shr    $0x8,%eax
  101788:	0f b7 c0             	movzwl %ax,%eax
  10178b:	0f b6 c0             	movzbl %al,%eax
  10178e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101794:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101797:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10179b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10179f:	ee                   	out    %al,(%dx)
}
  1017a0:	90                   	nop
    }
}
  1017a1:	90                   	nop
  1017a2:	89 ec                	mov    %ebp,%esp
  1017a4:	5d                   	pop    %ebp
  1017a5:	c3                   	ret    

001017a6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017a6:	55                   	push   %ebp
  1017a7:	89 e5                	mov    %esp,%ebp
  1017a9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1017af:	ba 01 00 00 00       	mov    $0x1,%edx
  1017b4:	88 c1                	mov    %al,%cl
  1017b6:	d3 e2                	shl    %cl,%edx
  1017b8:	89 d0                	mov    %edx,%eax
  1017ba:	98                   	cwtl   
  1017bb:	f7 d0                	not    %eax
  1017bd:	0f bf d0             	movswl %ax,%edx
  1017c0:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  1017c7:	98                   	cwtl   
  1017c8:	21 d0                	and    %edx,%eax
  1017ca:	98                   	cwtl   
  1017cb:	0f b7 c0             	movzwl %ax,%eax
  1017ce:	89 04 24             	mov    %eax,(%esp)
  1017d1:	e8 73 ff ff ff       	call   101749 <pic_setmask>
}
  1017d6:	90                   	nop
  1017d7:	89 ec                	mov    %ebp,%esp
  1017d9:	5d                   	pop    %ebp
  1017da:	c3                   	ret    

001017db <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017db:	55                   	push   %ebp
  1017dc:	89 e5                	mov    %esp,%ebp
  1017de:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017e1:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  1017e8:	00 00 00 
  1017eb:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017f1:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017f5:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017f9:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
}
  1017fe:	90                   	nop
  1017ff:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101805:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101809:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10180d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101811:	ee                   	out    %al,(%dx)
}
  101812:	90                   	nop
  101813:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101819:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10181d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101821:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
}
  101826:	90                   	nop
  101827:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10182d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101831:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101835:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101839:	ee                   	out    %al,(%dx)
}
  10183a:	90                   	nop
  10183b:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101841:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101845:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101849:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10184d:	ee                   	out    %al,(%dx)
}
  10184e:	90                   	nop
  10184f:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101855:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101859:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10185d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101861:	ee                   	out    %al,(%dx)
}
  101862:	90                   	nop
  101863:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101869:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10186d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101871:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101875:	ee                   	out    %al,(%dx)
}
  101876:	90                   	nop
  101877:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10187d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101881:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101885:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101889:	ee                   	out    %al,(%dx)
}
  10188a:	90                   	nop
  10188b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101891:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101895:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101899:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10189d:	ee                   	out    %al,(%dx)
}
  10189e:	90                   	nop
  10189f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018a5:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018a9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018ad:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018b1:	ee                   	out    %al,(%dx)
}
  1018b2:	90                   	nop
  1018b3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018b9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018bd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018c1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018c5:	ee                   	out    %al,(%dx)
}
  1018c6:	90                   	nop
  1018c7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018cd:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018d5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018d9:	ee                   	out    %al,(%dx)
}
  1018da:	90                   	nop
  1018db:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018e1:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018e9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018ed:	ee                   	out    %al,(%dx)
}
  1018ee:	90                   	nop
  1018ef:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018f5:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018f9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018fd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101901:	ee                   	out    %al,(%dx)
}
  101902:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101903:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10190a:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10190f:	74 0f                	je     101920 <pic_init+0x145>
        pic_setmask(irq_mask);
  101911:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101918:	89 04 24             	mov    %eax,(%esp)
  10191b:	e8 29 fe ff ff       	call   101749 <pic_setmask>
    }
}
  101920:	90                   	nop
  101921:	89 ec                	mov    %ebp,%esp
  101923:	5d                   	pop    %ebp
  101924:	c3                   	ret    

00101925 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101925:	55                   	push   %ebp
  101926:	89 e5                	mov    %esp,%ebp
  101928:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10192b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101932:	00 
  101933:	c7 04 24 a0 63 10 00 	movl   $0x1063a0,(%esp)
  10193a:	e8 17 ea ff ff       	call   100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10193f:	90                   	nop
  101940:	89 ec                	mov    %ebp,%esp
  101942:	5d                   	pop    %ebp
  101943:	c3                   	ret    

00101944 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101944:	55                   	push   %ebp
  101945:	89 e5                	mov    %esp,%ebp
  101947:	83 ec 28             	sub    $0x28,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */

    extern uintptr_t __vectors[];

    uintptr_t a = __vectors;
  10194a:	c7 45 f0 e0 95 11 00 	movl   $0x1195e0,-0x10(%ebp)

    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
  101951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101958:	e9 c4 00 00 00       	jmp    101a21 <idt_init+0xdd>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL)
  10195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101960:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101967:	0f b7 d0             	movzwl %ax,%edx
  10196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10196d:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  101974:	00 
  101975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101978:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  10197f:	00 08 00 
  101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101985:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  10198c:	00 
  10198d:	80 e2 e0             	and    $0xe0,%dl
  101990:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10199a:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019a1:	00 
  1019a2:	80 e2 1f             	and    $0x1f,%dl
  1019a5:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019af:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019b6:	00 
  1019b7:	80 e2 f0             	and    $0xf0,%dl
  1019ba:	80 ca 0e             	or     $0xe,%dl
  1019bd:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019c7:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019ce:	00 
  1019cf:	80 e2 ef             	and    $0xef,%dl
  1019d2:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019dc:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019e3:	00 
  1019e4:	80 e2 9f             	and    $0x9f,%dl
  1019e7:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019f1:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019f8:	00 
  1019f9:	80 ca 80             	or     $0x80,%dl
  1019fc:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a06:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a0d:	c1 e8 10             	shr    $0x10,%eax
  101a10:	0f b7 d0             	movzwl %ax,%edx
  101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a16:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a1d:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
  101a1e:	ff 45 f4             	incl   -0xc(%ebp)
  101a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a24:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a29:	0f 86 2e ff ff ff    	jbe    10195d <idt_init+0x19>
  101a2f:	c7 45 ec 60 95 11 00 	movl   $0x119560,-0x14(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101a39:	0f 01 18             	lidtl  (%eax)
}
  101a3c:	90                   	nop
    }

    lidt(&idt_pd);

    cprintf("test");
  101a3d:	c7 04 24 aa 63 10 00 	movl   $0x1063aa,(%esp)
  101a44:	e8 0d e9 ff ff       	call   100356 <cprintf>
}
  101a49:	90                   	nop
  101a4a:	89 ec                	mov    %ebp,%esp
  101a4c:	5d                   	pop    %ebp
  101a4d:	c3                   	ret    

00101a4e <trapname>:

static const char *
trapname(int trapno) {
  101a4e:	55                   	push   %ebp
  101a4f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	83 f8 13             	cmp    $0x13,%eax
  101a57:	77 0c                	ja     101a65 <trapname+0x17>
        return excnames[trapno];
  101a59:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5c:	8b 04 85 00 67 10 00 	mov    0x106700(,%eax,4),%eax
  101a63:	eb 18                	jmp    101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a69:	7e 0d                	jle    101a78 <trapname+0x2a>
  101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6f:	7f 07                	jg     101a78 <trapname+0x2a>
        return "Hardware Interrupt";
  101a71:	b8 af 63 10 00       	mov    $0x1063af,%eax
  101a76:	eb 05                	jmp    101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a78:	b8 c2 63 10 00       	mov    $0x1063c2,%eax
}
  101a7d:	5d                   	pop    %ebp
  101a7e:	c3                   	ret    

00101a7f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a7f:	55                   	push   %ebp
  101a80:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a89:	83 f8 08             	cmp    $0x8,%eax
  101a8c:	0f 94 c0             	sete   %al
  101a8f:	0f b6 c0             	movzbl %al,%eax
}
  101a92:	5d                   	pop    %ebp
  101a93:	c3                   	ret    

00101a94 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a94:	55                   	push   %ebp
  101a95:	89 e5                	mov    %esp,%ebp
  101a97:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa1:	c7 04 24 03 64 10 00 	movl   $0x106403,(%esp)
  101aa8:	e8 a9 e8 ff ff       	call   100356 <cprintf>
    print_regs(&tf->tf_regs);
  101aad:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab0:	89 04 24             	mov    %eax,(%esp)
  101ab3:	e8 8f 01 00 00       	call   101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 14 64 10 00 	movl   $0x106414,(%esp)
  101aca:	e8 87 e8 ff ff       	call   100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ada:	c7 04 24 27 64 10 00 	movl   $0x106427,(%esp)
  101ae1:	e8 70 e8 ff ff       	call   100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af1:	c7 04 24 3a 64 10 00 	movl   $0x10643a,(%esp)
  101af8:	e8 59 e8 ff ff       	call   100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101afd:	8b 45 08             	mov    0x8(%ebp),%eax
  101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b08:	c7 04 24 4d 64 10 00 	movl   $0x10644d,(%esp)
  101b0f:	e8 42 e8 ff ff       	call   100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b14:	8b 45 08             	mov    0x8(%ebp),%eax
  101b17:	8b 40 30             	mov    0x30(%eax),%eax
  101b1a:	89 04 24             	mov    %eax,(%esp)
  101b1d:	e8 2c ff ff ff       	call   101a4e <trapname>
  101b22:	8b 55 08             	mov    0x8(%ebp),%edx
  101b25:	8b 52 30             	mov    0x30(%edx),%edx
  101b28:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b30:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101b37:	e8 1a e8 ff ff       	call   100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	8b 40 34             	mov    0x34(%eax),%eax
  101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b46:	c7 04 24 72 64 10 00 	movl   $0x106472,(%esp)
  101b4d:	e8 04 e8 ff ff       	call   100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	8b 40 38             	mov    0x38(%eax),%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 81 64 10 00 	movl   $0x106481,(%esp)
  101b63:	e8 ee e7 ff ff       	call   100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b73:	c7 04 24 90 64 10 00 	movl   $0x106490,(%esp)
  101b7a:	e8 d7 e7 ff ff       	call   100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b82:	8b 40 40             	mov    0x40(%eax),%eax
  101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b89:	c7 04 24 a3 64 10 00 	movl   $0x1064a3,(%esp)
  101b90:	e8 c1 e7 ff ff       	call   100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b9c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ba3:	eb 3d                	jmp    101be2 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	8b 50 40             	mov    0x40(%eax),%edx
  101bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bae:	21 d0                	and    %edx,%eax
  101bb0:	85 c0                	test   %eax,%eax
  101bb2:	74 28                	je     101bdc <print_trapframe+0x148>
  101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb7:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101bbe:	85 c0                	test   %eax,%eax
  101bc0:	74 1a                	je     101bdc <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc5:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd0:	c7 04 24 b2 64 10 00 	movl   $0x1064b2,(%esp)
  101bd7:	e8 7a e7 ff ff       	call   100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bdc:	ff 45 f4             	incl   -0xc(%ebp)
  101bdf:	d1 65 f0             	shll   -0x10(%ebp)
  101be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be5:	83 f8 17             	cmp    $0x17,%eax
  101be8:	76 bb                	jbe    101ba5 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 40 40             	mov    0x40(%eax),%eax
  101bf0:	c1 e8 0c             	shr    $0xc,%eax
  101bf3:	83 e0 03             	and    $0x3,%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 b6 64 10 00 	movl   $0x1064b6,(%esp)
  101c01:	e8 50 e7 ff ff       	call   100356 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	89 04 24             	mov    %eax,(%esp)
  101c0c:	e8 6e fe ff ff       	call   101a7f <trap_in_kernel>
  101c11:	85 c0                	test   %eax,%eax
  101c13:	75 2d                	jne    101c42 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 44             	mov    0x44(%eax),%eax
  101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1f:	c7 04 24 bf 64 10 00 	movl   $0x1064bf,(%esp)
  101c26:	e8 2b e7 ff ff       	call   100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c36:	c7 04 24 ce 64 10 00 	movl   $0x1064ce,(%esp)
  101c3d:	e8 14 e7 ff ff       	call   100356 <cprintf>
    }
}
  101c42:	90                   	nop
  101c43:	89 ec                	mov    %ebp,%esp
  101c45:	5d                   	pop    %ebp
  101c46:	c3                   	ret    

00101c47 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c47:	55                   	push   %ebp
  101c48:	89 e5                	mov    %esp,%ebp
  101c4a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c50:	8b 00                	mov    (%eax),%eax
  101c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c56:	c7 04 24 e1 64 10 00 	movl   $0x1064e1,(%esp)
  101c5d:	e8 f4 e6 ff ff       	call   100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c62:	8b 45 08             	mov    0x8(%ebp),%eax
  101c65:	8b 40 04             	mov    0x4(%eax),%eax
  101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6c:	c7 04 24 f0 64 10 00 	movl   $0x1064f0,(%esp)
  101c73:	e8 de e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c78:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7b:	8b 40 08             	mov    0x8(%eax),%eax
  101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c82:	c7 04 24 ff 64 10 00 	movl   $0x1064ff,(%esp)
  101c89:	e8 c8 e6 ff ff       	call   100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	8b 40 0c             	mov    0xc(%eax),%eax
  101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c98:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  101c9f:	e8 b2 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca7:	8b 40 10             	mov    0x10(%eax),%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 1d 65 10 00 	movl   $0x10651d,(%esp)
  101cb5:	e8 9c e6 ff ff       	call   100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	8b 40 14             	mov    0x14(%eax),%eax
  101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc4:	c7 04 24 2c 65 10 00 	movl   $0x10652c,(%esp)
  101ccb:	e8 86 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 18             	mov    0x18(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 3b 65 10 00 	movl   $0x10653b,(%esp)
  101ce1:	e8 70 e6 ff ff       	call   100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 4a 65 10 00 	movl   $0x10654a,(%esp)
  101cf7:	e8 5a e6 ff ff       	call   100356 <cprintf>
}
  101cfc:	90                   	nop
  101cfd:	89 ec                	mov    %ebp,%esp
  101cff:	5d                   	pop    %ebp
  101d00:	c3                   	ret    

00101d01 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d01:	55                   	push   %ebp
  101d02:	89 e5                	mov    %esp,%ebp
  101d04:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	8b 40 30             	mov    0x30(%eax),%eax
  101d0d:	83 f8 79             	cmp    $0x79,%eax
  101d10:	0f 87 e6 00 00 00    	ja     101dfc <trap_dispatch+0xfb>
  101d16:	83 f8 78             	cmp    $0x78,%eax
  101d19:	0f 83 c1 00 00 00    	jae    101de0 <trap_dispatch+0xdf>
  101d1f:	83 f8 2f             	cmp    $0x2f,%eax
  101d22:	0f 87 d4 00 00 00    	ja     101dfc <trap_dispatch+0xfb>
  101d28:	83 f8 2e             	cmp    $0x2e,%eax
  101d2b:	0f 83 00 01 00 00    	jae    101e31 <trap_dispatch+0x130>
  101d31:	83 f8 24             	cmp    $0x24,%eax
  101d34:	74 5e                	je     101d94 <trap_dispatch+0x93>
  101d36:	83 f8 24             	cmp    $0x24,%eax
  101d39:	0f 87 bd 00 00 00    	ja     101dfc <trap_dispatch+0xfb>
  101d3f:	83 f8 20             	cmp    $0x20,%eax
  101d42:	74 0a                	je     101d4e <trap_dispatch+0x4d>
  101d44:	83 f8 21             	cmp    $0x21,%eax
  101d47:	74 71                	je     101dba <trap_dispatch+0xb9>
  101d49:	e9 ae 00 00 00       	jmp    101dfc <trap_dispatch+0xfb>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

        extern volatile size_t ticks;
            ticks++;
  101d4e:	a1 24 c4 11 00       	mov    0x11c424,%eax
  101d53:	40                   	inc    %eax
  101d54:	a3 24 c4 11 00       	mov    %eax,0x11c424
            if (ticks % TICK_NUM == 0){
  101d59:	8b 0d 24 c4 11 00    	mov    0x11c424,%ecx
  101d5f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d64:	89 c8                	mov    %ecx,%eax
  101d66:	f7 e2                	mul    %edx
  101d68:	c1 ea 05             	shr    $0x5,%edx
  101d6b:	89 d0                	mov    %edx,%eax
  101d6d:	c1 e0 02             	shl    $0x2,%eax
  101d70:	01 d0                	add    %edx,%eax
  101d72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d79:	01 d0                	add    %edx,%eax
  101d7b:	c1 e0 02             	shl    $0x2,%eax
  101d7e:	29 c1                	sub    %eax,%ecx
  101d80:	89 ca                	mov    %ecx,%edx
  101d82:	85 d2                	test   %edx,%edx
  101d84:	0f 85 aa 00 00 00    	jne    101e34 <trap_dispatch+0x133>
                print_ticks();
  101d8a:	e8 96 fb ff ff       	call   101925 <print_ticks>
            }


            break;
  101d8f:	e9 a0 00 00 00       	jmp    101e34 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d94:	e8 2f f9 ff ff       	call   1016c8 <cons_getc>
  101d99:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d9c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dac:	c7 04 24 59 65 10 00 	movl   $0x106559,(%esp)
  101db3:	e8 9e e5 ff ff       	call   100356 <cprintf>
        break;
  101db8:	eb 7b                	jmp    101e35 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dba:	e8 09 f9 ff ff       	call   1016c8 <cons_getc>
  101dbf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dc2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dca:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dce:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd2:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  101dd9:	e8 78 e5 ff ff       	call   100356 <cprintf>
        break;
  101dde:	eb 55                	jmp    101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101de0:	c7 44 24 08 7a 65 10 	movl   $0x10657a,0x8(%esp)
  101de7:	00 
  101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101def:	00 
  101df0:	c7 04 24 8a 65 10 00 	movl   $0x10658a,(%esp)
  101df7:	e8 ec ee ff ff       	call   100ce8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e03:	83 e0 03             	and    $0x3,%eax
  101e06:	85 c0                	test   %eax,%eax
  101e08:	75 2b                	jne    101e35 <trap_dispatch+0x134>
            print_trapframe(tf);
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	89 04 24             	mov    %eax,(%esp)
  101e10:	e8 7f fc ff ff       	call   101a94 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e15:	c7 44 24 08 9b 65 10 	movl   $0x10659b,0x8(%esp)
  101e1c:	00 
  101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  101e24:	00 
  101e25:	c7 04 24 8a 65 10 00 	movl   $0x10658a,(%esp)
  101e2c:	e8 b7 ee ff ff       	call   100ce8 <__panic>
        break;
  101e31:	90                   	nop
  101e32:	eb 01                	jmp    101e35 <trap_dispatch+0x134>
            break;
  101e34:	90                   	nop
        }
    }
}
  101e35:	90                   	nop
  101e36:	89 ec                	mov    %ebp,%esp
  101e38:	5d                   	pop    %ebp
  101e39:	c3                   	ret    

00101e3a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e3a:	55                   	push   %ebp
  101e3b:	89 e5                	mov    %esp,%ebp
  101e3d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	89 04 24             	mov    %eax,(%esp)
  101e46:	e8 b6 fe ff ff       	call   101d01 <trap_dispatch>
}
  101e4b:	90                   	nop
  101e4c:	89 ec                	mov    %ebp,%esp
  101e4e:	5d                   	pop    %ebp
  101e4f:	c3                   	ret    

00101e50 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e50:	1e                   	push   %ds
    pushl %es
  101e51:	06                   	push   %es
    pushl %fs
  101e52:	0f a0                	push   %fs
    pushl %gs
  101e54:	0f a8                	push   %gs
    pushal
  101e56:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e57:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e5c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e5e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e60:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e61:	e8 d4 ff ff ff       	call   101e3a <trap>

    # pop the pushed stack pointer
    popl %esp
  101e66:	5c                   	pop    %esp

00101e67 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e67:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e68:	0f a9                	pop    %gs
    popl %fs
  101e6a:	0f a1                	pop    %fs
    popl %es
  101e6c:	07                   	pop    %es
    popl %ds
  101e6d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e6e:	83 c4 08             	add    $0x8,%esp
    iret
  101e71:	cf                   	iret   

00101e72 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $0
  101e74:	6a 00                	push   $0x0
  jmp __alltraps
  101e76:	e9 d5 ff ff ff       	jmp    101e50 <__alltraps>

00101e7b <vector1>:
.globl vector1
vector1:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $1
  101e7d:	6a 01                	push   $0x1
  jmp __alltraps
  101e7f:	e9 cc ff ff ff       	jmp    101e50 <__alltraps>

00101e84 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $2
  101e86:	6a 02                	push   $0x2
  jmp __alltraps
  101e88:	e9 c3 ff ff ff       	jmp    101e50 <__alltraps>

00101e8d <vector3>:
.globl vector3
vector3:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $3
  101e8f:	6a 03                	push   $0x3
  jmp __alltraps
  101e91:	e9 ba ff ff ff       	jmp    101e50 <__alltraps>

00101e96 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $4
  101e98:	6a 04                	push   $0x4
  jmp __alltraps
  101e9a:	e9 b1 ff ff ff       	jmp    101e50 <__alltraps>

00101e9f <vector5>:
.globl vector5
vector5:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $5
  101ea1:	6a 05                	push   $0x5
  jmp __alltraps
  101ea3:	e9 a8 ff ff ff       	jmp    101e50 <__alltraps>

00101ea8 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $6
  101eaa:	6a 06                	push   $0x6
  jmp __alltraps
  101eac:	e9 9f ff ff ff       	jmp    101e50 <__alltraps>

00101eb1 <vector7>:
.globl vector7
vector7:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $7
  101eb3:	6a 07                	push   $0x7
  jmp __alltraps
  101eb5:	e9 96 ff ff ff       	jmp    101e50 <__alltraps>

00101eba <vector8>:
.globl vector8
vector8:
  pushl $8
  101eba:	6a 08                	push   $0x8
  jmp __alltraps
  101ebc:	e9 8f ff ff ff       	jmp    101e50 <__alltraps>

00101ec1 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $9
  101ec3:	6a 09                	push   $0x9
  jmp __alltraps
  101ec5:	e9 86 ff ff ff       	jmp    101e50 <__alltraps>

00101eca <vector10>:
.globl vector10
vector10:
  pushl $10
  101eca:	6a 0a                	push   $0xa
  jmp __alltraps
  101ecc:	e9 7f ff ff ff       	jmp    101e50 <__alltraps>

00101ed1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ed1:	6a 0b                	push   $0xb
  jmp __alltraps
  101ed3:	e9 78 ff ff ff       	jmp    101e50 <__alltraps>

00101ed8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ed8:	6a 0c                	push   $0xc
  jmp __alltraps
  101eda:	e9 71 ff ff ff       	jmp    101e50 <__alltraps>

00101edf <vector13>:
.globl vector13
vector13:
  pushl $13
  101edf:	6a 0d                	push   $0xd
  jmp __alltraps
  101ee1:	e9 6a ff ff ff       	jmp    101e50 <__alltraps>

00101ee6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ee6:	6a 0e                	push   $0xe
  jmp __alltraps
  101ee8:	e9 63 ff ff ff       	jmp    101e50 <__alltraps>

00101eed <vector15>:
.globl vector15
vector15:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $15
  101eef:	6a 0f                	push   $0xf
  jmp __alltraps
  101ef1:	e9 5a ff ff ff       	jmp    101e50 <__alltraps>

00101ef6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $16
  101ef8:	6a 10                	push   $0x10
  jmp __alltraps
  101efa:	e9 51 ff ff ff       	jmp    101e50 <__alltraps>

00101eff <vector17>:
.globl vector17
vector17:
  pushl $17
  101eff:	6a 11                	push   $0x11
  jmp __alltraps
  101f01:	e9 4a ff ff ff       	jmp    101e50 <__alltraps>

00101f06 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $18
  101f08:	6a 12                	push   $0x12
  jmp __alltraps
  101f0a:	e9 41 ff ff ff       	jmp    101e50 <__alltraps>

00101f0f <vector19>:
.globl vector19
vector19:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $19
  101f11:	6a 13                	push   $0x13
  jmp __alltraps
  101f13:	e9 38 ff ff ff       	jmp    101e50 <__alltraps>

00101f18 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $20
  101f1a:	6a 14                	push   $0x14
  jmp __alltraps
  101f1c:	e9 2f ff ff ff       	jmp    101e50 <__alltraps>

00101f21 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $21
  101f23:	6a 15                	push   $0x15
  jmp __alltraps
  101f25:	e9 26 ff ff ff       	jmp    101e50 <__alltraps>

00101f2a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $22
  101f2c:	6a 16                	push   $0x16
  jmp __alltraps
  101f2e:	e9 1d ff ff ff       	jmp    101e50 <__alltraps>

00101f33 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f33:	6a 00                	push   $0x0
  pushl $23
  101f35:	6a 17                	push   $0x17
  jmp __alltraps
  101f37:	e9 14 ff ff ff       	jmp    101e50 <__alltraps>

00101f3c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f3c:	6a 00                	push   $0x0
  pushl $24
  101f3e:	6a 18                	push   $0x18
  jmp __alltraps
  101f40:	e9 0b ff ff ff       	jmp    101e50 <__alltraps>

00101f45 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $25
  101f47:	6a 19                	push   $0x19
  jmp __alltraps
  101f49:	e9 02 ff ff ff       	jmp    101e50 <__alltraps>

00101f4e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $26
  101f50:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f52:	e9 f9 fe ff ff       	jmp    101e50 <__alltraps>

00101f57 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $27
  101f59:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f5b:	e9 f0 fe ff ff       	jmp    101e50 <__alltraps>

00101f60 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $28
  101f62:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f64:	e9 e7 fe ff ff       	jmp    101e50 <__alltraps>

00101f69 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $29
  101f6b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f6d:	e9 de fe ff ff       	jmp    101e50 <__alltraps>

00101f72 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $30
  101f74:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f76:	e9 d5 fe ff ff       	jmp    101e50 <__alltraps>

00101f7b <vector31>:
.globl vector31
vector31:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $31
  101f7d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f7f:	e9 cc fe ff ff       	jmp    101e50 <__alltraps>

00101f84 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $32
  101f86:	6a 20                	push   $0x20
  jmp __alltraps
  101f88:	e9 c3 fe ff ff       	jmp    101e50 <__alltraps>

00101f8d <vector33>:
.globl vector33
vector33:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $33
  101f8f:	6a 21                	push   $0x21
  jmp __alltraps
  101f91:	e9 ba fe ff ff       	jmp    101e50 <__alltraps>

00101f96 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f96:	6a 00                	push   $0x0
  pushl $34
  101f98:	6a 22                	push   $0x22
  jmp __alltraps
  101f9a:	e9 b1 fe ff ff       	jmp    101e50 <__alltraps>

00101f9f <vector35>:
.globl vector35
vector35:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $35
  101fa1:	6a 23                	push   $0x23
  jmp __alltraps
  101fa3:	e9 a8 fe ff ff       	jmp    101e50 <__alltraps>

00101fa8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $36
  101faa:	6a 24                	push   $0x24
  jmp __alltraps
  101fac:	e9 9f fe ff ff       	jmp    101e50 <__alltraps>

00101fb1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $37
  101fb3:	6a 25                	push   $0x25
  jmp __alltraps
  101fb5:	e9 96 fe ff ff       	jmp    101e50 <__alltraps>

00101fba <vector38>:
.globl vector38
vector38:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $38
  101fbc:	6a 26                	push   $0x26
  jmp __alltraps
  101fbe:	e9 8d fe ff ff       	jmp    101e50 <__alltraps>

00101fc3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $39
  101fc5:	6a 27                	push   $0x27
  jmp __alltraps
  101fc7:	e9 84 fe ff ff       	jmp    101e50 <__alltraps>

00101fcc <vector40>:
.globl vector40
vector40:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $40
  101fce:	6a 28                	push   $0x28
  jmp __alltraps
  101fd0:	e9 7b fe ff ff       	jmp    101e50 <__alltraps>

00101fd5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $41
  101fd7:	6a 29                	push   $0x29
  jmp __alltraps
  101fd9:	e9 72 fe ff ff       	jmp    101e50 <__alltraps>

00101fde <vector42>:
.globl vector42
vector42:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $42
  101fe0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fe2:	e9 69 fe ff ff       	jmp    101e50 <__alltraps>

00101fe7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $43
  101fe9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101feb:	e9 60 fe ff ff       	jmp    101e50 <__alltraps>

00101ff0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $44
  101ff2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ff4:	e9 57 fe ff ff       	jmp    101e50 <__alltraps>

00101ff9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $45
  101ffb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ffd:	e9 4e fe ff ff       	jmp    101e50 <__alltraps>

00102002 <vector46>:
.globl vector46
vector46:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $46
  102004:	6a 2e                	push   $0x2e
  jmp __alltraps
  102006:	e9 45 fe ff ff       	jmp    101e50 <__alltraps>

0010200b <vector47>:
.globl vector47
vector47:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $47
  10200d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10200f:	e9 3c fe ff ff       	jmp    101e50 <__alltraps>

00102014 <vector48>:
.globl vector48
vector48:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $48
  102016:	6a 30                	push   $0x30
  jmp __alltraps
  102018:	e9 33 fe ff ff       	jmp    101e50 <__alltraps>

0010201d <vector49>:
.globl vector49
vector49:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $49
  10201f:	6a 31                	push   $0x31
  jmp __alltraps
  102021:	e9 2a fe ff ff       	jmp    101e50 <__alltraps>

00102026 <vector50>:
.globl vector50
vector50:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $50
  102028:	6a 32                	push   $0x32
  jmp __alltraps
  10202a:	e9 21 fe ff ff       	jmp    101e50 <__alltraps>

0010202f <vector51>:
.globl vector51
vector51:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $51
  102031:	6a 33                	push   $0x33
  jmp __alltraps
  102033:	e9 18 fe ff ff       	jmp    101e50 <__alltraps>

00102038 <vector52>:
.globl vector52
vector52:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $52
  10203a:	6a 34                	push   $0x34
  jmp __alltraps
  10203c:	e9 0f fe ff ff       	jmp    101e50 <__alltraps>

00102041 <vector53>:
.globl vector53
vector53:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $53
  102043:	6a 35                	push   $0x35
  jmp __alltraps
  102045:	e9 06 fe ff ff       	jmp    101e50 <__alltraps>

0010204a <vector54>:
.globl vector54
vector54:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $54
  10204c:	6a 36                	push   $0x36
  jmp __alltraps
  10204e:	e9 fd fd ff ff       	jmp    101e50 <__alltraps>

00102053 <vector55>:
.globl vector55
vector55:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $55
  102055:	6a 37                	push   $0x37
  jmp __alltraps
  102057:	e9 f4 fd ff ff       	jmp    101e50 <__alltraps>

0010205c <vector56>:
.globl vector56
vector56:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $56
  10205e:	6a 38                	push   $0x38
  jmp __alltraps
  102060:	e9 eb fd ff ff       	jmp    101e50 <__alltraps>

00102065 <vector57>:
.globl vector57
vector57:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $57
  102067:	6a 39                	push   $0x39
  jmp __alltraps
  102069:	e9 e2 fd ff ff       	jmp    101e50 <__alltraps>

0010206e <vector58>:
.globl vector58
vector58:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $58
  102070:	6a 3a                	push   $0x3a
  jmp __alltraps
  102072:	e9 d9 fd ff ff       	jmp    101e50 <__alltraps>

00102077 <vector59>:
.globl vector59
vector59:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $59
  102079:	6a 3b                	push   $0x3b
  jmp __alltraps
  10207b:	e9 d0 fd ff ff       	jmp    101e50 <__alltraps>

00102080 <vector60>:
.globl vector60
vector60:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $60
  102082:	6a 3c                	push   $0x3c
  jmp __alltraps
  102084:	e9 c7 fd ff ff       	jmp    101e50 <__alltraps>

00102089 <vector61>:
.globl vector61
vector61:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $61
  10208b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10208d:	e9 be fd ff ff       	jmp    101e50 <__alltraps>

00102092 <vector62>:
.globl vector62
vector62:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $62
  102094:	6a 3e                	push   $0x3e
  jmp __alltraps
  102096:	e9 b5 fd ff ff       	jmp    101e50 <__alltraps>

0010209b <vector63>:
.globl vector63
vector63:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $63
  10209d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10209f:	e9 ac fd ff ff       	jmp    101e50 <__alltraps>

001020a4 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $64
  1020a6:	6a 40                	push   $0x40
  jmp __alltraps
  1020a8:	e9 a3 fd ff ff       	jmp    101e50 <__alltraps>

001020ad <vector65>:
.globl vector65
vector65:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $65
  1020af:	6a 41                	push   $0x41
  jmp __alltraps
  1020b1:	e9 9a fd ff ff       	jmp    101e50 <__alltraps>

001020b6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $66
  1020b8:	6a 42                	push   $0x42
  jmp __alltraps
  1020ba:	e9 91 fd ff ff       	jmp    101e50 <__alltraps>

001020bf <vector67>:
.globl vector67
vector67:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $67
  1020c1:	6a 43                	push   $0x43
  jmp __alltraps
  1020c3:	e9 88 fd ff ff       	jmp    101e50 <__alltraps>

001020c8 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $68
  1020ca:	6a 44                	push   $0x44
  jmp __alltraps
  1020cc:	e9 7f fd ff ff       	jmp    101e50 <__alltraps>

001020d1 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $69
  1020d3:	6a 45                	push   $0x45
  jmp __alltraps
  1020d5:	e9 76 fd ff ff       	jmp    101e50 <__alltraps>

001020da <vector70>:
.globl vector70
vector70:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $70
  1020dc:	6a 46                	push   $0x46
  jmp __alltraps
  1020de:	e9 6d fd ff ff       	jmp    101e50 <__alltraps>

001020e3 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $71
  1020e5:	6a 47                	push   $0x47
  jmp __alltraps
  1020e7:	e9 64 fd ff ff       	jmp    101e50 <__alltraps>

001020ec <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $72
  1020ee:	6a 48                	push   $0x48
  jmp __alltraps
  1020f0:	e9 5b fd ff ff       	jmp    101e50 <__alltraps>

001020f5 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $73
  1020f7:	6a 49                	push   $0x49
  jmp __alltraps
  1020f9:	e9 52 fd ff ff       	jmp    101e50 <__alltraps>

001020fe <vector74>:
.globl vector74
vector74:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $74
  102100:	6a 4a                	push   $0x4a
  jmp __alltraps
  102102:	e9 49 fd ff ff       	jmp    101e50 <__alltraps>

00102107 <vector75>:
.globl vector75
vector75:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $75
  102109:	6a 4b                	push   $0x4b
  jmp __alltraps
  10210b:	e9 40 fd ff ff       	jmp    101e50 <__alltraps>

00102110 <vector76>:
.globl vector76
vector76:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $76
  102112:	6a 4c                	push   $0x4c
  jmp __alltraps
  102114:	e9 37 fd ff ff       	jmp    101e50 <__alltraps>

00102119 <vector77>:
.globl vector77
vector77:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $77
  10211b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10211d:	e9 2e fd ff ff       	jmp    101e50 <__alltraps>

00102122 <vector78>:
.globl vector78
vector78:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $78
  102124:	6a 4e                	push   $0x4e
  jmp __alltraps
  102126:	e9 25 fd ff ff       	jmp    101e50 <__alltraps>

0010212b <vector79>:
.globl vector79
vector79:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $79
  10212d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10212f:	e9 1c fd ff ff       	jmp    101e50 <__alltraps>

00102134 <vector80>:
.globl vector80
vector80:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $80
  102136:	6a 50                	push   $0x50
  jmp __alltraps
  102138:	e9 13 fd ff ff       	jmp    101e50 <__alltraps>

0010213d <vector81>:
.globl vector81
vector81:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $81
  10213f:	6a 51                	push   $0x51
  jmp __alltraps
  102141:	e9 0a fd ff ff       	jmp    101e50 <__alltraps>

00102146 <vector82>:
.globl vector82
vector82:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $82
  102148:	6a 52                	push   $0x52
  jmp __alltraps
  10214a:	e9 01 fd ff ff       	jmp    101e50 <__alltraps>

0010214f <vector83>:
.globl vector83
vector83:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $83
  102151:	6a 53                	push   $0x53
  jmp __alltraps
  102153:	e9 f8 fc ff ff       	jmp    101e50 <__alltraps>

00102158 <vector84>:
.globl vector84
vector84:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $84
  10215a:	6a 54                	push   $0x54
  jmp __alltraps
  10215c:	e9 ef fc ff ff       	jmp    101e50 <__alltraps>

00102161 <vector85>:
.globl vector85
vector85:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $85
  102163:	6a 55                	push   $0x55
  jmp __alltraps
  102165:	e9 e6 fc ff ff       	jmp    101e50 <__alltraps>

0010216a <vector86>:
.globl vector86
vector86:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $86
  10216c:	6a 56                	push   $0x56
  jmp __alltraps
  10216e:	e9 dd fc ff ff       	jmp    101e50 <__alltraps>

00102173 <vector87>:
.globl vector87
vector87:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $87
  102175:	6a 57                	push   $0x57
  jmp __alltraps
  102177:	e9 d4 fc ff ff       	jmp    101e50 <__alltraps>

0010217c <vector88>:
.globl vector88
vector88:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $88
  10217e:	6a 58                	push   $0x58
  jmp __alltraps
  102180:	e9 cb fc ff ff       	jmp    101e50 <__alltraps>

00102185 <vector89>:
.globl vector89
vector89:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $89
  102187:	6a 59                	push   $0x59
  jmp __alltraps
  102189:	e9 c2 fc ff ff       	jmp    101e50 <__alltraps>

0010218e <vector90>:
.globl vector90
vector90:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $90
  102190:	6a 5a                	push   $0x5a
  jmp __alltraps
  102192:	e9 b9 fc ff ff       	jmp    101e50 <__alltraps>

00102197 <vector91>:
.globl vector91
vector91:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $91
  102199:	6a 5b                	push   $0x5b
  jmp __alltraps
  10219b:	e9 b0 fc ff ff       	jmp    101e50 <__alltraps>

001021a0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $92
  1021a2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021a4:	e9 a7 fc ff ff       	jmp    101e50 <__alltraps>

001021a9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $93
  1021ab:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021ad:	e9 9e fc ff ff       	jmp    101e50 <__alltraps>

001021b2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $94
  1021b4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021b6:	e9 95 fc ff ff       	jmp    101e50 <__alltraps>

001021bb <vector95>:
.globl vector95
vector95:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $95
  1021bd:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021bf:	e9 8c fc ff ff       	jmp    101e50 <__alltraps>

001021c4 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $96
  1021c6:	6a 60                	push   $0x60
  jmp __alltraps
  1021c8:	e9 83 fc ff ff       	jmp    101e50 <__alltraps>

001021cd <vector97>:
.globl vector97
vector97:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $97
  1021cf:	6a 61                	push   $0x61
  jmp __alltraps
  1021d1:	e9 7a fc ff ff       	jmp    101e50 <__alltraps>

001021d6 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $98
  1021d8:	6a 62                	push   $0x62
  jmp __alltraps
  1021da:	e9 71 fc ff ff       	jmp    101e50 <__alltraps>

001021df <vector99>:
.globl vector99
vector99:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $99
  1021e1:	6a 63                	push   $0x63
  jmp __alltraps
  1021e3:	e9 68 fc ff ff       	jmp    101e50 <__alltraps>

001021e8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $100
  1021ea:	6a 64                	push   $0x64
  jmp __alltraps
  1021ec:	e9 5f fc ff ff       	jmp    101e50 <__alltraps>

001021f1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $101
  1021f3:	6a 65                	push   $0x65
  jmp __alltraps
  1021f5:	e9 56 fc ff ff       	jmp    101e50 <__alltraps>

001021fa <vector102>:
.globl vector102
vector102:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $102
  1021fc:	6a 66                	push   $0x66
  jmp __alltraps
  1021fe:	e9 4d fc ff ff       	jmp    101e50 <__alltraps>

00102203 <vector103>:
.globl vector103
vector103:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $103
  102205:	6a 67                	push   $0x67
  jmp __alltraps
  102207:	e9 44 fc ff ff       	jmp    101e50 <__alltraps>

0010220c <vector104>:
.globl vector104
vector104:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $104
  10220e:	6a 68                	push   $0x68
  jmp __alltraps
  102210:	e9 3b fc ff ff       	jmp    101e50 <__alltraps>

00102215 <vector105>:
.globl vector105
vector105:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $105
  102217:	6a 69                	push   $0x69
  jmp __alltraps
  102219:	e9 32 fc ff ff       	jmp    101e50 <__alltraps>

0010221e <vector106>:
.globl vector106
vector106:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $106
  102220:	6a 6a                	push   $0x6a
  jmp __alltraps
  102222:	e9 29 fc ff ff       	jmp    101e50 <__alltraps>

00102227 <vector107>:
.globl vector107
vector107:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $107
  102229:	6a 6b                	push   $0x6b
  jmp __alltraps
  10222b:	e9 20 fc ff ff       	jmp    101e50 <__alltraps>

00102230 <vector108>:
.globl vector108
vector108:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $108
  102232:	6a 6c                	push   $0x6c
  jmp __alltraps
  102234:	e9 17 fc ff ff       	jmp    101e50 <__alltraps>

00102239 <vector109>:
.globl vector109
vector109:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $109
  10223b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10223d:	e9 0e fc ff ff       	jmp    101e50 <__alltraps>

00102242 <vector110>:
.globl vector110
vector110:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $110
  102244:	6a 6e                	push   $0x6e
  jmp __alltraps
  102246:	e9 05 fc ff ff       	jmp    101e50 <__alltraps>

0010224b <vector111>:
.globl vector111
vector111:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $111
  10224d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10224f:	e9 fc fb ff ff       	jmp    101e50 <__alltraps>

00102254 <vector112>:
.globl vector112
vector112:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $112
  102256:	6a 70                	push   $0x70
  jmp __alltraps
  102258:	e9 f3 fb ff ff       	jmp    101e50 <__alltraps>

0010225d <vector113>:
.globl vector113
vector113:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $113
  10225f:	6a 71                	push   $0x71
  jmp __alltraps
  102261:	e9 ea fb ff ff       	jmp    101e50 <__alltraps>

00102266 <vector114>:
.globl vector114
vector114:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $114
  102268:	6a 72                	push   $0x72
  jmp __alltraps
  10226a:	e9 e1 fb ff ff       	jmp    101e50 <__alltraps>

0010226f <vector115>:
.globl vector115
vector115:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $115
  102271:	6a 73                	push   $0x73
  jmp __alltraps
  102273:	e9 d8 fb ff ff       	jmp    101e50 <__alltraps>

00102278 <vector116>:
.globl vector116
vector116:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $116
  10227a:	6a 74                	push   $0x74
  jmp __alltraps
  10227c:	e9 cf fb ff ff       	jmp    101e50 <__alltraps>

00102281 <vector117>:
.globl vector117
vector117:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $117
  102283:	6a 75                	push   $0x75
  jmp __alltraps
  102285:	e9 c6 fb ff ff       	jmp    101e50 <__alltraps>

0010228a <vector118>:
.globl vector118
vector118:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $118
  10228c:	6a 76                	push   $0x76
  jmp __alltraps
  10228e:	e9 bd fb ff ff       	jmp    101e50 <__alltraps>

00102293 <vector119>:
.globl vector119
vector119:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $119
  102295:	6a 77                	push   $0x77
  jmp __alltraps
  102297:	e9 b4 fb ff ff       	jmp    101e50 <__alltraps>

0010229c <vector120>:
.globl vector120
vector120:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $120
  10229e:	6a 78                	push   $0x78
  jmp __alltraps
  1022a0:	e9 ab fb ff ff       	jmp    101e50 <__alltraps>

001022a5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $121
  1022a7:	6a 79                	push   $0x79
  jmp __alltraps
  1022a9:	e9 a2 fb ff ff       	jmp    101e50 <__alltraps>

001022ae <vector122>:
.globl vector122
vector122:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $122
  1022b0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022b2:	e9 99 fb ff ff       	jmp    101e50 <__alltraps>

001022b7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $123
  1022b9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022bb:	e9 90 fb ff ff       	jmp    101e50 <__alltraps>

001022c0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $124
  1022c2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022c4:	e9 87 fb ff ff       	jmp    101e50 <__alltraps>

001022c9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $125
  1022cb:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022cd:	e9 7e fb ff ff       	jmp    101e50 <__alltraps>

001022d2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $126
  1022d4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022d6:	e9 75 fb ff ff       	jmp    101e50 <__alltraps>

001022db <vector127>:
.globl vector127
vector127:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $127
  1022dd:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022df:	e9 6c fb ff ff       	jmp    101e50 <__alltraps>

001022e4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $128
  1022e6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022eb:	e9 60 fb ff ff       	jmp    101e50 <__alltraps>

001022f0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $129
  1022f2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022f7:	e9 54 fb ff ff       	jmp    101e50 <__alltraps>

001022fc <vector130>:
.globl vector130
vector130:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $130
  1022fe:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102303:	e9 48 fb ff ff       	jmp    101e50 <__alltraps>

00102308 <vector131>:
.globl vector131
vector131:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $131
  10230a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10230f:	e9 3c fb ff ff       	jmp    101e50 <__alltraps>

00102314 <vector132>:
.globl vector132
vector132:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $132
  102316:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10231b:	e9 30 fb ff ff       	jmp    101e50 <__alltraps>

00102320 <vector133>:
.globl vector133
vector133:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $133
  102322:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102327:	e9 24 fb ff ff       	jmp    101e50 <__alltraps>

0010232c <vector134>:
.globl vector134
vector134:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $134
  10232e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102333:	e9 18 fb ff ff       	jmp    101e50 <__alltraps>

00102338 <vector135>:
.globl vector135
vector135:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $135
  10233a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10233f:	e9 0c fb ff ff       	jmp    101e50 <__alltraps>

00102344 <vector136>:
.globl vector136
vector136:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $136
  102346:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10234b:	e9 00 fb ff ff       	jmp    101e50 <__alltraps>

00102350 <vector137>:
.globl vector137
vector137:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $137
  102352:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102357:	e9 f4 fa ff ff       	jmp    101e50 <__alltraps>

0010235c <vector138>:
.globl vector138
vector138:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $138
  10235e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102363:	e9 e8 fa ff ff       	jmp    101e50 <__alltraps>

00102368 <vector139>:
.globl vector139
vector139:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $139
  10236a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10236f:	e9 dc fa ff ff       	jmp    101e50 <__alltraps>

00102374 <vector140>:
.globl vector140
vector140:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $140
  102376:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10237b:	e9 d0 fa ff ff       	jmp    101e50 <__alltraps>

00102380 <vector141>:
.globl vector141
vector141:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $141
  102382:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102387:	e9 c4 fa ff ff       	jmp    101e50 <__alltraps>

0010238c <vector142>:
.globl vector142
vector142:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $142
  10238e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102393:	e9 b8 fa ff ff       	jmp    101e50 <__alltraps>

00102398 <vector143>:
.globl vector143
vector143:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $143
  10239a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10239f:	e9 ac fa ff ff       	jmp    101e50 <__alltraps>

001023a4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $144
  1023a6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023ab:	e9 a0 fa ff ff       	jmp    101e50 <__alltraps>

001023b0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $145
  1023b2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023b7:	e9 94 fa ff ff       	jmp    101e50 <__alltraps>

001023bc <vector146>:
.globl vector146
vector146:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $146
  1023be:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023c3:	e9 88 fa ff ff       	jmp    101e50 <__alltraps>

001023c8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $147
  1023ca:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023cf:	e9 7c fa ff ff       	jmp    101e50 <__alltraps>

001023d4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $148
  1023d6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023db:	e9 70 fa ff ff       	jmp    101e50 <__alltraps>

001023e0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $149
  1023e2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023e7:	e9 64 fa ff ff       	jmp    101e50 <__alltraps>

001023ec <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $150
  1023ee:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023f3:	e9 58 fa ff ff       	jmp    101e50 <__alltraps>

001023f8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $151
  1023fa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023ff:	e9 4c fa ff ff       	jmp    101e50 <__alltraps>

00102404 <vector152>:
.globl vector152
vector152:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $152
  102406:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10240b:	e9 40 fa ff ff       	jmp    101e50 <__alltraps>

00102410 <vector153>:
.globl vector153
vector153:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $153
  102412:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102417:	e9 34 fa ff ff       	jmp    101e50 <__alltraps>

0010241c <vector154>:
.globl vector154
vector154:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $154
  10241e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102423:	e9 28 fa ff ff       	jmp    101e50 <__alltraps>

00102428 <vector155>:
.globl vector155
vector155:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $155
  10242a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10242f:	e9 1c fa ff ff       	jmp    101e50 <__alltraps>

00102434 <vector156>:
.globl vector156
vector156:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $156
  102436:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10243b:	e9 10 fa ff ff       	jmp    101e50 <__alltraps>

00102440 <vector157>:
.globl vector157
vector157:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $157
  102442:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102447:	e9 04 fa ff ff       	jmp    101e50 <__alltraps>

0010244c <vector158>:
.globl vector158
vector158:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $158
  10244e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102453:	e9 f8 f9 ff ff       	jmp    101e50 <__alltraps>

00102458 <vector159>:
.globl vector159
vector159:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $159
  10245a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10245f:	e9 ec f9 ff ff       	jmp    101e50 <__alltraps>

00102464 <vector160>:
.globl vector160
vector160:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $160
  102466:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10246b:	e9 e0 f9 ff ff       	jmp    101e50 <__alltraps>

00102470 <vector161>:
.globl vector161
vector161:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $161
  102472:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102477:	e9 d4 f9 ff ff       	jmp    101e50 <__alltraps>

0010247c <vector162>:
.globl vector162
vector162:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $162
  10247e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102483:	e9 c8 f9 ff ff       	jmp    101e50 <__alltraps>

00102488 <vector163>:
.globl vector163
vector163:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $163
  10248a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10248f:	e9 bc f9 ff ff       	jmp    101e50 <__alltraps>

00102494 <vector164>:
.globl vector164
vector164:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $164
  102496:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10249b:	e9 b0 f9 ff ff       	jmp    101e50 <__alltraps>

001024a0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $165
  1024a2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024a7:	e9 a4 f9 ff ff       	jmp    101e50 <__alltraps>

001024ac <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $166
  1024ae:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024b3:	e9 98 f9 ff ff       	jmp    101e50 <__alltraps>

001024b8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $167
  1024ba:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024bf:	e9 8c f9 ff ff       	jmp    101e50 <__alltraps>

001024c4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $168
  1024c6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024cb:	e9 80 f9 ff ff       	jmp    101e50 <__alltraps>

001024d0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $169
  1024d2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024d7:	e9 74 f9 ff ff       	jmp    101e50 <__alltraps>

001024dc <vector170>:
.globl vector170
vector170:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $170
  1024de:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024e3:	e9 68 f9 ff ff       	jmp    101e50 <__alltraps>

001024e8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $171
  1024ea:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024ef:	e9 5c f9 ff ff       	jmp    101e50 <__alltraps>

001024f4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $172
  1024f6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024fb:	e9 50 f9 ff ff       	jmp    101e50 <__alltraps>

00102500 <vector173>:
.globl vector173
vector173:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $173
  102502:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102507:	e9 44 f9 ff ff       	jmp    101e50 <__alltraps>

0010250c <vector174>:
.globl vector174
vector174:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $174
  10250e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102513:	e9 38 f9 ff ff       	jmp    101e50 <__alltraps>

00102518 <vector175>:
.globl vector175
vector175:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $175
  10251a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10251f:	e9 2c f9 ff ff       	jmp    101e50 <__alltraps>

00102524 <vector176>:
.globl vector176
vector176:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $176
  102526:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10252b:	e9 20 f9 ff ff       	jmp    101e50 <__alltraps>

00102530 <vector177>:
.globl vector177
vector177:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $177
  102532:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102537:	e9 14 f9 ff ff       	jmp    101e50 <__alltraps>

0010253c <vector178>:
.globl vector178
vector178:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $178
  10253e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102543:	e9 08 f9 ff ff       	jmp    101e50 <__alltraps>

00102548 <vector179>:
.globl vector179
vector179:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $179
  10254a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10254f:	e9 fc f8 ff ff       	jmp    101e50 <__alltraps>

00102554 <vector180>:
.globl vector180
vector180:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $180
  102556:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10255b:	e9 f0 f8 ff ff       	jmp    101e50 <__alltraps>

00102560 <vector181>:
.globl vector181
vector181:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $181
  102562:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102567:	e9 e4 f8 ff ff       	jmp    101e50 <__alltraps>

0010256c <vector182>:
.globl vector182
vector182:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $182
  10256e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102573:	e9 d8 f8 ff ff       	jmp    101e50 <__alltraps>

00102578 <vector183>:
.globl vector183
vector183:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $183
  10257a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10257f:	e9 cc f8 ff ff       	jmp    101e50 <__alltraps>

00102584 <vector184>:
.globl vector184
vector184:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $184
  102586:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10258b:	e9 c0 f8 ff ff       	jmp    101e50 <__alltraps>

00102590 <vector185>:
.globl vector185
vector185:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $185
  102592:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102597:	e9 b4 f8 ff ff       	jmp    101e50 <__alltraps>

0010259c <vector186>:
.globl vector186
vector186:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $186
  10259e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025a3:	e9 a8 f8 ff ff       	jmp    101e50 <__alltraps>

001025a8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $187
  1025aa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025af:	e9 9c f8 ff ff       	jmp    101e50 <__alltraps>

001025b4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $188
  1025b6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025bb:	e9 90 f8 ff ff       	jmp    101e50 <__alltraps>

001025c0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $189
  1025c2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025c7:	e9 84 f8 ff ff       	jmp    101e50 <__alltraps>

001025cc <vector190>:
.globl vector190
vector190:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $190
  1025ce:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025d3:	e9 78 f8 ff ff       	jmp    101e50 <__alltraps>

001025d8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $191
  1025da:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025df:	e9 6c f8 ff ff       	jmp    101e50 <__alltraps>

001025e4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $192
  1025e6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025eb:	e9 60 f8 ff ff       	jmp    101e50 <__alltraps>

001025f0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $193
  1025f2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025f7:	e9 54 f8 ff ff       	jmp    101e50 <__alltraps>

001025fc <vector194>:
.globl vector194
vector194:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $194
  1025fe:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102603:	e9 48 f8 ff ff       	jmp    101e50 <__alltraps>

00102608 <vector195>:
.globl vector195
vector195:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $195
  10260a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10260f:	e9 3c f8 ff ff       	jmp    101e50 <__alltraps>

00102614 <vector196>:
.globl vector196
vector196:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $196
  102616:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10261b:	e9 30 f8 ff ff       	jmp    101e50 <__alltraps>

00102620 <vector197>:
.globl vector197
vector197:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $197
  102622:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102627:	e9 24 f8 ff ff       	jmp    101e50 <__alltraps>

0010262c <vector198>:
.globl vector198
vector198:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $198
  10262e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102633:	e9 18 f8 ff ff       	jmp    101e50 <__alltraps>

00102638 <vector199>:
.globl vector199
vector199:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $199
  10263a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10263f:	e9 0c f8 ff ff       	jmp    101e50 <__alltraps>

00102644 <vector200>:
.globl vector200
vector200:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $200
  102646:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10264b:	e9 00 f8 ff ff       	jmp    101e50 <__alltraps>

00102650 <vector201>:
.globl vector201
vector201:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $201
  102652:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102657:	e9 f4 f7 ff ff       	jmp    101e50 <__alltraps>

0010265c <vector202>:
.globl vector202
vector202:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $202
  10265e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102663:	e9 e8 f7 ff ff       	jmp    101e50 <__alltraps>

00102668 <vector203>:
.globl vector203
vector203:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $203
  10266a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10266f:	e9 dc f7 ff ff       	jmp    101e50 <__alltraps>

00102674 <vector204>:
.globl vector204
vector204:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $204
  102676:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10267b:	e9 d0 f7 ff ff       	jmp    101e50 <__alltraps>

00102680 <vector205>:
.globl vector205
vector205:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $205
  102682:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102687:	e9 c4 f7 ff ff       	jmp    101e50 <__alltraps>

0010268c <vector206>:
.globl vector206
vector206:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $206
  10268e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102693:	e9 b8 f7 ff ff       	jmp    101e50 <__alltraps>

00102698 <vector207>:
.globl vector207
vector207:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $207
  10269a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10269f:	e9 ac f7 ff ff       	jmp    101e50 <__alltraps>

001026a4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $208
  1026a6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026ab:	e9 a0 f7 ff ff       	jmp    101e50 <__alltraps>

001026b0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $209
  1026b2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026b7:	e9 94 f7 ff ff       	jmp    101e50 <__alltraps>

001026bc <vector210>:
.globl vector210
vector210:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $210
  1026be:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026c3:	e9 88 f7 ff ff       	jmp    101e50 <__alltraps>

001026c8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $211
  1026ca:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026cf:	e9 7c f7 ff ff       	jmp    101e50 <__alltraps>

001026d4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $212
  1026d6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026db:	e9 70 f7 ff ff       	jmp    101e50 <__alltraps>

001026e0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $213
  1026e2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026e7:	e9 64 f7 ff ff       	jmp    101e50 <__alltraps>

001026ec <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $214
  1026ee:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026f3:	e9 58 f7 ff ff       	jmp    101e50 <__alltraps>

001026f8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $215
  1026fa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026ff:	e9 4c f7 ff ff       	jmp    101e50 <__alltraps>

00102704 <vector216>:
.globl vector216
vector216:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $216
  102706:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10270b:	e9 40 f7 ff ff       	jmp    101e50 <__alltraps>

00102710 <vector217>:
.globl vector217
vector217:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $217
  102712:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102717:	e9 34 f7 ff ff       	jmp    101e50 <__alltraps>

0010271c <vector218>:
.globl vector218
vector218:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $218
  10271e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102723:	e9 28 f7 ff ff       	jmp    101e50 <__alltraps>

00102728 <vector219>:
.globl vector219
vector219:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $219
  10272a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10272f:	e9 1c f7 ff ff       	jmp    101e50 <__alltraps>

00102734 <vector220>:
.globl vector220
vector220:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $220
  102736:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10273b:	e9 10 f7 ff ff       	jmp    101e50 <__alltraps>

00102740 <vector221>:
.globl vector221
vector221:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $221
  102742:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102747:	e9 04 f7 ff ff       	jmp    101e50 <__alltraps>

0010274c <vector222>:
.globl vector222
vector222:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $222
  10274e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102753:	e9 f8 f6 ff ff       	jmp    101e50 <__alltraps>

00102758 <vector223>:
.globl vector223
vector223:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $223
  10275a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10275f:	e9 ec f6 ff ff       	jmp    101e50 <__alltraps>

00102764 <vector224>:
.globl vector224
vector224:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $224
  102766:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10276b:	e9 e0 f6 ff ff       	jmp    101e50 <__alltraps>

00102770 <vector225>:
.globl vector225
vector225:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $225
  102772:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102777:	e9 d4 f6 ff ff       	jmp    101e50 <__alltraps>

0010277c <vector226>:
.globl vector226
vector226:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $226
  10277e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102783:	e9 c8 f6 ff ff       	jmp    101e50 <__alltraps>

00102788 <vector227>:
.globl vector227
vector227:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $227
  10278a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10278f:	e9 bc f6 ff ff       	jmp    101e50 <__alltraps>

00102794 <vector228>:
.globl vector228
vector228:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $228
  102796:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10279b:	e9 b0 f6 ff ff       	jmp    101e50 <__alltraps>

001027a0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $229
  1027a2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027a7:	e9 a4 f6 ff ff       	jmp    101e50 <__alltraps>

001027ac <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $230
  1027ae:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027b3:	e9 98 f6 ff ff       	jmp    101e50 <__alltraps>

001027b8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $231
  1027ba:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027bf:	e9 8c f6 ff ff       	jmp    101e50 <__alltraps>

001027c4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $232
  1027c6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027cb:	e9 80 f6 ff ff       	jmp    101e50 <__alltraps>

001027d0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $233
  1027d2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027d7:	e9 74 f6 ff ff       	jmp    101e50 <__alltraps>

001027dc <vector234>:
.globl vector234
vector234:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $234
  1027de:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027e3:	e9 68 f6 ff ff       	jmp    101e50 <__alltraps>

001027e8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $235
  1027ea:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027ef:	e9 5c f6 ff ff       	jmp    101e50 <__alltraps>

001027f4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $236
  1027f6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027fb:	e9 50 f6 ff ff       	jmp    101e50 <__alltraps>

00102800 <vector237>:
.globl vector237
vector237:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $237
  102802:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102807:	e9 44 f6 ff ff       	jmp    101e50 <__alltraps>

0010280c <vector238>:
.globl vector238
vector238:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $238
  10280e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102813:	e9 38 f6 ff ff       	jmp    101e50 <__alltraps>

00102818 <vector239>:
.globl vector239
vector239:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $239
  10281a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10281f:	e9 2c f6 ff ff       	jmp    101e50 <__alltraps>

00102824 <vector240>:
.globl vector240
vector240:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $240
  102826:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10282b:	e9 20 f6 ff ff       	jmp    101e50 <__alltraps>

00102830 <vector241>:
.globl vector241
vector241:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $241
  102832:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102837:	e9 14 f6 ff ff       	jmp    101e50 <__alltraps>

0010283c <vector242>:
.globl vector242
vector242:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $242
  10283e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102843:	e9 08 f6 ff ff       	jmp    101e50 <__alltraps>

00102848 <vector243>:
.globl vector243
vector243:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $243
  10284a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10284f:	e9 fc f5 ff ff       	jmp    101e50 <__alltraps>

00102854 <vector244>:
.globl vector244
vector244:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $244
  102856:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10285b:	e9 f0 f5 ff ff       	jmp    101e50 <__alltraps>

00102860 <vector245>:
.globl vector245
vector245:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $245
  102862:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102867:	e9 e4 f5 ff ff       	jmp    101e50 <__alltraps>

0010286c <vector246>:
.globl vector246
vector246:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $246
  10286e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102873:	e9 d8 f5 ff ff       	jmp    101e50 <__alltraps>

00102878 <vector247>:
.globl vector247
vector247:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $247
  10287a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10287f:	e9 cc f5 ff ff       	jmp    101e50 <__alltraps>

00102884 <vector248>:
.globl vector248
vector248:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $248
  102886:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10288b:	e9 c0 f5 ff ff       	jmp    101e50 <__alltraps>

00102890 <vector249>:
.globl vector249
vector249:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $249
  102892:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102897:	e9 b4 f5 ff ff       	jmp    101e50 <__alltraps>

0010289c <vector250>:
.globl vector250
vector250:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $250
  10289e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028a3:	e9 a8 f5 ff ff       	jmp    101e50 <__alltraps>

001028a8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $251
  1028aa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028af:	e9 9c f5 ff ff       	jmp    101e50 <__alltraps>

001028b4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $252
  1028b6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028bb:	e9 90 f5 ff ff       	jmp    101e50 <__alltraps>

001028c0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $253
  1028c2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028c7:	e9 84 f5 ff ff       	jmp    101e50 <__alltraps>

001028cc <vector254>:
.globl vector254
vector254:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $254
  1028ce:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028d3:	e9 78 f5 ff ff       	jmp    101e50 <__alltraps>

001028d8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $255
  1028da:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028df:	e9 6c f5 ff ff       	jmp    101e50 <__alltraps>

001028e4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028e4:	55                   	push   %ebp
  1028e5:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028e7:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  1028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f0:	29 d0                	sub    %edx,%eax
  1028f2:	c1 f8 02             	sar    $0x2,%eax
  1028f5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028fb:	5d                   	pop    %ebp
  1028fc:	c3                   	ret    

001028fd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028fd:	55                   	push   %ebp
  1028fe:	89 e5                	mov    %esp,%ebp
  102900:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102903:	8b 45 08             	mov    0x8(%ebp),%eax
  102906:	89 04 24             	mov    %eax,(%esp)
  102909:	e8 d6 ff ff ff       	call   1028e4 <page2ppn>
  10290e:	c1 e0 0c             	shl    $0xc,%eax
}
  102911:	89 ec                	mov    %ebp,%esp
  102913:	5d                   	pop    %ebp
  102914:	c3                   	ret    

00102915 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102915:	55                   	push   %ebp
  102916:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102918:	8b 45 08             	mov    0x8(%ebp),%eax
  10291b:	8b 00                	mov    (%eax),%eax
}
  10291d:	5d                   	pop    %ebp
  10291e:	c3                   	ret    

0010291f <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10291f:	55                   	push   %ebp
  102920:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102922:	8b 45 08             	mov    0x8(%ebp),%eax
  102925:	8b 55 0c             	mov    0xc(%ebp),%edx
  102928:	89 10                	mov    %edx,(%eax)
}
  10292a:	90                   	nop
  10292b:	5d                   	pop    %ebp
  10292c:	c3                   	ret    

0010292d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10292d:	55                   	push   %ebp
  10292e:	89 e5                	mov    %esp,%ebp
  102930:	83 ec 10             	sub    $0x10,%esp
  102933:	c7 45 fc 80 ce 11 00 	movl   $0x11ce80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10293a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102940:	89 50 04             	mov    %edx,0x4(%eax)
  102943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102946:	8b 50 04             	mov    0x4(%eax),%edx
  102949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10294c:	89 10                	mov    %edx,(%eax)
}
  10294e:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  10294f:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  102956:	00 00 00 
}
  102959:	90                   	nop
  10295a:	89 ec                	mov    %ebp,%esp
  10295c:	5d                   	pop    %ebp
  10295d:	c3                   	ret    

0010295e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10295e:	55                   	push   %ebp
  10295f:	89 e5                	mov    %esp,%ebp
  102961:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102968:	75 24                	jne    10298e <default_init_memmap+0x30>
  10296a:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  102971:	00 
  102972:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102979:	00 
  10297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102981:	00 
  102982:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102989:	e8 5a e3 ff ff       	call   100ce8 <__panic>
    struct Page *p = base;
  10298e:	8b 45 08             	mov    0x8(%ebp),%eax
  102991:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++) {
  102994:	eb 7d                	jmp    102a13 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102999:	83 c0 04             	add    $0x4,%eax
  10299c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029ac:	0f a3 10             	bt     %edx,(%eax)
  1029af:	19 c0                	sbb    %eax,%eax
  1029b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029b8:	0f 95 c0             	setne  %al
  1029bb:	0f b6 c0             	movzbl %al,%eax
  1029be:	85 c0                	test   %eax,%eax
  1029c0:	75 24                	jne    1029e6 <default_init_memmap+0x88>
  1029c2:	c7 44 24 0c 81 67 10 	movl   $0x106781,0xc(%esp)
  1029c9:	00 
  1029ca:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1029d1:	00 
  1029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1029d9:	00 
  1029da:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1029e1:	e8 02 e3 ff ff       	call   100ce8 <__panic>
        p->flags = p->property = 0;
  1029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f3:	8b 50 08             	mov    0x8(%eax),%edx
  1029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f9:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a03:	00 
  102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a07:	89 04 24             	mov    %eax,(%esp)
  102a0a:	e8 10 ff ff ff       	call   10291f <set_page_ref>
    for (; p != base + n; p++) {
  102a0f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a16:	89 d0                	mov    %edx,%eax
  102a18:	c1 e0 02             	shl    $0x2,%eax
  102a1b:	01 d0                	add    %edx,%eax
  102a1d:	c1 e0 02             	shl    $0x2,%eax
  102a20:	89 c2                	mov    %eax,%edx
  102a22:	8b 45 08             	mov    0x8(%ebp),%eax
  102a25:	01 d0                	add    %edx,%eax
  102a27:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102a2a:	0f 85 66 ff ff ff    	jne    102996 <default_init_memmap+0x38>
    }
    base->property = n;
  102a30:	8b 45 08             	mov    0x8(%ebp),%eax
  102a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a36:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a39:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3c:	83 c0 04             	add    $0x4,%eax
  102a3f:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102a46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a4c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a4f:	0f ab 10             	bts    %edx,(%eax)
}
  102a52:	90                   	nop
    nr_free += n;
  102a53:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a5c:	01 d0                	add    %edx,%eax
  102a5e:	a3 88 ce 11 00       	mov    %eax,0x11ce88
    list_add(&free_list, &(base->page_link));
  102a63:	8b 45 08             	mov    0x8(%ebp),%eax
  102a66:	83 c0 0c             	add    $0xc,%eax
  102a69:	c7 45 e4 80 ce 11 00 	movl   $0x11ce80,-0x1c(%ebp)
  102a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a76:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a82:	8b 40 04             	mov    0x4(%eax),%eax
  102a85:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a8e:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102a91:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a9a:	89 10                	mov    %edx,(%eax)
  102a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a9f:	8b 10                	mov    (%eax),%edx
  102aa1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aa4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102aaa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102aad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ab0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ab3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102ab6:	89 10                	mov    %edx,(%eax)
}
  102ab8:	90                   	nop
}
  102ab9:	90                   	nop
}
  102aba:	90                   	nop
}
  102abb:	90                   	nop
  102abc:	89 ec                	mov    %ebp,%esp
  102abe:	5d                   	pop    %ebp
  102abf:	c3                   	ret    

00102ac0 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102ac0:	55                   	push   %ebp
  102ac1:	89 e5                	mov    %esp,%ebp
  102ac3:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aca:	75 24                	jne    102af0 <default_alloc_pages+0x30>
  102acc:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  102ad3:	00 
  102ad4:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102adb:	00 
  102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102ae3:	00 
  102ae4:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102aeb:	e8 f8 e1 ff ff       	call   100ce8 <__panic>
    if (n > nr_free) {
  102af0:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102af5:	39 45 08             	cmp    %eax,0x8(%ebp)
  102af8:	76 0a                	jbe    102b04 <default_alloc_pages+0x44>
        return NULL;
  102afa:	b8 00 00 00 00       	mov    $0x0,%eax
  102aff:	e9 4e 01 00 00       	jmp    102c52 <default_alloc_pages+0x192>
    }
    struct Page *page = NULL;
  102b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b0b:	c7 45 f0 80 ce 11 00 	movl   $0x11ce80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102b12:	eb 1c                	jmp    102b30 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b17:	83 e8 0c             	sub    $0xc,%eax
  102b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b20:	8b 40 08             	mov    0x8(%eax),%eax
  102b23:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b26:	77 08                	ja     102b30 <default_alloc_pages+0x70>
            page = p;
  102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b2e:	eb 18                	jmp    102b48 <default_alloc_pages+0x88>
  102b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b39:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  102b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b3f:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102b46:	75 cc                	jne    102b14 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  102b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b4c:	0f 84 fd 00 00 00    	je     102c4f <default_alloc_pages+0x18f>

        if (page->property > n) {
  102b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b55:	8b 40 08             	mov    0x8(%eax),%eax
  102b58:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b5b:	0f 83 9a 00 00 00    	jae    102bfb <default_alloc_pages+0x13b>
            struct Page *p = page + n;
  102b61:	8b 55 08             	mov    0x8(%ebp),%edx
  102b64:	89 d0                	mov    %edx,%eax
  102b66:	c1 e0 02             	shl    $0x2,%eax
  102b69:	01 d0                	add    %edx,%eax
  102b6b:	c1 e0 02             	shl    $0x2,%eax
  102b6e:	89 c2                	mov    %eax,%edx
  102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b73:	01 d0                	add    %edx,%eax
  102b75:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7b:	8b 40 08             	mov    0x8(%eax),%eax
  102b7e:	2b 45 08             	sub    0x8(%ebp),%eax
  102b81:	89 c2                	mov    %eax,%edx
  102b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b86:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8c:	83 c0 04             	add    $0x4,%eax
  102b8f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102b96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b99:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b9c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b9f:	0f ab 10             	bts    %edx,(%eax)
}
  102ba2:	90                   	nop
            list_add(&free_list, &(p->page_link)); //?
  102ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba6:	83 c0 0c             	add    $0xc,%eax
  102ba9:	c7 45 e0 80 ce 11 00 	movl   $0x11ce80,-0x20(%ebp)
  102bb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  102bbf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bc2:	8b 40 04             	mov    0x4(%eax),%eax
  102bc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102bc8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102bcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bce:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102bd1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  102bd4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102bd7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102bda:	89 10                	mov    %edx,(%eax)
  102bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102bdf:	8b 10                	mov    (%eax),%edx
  102be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102be4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102be7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102bed:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bf3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bf6:	89 10                	mov    %edx,(%eax)
}
  102bf8:	90                   	nop
}
  102bf9:	90                   	nop
}
  102bfa:	90                   	nop
        }
        list_del(&(page->page_link));
  102bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bfe:	83 c0 0c             	add    $0xc,%eax
  102c01:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102c04:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c07:	8b 40 04             	mov    0x4(%eax),%eax
  102c0a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102c0d:	8b 12                	mov    (%edx),%edx
  102c0f:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102c12:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c15:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c18:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c1b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c1e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102c21:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c24:	89 10                	mov    %edx,(%eax)
}
  102c26:	90                   	nop
}
  102c27:	90                   	nop
        nr_free -= n;
  102c28:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102c2d:	2b 45 08             	sub    0x8(%ebp),%eax
  102c30:	a3 88 ce 11 00       	mov    %eax,0x11ce88
        ClearPageProperty(page);
  102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c38:	83 c0 04             	add    $0x4,%eax
  102c3b:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102c42:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c45:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102c48:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c4b:	0f b3 10             	btr    %edx,(%eax)
}
  102c4e:	90                   	nop
    }
    return page;
  102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c52:	89 ec                	mov    %ebp,%esp
  102c54:	5d                   	pop    %ebp
  102c55:	c3                   	ret    

00102c56 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c56:	55                   	push   %ebp
  102c57:	89 e5                	mov    %esp,%ebp
  102c59:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  102c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c63:	75 24                	jne    102c89 <default_free_pages+0x33>
  102c65:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  102c6c:	00 
  102c6d:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102c74:	00 
  102c75:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  102c7c:	00 
  102c7d:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102c84:	e8 5f e0 ff ff       	call   100ce8 <__panic>
  102c89:	c7 45 e4 80 ce 11 00 	movl   $0x11ce80,-0x1c(%ebp)
    return listelm->next;
  102c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c93:	8b 40 04             	mov    0x4(%eax),%eax
    struct Page *p1;

    list_entry_t *le1 = list_next(&free_list);
  102c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
  102c99:	eb 32                	jmp    102ccd <default_free_pages+0x77>
        p1 = le2page(le1, page_link);
  102c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9e:	83 e8 0c             	sub    $0xc,%eax
  102ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cad:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
  102cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , p1);
  102cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc1:	c7 04 24 91 67 10 00 	movl   $0x106791,(%esp)
  102cc8:	e8 89 d6 ff ff       	call   100356 <cprintf>
    while (le1 != &free_list) {
  102ccd:	81 7d f4 80 ce 11 00 	cmpl   $0x11ce80,-0xc(%ebp)
  102cd4:	75 c5                	jne    102c9b <default_free_pages+0x45>
    }
    cprintf("\n\n");
  102cd6:	c7 04 24 9f 67 10 00 	movl   $0x10679f,(%esp)
  102cdd:	e8 74 d6 ff ff       	call   100356 <cprintf>

    struct Page *p = base;
  102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (; p != base + n; p++) {
  102ce8:	e9 9d 00 00 00       	jmp    102d8a <default_free_pages+0x134>
        assert(!PageReserved(p) && !PageProperty(p));
  102ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cf0:	83 c0 04             	add    $0x4,%eax
  102cf3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102cfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d00:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d03:	0f a3 10             	bt     %edx,(%eax)
  102d06:	19 c0                	sbb    %eax,%eax
  102d08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102d0b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102d0f:	0f 95 c0             	setne  %al
  102d12:	0f b6 c0             	movzbl %al,%eax
  102d15:	85 c0                	test   %eax,%eax
  102d17:	75 2c                	jne    102d45 <default_free_pages+0xef>
  102d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d1c:	83 c0 04             	add    $0x4,%eax
  102d1f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102d26:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d2c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d2f:	0f a3 10             	bt     %edx,(%eax)
  102d32:	19 c0                	sbb    %eax,%eax
  102d34:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  102d37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  102d3b:	0f 95 c0             	setne  %al
  102d3e:	0f b6 c0             	movzbl %al,%eax
  102d41:	85 c0                	test   %eax,%eax
  102d43:	74 24                	je     102d69 <default_free_pages+0x113>
  102d45:	c7 44 24 0c a4 67 10 	movl   $0x1067a4,0xc(%esp)
  102d4c:	00 
  102d4d:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102d54:	00 
  102d55:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  102d5c:	00 
  102d5d:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102d64:	e8 7f df ff ff       	call   100ce8 <__panic>
        p->flags = 0;
  102d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102d73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d7a:	00 
  102d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d7e:	89 04 24             	mov    %eax,(%esp)
  102d81:	e8 99 fb ff ff       	call   10291f <set_page_ref>
    for (; p != base + n; p++) {
  102d86:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d8d:	89 d0                	mov    %edx,%eax
  102d8f:	c1 e0 02             	shl    $0x2,%eax
  102d92:	01 d0                	add    %edx,%eax
  102d94:	c1 e0 02             	shl    $0x2,%eax
  102d97:	89 c2                	mov    %eax,%edx
  102d99:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9c:	01 d0                	add    %edx,%eax
  102d9e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102da1:	0f 85 46 ff ff ff    	jne    102ced <default_free_pages+0x97>
    }
    base->property = n;
  102da7:	8b 45 08             	mov    0x8(%ebp),%eax
  102daa:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dad:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102db0:	8b 45 08             	mov    0x8(%ebp),%eax
  102db3:	83 c0 04             	add    $0x4,%eax
  102db6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102dbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dc0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102dc3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102dc6:	0f ab 10             	bts    %edx,(%eax)
}
  102dc9:	90                   	nop
  102dca:	c7 45 c4 80 ce 11 00 	movl   $0x11ce80,-0x3c(%ebp)
  102dd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102dd4:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102dd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list) {
  102dda:	e9 0e 01 00 00       	jmp    102eed <default_free_pages+0x297>
        p = le2page(le, page_link);
  102ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102de2:	83 e8 0c             	sub    $0xc,%eax
  102de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102deb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102dee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102df1:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102df4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (base + base->property == p) {
  102df7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfa:	8b 50 08             	mov    0x8(%eax),%edx
  102dfd:	89 d0                	mov    %edx,%eax
  102dff:	c1 e0 02             	shl    $0x2,%eax
  102e02:	01 d0                	add    %edx,%eax
  102e04:	c1 e0 02             	shl    $0x2,%eax
  102e07:	89 c2                	mov    %eax,%edx
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	01 d0                	add    %edx,%eax
  102e0e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102e11:	75 5d                	jne    102e70 <default_free_pages+0x21a>
            base->property += p->property;
  102e13:	8b 45 08             	mov    0x8(%ebp),%eax
  102e16:	8b 50 08             	mov    0x8(%eax),%edx
  102e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e1c:	8b 40 08             	mov    0x8(%eax),%eax
  102e1f:	01 c2                	add    %eax,%edx
  102e21:	8b 45 08             	mov    0x8(%ebp),%eax
  102e24:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2a:	83 c0 04             	add    $0x4,%eax
  102e2d:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  102e34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e3a:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e3d:	0f b3 10             	btr    %edx,(%eax)
}
  102e40:	90                   	nop
            list_del(&(p->page_link));
  102e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e44:	83 c0 0c             	add    $0xc,%eax
  102e47:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102e4a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e4d:	8b 40 04             	mov    0x4(%eax),%eax
  102e50:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e53:	8b 12                	mov    (%edx),%edx
  102e55:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102e58:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
  102e5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102e61:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e64:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e67:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e6a:	89 10                	mov    %edx,(%eax)
}
  102e6c:	90                   	nop
}
  102e6d:	90                   	nop
  102e6e:	eb 7d                	jmp    102eed <default_free_pages+0x297>
        } else if (p + p->property == base) {
  102e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e73:	8b 50 08             	mov    0x8(%eax),%edx
  102e76:	89 d0                	mov    %edx,%eax
  102e78:	c1 e0 02             	shl    $0x2,%eax
  102e7b:	01 d0                	add    %edx,%eax
  102e7d:	c1 e0 02             	shl    $0x2,%eax
  102e80:	89 c2                	mov    %eax,%edx
  102e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e85:	01 d0                	add    %edx,%eax
  102e87:	39 45 08             	cmp    %eax,0x8(%ebp)
  102e8a:	75 61                	jne    102eed <default_free_pages+0x297>
            p->property += base->property;
  102e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e8f:	8b 50 08             	mov    0x8(%eax),%edx
  102e92:	8b 45 08             	mov    0x8(%ebp),%eax
  102e95:	8b 40 08             	mov    0x8(%eax),%eax
  102e98:	01 c2                	add    %eax,%edx
  102e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e9d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea3:	83 c0 04             	add    $0x4,%eax
  102ea6:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  102ead:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102eb0:	8b 45 90             	mov    -0x70(%ebp),%eax
  102eb3:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102eb6:	0f b3 10             	btr    %edx,(%eax)
}
  102eb9:	90                   	nop
            base = p;//?
  102eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebd:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec3:	83 c0 0c             	add    $0xc,%eax
  102ec6:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_del(listelm->prev, listelm->next);
  102ec9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ecc:	8b 40 04             	mov    0x4(%eax),%eax
  102ecf:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102ed2:	8b 12                	mov    (%edx),%edx
  102ed4:	89 55 9c             	mov    %edx,-0x64(%ebp)
  102ed7:	89 45 98             	mov    %eax,-0x68(%ebp)
    prev->next = next;
  102eda:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102edd:	8b 55 98             	mov    -0x68(%ebp),%edx
  102ee0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ee3:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ee6:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102ee9:	89 10                	mov    %edx,(%eax)
}
  102eeb:	90                   	nop
}
  102eec:	90                   	nop
    while (le != &free_list) {
  102eed:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  102ef4:	0f 85 e5 fe ff ff    	jne    102ddf <default_free_pages+0x189>
        }
    }



    nr_free += n;
  102efa:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f03:	01 d0                	add    %edx,%eax
  102f05:	a3 88 ce 11 00       	mov    %eax,0x11ce88
  102f0a:	c7 45 8c 80 ce 11 00 	movl   $0x11ce80,-0x74(%ebp)
    return listelm->next;
  102f11:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f14:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  102f17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list) {
  102f1a:	eb 34                	jmp    102f50 <default_free_pages+0x2fa>
        p = le2page(le, page_link);
  102f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f1f:	83 e8 0c             	sub    $0xc,%eax
  102f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f28:	89 45 88             	mov    %eax,-0x78(%ebp)
  102f2b:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f2e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (base + base->property < p) {
  102f34:	8b 45 08             	mov    0x8(%ebp),%eax
  102f37:	8b 50 08             	mov    0x8(%eax),%edx
  102f3a:	89 d0                	mov    %edx,%eax
  102f3c:	c1 e0 02             	shl    $0x2,%eax
  102f3f:	01 d0                	add    %edx,%eax
  102f41:	c1 e0 02             	shl    $0x2,%eax
  102f44:	89 c2                	mov    %eax,%edx
  102f46:	8b 45 08             	mov    0x8(%ebp),%eax
  102f49:	01 d0                	add    %edx,%eax
  102f4b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102f4e:	77 0b                	ja     102f5b <default_free_pages+0x305>
    while (le != &free_list) {
  102f50:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  102f57:	75 c3                	jne    102f1c <default_free_pages+0x2c6>
  102f59:	eb 01                	jmp    102f5c <default_free_pages+0x306>
            break;
  102f5b:	90                   	nop
        }

    }
//    list_add_before(le, &(base->page_link));
    list_add(le,&(base->page_link));
  102f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5f:	8d 50 0c             	lea    0xc(%eax),%edx
  102f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f65:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102f68:	89 55 80             	mov    %edx,-0x80(%ebp)
  102f6b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f6e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102f74:	8b 45 80             	mov    -0x80(%ebp),%eax
  102f77:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    __list_add(elm, listelm, listelm->next);
  102f7d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102f83:	8b 40 04             	mov    0x4(%eax),%eax
  102f86:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  102f8c:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
  102f92:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102f98:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  102f9e:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
    prev->next = next->prev = elm;
  102fa4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  102faa:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  102fb0:	89 10                	mov    %edx,(%eax)
  102fb2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  102fb8:	8b 10                	mov    (%eax),%edx
  102fba:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  102fc0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102fc3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102fc9:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  102fcf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102fd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102fd8:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  102fde:	89 10                	mov    %edx,(%eax)
}
  102fe0:	90                   	nop
}
  102fe1:	90                   	nop
}
  102fe2:	90                   	nop

}
  102fe3:	90                   	nop
  102fe4:	89 ec                	mov    %ebp,%esp
  102fe6:	5d                   	pop    %ebp
  102fe7:	c3                   	ret    

00102fe8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102fe8:	55                   	push   %ebp
  102fe9:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102feb:	a1 88 ce 11 00       	mov    0x11ce88,%eax
}
  102ff0:	5d                   	pop    %ebp
  102ff1:	c3                   	ret    

00102ff2 <basic_check>:

static void
basic_check(void) {
  102ff2:	55                   	push   %ebp
  102ff3:	89 e5                	mov    %esp,%ebp
  102ff5:	83 ec 58             	sub    $0x58,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102ff8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103008:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10300b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103012:	e8 91 0f 00 00       	call   103fa8 <alloc_pages>
  103017:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10301a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10301e:	75 24                	jne    103044 <basic_check+0x52>
  103020:	c7 44 24 0c c9 67 10 	movl   $0x1067c9,0xc(%esp)
  103027:	00 
  103028:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10302f:	00 
  103030:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103037:	00 
  103038:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10303f:	e8 a4 dc ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10304b:	e8 58 0f 00 00       	call   103fa8 <alloc_pages>
  103050:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103057:	75 24                	jne    10307d <basic_check+0x8b>
  103059:	c7 44 24 0c e5 67 10 	movl   $0x1067e5,0xc(%esp)
  103060:	00 
  103061:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103068:	00 
  103069:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  103070:	00 
  103071:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103078:	e8 6b dc ff ff       	call   100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10307d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103084:	e8 1f 0f 00 00       	call   103fa8 <alloc_pages>
  103089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10308c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103090:	75 24                	jne    1030b6 <basic_check+0xc4>
  103092:	c7 44 24 0c 01 68 10 	movl   $0x106801,0xc(%esp)
  103099:	00 
  10309a:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1030a1:	00 
  1030a2:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1030a9:	00 
  1030aa:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1030b1:	e8 32 dc ff ff       	call   100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1030bc:	74 10                	je     1030ce <basic_check+0xdc>
  1030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030c4:	74 08                	je     1030ce <basic_check+0xdc>
  1030c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030cc:	75 24                	jne    1030f2 <basic_check+0x100>
  1030ce:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  1030d5:	00 
  1030d6:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1030dd:	00 
  1030de:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1030e5:	00 
  1030e6:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1030ed:	e8 f6 db ff ff       	call   100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030f5:	89 04 24             	mov    %eax,(%esp)
  1030f8:	e8 18 f8 ff ff       	call   102915 <page_ref>
  1030fd:	85 c0                	test   %eax,%eax
  1030ff:	75 1e                	jne    10311f <basic_check+0x12d>
  103101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103104:	89 04 24             	mov    %eax,(%esp)
  103107:	e8 09 f8 ff ff       	call   102915 <page_ref>
  10310c:	85 c0                	test   %eax,%eax
  10310e:	75 0f                	jne    10311f <basic_check+0x12d>
  103110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103113:	89 04 24             	mov    %eax,(%esp)
  103116:	e8 fa f7 ff ff       	call   102915 <page_ref>
  10311b:	85 c0                	test   %eax,%eax
  10311d:	74 24                	je     103143 <basic_check+0x151>
  10311f:	c7 44 24 0c 44 68 10 	movl   $0x106844,0xc(%esp)
  103126:	00 
  103127:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10312e:	00 
  10312f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103136:	00 
  103137:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10313e:	e8 a5 db ff ff       	call   100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103146:	89 04 24             	mov    %eax,(%esp)
  103149:	e8 af f7 ff ff       	call   1028fd <page2pa>
  10314e:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  103154:	c1 e2 0c             	shl    $0xc,%edx
  103157:	39 d0                	cmp    %edx,%eax
  103159:	72 24                	jb     10317f <basic_check+0x18d>
  10315b:	c7 44 24 0c 80 68 10 	movl   $0x106880,0xc(%esp)
  103162:	00 
  103163:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10316a:	00 
  10316b:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  103172:	00 
  103173:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10317a:	e8 69 db ff ff       	call   100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10317f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103182:	89 04 24             	mov    %eax,(%esp)
  103185:	e8 73 f7 ff ff       	call   1028fd <page2pa>
  10318a:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  103190:	c1 e2 0c             	shl    $0xc,%edx
  103193:	39 d0                	cmp    %edx,%eax
  103195:	72 24                	jb     1031bb <basic_check+0x1c9>
  103197:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  10319e:	00 
  10319f:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1031a6:	00 
  1031a7:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  1031ae:	00 
  1031af:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1031b6:	e8 2d db ff ff       	call   100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031be:	89 04 24             	mov    %eax,(%esp)
  1031c1:	e8 37 f7 ff ff       	call   1028fd <page2pa>
  1031c6:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1031cc:	c1 e2 0c             	shl    $0xc,%edx
  1031cf:	39 d0                	cmp    %edx,%eax
  1031d1:	72 24                	jb     1031f7 <basic_check+0x205>
  1031d3:	c7 44 24 0c ba 68 10 	movl   $0x1068ba,0xc(%esp)
  1031da:	00 
  1031db:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1031e2:	00 
  1031e3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  1031ea:	00 
  1031eb:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1031f2:	e8 f1 da ff ff       	call   100ce8 <__panic>

    list_entry_t free_list_store = free_list;
  1031f7:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1031fc:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  103202:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103205:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103208:	c7 45 d4 80 ce 11 00 	movl   $0x11ce80,-0x2c(%ebp)
    elm->prev = elm->next = elm;
  10320f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103212:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103215:	89 50 04             	mov    %edx,0x4(%eax)
  103218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10321b:	8b 50 04             	mov    0x4(%eax),%edx
  10321e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103221:	89 10                	mov    %edx,(%eax)
}
  103223:	90                   	nop
  103224:	c7 45 d8 80 ce 11 00 	movl   $0x11ce80,-0x28(%ebp)
    return list->next == list;
  10322b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10322e:	8b 40 04             	mov    0x4(%eax),%eax
  103231:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103234:	0f 94 c0             	sete   %al
  103237:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10323a:	85 c0                	test   %eax,%eax
  10323c:	75 24                	jne    103262 <basic_check+0x270>
  10323e:	c7 44 24 0c d7 68 10 	movl   $0x1068d7,0xc(%esp)
  103245:	00 
  103246:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10324d:	00 
  10324e:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103255:	00 
  103256:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10325d:	e8 86 da ff ff       	call   100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
  103262:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10326a:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  103271:	00 00 00 

    assert(alloc_page() == NULL);
  103274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10327b:	e8 28 0d 00 00       	call   103fa8 <alloc_pages>
  103280:	85 c0                	test   %eax,%eax
  103282:	74 24                	je     1032a8 <basic_check+0x2b6>
  103284:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  10328b:	00 
  10328c:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103293:	00 
  103294:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10329b:	00 
  10329c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1032a3:	e8 40 da ff ff       	call   100ce8 <__panic>

    free_page(p0);
  1032a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032af:	00 
  1032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032b3:	89 04 24             	mov    %eax,(%esp)
  1032b6:	e8 27 0d 00 00       	call   103fe2 <free_pages>
    free_page(p1);
  1032bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032c2:	00 
  1032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032c6:	89 04 24             	mov    %eax,(%esp)
  1032c9:	e8 14 0d 00 00       	call   103fe2 <free_pages>
    free_page(p2);
  1032ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032d5:	00 
  1032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d9:	89 04 24             	mov    %eax,(%esp)
  1032dc:	e8 01 0d 00 00       	call   103fe2 <free_pages>
    assert(nr_free == 3);
  1032e1:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1032e6:	83 f8 03             	cmp    $0x3,%eax
  1032e9:	74 24                	je     10330f <basic_check+0x31d>
  1032eb:	c7 44 24 0c 03 69 10 	movl   $0x106903,0xc(%esp)
  1032f2:	00 
  1032f3:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1032fa:	00 
  1032fb:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103302:	00 
  103303:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10330a:	e8 d9 d9 ff ff       	call   100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10330f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103316:	e8 8d 0c 00 00       	call   103fa8 <alloc_pages>
  10331b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10331e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103322:	75 24                	jne    103348 <basic_check+0x356>
  103324:	c7 44 24 0c c9 67 10 	movl   $0x1067c9,0xc(%esp)
  10332b:	00 
  10332c:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103333:	00 
  103334:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  10333b:	00 
  10333c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103343:	e8 a0 d9 ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103348:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10334f:	e8 54 0c 00 00       	call   103fa8 <alloc_pages>
  103354:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103357:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10335b:	75 24                	jne    103381 <basic_check+0x38f>
  10335d:	c7 44 24 0c e5 67 10 	movl   $0x1067e5,0xc(%esp)
  103364:	00 
  103365:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10336c:	00 
  10336d:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103374:	00 
  103375:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10337c:	e8 67 d9 ff ff       	call   100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103388:	e8 1b 0c 00 00       	call   103fa8 <alloc_pages>
  10338d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103394:	75 24                	jne    1033ba <basic_check+0x3c8>
  103396:	c7 44 24 0c 01 68 10 	movl   $0x106801,0xc(%esp)
  10339d:	00 
  10339e:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1033a5:	00 
  1033a6:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  1033ad:	00 
  1033ae:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1033b5:	e8 2e d9 ff ff       	call   100ce8 <__panic>

    assert(alloc_page() == NULL);
  1033ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c1:	e8 e2 0b 00 00       	call   103fa8 <alloc_pages>
  1033c6:	85 c0                	test   %eax,%eax
  1033c8:	74 24                	je     1033ee <basic_check+0x3fc>
  1033ca:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  1033d1:	00 
  1033d2:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1033d9:	00 
  1033da:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1033e1:	00 
  1033e2:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1033e9:	e8 fa d8 ff ff       	call   100ce8 <__panic>
  1033ee:	c7 45 d0 80 ce 11 00 	movl   $0x11ce80,-0x30(%ebp)
    return listelm->next;
  1033f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033f8:	8b 40 04             	mov    0x4(%eax),%eax

    struct Page *pp1;

    list_entry_t *le1 = list_next(&free_list);
  1033fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
  1033fe:	eb 32                	jmp    103432 <basic_check+0x440>
        pp1 = le2page(le1, page_link);
  103400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103403:	83 e8 0c             	sub    $0xc,%eax
  103406:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10340f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103412:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
  103415:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
  103418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10341b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103422:	89 44 24 04          	mov    %eax,0x4(%esp)
  103426:	c7 04 24 91 67 10 00 	movl   $0x106791,(%esp)
  10342d:	e8 24 cf ff ff       	call   100356 <cprintf>
    while (le1 != &free_list) {
  103432:	81 7d f4 80 ce 11 00 	cmpl   $0x11ce80,-0xc(%ebp)
  103439:	75 c5                	jne    103400 <basic_check+0x40e>
    }
    cprintf("\n\n");
  10343b:	c7 04 24 9f 67 10 00 	movl   $0x10679f,(%esp)
  103442:	e8 0f cf ff ff       	call   100356 <cprintf>

    free_page(p0);
  103447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10344e:	00 
  10344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103452:	89 04 24             	mov    %eax,(%esp)
  103455:	e8 88 0b 00 00       	call   103fe2 <free_pages>
  10345a:	c7 45 c8 80 ce 11 00 	movl   $0x11ce80,-0x38(%ebp)
  103461:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103464:	8b 40 04             	mov    0x4(%eax),%eax

    le1 = list_next(&free_list);
  103467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
  10346a:	eb 32                	jmp    10349e <basic_check+0x4ac>
        pp1 = le2page(le1, page_link);
  10346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10346f:	83 e8 0c             	sub    $0xc,%eax
  103472:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103478:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  10347b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10347e:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
  103481:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
  103484:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103487:	89 44 24 08          	mov    %eax,0x8(%esp)
  10348b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10348e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103492:	c7 04 24 91 67 10 00 	movl   $0x106791,(%esp)
  103499:	e8 b8 ce ff ff       	call   100356 <cprintf>
    while (le1 != &free_list) {
  10349e:	81 7d f4 80 ce 11 00 	cmpl   $0x11ce80,-0xc(%ebp)
  1034a5:	75 c5                	jne    10346c <basic_check+0x47a>
    }
    cprintf("\n\n");
  1034a7:	c7 04 24 9f 67 10 00 	movl   $0x10679f,(%esp)
  1034ae:	e8 a3 ce ff ff       	call   100356 <cprintf>
  1034b3:	c7 45 c0 80 ce 11 00 	movl   $0x11ce80,-0x40(%ebp)
    return list->next == list;
  1034ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1034bd:	8b 40 04             	mov    0x4(%eax),%eax
  1034c0:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  1034c3:	0f 94 c0             	sete   %al
  1034c6:	0f b6 c0             	movzbl %al,%eax


    assert(!list_empty(&free_list));
  1034c9:	85 c0                	test   %eax,%eax
  1034cb:	74 24                	je     1034f1 <basic_check+0x4ff>
  1034cd:	c7 44 24 0c 10 69 10 	movl   $0x106910,0xc(%esp)
  1034d4:	00 
  1034d5:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1034dc:	00 
  1034dd:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1034e4:	00 
  1034e5:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1034ec:	e8 f7 d7 ff ff       	call   100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034f8:	e8 ab 0a 00 00       	call   103fa8 <alloc_pages>
  1034fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103503:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  103506:	74 24                	je     10352c <basic_check+0x53a>
  103508:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  10350f:	00 
  103510:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103517:	00 
  103518:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10351f:	00 
  103520:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103527:	e8 bc d7 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  10352c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103533:	e8 70 0a 00 00       	call   103fa8 <alloc_pages>
  103538:	85 c0                	test   %eax,%eax
  10353a:	74 24                	je     103560 <basic_check+0x56e>
  10353c:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  103543:	00 
  103544:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10354b:	00 
  10354c:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  103553:	00 
  103554:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10355b:	e8 88 d7 ff ff       	call   100ce8 <__panic>

    assert(nr_free == 0);
  103560:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103565:	85 c0                	test   %eax,%eax
  103567:	74 24                	je     10358d <basic_check+0x59b>
  103569:	c7 44 24 0c 41 69 10 	movl   $0x106941,0xc(%esp)
  103570:	00 
  103571:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103578:	00 
  103579:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  103580:	00 
  103581:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103588:	e8 5b d7 ff ff       	call   100ce8 <__panic>
    free_list = free_list_store;
  10358d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103590:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103593:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103598:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    nr_free = nr_free_store;
  10359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035a1:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_page(p);
  1035a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035ad:	00 
  1035ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035b1:	89 04 24             	mov    %eax,(%esp)
  1035b4:	e8 29 0a 00 00       	call   103fe2 <free_pages>
    free_page(p1);
  1035b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035c0:	00 
  1035c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c4:	89 04 24             	mov    %eax,(%esp)
  1035c7:	e8 16 0a 00 00       	call   103fe2 <free_pages>
    free_page(p2);
  1035cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035d3:	00 
  1035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035d7:	89 04 24             	mov    %eax,(%esp)
  1035da:	e8 03 0a 00 00       	call   103fe2 <free_pages>
}
  1035df:	90                   	nop
  1035e0:	89 ec                	mov    %ebp,%esp
  1035e2:	5d                   	pop    %ebp
  1035e3:	c3                   	ret    

001035e4 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1035e4:	55                   	push   %ebp
  1035e5:	89 e5                	mov    %esp,%ebp
  1035e7:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1035ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035fb:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103602:	eb 6a                	jmp    10366e <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  103604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103607:	83 e8 0c             	sub    $0xc,%eax
  10360a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  10360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103610:	83 c0 04             	add    $0x4,%eax
  103613:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10361a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10361d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103620:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103623:	0f a3 10             	bt     %edx,(%eax)
  103626:	19 c0                	sbb    %eax,%eax
  103628:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10362b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10362f:	0f 95 c0             	setne  %al
  103632:	0f b6 c0             	movzbl %al,%eax
  103635:	85 c0                	test   %eax,%eax
  103637:	75 24                	jne    10365d <default_check+0x79>
  103639:	c7 44 24 0c 4e 69 10 	movl   $0x10694e,0xc(%esp)
  103640:	00 
  103641:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103648:	00 
  103649:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  103650:	00 
  103651:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103658:	e8 8b d6 ff ff       	call   100ce8 <__panic>
        count++, total += p->property;
  10365d:	ff 45 f4             	incl   -0xc(%ebp)
  103660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103663:	8b 50 08             	mov    0x8(%eax),%edx
  103666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103669:	01 d0                	add    %edx,%eax
  10366b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103671:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103674:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103677:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10367a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10367d:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103684:	0f 85 7a ff ff ff    	jne    103604 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10368a:	e8 88 09 00 00       	call   104017 <nr_free_pages>
  10368f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103692:	39 d0                	cmp    %edx,%eax
  103694:	74 24                	je     1036ba <default_check+0xd6>
  103696:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  10369d:	00 
  10369e:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1036a5:	00 
  1036a6:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  1036ad:	00 
  1036ae:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1036b5:	e8 2e d6 ff ff       	call   100ce8 <__panic>

    basic_check();
  1036ba:	e8 33 f9 ff ff       	call   102ff2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1036bf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1036c6:	e8 dd 08 00 00       	call   103fa8 <alloc_pages>
  1036cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1036ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036d2:	75 24                	jne    1036f8 <default_check+0x114>
  1036d4:	c7 44 24 0c 77 69 10 	movl   $0x106977,0xc(%esp)
  1036db:	00 
  1036dc:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1036e3:	00 
  1036e4:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  1036eb:	00 
  1036ec:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1036f3:	e8 f0 d5 ff ff       	call   100ce8 <__panic>
    assert(!PageProperty(p0));
  1036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036fb:	83 c0 04             	add    $0x4,%eax
  1036fe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103705:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103708:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10370b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10370e:	0f a3 10             	bt     %edx,(%eax)
  103711:	19 c0                	sbb    %eax,%eax
  103713:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103716:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10371a:	0f 95 c0             	setne  %al
  10371d:	0f b6 c0             	movzbl %al,%eax
  103720:	85 c0                	test   %eax,%eax
  103722:	74 24                	je     103748 <default_check+0x164>
  103724:	c7 44 24 0c 82 69 10 	movl   $0x106982,0xc(%esp)
  10372b:	00 
  10372c:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103733:	00 
  103734:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  10373b:	00 
  10373c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103743:	e8 a0 d5 ff ff       	call   100ce8 <__panic>

    list_entry_t free_list_store = free_list;
  103748:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10374d:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  103753:	89 45 80             	mov    %eax,-0x80(%ebp)
  103756:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103759:	c7 45 b0 80 ce 11 00 	movl   $0x11ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  103760:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103763:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103766:	89 50 04             	mov    %edx,0x4(%eax)
  103769:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10376c:	8b 50 04             	mov    0x4(%eax),%edx
  10376f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103772:	89 10                	mov    %edx,(%eax)
}
  103774:	90                   	nop
  103775:	c7 45 b4 80 ce 11 00 	movl   $0x11ce80,-0x4c(%ebp)
    return list->next == list;
  10377c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10377f:	8b 40 04             	mov    0x4(%eax),%eax
  103782:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103785:	0f 94 c0             	sete   %al
  103788:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10378b:	85 c0                	test   %eax,%eax
  10378d:	75 24                	jne    1037b3 <default_check+0x1cf>
  10378f:	c7 44 24 0c d7 68 10 	movl   $0x1068d7,0xc(%esp)
  103796:	00 
  103797:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10379e:	00 
  10379f:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1037a6:	00 
  1037a7:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1037ae:	e8 35 d5 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  1037b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037ba:	e8 e9 07 00 00       	call   103fa8 <alloc_pages>
  1037bf:	85 c0                	test   %eax,%eax
  1037c1:	74 24                	je     1037e7 <default_check+0x203>
  1037c3:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  1037ca:	00 
  1037cb:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1037d2:	00 
  1037d3:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1037da:	00 
  1037db:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1037e2:	e8 01 d5 ff ff       	call   100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
  1037e7:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1037ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1037ef:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  1037f6:	00 00 00 

    free_pages(p0 + 2, 3);
  1037f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037fc:	83 c0 28             	add    $0x28,%eax
  1037ff:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103806:	00 
  103807:	89 04 24             	mov    %eax,(%esp)
  10380a:	e8 d3 07 00 00       	call   103fe2 <free_pages>
    assert(alloc_pages(4) == NULL);
  10380f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103816:	e8 8d 07 00 00       	call   103fa8 <alloc_pages>
  10381b:	85 c0                	test   %eax,%eax
  10381d:	74 24                	je     103843 <default_check+0x25f>
  10381f:	c7 44 24 0c 94 69 10 	movl   $0x106994,0xc(%esp)
  103826:	00 
  103827:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10382e:	00 
  10382f:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  103836:	00 
  103837:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10383e:	e8 a5 d4 ff ff       	call   100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103846:	83 c0 28             	add    $0x28,%eax
  103849:	83 c0 04             	add    $0x4,%eax
  10384c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103853:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103856:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103859:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10385c:	0f a3 10             	bt     %edx,(%eax)
  10385f:	19 c0                	sbb    %eax,%eax
  103861:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103864:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103868:	0f 95 c0             	setne  %al
  10386b:	0f b6 c0             	movzbl %al,%eax
  10386e:	85 c0                	test   %eax,%eax
  103870:	74 0e                	je     103880 <default_check+0x29c>
  103872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103875:	83 c0 28             	add    $0x28,%eax
  103878:	8b 40 08             	mov    0x8(%eax),%eax
  10387b:	83 f8 03             	cmp    $0x3,%eax
  10387e:	74 24                	je     1038a4 <default_check+0x2c0>
  103880:	c7 44 24 0c ac 69 10 	movl   $0x1069ac,0xc(%esp)
  103887:	00 
  103888:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10388f:	00 
  103890:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  103897:	00 
  103898:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10389f:	e8 44 d4 ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1038a4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1038ab:	e8 f8 06 00 00       	call   103fa8 <alloc_pages>
  1038b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1038b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1038b7:	75 24                	jne    1038dd <default_check+0x2f9>
  1038b9:	c7 44 24 0c d8 69 10 	movl   $0x1069d8,0xc(%esp)
  1038c0:	00 
  1038c1:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1038c8:	00 
  1038c9:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1038d0:	00 
  1038d1:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1038d8:	e8 0b d4 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  1038dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038e4:	e8 bf 06 00 00       	call   103fa8 <alloc_pages>
  1038e9:	85 c0                	test   %eax,%eax
  1038eb:	74 24                	je     103911 <default_check+0x32d>
  1038ed:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  1038f4:	00 
  1038f5:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1038fc:	00 
  1038fd:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103904:	00 
  103905:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10390c:	e8 d7 d3 ff ff       	call   100ce8 <__panic>
    assert(p0 + 2 == p1);
  103911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103914:	83 c0 28             	add    $0x28,%eax
  103917:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10391a:	74 24                	je     103940 <default_check+0x35c>
  10391c:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  103923:	00 
  103924:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10392b:	00 
  10392c:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  103933:	00 
  103934:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10393b:	e8 a8 d3 ff ff       	call   100ce8 <__panic>

    p2 = p0 + 1;
  103940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103943:	83 c0 14             	add    $0x14,%eax
  103946:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  103949:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103950:	00 
  103951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103954:	89 04 24             	mov    %eax,(%esp)
  103957:	e8 86 06 00 00       	call   103fe2 <free_pages>
    free_pages(p1, 3);
  10395c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103963:	00 
  103964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103967:	89 04 24             	mov    %eax,(%esp)
  10396a:	e8 73 06 00 00       	call   103fe2 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103972:	83 c0 04             	add    $0x4,%eax
  103975:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10397c:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10397f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103982:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103985:	0f a3 10             	bt     %edx,(%eax)
  103988:	19 c0                	sbb    %eax,%eax
  10398a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10398d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103991:	0f 95 c0             	setne  %al
  103994:	0f b6 c0             	movzbl %al,%eax
  103997:	85 c0                	test   %eax,%eax
  103999:	74 0b                	je     1039a6 <default_check+0x3c2>
  10399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10399e:	8b 40 08             	mov    0x8(%eax),%eax
  1039a1:	83 f8 01             	cmp    $0x1,%eax
  1039a4:	74 24                	je     1039ca <default_check+0x3e6>
  1039a6:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  1039ad:	00 
  1039ae:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1039b5:	00 
  1039b6:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  1039bd:	00 
  1039be:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1039c5:	e8 1e d3 ff ff       	call   100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1039ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039cd:	83 c0 04             	add    $0x4,%eax
  1039d0:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1039d7:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1039da:	8b 45 90             	mov    -0x70(%ebp),%eax
  1039dd:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1039e0:	0f a3 10             	bt     %edx,(%eax)
  1039e3:	19 c0                	sbb    %eax,%eax
  1039e5:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1039e8:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1039ec:	0f 95 c0             	setne  %al
  1039ef:	0f b6 c0             	movzbl %al,%eax
  1039f2:	85 c0                	test   %eax,%eax
  1039f4:	74 0b                	je     103a01 <default_check+0x41d>
  1039f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039f9:	8b 40 08             	mov    0x8(%eax),%eax
  1039fc:	83 f8 03             	cmp    $0x3,%eax
  1039ff:	74 24                	je     103a25 <default_check+0x441>
  103a01:	c7 44 24 0c 2c 6a 10 	movl   $0x106a2c,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103a20:	e8 c3 d2 ff ff       	call   100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a2c:	e8 77 05 00 00       	call   103fa8 <alloc_pages>
  103a31:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a37:	83 e8 14             	sub    $0x14,%eax
  103a3a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a3d:	74 24                	je     103a63 <default_check+0x47f>
  103a3f:	c7 44 24 0c 52 6a 10 	movl   $0x106a52,0xc(%esp)
  103a46:	00 
  103a47:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103a4e:	00 
  103a4f:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103a56:	00 
  103a57:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103a5e:	e8 85 d2 ff ff       	call   100ce8 <__panic>
    free_page(p0);
  103a63:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a6a:	00 
  103a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a6e:	89 04 24             	mov    %eax,(%esp)
  103a71:	e8 6c 05 00 00       	call   103fe2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a76:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a7d:	e8 26 05 00 00       	call   103fa8 <alloc_pages>
  103a82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a88:	83 c0 14             	add    $0x14,%eax
  103a8b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a8e:	74 24                	je     103ab4 <default_check+0x4d0>
  103a90:	c7 44 24 0c 70 6a 10 	movl   $0x106a70,0xc(%esp)
  103a97:	00 
  103a98:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103a9f:	00 
  103aa0:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
  103aa7:	00 
  103aa8:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103aaf:	e8 34 d2 ff ff       	call   100ce8 <__panic>

    free_pages(p0, 2);
  103ab4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103abb:	00 
  103abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103abf:	89 04 24             	mov    %eax,(%esp)
  103ac2:	e8 1b 05 00 00       	call   103fe2 <free_pages>
    free_page(p2);
  103ac7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103ace:	00 
  103acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ad2:	89 04 24             	mov    %eax,(%esp)
  103ad5:	e8 08 05 00 00       	call   103fe2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103ada:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103ae1:	e8 c2 04 00 00       	call   103fa8 <alloc_pages>
  103ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103ae9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103aed:	75 24                	jne    103b13 <default_check+0x52f>
  103aef:	c7 44 24 0c 90 6a 10 	movl   $0x106a90,0xc(%esp)
  103af6:	00 
  103af7:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103afe:	00 
  103aff:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
  103b06:	00 
  103b07:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103b0e:	e8 d5 d1 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  103b13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b1a:	e8 89 04 00 00       	call   103fa8 <alloc_pages>
  103b1f:	85 c0                	test   %eax,%eax
  103b21:	74 24                	je     103b47 <default_check+0x563>
  103b23:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  103b2a:	00 
  103b2b:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103b32:	00 
  103b33:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  103b3a:	00 
  103b3b:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103b42:	e8 a1 d1 ff ff       	call   100ce8 <__panic>

    assert(nr_free == 0);
  103b47:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103b4c:	85 c0                	test   %eax,%eax
  103b4e:	74 24                	je     103b74 <default_check+0x590>
  103b50:	c7 44 24 0c 41 69 10 	movl   $0x106941,0xc(%esp)
  103b57:	00 
  103b58:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103b5f:	00 
  103b60:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
  103b67:	00 
  103b68:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103b6f:	e8 74 d1 ff ff       	call   100ce8 <__panic>
    nr_free = nr_free_store;
  103b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b77:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_list = free_list_store;
  103b7c:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b7f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b82:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103b87:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    free_pages(p0, 5);
  103b8d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b94:	00 
  103b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b98:	89 04 24             	mov    %eax,(%esp)
  103b9b:	e8 42 04 00 00       	call   103fe2 <free_pages>

    le = &free_list;
  103ba0:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103ba7:	eb 5a                	jmp    103c03 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  103ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bac:	8b 40 04             	mov    0x4(%eax),%eax
  103baf:	8b 00                	mov    (%eax),%eax
  103bb1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103bb4:	75 0d                	jne    103bc3 <default_check+0x5df>
  103bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bb9:	8b 00                	mov    (%eax),%eax
  103bbb:	8b 40 04             	mov    0x4(%eax),%eax
  103bbe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103bc1:	74 24                	je     103be7 <default_check+0x603>
  103bc3:	c7 44 24 0c b0 6a 10 	movl   $0x106ab0,0xc(%esp)
  103bca:	00 
  103bcb:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103bd2:	00 
  103bd3:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  103bda:	00 
  103bdb:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103be2:	e8 01 d1 ff ff       	call   100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
  103be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bea:	83 e8 0c             	sub    $0xc,%eax
  103bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  103bf0:	ff 4d f4             	decl   -0xc(%ebp)
  103bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103bf9:	8b 48 08             	mov    0x8(%eax),%ecx
  103bfc:	89 d0                	mov    %edx,%eax
  103bfe:	29 c8                	sub    %ecx,%eax
  103c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c06:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103c09:	8b 45 88             	mov    -0x78(%ebp),%eax
  103c0c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c12:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103c19:	75 8e                	jne    103ba9 <default_check+0x5c5>
    }
    assert(count == 0);
  103c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103c1f:	74 24                	je     103c45 <default_check+0x661>
  103c21:	c7 44 24 0c dd 6a 10 	movl   $0x106add,0xc(%esp)
  103c28:	00 
  103c29:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103c30:	00 
  103c31:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
  103c38:	00 
  103c39:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103c40:	e8 a3 d0 ff ff       	call   100ce8 <__panic>
    assert(total == 0);
  103c45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c49:	74 24                	je     103c6f <default_check+0x68b>
  103c4b:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  103c52:	00 
  103c53:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103c5a:	00 
  103c5b:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
  103c62:	00 
  103c63:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103c6a:	e8 79 d0 ff ff       	call   100ce8 <__panic>
}
  103c6f:	90                   	nop
  103c70:	89 ec                	mov    %ebp,%esp
  103c72:	5d                   	pop    %ebp
  103c73:	c3                   	ret    

00103c74 <page2ppn>:
page2ppn(struct Page *page) {
  103c74:	55                   	push   %ebp
  103c75:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c77:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  103c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c80:	29 d0                	sub    %edx,%eax
  103c82:	c1 f8 02             	sar    $0x2,%eax
  103c85:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c8b:	5d                   	pop    %ebp
  103c8c:	c3                   	ret    

00103c8d <page2pa>:
page2pa(struct Page *page) {
  103c8d:	55                   	push   %ebp
  103c8e:	89 e5                	mov    %esp,%ebp
  103c90:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c93:	8b 45 08             	mov    0x8(%ebp),%eax
  103c96:	89 04 24             	mov    %eax,(%esp)
  103c99:	e8 d6 ff ff ff       	call   103c74 <page2ppn>
  103c9e:	c1 e0 0c             	shl    $0xc,%eax
}
  103ca1:	89 ec                	mov    %ebp,%esp
  103ca3:	5d                   	pop    %ebp
  103ca4:	c3                   	ret    

00103ca5 <pa2page>:
pa2page(uintptr_t pa) {
  103ca5:	55                   	push   %ebp
  103ca6:	89 e5                	mov    %esp,%ebp
  103ca8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103cab:	8b 45 08             	mov    0x8(%ebp),%eax
  103cae:	c1 e8 0c             	shr    $0xc,%eax
  103cb1:	89 c2                	mov    %eax,%edx
  103cb3:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103cb8:	39 c2                	cmp    %eax,%edx
  103cba:	72 1c                	jb     103cd8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103cbc:	c7 44 24 08 24 6b 10 	movl   $0x106b24,0x8(%esp)
  103cc3:	00 
  103cc4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103ccb:	00 
  103ccc:	c7 04 24 43 6b 10 00 	movl   $0x106b43,(%esp)
  103cd3:	e8 10 d0 ff ff       	call   100ce8 <__panic>
    return &pages[PPN(pa)];
  103cd8:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  103cde:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce1:	c1 e8 0c             	shr    $0xc,%eax
  103ce4:	89 c2                	mov    %eax,%edx
  103ce6:	89 d0                	mov    %edx,%eax
  103ce8:	c1 e0 02             	shl    $0x2,%eax
  103ceb:	01 d0                	add    %edx,%eax
  103ced:	c1 e0 02             	shl    $0x2,%eax
  103cf0:	01 c8                	add    %ecx,%eax
}
  103cf2:	89 ec                	mov    %ebp,%esp
  103cf4:	5d                   	pop    %ebp
  103cf5:	c3                   	ret    

00103cf6 <page2kva>:
page2kva(struct Page *page) {
  103cf6:	55                   	push   %ebp
  103cf7:	89 e5                	mov    %esp,%ebp
  103cf9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  103cff:	89 04 24             	mov    %eax,(%esp)
  103d02:	e8 86 ff ff ff       	call   103c8d <page2pa>
  103d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d0d:	c1 e8 0c             	shr    $0xc,%eax
  103d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d13:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103d18:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103d1b:	72 23                	jb     103d40 <page2kva+0x4a>
  103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d24:	c7 44 24 08 54 6b 10 	movl   $0x106b54,0x8(%esp)
  103d2b:	00 
  103d2c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103d33:	00 
  103d34:	c7 04 24 43 6b 10 00 	movl   $0x106b43,(%esp)
  103d3b:	e8 a8 cf ff ff       	call   100ce8 <__panic>
  103d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d43:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103d48:	89 ec                	mov    %ebp,%esp
  103d4a:	5d                   	pop    %ebp
  103d4b:	c3                   	ret    

00103d4c <pte2page>:
pte2page(pte_t pte) {
  103d4c:	55                   	push   %ebp
  103d4d:	89 e5                	mov    %esp,%ebp
  103d4f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103d52:	8b 45 08             	mov    0x8(%ebp),%eax
  103d55:	83 e0 01             	and    $0x1,%eax
  103d58:	85 c0                	test   %eax,%eax
  103d5a:	75 1c                	jne    103d78 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103d5c:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  103d63:	00 
  103d64:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103d6b:	00 
  103d6c:	c7 04 24 43 6b 10 00 	movl   $0x106b43,(%esp)
  103d73:	e8 70 cf ff ff       	call   100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
  103d78:	8b 45 08             	mov    0x8(%ebp),%eax
  103d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d80:	89 04 24             	mov    %eax,(%esp)
  103d83:	e8 1d ff ff ff       	call   103ca5 <pa2page>
}
  103d88:	89 ec                	mov    %ebp,%esp
  103d8a:	5d                   	pop    %ebp
  103d8b:	c3                   	ret    

00103d8c <pde2page>:
pde2page(pde_t pde) {
  103d8c:	55                   	push   %ebp
  103d8d:	89 e5                	mov    %esp,%ebp
  103d8f:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d92:	8b 45 08             	mov    0x8(%ebp),%eax
  103d95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d9a:	89 04 24             	mov    %eax,(%esp)
  103d9d:	e8 03 ff ff ff       	call   103ca5 <pa2page>
}
  103da2:	89 ec                	mov    %ebp,%esp
  103da4:	5d                   	pop    %ebp
  103da5:	c3                   	ret    

00103da6 <page_ref>:
page_ref(struct Page *page) {
  103da6:	55                   	push   %ebp
  103da7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103da9:	8b 45 08             	mov    0x8(%ebp),%eax
  103dac:	8b 00                	mov    (%eax),%eax
}
  103dae:	5d                   	pop    %ebp
  103daf:	c3                   	ret    

00103db0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103db0:	55                   	push   %ebp
  103db1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103db3:	8b 45 08             	mov    0x8(%ebp),%eax
  103db6:	8b 00                	mov    (%eax),%eax
  103db8:	8d 50 01             	lea    0x1(%eax),%edx
  103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  103dbe:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  103dc3:	8b 00                	mov    (%eax),%eax
}
  103dc5:	5d                   	pop    %ebp
  103dc6:	c3                   	ret    

00103dc7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103dc7:	55                   	push   %ebp
  103dc8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103dca:	8b 45 08             	mov    0x8(%ebp),%eax
  103dcd:	8b 00                	mov    (%eax),%eax
  103dcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  103dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  103dd5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  103dda:	8b 00                	mov    (%eax),%eax
}
  103ddc:	5d                   	pop    %ebp
  103ddd:	c3                   	ret    

00103dde <__intr_save>:
__intr_save(void) {
  103dde:	55                   	push   %ebp
  103ddf:	89 e5                	mov    %esp,%ebp
  103de1:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103de4:	9c                   	pushf  
  103de5:	58                   	pop    %eax
  103de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103dec:	25 00 02 00 00       	and    $0x200,%eax
  103df1:	85 c0                	test   %eax,%eax
  103df3:	74 0c                	je     103e01 <__intr_save+0x23>
        intr_disable();
  103df5:	e8 47 d9 ff ff       	call   101741 <intr_disable>
        return 1;
  103dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  103dff:	eb 05                	jmp    103e06 <__intr_save+0x28>
    return 0;
  103e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103e06:	89 ec                	mov    %ebp,%esp
  103e08:	5d                   	pop    %ebp
  103e09:	c3                   	ret    

00103e0a <__intr_restore>:
__intr_restore(bool flag) {
  103e0a:	55                   	push   %ebp
  103e0b:	89 e5                	mov    %esp,%ebp
  103e0d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103e10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103e14:	74 05                	je     103e1b <__intr_restore+0x11>
        intr_enable();
  103e16:	e8 1e d9 ff ff       	call   101739 <intr_enable>
}
  103e1b:	90                   	nop
  103e1c:	89 ec                	mov    %ebp,%esp
  103e1e:	5d                   	pop    %ebp
  103e1f:	c3                   	ret    

00103e20 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103e20:	55                   	push   %ebp
  103e21:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103e23:	8b 45 08             	mov    0x8(%ebp),%eax
  103e26:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103e29:	b8 23 00 00 00       	mov    $0x23,%eax
  103e2e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103e30:	b8 23 00 00 00       	mov    $0x23,%eax
  103e35:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103e37:	b8 10 00 00 00       	mov    $0x10,%eax
  103e3c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103e3e:	b8 10 00 00 00       	mov    $0x10,%eax
  103e43:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103e45:	b8 10 00 00 00       	mov    $0x10,%eax
  103e4a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103e4c:	ea 53 3e 10 00 08 00 	ljmp   $0x8,$0x103e53
}
  103e53:	90                   	nop
  103e54:	5d                   	pop    %ebp
  103e55:	c3                   	ret    

00103e56 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103e56:	55                   	push   %ebp
  103e57:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103e59:	8b 45 08             	mov    0x8(%ebp),%eax
  103e5c:	a3 c4 ce 11 00       	mov    %eax,0x11cec4
}
  103e61:	90                   	nop
  103e62:	5d                   	pop    %ebp
  103e63:	c3                   	ret    

00103e64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103e64:	55                   	push   %ebp
  103e65:	89 e5                	mov    %esp,%ebp
  103e67:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103e6a:	b8 00 90 11 00       	mov    $0x119000,%eax
  103e6f:	89 04 24             	mov    %eax,(%esp)
  103e72:	e8 df ff ff ff       	call   103e56 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e77:	66 c7 05 c8 ce 11 00 	movw   $0x10,0x11cec8
  103e7e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e80:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  103e87:	68 00 
  103e89:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e8e:	0f b7 c0             	movzwl %ax,%eax
  103e91:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  103e97:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e9c:	c1 e8 10             	shr    $0x10,%eax
  103e9f:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  103ea4:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103eab:	24 f0                	and    $0xf0,%al
  103ead:	0c 09                	or     $0x9,%al
  103eaf:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103eb4:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103ebb:	24 ef                	and    $0xef,%al
  103ebd:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103ec2:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103ec9:	24 9f                	and    $0x9f,%al
  103ecb:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103ed0:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103ed7:	0c 80                	or     $0x80,%al
  103ed9:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103ede:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103ee5:	24 f0                	and    $0xf0,%al
  103ee7:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103eec:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103ef3:	24 ef                	and    $0xef,%al
  103ef5:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103efa:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103f01:	24 df                	and    $0xdf,%al
  103f03:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103f08:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103f0f:	0c 40                	or     $0x40,%al
  103f11:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103f16:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103f1d:	24 7f                	and    $0x7f,%al
  103f1f:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103f24:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103f29:	c1 e8 18             	shr    $0x18,%eax
  103f2c:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103f31:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  103f38:	e8 e3 fe ff ff       	call   103e20 <lgdt>
  103f3d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103f43:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103f47:	0f 00 d8             	ltr    %ax
}
  103f4a:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103f4b:	90                   	nop
  103f4c:	89 ec                	mov    %ebp,%esp
  103f4e:	5d                   	pop    %ebp
  103f4f:	c3                   	ret    

00103f50 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103f50:	55                   	push   %ebp
  103f51:	89 e5                	mov    %esp,%ebp
  103f53:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103f56:	c7 05 ac ce 11 00 08 	movl   $0x106b08,0x11ceac
  103f5d:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103f60:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f65:	8b 00                	mov    (%eax),%eax
  103f67:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f6b:	c7 04 24 a4 6b 10 00 	movl   $0x106ba4,(%esp)
  103f72:	e8 df c3 ff ff       	call   100356 <cprintf>
    pmm_manager->init();
  103f77:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f7c:	8b 40 04             	mov    0x4(%eax),%eax
  103f7f:	ff d0                	call   *%eax
}
  103f81:	90                   	nop
  103f82:	89 ec                	mov    %ebp,%esp
  103f84:	5d                   	pop    %ebp
  103f85:	c3                   	ret    

00103f86 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f86:	55                   	push   %ebp
  103f87:	89 e5                	mov    %esp,%ebp
  103f89:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f8c:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f91:	8b 40 08             	mov    0x8(%eax),%eax
  103f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f97:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  103f9e:	89 14 24             	mov    %edx,(%esp)
  103fa1:	ff d0                	call   *%eax
}
  103fa3:	90                   	nop
  103fa4:	89 ec                	mov    %ebp,%esp
  103fa6:	5d                   	pop    %ebp
  103fa7:	c3                   	ret    

00103fa8 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103fa8:	55                   	push   %ebp
  103fa9:	89 e5                	mov    %esp,%ebp
  103fab:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103fb5:	e8 24 fe ff ff       	call   103dde <__intr_save>
  103fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103fbd:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  103fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  103fc8:	89 14 24             	mov    %edx,(%esp)
  103fcb:	ff d0                	call   *%eax
  103fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fd3:	89 04 24             	mov    %eax,(%esp)
  103fd6:	e8 2f fe ff ff       	call   103e0a <__intr_restore>
    return page;
  103fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103fde:	89 ec                	mov    %ebp,%esp
  103fe0:	5d                   	pop    %ebp
  103fe1:	c3                   	ret    

00103fe2 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103fe2:	55                   	push   %ebp
  103fe3:	89 e5                	mov    %esp,%ebp
  103fe5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103fe8:	e8 f1 fd ff ff       	call   103dde <__intr_save>
  103fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103ff0:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103ff5:	8b 40 10             	mov    0x10(%eax),%eax
  103ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fff:	8b 55 08             	mov    0x8(%ebp),%edx
  104002:	89 14 24             	mov    %edx,(%esp)
  104005:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  104007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10400a:	89 04 24             	mov    %eax,(%esp)
  10400d:	e8 f8 fd ff ff       	call   103e0a <__intr_restore>
}
  104012:	90                   	nop
  104013:	89 ec                	mov    %ebp,%esp
  104015:	5d                   	pop    %ebp
  104016:	c3                   	ret    

00104017 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  104017:	55                   	push   %ebp
  104018:	89 e5                	mov    %esp,%ebp
  10401a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  10401d:	e8 bc fd ff ff       	call   103dde <__intr_save>
  104022:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  104025:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  10402a:	8b 40 14             	mov    0x14(%eax),%eax
  10402d:	ff d0                	call   *%eax
  10402f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  104032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104035:	89 04 24             	mov    %eax,(%esp)
  104038:	e8 cd fd ff ff       	call   103e0a <__intr_restore>
    return ret;
  10403d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104040:	89 ec                	mov    %ebp,%esp
  104042:	5d                   	pop    %ebp
  104043:	c3                   	ret    

00104044 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  104044:	55                   	push   %ebp
  104045:	89 e5                	mov    %esp,%ebp
  104047:	57                   	push   %edi
  104048:	56                   	push   %esi
  104049:	53                   	push   %ebx
  10404a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104050:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
  104057:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10405e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104065:	c7 04 24 bb 6b 10 00 	movl   $0x106bbb,(%esp)
  10406c:	e8 e5 c2 ff ff       	call   100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104071:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104078:	e9 0c 01 00 00       	jmp    104189 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10407d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104080:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104083:	89 d0                	mov    %edx,%eax
  104085:	c1 e0 02             	shl    $0x2,%eax
  104088:	01 d0                	add    %edx,%eax
  10408a:	c1 e0 02             	shl    $0x2,%eax
  10408d:	01 c8                	add    %ecx,%eax
  10408f:	8b 50 08             	mov    0x8(%eax),%edx
  104092:	8b 40 04             	mov    0x4(%eax),%eax
  104095:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104098:	89 55 ac             	mov    %edx,-0x54(%ebp)
  10409b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10409e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040a1:	89 d0                	mov    %edx,%eax
  1040a3:	c1 e0 02             	shl    $0x2,%eax
  1040a6:	01 d0                	add    %edx,%eax
  1040a8:	c1 e0 02             	shl    $0x2,%eax
  1040ab:	01 c8                	add    %ecx,%eax
  1040ad:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040b0:	8b 58 10             	mov    0x10(%eax),%ebx
  1040b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1040b6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1040b9:	01 c8                	add    %ecx,%eax
  1040bb:	11 da                	adc    %ebx,%edx
  1040bd:	89 45 a0             	mov    %eax,-0x60(%ebp)
  1040c0:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  1040c3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  1040c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040c9:	89 d0                	mov    %edx,%eax
  1040cb:	c1 e0 02             	shl    $0x2,%eax
  1040ce:	01 d0                	add    %edx,%eax
  1040d0:	c1 e0 02             	shl    $0x2,%eax
  1040d3:	01 c8                	add    %ecx,%eax
  1040d5:	83 c0 14             	add    $0x14,%eax
  1040d8:	8b 00                	mov    (%eax),%eax
  1040da:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1040e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040e3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040e6:	83 c0 ff             	add    $0xffffffff,%eax
  1040e9:	83 d2 ff             	adc    $0xffffffff,%edx
  1040ec:	89 c6                	mov    %eax,%esi
  1040ee:	89 d7                	mov    %edx,%edi
  1040f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  1040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040f6:	89 d0                	mov    %edx,%eax
  1040f8:	c1 e0 02             	shl    $0x2,%eax
  1040fb:	01 d0                	add    %edx,%eax
  1040fd:	c1 e0 02             	shl    $0x2,%eax
  104100:	01 c8                	add    %ecx,%eax
  104102:	8b 48 0c             	mov    0xc(%eax),%ecx
  104105:	8b 58 10             	mov    0x10(%eax),%ebx
  104108:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10410e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104112:	89 74 24 14          	mov    %esi,0x14(%esp)
  104116:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10411a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10411d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104120:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104124:	89 54 24 10          	mov    %edx,0x10(%esp)
  104128:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10412c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104130:	c7 04 24 c8 6b 10 00 	movl   $0x106bc8,(%esp)
  104137:	e8 1a c2 ff ff       	call   100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  10413c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10413f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104142:	89 d0                	mov    %edx,%eax
  104144:	c1 e0 02             	shl    $0x2,%eax
  104147:	01 d0                	add    %edx,%eax
  104149:	c1 e0 02             	shl    $0x2,%eax
  10414c:	01 c8                	add    %ecx,%eax
  10414e:	83 c0 14             	add    $0x14,%eax
  104151:	8b 00                	mov    (%eax),%eax
  104153:	83 f8 01             	cmp    $0x1,%eax
  104156:	75 2e                	jne    104186 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  104158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10415b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10415e:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  104161:	89 d0                	mov    %edx,%eax
  104163:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  104166:	73 1e                	jae    104186 <page_init+0x142>
  104168:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  10416d:	b8 00 00 00 00       	mov    $0x0,%eax
  104172:	3b 55 a8             	cmp    -0x58(%ebp),%edx
  104175:	1b 45 ac             	sbb    -0x54(%ebp),%eax
  104178:	72 0c                	jb     104186 <page_init+0x142>
                maxpa = end;
  10417a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10417d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104180:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104183:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  104186:	ff 45 dc             	incl   -0x24(%ebp)
  104189:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10418c:	8b 00                	mov    (%eax),%eax
  10418e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104191:	0f 8c e6 fe ff ff    	jl     10407d <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104197:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10419c:	b8 00 00 00 00       	mov    $0x0,%eax
  1041a1:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  1041a4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  1041a7:	73 0e                	jae    1041b7 <page_init+0x173>
        maxpa = KMEMSIZE;
  1041a9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  1041b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1041b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1041bd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1041c1:	c1 ea 0c             	shr    $0xc,%edx
  1041c4:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1041c9:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  1041d0:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  1041d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1041d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041db:	01 d0                	add    %edx,%eax
  1041dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1041e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e8:	f7 75 c8             	divl   -0x38(%ebp)
  1041eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041ee:	29 d0                	sub    %edx,%eax
  1041f0:	a3 a0 ce 11 00       	mov    %eax,0x11cea0

    for (i = 0; i < npage; i ++) {
  1041f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041fc:	eb 2f                	jmp    10422d <page_init+0x1e9>
        SetPageReserved(pages + i);
  1041fe:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  104204:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104207:	89 d0                	mov    %edx,%eax
  104209:	c1 e0 02             	shl    $0x2,%eax
  10420c:	01 d0                	add    %edx,%eax
  10420e:	c1 e0 02             	shl    $0x2,%eax
  104211:	01 c8                	add    %ecx,%eax
  104213:	83 c0 04             	add    $0x4,%eax
  104216:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
  10421d:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104220:	8b 45 98             	mov    -0x68(%ebp),%eax
  104223:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104226:	0f ab 10             	bts    %edx,(%eax)
}
  104229:	90                   	nop
    for (i = 0; i < npage; i ++) {
  10422a:	ff 45 dc             	incl   -0x24(%ebp)
  10422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104230:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104235:	39 c2                	cmp    %eax,%edx
  104237:	72 c5                	jb     1041fe <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104239:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  10423f:	89 d0                	mov    %edx,%eax
  104241:	c1 e0 02             	shl    $0x2,%eax
  104244:	01 d0                	add    %edx,%eax
  104246:	c1 e0 02             	shl    $0x2,%eax
  104249:	89 c2                	mov    %eax,%edx
  10424b:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  104250:	01 d0                	add    %edx,%eax
  104252:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104255:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
  10425c:	77 23                	ja     104281 <page_init+0x23d>
  10425e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104265:	c7 44 24 08 f8 6b 10 	movl   $0x106bf8,0x8(%esp)
  10426c:	00 
  10426d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104274:	00 
  104275:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10427c:	e8 67 ca ff ff       	call   100ce8 <__panic>
  104281:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104284:	05 00 00 00 40       	add    $0x40000000,%eax
  104289:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10428c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104293:	e9 85 01 00 00       	jmp    10441d <page_init+0x3d9>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104298:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10429b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10429e:	89 d0                	mov    %edx,%eax
  1042a0:	c1 e0 02             	shl    $0x2,%eax
  1042a3:	01 d0                	add    %edx,%eax
  1042a5:	c1 e0 02             	shl    $0x2,%eax
  1042a8:	01 c8                	add    %ecx,%eax
  1042aa:	8b 50 08             	mov    0x8(%eax),%edx
  1042ad:	8b 40 04             	mov    0x4(%eax),%eax
  1042b0:	89 45 90             	mov    %eax,-0x70(%ebp)
  1042b3:	89 55 94             	mov    %edx,-0x6c(%ebp)
  1042b6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  1042b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042bc:	89 d0                	mov    %edx,%eax
  1042be:	c1 e0 02             	shl    $0x2,%eax
  1042c1:	01 d0                	add    %edx,%eax
  1042c3:	c1 e0 02             	shl    $0x2,%eax
  1042c6:	01 c8                	add    %ecx,%eax
  1042c8:	8b 48 0c             	mov    0xc(%eax),%ecx
  1042cb:	8b 58 10             	mov    0x10(%eax),%ebx
  1042ce:	8b 45 90             	mov    -0x70(%ebp),%eax
  1042d1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1042d4:	01 c8                	add    %ecx,%eax
  1042d6:	11 da                	adc    %ebx,%edx
  1042d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042db:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1042de:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  1042e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042e4:	89 d0                	mov    %edx,%eax
  1042e6:	c1 e0 02             	shl    $0x2,%eax
  1042e9:	01 d0                	add    %edx,%eax
  1042eb:	c1 e0 02             	shl    $0x2,%eax
  1042ee:	01 c8                	add    %ecx,%eax
  1042f0:	83 c0 14             	add    $0x14,%eax
  1042f3:	8b 00                	mov    (%eax),%eax
  1042f5:	83 f8 01             	cmp    $0x1,%eax
  1042f8:	0f 85 1c 01 00 00    	jne    10441a <page_init+0x3d6>
            if (begin < freemem) {
  1042fe:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  104301:	bb 00 00 00 00       	mov    $0x0,%ebx
  104306:	8b 45 90             	mov    -0x70(%ebp),%eax
  104309:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10430c:	39 c8                	cmp    %ecx,%eax
  10430e:	89 d0                	mov    %edx,%eax
  104310:	19 d8                	sbb    %ebx,%eax
  104312:	73 0e                	jae    104322 <page_init+0x2de>
                begin = freemem;
  104314:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104317:	ba 00 00 00 00       	mov    $0x0,%edx
  10431c:	89 45 90             	mov    %eax,-0x70(%ebp)
  10431f:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
  104322:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104327:	b8 00 00 00 00       	mov    $0x0,%eax
  10432c:	3b 55 d0             	cmp    -0x30(%ebp),%edx
  10432f:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  104332:	73 0e                	jae    104342 <page_init+0x2fe>
                end = KMEMSIZE;
  104334:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
  10433b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
  104342:	8b 45 90             	mov    -0x70(%ebp),%eax
  104345:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104348:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10434b:	89 d0                	mov    %edx,%eax
  10434d:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  104350:	0f 83 c4 00 00 00    	jae    10441a <page_init+0x3d6>
                begin = ROUNDUP(begin, PGSIZE);
  104356:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  10435d:	8b 45 90             	mov    -0x70(%ebp),%eax
  104360:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104363:	89 c2                	mov    %eax,%edx
  104365:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104368:	01 d0                	add    %edx,%eax
  10436a:	48                   	dec    %eax
  10436b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  10436e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104371:	ba 00 00 00 00       	mov    $0x0,%edx
  104376:	f7 75 b8             	divl   -0x48(%ebp)
  104379:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10437c:	29 d0                	sub    %edx,%eax
  10437e:	ba 00 00 00 00       	mov    $0x0,%edx
  104383:	89 45 90             	mov    %eax,-0x70(%ebp)
  104386:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104389:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10438c:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10438f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104392:	ba 00 00 00 00       	mov    $0x0,%edx
  104397:	89 c7                	mov    %eax,%edi
  104399:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10439f:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1043a2:	89 d0                	mov    %edx,%eax
  1043a4:	83 e0 00             	and    $0x0,%eax
  1043a7:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1043aa:	8b 45 80             	mov    -0x80(%ebp),%eax
  1043ad:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1043b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1043b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                if (begin < end) {
  1043b6:	8b 45 90             	mov    -0x70(%ebp),%eax
  1043b9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1043bc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1043bf:	89 d0                	mov    %edx,%eax
  1043c1:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  1043c4:	73 54                	jae    10441a <page_init+0x3d6>

                    cprintf("memory: %08llx,%08llx\n",begin,&begin);
  1043c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  1043c9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1043cc:	8d 4d 90             	lea    -0x70(%ebp),%ecx
  1043cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1043d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1043db:	c7 04 24 2a 6c 10 00 	movl   $0x106c2a,(%esp)
  1043e2:	e8 6f bf ff ff       	call   100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1043e7:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  1043ea:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
  1043ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043f3:	29 c8                	sub    %ecx,%eax
  1043f5:	19 da                	sbb    %ebx,%edx
  1043f7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1043fb:	c1 ea 0c             	shr    $0xc,%edx
  1043fe:	89 c3                	mov    %eax,%ebx
  104400:	8b 45 90             	mov    -0x70(%ebp),%eax
  104403:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104406:	89 04 24             	mov    %eax,(%esp)
  104409:	e8 97 f8 ff ff       	call   103ca5 <pa2page>
  10440e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104412:	89 04 24             	mov    %eax,(%esp)
  104415:	e8 6c fb ff ff       	call   103f86 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10441a:	ff 45 dc             	incl   -0x24(%ebp)
  10441d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104420:	8b 00                	mov    (%eax),%eax
  104422:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104425:	0f 8c 6d fe ff ff    	jl     104298 <page_init+0x254>
                }
            }
        }
    }
}
  10442b:	90                   	nop
  10442c:	90                   	nop
  10442d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104433:	5b                   	pop    %ebx
  104434:	5e                   	pop    %esi
  104435:	5f                   	pop    %edi
  104436:	5d                   	pop    %ebp
  104437:	c3                   	ret    

00104438 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104438:	55                   	push   %ebp
  104439:	89 e5                	mov    %esp,%ebp
  10443b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10443e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104441:	33 45 14             	xor    0x14(%ebp),%eax
  104444:	25 ff 0f 00 00       	and    $0xfff,%eax
  104449:	85 c0                	test   %eax,%eax
  10444b:	74 24                	je     104471 <boot_map_segment+0x39>
  10444d:	c7 44 24 0c 41 6c 10 	movl   $0x106c41,0xc(%esp)
  104454:	00 
  104455:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  10445c:	00 
  10445d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  104464:	00 
  104465:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10446c:	e8 77 c8 ff ff       	call   100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104471:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10447b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104480:	89 c2                	mov    %eax,%edx
  104482:	8b 45 10             	mov    0x10(%ebp),%eax
  104485:	01 c2                	add    %eax,%edx
  104487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10448a:	01 d0                	add    %edx,%eax
  10448c:	48                   	dec    %eax
  10448d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104493:	ba 00 00 00 00       	mov    $0x0,%edx
  104498:	f7 75 f0             	divl   -0x10(%ebp)
  10449b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10449e:	29 d0                	sub    %edx,%eax
  1044a0:	c1 e8 0c             	shr    $0xc,%eax
  1044a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1044a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1044ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044b4:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1044b7:	8b 45 14             	mov    0x14(%ebp),%eax
  1044ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044c5:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044c8:	eb 68                	jmp    104532 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1044ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1044d1:	00 
  1044d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1044dc:	89 04 24             	mov    %eax,(%esp)
  1044df:	e8 88 01 00 00       	call   10466c <get_pte>
  1044e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1044e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1044eb:	75 24                	jne    104511 <boot_map_segment+0xd9>
  1044ed:	c7 44 24 0c 6d 6c 10 	movl   $0x106c6d,0xc(%esp)
  1044f4:	00 
  1044f5:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1044fc:	00 
  1044fd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104504:	00 
  104505:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10450c:	e8 d7 c7 ff ff       	call   100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
  104511:	8b 45 14             	mov    0x14(%ebp),%eax
  104514:	0b 45 18             	or     0x18(%ebp),%eax
  104517:	83 c8 01             	or     $0x1,%eax
  10451a:	89 c2                	mov    %eax,%edx
  10451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104521:	ff 4d f4             	decl   -0xc(%ebp)
  104524:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10452b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104536:	75 92                	jne    1044ca <boot_map_segment+0x92>
    }
}
  104538:	90                   	nop
  104539:	90                   	nop
  10453a:	89 ec                	mov    %ebp,%esp
  10453c:	5d                   	pop    %ebp
  10453d:	c3                   	ret    

0010453e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10453e:	55                   	push   %ebp
  10453f:	89 e5                	mov    %esp,%ebp
  104541:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104544:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10454b:	e8 58 fa ff ff       	call   103fa8 <alloc_pages>
  104550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104557:	75 1c                	jne    104575 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104559:	c7 44 24 08 7a 6c 10 	movl   $0x106c7a,0x8(%esp)
  104560:	00 
  104561:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  104568:	00 
  104569:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104570:	e8 73 c7 ff ff       	call   100ce8 <__panic>
    }
    return page2kva(p);
  104575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104578:	89 04 24             	mov    %eax,(%esp)
  10457b:	e8 76 f7 ff ff       	call   103cf6 <page2kva>
}
  104580:	89 ec                	mov    %ebp,%esp
  104582:	5d                   	pop    %ebp
  104583:	c3                   	ret    

00104584 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104584:	55                   	push   %ebp
  104585:	89 e5                	mov    %esp,%ebp
  104587:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10458a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10458f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104592:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104599:	77 23                	ja     1045be <pmm_init+0x3a>
  10459b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10459e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045a2:	c7 44 24 08 f8 6b 10 	movl   $0x106bf8,0x8(%esp)
  1045a9:	00 
  1045aa:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1045b1:	00 
  1045b2:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1045b9:	e8 2a c7 ff ff       	call   100ce8 <__panic>
  1045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c1:	05 00 00 00 40       	add    $0x40000000,%eax
  1045c6:	a3 a8 ce 11 00       	mov    %eax,0x11cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1045cb:	e8 80 f9 ff ff       	call   103f50 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1045d0:	e8 6f fa ff ff       	call   104044 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1045d5:	e8 5a 02 00 00       	call   104834 <check_alloc_page>

    check_pgdir();
  1045da:	e8 76 02 00 00       	call   104855 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1045df:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1045e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045e7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1045ee:	77 23                	ja     104613 <pmm_init+0x8f>
  1045f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045f7:	c7 44 24 08 f8 6b 10 	movl   $0x106bf8,0x8(%esp)
  1045fe:	00 
  1045ff:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  104606:	00 
  104607:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10460e:	e8 d5 c6 ff ff       	call   100ce8 <__panic>
  104613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104616:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10461c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104621:	05 ac 0f 00 00       	add    $0xfac,%eax
  104626:	83 ca 03             	or     $0x3,%edx
  104629:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10462b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104630:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104637:	00 
  104638:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10463f:	00 
  104640:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104647:	38 
  104648:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10464f:	c0 
  104650:	89 04 24             	mov    %eax,(%esp)
  104653:	e8 e0 fd ff ff       	call   104438 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104658:	e8 07 f8 ff ff       	call   103e64 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10465d:	e8 91 08 00 00       	call   104ef3 <check_boot_pgdir>

    print_pgdir();
  104662:	e8 0e 0d 00 00       	call   105375 <print_pgdir>

}
  104667:	90                   	nop
  104668:	89 ec                	mov    %ebp,%esp
  10466a:	5d                   	pop    %ebp
  10466b:	c3                   	ret    

0010466c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10466c:	55                   	push   %ebp
  10466d:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10466f:	90                   	nop
  104670:	5d                   	pop    %ebp
  104671:	c3                   	ret    

00104672 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104672:	55                   	push   %ebp
  104673:	89 e5                	mov    %esp,%ebp
  104675:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104678:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10467f:	00 
  104680:	8b 45 0c             	mov    0xc(%ebp),%eax
  104683:	89 44 24 04          	mov    %eax,0x4(%esp)
  104687:	8b 45 08             	mov    0x8(%ebp),%eax
  10468a:	89 04 24             	mov    %eax,(%esp)
  10468d:	e8 da ff ff ff       	call   10466c <get_pte>
  104692:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104695:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104699:	74 08                	je     1046a3 <get_page+0x31>
        *ptep_store = ptep;
  10469b:	8b 45 10             	mov    0x10(%ebp),%eax
  10469e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046a1:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1046a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046a7:	74 1b                	je     1046c4 <get_page+0x52>
  1046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ac:	8b 00                	mov    (%eax),%eax
  1046ae:	83 e0 01             	and    $0x1,%eax
  1046b1:	85 c0                	test   %eax,%eax
  1046b3:	74 0f                	je     1046c4 <get_page+0x52>
        return pte2page(*ptep);
  1046b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b8:	8b 00                	mov    (%eax),%eax
  1046ba:	89 04 24             	mov    %eax,(%esp)
  1046bd:	e8 8a f6 ff ff       	call   103d4c <pte2page>
  1046c2:	eb 05                	jmp    1046c9 <get_page+0x57>
    }
    return NULL;
  1046c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1046c9:	89 ec                	mov    %ebp,%esp
  1046cb:	5d                   	pop    %ebp
  1046cc:	c3                   	ret    

001046cd <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1046cd:	55                   	push   %ebp
  1046ce:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1046d0:	90                   	nop
  1046d1:	5d                   	pop    %ebp
  1046d2:	c3                   	ret    

001046d3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1046d3:	55                   	push   %ebp
  1046d4:	89 e5                	mov    %esp,%ebp
  1046d6:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1046d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046e0:	00 
  1046e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046eb:	89 04 24             	mov    %eax,(%esp)
  1046ee:	e8 79 ff ff ff       	call   10466c <get_pte>
  1046f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1046f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1046fa:	74 19                	je     104715 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1046ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  104703:	8b 45 0c             	mov    0xc(%ebp),%eax
  104706:	89 44 24 04          	mov    %eax,0x4(%esp)
  10470a:	8b 45 08             	mov    0x8(%ebp),%eax
  10470d:	89 04 24             	mov    %eax,(%esp)
  104710:	e8 b8 ff ff ff       	call   1046cd <page_remove_pte>
    }
}
  104715:	90                   	nop
  104716:	89 ec                	mov    %ebp,%esp
  104718:	5d                   	pop    %ebp
  104719:	c3                   	ret    

0010471a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10471a:	55                   	push   %ebp
  10471b:	89 e5                	mov    %esp,%ebp
  10471d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104720:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104727:	00 
  104728:	8b 45 10             	mov    0x10(%ebp),%eax
  10472b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10472f:	8b 45 08             	mov    0x8(%ebp),%eax
  104732:	89 04 24             	mov    %eax,(%esp)
  104735:	e8 32 ff ff ff       	call   10466c <get_pte>
  10473a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10473d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104741:	75 0a                	jne    10474d <page_insert+0x33>
        return -E_NO_MEM;
  104743:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104748:	e9 84 00 00 00       	jmp    1047d1 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10474d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104750:	89 04 24             	mov    %eax,(%esp)
  104753:	e8 58 f6 ff ff       	call   103db0 <page_ref_inc>
    if (*ptep & PTE_P) {
  104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475b:	8b 00                	mov    (%eax),%eax
  10475d:	83 e0 01             	and    $0x1,%eax
  104760:	85 c0                	test   %eax,%eax
  104762:	74 3e                	je     1047a2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104767:	8b 00                	mov    (%eax),%eax
  104769:	89 04 24             	mov    %eax,(%esp)
  10476c:	e8 db f5 ff ff       	call   103d4c <pte2page>
  104771:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104777:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10477a:	75 0d                	jne    104789 <page_insert+0x6f>
            page_ref_dec(page);
  10477c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10477f:	89 04 24             	mov    %eax,(%esp)
  104782:	e8 40 f6 ff ff       	call   103dc7 <page_ref_dec>
  104787:	eb 19                	jmp    1047a2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10478c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104790:	8b 45 10             	mov    0x10(%ebp),%eax
  104793:	89 44 24 04          	mov    %eax,0x4(%esp)
  104797:	8b 45 08             	mov    0x8(%ebp),%eax
  10479a:	89 04 24             	mov    %eax,(%esp)
  10479d:	e8 2b ff ff ff       	call   1046cd <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a5:	89 04 24             	mov    %eax,(%esp)
  1047a8:	e8 e0 f4 ff ff       	call   103c8d <page2pa>
  1047ad:	0b 45 14             	or     0x14(%ebp),%eax
  1047b0:	83 c8 01             	or     $0x1,%eax
  1047b3:	89 c2                	mov    %eax,%edx
  1047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1047ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1047bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c4:	89 04 24             	mov    %eax,(%esp)
  1047c7:	e8 09 00 00 00       	call   1047d5 <tlb_invalidate>
    return 0;
  1047cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047d1:	89 ec                	mov    %ebp,%esp
  1047d3:	5d                   	pop    %ebp
  1047d4:	c3                   	ret    

001047d5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1047d5:	55                   	push   %ebp
  1047d6:	89 e5                	mov    %esp,%ebp
  1047d8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1047db:	0f 20 d8             	mov    %cr3,%eax
  1047de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1047e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1047e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047ea:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1047f1:	77 23                	ja     104816 <tlb_invalidate+0x41>
  1047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047fa:	c7 44 24 08 f8 6b 10 	movl   $0x106bf8,0x8(%esp)
  104801:	00 
  104802:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
  104809:	00 
  10480a:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104811:	e8 d2 c4 ff ff       	call   100ce8 <__panic>
  104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104819:	05 00 00 00 40       	add    $0x40000000,%eax
  10481e:	39 d0                	cmp    %edx,%eax
  104820:	75 0d                	jne    10482f <tlb_invalidate+0x5a>
        invlpg((void *)la);
  104822:	8b 45 0c             	mov    0xc(%ebp),%eax
  104825:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10482b:	0f 01 38             	invlpg (%eax)
}
  10482e:	90                   	nop
    }
}
  10482f:	90                   	nop
  104830:	89 ec                	mov    %ebp,%esp
  104832:	5d                   	pop    %ebp
  104833:	c3                   	ret    

00104834 <check_alloc_page>:

static void
check_alloc_page(void) {
  104834:	55                   	push   %ebp
  104835:	89 e5                	mov    %esp,%ebp
  104837:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10483a:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  10483f:	8b 40 18             	mov    0x18(%eax),%eax
  104842:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104844:	c7 04 24 94 6c 10 00 	movl   $0x106c94,(%esp)
  10484b:	e8 06 bb ff ff       	call   100356 <cprintf>
}
  104850:	90                   	nop
  104851:	89 ec                	mov    %ebp,%esp
  104853:	5d                   	pop    %ebp
  104854:	c3                   	ret    

00104855 <check_pgdir>:

static void
check_pgdir(void) {
  104855:	55                   	push   %ebp
  104856:	89 e5                	mov    %esp,%ebp
  104858:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10485b:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104860:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104865:	76 24                	jbe    10488b <check_pgdir+0x36>
  104867:	c7 44 24 0c b3 6c 10 	movl   $0x106cb3,0xc(%esp)
  10486e:	00 
  10486f:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104876:	00 
  104877:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  10487e:	00 
  10487f:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104886:	e8 5d c4 ff ff       	call   100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10488b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104890:	85 c0                	test   %eax,%eax
  104892:	74 0e                	je     1048a2 <check_pgdir+0x4d>
  104894:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104899:	25 ff 0f 00 00       	and    $0xfff,%eax
  10489e:	85 c0                	test   %eax,%eax
  1048a0:	74 24                	je     1048c6 <check_pgdir+0x71>
  1048a2:	c7 44 24 0c d0 6c 10 	movl   $0x106cd0,0xc(%esp)
  1048a9:	00 
  1048aa:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1048b1:	00 
  1048b2:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
  1048b9:	00 
  1048ba:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1048c1:	e8 22 c4 ff ff       	call   100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1048c6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1048cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048d2:	00 
  1048d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048da:	00 
  1048db:	89 04 24             	mov    %eax,(%esp)
  1048de:	e8 8f fd ff ff       	call   104672 <get_page>
  1048e3:	85 c0                	test   %eax,%eax
  1048e5:	74 24                	je     10490b <check_pgdir+0xb6>
  1048e7:	c7 44 24 0c 08 6d 10 	movl   $0x106d08,0xc(%esp)
  1048ee:	00 
  1048ef:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1048f6:	00 
  1048f7:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
  1048fe:	00 
  1048ff:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104906:	e8 dd c3 ff ff       	call   100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10490b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104912:	e8 91 f6 ff ff       	call   103fa8 <alloc_pages>
  104917:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10491a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10491f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104926:	00 
  104927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10492e:	00 
  10492f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104932:	89 54 24 04          	mov    %edx,0x4(%esp)
  104936:	89 04 24             	mov    %eax,(%esp)
  104939:	e8 dc fd ff ff       	call   10471a <page_insert>
  10493e:	85 c0                	test   %eax,%eax
  104940:	74 24                	je     104966 <check_pgdir+0x111>
  104942:	c7 44 24 0c 30 6d 10 	movl   $0x106d30,0xc(%esp)
  104949:	00 
  10494a:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104951:	00 
  104952:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  104959:	00 
  10495a:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104961:	e8 82 c3 ff ff       	call   100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104966:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10496b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104972:	00 
  104973:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10497a:	00 
  10497b:	89 04 24             	mov    %eax,(%esp)
  10497e:	e8 e9 fc ff ff       	call   10466c <get_pte>
  104983:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10498a:	75 24                	jne    1049b0 <check_pgdir+0x15b>
  10498c:	c7 44 24 0c 5c 6d 10 	movl   $0x106d5c,0xc(%esp)
  104993:	00 
  104994:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  10499b:	00 
  10499c:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  1049a3:	00 
  1049a4:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1049ab:	e8 38 c3 ff ff       	call   100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
  1049b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049b3:	8b 00                	mov    (%eax),%eax
  1049b5:	89 04 24             	mov    %eax,(%esp)
  1049b8:	e8 8f f3 ff ff       	call   103d4c <pte2page>
  1049bd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1049c0:	74 24                	je     1049e6 <check_pgdir+0x191>
  1049c2:	c7 44 24 0c 89 6d 10 	movl   $0x106d89,0xc(%esp)
  1049c9:	00 
  1049ca:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1049d1:	00 
  1049d2:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  1049d9:	00 
  1049da:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1049e1:	e8 02 c3 ff ff       	call   100ce8 <__panic>
    assert(page_ref(p1) == 1);
  1049e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e9:	89 04 24             	mov    %eax,(%esp)
  1049ec:	e8 b5 f3 ff ff       	call   103da6 <page_ref>
  1049f1:	83 f8 01             	cmp    $0x1,%eax
  1049f4:	74 24                	je     104a1a <check_pgdir+0x1c5>
  1049f6:	c7 44 24 0c 9f 6d 10 	movl   $0x106d9f,0xc(%esp)
  1049fd:	00 
  1049fe:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104a05:	00 
  104a06:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104a0d:	00 
  104a0e:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104a15:	e8 ce c2 ff ff       	call   100ce8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104a1a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a1f:	8b 00                	mov    (%eax),%eax
  104a21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a2c:	c1 e8 0c             	shr    $0xc,%eax
  104a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a32:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104a37:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a3a:	72 23                	jb     104a5f <check_pgdir+0x20a>
  104a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a43:	c7 44 24 08 54 6b 10 	movl   $0x106b54,0x8(%esp)
  104a4a:	00 
  104a4b:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
  104a52:	00 
  104a53:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104a5a:	e8 89 c2 ff ff       	call   100ce8 <__panic>
  104a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a62:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a67:	83 c0 04             	add    $0x4,%eax
  104a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a6d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a79:	00 
  104a7a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a81:	00 
  104a82:	89 04 24             	mov    %eax,(%esp)
  104a85:	e8 e2 fb ff ff       	call   10466c <get_pte>
  104a8a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a8d:	74 24                	je     104ab3 <check_pgdir+0x25e>
  104a8f:	c7 44 24 0c b4 6d 10 	movl   $0x106db4,0xc(%esp)
  104a96:	00 
  104a97:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
  104aa6:	00 
  104aa7:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104aae:	e8 35 c2 ff ff       	call   100ce8 <__panic>

    p2 = alloc_page();
  104ab3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104aba:	e8 e9 f4 ff ff       	call   103fa8 <alloc_pages>
  104abf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104ac2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ac7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ace:	00 
  104acf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104ad6:	00 
  104ad7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ada:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ade:	89 04 24             	mov    %eax,(%esp)
  104ae1:	e8 34 fc ff ff       	call   10471a <page_insert>
  104ae6:	85 c0                	test   %eax,%eax
  104ae8:	74 24                	je     104b0e <check_pgdir+0x2b9>
  104aea:	c7 44 24 0c dc 6d 10 	movl   $0x106ddc,0xc(%esp)
  104af1:	00 
  104af2:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104af9:	00 
  104afa:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104b01:	00 
  104b02:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104b09:	e8 da c1 ff ff       	call   100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b0e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b1a:	00 
  104b1b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b22:	00 
  104b23:	89 04 24             	mov    %eax,(%esp)
  104b26:	e8 41 fb ff ff       	call   10466c <get_pte>
  104b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b32:	75 24                	jne    104b58 <check_pgdir+0x303>
  104b34:	c7 44 24 0c 14 6e 10 	movl   $0x106e14,0xc(%esp)
  104b3b:	00 
  104b3c:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104b43:	00 
  104b44:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104b4b:	00 
  104b4c:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104b53:	e8 90 c1 ff ff       	call   100ce8 <__panic>
    assert(*ptep & PTE_U);
  104b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b5b:	8b 00                	mov    (%eax),%eax
  104b5d:	83 e0 04             	and    $0x4,%eax
  104b60:	85 c0                	test   %eax,%eax
  104b62:	75 24                	jne    104b88 <check_pgdir+0x333>
  104b64:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104b73:	00 
  104b74:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104b7b:	00 
  104b7c:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104b83:	e8 60 c1 ff ff       	call   100ce8 <__panic>
    assert(*ptep & PTE_W);
  104b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b8b:	8b 00                	mov    (%eax),%eax
  104b8d:	83 e0 02             	and    $0x2,%eax
  104b90:	85 c0                	test   %eax,%eax
  104b92:	75 24                	jne    104bb8 <check_pgdir+0x363>
  104b94:	c7 44 24 0c 52 6e 10 	movl   $0x106e52,0xc(%esp)
  104b9b:	00 
  104b9c:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104ba3:	00 
  104ba4:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104bab:	00 
  104bac:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104bb3:	e8 30 c1 ff ff       	call   100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104bb8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104bbd:	8b 00                	mov    (%eax),%eax
  104bbf:	83 e0 04             	and    $0x4,%eax
  104bc2:	85 c0                	test   %eax,%eax
  104bc4:	75 24                	jne    104bea <check_pgdir+0x395>
  104bc6:	c7 44 24 0c 60 6e 10 	movl   $0x106e60,0xc(%esp)
  104bcd:	00 
  104bce:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104bd5:	00 
  104bd6:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  104bdd:	00 
  104bde:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104be5:	e8 fe c0 ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 1);
  104bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bed:	89 04 24             	mov    %eax,(%esp)
  104bf0:	e8 b1 f1 ff ff       	call   103da6 <page_ref>
  104bf5:	83 f8 01             	cmp    $0x1,%eax
  104bf8:	74 24                	je     104c1e <check_pgdir+0x3c9>
  104bfa:	c7 44 24 0c 76 6e 10 	movl   $0x106e76,0xc(%esp)
  104c01:	00 
  104c02:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104c09:	00 
  104c0a:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104c11:	00 
  104c12:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104c19:	e8 ca c0 ff ff       	call   100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104c1e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104c23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104c2a:	00 
  104c2b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c32:	00 
  104c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c36:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c3a:	89 04 24             	mov    %eax,(%esp)
  104c3d:	e8 d8 fa ff ff       	call   10471a <page_insert>
  104c42:	85 c0                	test   %eax,%eax
  104c44:	74 24                	je     104c6a <check_pgdir+0x415>
  104c46:	c7 44 24 0c 88 6e 10 	movl   $0x106e88,0xc(%esp)
  104c4d:	00 
  104c4e:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104c55:	00 
  104c56:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104c5d:	00 
  104c5e:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104c65:	e8 7e c0 ff ff       	call   100ce8 <__panic>
    assert(page_ref(p1) == 2);
  104c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c6d:	89 04 24             	mov    %eax,(%esp)
  104c70:	e8 31 f1 ff ff       	call   103da6 <page_ref>
  104c75:	83 f8 02             	cmp    $0x2,%eax
  104c78:	74 24                	je     104c9e <check_pgdir+0x449>
  104c7a:	c7 44 24 0c b4 6e 10 	movl   $0x106eb4,0xc(%esp)
  104c81:	00 
  104c82:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104c89:	00 
  104c8a:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104c91:	00 
  104c92:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104c99:	e8 4a c0 ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ca1:	89 04 24             	mov    %eax,(%esp)
  104ca4:	e8 fd f0 ff ff       	call   103da6 <page_ref>
  104ca9:	85 c0                	test   %eax,%eax
  104cab:	74 24                	je     104cd1 <check_pgdir+0x47c>
  104cad:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  104cb4:	00 
  104cb5:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104cbc:	00 
  104cbd:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104cc4:	00 
  104cc5:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104ccc:	e8 17 c0 ff ff       	call   100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104cd1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104cd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cdd:	00 
  104cde:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ce5:	00 
  104ce6:	89 04 24             	mov    %eax,(%esp)
  104ce9:	e8 7e f9 ff ff       	call   10466c <get_pte>
  104cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cf5:	75 24                	jne    104d1b <check_pgdir+0x4c6>
  104cf7:	c7 44 24 0c 14 6e 10 	movl   $0x106e14,0xc(%esp)
  104cfe:	00 
  104cff:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104d06:	00 
  104d07:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104d0e:	00 
  104d0f:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104d16:	e8 cd bf ff ff       	call   100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
  104d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d1e:	8b 00                	mov    (%eax),%eax
  104d20:	89 04 24             	mov    %eax,(%esp)
  104d23:	e8 24 f0 ff ff       	call   103d4c <pte2page>
  104d28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104d2b:	74 24                	je     104d51 <check_pgdir+0x4fc>
  104d2d:	c7 44 24 0c 89 6d 10 	movl   $0x106d89,0xc(%esp)
  104d34:	00 
  104d35:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104d3c:	00 
  104d3d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104d44:	00 
  104d45:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104d4c:	e8 97 bf ff ff       	call   100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
  104d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d54:	8b 00                	mov    (%eax),%eax
  104d56:	83 e0 04             	and    $0x4,%eax
  104d59:	85 c0                	test   %eax,%eax
  104d5b:	74 24                	je     104d81 <check_pgdir+0x52c>
  104d5d:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104d64:	00 
  104d65:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104d6c:	00 
  104d6d:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  104d74:	00 
  104d75:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104d7c:	e8 67 bf ff ff       	call   100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
  104d81:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104d86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d8d:	00 
  104d8e:	89 04 24             	mov    %eax,(%esp)
  104d91:	e8 3d f9 ff ff       	call   1046d3 <page_remove>
    assert(page_ref(p1) == 1);
  104d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d99:	89 04 24             	mov    %eax,(%esp)
  104d9c:	e8 05 f0 ff ff       	call   103da6 <page_ref>
  104da1:	83 f8 01             	cmp    $0x1,%eax
  104da4:	74 24                	je     104dca <check_pgdir+0x575>
  104da6:	c7 44 24 0c 9f 6d 10 	movl   $0x106d9f,0xc(%esp)
  104dad:	00 
  104dae:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104db5:	00 
  104db6:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  104dbd:	00 
  104dbe:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104dc5:	e8 1e bf ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dcd:	89 04 24             	mov    %eax,(%esp)
  104dd0:	e8 d1 ef ff ff       	call   103da6 <page_ref>
  104dd5:	85 c0                	test   %eax,%eax
  104dd7:	74 24                	je     104dfd <check_pgdir+0x5a8>
  104dd9:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  104de0:	00 
  104de1:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104de8:	00 
  104de9:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104df0:	00 
  104df1:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104df8:	e8 eb be ff ff       	call   100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104dfd:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104e02:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e09:	00 
  104e0a:	89 04 24             	mov    %eax,(%esp)
  104e0d:	e8 c1 f8 ff ff       	call   1046d3 <page_remove>
    assert(page_ref(p1) == 0);
  104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e15:	89 04 24             	mov    %eax,(%esp)
  104e18:	e8 89 ef ff ff       	call   103da6 <page_ref>
  104e1d:	85 c0                	test   %eax,%eax
  104e1f:	74 24                	je     104e45 <check_pgdir+0x5f0>
  104e21:	c7 44 24 0c ed 6e 10 	movl   $0x106eed,0xc(%esp)
  104e28:	00 
  104e29:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104e30:	00 
  104e31:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104e38:	00 
  104e39:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104e40:	e8 a3 be ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e48:	89 04 24             	mov    %eax,(%esp)
  104e4b:	e8 56 ef ff ff       	call   103da6 <page_ref>
  104e50:	85 c0                	test   %eax,%eax
  104e52:	74 24                	je     104e78 <check_pgdir+0x623>
  104e54:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  104e5b:	00 
  104e5c:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104e63:	00 
  104e64:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104e6b:	00 
  104e6c:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104e73:	e8 70 be ff ff       	call   100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104e78:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104e7d:	8b 00                	mov    (%eax),%eax
  104e7f:	89 04 24             	mov    %eax,(%esp)
  104e82:	e8 05 ef ff ff       	call   103d8c <pde2page>
  104e87:	89 04 24             	mov    %eax,(%esp)
  104e8a:	e8 17 ef ff ff       	call   103da6 <page_ref>
  104e8f:	83 f8 01             	cmp    $0x1,%eax
  104e92:	74 24                	je     104eb8 <check_pgdir+0x663>
  104e94:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104e9b:	00 
  104e9c:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104ea3:	00 
  104ea4:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104eab:	00 
  104eac:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104eb3:	e8 30 be ff ff       	call   100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104eb8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ebd:	8b 00                	mov    (%eax),%eax
  104ebf:	89 04 24             	mov    %eax,(%esp)
  104ec2:	e8 c5 ee ff ff       	call   103d8c <pde2page>
  104ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ece:	00 
  104ecf:	89 04 24             	mov    %eax,(%esp)
  104ed2:	e8 0b f1 ff ff       	call   103fe2 <free_pages>
    boot_pgdir[0] = 0;
  104ed7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104edc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104ee2:	c7 04 24 27 6f 10 00 	movl   $0x106f27,(%esp)
  104ee9:	e8 68 b4 ff ff       	call   100356 <cprintf>
}
  104eee:	90                   	nop
  104eef:	89 ec                	mov    %ebp,%esp
  104ef1:	5d                   	pop    %ebp
  104ef2:	c3                   	ret    

00104ef3 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104ef3:	55                   	push   %ebp
  104ef4:	89 e5                	mov    %esp,%ebp
  104ef6:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f00:	e9 ca 00 00 00       	jmp    104fcf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f0e:	c1 e8 0c             	shr    $0xc,%eax
  104f11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104f14:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104f19:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104f1c:	72 23                	jb     104f41 <check_boot_pgdir+0x4e>
  104f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f25:	c7 44 24 08 54 6b 10 	movl   $0x106b54,0x8(%esp)
  104f2c:	00 
  104f2d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104f34:	00 
  104f35:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104f3c:	e8 a7 bd ff ff       	call   100ce8 <__panic>
  104f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f44:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f49:	89 c2                	mov    %eax,%edx
  104f4b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104f50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f57:	00 
  104f58:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f5c:	89 04 24             	mov    %eax,(%esp)
  104f5f:	e8 08 f7 ff ff       	call   10466c <get_pte>
  104f64:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104f67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104f6b:	75 24                	jne    104f91 <check_boot_pgdir+0x9e>
  104f6d:	c7 44 24 0c 44 6f 10 	movl   $0x106f44,0xc(%esp)
  104f74:	00 
  104f75:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104f7c:	00 
  104f7d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104f84:	00 
  104f85:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104f8c:	e8 57 bd ff ff       	call   100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f94:	8b 00                	mov    (%eax),%eax
  104f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f9b:	89 c2                	mov    %eax,%edx
  104f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fa0:	39 c2                	cmp    %eax,%edx
  104fa2:	74 24                	je     104fc8 <check_boot_pgdir+0xd5>
  104fa4:	c7 44 24 0c 81 6f 10 	movl   $0x106f81,0xc(%esp)
  104fab:	00 
  104fac:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  104fb3:	00 
  104fb4:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104fbb:	00 
  104fbc:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  104fc3:	e8 20 bd ff ff       	call   100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104fc8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104fd2:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104fd7:	39 c2                	cmp    %eax,%edx
  104fd9:	0f 82 26 ff ff ff    	jb     104f05 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104fdf:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fe4:	05 ac 0f 00 00       	add    $0xfac,%eax
  104fe9:	8b 00                	mov    (%eax),%eax
  104feb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ff0:	89 c2                	mov    %eax,%edx
  104ff2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ffa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105001:	77 23                	ja     105026 <check_boot_pgdir+0x133>
  105003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105006:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10500a:	c7 44 24 08 f8 6b 10 	movl   $0x106bf8,0x8(%esp)
  105011:	00 
  105012:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  105019:	00 
  10501a:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  105021:	e8 c2 bc ff ff       	call   100ce8 <__panic>
  105026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105029:	05 00 00 00 40       	add    $0x40000000,%eax
  10502e:	39 d0                	cmp    %edx,%eax
  105030:	74 24                	je     105056 <check_boot_pgdir+0x163>
  105032:	c7 44 24 0c 98 6f 10 	movl   $0x106f98,0xc(%esp)
  105039:	00 
  10503a:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  105041:	00 
  105042:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  105049:	00 
  10504a:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  105051:	e8 92 bc ff ff       	call   100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
  105056:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10505b:	8b 00                	mov    (%eax),%eax
  10505d:	85 c0                	test   %eax,%eax
  10505f:	74 24                	je     105085 <check_boot_pgdir+0x192>
  105061:	c7 44 24 0c cc 6f 10 	movl   $0x106fcc,0xc(%esp)
  105068:	00 
  105069:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  105070:	00 
  105071:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  105078:	00 
  105079:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  105080:	e8 63 bc ff ff       	call   100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
  105085:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10508c:	e8 17 ef ff ff       	call   103fa8 <alloc_pages>
  105091:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105094:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105099:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050a0:	00 
  1050a1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1050a8:	00 
  1050a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050b0:	89 04 24             	mov    %eax,(%esp)
  1050b3:	e8 62 f6 ff ff       	call   10471a <page_insert>
  1050b8:	85 c0                	test   %eax,%eax
  1050ba:	74 24                	je     1050e0 <check_boot_pgdir+0x1ed>
  1050bc:	c7 44 24 0c e0 6f 10 	movl   $0x106fe0,0xc(%esp)
  1050c3:	00 
  1050c4:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1050cb:	00 
  1050cc:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  1050d3:	00 
  1050d4:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1050db:	e8 08 bc ff ff       	call   100ce8 <__panic>
    assert(page_ref(p) == 1);
  1050e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050e3:	89 04 24             	mov    %eax,(%esp)
  1050e6:	e8 bb ec ff ff       	call   103da6 <page_ref>
  1050eb:	83 f8 01             	cmp    $0x1,%eax
  1050ee:	74 24                	je     105114 <check_boot_pgdir+0x221>
  1050f0:	c7 44 24 0c 0e 70 10 	movl   $0x10700e,0xc(%esp)
  1050f7:	00 
  1050f8:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1050ff:	00 
  105100:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105107:	00 
  105108:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10510f:	e8 d4 bb ff ff       	call   100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105114:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105119:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105120:	00 
  105121:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105128:	00 
  105129:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10512c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105130:	89 04 24             	mov    %eax,(%esp)
  105133:	e8 e2 f5 ff ff       	call   10471a <page_insert>
  105138:	85 c0                	test   %eax,%eax
  10513a:	74 24                	je     105160 <check_boot_pgdir+0x26d>
  10513c:	c7 44 24 0c 20 70 10 	movl   $0x107020,0xc(%esp)
  105143:	00 
  105144:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  10514b:	00 
  10514c:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  105153:	00 
  105154:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10515b:	e8 88 bb ff ff       	call   100ce8 <__panic>
    assert(page_ref(p) == 2);
  105160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105163:	89 04 24             	mov    %eax,(%esp)
  105166:	e8 3b ec ff ff       	call   103da6 <page_ref>
  10516b:	83 f8 02             	cmp    $0x2,%eax
  10516e:	74 24                	je     105194 <check_boot_pgdir+0x2a1>
  105170:	c7 44 24 0c 57 70 10 	movl   $0x107057,0xc(%esp)
  105177:	00 
  105178:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  10517f:	00 
  105180:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  105187:	00 
  105188:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10518f:	e8 54 bb ff ff       	call   100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
  105194:	c7 45 e8 68 70 10 00 	movl   $0x107068,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10519b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10519e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051a9:	e8 fc 09 00 00       	call   105baa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1051ae:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1051b5:	00 
  1051b6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051bd:	e8 60 0a 00 00       	call   105c22 <strcmp>
  1051c2:	85 c0                	test   %eax,%eax
  1051c4:	74 24                	je     1051ea <check_boot_pgdir+0x2f7>
  1051c6:	c7 44 24 0c 80 70 10 	movl   $0x107080,0xc(%esp)
  1051cd:	00 
  1051ce:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  1051d5:	00 
  1051d6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  1051dd:	00 
  1051de:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  1051e5:	e8 fe ba ff ff       	call   100ce8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1051ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051ed:	89 04 24             	mov    %eax,(%esp)
  1051f0:	e8 01 eb ff ff       	call   103cf6 <page2kva>
  1051f5:	05 00 01 00 00       	add    $0x100,%eax
  1051fa:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1051fd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105204:	e8 47 09 00 00       	call   105b50 <strlen>
  105209:	85 c0                	test   %eax,%eax
  10520b:	74 24                	je     105231 <check_boot_pgdir+0x33e>
  10520d:	c7 44 24 0c b8 70 10 	movl   $0x1070b8,0xc(%esp)
  105214:	00 
  105215:	c7 44 24 08 58 6c 10 	movl   $0x106c58,0x8(%esp)
  10521c:	00 
  10521d:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  105224:	00 
  105225:	c7 04 24 1c 6c 10 00 	movl   $0x106c1c,(%esp)
  10522c:	e8 b7 ba ff ff       	call   100ce8 <__panic>

    free_page(p);
  105231:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105238:	00 
  105239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10523c:	89 04 24             	mov    %eax,(%esp)
  10523f:	e8 9e ed ff ff       	call   103fe2 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105244:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105249:	8b 00                	mov    (%eax),%eax
  10524b:	89 04 24             	mov    %eax,(%esp)
  10524e:	e8 39 eb ff ff       	call   103d8c <pde2page>
  105253:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10525a:	00 
  10525b:	89 04 24             	mov    %eax,(%esp)
  10525e:	e8 7f ed ff ff       	call   103fe2 <free_pages>
    boot_pgdir[0] = 0;
  105263:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10526e:	c7 04 24 dc 70 10 00 	movl   $0x1070dc,(%esp)
  105275:	e8 dc b0 ff ff       	call   100356 <cprintf>
}
  10527a:	90                   	nop
  10527b:	89 ec                	mov    %ebp,%esp
  10527d:	5d                   	pop    %ebp
  10527e:	c3                   	ret    

0010527f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10527f:	55                   	push   %ebp
  105280:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105282:	8b 45 08             	mov    0x8(%ebp),%eax
  105285:	83 e0 04             	and    $0x4,%eax
  105288:	85 c0                	test   %eax,%eax
  10528a:	74 04                	je     105290 <perm2str+0x11>
  10528c:	b0 75                	mov    $0x75,%al
  10528e:	eb 02                	jmp    105292 <perm2str+0x13>
  105290:	b0 2d                	mov    $0x2d,%al
  105292:	a2 28 cf 11 00       	mov    %al,0x11cf28
    str[1] = 'r';
  105297:	c6 05 29 cf 11 00 72 	movb   $0x72,0x11cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10529e:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a1:	83 e0 02             	and    $0x2,%eax
  1052a4:	85 c0                	test   %eax,%eax
  1052a6:	74 04                	je     1052ac <perm2str+0x2d>
  1052a8:	b0 77                	mov    $0x77,%al
  1052aa:	eb 02                	jmp    1052ae <perm2str+0x2f>
  1052ac:	b0 2d                	mov    $0x2d,%al
  1052ae:	a2 2a cf 11 00       	mov    %al,0x11cf2a
    str[3] = '\0';
  1052b3:	c6 05 2b cf 11 00 00 	movb   $0x0,0x11cf2b
    return str;
  1052ba:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
}
  1052bf:	5d                   	pop    %ebp
  1052c0:	c3                   	ret    

001052c1 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1052c1:	55                   	push   %ebp
  1052c2:	89 e5                	mov    %esp,%ebp
  1052c4:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1052c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052cd:	72 0d                	jb     1052dc <get_pgtable_items+0x1b>
        return 0;
  1052cf:	b8 00 00 00 00       	mov    $0x0,%eax
  1052d4:	e9 98 00 00 00       	jmp    105371 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1052d9:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1052dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052e2:	73 18                	jae    1052fc <get_pgtable_items+0x3b>
  1052e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1052e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1052f1:	01 d0                	add    %edx,%eax
  1052f3:	8b 00                	mov    (%eax),%eax
  1052f5:	83 e0 01             	and    $0x1,%eax
  1052f8:	85 c0                	test   %eax,%eax
  1052fa:	74 dd                	je     1052d9 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1052fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105302:	73 68                	jae    10536c <get_pgtable_items+0xab>
        if (left_store != NULL) {
  105304:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105308:	74 08                	je     105312 <get_pgtable_items+0x51>
            *left_store = start;
  10530a:	8b 45 18             	mov    0x18(%ebp),%eax
  10530d:	8b 55 10             	mov    0x10(%ebp),%edx
  105310:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105312:	8b 45 10             	mov    0x10(%ebp),%eax
  105315:	8d 50 01             	lea    0x1(%eax),%edx
  105318:	89 55 10             	mov    %edx,0x10(%ebp)
  10531b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105322:	8b 45 14             	mov    0x14(%ebp),%eax
  105325:	01 d0                	add    %edx,%eax
  105327:	8b 00                	mov    (%eax),%eax
  105329:	83 e0 07             	and    $0x7,%eax
  10532c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10532f:	eb 03                	jmp    105334 <get_pgtable_items+0x73>
            start ++;
  105331:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105334:	8b 45 10             	mov    0x10(%ebp),%eax
  105337:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10533a:	73 1d                	jae    105359 <get_pgtable_items+0x98>
  10533c:	8b 45 10             	mov    0x10(%ebp),%eax
  10533f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105346:	8b 45 14             	mov    0x14(%ebp),%eax
  105349:	01 d0                	add    %edx,%eax
  10534b:	8b 00                	mov    (%eax),%eax
  10534d:	83 e0 07             	and    $0x7,%eax
  105350:	89 c2                	mov    %eax,%edx
  105352:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105355:	39 c2                	cmp    %eax,%edx
  105357:	74 d8                	je     105331 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  105359:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10535d:	74 08                	je     105367 <get_pgtable_items+0xa6>
            *right_store = start;
  10535f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105362:	8b 55 10             	mov    0x10(%ebp),%edx
  105365:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105367:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10536a:	eb 05                	jmp    105371 <get_pgtable_items+0xb0>
    }
    return 0;
  10536c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105371:	89 ec                	mov    %ebp,%esp
  105373:	5d                   	pop    %ebp
  105374:	c3                   	ret    

00105375 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105375:	55                   	push   %ebp
  105376:	89 e5                	mov    %esp,%ebp
  105378:	57                   	push   %edi
  105379:	56                   	push   %esi
  10537a:	53                   	push   %ebx
  10537b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10537e:	c7 04 24 fc 70 10 00 	movl   $0x1070fc,(%esp)
  105385:	e8 cc af ff ff       	call   100356 <cprintf>
    size_t left, right = 0, perm;
  10538a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105391:	e9 f2 00 00 00       	jmp    105488 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105399:	89 04 24             	mov    %eax,(%esp)
  10539c:	e8 de fe ff ff       	call   10527f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1053a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053a7:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053a9:	89 d6                	mov    %edx,%esi
  1053ab:	c1 e6 16             	shl    $0x16,%esi
  1053ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053b1:	89 d3                	mov    %edx,%ebx
  1053b3:	c1 e3 16             	shl    $0x16,%ebx
  1053b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053b9:	89 d1                	mov    %edx,%ecx
  1053bb:	c1 e1 16             	shl    $0x16,%ecx
  1053be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053c1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1053c4:	29 fa                	sub    %edi,%edx
  1053c6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053ca:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053da:	c7 04 24 2d 71 10 00 	movl   $0x10712d,(%esp)
  1053e1:	e8 70 af ff ff       	call   100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1053e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053e9:	c1 e0 0a             	shl    $0xa,%eax
  1053ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053ef:	eb 50                	jmp    105441 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053f4:	89 04 24             	mov    %eax,(%esp)
  1053f7:	e8 83 fe ff ff       	call   10527f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105402:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105404:	89 d6                	mov    %edx,%esi
  105406:	c1 e6 0c             	shl    $0xc,%esi
  105409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10540c:	89 d3                	mov    %edx,%ebx
  10540e:	c1 e3 0c             	shl    $0xc,%ebx
  105411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105414:	89 d1                	mov    %edx,%ecx
  105416:	c1 e1 0c             	shl    $0xc,%ecx
  105419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10541c:	8b 7d d8             	mov    -0x28(%ebp),%edi
  10541f:	29 fa                	sub    %edi,%edx
  105421:	89 44 24 14          	mov    %eax,0x14(%esp)
  105425:	89 74 24 10          	mov    %esi,0x10(%esp)
  105429:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10542d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105431:	89 54 24 04          	mov    %edx,0x4(%esp)
  105435:	c7 04 24 4c 71 10 00 	movl   $0x10714c,(%esp)
  10543c:	e8 15 af ff ff       	call   100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105441:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  105446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105449:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10544c:	89 d3                	mov    %edx,%ebx
  10544e:	c1 e3 0a             	shl    $0xa,%ebx
  105451:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105454:	89 d1                	mov    %edx,%ecx
  105456:	c1 e1 0a             	shl    $0xa,%ecx
  105459:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10545c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105460:	8d 55 d8             	lea    -0x28(%ebp),%edx
  105463:	89 54 24 10          	mov    %edx,0x10(%esp)
  105467:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10546b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10546f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105473:	89 0c 24             	mov    %ecx,(%esp)
  105476:	e8 46 fe ff ff       	call   1052c1 <get_pgtable_items>
  10547b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10547e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105482:	0f 85 69 ff ff ff    	jne    1053f1 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105488:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10548d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105490:	8d 55 dc             	lea    -0x24(%ebp),%edx
  105493:	89 54 24 14          	mov    %edx,0x14(%esp)
  105497:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10549a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10549e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1054ad:	00 
  1054ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054b5:	e8 07 fe ff ff       	call   1052c1 <get_pgtable_items>
  1054ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054c1:	0f 85 cf fe ff ff    	jne    105396 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1054c7:	c7 04 24 70 71 10 00 	movl   $0x107170,(%esp)
  1054ce:	e8 83 ae ff ff       	call   100356 <cprintf>
}
  1054d3:	90                   	nop
  1054d4:	83 c4 4c             	add    $0x4c,%esp
  1054d7:	5b                   	pop    %ebx
  1054d8:	5e                   	pop    %esi
  1054d9:	5f                   	pop    %edi
  1054da:	5d                   	pop    %ebp
  1054db:	c3                   	ret    

001054dc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1054dc:	55                   	push   %ebp
  1054dd:	89 e5                	mov    %esp,%ebp
  1054df:	83 ec 58             	sub    $0x58,%esp
  1054e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1054e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1054eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054f7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054fa:	8b 45 18             	mov    0x18(%ebp),%eax
  1054fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105503:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105506:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105509:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10550c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10550f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105516:	74 1c                	je     105534 <printnum+0x58>
  105518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10551b:	ba 00 00 00 00       	mov    $0x0,%edx
  105520:	f7 75 e4             	divl   -0x1c(%ebp)
  105523:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105529:	ba 00 00 00 00       	mov    $0x0,%edx
  10552e:	f7 75 e4             	divl   -0x1c(%ebp)
  105531:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10553a:	f7 75 e4             	divl   -0x1c(%ebp)
  10553d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105540:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105546:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105549:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10554c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10554f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105552:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105555:	8b 45 18             	mov    0x18(%ebp),%eax
  105558:	ba 00 00 00 00       	mov    $0x0,%edx
  10555d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105560:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105563:	19 d1                	sbb    %edx,%ecx
  105565:	72 4c                	jb     1055b3 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105567:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10556a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10556d:	8b 45 20             	mov    0x20(%ebp),%eax
  105570:	89 44 24 18          	mov    %eax,0x18(%esp)
  105574:	89 54 24 14          	mov    %edx,0x14(%esp)
  105578:	8b 45 18             	mov    0x18(%ebp),%eax
  10557b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10557f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105582:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105585:	89 44 24 08          	mov    %eax,0x8(%esp)
  105589:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10558d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105590:	89 44 24 04          	mov    %eax,0x4(%esp)
  105594:	8b 45 08             	mov    0x8(%ebp),%eax
  105597:	89 04 24             	mov    %eax,(%esp)
  10559a:	e8 3d ff ff ff       	call   1054dc <printnum>
  10559f:	eb 1b                	jmp    1055bc <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1055a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055a8:	8b 45 20             	mov    0x20(%ebp),%eax
  1055ab:	89 04 24             	mov    %eax,(%esp)
  1055ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b1:	ff d0                	call   *%eax
        while (-- width > 0)
  1055b3:	ff 4d 1c             	decl   0x1c(%ebp)
  1055b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055ba:	7f e5                	jg     1055a1 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1055bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1055bf:	05 24 72 10 00       	add    $0x107224,%eax
  1055c4:	0f b6 00             	movzbl (%eax),%eax
  1055c7:	0f be c0             	movsbl %al,%eax
  1055ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055d1:	89 04 24             	mov    %eax,(%esp)
  1055d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d7:	ff d0                	call   *%eax
}
  1055d9:	90                   	nop
  1055da:	89 ec                	mov    %ebp,%esp
  1055dc:	5d                   	pop    %ebp
  1055dd:	c3                   	ret    

001055de <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1055de:	55                   	push   %ebp
  1055df:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055e5:	7e 14                	jle    1055fb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ea:	8b 00                	mov    (%eax),%eax
  1055ec:	8d 48 08             	lea    0x8(%eax),%ecx
  1055ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1055f2:	89 0a                	mov    %ecx,(%edx)
  1055f4:	8b 50 04             	mov    0x4(%eax),%edx
  1055f7:	8b 00                	mov    (%eax),%eax
  1055f9:	eb 30                	jmp    10562b <getuint+0x4d>
    }
    else if (lflag) {
  1055fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055ff:	74 16                	je     105617 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105601:	8b 45 08             	mov    0x8(%ebp),%eax
  105604:	8b 00                	mov    (%eax),%eax
  105606:	8d 48 04             	lea    0x4(%eax),%ecx
  105609:	8b 55 08             	mov    0x8(%ebp),%edx
  10560c:	89 0a                	mov    %ecx,(%edx)
  10560e:	8b 00                	mov    (%eax),%eax
  105610:	ba 00 00 00 00       	mov    $0x0,%edx
  105615:	eb 14                	jmp    10562b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105617:	8b 45 08             	mov    0x8(%ebp),%eax
  10561a:	8b 00                	mov    (%eax),%eax
  10561c:	8d 48 04             	lea    0x4(%eax),%ecx
  10561f:	8b 55 08             	mov    0x8(%ebp),%edx
  105622:	89 0a                	mov    %ecx,(%edx)
  105624:	8b 00                	mov    (%eax),%eax
  105626:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10562b:	5d                   	pop    %ebp
  10562c:	c3                   	ret    

0010562d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10562d:	55                   	push   %ebp
  10562e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105630:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105634:	7e 14                	jle    10564a <getint+0x1d>
        return va_arg(*ap, long long);
  105636:	8b 45 08             	mov    0x8(%ebp),%eax
  105639:	8b 00                	mov    (%eax),%eax
  10563b:	8d 48 08             	lea    0x8(%eax),%ecx
  10563e:	8b 55 08             	mov    0x8(%ebp),%edx
  105641:	89 0a                	mov    %ecx,(%edx)
  105643:	8b 50 04             	mov    0x4(%eax),%edx
  105646:	8b 00                	mov    (%eax),%eax
  105648:	eb 28                	jmp    105672 <getint+0x45>
    }
    else if (lflag) {
  10564a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10564e:	74 12                	je     105662 <getint+0x35>
        return va_arg(*ap, long);
  105650:	8b 45 08             	mov    0x8(%ebp),%eax
  105653:	8b 00                	mov    (%eax),%eax
  105655:	8d 48 04             	lea    0x4(%eax),%ecx
  105658:	8b 55 08             	mov    0x8(%ebp),%edx
  10565b:	89 0a                	mov    %ecx,(%edx)
  10565d:	8b 00                	mov    (%eax),%eax
  10565f:	99                   	cltd   
  105660:	eb 10                	jmp    105672 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105662:	8b 45 08             	mov    0x8(%ebp),%eax
  105665:	8b 00                	mov    (%eax),%eax
  105667:	8d 48 04             	lea    0x4(%eax),%ecx
  10566a:	8b 55 08             	mov    0x8(%ebp),%edx
  10566d:	89 0a                	mov    %ecx,(%edx)
  10566f:	8b 00                	mov    (%eax),%eax
  105671:	99                   	cltd   
    }
}
  105672:	5d                   	pop    %ebp
  105673:	c3                   	ret    

00105674 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105674:	55                   	push   %ebp
  105675:	89 e5                	mov    %esp,%ebp
  105677:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10567a:	8d 45 14             	lea    0x14(%ebp),%eax
  10567d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105683:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105687:	8b 45 10             	mov    0x10(%ebp),%eax
  10568a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10568e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105691:	89 44 24 04          	mov    %eax,0x4(%esp)
  105695:	8b 45 08             	mov    0x8(%ebp),%eax
  105698:	89 04 24             	mov    %eax,(%esp)
  10569b:	e8 05 00 00 00       	call   1056a5 <vprintfmt>
    va_end(ap);
}
  1056a0:	90                   	nop
  1056a1:	89 ec                	mov    %ebp,%esp
  1056a3:	5d                   	pop    %ebp
  1056a4:	c3                   	ret    

001056a5 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1056a5:	55                   	push   %ebp
  1056a6:	89 e5                	mov    %esp,%ebp
  1056a8:	56                   	push   %esi
  1056a9:	53                   	push   %ebx
  1056aa:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056ad:	eb 17                	jmp    1056c6 <vprintfmt+0x21>
            if (ch == '\0') {
  1056af:	85 db                	test   %ebx,%ebx
  1056b1:	0f 84 bf 03 00 00    	je     105a76 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056be:	89 1c 24             	mov    %ebx,(%esp)
  1056c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c4:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c9:	8d 50 01             	lea    0x1(%eax),%edx
  1056cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1056cf:	0f b6 00             	movzbl (%eax),%eax
  1056d2:	0f b6 d8             	movzbl %al,%ebx
  1056d5:	83 fb 25             	cmp    $0x25,%ebx
  1056d8:	75 d5                	jne    1056af <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1056da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1056de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1056fb:	8d 50 01             	lea    0x1(%eax),%edx
  1056fe:	89 55 10             	mov    %edx,0x10(%ebp)
  105701:	0f b6 00             	movzbl (%eax),%eax
  105704:	0f b6 d8             	movzbl %al,%ebx
  105707:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10570a:	83 f8 55             	cmp    $0x55,%eax
  10570d:	0f 87 37 03 00 00    	ja     105a4a <vprintfmt+0x3a5>
  105713:	8b 04 85 48 72 10 00 	mov    0x107248(,%eax,4),%eax
  10571a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10571c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105720:	eb d6                	jmp    1056f8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105722:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105726:	eb d0                	jmp    1056f8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10572f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105732:	89 d0                	mov    %edx,%eax
  105734:	c1 e0 02             	shl    $0x2,%eax
  105737:	01 d0                	add    %edx,%eax
  105739:	01 c0                	add    %eax,%eax
  10573b:	01 d8                	add    %ebx,%eax
  10573d:	83 e8 30             	sub    $0x30,%eax
  105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105743:	8b 45 10             	mov    0x10(%ebp),%eax
  105746:	0f b6 00             	movzbl (%eax),%eax
  105749:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10574c:	83 fb 2f             	cmp    $0x2f,%ebx
  10574f:	7e 38                	jle    105789 <vprintfmt+0xe4>
  105751:	83 fb 39             	cmp    $0x39,%ebx
  105754:	7f 33                	jg     105789 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105756:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105759:	eb d4                	jmp    10572f <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10575b:	8b 45 14             	mov    0x14(%ebp),%eax
  10575e:	8d 50 04             	lea    0x4(%eax),%edx
  105761:	89 55 14             	mov    %edx,0x14(%ebp)
  105764:	8b 00                	mov    (%eax),%eax
  105766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105769:	eb 1f                	jmp    10578a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10576b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10576f:	79 87                	jns    1056f8 <vprintfmt+0x53>
                width = 0;
  105771:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105778:	e9 7b ff ff ff       	jmp    1056f8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10577d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105784:	e9 6f ff ff ff       	jmp    1056f8 <vprintfmt+0x53>
            goto process_precision;
  105789:	90                   	nop

        process_precision:
            if (width < 0)
  10578a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10578e:	0f 89 64 ff ff ff    	jns    1056f8 <vprintfmt+0x53>
                width = precision, precision = -1;
  105794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105797:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10579a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1057a1:	e9 52 ff ff ff       	jmp    1056f8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1057a6:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1057a9:	e9 4a ff ff ff       	jmp    1056f8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1057ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1057b1:	8d 50 04             	lea    0x4(%eax),%edx
  1057b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1057b7:	8b 00                	mov    (%eax),%eax
  1057b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057c0:	89 04 24             	mov    %eax,(%esp)
  1057c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c6:	ff d0                	call   *%eax
            break;
  1057c8:	e9 a4 02 00 00       	jmp    105a71 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1057cd:	8b 45 14             	mov    0x14(%ebp),%eax
  1057d0:	8d 50 04             	lea    0x4(%eax),%edx
  1057d3:	89 55 14             	mov    %edx,0x14(%ebp)
  1057d6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1057d8:	85 db                	test   %ebx,%ebx
  1057da:	79 02                	jns    1057de <vprintfmt+0x139>
                err = -err;
  1057dc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1057de:	83 fb 06             	cmp    $0x6,%ebx
  1057e1:	7f 0b                	jg     1057ee <vprintfmt+0x149>
  1057e3:	8b 34 9d 08 72 10 00 	mov    0x107208(,%ebx,4),%esi
  1057ea:	85 f6                	test   %esi,%esi
  1057ec:	75 23                	jne    105811 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1057ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057f2:	c7 44 24 08 35 72 10 	movl   $0x107235,0x8(%esp)
  1057f9:	00 
  1057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105801:	8b 45 08             	mov    0x8(%ebp),%eax
  105804:	89 04 24             	mov    %eax,(%esp)
  105807:	e8 68 fe ff ff       	call   105674 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10580c:	e9 60 02 00 00       	jmp    105a71 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105811:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105815:	c7 44 24 08 3e 72 10 	movl   $0x10723e,0x8(%esp)
  10581c:	00 
  10581d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105820:	89 44 24 04          	mov    %eax,0x4(%esp)
  105824:	8b 45 08             	mov    0x8(%ebp),%eax
  105827:	89 04 24             	mov    %eax,(%esp)
  10582a:	e8 45 fe ff ff       	call   105674 <printfmt>
            break;
  10582f:	e9 3d 02 00 00       	jmp    105a71 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105834:	8b 45 14             	mov    0x14(%ebp),%eax
  105837:	8d 50 04             	lea    0x4(%eax),%edx
  10583a:	89 55 14             	mov    %edx,0x14(%ebp)
  10583d:	8b 30                	mov    (%eax),%esi
  10583f:	85 f6                	test   %esi,%esi
  105841:	75 05                	jne    105848 <vprintfmt+0x1a3>
                p = "(null)";
  105843:	be 41 72 10 00       	mov    $0x107241,%esi
            }
            if (width > 0 && padc != '-') {
  105848:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10584c:	7e 76                	jle    1058c4 <vprintfmt+0x21f>
  10584e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105852:	74 70                	je     1058c4 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105857:	89 44 24 04          	mov    %eax,0x4(%esp)
  10585b:	89 34 24             	mov    %esi,(%esp)
  10585e:	e8 16 03 00 00       	call   105b79 <strnlen>
  105863:	89 c2                	mov    %eax,%edx
  105865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105868:	29 d0                	sub    %edx,%eax
  10586a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10586d:	eb 16                	jmp    105885 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10586f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105873:	8b 55 0c             	mov    0xc(%ebp),%edx
  105876:	89 54 24 04          	mov    %edx,0x4(%esp)
  10587a:	89 04 24             	mov    %eax,(%esp)
  10587d:	8b 45 08             	mov    0x8(%ebp),%eax
  105880:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105882:	ff 4d e8             	decl   -0x18(%ebp)
  105885:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105889:	7f e4                	jg     10586f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10588b:	eb 37                	jmp    1058c4 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10588d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105891:	74 1f                	je     1058b2 <vprintfmt+0x20d>
  105893:	83 fb 1f             	cmp    $0x1f,%ebx
  105896:	7e 05                	jle    10589d <vprintfmt+0x1f8>
  105898:	83 fb 7e             	cmp    $0x7e,%ebx
  10589b:	7e 15                	jle    1058b2 <vprintfmt+0x20d>
                    putch('?', putdat);
  10589d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1058ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ae:	ff d0                	call   *%eax
  1058b0:	eb 0f                	jmp    1058c1 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  1058b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b9:	89 1c 24             	mov    %ebx,(%esp)
  1058bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1058bf:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058c1:	ff 4d e8             	decl   -0x18(%ebp)
  1058c4:	89 f0                	mov    %esi,%eax
  1058c6:	8d 70 01             	lea    0x1(%eax),%esi
  1058c9:	0f b6 00             	movzbl (%eax),%eax
  1058cc:	0f be d8             	movsbl %al,%ebx
  1058cf:	85 db                	test   %ebx,%ebx
  1058d1:	74 27                	je     1058fa <vprintfmt+0x255>
  1058d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058d7:	78 b4                	js     10588d <vprintfmt+0x1e8>
  1058d9:	ff 4d e4             	decl   -0x1c(%ebp)
  1058dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058e0:	79 ab                	jns    10588d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1058e2:	eb 16                	jmp    1058fa <vprintfmt+0x255>
                putch(' ', putdat);
  1058e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1058f7:	ff 4d e8             	decl   -0x18(%ebp)
  1058fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058fe:	7f e4                	jg     1058e4 <vprintfmt+0x23f>
            }
            break;
  105900:	e9 6c 01 00 00       	jmp    105a71 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105908:	89 44 24 04          	mov    %eax,0x4(%esp)
  10590c:	8d 45 14             	lea    0x14(%ebp),%eax
  10590f:	89 04 24             	mov    %eax,(%esp)
  105912:	e8 16 fd ff ff       	call   10562d <getint>
  105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10591a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10591d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105923:	85 d2                	test   %edx,%edx
  105925:	79 26                	jns    10594d <vprintfmt+0x2a8>
                putch('-', putdat);
  105927:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105935:	8b 45 08             	mov    0x8(%ebp),%eax
  105938:	ff d0                	call   *%eax
                num = -(long long)num;
  10593a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10593d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105940:	f7 d8                	neg    %eax
  105942:	83 d2 00             	adc    $0x0,%edx
  105945:	f7 da                	neg    %edx
  105947:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10594a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10594d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105954:	e9 a8 00 00 00       	jmp    105a01 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10595c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105960:	8d 45 14             	lea    0x14(%ebp),%eax
  105963:	89 04 24             	mov    %eax,(%esp)
  105966:	e8 73 fc ff ff       	call   1055de <getuint>
  10596b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10596e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105971:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105978:	e9 84 00 00 00       	jmp    105a01 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10597d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105980:	89 44 24 04          	mov    %eax,0x4(%esp)
  105984:	8d 45 14             	lea    0x14(%ebp),%eax
  105987:	89 04 24             	mov    %eax,(%esp)
  10598a:	e8 4f fc ff ff       	call   1055de <getuint>
  10598f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105992:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105995:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10599c:	eb 63                	jmp    105a01 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10599e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059a5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1059ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1059af:	ff d0                	call   *%eax
            putch('x', putdat);
  1059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1059bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c2:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1059c4:	8b 45 14             	mov    0x14(%ebp),%eax
  1059c7:	8d 50 04             	lea    0x4(%eax),%edx
  1059ca:	89 55 14             	mov    %edx,0x14(%ebp)
  1059cd:	8b 00                	mov    (%eax),%eax
  1059cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1059d9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059e0:	eb 1f                	jmp    105a01 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e9:	8d 45 14             	lea    0x14(%ebp),%eax
  1059ec:	89 04 24             	mov    %eax,(%esp)
  1059ef:	e8 ea fb ff ff       	call   1055de <getuint>
  1059f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1059fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a01:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a08:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a0f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a13:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a21:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2f:	89 04 24             	mov    %eax,(%esp)
  105a32:	e8 a5 fa ff ff       	call   1054dc <printnum>
            break;
  105a37:	eb 38                	jmp    105a71 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a40:	89 1c 24             	mov    %ebx,(%esp)
  105a43:	8b 45 08             	mov    0x8(%ebp),%eax
  105a46:	ff d0                	call   *%eax
            break;
  105a48:	eb 27                	jmp    105a71 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a51:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a58:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a5d:	ff 4d 10             	decl   0x10(%ebp)
  105a60:	eb 03                	jmp    105a65 <vprintfmt+0x3c0>
  105a62:	ff 4d 10             	decl   0x10(%ebp)
  105a65:	8b 45 10             	mov    0x10(%ebp),%eax
  105a68:	48                   	dec    %eax
  105a69:	0f b6 00             	movzbl (%eax),%eax
  105a6c:	3c 25                	cmp    $0x25,%al
  105a6e:	75 f2                	jne    105a62 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105a70:	90                   	nop
    while (1) {
  105a71:	e9 37 fc ff ff       	jmp    1056ad <vprintfmt+0x8>
                return;
  105a76:	90                   	nop
        }
    }
}
  105a77:	83 c4 40             	add    $0x40,%esp
  105a7a:	5b                   	pop    %ebx
  105a7b:	5e                   	pop    %esi
  105a7c:	5d                   	pop    %ebp
  105a7d:	c3                   	ret    

00105a7e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a7e:	55                   	push   %ebp
  105a7f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a84:	8b 40 08             	mov    0x8(%eax),%eax
  105a87:	8d 50 01             	lea    0x1(%eax),%edx
  105a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a8d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a93:	8b 10                	mov    (%eax),%edx
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	8b 40 04             	mov    0x4(%eax),%eax
  105a9b:	39 c2                	cmp    %eax,%edx
  105a9d:	73 12                	jae    105ab1 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa2:	8b 00                	mov    (%eax),%eax
  105aa4:	8d 48 01             	lea    0x1(%eax),%ecx
  105aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  105aaa:	89 0a                	mov    %ecx,(%edx)
  105aac:	8b 55 08             	mov    0x8(%ebp),%edx
  105aaf:	88 10                	mov    %dl,(%eax)
    }
}
  105ab1:	90                   	nop
  105ab2:	5d                   	pop    %ebp
  105ab3:	c3                   	ret    

00105ab4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105ab4:	55                   	push   %ebp
  105ab5:	89 e5                	mov    %esp,%ebp
  105ab7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105aba:	8d 45 14             	lea    0x14(%ebp),%eax
  105abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  105aca:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad8:	89 04 24             	mov    %eax,(%esp)
  105adb:	e8 0a 00 00 00       	call   105aea <vsnprintf>
  105ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ae6:	89 ec                	mov    %ebp,%esp
  105ae8:	5d                   	pop    %ebp
  105ae9:	c3                   	ret    

00105aea <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105aea:	55                   	push   %ebp
  105aeb:	89 e5                	mov    %esp,%ebp
  105aed:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105af0:	8b 45 08             	mov    0x8(%ebp),%eax
  105af3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af9:	8d 50 ff             	lea    -0x1(%eax),%edx
  105afc:	8b 45 08             	mov    0x8(%ebp),%eax
  105aff:	01 d0                	add    %edx,%eax
  105b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b0f:	74 0a                	je     105b1b <vsnprintf+0x31>
  105b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b17:	39 c2                	cmp    %eax,%edx
  105b19:	76 07                	jbe    105b22 <vsnprintf+0x38>
        return -E_INVAL;
  105b1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b20:	eb 2a                	jmp    105b4c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b22:	8b 45 14             	mov    0x14(%ebp),%eax
  105b25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b29:	8b 45 10             	mov    0x10(%ebp),%eax
  105b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b30:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b37:	c7 04 24 7e 5a 10 00 	movl   $0x105a7e,(%esp)
  105b3e:	e8 62 fb ff ff       	call   1056a5 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b46:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b4c:	89 ec                	mov    %ebp,%esp
  105b4e:	5d                   	pop    %ebp
  105b4f:	c3                   	ret    

00105b50 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b50:	55                   	push   %ebp
  105b51:	89 e5                	mov    %esp,%ebp
  105b53:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b5d:	eb 03                	jmp    105b62 <strlen+0x12>
        cnt ++;
  105b5f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105b62:	8b 45 08             	mov    0x8(%ebp),%eax
  105b65:	8d 50 01             	lea    0x1(%eax),%edx
  105b68:	89 55 08             	mov    %edx,0x8(%ebp)
  105b6b:	0f b6 00             	movzbl (%eax),%eax
  105b6e:	84 c0                	test   %al,%al
  105b70:	75 ed                	jne    105b5f <strlen+0xf>
    }
    return cnt;
  105b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b75:	89 ec                	mov    %ebp,%esp
  105b77:	5d                   	pop    %ebp
  105b78:	c3                   	ret    

00105b79 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b79:	55                   	push   %ebp
  105b7a:	89 e5                	mov    %esp,%ebp
  105b7c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b86:	eb 03                	jmp    105b8b <strnlen+0x12>
        cnt ++;
  105b88:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b91:	73 10                	jae    105ba3 <strnlen+0x2a>
  105b93:	8b 45 08             	mov    0x8(%ebp),%eax
  105b96:	8d 50 01             	lea    0x1(%eax),%edx
  105b99:	89 55 08             	mov    %edx,0x8(%ebp)
  105b9c:	0f b6 00             	movzbl (%eax),%eax
  105b9f:	84 c0                	test   %al,%al
  105ba1:	75 e5                	jne    105b88 <strnlen+0xf>
    }
    return cnt;
  105ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ba6:	89 ec                	mov    %ebp,%esp
  105ba8:	5d                   	pop    %ebp
  105ba9:	c3                   	ret    

00105baa <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105baa:	55                   	push   %ebp
  105bab:	89 e5                	mov    %esp,%ebp
  105bad:	57                   	push   %edi
  105bae:	56                   	push   %esi
  105baf:	83 ec 20             	sub    $0x20,%esp
  105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bc4:	89 d1                	mov    %edx,%ecx
  105bc6:	89 c2                	mov    %eax,%edx
  105bc8:	89 ce                	mov    %ecx,%esi
  105bca:	89 d7                	mov    %edx,%edi
  105bcc:	ac                   	lods   %ds:(%esi),%al
  105bcd:	aa                   	stos   %al,%es:(%edi)
  105bce:	84 c0                	test   %al,%al
  105bd0:	75 fa                	jne    105bcc <strcpy+0x22>
  105bd2:	89 fa                	mov    %edi,%edx
  105bd4:	89 f1                	mov    %esi,%ecx
  105bd6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105bd9:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105be2:	83 c4 20             	add    $0x20,%esp
  105be5:	5e                   	pop    %esi
  105be6:	5f                   	pop    %edi
  105be7:	5d                   	pop    %ebp
  105be8:	c3                   	ret    

00105be9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105be9:	55                   	push   %ebp
  105bea:	89 e5                	mov    %esp,%ebp
  105bec:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105bef:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bf5:	eb 1e                	jmp    105c15 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfa:	0f b6 10             	movzbl (%eax),%edx
  105bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c00:	88 10                	mov    %dl,(%eax)
  105c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c05:	0f b6 00             	movzbl (%eax),%eax
  105c08:	84 c0                	test   %al,%al
  105c0a:	74 03                	je     105c0f <strncpy+0x26>
            src ++;
  105c0c:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105c0f:	ff 45 fc             	incl   -0x4(%ebp)
  105c12:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105c15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c19:	75 dc                	jne    105bf7 <strncpy+0xe>
    }
    return dst;
  105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c1e:	89 ec                	mov    %ebp,%esp
  105c20:	5d                   	pop    %ebp
  105c21:	c3                   	ret    

00105c22 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c22:	55                   	push   %ebp
  105c23:	89 e5                	mov    %esp,%ebp
  105c25:	57                   	push   %edi
  105c26:	56                   	push   %esi
  105c27:	83 ec 20             	sub    $0x20,%esp
  105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c3c:	89 d1                	mov    %edx,%ecx
  105c3e:	89 c2                	mov    %eax,%edx
  105c40:	89 ce                	mov    %ecx,%esi
  105c42:	89 d7                	mov    %edx,%edi
  105c44:	ac                   	lods   %ds:(%esi),%al
  105c45:	ae                   	scas   %es:(%edi),%al
  105c46:	75 08                	jne    105c50 <strcmp+0x2e>
  105c48:	84 c0                	test   %al,%al
  105c4a:	75 f8                	jne    105c44 <strcmp+0x22>
  105c4c:	31 c0                	xor    %eax,%eax
  105c4e:	eb 04                	jmp    105c54 <strcmp+0x32>
  105c50:	19 c0                	sbb    %eax,%eax
  105c52:	0c 01                	or     $0x1,%al
  105c54:	89 fa                	mov    %edi,%edx
  105c56:	89 f1                	mov    %esi,%ecx
  105c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c5b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c64:	83 c4 20             	add    $0x20,%esp
  105c67:	5e                   	pop    %esi
  105c68:	5f                   	pop    %edi
  105c69:	5d                   	pop    %ebp
  105c6a:	c3                   	ret    

00105c6b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c6b:	55                   	push   %ebp
  105c6c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c6e:	eb 09                	jmp    105c79 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105c70:	ff 4d 10             	decl   0x10(%ebp)
  105c73:	ff 45 08             	incl   0x8(%ebp)
  105c76:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c7d:	74 1a                	je     105c99 <strncmp+0x2e>
  105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c82:	0f b6 00             	movzbl (%eax),%eax
  105c85:	84 c0                	test   %al,%al
  105c87:	74 10                	je     105c99 <strncmp+0x2e>
  105c89:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8c:	0f b6 10             	movzbl (%eax),%edx
  105c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c92:	0f b6 00             	movzbl (%eax),%eax
  105c95:	38 c2                	cmp    %al,%dl
  105c97:	74 d7                	je     105c70 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c9d:	74 18                	je     105cb7 <strncmp+0x4c>
  105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca2:	0f b6 00             	movzbl (%eax),%eax
  105ca5:	0f b6 d0             	movzbl %al,%edx
  105ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cab:	0f b6 00             	movzbl (%eax),%eax
  105cae:	0f b6 c8             	movzbl %al,%ecx
  105cb1:	89 d0                	mov    %edx,%eax
  105cb3:	29 c8                	sub    %ecx,%eax
  105cb5:	eb 05                	jmp    105cbc <strncmp+0x51>
  105cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cbc:	5d                   	pop    %ebp
  105cbd:	c3                   	ret    

00105cbe <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105cbe:	55                   	push   %ebp
  105cbf:	89 e5                	mov    %esp,%ebp
  105cc1:	83 ec 04             	sub    $0x4,%esp
  105cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105cca:	eb 13                	jmp    105cdf <strchr+0x21>
        if (*s == c) {
  105ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccf:	0f b6 00             	movzbl (%eax),%eax
  105cd2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105cd5:	75 05                	jne    105cdc <strchr+0x1e>
            return (char *)s;
  105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cda:	eb 12                	jmp    105cee <strchr+0x30>
        }
        s ++;
  105cdc:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce2:	0f b6 00             	movzbl (%eax),%eax
  105ce5:	84 c0                	test   %al,%al
  105ce7:	75 e3                	jne    105ccc <strchr+0xe>
    }
    return NULL;
  105ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cee:	89 ec                	mov    %ebp,%esp
  105cf0:	5d                   	pop    %ebp
  105cf1:	c3                   	ret    

00105cf2 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105cf2:	55                   	push   %ebp
  105cf3:	89 e5                	mov    %esp,%ebp
  105cf5:	83 ec 04             	sub    $0x4,%esp
  105cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105cfe:	eb 0e                	jmp    105d0e <strfind+0x1c>
        if (*s == c) {
  105d00:	8b 45 08             	mov    0x8(%ebp),%eax
  105d03:	0f b6 00             	movzbl (%eax),%eax
  105d06:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105d09:	74 0f                	je     105d1a <strfind+0x28>
            break;
        }
        s ++;
  105d0b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d11:	0f b6 00             	movzbl (%eax),%eax
  105d14:	84 c0                	test   %al,%al
  105d16:	75 e8                	jne    105d00 <strfind+0xe>
  105d18:	eb 01                	jmp    105d1b <strfind+0x29>
            break;
  105d1a:	90                   	nop
    }
    return (char *)s;
  105d1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d1e:	89 ec                	mov    %ebp,%esp
  105d20:	5d                   	pop    %ebp
  105d21:	c3                   	ret    

00105d22 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d22:	55                   	push   %ebp
  105d23:	89 e5                	mov    %esp,%ebp
  105d25:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d2f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d36:	eb 03                	jmp    105d3b <strtol+0x19>
        s ++;
  105d38:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3e:	0f b6 00             	movzbl (%eax),%eax
  105d41:	3c 20                	cmp    $0x20,%al
  105d43:	74 f3                	je     105d38 <strtol+0x16>
  105d45:	8b 45 08             	mov    0x8(%ebp),%eax
  105d48:	0f b6 00             	movzbl (%eax),%eax
  105d4b:	3c 09                	cmp    $0x9,%al
  105d4d:	74 e9                	je     105d38 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d52:	0f b6 00             	movzbl (%eax),%eax
  105d55:	3c 2b                	cmp    $0x2b,%al
  105d57:	75 05                	jne    105d5e <strtol+0x3c>
        s ++;
  105d59:	ff 45 08             	incl   0x8(%ebp)
  105d5c:	eb 14                	jmp    105d72 <strtol+0x50>
    }
    else if (*s == '-') {
  105d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d61:	0f b6 00             	movzbl (%eax),%eax
  105d64:	3c 2d                	cmp    $0x2d,%al
  105d66:	75 0a                	jne    105d72 <strtol+0x50>
        s ++, neg = 1;
  105d68:	ff 45 08             	incl   0x8(%ebp)
  105d6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d76:	74 06                	je     105d7e <strtol+0x5c>
  105d78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d7c:	75 22                	jne    105da0 <strtol+0x7e>
  105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d81:	0f b6 00             	movzbl (%eax),%eax
  105d84:	3c 30                	cmp    $0x30,%al
  105d86:	75 18                	jne    105da0 <strtol+0x7e>
  105d88:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8b:	40                   	inc    %eax
  105d8c:	0f b6 00             	movzbl (%eax),%eax
  105d8f:	3c 78                	cmp    $0x78,%al
  105d91:	75 0d                	jne    105da0 <strtol+0x7e>
        s += 2, base = 16;
  105d93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d9e:	eb 29                	jmp    105dc9 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105da4:	75 16                	jne    105dbc <strtol+0x9a>
  105da6:	8b 45 08             	mov    0x8(%ebp),%eax
  105da9:	0f b6 00             	movzbl (%eax),%eax
  105dac:	3c 30                	cmp    $0x30,%al
  105dae:	75 0c                	jne    105dbc <strtol+0x9a>
        s ++, base = 8;
  105db0:	ff 45 08             	incl   0x8(%ebp)
  105db3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105dba:	eb 0d                	jmp    105dc9 <strtol+0xa7>
    }
    else if (base == 0) {
  105dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dc0:	75 07                	jne    105dc9 <strtol+0xa7>
        base = 10;
  105dc2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dcc:	0f b6 00             	movzbl (%eax),%eax
  105dcf:	3c 2f                	cmp    $0x2f,%al
  105dd1:	7e 1b                	jle    105dee <strtol+0xcc>
  105dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd6:	0f b6 00             	movzbl (%eax),%eax
  105dd9:	3c 39                	cmp    $0x39,%al
  105ddb:	7f 11                	jg     105dee <strtol+0xcc>
            dig = *s - '0';
  105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  105de0:	0f b6 00             	movzbl (%eax),%eax
  105de3:	0f be c0             	movsbl %al,%eax
  105de6:	83 e8 30             	sub    $0x30,%eax
  105de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dec:	eb 48                	jmp    105e36 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105dee:	8b 45 08             	mov    0x8(%ebp),%eax
  105df1:	0f b6 00             	movzbl (%eax),%eax
  105df4:	3c 60                	cmp    $0x60,%al
  105df6:	7e 1b                	jle    105e13 <strtol+0xf1>
  105df8:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfb:	0f b6 00             	movzbl (%eax),%eax
  105dfe:	3c 7a                	cmp    $0x7a,%al
  105e00:	7f 11                	jg     105e13 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105e02:	8b 45 08             	mov    0x8(%ebp),%eax
  105e05:	0f b6 00             	movzbl (%eax),%eax
  105e08:	0f be c0             	movsbl %al,%eax
  105e0b:	83 e8 57             	sub    $0x57,%eax
  105e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e11:	eb 23                	jmp    105e36 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e13:	8b 45 08             	mov    0x8(%ebp),%eax
  105e16:	0f b6 00             	movzbl (%eax),%eax
  105e19:	3c 40                	cmp    $0x40,%al
  105e1b:	7e 3b                	jle    105e58 <strtol+0x136>
  105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e20:	0f b6 00             	movzbl (%eax),%eax
  105e23:	3c 5a                	cmp    $0x5a,%al
  105e25:	7f 31                	jg     105e58 <strtol+0x136>
            dig = *s - 'A' + 10;
  105e27:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2a:	0f b6 00             	movzbl (%eax),%eax
  105e2d:	0f be c0             	movsbl %al,%eax
  105e30:	83 e8 37             	sub    $0x37,%eax
  105e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e39:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e3c:	7d 19                	jge    105e57 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105e3e:	ff 45 08             	incl   0x8(%ebp)
  105e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e44:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e48:	89 c2                	mov    %eax,%edx
  105e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e4d:	01 d0                	add    %edx,%eax
  105e4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105e52:	e9 72 ff ff ff       	jmp    105dc9 <strtol+0xa7>
            break;
  105e57:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105e58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e5c:	74 08                	je     105e66 <strtol+0x144>
        *endptr = (char *) s;
  105e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e61:	8b 55 08             	mov    0x8(%ebp),%edx
  105e64:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105e66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105e6a:	74 07                	je     105e73 <strtol+0x151>
  105e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e6f:	f7 d8                	neg    %eax
  105e71:	eb 03                	jmp    105e76 <strtol+0x154>
  105e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e76:	89 ec                	mov    %ebp,%esp
  105e78:	5d                   	pop    %ebp
  105e79:	c3                   	ret    

00105e7a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e7a:	55                   	push   %ebp
  105e7b:	89 e5                	mov    %esp,%ebp
  105e7d:	83 ec 28             	sub    $0x28,%esp
  105e80:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e86:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e89:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e90:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105e93:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105e96:	8b 45 10             	mov    0x10(%ebp),%eax
  105e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ea3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105ea6:	89 d7                	mov    %edx,%edi
  105ea8:	f3 aa                	rep stos %al,%es:(%edi)
  105eaa:	89 fa                	mov    %edi,%edx
  105eac:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105eaf:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105eb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105eb8:	89 ec                	mov    %ebp,%esp
  105eba:	5d                   	pop    %ebp
  105ebb:	c3                   	ret    

00105ebc <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105ebc:	55                   	push   %ebp
  105ebd:	89 e5                	mov    %esp,%ebp
  105ebf:	57                   	push   %edi
  105ec0:	56                   	push   %esi
  105ec1:	53                   	push   %ebx
  105ec2:	83 ec 30             	sub    $0x30,%esp
  105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ed4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105edd:	73 42                	jae    105f21 <memmove+0x65>
  105edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eee:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ef4:	c1 e8 02             	shr    $0x2,%eax
  105ef7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105ef9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105eff:	89 d7                	mov    %edx,%edi
  105f01:	89 c6                	mov    %eax,%esi
  105f03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f05:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f08:	83 e1 03             	and    $0x3,%ecx
  105f0b:	74 02                	je     105f0f <memmove+0x53>
  105f0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f0f:	89 f0                	mov    %esi,%eax
  105f11:	89 fa                	mov    %edi,%edx
  105f13:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f16:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105f19:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105f1f:	eb 36                	jmp    105f57 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f24:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f2a:	01 c2                	add    %eax,%edx
  105f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f2f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f35:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f3b:	89 c1                	mov    %eax,%ecx
  105f3d:	89 d8                	mov    %ebx,%eax
  105f3f:	89 d6                	mov    %edx,%esi
  105f41:	89 c7                	mov    %eax,%edi
  105f43:	fd                   	std    
  105f44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f46:	fc                   	cld    
  105f47:	89 f8                	mov    %edi,%eax
  105f49:	89 f2                	mov    %esi,%edx
  105f4b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f4e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f51:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f57:	83 c4 30             	add    $0x30,%esp
  105f5a:	5b                   	pop    %ebx
  105f5b:	5e                   	pop    %esi
  105f5c:	5f                   	pop    %edi
  105f5d:	5d                   	pop    %ebp
  105f5e:	c3                   	ret    

00105f5f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105f5f:	55                   	push   %ebp
  105f60:	89 e5                	mov    %esp,%ebp
  105f62:	57                   	push   %edi
  105f63:	56                   	push   %esi
  105f64:	83 ec 20             	sub    $0x20,%esp
  105f67:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f73:	8b 45 10             	mov    0x10(%ebp),%eax
  105f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f7c:	c1 e8 02             	shr    $0x2,%eax
  105f7f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f87:	89 d7                	mov    %edx,%edi
  105f89:	89 c6                	mov    %eax,%esi
  105f8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f8d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f90:	83 e1 03             	and    $0x3,%ecx
  105f93:	74 02                	je     105f97 <memcpy+0x38>
  105f95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f97:	89 f0                	mov    %esi,%eax
  105f99:	89 fa                	mov    %edi,%edx
  105f9b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105fa7:	83 c4 20             	add    $0x20,%esp
  105faa:	5e                   	pop    %esi
  105fab:	5f                   	pop    %edi
  105fac:	5d                   	pop    %ebp
  105fad:	c3                   	ret    

00105fae <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105fae:	55                   	push   %ebp
  105faf:	89 e5                	mov    %esp,%ebp
  105fb1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105fc0:	eb 2e                	jmp    105ff0 <memcmp+0x42>
        if (*s1 != *s2) {
  105fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fc5:	0f b6 10             	movzbl (%eax),%edx
  105fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fcb:	0f b6 00             	movzbl (%eax),%eax
  105fce:	38 c2                	cmp    %al,%dl
  105fd0:	74 18                	je     105fea <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fd5:	0f b6 00             	movzbl (%eax),%eax
  105fd8:	0f b6 d0             	movzbl %al,%edx
  105fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fde:	0f b6 00             	movzbl (%eax),%eax
  105fe1:	0f b6 c8             	movzbl %al,%ecx
  105fe4:	89 d0                	mov    %edx,%eax
  105fe6:	29 c8                	sub    %ecx,%eax
  105fe8:	eb 18                	jmp    106002 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105fea:	ff 45 fc             	incl   -0x4(%ebp)
  105fed:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  105ff3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ff6:	89 55 10             	mov    %edx,0x10(%ebp)
  105ff9:	85 c0                	test   %eax,%eax
  105ffb:	75 c5                	jne    105fc2 <memcmp+0x14>
    }
    return 0;
  105ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106002:	89 ec                	mov    %ebp,%esp
  106004:	5d                   	pop    %ebp
  106005:	c3                   	ret    
