
bin/kernel_nopage:     file format elf32-i386


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
  100059:	e8 4a 5f 00 00       	call   105fa8 <memset>

    cons_init();                // init the console
  10005e:	e8 f7 15 00 00       	call   10165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 40 61 10 00 	movl   $0x106140,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 5c 61 10 00 	movl   $0x10615c,(%esp)
  100078:	e8 d9 02 00 00       	call   100356 <cprintf>

    print_kerninfo();
  10007d:	e8 f7 07 00 00       	call   100879 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 82 44 00 00       	call   10450e <pmm_init>

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
  100167:	c7 04 24 61 61 10 00 	movl   $0x106161,(%esp)
  10016e:	e8 e3 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 6f 61 10 00 	movl   $0x10616f,(%esp)
  10018d:	e8 c4 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 7d 61 10 00 	movl   $0x10617d,(%esp)
  1001ac:	e8 a5 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 8b 61 10 00 	movl   $0x10618b,(%esp)
  1001cb:	e8 86 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 99 61 10 00 	movl   $0x106199,(%esp)
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
  100216:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  10021d:	e8 34 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_user();
  100222:	e8 d8 ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100227:	e8 13 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022c:	c7 04 24 c8 61 10 00 	movl   $0x1061c8,(%esp)
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
  10025a:	c7 04 24 e7 61 10 00 	movl   $0x1061e7,(%esp)
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
  10034a:	e8 84 54 00 00       	call   1057d3 <vprintfmt>
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
  10055a:	c7 00 ec 61 10 00    	movl   $0x1061ec,(%eax)
    info->eip_line = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	c7 40 08 ec 61 10 00 	movl   $0x1061ec,0x8(%eax)
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
  100591:	c7 45 f4 c4 74 10 00 	movl   $0x1074c4,-0xc(%ebp)
    stab_end = __STAB_END__;
  100598:	c7 45 f0 88 2e 11 00 	movl   $0x112e88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10059f:	c7 45 ec 89 2e 11 00 	movl   $0x112e89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005a6:	c7 45 e8 36 64 11 00 	movl   $0x116436,-0x18(%ebp)

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
  1006f9:	e8 22 57 00 00       	call   105e20 <strfind>
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
  10087f:	c7 04 24 f6 61 10 00 	movl   $0x1061f6,(%esp)
  100886:	e8 cb fa ff ff       	call   100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 0f 62 10 00 	movl   $0x10620f,(%esp)
  10089a:	e8 b7 fa ff ff       	call   100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089f:	c7 44 24 04 34 61 10 	movl   $0x106134,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 27 62 10 00 	movl   $0x106227,(%esp)
  1008ae:	e8 a3 fa ff ff       	call   100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b3:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1008ba:	00 
  1008bb:	c7 04 24 3f 62 10 00 	movl   $0x10623f,(%esp)
  1008c2:	e8 8f fa ff ff       	call   100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c7:	c7 44 24 04 2c cf 11 	movl   $0x11cf2c,0x4(%esp)
  1008ce:	00 
  1008cf:	c7 04 24 57 62 10 00 	movl   $0x106257,(%esp)
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
  1008fc:	c7 04 24 70 62 10 00 	movl   $0x106270,(%esp)
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
  100933:	c7 04 24 9a 62 10 00 	movl   $0x10629a,(%esp)
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
  1009a1:	c7 04 24 b6 62 10 00 	movl   $0x1062b6,(%esp)
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
  100a05:	c7 04 24 c8 62 10 00 	movl   $0x1062c8,(%esp)
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
  100a41:	c7 04 24 e0 62 10 00 	movl   $0x1062e0,(%esp)
  100a48:	e8 09 f9 ff ff       	call   100356 <cprintf>

        cprintf("\n");
  100a4d:	c7 04 24 01 63 10 00 	movl   $0x106301,(%esp)
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
  100ac2:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  100ac9:	e8 1e 53 00 00       	call   105dec <strchr>
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
  100aea:	c7 04 24 89 63 10 00 	movl   $0x106389,(%esp)
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
  100b2c:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  100b33:	e8 b4 52 00 00       	call   105dec <strchr>
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
  100b9d:	e8 ae 51 00 00       	call   105d50 <strcmp>
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
  100be9:	c7 04 24 a7 63 10 00 	movl   $0x1063a7,(%esp)
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
  100c07:	c7 04 24 c0 63 10 00 	movl   $0x1063c0,(%esp)
  100c0e:	e8 43 f7 ff ff       	call   100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c13:	c7 04 24 e8 63 10 00 	movl   $0x1063e8,(%esp)
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
  100c30:	c7 04 24 0d 64 10 00 	movl   $0x10640d,(%esp)
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
  100ca0:	c7 04 24 11 64 10 00 	movl   $0x106411,(%esp)
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
  100d15:	c7 04 24 1a 64 10 00 	movl   $0x10641a,(%esp)
  100d1c:	e8 35 f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d28:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2b:	89 04 24             	mov    %eax,(%esp)
  100d2e:	e8 ee f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d33:	c7 04 24 36 64 10 00 	movl   $0x106436,(%esp)
  100d3a:	e8 17 f6 ff ff       	call   100356 <cprintf>
    
    cprintf("stack trackback:\n");
  100d3f:	c7 04 24 38 64 10 00 	movl   $0x106438,(%esp)
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
  100d80:	c7 04 24 4a 64 10 00 	movl   $0x10644a,(%esp)
  100d87:	e8 ca f5 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d93:	8b 45 10             	mov    0x10(%ebp),%eax
  100d96:	89 04 24             	mov    %eax,(%esp)
  100d99:	e8 83 f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d9e:	c7 04 24 36 64 10 00 	movl   $0x106436,(%esp)
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
  100e05:	c7 04 24 68 64 10 00 	movl   $0x106468,(%esp)
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
  10126f:	e8 76 4d 00 00       	call   105fea <memmove>
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
  101601:	c7 04 24 83 64 10 00 	movl   $0x106483,(%esp)
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
  101678:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
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
  101933:	c7 04 24 c0 64 10 00 	movl   $0x1064c0,(%esp)
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
  101a3d:	c7 04 24 ca 64 10 00 	movl   $0x1064ca,(%esp)
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
  101a5c:	8b 04 85 20 68 10 00 	mov    0x106820(,%eax,4),%eax
  101a63:	eb 18                	jmp    101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a69:	7e 0d                	jle    101a78 <trapname+0x2a>
  101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6f:	7f 07                	jg     101a78 <trapname+0x2a>
        return "Hardware Interrupt";
  101a71:	b8 cf 64 10 00       	mov    $0x1064cf,%eax
  101a76:	eb 05                	jmp    101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a78:	b8 e2 64 10 00       	mov    $0x1064e2,%eax
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
  101aa1:	c7 04 24 23 65 10 00 	movl   $0x106523,(%esp)
  101aa8:	e8 a9 e8 ff ff       	call   100356 <cprintf>
    print_regs(&tf->tf_regs);
  101aad:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab0:	89 04 24             	mov    %eax,(%esp)
  101ab3:	e8 8f 01 00 00       	call   101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 34 65 10 00 	movl   $0x106534,(%esp)
  101aca:	e8 87 e8 ff ff       	call   100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ada:	c7 04 24 47 65 10 00 	movl   $0x106547,(%esp)
  101ae1:	e8 70 e8 ff ff       	call   100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af1:	c7 04 24 5a 65 10 00 	movl   $0x10655a,(%esp)
  101af8:	e8 59 e8 ff ff       	call   100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101afd:	8b 45 08             	mov    0x8(%ebp),%eax
  101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b08:	c7 04 24 6d 65 10 00 	movl   $0x10656d,(%esp)
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
  101b30:	c7 04 24 80 65 10 00 	movl   $0x106580,(%esp)
  101b37:	e8 1a e8 ff ff       	call   100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	8b 40 34             	mov    0x34(%eax),%eax
  101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b46:	c7 04 24 92 65 10 00 	movl   $0x106592,(%esp)
  101b4d:	e8 04 e8 ff ff       	call   100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	8b 40 38             	mov    0x38(%eax),%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 a1 65 10 00 	movl   $0x1065a1,(%esp)
  101b63:	e8 ee e7 ff ff       	call   100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b73:	c7 04 24 b0 65 10 00 	movl   $0x1065b0,(%esp)
  101b7a:	e8 d7 e7 ff ff       	call   100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b82:	8b 40 40             	mov    0x40(%eax),%eax
  101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b89:	c7 04 24 c3 65 10 00 	movl   $0x1065c3,(%esp)
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
  101bd0:	c7 04 24 d2 65 10 00 	movl   $0x1065d2,(%esp)
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
  101bfa:	c7 04 24 d6 65 10 00 	movl   $0x1065d6,(%esp)
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
  101c1f:	c7 04 24 df 65 10 00 	movl   $0x1065df,(%esp)
  101c26:	e8 2b e7 ff ff       	call   100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c36:	c7 04 24 ee 65 10 00 	movl   $0x1065ee,(%esp)
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
  101c56:	c7 04 24 01 66 10 00 	movl   $0x106601,(%esp)
  101c5d:	e8 f4 e6 ff ff       	call   100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c62:	8b 45 08             	mov    0x8(%ebp),%eax
  101c65:	8b 40 04             	mov    0x4(%eax),%eax
  101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6c:	c7 04 24 10 66 10 00 	movl   $0x106610,(%esp)
  101c73:	e8 de e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c78:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7b:	8b 40 08             	mov    0x8(%eax),%eax
  101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c82:	c7 04 24 1f 66 10 00 	movl   $0x10661f,(%esp)
  101c89:	e8 c8 e6 ff ff       	call   100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	8b 40 0c             	mov    0xc(%eax),%eax
  101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c98:	c7 04 24 2e 66 10 00 	movl   $0x10662e,(%esp)
  101c9f:	e8 b2 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca7:	8b 40 10             	mov    0x10(%eax),%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 3d 66 10 00 	movl   $0x10663d,(%esp)
  101cb5:	e8 9c e6 ff ff       	call   100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	8b 40 14             	mov    0x14(%eax),%eax
  101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc4:	c7 04 24 4c 66 10 00 	movl   $0x10664c,(%esp)
  101ccb:	e8 86 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 18             	mov    0x18(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 5b 66 10 00 	movl   $0x10665b,(%esp)
  101ce1:	e8 70 e6 ff ff       	call   100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 6a 66 10 00 	movl   $0x10666a,(%esp)
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
  101dac:	c7 04 24 79 66 10 00 	movl   $0x106679,(%esp)
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
  101dd2:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  101dd9:	e8 78 e5 ff ff       	call   100356 <cprintf>
        break;
  101dde:	eb 55                	jmp    101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101de0:	c7 44 24 08 9a 66 10 	movl   $0x10669a,0x8(%esp)
  101de7:	00 
  101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101def:	00 
  101df0:	c7 04 24 aa 66 10 00 	movl   $0x1066aa,(%esp)
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
  101e15:	c7 44 24 08 bb 66 10 	movl   $0x1066bb,0x8(%esp)
  101e1c:	00 
  101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  101e24:	00 
  101e25:	c7 04 24 aa 66 10 00 	movl   $0x1066aa,(%esp)
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
  10296a:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  102971:	00 
  102972:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102979:	00 
  10297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102981:	00 
  102982:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
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
  1029c2:	c7 44 24 0c a1 68 10 	movl   $0x1068a1,0xc(%esp)
  1029c9:	00 
  1029ca:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1029d1:	00 
  1029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1029d9:	00 
  1029da:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
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
  102acc:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  102ad3:	00 
  102ad4:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102adb:	00 
  102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102ae3:	00 
  102ae4:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
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
  102c59:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c63:	75 24                	jne    102c89 <default_free_pages+0x33>
  102c65:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  102c6c:	00 
  102c6d:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102c74:	00 
  102c75:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  102c7c:	00 
  102c7d:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  102c84:	e8 5f e0 ff ff       	call   100ce8 <__panic>
//        cprintf("le:%x page:%x",le1 , p1);
//        le1=list_next(le1);
//    }
//    cprintf("\n\n");

    struct Page *p = base;
  102c89:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++) {
  102c8f:	e9 9d 00 00 00       	jmp    102d31 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c97:	83 c0 04             	add    $0x4,%eax
  102c9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ca7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102caa:	0f a3 10             	bt     %edx,(%eax)
  102cad:	19 c0                	sbb    %eax,%eax
  102caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cb6:	0f 95 c0             	setne  %al
  102cb9:	0f b6 c0             	movzbl %al,%eax
  102cbc:	85 c0                	test   %eax,%eax
  102cbe:	75 2c                	jne    102cec <default_free_pages+0x96>
  102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cc3:	83 c0 04             	add    $0x4,%eax
  102cc6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102ccd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cd6:	0f a3 10             	bt     %edx,(%eax)
  102cd9:	19 c0                	sbb    %eax,%eax
  102cdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102cde:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102ce2:	0f 95 c0             	setne  %al
  102ce5:	0f b6 c0             	movzbl %al,%eax
  102ce8:	85 c0                	test   %eax,%eax
  102cea:	74 24                	je     102d10 <default_free_pages+0xba>
  102cec:	c7 44 24 0c b4 68 10 	movl   $0x1068b4,0xc(%esp)
  102cf3:	00 
  102cf4:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102cfb:	00 
  102cfc:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  102d03:	00 
  102d04:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  102d0b:	e8 d8 df ff ff       	call   100ce8 <__panic>
        p->flags = 0;
  102d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102d1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d21:	00 
  102d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d25:	89 04 24             	mov    %eax,(%esp)
  102d28:	e8 f2 fb ff ff       	call   10291f <set_page_ref>
    for (; p != base + n; p++) {
  102d2d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d34:	89 d0                	mov    %edx,%eax
  102d36:	c1 e0 02             	shl    $0x2,%eax
  102d39:	01 d0                	add    %edx,%eax
  102d3b:	c1 e0 02             	shl    $0x2,%eax
  102d3e:	89 c2                	mov    %eax,%edx
  102d40:	8b 45 08             	mov    0x8(%ebp),%eax
  102d43:	01 d0                	add    %edx,%eax
  102d45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102d48:	0f 85 46 ff ff ff    	jne    102c94 <default_free_pages+0x3e>
    }
    base->property = n;
  102d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d54:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	83 c0 04             	add    $0x4,%eax
  102d5d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102d64:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d6a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d6d:	0f ab 10             	bts    %edx,(%eax)
}
  102d70:	90                   	nop
  102d71:	c7 45 d4 80 ce 11 00 	movl   $0x11ce80,-0x2c(%ebp)
    return listelm->next;
  102d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d7b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102d81:	e9 0e 01 00 00       	jmp    102e94 <default_free_pages+0x23e>
        p = le2page(le, page_link);
  102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d89:	83 e8 0c             	sub    $0xc,%eax
  102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d92:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d98:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	8b 50 08             	mov    0x8(%eax),%edx
  102da4:	89 d0                	mov    %edx,%eax
  102da6:	c1 e0 02             	shl    $0x2,%eax
  102da9:	01 d0                	add    %edx,%eax
  102dab:	c1 e0 02             	shl    $0x2,%eax
  102dae:	89 c2                	mov    %eax,%edx
  102db0:	8b 45 08             	mov    0x8(%ebp),%eax
  102db3:	01 d0                	add    %edx,%eax
  102db5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102db8:	75 5d                	jne    102e17 <default_free_pages+0x1c1>
            base->property += p->property;
  102dba:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbd:	8b 50 08             	mov    0x8(%eax),%edx
  102dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc3:	8b 40 08             	mov    0x8(%eax),%eax
  102dc6:	01 c2                	add    %eax,%edx
  102dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd1:	83 c0 04             	add    $0x4,%eax
  102dd4:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102de1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102de4:	0f b3 10             	btr    %edx,(%eax)
}
  102de7:	90                   	nop
            list_del(&(p->page_link));
  102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102deb:	83 c0 0c             	add    $0xc,%eax
  102dee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102df1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102df4:	8b 40 04             	mov    0x4(%eax),%eax
  102df7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102dfa:	8b 12                	mov    (%edx),%edx
  102dfc:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102dff:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  102e02:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e05:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e08:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e0b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102e11:	89 10                	mov    %edx,(%eax)
}
  102e13:	90                   	nop
}
  102e14:	90                   	nop
  102e15:	eb 7d                	jmp    102e94 <default_free_pages+0x23e>
        } else if (p + p->property == base) {
  102e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1a:	8b 50 08             	mov    0x8(%eax),%edx
  102e1d:	89 d0                	mov    %edx,%eax
  102e1f:	c1 e0 02             	shl    $0x2,%eax
  102e22:	01 d0                	add    %edx,%eax
  102e24:	c1 e0 02             	shl    $0x2,%eax
  102e27:	89 c2                	mov    %eax,%edx
  102e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2c:	01 d0                	add    %edx,%eax
  102e2e:	39 45 08             	cmp    %eax,0x8(%ebp)
  102e31:	75 61                	jne    102e94 <default_free_pages+0x23e>
            p->property += base->property;
  102e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e36:	8b 50 08             	mov    0x8(%eax),%edx
  102e39:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3c:	8b 40 08             	mov    0x8(%eax),%eax
  102e3f:	01 c2                	add    %eax,%edx
  102e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e44:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e47:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4a:	83 c0 04             	add    $0x4,%eax
  102e4d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102e54:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e57:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e5a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e5d:	0f b3 10             	btr    %edx,(%eax)
}
  102e60:	90                   	nop
            base = p;//?
  102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e64:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6a:	83 c0 0c             	add    $0xc,%eax
  102e6d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102e70:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e73:	8b 40 04             	mov    0x4(%eax),%eax
  102e76:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e79:	8b 12                	mov    (%edx),%edx
  102e7b:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102e7e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102e81:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e84:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e8a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e8d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102e90:	89 10                	mov    %edx,(%eax)
}
  102e92:	90                   	nop
}
  102e93:	90                   	nop
    while (le != &free_list) {
  102e94:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102e9b:	0f 85 e5 fe ff ff    	jne    102d86 <default_free_pages+0x130>
        }
    }

    nr_free += n;
  102ea1:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eaa:	01 d0                	add    %edx,%eax
  102eac:	a3 88 ce 11 00       	mov    %eax,0x11ce88
  102eb1:	c7 45 9c 80 ce 11 00 	movl   $0x11ce80,-0x64(%ebp)
    return listelm->next;
  102eb8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102ebb:	8b 40 04             	mov    0x4(%eax),%eax

    le = list_next(&free_list);
  102ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102ec1:	eb 34                	jmp    102ef7 <default_free_pages+0x2a1>
        p = le2page(le, page_link);
  102ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec6:	83 e8 0c             	sub    $0xc,%eax
  102ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ecf:	89 45 98             	mov    %eax,-0x68(%ebp)
  102ed2:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ed5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property < p) {
  102edb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ede:	8b 50 08             	mov    0x8(%eax),%edx
  102ee1:	89 d0                	mov    %edx,%eax
  102ee3:	c1 e0 02             	shl    $0x2,%eax
  102ee6:	01 d0                	add    %edx,%eax
  102ee8:	c1 e0 02             	shl    $0x2,%eax
  102eeb:	89 c2                	mov    %eax,%edx
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	01 d0                	add    %edx,%eax
  102ef2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ef5:	77 0b                	ja     102f02 <default_free_pages+0x2ac>
    while (le != &free_list) {
  102ef7:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102efe:	75 c3                	jne    102ec3 <default_free_pages+0x26d>
  102f00:	eb 01                	jmp    102f03 <default_free_pages+0x2ad>
            break;
  102f02:	90                   	nop
        }

    }

    //这里理解为什么要用add——before，因为是FF，先进先出
    list_add_before(le, &(base->page_link));
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	8d 50 0c             	lea    0xc(%eax),%edx
  102f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f0f:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102f12:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f15:	8b 00                	mov    (%eax),%eax
  102f17:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f1a:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102f1d:	89 45 88             	mov    %eax,-0x78(%ebp)
  102f20:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f23:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  102f26:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f29:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102f2c:	89 10                	mov    %edx,(%eax)
  102f2e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f31:	8b 10                	mov    (%eax),%edx
  102f33:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102f39:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f3c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f42:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f45:	8b 55 88             	mov    -0x78(%ebp),%edx
  102f48:	89 10                	mov    %edx,(%eax)
}
  102f4a:	90                   	nop
}
  102f4b:	90                   	nop
//        cprintf("le:%x page:%x",le1 , p1);
//        le1=list_next(le1);
//    }
//    cprintf("\n\n");

}
  102f4c:	90                   	nop
  102f4d:	89 ec                	mov    %ebp,%esp
  102f4f:	5d                   	pop    %ebp
  102f50:	c3                   	ret    

00102f51 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102f51:	55                   	push   %ebp
  102f52:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102f54:	a1 88 ce 11 00       	mov    0x11ce88,%eax
}
  102f59:	5d                   	pop    %ebp
  102f5a:	c3                   	ret    

00102f5b <basic_check>:

static void
basic_check(void) {
  102f5b:	55                   	push   %ebp
  102f5c:	89 e5                	mov    %esp,%ebp
  102f5e:	83 ec 58             	sub    $0x58,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102f61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f7b:	e8 9f 0f 00 00       	call   103f1f <alloc_pages>
  102f80:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f87:	75 24                	jne    102fad <basic_check+0x52>
  102f89:	c7 44 24 0c d9 68 10 	movl   $0x1068d9,0xc(%esp)
  102f90:	00 
  102f91:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102f98:	00 
  102f99:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  102fa0:	00 
  102fa1:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  102fa8:	e8 3b dd ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fb4:	e8 66 0f 00 00       	call   103f1f <alloc_pages>
  102fb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102fc0:	75 24                	jne    102fe6 <basic_check+0x8b>
  102fc2:	c7 44 24 0c f5 68 10 	movl   $0x1068f5,0xc(%esp)
  102fc9:	00 
  102fca:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  102fd1:	00 
  102fd2:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  102fd9:	00 
  102fda:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  102fe1:	e8 02 dd ff ff       	call   100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fe6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fed:	e8 2d 0f 00 00       	call   103f1f <alloc_pages>
  102ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ff9:	75 24                	jne    10301f <basic_check+0xc4>
  102ffb:	c7 44 24 0c 11 69 10 	movl   $0x106911,0xc(%esp)
  103002:	00 
  103003:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10300a:	00 
  10300b:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103012:	00 
  103013:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10301a:	e8 c9 dc ff ff       	call   100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103022:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103025:	74 10                	je     103037 <basic_check+0xdc>
  103027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10302a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10302d:	74 08                	je     103037 <basic_check+0xdc>
  10302f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103032:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103035:	75 24                	jne    10305b <basic_check+0x100>
  103037:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  10303e:	00 
  10303f:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103046:	00 
  103047:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10304e:	00 
  10304f:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103056:	e8 8d dc ff ff       	call   100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10305e:	89 04 24             	mov    %eax,(%esp)
  103061:	e8 af f8 ff ff       	call   102915 <page_ref>
  103066:	85 c0                	test   %eax,%eax
  103068:	75 1e                	jne    103088 <basic_check+0x12d>
  10306a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10306d:	89 04 24             	mov    %eax,(%esp)
  103070:	e8 a0 f8 ff ff       	call   102915 <page_ref>
  103075:	85 c0                	test   %eax,%eax
  103077:	75 0f                	jne    103088 <basic_check+0x12d>
  103079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307c:	89 04 24             	mov    %eax,(%esp)
  10307f:	e8 91 f8 ff ff       	call   102915 <page_ref>
  103084:	85 c0                	test   %eax,%eax
  103086:	74 24                	je     1030ac <basic_check+0x151>
  103088:	c7 44 24 0c 54 69 10 	movl   $0x106954,0xc(%esp)
  10308f:	00 
  103090:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103097:	00 
  103098:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  10309f:	00 
  1030a0:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1030a7:	e8 3c dc ff ff       	call   100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030af:	89 04 24             	mov    %eax,(%esp)
  1030b2:	e8 46 f8 ff ff       	call   1028fd <page2pa>
  1030b7:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1030bd:	c1 e2 0c             	shl    $0xc,%edx
  1030c0:	39 d0                	cmp    %edx,%eax
  1030c2:	72 24                	jb     1030e8 <basic_check+0x18d>
  1030c4:	c7 44 24 0c 90 69 10 	movl   $0x106990,0xc(%esp)
  1030cb:	00 
  1030cc:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1030d3:	00 
  1030d4:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1030db:	00 
  1030dc:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1030e3:	e8 00 dc ff ff       	call   100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030eb:	89 04 24             	mov    %eax,(%esp)
  1030ee:	e8 0a f8 ff ff       	call   1028fd <page2pa>
  1030f3:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1030f9:	c1 e2 0c             	shl    $0xc,%edx
  1030fc:	39 d0                	cmp    %edx,%eax
  1030fe:	72 24                	jb     103124 <basic_check+0x1c9>
  103100:	c7 44 24 0c ad 69 10 	movl   $0x1069ad,0xc(%esp)
  103107:	00 
  103108:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10310f:	00 
  103110:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103117:	00 
  103118:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10311f:	e8 c4 db ff ff       	call   100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103127:	89 04 24             	mov    %eax,(%esp)
  10312a:	e8 ce f7 ff ff       	call   1028fd <page2pa>
  10312f:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  103135:	c1 e2 0c             	shl    $0xc,%edx
  103138:	39 d0                	cmp    %edx,%eax
  10313a:	72 24                	jb     103160 <basic_check+0x205>
  10313c:	c7 44 24 0c ca 69 10 	movl   $0x1069ca,0xc(%esp)
  103143:	00 
  103144:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10314b:	00 
  10314c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103153:	00 
  103154:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10315b:	e8 88 db ff ff       	call   100ce8 <__panic>

    list_entry_t free_list_store = free_list;
  103160:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103165:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  10316b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10316e:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103171:	c7 45 d4 80 ce 11 00 	movl   $0x11ce80,-0x2c(%ebp)
    elm->prev = elm->next = elm;
  103178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10317b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10317e:	89 50 04             	mov    %edx,0x4(%eax)
  103181:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103184:	8b 50 04             	mov    0x4(%eax),%edx
  103187:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10318a:	89 10                	mov    %edx,(%eax)
}
  10318c:	90                   	nop
  10318d:	c7 45 d8 80 ce 11 00 	movl   $0x11ce80,-0x28(%ebp)
    return list->next == list;
  103194:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103197:	8b 40 04             	mov    0x4(%eax),%eax
  10319a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10319d:	0f 94 c0             	sete   %al
  1031a0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1031a3:	85 c0                	test   %eax,%eax
  1031a5:	75 24                	jne    1031cb <basic_check+0x270>
  1031a7:	c7 44 24 0c e7 69 10 	movl   $0x1069e7,0xc(%esp)
  1031ae:	00 
  1031af:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1031b6:	00 
  1031b7:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1031be:	00 
  1031bf:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1031c6:	e8 1d db ff ff       	call   100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
  1031cb:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1031d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1031d3:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  1031da:	00 00 00 

    assert(alloc_page() == NULL);
  1031dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e4:	e8 36 0d 00 00       	call   103f1f <alloc_pages>
  1031e9:	85 c0                	test   %eax,%eax
  1031eb:	74 24                	je     103211 <basic_check+0x2b6>
  1031ed:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  1031f4:	00 
  1031f5:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1031fc:	00 
  1031fd:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103204:	00 
  103205:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10320c:	e8 d7 da ff ff       	call   100ce8 <__panic>

    free_page(p0);
  103211:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103218:	00 
  103219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10321c:	89 04 24             	mov    %eax,(%esp)
  10321f:	e8 35 0d 00 00       	call   103f59 <free_pages>
    free_page(p1);
  103224:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10322b:	00 
  10322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10322f:	89 04 24             	mov    %eax,(%esp)
  103232:	e8 22 0d 00 00       	call   103f59 <free_pages>
    free_page(p2);
  103237:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10323e:	00 
  10323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103242:	89 04 24             	mov    %eax,(%esp)
  103245:	e8 0f 0d 00 00       	call   103f59 <free_pages>
    assert(nr_free == 3);
  10324a:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  10324f:	83 f8 03             	cmp    $0x3,%eax
  103252:	74 24                	je     103278 <basic_check+0x31d>
  103254:	c7 44 24 0c 13 6a 10 	movl   $0x106a13,0xc(%esp)
  10325b:	00 
  10325c:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103263:	00 
  103264:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  10326b:	00 
  10326c:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103273:	e8 70 da ff ff       	call   100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103278:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10327f:	e8 9b 0c 00 00       	call   103f1f <alloc_pages>
  103284:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103287:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10328b:	75 24                	jne    1032b1 <basic_check+0x356>
  10328d:	c7 44 24 0c d9 68 10 	movl   $0x1068d9,0xc(%esp)
  103294:	00 
  103295:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10329c:	00 
  10329d:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1032a4:	00 
  1032a5:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1032ac:	e8 37 da ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1032b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b8:	e8 62 0c 00 00       	call   103f1f <alloc_pages>
  1032bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1032c4:	75 24                	jne    1032ea <basic_check+0x38f>
  1032c6:	c7 44 24 0c f5 68 10 	movl   $0x1068f5,0xc(%esp)
  1032cd:	00 
  1032ce:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1032d5:	00 
  1032d6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1032dd:	00 
  1032de:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1032e5:	e8 fe d9 ff ff       	call   100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1032ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032f1:	e8 29 0c 00 00       	call   103f1f <alloc_pages>
  1032f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032fd:	75 24                	jne    103323 <basic_check+0x3c8>
  1032ff:	c7 44 24 0c 11 69 10 	movl   $0x106911,0xc(%esp)
  103306:	00 
  103307:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10330e:	00 
  10330f:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103316:	00 
  103317:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10331e:	e8 c5 d9 ff ff       	call   100ce8 <__panic>

    assert(alloc_page() == NULL);
  103323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10332a:	e8 f0 0b 00 00       	call   103f1f <alloc_pages>
  10332f:	85 c0                	test   %eax,%eax
  103331:	74 24                	je     103357 <basic_check+0x3fc>
  103333:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  10333a:	00 
  10333b:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103342:	00 
  103343:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  10334a:	00 
  10334b:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103352:	e8 91 d9 ff ff       	call   100ce8 <__panic>
  103357:	c7 45 d0 80 ce 11 00 	movl   $0x11ce80,-0x30(%ebp)
    return listelm->next;
  10335e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103361:	8b 40 04             	mov    0x4(%eax),%eax

    struct Page *pp1;

    list_entry_t *le1 = list_next(&free_list);
  103364:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
  103367:	eb 32                	jmp    10339b <basic_check+0x440>
        pp1 = le2page(le1, page_link);
  103369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10336c:	83 e8 0c             	sub    $0xc,%eax
  10336f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103375:	89 45 cc             	mov    %eax,-0x34(%ebp)
  103378:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10337b:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
  10337e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
  103381:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103384:	89 44 24 08          	mov    %eax,0x8(%esp)
  103388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10338b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10338f:	c7 04 24 20 6a 10 00 	movl   $0x106a20,(%esp)
  103396:	e8 bb cf ff ff       	call   100356 <cprintf>
    while (le1 != &free_list) {
  10339b:	81 7d f4 80 ce 11 00 	cmpl   $0x11ce80,-0xc(%ebp)
  1033a2:	75 c5                	jne    103369 <basic_check+0x40e>
    }
    cprintf("\n\n");
  1033a4:	c7 04 24 2e 6a 10 00 	movl   $0x106a2e,(%esp)
  1033ab:	e8 a6 cf ff ff       	call   100356 <cprintf>

    free_page(p0);
  1033b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033b7:	00 
  1033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033bb:	89 04 24             	mov    %eax,(%esp)
  1033be:	e8 96 0b 00 00       	call   103f59 <free_pages>
  1033c3:	c7 45 c8 80 ce 11 00 	movl   $0x11ce80,-0x38(%ebp)
  1033ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1033cd:	8b 40 04             	mov    0x4(%eax),%eax

    le1 = list_next(&free_list);
  1033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
  1033d3:	eb 32                	jmp    103407 <basic_check+0x4ac>
        pp1 = le2page(le1, page_link);
  1033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033d8:	83 e8 0c             	sub    $0xc,%eax
  1033db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1033e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033e7:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
  1033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
  1033ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033fb:	c7 04 24 20 6a 10 00 	movl   $0x106a20,(%esp)
  103402:	e8 4f cf ff ff       	call   100356 <cprintf>
    while (le1 != &free_list) {
  103407:	81 7d f4 80 ce 11 00 	cmpl   $0x11ce80,-0xc(%ebp)
  10340e:	75 c5                	jne    1033d5 <basic_check+0x47a>
    }
    cprintf("\n\n");
  103410:	c7 04 24 2e 6a 10 00 	movl   $0x106a2e,(%esp)
  103417:	e8 3a cf ff ff       	call   100356 <cprintf>
  10341c:	c7 45 c0 80 ce 11 00 	movl   $0x11ce80,-0x40(%ebp)
    return list->next == list;
  103423:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103426:	8b 40 04             	mov    0x4(%eax),%eax
  103429:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  10342c:	0f 94 c0             	sete   %al
  10342f:	0f b6 c0             	movzbl %al,%eax


    assert(!list_empty(&free_list));
  103432:	85 c0                	test   %eax,%eax
  103434:	74 24                	je     10345a <basic_check+0x4ff>
  103436:	c7 44 24 0c 31 6a 10 	movl   $0x106a31,0xc(%esp)
  10343d:	00 
  10343e:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103445:	00 
  103446:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10344d:	00 
  10344e:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103455:	e8 8e d8 ff ff       	call   100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10345a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103461:	e8 b9 0a 00 00       	call   103f1f <alloc_pages>
  103466:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10346c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  10346f:	74 24                	je     103495 <basic_check+0x53a>
  103471:	c7 44 24 0c 49 6a 10 	movl   $0x106a49,0xc(%esp)
  103478:	00 
  103479:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103480:	00 
  103481:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  103488:	00 
  103489:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103490:	e8 53 d8 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  103495:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10349c:	e8 7e 0a 00 00       	call   103f1f <alloc_pages>
  1034a1:	85 c0                	test   %eax,%eax
  1034a3:	74 24                	je     1034c9 <basic_check+0x56e>
  1034a5:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  1034ac:	00 
  1034ad:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1034b4:	00 
  1034b5:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1034bc:	00 
  1034bd:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1034c4:	e8 1f d8 ff ff       	call   100ce8 <__panic>

    assert(nr_free == 0);
  1034c9:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1034ce:	85 c0                	test   %eax,%eax
  1034d0:	74 24                	je     1034f6 <basic_check+0x59b>
  1034d2:	c7 44 24 0c 62 6a 10 	movl   $0x106a62,0xc(%esp)
  1034d9:	00 
  1034da:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1034e1:	00 
  1034e2:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1034e9:	00 
  1034ea:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1034f1:	e8 f2 d7 ff ff       	call   100ce8 <__panic>
    free_list = free_list_store;
  1034f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1034f9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1034fc:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103501:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    nr_free = nr_free_store;
  103507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350a:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_page(p);
  10350f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103516:	00 
  103517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10351a:	89 04 24             	mov    %eax,(%esp)
  10351d:	e8 37 0a 00 00       	call   103f59 <free_pages>
    free_page(p1);
  103522:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103529:	00 
  10352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10352d:	89 04 24             	mov    %eax,(%esp)
  103530:	e8 24 0a 00 00       	call   103f59 <free_pages>
    free_page(p2);
  103535:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10353c:	00 
  10353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103540:	89 04 24             	mov    %eax,(%esp)
  103543:	e8 11 0a 00 00       	call   103f59 <free_pages>
}
  103548:	90                   	nop
  103549:	89 ec                	mov    %ebp,%esp
  10354b:	5d                   	pop    %ebp
  10354c:	c3                   	ret    

0010354d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10354d:	55                   	push   %ebp
  10354e:	89 e5                	mov    %esp,%ebp
  103550:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  103556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10355d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103564:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10356b:	eb 6a                	jmp    1035d7 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  10356d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103570:	83 e8 0c             	sub    $0xc,%eax
  103573:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  103576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103579:	83 c0 04             	add    $0x4,%eax
  10357c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103583:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103586:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103589:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10358c:	0f a3 10             	bt     %edx,(%eax)
  10358f:	19 c0                	sbb    %eax,%eax
  103591:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103594:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103598:	0f 95 c0             	setne  %al
  10359b:	0f b6 c0             	movzbl %al,%eax
  10359e:	85 c0                	test   %eax,%eax
  1035a0:	75 24                	jne    1035c6 <default_check+0x79>
  1035a2:	c7 44 24 0c 6f 6a 10 	movl   $0x106a6f,0xc(%esp)
  1035a9:	00 
  1035aa:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1035b1:	00 
  1035b2:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1035b9:	00 
  1035ba:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1035c1:	e8 22 d7 ff ff       	call   100ce8 <__panic>
        count++, total += p->property;
  1035c6:	ff 45 f4             	incl   -0xc(%ebp)
  1035c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035cc:	8b 50 08             	mov    0x8(%eax),%edx
  1035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035d2:	01 d0                	add    %edx,%eax
  1035d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1035dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1035e0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1035e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035e6:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  1035ed:	0f 85 7a ff ff ff    	jne    10356d <default_check+0x20>
    }
    assert(total == nr_free_pages());
  1035f3:	e8 96 09 00 00       	call   103f8e <nr_free_pages>
  1035f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1035fb:	39 d0                	cmp    %edx,%eax
  1035fd:	74 24                	je     103623 <default_check+0xd6>
  1035ff:	c7 44 24 0c 7f 6a 10 	movl   $0x106a7f,0xc(%esp)
  103606:	00 
  103607:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10360e:	00 
  10360f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103616:	00 
  103617:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10361e:	e8 c5 d6 ff ff       	call   100ce8 <__panic>

    basic_check();
  103623:	e8 33 f9 ff ff       	call   102f5b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103628:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10362f:	e8 eb 08 00 00       	call   103f1f <alloc_pages>
  103634:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103637:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10363b:	75 24                	jne    103661 <default_check+0x114>
  10363d:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  103644:	00 
  103645:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10364c:	00 
  10364d:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  103654:	00 
  103655:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10365c:	e8 87 d6 ff ff       	call   100ce8 <__panic>
    assert(!PageProperty(p0));
  103661:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103664:	83 c0 04             	add    $0x4,%eax
  103667:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10366e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103671:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103674:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103677:	0f a3 10             	bt     %edx,(%eax)
  10367a:	19 c0                	sbb    %eax,%eax
  10367c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10367f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103683:	0f 95 c0             	setne  %al
  103686:	0f b6 c0             	movzbl %al,%eax
  103689:	85 c0                	test   %eax,%eax
  10368b:	74 24                	je     1036b1 <default_check+0x164>
  10368d:	c7 44 24 0c a3 6a 10 	movl   $0x106aa3,0xc(%esp)
  103694:	00 
  103695:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10369c:	00 
  10369d:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  1036a4:	00 
  1036a5:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1036ac:	e8 37 d6 ff ff       	call   100ce8 <__panic>

    list_entry_t free_list_store = free_list;
  1036b1:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1036b6:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  1036bc:	89 45 80             	mov    %eax,-0x80(%ebp)
  1036bf:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1036c2:	c7 45 b0 80 ce 11 00 	movl   $0x11ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1036c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1036cf:	89 50 04             	mov    %edx,0x4(%eax)
  1036d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036d5:	8b 50 04             	mov    0x4(%eax),%edx
  1036d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036db:	89 10                	mov    %edx,(%eax)
}
  1036dd:	90                   	nop
  1036de:	c7 45 b4 80 ce 11 00 	movl   $0x11ce80,-0x4c(%ebp)
    return list->next == list;
  1036e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036e8:	8b 40 04             	mov    0x4(%eax),%eax
  1036eb:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1036ee:	0f 94 c0             	sete   %al
  1036f1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1036f4:	85 c0                	test   %eax,%eax
  1036f6:	75 24                	jne    10371c <default_check+0x1cf>
  1036f8:	c7 44 24 0c e7 69 10 	movl   $0x1069e7,0xc(%esp)
  1036ff:	00 
  103700:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103707:	00 
  103708:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  10370f:	00 
  103710:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103717:	e8 cc d5 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  10371c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103723:	e8 f7 07 00 00       	call   103f1f <alloc_pages>
  103728:	85 c0                	test   %eax,%eax
  10372a:	74 24                	je     103750 <default_check+0x203>
  10372c:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  103733:	00 
  103734:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10373b:	00 
  10373c:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  103743:	00 
  103744:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10374b:	e8 98 d5 ff ff       	call   100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
  103750:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103755:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  103758:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  10375f:	00 00 00 

    free_pages(p0 + 2, 3);
  103762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103765:	83 c0 28             	add    $0x28,%eax
  103768:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10376f:	00 
  103770:	89 04 24             	mov    %eax,(%esp)
  103773:	e8 e1 07 00 00       	call   103f59 <free_pages>
    assert(alloc_pages(4) == NULL);
  103778:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10377f:	e8 9b 07 00 00       	call   103f1f <alloc_pages>
  103784:	85 c0                	test   %eax,%eax
  103786:	74 24                	je     1037ac <default_check+0x25f>
  103788:	c7 44 24 0c b5 6a 10 	movl   $0x106ab5,0xc(%esp)
  10378f:	00 
  103790:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103797:	00 
  103798:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  10379f:	00 
  1037a0:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1037a7:	e8 3c d5 ff ff       	call   100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037af:	83 c0 28             	add    $0x28,%eax
  1037b2:	83 c0 04             	add    $0x4,%eax
  1037b5:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037bc:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1037c2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1037c5:	0f a3 10             	bt     %edx,(%eax)
  1037c8:	19 c0                	sbb    %eax,%eax
  1037ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1037cd:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1037d1:	0f 95 c0             	setne  %al
  1037d4:	0f b6 c0             	movzbl %al,%eax
  1037d7:	85 c0                	test   %eax,%eax
  1037d9:	74 0e                	je     1037e9 <default_check+0x29c>
  1037db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037de:	83 c0 28             	add    $0x28,%eax
  1037e1:	8b 40 08             	mov    0x8(%eax),%eax
  1037e4:	83 f8 03             	cmp    $0x3,%eax
  1037e7:	74 24                	je     10380d <default_check+0x2c0>
  1037e9:	c7 44 24 0c cc 6a 10 	movl   $0x106acc,0xc(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1037f8:	00 
  1037f9:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103800:	00 
  103801:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103808:	e8 db d4 ff ff       	call   100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10380d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103814:	e8 06 07 00 00       	call   103f1f <alloc_pages>
  103819:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10381c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103820:	75 24                	jne    103846 <default_check+0x2f9>
  103822:	c7 44 24 0c f8 6a 10 	movl   $0x106af8,0xc(%esp)
  103829:	00 
  10382a:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103831:	00 
  103832:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  103839:	00 
  10383a:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103841:	e8 a2 d4 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  103846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10384d:	e8 cd 06 00 00       	call   103f1f <alloc_pages>
  103852:	85 c0                	test   %eax,%eax
  103854:	74 24                	je     10387a <default_check+0x32d>
  103856:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  10385d:	00 
  10385e:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103865:	00 
  103866:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
  10386d:	00 
  10386e:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103875:	e8 6e d4 ff ff       	call   100ce8 <__panic>
    assert(p0 + 2 == p1);
  10387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10387d:	83 c0 28             	add    $0x28,%eax
  103880:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103883:	74 24                	je     1038a9 <default_check+0x35c>
  103885:	c7 44 24 0c 16 6b 10 	movl   $0x106b16,0xc(%esp)
  10388c:	00 
  10388d:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103894:	00 
  103895:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  10389c:	00 
  10389d:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1038a4:	e8 3f d4 ff ff       	call   100ce8 <__panic>

    //h
    p2 = p0 + 1;
  1038a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038ac:	83 c0 14             	add    $0x14,%eax
  1038af:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1038b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038b9:	00 
  1038ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038bd:	89 04 24             	mov    %eax,(%esp)
  1038c0:	e8 94 06 00 00       	call   103f59 <free_pages>
    free_pages(p1, 3);
  1038c5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1038cc:	00 
  1038cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038d0:	89 04 24             	mov    %eax,(%esp)
  1038d3:	e8 81 06 00 00       	call   103f59 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1038d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038db:	83 c0 04             	add    $0x4,%eax
  1038de:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1038e5:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1038e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1038eb:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1038ee:	0f a3 10             	bt     %edx,(%eax)
  1038f1:	19 c0                	sbb    %eax,%eax
  1038f3:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1038f6:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1038fa:	0f 95 c0             	setne  %al
  1038fd:	0f b6 c0             	movzbl %al,%eax
  103900:	85 c0                	test   %eax,%eax
  103902:	74 0b                	je     10390f <default_check+0x3c2>
  103904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103907:	8b 40 08             	mov    0x8(%eax),%eax
  10390a:	83 f8 01             	cmp    $0x1,%eax
  10390d:	74 24                	je     103933 <default_check+0x3e6>
  10390f:	c7 44 24 0c 24 6b 10 	movl   $0x106b24,0xc(%esp)
  103916:	00 
  103917:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  10391e:	00 
  10391f:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
  103926:	00 
  103927:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  10392e:	e8 b5 d3 ff ff       	call   100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103936:	83 c0 04             	add    $0x4,%eax
  103939:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103940:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103943:	8b 45 90             	mov    -0x70(%ebp),%eax
  103946:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103949:	0f a3 10             	bt     %edx,(%eax)
  10394c:	19 c0                	sbb    %eax,%eax
  10394e:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103951:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103955:	0f 95 c0             	setne  %al
  103958:	0f b6 c0             	movzbl %al,%eax
  10395b:	85 c0                	test   %eax,%eax
  10395d:	74 0b                	je     10396a <default_check+0x41d>
  10395f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103962:	8b 40 08             	mov    0x8(%eax),%eax
  103965:	83 f8 03             	cmp    $0x3,%eax
  103968:	74 24                	je     10398e <default_check+0x441>
  10396a:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  103971:	00 
  103972:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103979:	00 
  10397a:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
  103981:	00 
  103982:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103989:	e8 5a d3 ff ff       	call   100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10398e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103995:	e8 85 05 00 00       	call   103f1f <alloc_pages>
  10399a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10399d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039a0:	83 e8 14             	sub    $0x14,%eax
  1039a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039a6:	74 24                	je     1039cc <default_check+0x47f>
  1039a8:	c7 44 24 0c 72 6b 10 	movl   $0x106b72,0xc(%esp)
  1039af:	00 
  1039b0:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  1039b7:	00 
  1039b8:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  1039bf:	00 
  1039c0:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  1039c7:	e8 1c d3 ff ff       	call   100ce8 <__panic>
    free_page(p0);
  1039cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039d3:	00 
  1039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039d7:	89 04 24             	mov    %eax,(%esp)
  1039da:	e8 7a 05 00 00       	call   103f59 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1039df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1039e6:	e8 34 05 00 00       	call   103f1f <alloc_pages>
  1039eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039f1:	83 c0 14             	add    $0x14,%eax
  1039f4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039f7:	74 24                	je     103a1d <default_check+0x4d0>
  1039f9:	c7 44 24 0c 90 6b 10 	movl   $0x106b90,0xc(%esp)
  103a00:	00 
  103a01:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103a08:	00 
  103a09:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
  103a10:	00 
  103a11:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103a18:	e8 cb d2 ff ff       	call   100ce8 <__panic>

    free_pages(p0, 2);
  103a1d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a24:	00 
  103a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a28:	89 04 24             	mov    %eax,(%esp)
  103a2b:	e8 29 05 00 00       	call   103f59 <free_pages>
    free_page(p2);
  103a30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a37:	00 
  103a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a3b:	89 04 24             	mov    %eax,(%esp)
  103a3e:	e8 16 05 00 00       	call   103f59 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a43:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a4a:	e8 d0 04 00 00       	call   103f1f <alloc_pages>
  103a4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103a56:	75 24                	jne    103a7c <default_check+0x52f>
  103a58:	c7 44 24 0c b0 6b 10 	movl   $0x106bb0,0xc(%esp)
  103a5f:	00 
  103a60:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103a67:	00 
  103a68:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
  103a6f:	00 
  103a70:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103a77:	e8 6c d2 ff ff       	call   100ce8 <__panic>
    assert(alloc_page() == NULL);
  103a7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a83:	e8 97 04 00 00       	call   103f1f <alloc_pages>
  103a88:	85 c0                	test   %eax,%eax
  103a8a:	74 24                	je     103ab0 <default_check+0x563>
  103a8c:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  103a93:	00 
  103a94:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103a9b:	00 
  103a9c:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
  103aa3:	00 
  103aa4:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103aab:	e8 38 d2 ff ff       	call   100ce8 <__panic>

    assert(nr_free == 0);
  103ab0:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103ab5:	85 c0                	test   %eax,%eax
  103ab7:	74 24                	je     103add <default_check+0x590>
  103ab9:	c7 44 24 0c 62 6a 10 	movl   $0x106a62,0xc(%esp)
  103ac0:	00 
  103ac1:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103ac8:	00 
  103ac9:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
  103ad0:	00 
  103ad1:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103ad8:	e8 0b d2 ff ff       	call   100ce8 <__panic>
    nr_free = nr_free_store;
  103add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ae0:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_list = free_list_store;
  103ae5:	8b 45 80             	mov    -0x80(%ebp),%eax
  103ae8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103aeb:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103af0:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    free_pages(p0, 5);
  103af6:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103afd:	00 
  103afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b01:	89 04 24             	mov    %eax,(%esp)
  103b04:	e8 50 04 00 00       	call   103f59 <free_pages>

    le = &free_list;
  103b09:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b10:	eb 5a                	jmp    103b6c <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  103b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b15:	8b 40 04             	mov    0x4(%eax),%eax
  103b18:	8b 00                	mov    (%eax),%eax
  103b1a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b1d:	75 0d                	jne    103b2c <default_check+0x5df>
  103b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b22:	8b 00                	mov    (%eax),%eax
  103b24:	8b 40 04             	mov    0x4(%eax),%eax
  103b27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b2a:	74 24                	je     103b50 <default_check+0x603>
  103b2c:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  103b33:	00 
  103b34:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103b3b:	00 
  103b3c:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
  103b43:	00 
  103b44:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103b4b:	e8 98 d1 ff ff       	call   100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
  103b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b53:	83 e8 0c             	sub    $0xc,%eax
  103b56:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  103b59:	ff 4d f4             	decl   -0xc(%ebp)
  103b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b62:	8b 48 08             	mov    0x8(%eax),%ecx
  103b65:	89 d0                	mov    %edx,%eax
  103b67:	29 c8                	sub    %ecx,%eax
  103b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b6f:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103b72:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b75:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b7b:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103b82:	75 8e                	jne    103b12 <default_check+0x5c5>
    }
    assert(count == 0);
  103b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b88:	74 24                	je     103bae <default_check+0x661>
  103b8a:	c7 44 24 0c fd 6b 10 	movl   $0x106bfd,0xc(%esp)
  103b91:	00 
  103b92:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103b99:	00 
  103b9a:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
  103ba1:	00 
  103ba2:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103ba9:	e8 3a d1 ff ff       	call   100ce8 <__panic>
    assert(total == 0);
  103bae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bb2:	74 24                	je     103bd8 <default_check+0x68b>
  103bb4:	c7 44 24 0c 08 6c 10 	movl   $0x106c08,0xc(%esp)
  103bbb:	00 
  103bbc:	c7 44 24 08 76 68 10 	movl   $0x106876,0x8(%esp)
  103bc3:	00 
  103bc4:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  103bcb:	00 
  103bcc:	c7 04 24 8b 68 10 00 	movl   $0x10688b,(%esp)
  103bd3:	e8 10 d1 ff ff       	call   100ce8 <__panic>
}
  103bd8:	90                   	nop
  103bd9:	89 ec                	mov    %ebp,%esp
  103bdb:	5d                   	pop    %ebp
  103bdc:	c3                   	ret    

00103bdd <page2ppn>:
page2ppn(struct Page *page) {
  103bdd:	55                   	push   %ebp
  103bde:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103be0:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  103be6:	8b 45 08             	mov    0x8(%ebp),%eax
  103be9:	29 d0                	sub    %edx,%eax
  103beb:	c1 f8 02             	sar    $0x2,%eax
  103bee:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103bf4:	5d                   	pop    %ebp
  103bf5:	c3                   	ret    

00103bf6 <page2pa>:
page2pa(struct Page *page) {
  103bf6:	55                   	push   %ebp
  103bf7:	89 e5                	mov    %esp,%ebp
  103bf9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  103bff:	89 04 24             	mov    %eax,(%esp)
  103c02:	e8 d6 ff ff ff       	call   103bdd <page2ppn>
  103c07:	c1 e0 0c             	shl    $0xc,%eax
}
  103c0a:	89 ec                	mov    %ebp,%esp
  103c0c:	5d                   	pop    %ebp
  103c0d:	c3                   	ret    

00103c0e <pa2page>:
pa2page(uintptr_t pa) {
  103c0e:	55                   	push   %ebp
  103c0f:	89 e5                	mov    %esp,%ebp
  103c11:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c14:	8b 45 08             	mov    0x8(%ebp),%eax
  103c17:	c1 e8 0c             	shr    $0xc,%eax
  103c1a:	89 c2                	mov    %eax,%edx
  103c1c:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103c21:	39 c2                	cmp    %eax,%edx
  103c23:	72 1c                	jb     103c41 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c25:	c7 44 24 08 44 6c 10 	movl   $0x106c44,0x8(%esp)
  103c2c:	00 
  103c2d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c34:	00 
  103c35:	c7 04 24 63 6c 10 00 	movl   $0x106c63,(%esp)
  103c3c:	e8 a7 d0 ff ff       	call   100ce8 <__panic>
    return &pages[PPN(pa)];
  103c41:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  103c47:	8b 45 08             	mov    0x8(%ebp),%eax
  103c4a:	c1 e8 0c             	shr    $0xc,%eax
  103c4d:	89 c2                	mov    %eax,%edx
  103c4f:	89 d0                	mov    %edx,%eax
  103c51:	c1 e0 02             	shl    $0x2,%eax
  103c54:	01 d0                	add    %edx,%eax
  103c56:	c1 e0 02             	shl    $0x2,%eax
  103c59:	01 c8                	add    %ecx,%eax
}
  103c5b:	89 ec                	mov    %ebp,%esp
  103c5d:	5d                   	pop    %ebp
  103c5e:	c3                   	ret    

00103c5f <page2kva>:
page2kva(struct Page *page) {
  103c5f:	55                   	push   %ebp
  103c60:	89 e5                	mov    %esp,%ebp
  103c62:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c65:	8b 45 08             	mov    0x8(%ebp),%eax
  103c68:	89 04 24             	mov    %eax,(%esp)
  103c6b:	e8 86 ff ff ff       	call   103bf6 <page2pa>
  103c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c76:	c1 e8 0c             	shr    $0xc,%eax
  103c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c7c:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103c81:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c84:	72 23                	jb     103ca9 <page2kva+0x4a>
  103c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c8d:	c7 44 24 08 74 6c 10 	movl   $0x106c74,0x8(%esp)
  103c94:	00 
  103c95:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103c9c:	00 
  103c9d:	c7 04 24 63 6c 10 00 	movl   $0x106c63,(%esp)
  103ca4:	e8 3f d0 ff ff       	call   100ce8 <__panic>
  103ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cac:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cb1:	89 ec                	mov    %ebp,%esp
  103cb3:	5d                   	pop    %ebp
  103cb4:	c3                   	ret    

00103cb5 <pte2page>:
pte2page(pte_t pte) {
  103cb5:	55                   	push   %ebp
  103cb6:	89 e5                	mov    %esp,%ebp
  103cb8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  103cbe:	83 e0 01             	and    $0x1,%eax
  103cc1:	85 c0                	test   %eax,%eax
  103cc3:	75 1c                	jne    103ce1 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103cc5:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  103ccc:	00 
  103ccd:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cd4:	00 
  103cd5:	c7 04 24 63 6c 10 00 	movl   $0x106c63,(%esp)
  103cdc:	e8 07 d0 ff ff       	call   100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
  103ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ce9:	89 04 24             	mov    %eax,(%esp)
  103cec:	e8 1d ff ff ff       	call   103c0e <pa2page>
}
  103cf1:	89 ec                	mov    %ebp,%esp
  103cf3:	5d                   	pop    %ebp
  103cf4:	c3                   	ret    

00103cf5 <pde2page>:
pde2page(pde_t pde) {
  103cf5:	55                   	push   %ebp
  103cf6:	89 e5                	mov    %esp,%ebp
  103cf8:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  103cfe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d03:	89 04 24             	mov    %eax,(%esp)
  103d06:	e8 03 ff ff ff       	call   103c0e <pa2page>
}
  103d0b:	89 ec                	mov    %ebp,%esp
  103d0d:	5d                   	pop    %ebp
  103d0e:	c3                   	ret    

00103d0f <page_ref>:
page_ref(struct Page *page) {
  103d0f:	55                   	push   %ebp
  103d10:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d12:	8b 45 08             	mov    0x8(%ebp),%eax
  103d15:	8b 00                	mov    (%eax),%eax
}
  103d17:	5d                   	pop    %ebp
  103d18:	c3                   	ret    

00103d19 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103d19:	55                   	push   %ebp
  103d1a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d22:	89 10                	mov    %edx,(%eax)
}
  103d24:	90                   	nop
  103d25:	5d                   	pop    %ebp
  103d26:	c3                   	ret    

00103d27 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d27:	55                   	push   %ebp
  103d28:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d2d:	8b 00                	mov    (%eax),%eax
  103d2f:	8d 50 01             	lea    0x1(%eax),%edx
  103d32:	8b 45 08             	mov    0x8(%ebp),%eax
  103d35:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d37:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3a:	8b 00                	mov    (%eax),%eax
}
  103d3c:	5d                   	pop    %ebp
  103d3d:	c3                   	ret    

00103d3e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d3e:	55                   	push   %ebp
  103d3f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d41:	8b 45 08             	mov    0x8(%ebp),%eax
  103d44:	8b 00                	mov    (%eax),%eax
  103d46:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d49:	8b 45 08             	mov    0x8(%ebp),%eax
  103d4c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  103d51:	8b 00                	mov    (%eax),%eax
}
  103d53:	5d                   	pop    %ebp
  103d54:	c3                   	ret    

00103d55 <__intr_save>:
__intr_save(void) {
  103d55:	55                   	push   %ebp
  103d56:	89 e5                	mov    %esp,%ebp
  103d58:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d5b:	9c                   	pushf  
  103d5c:	58                   	pop    %eax
  103d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d63:	25 00 02 00 00       	and    $0x200,%eax
  103d68:	85 c0                	test   %eax,%eax
  103d6a:	74 0c                	je     103d78 <__intr_save+0x23>
        intr_disable();
  103d6c:	e8 d0 d9 ff ff       	call   101741 <intr_disable>
        return 1;
  103d71:	b8 01 00 00 00       	mov    $0x1,%eax
  103d76:	eb 05                	jmp    103d7d <__intr_save+0x28>
    return 0;
  103d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d7d:	89 ec                	mov    %ebp,%esp
  103d7f:	5d                   	pop    %ebp
  103d80:	c3                   	ret    

00103d81 <__intr_restore>:
__intr_restore(bool flag) {
  103d81:	55                   	push   %ebp
  103d82:	89 e5                	mov    %esp,%ebp
  103d84:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d8b:	74 05                	je     103d92 <__intr_restore+0x11>
        intr_enable();
  103d8d:	e8 a7 d9 ff ff       	call   101739 <intr_enable>
}
  103d92:	90                   	nop
  103d93:	89 ec                	mov    %ebp,%esp
  103d95:	5d                   	pop    %ebp
  103d96:	c3                   	ret    

00103d97 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d97:	55                   	push   %ebp
  103d98:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)"::"r" (pd));
  103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d9d:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs"::"a" (USER_DS));
  103da0:	b8 23 00 00 00       	mov    $0x23,%eax
  103da5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs"::"a" (USER_DS));
  103da7:	b8 23 00 00 00       	mov    $0x23,%eax
  103dac:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es"::"a" (KERNEL_DS));
  103dae:	b8 10 00 00 00       	mov    $0x10,%eax
  103db3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds"::"a" (KERNEL_DS));
  103db5:	b8 10 00 00 00       	mov    $0x10,%eax
  103dba:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss"::"a" (KERNEL_DS));
  103dbc:	b8 10 00 00 00       	mov    $0x10,%eax
  103dc1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n"::"i" (KERNEL_CS));
  103dc3:	ea ca 3d 10 00 08 00 	ljmp   $0x8,$0x103dca
}
  103dca:	90                   	nop
  103dcb:	5d                   	pop    %ebp
  103dcc:	c3                   	ret    

00103dcd <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103dcd:	55                   	push   %ebp
  103dce:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  103dd3:	a3 c4 ce 11 00       	mov    %eax,0x11cec4
}
  103dd8:	90                   	nop
  103dd9:	5d                   	pop    %ebp
  103dda:	c3                   	ret    

00103ddb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103ddb:	55                   	push   %ebp
  103ddc:	89 e5                	mov    %esp,%ebp
  103dde:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t) bootstacktop);
  103de1:	b8 00 90 11 00       	mov    $0x119000,%eax
  103de6:	89 04 24             	mov    %eax,(%esp)
  103de9:	e8 df ff ff ff       	call   103dcd <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103dee:	66 c7 05 c8 ce 11 00 	movw   $0x10,0x11cec8
  103df5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t) & ts, sizeof(ts), DPL_KERNEL);
  103df7:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  103dfe:	68 00 
  103e00:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e05:	0f b7 c0             	movzwl %ax,%eax
  103e08:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  103e0e:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e13:	c1 e8 10             	shr    $0x10,%eax
  103e16:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  103e1b:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e22:	24 f0                	and    $0xf0,%al
  103e24:	0c 09                	or     $0x9,%al
  103e26:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e2b:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e32:	24 ef                	and    $0xef,%al
  103e34:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e39:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e40:	24 9f                	and    $0x9f,%al
  103e42:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e47:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e4e:	0c 80                	or     $0x80,%al
  103e50:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e55:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e5c:	24 f0                	and    $0xf0,%al
  103e5e:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e63:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e6a:	24 ef                	and    $0xef,%al
  103e6c:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e71:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e78:	24 df                	and    $0xdf,%al
  103e7a:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e7f:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e86:	0c 40                	or     $0x40,%al
  103e88:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e8d:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e94:	24 7f                	and    $0x7f,%al
  103e96:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e9b:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103ea0:	c1 e8 18             	shr    $0x18,%eax
  103ea3:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ea8:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  103eaf:	e8 e3 fe ff ff       	call   103d97 <lgdt>
  103eb4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103eba:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103ebe:	0f 00 d8             	ltr    %ax
}
  103ec1:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103ec2:	90                   	nop
  103ec3:	89 ec                	mov    %ebp,%esp
  103ec5:	5d                   	pop    %ebp
  103ec6:	c3                   	ret    

00103ec7 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103ec7:	55                   	push   %ebp
  103ec8:	89 e5                	mov    %esp,%ebp
  103eca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ecd:	c7 05 ac ce 11 00 28 	movl   $0x106c28,0x11ceac
  103ed4:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ed7:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103edc:	8b 00                	mov    (%eax),%eax
  103ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ee2:	c7 04 24 c4 6c 10 00 	movl   $0x106cc4,(%esp)
  103ee9:	e8 68 c4 ff ff       	call   100356 <cprintf>
    pmm_manager->init();
  103eee:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103ef3:	8b 40 04             	mov    0x4(%eax),%eax
  103ef6:	ff d0                	call   *%eax
}
  103ef8:	90                   	nop
  103ef9:	89 ec                	mov    %ebp,%esp
  103efb:	5d                   	pop    %ebp
  103efc:	c3                   	ret    

00103efd <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103efd:	55                   	push   %ebp
  103efe:	89 e5                	mov    %esp,%ebp
  103f00:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f03:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f08:	8b 40 08             	mov    0x8(%eax),%eax
  103f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f0e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f12:	8b 55 08             	mov    0x8(%ebp),%edx
  103f15:	89 14 24             	mov    %edx,(%esp)
  103f18:	ff d0                	call   *%eax
}
  103f1a:	90                   	nop
  103f1b:	89 ec                	mov    %ebp,%esp
  103f1d:	5d                   	pop    %ebp
  103f1e:	c3                   	ret    

00103f1f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f1f:	55                   	push   %ebp
  103f20:	89 e5                	mov    %esp,%ebp
  103f22:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
  103f25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f2c:	e8 24 fe ff ff       	call   103d55 <__intr_save>
  103f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f34:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f39:	8b 40 0c             	mov    0xc(%eax),%eax
  103f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  103f3f:	89 14 24             	mov    %edx,(%esp)
  103f42:	ff d0                	call   *%eax
  103f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f4a:	89 04 24             	mov    %eax,(%esp)
  103f4d:	e8 2f fe ff ff       	call   103d81 <__intr_restore>
    return page;
  103f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f55:	89 ec                	mov    %ebp,%esp
  103f57:	5d                   	pop    %ebp
  103f58:	c3                   	ret    

00103f59 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f59:	55                   	push   %ebp
  103f5a:	89 e5                	mov    %esp,%ebp
  103f5c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f5f:	e8 f1 fd ff ff       	call   103d55 <__intr_save>
  103f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f67:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f6c:	8b 40 10             	mov    0x10(%eax),%eax
  103f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f72:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f76:	8b 55 08             	mov    0x8(%ebp),%edx
  103f79:	89 14 24             	mov    %edx,(%esp)
  103f7c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f81:	89 04 24             	mov    %eax,(%esp)
  103f84:	e8 f8 fd ff ff       	call   103d81 <__intr_restore>
}
  103f89:	90                   	nop
  103f8a:	89 ec                	mov    %ebp,%esp
  103f8c:	5d                   	pop    %ebp
  103f8d:	c3                   	ret    

00103f8e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f8e:	55                   	push   %ebp
  103f8f:	89 e5                	mov    %esp,%ebp
  103f91:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f94:	e8 bc fd ff ff       	call   103d55 <__intr_save>
  103f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f9c:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103fa1:	8b 40 14             	mov    0x14(%eax),%eax
  103fa4:	ff d0                	call   *%eax
  103fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fac:	89 04 24             	mov    %eax,(%esp)
  103faf:	e8 cd fd ff ff       	call   103d81 <__intr_restore>
    return ret;
  103fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103fb7:	89 ec                	mov    %ebp,%esp
  103fb9:	5d                   	pop    %ebp
  103fba:	c3                   	ret    

00103fbb <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103fbb:	55                   	push   %ebp
  103fbc:	89 e5                	mov    %esp,%ebp
  103fbe:	57                   	push   %edi
  103fbf:	56                   	push   %esi
  103fc0:	53                   	push   %ebx
  103fc1:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *) (0x8000 + KERNBASE);
  103fc7:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
  103fce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103fdc:	c7 04 24 db 6c 10 00 	movl   $0x106cdb,(%esp)
  103fe3:	e8 6e c3 ff ff       	call   100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++) {
  103fe8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fef:	e9 0c 01 00 00       	jmp    104100 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103ff4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  103ff7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ffa:	89 d0                	mov    %edx,%eax
  103ffc:	c1 e0 02             	shl    $0x2,%eax
  103fff:	01 d0                	add    %edx,%eax
  104001:	c1 e0 02             	shl    $0x2,%eax
  104004:	01 c8                	add    %ecx,%eax
  104006:	8b 50 08             	mov    0x8(%eax),%edx
  104009:	8b 40 04             	mov    0x4(%eax),%eax
  10400c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10400f:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104012:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104015:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104018:	89 d0                	mov    %edx,%eax
  10401a:	c1 e0 02             	shl    $0x2,%eax
  10401d:	01 d0                	add    %edx,%eax
  10401f:	c1 e0 02             	shl    $0x2,%eax
  104022:	01 c8                	add    %ecx,%eax
  104024:	8b 48 0c             	mov    0xc(%eax),%ecx
  104027:	8b 58 10             	mov    0x10(%eax),%ebx
  10402a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10402d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104030:	01 c8                	add    %ecx,%eax
  104032:	11 da                	adc    %ebx,%edx
  104034:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104037:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  10403a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10403d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104040:	89 d0                	mov    %edx,%eax
  104042:	c1 e0 02             	shl    $0x2,%eax
  104045:	01 d0                	add    %edx,%eax
  104047:	c1 e0 02             	shl    $0x2,%eax
  10404a:	01 c8                	add    %ecx,%eax
  10404c:	83 c0 14             	add    $0x14,%eax
  10404f:	8b 00                	mov    (%eax),%eax
  104051:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104057:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10405a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10405d:	83 c0 ff             	add    $0xffffffff,%eax
  104060:	83 d2 ff             	adc    $0xffffffff,%edx
  104063:	89 c6                	mov    %eax,%esi
  104065:	89 d7                	mov    %edx,%edi
  104067:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  10406a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10406d:	89 d0                	mov    %edx,%eax
  10406f:	c1 e0 02             	shl    $0x2,%eax
  104072:	01 d0                	add    %edx,%eax
  104074:	c1 e0 02             	shl    $0x2,%eax
  104077:	01 c8                	add    %ecx,%eax
  104079:	8b 48 0c             	mov    0xc(%eax),%ecx
  10407c:	8b 58 10             	mov    0x10(%eax),%ebx
  10407f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104085:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104089:	89 74 24 14          	mov    %esi,0x14(%esp)
  10408d:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104091:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104094:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104097:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10409b:	89 54 24 10          	mov    %edx,0x10(%esp)
  10409f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040a7:	c7 04 24 e8 6c 10 00 	movl   $0x106ce8,(%esp)
  1040ae:	e8 a3 c2 ff ff       	call   100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040b3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  1040b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040b9:	89 d0                	mov    %edx,%eax
  1040bb:	c1 e0 02             	shl    $0x2,%eax
  1040be:	01 d0                	add    %edx,%eax
  1040c0:	c1 e0 02             	shl    $0x2,%eax
  1040c3:	01 c8                	add    %ecx,%eax
  1040c5:	83 c0 14             	add    $0x14,%eax
  1040c8:	8b 00                	mov    (%eax),%eax
  1040ca:	83 f8 01             	cmp    $0x1,%eax
  1040cd:	75 2e                	jne    1040fd <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  1040cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040d5:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  1040d8:	89 d0                	mov    %edx,%eax
  1040da:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  1040dd:	73 1e                	jae    1040fd <page_init+0x142>
  1040df:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1040e4:	b8 00 00 00 00       	mov    $0x0,%eax
  1040e9:	3b 55 a8             	cmp    -0x58(%ebp),%edx
  1040ec:	1b 45 ac             	sbb    -0x54(%ebp),%eax
  1040ef:	72 0c                	jb     1040fd <page_init+0x142>
                maxpa = end;
  1040f1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040f4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++) {
  1040fd:	ff 45 dc             	incl   -0x24(%ebp)
  104100:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104103:	8b 00                	mov    (%eax),%eax
  104105:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104108:	0f 8c e6 fe ff ff    	jl     103ff4 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10410e:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104113:	b8 00 00 00 00       	mov    $0x0,%eax
  104118:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  10411b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  10411e:	73 0e                	jae    10412e <page_init+0x173>
        maxpa = KMEMSIZE;
  104120:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104127:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10412e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104131:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104134:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104138:	c1 ea 0c             	shr    $0xc,%edx
  10413b:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
    pages = (struct Page *) ROUNDUP((void *) end, PGSIZE);
  104140:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  104147:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  10414c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10414f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104152:	01 d0                	add    %edx,%eax
  104154:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104157:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10415a:	ba 00 00 00 00       	mov    $0x0,%edx
  10415f:	f7 75 c8             	divl   -0x38(%ebp)
  104162:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104165:	29 d0                	sub    %edx,%eax
  104167:	a3 a0 ce 11 00       	mov    %eax,0x11cea0

    for (i = 0; i < npage; i++) {
  10416c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104173:	eb 2f                	jmp    1041a4 <page_init+0x1e9>
        SetPageReserved(pages + i);
  104175:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  10417b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10417e:	89 d0                	mov    %edx,%eax
  104180:	c1 e0 02             	shl    $0x2,%eax
  104183:	01 d0                	add    %edx,%eax
  104185:	c1 e0 02             	shl    $0x2,%eax
  104188:	01 c8                	add    %ecx,%eax
  10418a:	83 c0 04             	add    $0x4,%eax
  10418d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
  104194:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104197:	8b 45 98             	mov    -0x68(%ebp),%eax
  10419a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10419d:	0f ab 10             	bts    %edx,(%eax)
}
  1041a0:	90                   	nop
    for (i = 0; i < npage; i++) {
  1041a1:	ff 45 dc             	incl   -0x24(%ebp)
  1041a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041a7:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1041ac:	39 c2                	cmp    %eax,%edx
  1041ae:	72 c5                	jb     104175 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t) pages + sizeof(struct Page) * npage);
  1041b0:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1041b6:	89 d0                	mov    %edx,%eax
  1041b8:	c1 e0 02             	shl    $0x2,%eax
  1041bb:	01 d0                	add    %edx,%eax
  1041bd:	c1 e0 02             	shl    $0x2,%eax
  1041c0:	89 c2                	mov    %eax,%edx
  1041c2:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  1041c7:	01 d0                	add    %edx,%eax
  1041c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1041cc:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
  1041d3:	77 23                	ja     1041f8 <page_init+0x23d>
  1041d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1041d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041dc:	c7 44 24 08 18 6d 10 	movl   $0x106d18,0x8(%esp)
  1041e3:	00 
  1041e4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1041eb:	00 
  1041ec:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1041f3:	e8 f0 ca ff ff       	call   100ce8 <__panic>
  1041f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1041fb:	05 00 00 00 40       	add    $0x40000000,%eax
  104200:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i++) {
  104203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10420a:	e9 85 01 00 00       	jmp    104394 <page_init+0x3d9>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10420f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104212:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104215:	89 d0                	mov    %edx,%eax
  104217:	c1 e0 02             	shl    $0x2,%eax
  10421a:	01 d0                	add    %edx,%eax
  10421c:	c1 e0 02             	shl    $0x2,%eax
  10421f:	01 c8                	add    %ecx,%eax
  104221:	8b 50 08             	mov    0x8(%eax),%edx
  104224:	8b 40 04             	mov    0x4(%eax),%eax
  104227:	89 45 90             	mov    %eax,-0x70(%ebp)
  10422a:	89 55 94             	mov    %edx,-0x6c(%ebp)
  10422d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104230:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104233:	89 d0                	mov    %edx,%eax
  104235:	c1 e0 02             	shl    $0x2,%eax
  104238:	01 d0                	add    %edx,%eax
  10423a:	c1 e0 02             	shl    $0x2,%eax
  10423d:	01 c8                	add    %ecx,%eax
  10423f:	8b 48 0c             	mov    0xc(%eax),%ecx
  104242:	8b 58 10             	mov    0x10(%eax),%ebx
  104245:	8b 45 90             	mov    -0x70(%ebp),%eax
  104248:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10424b:	01 c8                	add    %ecx,%eax
  10424d:	11 da                	adc    %ebx,%edx
  10424f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104252:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104255:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  104258:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10425b:	89 d0                	mov    %edx,%eax
  10425d:	c1 e0 02             	shl    $0x2,%eax
  104260:	01 d0                	add    %edx,%eax
  104262:	c1 e0 02             	shl    $0x2,%eax
  104265:	01 c8                	add    %ecx,%eax
  104267:	83 c0 14             	add    $0x14,%eax
  10426a:	8b 00                	mov    (%eax),%eax
  10426c:	83 f8 01             	cmp    $0x1,%eax
  10426f:	0f 85 1c 01 00 00    	jne    104391 <page_init+0x3d6>
            if (begin < freemem) {
  104275:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  104278:	bb 00 00 00 00       	mov    $0x0,%ebx
  10427d:	8b 45 90             	mov    -0x70(%ebp),%eax
  104280:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104283:	39 c8                	cmp    %ecx,%eax
  104285:	89 d0                	mov    %edx,%eax
  104287:	19 d8                	sbb    %ebx,%eax
  104289:	73 0e                	jae    104299 <page_init+0x2de>
                begin = freemem;
  10428b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10428e:	ba 00 00 00 00       	mov    $0x0,%edx
  104293:	89 45 90             	mov    %eax,-0x70(%ebp)
  104296:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
  104299:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10429e:	b8 00 00 00 00       	mov    $0x0,%eax
  1042a3:	3b 55 d0             	cmp    -0x30(%ebp),%edx
  1042a6:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  1042a9:	73 0e                	jae    1042b9 <page_init+0x2fe>
                end = KMEMSIZE;
  1042ab:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
  1042b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
  1042b9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1042bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1042bf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1042c2:	89 d0                	mov    %edx,%eax
  1042c4:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  1042c7:	0f 83 c4 00 00 00    	jae    104391 <page_init+0x3d6>
                begin = ROUNDUP(begin, PGSIZE);
  1042cd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  1042d4:	8b 45 90             	mov    -0x70(%ebp),%eax
  1042d7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1042da:	89 c2                	mov    %eax,%edx
  1042dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1042df:	01 d0                	add    %edx,%eax
  1042e1:	48                   	dec    %eax
  1042e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  1042e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042e8:	ba 00 00 00 00       	mov    $0x0,%edx
  1042ed:	f7 75 b8             	divl   -0x48(%ebp)
  1042f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042f3:	29 d0                	sub    %edx,%eax
  1042f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1042fa:	89 45 90             	mov    %eax,-0x70(%ebp)
  1042fd:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104303:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104309:	ba 00 00 00 00       	mov    $0x0,%edx
  10430e:	89 c7                	mov    %eax,%edi
  104310:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104316:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104319:	89 d0                	mov    %edx,%eax
  10431b:	83 e0 00             	and    $0x0,%eax
  10431e:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104321:	8b 45 80             	mov    -0x80(%ebp),%eax
  104324:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104327:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10432a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                if (begin < end) {
  10432d:	8b 45 90             	mov    -0x70(%ebp),%eax
  104330:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104333:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104336:	89 d0                	mov    %edx,%eax
  104338:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
  10433b:	73 54                	jae    104391 <page_init+0x3d6>

                    cprintf("memory: %08llx,%08llx\n", begin, &begin);
  10433d:	8b 45 90             	mov    -0x70(%ebp),%eax
  104340:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104343:	8d 4d 90             	lea    -0x70(%ebp),%ecx
  104346:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10434a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10434e:	89 54 24 08          	mov    %edx,0x8(%esp)
  104352:	c7 04 24 4a 6d 10 00 	movl   $0x106d4a,(%esp)
  104359:	e8 f8 bf ff ff       	call   100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10435e:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  104361:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
  104364:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104367:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10436a:	29 c8                	sub    %ecx,%eax
  10436c:	19 da                	sbb    %ebx,%edx
  10436e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104372:	c1 ea 0c             	shr    $0xc,%edx
  104375:	89 c3                	mov    %eax,%ebx
  104377:	8b 45 90             	mov    -0x70(%ebp),%eax
  10437a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10437d:	89 04 24             	mov    %eax,(%esp)
  104380:	e8 89 f8 ff ff       	call   103c0e <pa2page>
  104385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104389:	89 04 24             	mov    %eax,(%esp)
  10438c:	e8 6c fb ff ff       	call   103efd <init_memmap>
    for (i = 0; i < memmap->nr_map; i++) {
  104391:	ff 45 dc             	incl   -0x24(%ebp)
  104394:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104397:	8b 00                	mov    (%eax),%eax
  104399:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10439c:	0f 8c 6d fe ff ff    	jl     10420f <page_init+0x254>
                }
            }
        }
    }
}
  1043a2:	90                   	nop
  1043a3:	90                   	nop
  1043a4:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043aa:	5b                   	pop    %ebx
  1043ab:	5e                   	pop    %esi
  1043ac:	5f                   	pop    %edi
  1043ad:	5d                   	pop    %ebp
  1043ae:	c3                   	ret    

001043af <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043af:	55                   	push   %ebp
  1043b0:	89 e5                	mov    %esp,%ebp
  1043b2:	83 ec 38             	sub    $0x38,%esp
    cprintf("%08x",pgdir);
  1043b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043bc:	c7 04 24 61 6d 10 00 	movl   $0x106d61,(%esp)
  1043c3:	e8 8e bf ff ff       	call   100356 <cprintf>
    assert(PGOFF(la) == PGOFF(pa));
  1043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043cb:	33 45 14             	xor    0x14(%ebp),%eax
  1043ce:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043d3:	85 c0                	test   %eax,%eax
  1043d5:	74 24                	je     1043fb <boot_map_segment+0x4c>
  1043d7:	c7 44 24 0c 66 6d 10 	movl   $0x106d66,0xc(%esp)
  1043de:	00 
  1043df:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1043e6:	00 
  1043e7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1043ee:	00 
  1043ef:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1043f6:	e8 ed c8 ff ff       	call   100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104402:	8b 45 0c             	mov    0xc(%ebp),%eax
  104405:	25 ff 0f 00 00       	and    $0xfff,%eax
  10440a:	89 c2                	mov    %eax,%edx
  10440c:	8b 45 10             	mov    0x10(%ebp),%eax
  10440f:	01 c2                	add    %eax,%edx
  104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104414:	01 d0                	add    %edx,%eax
  104416:	48                   	dec    %eax
  104417:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10441a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441d:	ba 00 00 00 00       	mov    $0x0,%edx
  104422:	f7 75 f0             	divl   -0x10(%ebp)
  104425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104428:	29 d0                	sub    %edx,%eax
  10442a:	c1 e8 0c             	shr    $0xc,%eax
  10442d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104430:	8b 45 0c             	mov    0xc(%ebp),%eax
  104433:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104439:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10443e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104441:	8b 45 14             	mov    0x14(%ebp),%eax
  104444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10444a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10444f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
  104452:	eb 68                	jmp    1044bc <boot_map_segment+0x10d>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104454:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10445b:	00 
  10445c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10445f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104463:	8b 45 08             	mov    0x8(%ebp),%eax
  104466:	89 04 24             	mov    %eax,(%esp)
  104469:	e8 88 01 00 00       	call   1045f6 <get_pte>
  10446e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104471:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104475:	75 24                	jne    10449b <boot_map_segment+0xec>
  104477:	c7 44 24 0c 92 6d 10 	movl   $0x106d92,0xc(%esp)
  10447e:	00 
  10447f:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104486:	00 
  104487:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  10448e:	00 
  10448f:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104496:	e8 4d c8 ff ff       	call   100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
  10449b:	8b 45 14             	mov    0x14(%ebp),%eax
  10449e:	0b 45 18             	or     0x18(%ebp),%eax
  1044a1:	83 c8 01             	or     $0x1,%eax
  1044a4:	89 c2                	mov    %eax,%edx
  1044a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044a9:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
  1044ab:	ff 4d f4             	decl   -0xc(%ebp)
  1044ae:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044b5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044c0:	75 92                	jne    104454 <boot_map_segment+0xa5>
    }
}
  1044c2:	90                   	nop
  1044c3:	90                   	nop
  1044c4:	89 ec                	mov    %ebp,%esp
  1044c6:	5d                   	pop    %ebp
  1044c7:	c3                   	ret    

001044c8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044c8:	55                   	push   %ebp
  1044c9:	89 e5                	mov    %esp,%ebp
  1044cb:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044d5:	e8 45 fa ff ff       	call   103f1f <alloc_pages>
  1044da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044e1:	75 1c                	jne    1044ff <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044e3:	c7 44 24 08 9f 6d 10 	movl   $0x106d9f,0x8(%esp)
  1044ea:	00 
  1044eb:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1044f2:	00 
  1044f3:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1044fa:	e8 e9 c7 ff ff       	call   100ce8 <__panic>
    }
    return page2kva(p);
  1044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104502:	89 04 24             	mov    %eax,(%esp)
  104505:	e8 55 f7 ff ff       	call   103c5f <page2kva>
}
  10450a:	89 ec                	mov    %ebp,%esp
  10450c:	5d                   	pop    %ebp
  10450d:	c3                   	ret    

0010450e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10450e:	55                   	push   %ebp
  10450f:	89 e5                	mov    %esp,%ebp
  104511:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  104514:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10451c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104523:	77 23                	ja     104548 <pmm_init+0x3a>
  104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104528:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10452c:	c7 44 24 08 18 6d 10 	movl   $0x106d18,0x8(%esp)
  104533:	00 
  104534:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  10453b:	00 
  10453c:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104543:	e8 a0 c7 ff ff       	call   100ce8 <__panic>
  104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10454b:	05 00 00 00 40       	add    $0x40000000,%eax
  104550:	a3 a8 ce 11 00       	mov    %eax,0x11cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104555:	e8 6d f9 ff ff       	call   103ec7 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10455a:	e8 5c fa ff ff       	call   103fbb <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10455f:	e8 fe 03 00 00       	call   104962 <check_alloc_page>

    check_pgdir();
  104564:	e8 1a 04 00 00       	call   104983 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104569:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10456e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104571:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104578:	77 23                	ja     10459d <pmm_init+0x8f>
  10457a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10457d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104581:	c7 44 24 08 18 6d 10 	movl   $0x106d18,0x8(%esp)
  104588:	00 
  104589:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  104590:	00 
  104591:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104598:	e8 4b c7 ff ff       	call   100ce8 <__panic>
  10459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1045a6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1045ab:	05 ac 0f 00 00       	add    $0xfac,%eax
  1045b0:	83 ca 03             	or     $0x3,%edx
  1045b3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045b5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1045ba:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045c1:	00 
  1045c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045c9:	00 
  1045ca:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045d1:	38 
  1045d2:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045d9:	c0 
  1045da:	89 04 24             	mov    %eax,(%esp)
  1045dd:	e8 cd fd ff ff       	call   1043af <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045e2:	e8 f4 f7 ff ff       	call   103ddb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045e7:	e8 35 0a 00 00       	call   105021 <check_boot_pgdir>

    print_pgdir();
  1045ec:	e8 b2 0e 00 00       	call   1054a3 <print_pgdir>

}
  1045f1:	90                   	nop
  1045f2:	89 ec                	mov    %ebp,%esp
  1045f4:	5d                   	pop    %ebp
  1045f5:	c3                   	ret    

001045f6 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045f6:	55                   	push   %ebp
  1045f7:	89 e5                	mov    %esp,%ebp
  1045f9:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1045fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045ff:	c1 e8 16             	shr    $0x16,%eax
  104602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104609:	8b 45 08             	mov    0x8(%ebp),%eax
  10460c:	01 d0                	add    %edx,%eax
  10460e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t pa1, la2;

    if (!(*pdep & PTE_P)) {
  104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104614:	8b 00                	mov    (%eax),%eax
  104616:	83 e0 01             	and    $0x1,%eax
  104619:	85 c0                	test   %eax,%eax
  10461b:	0f 85 b9 00 00 00    	jne    1046da <get_pte+0xe4>
        struct Page *page;
        if (!create) {
  104621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104625:	75 0a                	jne    104631 <get_pte+0x3b>
            return NULL;
  104627:	b8 00 00 00 00       	mov    $0x0,%eax
  10462c:	e9 08 01 00 00       	jmp    104739 <get_pte+0x143>
        } else {
            page = alloc_page();
  104631:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104638:	e8 e2 f8 ff ff       	call   103f1f <alloc_pages>
  10463d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if (page == NULL) return;
  104640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104644:	0f 84 ef 00 00 00    	je     104739 <get_pte+0x143>
            set_page_ref(page, 1);
  10464a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104651:	00 
  104652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104655:	89 04 24             	mov    %eax,(%esp)
  104658:	e8 bc f6 ff ff       	call   103d19 <set_page_ref>
            pa1 = page2pa(page);
  10465d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104660:	89 04 24             	mov    %eax,(%esp)
  104663:	e8 8e f5 ff ff       	call   103bf6 <page2pa>
  104668:	89 45 ec             	mov    %eax,-0x14(%ebp)
            la2 = KADDR(pa1);
  10466b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10466e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104674:	c1 e8 0c             	shr    $0xc,%eax
  104677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10467a:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  10467f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104682:	72 23                	jb     1046a7 <get_pte+0xb1>
  104684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104687:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10468b:	c7 44 24 08 74 6c 10 	movl   $0x106c74,0x8(%esp)
  104692:	00 
  104693:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  10469a:	00 
  10469b:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1046a2:	e8 41 c6 ff ff       	call   100ce8 <__panic>
  1046a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046af:	89 45 e0             	mov    %eax,-0x20(%ebp)
            memset(la2, 0, PGSIZE);
  1046b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1046bc:	00 
  1046bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046c4:	00 
  1046c5:	89 04 24             	mov    %eax,(%esp)
  1046c8:	e8 db 18 00 00       	call   105fa8 <memset>
            //set permission
            //这里为何要用物理地址？可能这个机制是物理寻址
//            *pdep = la2 | PTE_P | PTE_U | PTE_W;
            *pdep = pa1 | PTE_P | PTE_U | PTE_W;
  1046cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046d0:	83 c8 07             	or     $0x7,%eax
  1046d3:	89 c2                	mov    %eax,%edx
  1046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d8:	89 10                	mov    %edx,(%eax)
        }
    }
//    PTE_ADDR(pte)
//    &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
    return &((pte_t *) KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046dd:	8b 00                	mov    (%eax),%eax
  1046df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1046e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046ea:	c1 e8 0c             	shr    $0xc,%eax
  1046ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1046f0:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1046f5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1046f8:	72 23                	jb     10471d <get_pte+0x127>
  1046fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104701:	c7 44 24 08 74 6c 10 	movl   $0x106c74,0x8(%esp)
  104708:	00 
  104709:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
  104710:	00 
  104711:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104718:	e8 cb c5 ff ff       	call   100ce8 <__panic>
  10471d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104720:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104725:	89 c2                	mov    %eax,%edx
  104727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10472a:	c1 e8 0c             	shr    $0xc,%eax
  10472d:	25 ff 03 00 00       	and    $0x3ff,%eax
  104732:	c1 e0 02             	shl    $0x2,%eax
  104735:	01 d0                	add    %edx,%eax
  104737:	eb 00                	jmp    104739 <get_pte+0x143>
//        // 之后该页面就是其中的一个二级页面
//        *pdep = pa | PTE_U | PTE_W | PTE_P;
//    }
//    // 返回在pgdir中对应于la的二级页表项
//    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
  104739:	89 ec                	mov    %ebp,%esp
  10473b:	5d                   	pop    %ebp
  10473c:	c3                   	ret    

0010473d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10473d:	55                   	push   %ebp
  10473e:	89 e5                	mov    %esp,%ebp
  104740:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104743:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10474a:	00 
  10474b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10474e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104752:	8b 45 08             	mov    0x8(%ebp),%eax
  104755:	89 04 24             	mov    %eax,(%esp)
  104758:	e8 99 fe ff ff       	call   1045f6 <get_pte>
  10475d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104760:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104764:	74 08                	je     10476e <get_page+0x31>
        *ptep_store = ptep;
  104766:	8b 45 10             	mov    0x10(%ebp),%eax
  104769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10476c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10476e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104772:	74 1b                	je     10478f <get_page+0x52>
  104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104777:	8b 00                	mov    (%eax),%eax
  104779:	83 e0 01             	and    $0x1,%eax
  10477c:	85 c0                	test   %eax,%eax
  10477e:	74 0f                	je     10478f <get_page+0x52>
        return pte2page(*ptep);
  104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104783:	8b 00                	mov    (%eax),%eax
  104785:	89 04 24             	mov    %eax,(%esp)
  104788:	e8 28 f5 ff ff       	call   103cb5 <pte2page>
  10478d:	eb 05                	jmp    104794 <get_page+0x57>
    }
    return NULL;
  10478f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104794:	89 ec                	mov    %ebp,%esp
  104796:	5d                   	pop    %ebp
  104797:	c3                   	ret    

00104798 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104798:	55                   	push   %ebp
  104799:	89 e5                	mov    %esp,%ebp
  10479b:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P){
  10479e:	8b 45 10             	mov    0x10(%ebp),%eax
  1047a1:	8b 00                	mov    (%eax),%eax
  1047a3:	83 e0 01             	and    $0x1,%eax
  1047a6:	85 c0                	test   %eax,%eax
  1047a8:	74 52                	je     1047fc <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
  1047aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1047ad:	8b 00                	mov    (%eax),%eax
  1047af:	89 04 24             	mov    %eax,(%esp)
  1047b2:	e8 fe f4 ff ff       	call   103cb5 <pte2page>
  1047b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
  1047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bd:	89 04 24             	mov    %eax,(%esp)
  1047c0:	e8 79 f5 ff ff       	call   103d3e <page_ref_dec>
    if (page->ref == 0) {
  1047c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c8:	8b 00                	mov    (%eax),%eax
  1047ca:	85 c0                	test   %eax,%eax
  1047cc:	75 13                	jne    1047e1 <page_remove_pte+0x49>
        free_page(page);
  1047ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047d5:	00 
  1047d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d9:	89 04 24             	mov    %eax,(%esp)
  1047dc:	e8 78 f7 ff ff       	call   103f59 <free_pages>
    }
    *ptep=0;
  1047e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1047e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);
  1047ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f4:	89 04 24             	mov    %eax,(%esp)
  1047f7:	e8 07 01 00 00       	call   104903 <tlb_invalidate>
    }

}
  1047fc:	90                   	nop
  1047fd:	89 ec                	mov    %ebp,%esp
  1047ff:	5d                   	pop    %ebp
  104800:	c3                   	ret    

00104801 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104801:	55                   	push   %ebp
  104802:	89 e5                	mov    %esp,%ebp
  104804:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104807:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10480e:	00 
  10480f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104812:	89 44 24 04          	mov    %eax,0x4(%esp)
  104816:	8b 45 08             	mov    0x8(%ebp),%eax
  104819:	89 04 24             	mov    %eax,(%esp)
  10481c:	e8 d5 fd ff ff       	call   1045f6 <get_pte>
  104821:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104828:	74 19                	je     104843 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10482d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104831:	8b 45 0c             	mov    0xc(%ebp),%eax
  104834:	89 44 24 04          	mov    %eax,0x4(%esp)
  104838:	8b 45 08             	mov    0x8(%ebp),%eax
  10483b:	89 04 24             	mov    %eax,(%esp)
  10483e:	e8 55 ff ff ff       	call   104798 <page_remove_pte>
    }
}
  104843:	90                   	nop
  104844:	89 ec                	mov    %ebp,%esp
  104846:	5d                   	pop    %ebp
  104847:	c3                   	ret    

00104848 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104848:	55                   	push   %ebp
  104849:	89 e5                	mov    %esp,%ebp
  10484b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10484e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104855:	00 
  104856:	8b 45 10             	mov    0x10(%ebp),%eax
  104859:	89 44 24 04          	mov    %eax,0x4(%esp)
  10485d:	8b 45 08             	mov    0x8(%ebp),%eax
  104860:	89 04 24             	mov    %eax,(%esp)
  104863:	e8 8e fd ff ff       	call   1045f6 <get_pte>
  104868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10486b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10486f:	75 0a                	jne    10487b <page_insert+0x33>
        return -E_NO_MEM;
  104871:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104876:	e9 84 00 00 00       	jmp    1048ff <page_insert+0xb7>
    }
    page_ref_inc(page);
  10487b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10487e:	89 04 24             	mov    %eax,(%esp)
  104881:	e8 a1 f4 ff ff       	call   103d27 <page_ref_inc>
    if (*ptep & PTE_P) {
  104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104889:	8b 00                	mov    (%eax),%eax
  10488b:	83 e0 01             	and    $0x1,%eax
  10488e:	85 c0                	test   %eax,%eax
  104890:	74 3e                	je     1048d0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104895:	8b 00                	mov    (%eax),%eax
  104897:	89 04 24             	mov    %eax,(%esp)
  10489a:	e8 16 f4 ff ff       	call   103cb5 <pte2page>
  10489f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1048a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1048a8:	75 0d                	jne    1048b7 <page_insert+0x6f>
            page_ref_dec(page);
  1048aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048ad:	89 04 24             	mov    %eax,(%esp)
  1048b0:	e8 89 f4 ff ff       	call   103d3e <page_ref_dec>
  1048b5:	eb 19                	jmp    1048d0 <page_insert+0x88>
        } else {
            page_remove_pte(pgdir, la, ptep);
  1048b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  1048be:	8b 45 10             	mov    0x10(%ebp),%eax
  1048c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c8:	89 04 24             	mov    %eax,(%esp)
  1048cb:	e8 c8 fe ff ff       	call   104798 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1048d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048d3:	89 04 24             	mov    %eax,(%esp)
  1048d6:	e8 1b f3 ff ff       	call   103bf6 <page2pa>
  1048db:	0b 45 14             	or     0x14(%ebp),%eax
  1048de:	83 c8 01             	or     $0x1,%eax
  1048e1:	89 c2                	mov    %eax,%edx
  1048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1048e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1048eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f2:	89 04 24             	mov    %eax,(%esp)
  1048f5:	e8 09 00 00 00       	call   104903 <tlb_invalidate>
    return 0;
  1048fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048ff:	89 ec                	mov    %ebp,%esp
  104901:	5d                   	pop    %ebp
  104902:	c3                   	ret    

00104903 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104903:	55                   	push   %ebp
  104904:	89 e5                	mov    %esp,%ebp
  104906:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104909:	0f 20 d8             	mov    %cr3,%eax
  10490c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10490f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  104912:	8b 45 08             	mov    0x8(%ebp),%eax
  104915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104918:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10491f:	77 23                	ja     104944 <tlb_invalidate+0x41>
  104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104924:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104928:	c7 44 24 08 18 6d 10 	movl   $0x106d18,0x8(%esp)
  10492f:	00 
  104930:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104937:	00 
  104938:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10493f:	e8 a4 c3 ff ff       	call   100ce8 <__panic>
  104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104947:	05 00 00 00 40       	add    $0x40000000,%eax
  10494c:	39 d0                	cmp    %edx,%eax
  10494e:	75 0d                	jne    10495d <tlb_invalidate+0x5a>
        invlpg((void *) la);
  104950:	8b 45 0c             	mov    0xc(%ebp),%eax
  104953:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104959:	0f 01 38             	invlpg (%eax)
}
  10495c:	90                   	nop
    }
}
  10495d:	90                   	nop
  10495e:	89 ec                	mov    %ebp,%esp
  104960:	5d                   	pop    %ebp
  104961:	c3                   	ret    

00104962 <check_alloc_page>:

static void
check_alloc_page(void) {
  104962:	55                   	push   %ebp
  104963:	89 e5                	mov    %esp,%ebp
  104965:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104968:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  10496d:	8b 40 18             	mov    0x18(%eax),%eax
  104970:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104972:	c7 04 24 b8 6d 10 00 	movl   $0x106db8,(%esp)
  104979:	e8 d8 b9 ff ff       	call   100356 <cprintf>
}
  10497e:	90                   	nop
  10497f:	89 ec                	mov    %ebp,%esp
  104981:	5d                   	pop    %ebp
  104982:	c3                   	ret    

00104983 <check_pgdir>:

static void
check_pgdir(void) {
  104983:	55                   	push   %ebp
  104984:	89 e5                	mov    %esp,%ebp
  104986:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104989:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  10498e:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104993:	76 24                	jbe    1049b9 <check_pgdir+0x36>
  104995:	c7 44 24 0c d7 6d 10 	movl   $0x106dd7,0xc(%esp)
  10499c:	00 
  10499d:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1049a4:	00 
  1049a5:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  1049ac:	00 
  1049ad:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1049b4:	e8 2f c3 ff ff       	call   100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t) PGOFF(boot_pgdir) == 0);
  1049b9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049be:	85 c0                	test   %eax,%eax
  1049c0:	74 0e                	je     1049d0 <check_pgdir+0x4d>
  1049c2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049c7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1049cc:	85 c0                	test   %eax,%eax
  1049ce:	74 24                	je     1049f4 <check_pgdir+0x71>
  1049d0:	c7 44 24 0c f4 6d 10 	movl   $0x106df4,0xc(%esp)
  1049d7:	00 
  1049d8:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1049df:	00 
  1049e0:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  1049e7:	00 
  1049e8:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1049ef:	e8 f4 c2 ff ff       	call   100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1049f4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a00:	00 
  104a01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a08:	00 
  104a09:	89 04 24             	mov    %eax,(%esp)
  104a0c:	e8 2c fd ff ff       	call   10473d <get_page>
  104a11:	85 c0                	test   %eax,%eax
  104a13:	74 24                	je     104a39 <check_pgdir+0xb6>
  104a15:	c7 44 24 0c 2c 6e 10 	movl   $0x106e2c,0xc(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104a24:	00 
  104a25:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104a2c:	00 
  104a2d:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104a34:	e8 af c2 ff ff       	call   100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a40:	e8 da f4 ff ff       	call   103f1f <alloc_pages>
  104a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a48:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a4d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a54:	00 
  104a55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a5c:	00 
  104a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a60:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a64:	89 04 24             	mov    %eax,(%esp)
  104a67:	e8 dc fd ff ff       	call   104848 <page_insert>
  104a6c:	85 c0                	test   %eax,%eax
  104a6e:	74 24                	je     104a94 <check_pgdir+0x111>
  104a70:	c7 44 24 0c 54 6e 10 	movl   $0x106e54,0xc(%esp)
  104a77:	00 
  104a78:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104a7f:	00 
  104a80:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104a87:	00 
  104a88:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104a8f:	e8 54 c2 ff ff       	call   100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104a94:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aa0:	00 
  104aa1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104aa8:	00 
  104aa9:	89 04 24             	mov    %eax,(%esp)
  104aac:	e8 45 fb ff ff       	call   1045f6 <get_pte>
  104ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ab4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ab8:	75 24                	jne    104ade <check_pgdir+0x15b>
  104aba:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104ac1:	00 
  104ac2:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104ac9:	00 
  104aca:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104ad1:	00 
  104ad2:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104ad9:	e8 0a c2 ff ff       	call   100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
  104ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ae1:	8b 00                	mov    (%eax),%eax
  104ae3:	89 04 24             	mov    %eax,(%esp)
  104ae6:	e8 ca f1 ff ff       	call   103cb5 <pte2page>
  104aeb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104aee:	74 24                	je     104b14 <check_pgdir+0x191>
  104af0:	c7 44 24 0c ad 6e 10 	movl   $0x106ead,0xc(%esp)
  104af7:	00 
  104af8:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104aff:	00 
  104b00:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104b07:	00 
  104b08:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104b0f:	e8 d4 c1 ff ff       	call   100ce8 <__panic>
    assert(page_ref(p1) == 1);
  104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b17:	89 04 24             	mov    %eax,(%esp)
  104b1a:	e8 f0 f1 ff ff       	call   103d0f <page_ref>
  104b1f:	83 f8 01             	cmp    $0x1,%eax
  104b22:	74 24                	je     104b48 <check_pgdir+0x1c5>
  104b24:	c7 44 24 0c c3 6e 10 	movl   $0x106ec3,0xc(%esp)
  104b2b:	00 
  104b2c:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104b33:	00 
  104b34:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b3b:	00 
  104b3c:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104b43:	e8 a0 c1 ff ff       	call   100ce8 <__panic>

    ptep = &((pte_t *) KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b48:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b4d:	8b 00                	mov    (%eax),%eax
  104b4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b5a:	c1 e8 0c             	shr    $0xc,%eax
  104b5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b60:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104b65:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b68:	72 23                	jb     104b8d <check_pgdir+0x20a>
  104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b71:	c7 44 24 08 74 6c 10 	movl   $0x106c74,0x8(%esp)
  104b78:	00 
  104b79:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104b80:	00 
  104b81:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104b88:	e8 5b c1 ff ff       	call   100ce8 <__panic>
  104b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b90:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b95:	83 c0 04             	add    $0x4,%eax
  104b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104b9b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ba0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ba7:	00 
  104ba8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104baf:	00 
  104bb0:	89 04 24             	mov    %eax,(%esp)
  104bb3:	e8 3e fa ff ff       	call   1045f6 <get_pte>
  104bb8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104bbb:	74 24                	je     104be1 <check_pgdir+0x25e>
  104bbd:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104bc4:	00 
  104bc5:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104bcc:	00 
  104bcd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104bd4:	00 
  104bd5:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104bdc:	e8 07 c1 ff ff       	call   100ce8 <__panic>

    p2 = alloc_page();
  104be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104be8:	e8 32 f3 ff ff       	call   103f1f <alloc_pages>
  104bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104bf0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104bf5:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c04:	00 
  104c05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c08:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c0c:	89 04 24             	mov    %eax,(%esp)
  104c0f:	e8 34 fc ff ff       	call   104848 <page_insert>
  104c14:	85 c0                	test   %eax,%eax
  104c16:	74 24                	je     104c3c <check_pgdir+0x2b9>
  104c18:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104c1f:	00 
  104c20:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104c27:	00 
  104c28:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104c2f:	00 
  104c30:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104c37:	e8 ac c0 ff ff       	call   100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c3c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104c41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c48:	00 
  104c49:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c50:	00 
  104c51:	89 04 24             	mov    %eax,(%esp)
  104c54:	e8 9d f9 ff ff       	call   1045f6 <get_pte>
  104c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c60:	75 24                	jne    104c86 <check_pgdir+0x303>
  104c62:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104c69:	00 
  104c6a:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104c71:	00 
  104c72:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104c79:	00 
  104c7a:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104c81:	e8 62 c0 ff ff       	call   100ce8 <__panic>
    assert(*ptep & PTE_U);
  104c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c89:	8b 00                	mov    (%eax),%eax
  104c8b:	83 e0 04             	and    $0x4,%eax
  104c8e:	85 c0                	test   %eax,%eax
  104c90:	75 24                	jne    104cb6 <check_pgdir+0x333>
  104c92:	c7 44 24 0c 68 6f 10 	movl   $0x106f68,0xc(%esp)
  104c99:	00 
  104c9a:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104ca1:	00 
  104ca2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104ca9:	00 
  104caa:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104cb1:	e8 32 c0 ff ff       	call   100ce8 <__panic>
    assert(*ptep & PTE_W);
  104cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cb9:	8b 00                	mov    (%eax),%eax
  104cbb:	83 e0 02             	and    $0x2,%eax
  104cbe:	85 c0                	test   %eax,%eax
  104cc0:	75 24                	jne    104ce6 <check_pgdir+0x363>
  104cc2:	c7 44 24 0c 76 6f 10 	movl   $0x106f76,0xc(%esp)
  104cc9:	00 
  104cca:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104cd1:	00 
  104cd2:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104cd9:	00 
  104cda:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104ce1:	e8 02 c0 ff ff       	call   100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ce6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ceb:	8b 00                	mov    (%eax),%eax
  104ced:	83 e0 04             	and    $0x4,%eax
  104cf0:	85 c0                	test   %eax,%eax
  104cf2:	75 24                	jne    104d18 <check_pgdir+0x395>
  104cf4:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  104cfb:	00 
  104cfc:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104d03:	00 
  104d04:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104d0b:	00 
  104d0c:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104d13:	e8 d0 bf ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 1);
  104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d1b:	89 04 24             	mov    %eax,(%esp)
  104d1e:	e8 ec ef ff ff       	call   103d0f <page_ref>
  104d23:	83 f8 01             	cmp    $0x1,%eax
  104d26:	74 24                	je     104d4c <check_pgdir+0x3c9>
  104d28:	c7 44 24 0c 9a 6f 10 	movl   $0x106f9a,0xc(%esp)
  104d2f:	00 
  104d30:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104d37:	00 
  104d38:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d3f:	00 
  104d40:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104d47:	e8 9c bf ff ff       	call   100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d4c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104d51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d58:	00 
  104d59:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d60:	00 
  104d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d64:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d68:	89 04 24             	mov    %eax,(%esp)
  104d6b:	e8 d8 fa ff ff       	call   104848 <page_insert>
  104d70:	85 c0                	test   %eax,%eax
  104d72:	74 24                	je     104d98 <check_pgdir+0x415>
  104d74:	c7 44 24 0c ac 6f 10 	movl   $0x106fac,0xc(%esp)
  104d7b:	00 
  104d7c:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104d83:	00 
  104d84:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104d8b:	00 
  104d8c:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104d93:	e8 50 bf ff ff       	call   100ce8 <__panic>
    assert(page_ref(p1) == 2);
  104d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d9b:	89 04 24             	mov    %eax,(%esp)
  104d9e:	e8 6c ef ff ff       	call   103d0f <page_ref>
  104da3:	83 f8 02             	cmp    $0x2,%eax
  104da6:	74 24                	je     104dcc <check_pgdir+0x449>
  104da8:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  104daf:	00 
  104db0:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104db7:	00 
  104db8:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104dbf:	00 
  104dc0:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104dc7:	e8 1c bf ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dcf:	89 04 24             	mov    %eax,(%esp)
  104dd2:	e8 38 ef ff ff       	call   103d0f <page_ref>
  104dd7:	85 c0                	test   %eax,%eax
  104dd9:	74 24                	je     104dff <check_pgdir+0x47c>
  104ddb:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104de2:	00 
  104de3:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104dea:	00 
  104deb:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104df2:	00 
  104df3:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104dfa:	e8 e9 be ff ff       	call   100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104dff:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104e04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e0b:	00 
  104e0c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e13:	00 
  104e14:	89 04 24             	mov    %eax,(%esp)
  104e17:	e8 da f7 ff ff       	call   1045f6 <get_pte>
  104e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e23:	75 24                	jne    104e49 <check_pgdir+0x4c6>
  104e25:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104e2c:	00 
  104e2d:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104e34:	00 
  104e35:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104e3c:	00 
  104e3d:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104e44:	e8 9f be ff ff       	call   100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
  104e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e4c:	8b 00                	mov    (%eax),%eax
  104e4e:	89 04 24             	mov    %eax,(%esp)
  104e51:	e8 5f ee ff ff       	call   103cb5 <pte2page>
  104e56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104e59:	74 24                	je     104e7f <check_pgdir+0x4fc>
  104e5b:	c7 44 24 0c ad 6e 10 	movl   $0x106ead,0xc(%esp)
  104e62:	00 
  104e63:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104e6a:	00 
  104e6b:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104e72:	00 
  104e73:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104e7a:	e8 69 be ff ff       	call   100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
  104e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e82:	8b 00                	mov    (%eax),%eax
  104e84:	83 e0 04             	and    $0x4,%eax
  104e87:	85 c0                	test   %eax,%eax
  104e89:	74 24                	je     104eaf <check_pgdir+0x52c>
  104e8b:	c7 44 24 0c fc 6f 10 	movl   $0x106ffc,0xc(%esp)
  104e92:	00 
  104e93:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104e9a:	00 
  104e9b:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104ea2:	00 
  104ea3:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104eaa:	e8 39 be ff ff       	call   100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
  104eaf:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104eb4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ebb:	00 
  104ebc:	89 04 24             	mov    %eax,(%esp)
  104ebf:	e8 3d f9 ff ff       	call   104801 <page_remove>
    assert(page_ref(p1) == 1);
  104ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ec7:	89 04 24             	mov    %eax,(%esp)
  104eca:	e8 40 ee ff ff       	call   103d0f <page_ref>
  104ecf:	83 f8 01             	cmp    $0x1,%eax
  104ed2:	74 24                	je     104ef8 <check_pgdir+0x575>
  104ed4:	c7 44 24 0c c3 6e 10 	movl   $0x106ec3,0xc(%esp)
  104edb:	00 
  104edc:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104ee3:	00 
  104ee4:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104eeb:	00 
  104eec:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104ef3:	e8 f0 bd ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104efb:	89 04 24             	mov    %eax,(%esp)
  104efe:	e8 0c ee ff ff       	call   103d0f <page_ref>
  104f03:	85 c0                	test   %eax,%eax
  104f05:	74 24                	je     104f2b <check_pgdir+0x5a8>
  104f07:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104f0e:	00 
  104f0f:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104f16:	00 
  104f17:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104f1e:	00 
  104f1f:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104f26:	e8 bd bd ff ff       	call   100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104f2b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104f30:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f37:	00 
  104f38:	89 04 24             	mov    %eax,(%esp)
  104f3b:	e8 c1 f8 ff ff       	call   104801 <page_remove>
    assert(page_ref(p1) == 0);
  104f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f43:	89 04 24             	mov    %eax,(%esp)
  104f46:	e8 c4 ed ff ff       	call   103d0f <page_ref>
  104f4b:	85 c0                	test   %eax,%eax
  104f4d:	74 24                	je     104f73 <check_pgdir+0x5f0>
  104f4f:	c7 44 24 0c 11 70 10 	movl   $0x107011,0xc(%esp)
  104f56:	00 
  104f57:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104f5e:	00 
  104f5f:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  104f66:	00 
  104f67:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104f6e:	e8 75 bd ff ff       	call   100ce8 <__panic>
    assert(page_ref(p2) == 0);
  104f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f76:	89 04 24             	mov    %eax,(%esp)
  104f79:	e8 91 ed ff ff       	call   103d0f <page_ref>
  104f7e:	85 c0                	test   %eax,%eax
  104f80:	74 24                	je     104fa6 <check_pgdir+0x623>
  104f82:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104f89:	00 
  104f8a:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104f91:	00 
  104f92:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104f99:	00 
  104f9a:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104fa1:	e8 42 bd ff ff       	call   100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104fa6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fab:	8b 00                	mov    (%eax),%eax
  104fad:	89 04 24             	mov    %eax,(%esp)
  104fb0:	e8 40 ed ff ff       	call   103cf5 <pde2page>
  104fb5:	89 04 24             	mov    %eax,(%esp)
  104fb8:	e8 52 ed ff ff       	call   103d0f <page_ref>
  104fbd:	83 f8 01             	cmp    $0x1,%eax
  104fc0:	74 24                	je     104fe6 <check_pgdir+0x663>
  104fc2:	c7 44 24 0c 24 70 10 	movl   $0x107024,0xc(%esp)
  104fc9:	00 
  104fca:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  104fd1:	00 
  104fd2:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104fd9:	00 
  104fda:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  104fe1:	e8 02 bd ff ff       	call   100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104fe6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104feb:	8b 00                	mov    (%eax),%eax
  104fed:	89 04 24             	mov    %eax,(%esp)
  104ff0:	e8 00 ed ff ff       	call   103cf5 <pde2page>
  104ff5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ffc:	00 
  104ffd:	89 04 24             	mov    %eax,(%esp)
  105000:	e8 54 ef ff ff       	call   103f59 <free_pages>
    boot_pgdir[0] = 0;
  105005:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10500a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105010:	c7 04 24 4b 70 10 00 	movl   $0x10704b,(%esp)
  105017:	e8 3a b3 ff ff       	call   100356 <cprintf>
}
  10501c:	90                   	nop
  10501d:	89 ec                	mov    %ebp,%esp
  10501f:	5d                   	pop    %ebp
  105020:	c3                   	ret    

00105021 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105021:	55                   	push   %ebp
  105022:	89 e5                	mov    %esp,%ebp
  105024:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10502e:	e9 ca 00 00 00       	jmp    1050fd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t) KADDR(i), 0)) != NULL);
  105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10503c:	c1 e8 0c             	shr    $0xc,%eax
  10503f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105042:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  105047:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10504a:	72 23                	jb     10506f <check_boot_pgdir+0x4e>
  10504c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10504f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105053:	c7 44 24 08 74 6c 10 	movl   $0x106c74,0x8(%esp)
  10505a:	00 
  10505b:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105062:	00 
  105063:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10506a:	e8 79 bc ff ff       	call   100ce8 <__panic>
  10506f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105072:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105077:	89 c2                	mov    %eax,%edx
  105079:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10507e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105085:	00 
  105086:	89 54 24 04          	mov    %edx,0x4(%esp)
  10508a:	89 04 24             	mov    %eax,(%esp)
  10508d:	e8 64 f5 ff ff       	call   1045f6 <get_pte>
  105092:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105095:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105099:	75 24                	jne    1050bf <check_boot_pgdir+0x9e>
  10509b:	c7 44 24 0c 68 70 10 	movl   $0x107068,0xc(%esp)
  1050a2:	00 
  1050a3:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1050aa:	00 
  1050ab:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1050b2:	00 
  1050b3:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1050ba:	e8 29 bc ff ff       	call   100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1050bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050c2:	8b 00                	mov    (%eax),%eax
  1050c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050c9:	89 c2                	mov    %eax,%edx
  1050cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050ce:	39 c2                	cmp    %eax,%edx
  1050d0:	74 24                	je     1050f6 <check_boot_pgdir+0xd5>
  1050d2:	c7 44 24 0c a6 70 10 	movl   $0x1070a6,0xc(%esp)
  1050d9:	00 
  1050da:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1050e1:	00 
  1050e2:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1050e9:	00 
  1050ea:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1050f1:	e8 f2 bb ff ff       	call   100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1050f6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1050fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105100:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  105105:	39 c2                	cmp    %eax,%edx
  105107:	0f 82 26 ff ff ff    	jb     105033 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10510d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105112:	05 ac 0f 00 00       	add    $0xfac,%eax
  105117:	8b 00                	mov    (%eax),%eax
  105119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10511e:	89 c2                	mov    %eax,%edx
  105120:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105128:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10512f:	77 23                	ja     105154 <check_boot_pgdir+0x133>
  105131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105134:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105138:	c7 44 24 08 18 6d 10 	movl   $0x106d18,0x8(%esp)
  10513f:	00 
  105140:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  105147:	00 
  105148:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10514f:	e8 94 bb ff ff       	call   100ce8 <__panic>
  105154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105157:	05 00 00 00 40       	add    $0x40000000,%eax
  10515c:	39 d0                	cmp    %edx,%eax
  10515e:	74 24                	je     105184 <check_boot_pgdir+0x163>
  105160:	c7 44 24 0c bc 70 10 	movl   $0x1070bc,0xc(%esp)
  105167:	00 
  105168:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  10516f:	00 
  105170:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  105177:	00 
  105178:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10517f:	e8 64 bb ff ff       	call   100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
  105184:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105189:	8b 00                	mov    (%eax),%eax
  10518b:	85 c0                	test   %eax,%eax
  10518d:	74 24                	je     1051b3 <check_boot_pgdir+0x192>
  10518f:	c7 44 24 0c f0 70 10 	movl   $0x1070f0,0xc(%esp)
  105196:	00 
  105197:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  10519e:	00 
  10519f:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  1051a6:	00 
  1051a7:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1051ae:	e8 35 bb ff ff       	call   100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
  1051b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051ba:	e8 60 ed ff ff       	call   103f1f <alloc_pages>
  1051bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1051c2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1051c7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1051ce:	00 
  1051cf:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1051d6:	00 
  1051d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1051da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051de:	89 04 24             	mov    %eax,(%esp)
  1051e1:	e8 62 f6 ff ff       	call   104848 <page_insert>
  1051e6:	85 c0                	test   %eax,%eax
  1051e8:	74 24                	je     10520e <check_boot_pgdir+0x1ed>
  1051ea:	c7 44 24 0c 04 71 10 	movl   $0x107104,0xc(%esp)
  1051f1:	00 
  1051f2:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1051f9:	00 
  1051fa:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105201:	00 
  105202:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  105209:	e8 da ba ff ff       	call   100ce8 <__panic>
    assert(page_ref(p) == 1);
  10520e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105211:	89 04 24             	mov    %eax,(%esp)
  105214:	e8 f6 ea ff ff       	call   103d0f <page_ref>
  105219:	83 f8 01             	cmp    $0x1,%eax
  10521c:	74 24                	je     105242 <check_boot_pgdir+0x221>
  10521e:	c7 44 24 0c 32 71 10 	movl   $0x107132,0xc(%esp)
  105225:	00 
  105226:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  10522d:	00 
  10522e:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
  105235:	00 
  105236:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10523d:	e8 a6 ba ff ff       	call   100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105242:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105247:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10524e:	00 
  10524f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105256:	00 
  105257:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10525a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10525e:	89 04 24             	mov    %eax,(%esp)
  105261:	e8 e2 f5 ff ff       	call   104848 <page_insert>
  105266:	85 c0                	test   %eax,%eax
  105268:	74 24                	je     10528e <check_boot_pgdir+0x26d>
  10526a:	c7 44 24 0c 44 71 10 	movl   $0x107144,0xc(%esp)
  105271:	00 
  105272:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  105279:	00 
  10527a:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
  105281:	00 
  105282:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  105289:	e8 5a ba ff ff       	call   100ce8 <__panic>
    assert(page_ref(p) == 2);
  10528e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105291:	89 04 24             	mov    %eax,(%esp)
  105294:	e8 76 ea ff ff       	call   103d0f <page_ref>
  105299:	83 f8 02             	cmp    $0x2,%eax
  10529c:	74 24                	je     1052c2 <check_boot_pgdir+0x2a1>
  10529e:	c7 44 24 0c 7b 71 10 	movl   $0x10717b,0xc(%esp)
  1052a5:	00 
  1052a6:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  1052ad:	00 
  1052ae:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
  1052b5:	00 
  1052b6:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1052bd:	e8 26 ba ff ff       	call   100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
  1052c2:	c7 45 e8 8c 71 10 00 	movl   $0x10718c,-0x18(%ebp)
    strcpy((void *) 0x100, str);
  1052c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052d0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052d7:	e8 fc 09 00 00       	call   105cd8 <strcpy>
    assert(strcmp((void *) 0x100, (void *) (0x100 + PGSIZE)) == 0);
  1052dc:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1052e3:	00 
  1052e4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052eb:	e8 60 0a 00 00       	call   105d50 <strcmp>
  1052f0:	85 c0                	test   %eax,%eax
  1052f2:	74 24                	je     105318 <check_boot_pgdir+0x2f7>
  1052f4:	c7 44 24 0c a4 71 10 	movl   $0x1071a4,0xc(%esp)
  1052fb:	00 
  1052fc:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  105303:	00 
  105304:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
  10530b:	00 
  10530c:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  105313:	e8 d0 b9 ff ff       	call   100ce8 <__panic>

    *(char *) (page2kva(p) + 0x100) = '\0';
  105318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10531b:	89 04 24             	mov    %eax,(%esp)
  10531e:	e8 3c e9 ff ff       	call   103c5f <page2kva>
  105323:	05 00 01 00 00       	add    $0x100,%eax
  105328:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *) 0x100) == 0);
  10532b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105332:	e8 47 09 00 00       	call   105c7e <strlen>
  105337:	85 c0                	test   %eax,%eax
  105339:	74 24                	je     10535f <check_boot_pgdir+0x33e>
  10533b:	c7 44 24 0c dc 71 10 	movl   $0x1071dc,0xc(%esp)
  105342:	00 
  105343:	c7 44 24 08 7d 6d 10 	movl   $0x106d7d,0x8(%esp)
  10534a:	00 
  10534b:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
  105352:	00 
  105353:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  10535a:	e8 89 b9 ff ff       	call   100ce8 <__panic>

    free_page(p);
  10535f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105366:	00 
  105367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10536a:	89 04 24             	mov    %eax,(%esp)
  10536d:	e8 e7 eb ff ff       	call   103f59 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105372:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105377:	8b 00                	mov    (%eax),%eax
  105379:	89 04 24             	mov    %eax,(%esp)
  10537c:	e8 74 e9 ff ff       	call   103cf5 <pde2page>
  105381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105388:	00 
  105389:	89 04 24             	mov    %eax,(%esp)
  10538c:	e8 c8 eb ff ff       	call   103f59 <free_pages>
    boot_pgdir[0] = 0;
  105391:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10539c:	c7 04 24 00 72 10 00 	movl   $0x107200,(%esp)
  1053a3:	e8 ae af ff ff       	call   100356 <cprintf>
}
  1053a8:	90                   	nop
  1053a9:	89 ec                	mov    %ebp,%esp
  1053ab:	5d                   	pop    %ebp
  1053ac:	c3                   	ret    

001053ad <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1053ad:	55                   	push   %ebp
  1053ae:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1053b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b3:	83 e0 04             	and    $0x4,%eax
  1053b6:	85 c0                	test   %eax,%eax
  1053b8:	74 04                	je     1053be <perm2str+0x11>
  1053ba:	b0 75                	mov    $0x75,%al
  1053bc:	eb 02                	jmp    1053c0 <perm2str+0x13>
  1053be:	b0 2d                	mov    $0x2d,%al
  1053c0:	a2 28 cf 11 00       	mov    %al,0x11cf28
    str[1] = 'r';
  1053c5:	c6 05 29 cf 11 00 72 	movb   $0x72,0x11cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1053cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053cf:	83 e0 02             	and    $0x2,%eax
  1053d2:	85 c0                	test   %eax,%eax
  1053d4:	74 04                	je     1053da <perm2str+0x2d>
  1053d6:	b0 77                	mov    $0x77,%al
  1053d8:	eb 02                	jmp    1053dc <perm2str+0x2f>
  1053da:	b0 2d                	mov    $0x2d,%al
  1053dc:	a2 2a cf 11 00       	mov    %al,0x11cf2a
    str[3] = '\0';
  1053e1:	c6 05 2b cf 11 00 00 	movb   $0x0,0x11cf2b
    return str;
  1053e8:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
}
  1053ed:	5d                   	pop    %ebp
  1053ee:	c3                   	ret    

001053ef <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1053ef:	55                   	push   %ebp
  1053f0:	89 e5                	mov    %esp,%ebp
  1053f2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1053f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053fb:	72 0d                	jb     10540a <get_pgtable_items+0x1b>
        return 0;
  1053fd:	b8 00 00 00 00       	mov    $0x0,%eax
  105402:	e9 98 00 00 00       	jmp    10549f <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start++;
  105407:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10540a:	8b 45 10             	mov    0x10(%ebp),%eax
  10540d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105410:	73 18                	jae    10542a <get_pgtable_items+0x3b>
  105412:	8b 45 10             	mov    0x10(%ebp),%eax
  105415:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10541c:	8b 45 14             	mov    0x14(%ebp),%eax
  10541f:	01 d0                	add    %edx,%eax
  105421:	8b 00                	mov    (%eax),%eax
  105423:	83 e0 01             	and    $0x1,%eax
  105426:	85 c0                	test   %eax,%eax
  105428:	74 dd                	je     105407 <get_pgtable_items+0x18>
    }
    if (start < right) {
  10542a:	8b 45 10             	mov    0x10(%ebp),%eax
  10542d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105430:	73 68                	jae    10549a <get_pgtable_items+0xab>
        if (left_store != NULL) {
  105432:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105436:	74 08                	je     105440 <get_pgtable_items+0x51>
            *left_store = start;
  105438:	8b 45 18             	mov    0x18(%ebp),%eax
  10543b:	8b 55 10             	mov    0x10(%ebp),%edx
  10543e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
  105440:	8b 45 10             	mov    0x10(%ebp),%eax
  105443:	8d 50 01             	lea    0x1(%eax),%edx
  105446:	89 55 10             	mov    %edx,0x10(%ebp)
  105449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105450:	8b 45 14             	mov    0x14(%ebp),%eax
  105453:	01 d0                	add    %edx,%eax
  105455:	8b 00                	mov    (%eax),%eax
  105457:	83 e0 07             	and    $0x7,%eax
  10545a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10545d:	eb 03                	jmp    105462 <get_pgtable_items+0x73>
            start++;
  10545f:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105462:	8b 45 10             	mov    0x10(%ebp),%eax
  105465:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105468:	73 1d                	jae    105487 <get_pgtable_items+0x98>
  10546a:	8b 45 10             	mov    0x10(%ebp),%eax
  10546d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105474:	8b 45 14             	mov    0x14(%ebp),%eax
  105477:	01 d0                	add    %edx,%eax
  105479:	8b 00                	mov    (%eax),%eax
  10547b:	83 e0 07             	and    $0x7,%eax
  10547e:	89 c2                	mov    %eax,%edx
  105480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105483:	39 c2                	cmp    %eax,%edx
  105485:	74 d8                	je     10545f <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  105487:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10548b:	74 08                	je     105495 <get_pgtable_items+0xa6>
            *right_store = start;
  10548d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105490:	8b 55 10             	mov    0x10(%ebp),%edx
  105493:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105498:	eb 05                	jmp    10549f <get_pgtable_items+0xb0>
    }
    return 0;
  10549a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10549f:	89 ec                	mov    %ebp,%esp
  1054a1:	5d                   	pop    %ebp
  1054a2:	c3                   	ret    

001054a3 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1054a3:	55                   	push   %ebp
  1054a4:	89 e5                	mov    %esp,%ebp
  1054a6:	57                   	push   %edi
  1054a7:	56                   	push   %esi
  1054a8:	53                   	push   %ebx
  1054a9:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1054ac:	c7 04 24 20 72 10 00 	movl   $0x107220,(%esp)
  1054b3:	e8 9e ae ff ff       	call   100356 <cprintf>
    size_t left, right = 0, perm;
  1054b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1054bf:	e9 f2 00 00 00       	jmp    1055b6 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054c7:	89 04 24             	mov    %eax,(%esp)
  1054ca:	e8 de fe ff ff       	call   1053ad <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1054cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1054d5:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054d7:	89 d6                	mov    %edx,%esi
  1054d9:	c1 e6 16             	shl    $0x16,%esi
  1054dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054df:	89 d3                	mov    %edx,%ebx
  1054e1:	c1 e3 16             	shl    $0x16,%ebx
  1054e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054e7:	89 d1                	mov    %edx,%ecx
  1054e9:	c1 e1 16             	shl    $0x16,%ecx
  1054ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054ef:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1054f2:	29 fa                	sub    %edi,%edx
  1054f4:	89 44 24 14          	mov    %eax,0x14(%esp)
  1054f8:	89 74 24 10          	mov    %esi,0x10(%esp)
  1054fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105500:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105504:	89 54 24 04          	mov    %edx,0x4(%esp)
  105508:	c7 04 24 51 72 10 00 	movl   $0x107251,(%esp)
  10550f:	e8 42 ae ff ff       	call   100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
  105514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105517:	c1 e0 0a             	shl    $0xa,%eax
  10551a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10551d:	eb 50                	jmp    10556f <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10551f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105522:	89 04 24             	mov    %eax,(%esp)
  105525:	e8 83 fe ff ff       	call   1053ad <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10552a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10552d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105530:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105532:	89 d6                	mov    %edx,%esi
  105534:	c1 e6 0c             	shl    $0xc,%esi
  105537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10553a:	89 d3                	mov    %edx,%ebx
  10553c:	c1 e3 0c             	shl    $0xc,%ebx
  10553f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105542:	89 d1                	mov    %edx,%ecx
  105544:	c1 e1 0c             	shl    $0xc,%ecx
  105547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10554a:	8b 7d d8             	mov    -0x28(%ebp),%edi
  10554d:	29 fa                	sub    %edi,%edx
  10554f:	89 44 24 14          	mov    %eax,0x14(%esp)
  105553:	89 74 24 10          	mov    %esi,0x10(%esp)
  105557:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10555b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10555f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105563:	c7 04 24 70 72 10 00 	movl   $0x107270,(%esp)
  10556a:	e8 e7 ad ff ff       	call   100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10556f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  105574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105577:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10557a:	89 d3                	mov    %edx,%ebx
  10557c:	c1 e3 0a             	shl    $0xa,%ebx
  10557f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105582:	89 d1                	mov    %edx,%ecx
  105584:	c1 e1 0a             	shl    $0xa,%ecx
  105587:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10558a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10558e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  105591:	89 54 24 10          	mov    %edx,0x10(%esp)
  105595:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105599:	89 44 24 08          	mov    %eax,0x8(%esp)
  10559d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1055a1:	89 0c 24             	mov    %ecx,(%esp)
  1055a4:	e8 46 fe ff ff       	call   1053ef <get_pgtable_items>
  1055a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055b0:	0f 85 69 ff ff ff    	jne    10551f <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1055b6:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1055bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055be:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1055c1:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055c5:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1055c8:	89 54 24 10          	mov    %edx,0x10(%esp)
  1055cc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1055d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055d4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1055db:	00 
  1055dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055e3:	e8 07 fe ff ff       	call   1053ef <get_pgtable_items>
  1055e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055ef:	0f 85 cf fe ff ff    	jne    1054c4 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1055f5:	c7 04 24 94 72 10 00 	movl   $0x107294,(%esp)
  1055fc:	e8 55 ad ff ff       	call   100356 <cprintf>
}
  105601:	90                   	nop
  105602:	83 c4 4c             	add    $0x4c,%esp
  105605:	5b                   	pop    %ebx
  105606:	5e                   	pop    %esi
  105607:	5f                   	pop    %edi
  105608:	5d                   	pop    %ebp
  105609:	c3                   	ret    

0010560a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10560a:	55                   	push   %ebp
  10560b:	89 e5                	mov    %esp,%ebp
  10560d:	83 ec 58             	sub    $0x58,%esp
  105610:	8b 45 10             	mov    0x10(%ebp),%eax
  105613:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105616:	8b 45 14             	mov    0x14(%ebp),%eax
  105619:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10561c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10561f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105622:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105625:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105628:	8b 45 18             	mov    0x18(%ebp),%eax
  10562b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10562e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105631:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105634:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105637:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10563a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10563d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105644:	74 1c                	je     105662 <printnum+0x58>
  105646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105649:	ba 00 00 00 00       	mov    $0x0,%edx
  10564e:	f7 75 e4             	divl   -0x1c(%ebp)
  105651:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105657:	ba 00 00 00 00       	mov    $0x0,%edx
  10565c:	f7 75 e4             	divl   -0x1c(%ebp)
  10565f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105668:	f7 75 e4             	divl   -0x1c(%ebp)
  10566b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10566e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105674:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105677:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10567a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10567d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105680:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105683:	8b 45 18             	mov    0x18(%ebp),%eax
  105686:	ba 00 00 00 00       	mov    $0x0,%edx
  10568b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10568e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105691:	19 d1                	sbb    %edx,%ecx
  105693:	72 4c                	jb     1056e1 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105695:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105698:	8d 50 ff             	lea    -0x1(%eax),%edx
  10569b:	8b 45 20             	mov    0x20(%ebp),%eax
  10569e:	89 44 24 18          	mov    %eax,0x18(%esp)
  1056a2:	89 54 24 14          	mov    %edx,0x14(%esp)
  1056a6:	8b 45 18             	mov    0x18(%ebp),%eax
  1056a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1056ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1056b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1056bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c5:	89 04 24             	mov    %eax,(%esp)
  1056c8:	e8 3d ff ff ff       	call   10560a <printnum>
  1056cd:	eb 1b                	jmp    1056ea <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1056cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056d6:	8b 45 20             	mov    0x20(%ebp),%eax
  1056d9:	89 04 24             	mov    %eax,(%esp)
  1056dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1056df:	ff d0                	call   *%eax
        while (-- width > 0)
  1056e1:	ff 4d 1c             	decl   0x1c(%ebp)
  1056e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056e8:	7f e5                	jg     1056cf <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056ed:	05 48 73 10 00       	add    $0x107348,%eax
  1056f2:	0f b6 00             	movzbl (%eax),%eax
  1056f5:	0f be c0             	movsbl %al,%eax
  1056f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056ff:	89 04 24             	mov    %eax,(%esp)
  105702:	8b 45 08             	mov    0x8(%ebp),%eax
  105705:	ff d0                	call   *%eax
}
  105707:	90                   	nop
  105708:	89 ec                	mov    %ebp,%esp
  10570a:	5d                   	pop    %ebp
  10570b:	c3                   	ret    

0010570c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10570c:	55                   	push   %ebp
  10570d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10570f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105713:	7e 14                	jle    105729 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105715:	8b 45 08             	mov    0x8(%ebp),%eax
  105718:	8b 00                	mov    (%eax),%eax
  10571a:	8d 48 08             	lea    0x8(%eax),%ecx
  10571d:	8b 55 08             	mov    0x8(%ebp),%edx
  105720:	89 0a                	mov    %ecx,(%edx)
  105722:	8b 50 04             	mov    0x4(%eax),%edx
  105725:	8b 00                	mov    (%eax),%eax
  105727:	eb 30                	jmp    105759 <getuint+0x4d>
    }
    else if (lflag) {
  105729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10572d:	74 16                	je     105745 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10572f:	8b 45 08             	mov    0x8(%ebp),%eax
  105732:	8b 00                	mov    (%eax),%eax
  105734:	8d 48 04             	lea    0x4(%eax),%ecx
  105737:	8b 55 08             	mov    0x8(%ebp),%edx
  10573a:	89 0a                	mov    %ecx,(%edx)
  10573c:	8b 00                	mov    (%eax),%eax
  10573e:	ba 00 00 00 00       	mov    $0x0,%edx
  105743:	eb 14                	jmp    105759 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105745:	8b 45 08             	mov    0x8(%ebp),%eax
  105748:	8b 00                	mov    (%eax),%eax
  10574a:	8d 48 04             	lea    0x4(%eax),%ecx
  10574d:	8b 55 08             	mov    0x8(%ebp),%edx
  105750:	89 0a                	mov    %ecx,(%edx)
  105752:	8b 00                	mov    (%eax),%eax
  105754:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105759:	5d                   	pop    %ebp
  10575a:	c3                   	ret    

0010575b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10575b:	55                   	push   %ebp
  10575c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10575e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105762:	7e 14                	jle    105778 <getint+0x1d>
        return va_arg(*ap, long long);
  105764:	8b 45 08             	mov    0x8(%ebp),%eax
  105767:	8b 00                	mov    (%eax),%eax
  105769:	8d 48 08             	lea    0x8(%eax),%ecx
  10576c:	8b 55 08             	mov    0x8(%ebp),%edx
  10576f:	89 0a                	mov    %ecx,(%edx)
  105771:	8b 50 04             	mov    0x4(%eax),%edx
  105774:	8b 00                	mov    (%eax),%eax
  105776:	eb 28                	jmp    1057a0 <getint+0x45>
    }
    else if (lflag) {
  105778:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10577c:	74 12                	je     105790 <getint+0x35>
        return va_arg(*ap, long);
  10577e:	8b 45 08             	mov    0x8(%ebp),%eax
  105781:	8b 00                	mov    (%eax),%eax
  105783:	8d 48 04             	lea    0x4(%eax),%ecx
  105786:	8b 55 08             	mov    0x8(%ebp),%edx
  105789:	89 0a                	mov    %ecx,(%edx)
  10578b:	8b 00                	mov    (%eax),%eax
  10578d:	99                   	cltd   
  10578e:	eb 10                	jmp    1057a0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	8b 00                	mov    (%eax),%eax
  105795:	8d 48 04             	lea    0x4(%eax),%ecx
  105798:	8b 55 08             	mov    0x8(%ebp),%edx
  10579b:	89 0a                	mov    %ecx,(%edx)
  10579d:	8b 00                	mov    (%eax),%eax
  10579f:	99                   	cltd   
    }
}
  1057a0:	5d                   	pop    %ebp
  1057a1:	c3                   	ret    

001057a2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1057a2:	55                   	push   %ebp
  1057a3:	89 e5                	mov    %esp,%ebp
  1057a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1057a8:	8d 45 14             	lea    0x14(%ebp),%eax
  1057ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1057b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1057b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c6:	89 04 24             	mov    %eax,(%esp)
  1057c9:	e8 05 00 00 00       	call   1057d3 <vprintfmt>
    va_end(ap);
}
  1057ce:	90                   	nop
  1057cf:	89 ec                	mov    %ebp,%esp
  1057d1:	5d                   	pop    %ebp
  1057d2:	c3                   	ret    

001057d3 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1057d3:	55                   	push   %ebp
  1057d4:	89 e5                	mov    %esp,%ebp
  1057d6:	56                   	push   %esi
  1057d7:	53                   	push   %ebx
  1057d8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057db:	eb 17                	jmp    1057f4 <vprintfmt+0x21>
            if (ch == '\0') {
  1057dd:	85 db                	test   %ebx,%ebx
  1057df:	0f 84 bf 03 00 00    	je     105ba4 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1057e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ec:	89 1c 24             	mov    %ebx,(%esp)
  1057ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1057f7:	8d 50 01             	lea    0x1(%eax),%edx
  1057fa:	89 55 10             	mov    %edx,0x10(%ebp)
  1057fd:	0f b6 00             	movzbl (%eax),%eax
  105800:	0f b6 d8             	movzbl %al,%ebx
  105803:	83 fb 25             	cmp    $0x25,%ebx
  105806:	75 d5                	jne    1057dd <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105808:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10580c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105816:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105819:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105820:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105823:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105826:	8b 45 10             	mov    0x10(%ebp),%eax
  105829:	8d 50 01             	lea    0x1(%eax),%edx
  10582c:	89 55 10             	mov    %edx,0x10(%ebp)
  10582f:	0f b6 00             	movzbl (%eax),%eax
  105832:	0f b6 d8             	movzbl %al,%ebx
  105835:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105838:	83 f8 55             	cmp    $0x55,%eax
  10583b:	0f 87 37 03 00 00    	ja     105b78 <vprintfmt+0x3a5>
  105841:	8b 04 85 6c 73 10 00 	mov    0x10736c(,%eax,4),%eax
  105848:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10584a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10584e:	eb d6                	jmp    105826 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105850:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105854:	eb d0                	jmp    105826 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105856:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10585d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105860:	89 d0                	mov    %edx,%eax
  105862:	c1 e0 02             	shl    $0x2,%eax
  105865:	01 d0                	add    %edx,%eax
  105867:	01 c0                	add    %eax,%eax
  105869:	01 d8                	add    %ebx,%eax
  10586b:	83 e8 30             	sub    $0x30,%eax
  10586e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105871:	8b 45 10             	mov    0x10(%ebp),%eax
  105874:	0f b6 00             	movzbl (%eax),%eax
  105877:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10587a:	83 fb 2f             	cmp    $0x2f,%ebx
  10587d:	7e 38                	jle    1058b7 <vprintfmt+0xe4>
  10587f:	83 fb 39             	cmp    $0x39,%ebx
  105882:	7f 33                	jg     1058b7 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105884:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105887:	eb d4                	jmp    10585d <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105889:	8b 45 14             	mov    0x14(%ebp),%eax
  10588c:	8d 50 04             	lea    0x4(%eax),%edx
  10588f:	89 55 14             	mov    %edx,0x14(%ebp)
  105892:	8b 00                	mov    (%eax),%eax
  105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105897:	eb 1f                	jmp    1058b8 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105899:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10589d:	79 87                	jns    105826 <vprintfmt+0x53>
                width = 0;
  10589f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1058a6:	e9 7b ff ff ff       	jmp    105826 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1058ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1058b2:	e9 6f ff ff ff       	jmp    105826 <vprintfmt+0x53>
            goto process_precision;
  1058b7:	90                   	nop

        process_precision:
            if (width < 0)
  1058b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058bc:	0f 89 64 ff ff ff    	jns    105826 <vprintfmt+0x53>
                width = precision, precision = -1;
  1058c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1058cf:	e9 52 ff ff ff       	jmp    105826 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1058d4:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1058d7:	e9 4a ff ff ff       	jmp    105826 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058dc:	8b 45 14             	mov    0x14(%ebp),%eax
  1058df:	8d 50 04             	lea    0x4(%eax),%edx
  1058e2:	89 55 14             	mov    %edx,0x14(%ebp)
  1058e5:	8b 00                	mov    (%eax),%eax
  1058e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058ee:	89 04 24             	mov    %eax,(%esp)
  1058f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f4:	ff d0                	call   *%eax
            break;
  1058f6:	e9 a4 02 00 00       	jmp    105b9f <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1058fe:	8d 50 04             	lea    0x4(%eax),%edx
  105901:	89 55 14             	mov    %edx,0x14(%ebp)
  105904:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105906:	85 db                	test   %ebx,%ebx
  105908:	79 02                	jns    10590c <vprintfmt+0x139>
                err = -err;
  10590a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10590c:	83 fb 06             	cmp    $0x6,%ebx
  10590f:	7f 0b                	jg     10591c <vprintfmt+0x149>
  105911:	8b 34 9d 2c 73 10 00 	mov    0x10732c(,%ebx,4),%esi
  105918:	85 f6                	test   %esi,%esi
  10591a:	75 23                	jne    10593f <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  10591c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105920:	c7 44 24 08 59 73 10 	movl   $0x107359,0x8(%esp)
  105927:	00 
  105928:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592f:	8b 45 08             	mov    0x8(%ebp),%eax
  105932:	89 04 24             	mov    %eax,(%esp)
  105935:	e8 68 fe ff ff       	call   1057a2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10593a:	e9 60 02 00 00       	jmp    105b9f <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  10593f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105943:	c7 44 24 08 62 73 10 	movl   $0x107362,0x8(%esp)
  10594a:	00 
  10594b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10594e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105952:	8b 45 08             	mov    0x8(%ebp),%eax
  105955:	89 04 24             	mov    %eax,(%esp)
  105958:	e8 45 fe ff ff       	call   1057a2 <printfmt>
            break;
  10595d:	e9 3d 02 00 00       	jmp    105b9f <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105962:	8b 45 14             	mov    0x14(%ebp),%eax
  105965:	8d 50 04             	lea    0x4(%eax),%edx
  105968:	89 55 14             	mov    %edx,0x14(%ebp)
  10596b:	8b 30                	mov    (%eax),%esi
  10596d:	85 f6                	test   %esi,%esi
  10596f:	75 05                	jne    105976 <vprintfmt+0x1a3>
                p = "(null)";
  105971:	be 65 73 10 00       	mov    $0x107365,%esi
            }
            if (width > 0 && padc != '-') {
  105976:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10597a:	7e 76                	jle    1059f2 <vprintfmt+0x21f>
  10597c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105980:	74 70                	je     1059f2 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105985:	89 44 24 04          	mov    %eax,0x4(%esp)
  105989:	89 34 24             	mov    %esi,(%esp)
  10598c:	e8 16 03 00 00       	call   105ca7 <strnlen>
  105991:	89 c2                	mov    %eax,%edx
  105993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105996:	29 d0                	sub    %edx,%eax
  105998:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10599b:	eb 16                	jmp    1059b3 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10599d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1059a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059a8:	89 04 24             	mov    %eax,(%esp)
  1059ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ae:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1059b0:	ff 4d e8             	decl   -0x18(%ebp)
  1059b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059b7:	7f e4                	jg     10599d <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059b9:	eb 37                	jmp    1059f2 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  1059bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1059bf:	74 1f                	je     1059e0 <vprintfmt+0x20d>
  1059c1:	83 fb 1f             	cmp    $0x1f,%ebx
  1059c4:	7e 05                	jle    1059cb <vprintfmt+0x1f8>
  1059c6:	83 fb 7e             	cmp    $0x7e,%ebx
  1059c9:	7e 15                	jle    1059e0 <vprintfmt+0x20d>
                    putch('?', putdat);
  1059cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1059d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059dc:	ff d0                	call   *%eax
  1059de:	eb 0f                	jmp    1059ef <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  1059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e7:	89 1c 24             	mov    %ebx,(%esp)
  1059ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ed:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059ef:	ff 4d e8             	decl   -0x18(%ebp)
  1059f2:	89 f0                	mov    %esi,%eax
  1059f4:	8d 70 01             	lea    0x1(%eax),%esi
  1059f7:	0f b6 00             	movzbl (%eax),%eax
  1059fa:	0f be d8             	movsbl %al,%ebx
  1059fd:	85 db                	test   %ebx,%ebx
  1059ff:	74 27                	je     105a28 <vprintfmt+0x255>
  105a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a05:	78 b4                	js     1059bb <vprintfmt+0x1e8>
  105a07:	ff 4d e4             	decl   -0x1c(%ebp)
  105a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a0e:	79 ab                	jns    1059bb <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105a10:	eb 16                	jmp    105a28 <vprintfmt+0x255>
                putch(' ', putdat);
  105a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a19:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105a20:	8b 45 08             	mov    0x8(%ebp),%eax
  105a23:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105a25:	ff 4d e8             	decl   -0x18(%ebp)
  105a28:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a2c:	7f e4                	jg     105a12 <vprintfmt+0x23f>
            }
            break;
  105a2e:	e9 6c 01 00 00       	jmp    105b9f <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a3a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a3d:	89 04 24             	mov    %eax,(%esp)
  105a40:	e8 16 fd ff ff       	call   10575b <getint>
  105a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a48:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a51:	85 d2                	test   %edx,%edx
  105a53:	79 26                	jns    105a7b <vprintfmt+0x2a8>
                putch('-', putdat);
  105a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a5c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a63:	8b 45 08             	mov    0x8(%ebp),%eax
  105a66:	ff d0                	call   *%eax
                num = -(long long)num;
  105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a6e:	f7 d8                	neg    %eax
  105a70:	83 d2 00             	adc    $0x0,%edx
  105a73:	f7 da                	neg    %edx
  105a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a78:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a7b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a82:	e9 a8 00 00 00       	jmp    105b2f <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  105a91:	89 04 24             	mov    %eax,(%esp)
  105a94:	e8 73 fc ff ff       	call   10570c <getuint>
  105a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a9f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105aa6:	e9 84 00 00 00       	jmp    105b2f <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab2:	8d 45 14             	lea    0x14(%ebp),%eax
  105ab5:	89 04 24             	mov    %eax,(%esp)
  105ab8:	e8 4f fc ff ff       	call   10570c <getuint>
  105abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105ac3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105aca:	eb 63                	jmp    105b2f <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ad3:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105ada:	8b 45 08             	mov    0x8(%ebp),%eax
  105add:	ff d0                	call   *%eax
            putch('x', putdat);
  105adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105aed:	8b 45 08             	mov    0x8(%ebp),%eax
  105af0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105af2:	8b 45 14             	mov    0x14(%ebp),%eax
  105af5:	8d 50 04             	lea    0x4(%eax),%edx
  105af8:	89 55 14             	mov    %edx,0x14(%ebp)
  105afb:	8b 00                	mov    (%eax),%eax
  105afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105b0e:	eb 1f                	jmp    105b2f <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b17:	8d 45 14             	lea    0x14(%ebp),%eax
  105b1a:	89 04 24             	mov    %eax,(%esp)
  105b1d:	e8 ea fb ff ff       	call   10570c <getuint>
  105b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b25:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b36:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b3d:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b41:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b4f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5d:	89 04 24             	mov    %eax,(%esp)
  105b60:	e8 a5 fa ff ff       	call   10560a <printnum>
            break;
  105b65:	eb 38                	jmp    105b9f <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b6e:	89 1c 24             	mov    %ebx,(%esp)
  105b71:	8b 45 08             	mov    0x8(%ebp),%eax
  105b74:	ff d0                	call   *%eax
            break;
  105b76:	eb 27                	jmp    105b9f <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b7f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b86:	8b 45 08             	mov    0x8(%ebp),%eax
  105b89:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b8b:	ff 4d 10             	decl   0x10(%ebp)
  105b8e:	eb 03                	jmp    105b93 <vprintfmt+0x3c0>
  105b90:	ff 4d 10             	decl   0x10(%ebp)
  105b93:	8b 45 10             	mov    0x10(%ebp),%eax
  105b96:	48                   	dec    %eax
  105b97:	0f b6 00             	movzbl (%eax),%eax
  105b9a:	3c 25                	cmp    $0x25,%al
  105b9c:	75 f2                	jne    105b90 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105b9e:	90                   	nop
    while (1) {
  105b9f:	e9 37 fc ff ff       	jmp    1057db <vprintfmt+0x8>
                return;
  105ba4:	90                   	nop
        }
    }
}
  105ba5:	83 c4 40             	add    $0x40,%esp
  105ba8:	5b                   	pop    %ebx
  105ba9:	5e                   	pop    %esi
  105baa:	5d                   	pop    %ebp
  105bab:	c3                   	ret    

00105bac <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105bac:	55                   	push   %ebp
  105bad:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb2:	8b 40 08             	mov    0x8(%eax),%eax
  105bb5:	8d 50 01             	lea    0x1(%eax),%edx
  105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bbb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc1:	8b 10                	mov    (%eax),%edx
  105bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc6:	8b 40 04             	mov    0x4(%eax),%eax
  105bc9:	39 c2                	cmp    %eax,%edx
  105bcb:	73 12                	jae    105bdf <sprintputch+0x33>
        *b->buf ++ = ch;
  105bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd0:	8b 00                	mov    (%eax),%eax
  105bd2:	8d 48 01             	lea    0x1(%eax),%ecx
  105bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  105bd8:	89 0a                	mov    %ecx,(%edx)
  105bda:	8b 55 08             	mov    0x8(%ebp),%edx
  105bdd:	88 10                	mov    %dl,(%eax)
    }
}
  105bdf:	90                   	nop
  105be0:	5d                   	pop    %ebp
  105be1:	c3                   	ret    

00105be2 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105be2:	55                   	push   %ebp
  105be3:	89 e5                	mov    %esp,%ebp
  105be5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105be8:	8d 45 14             	lea    0x14(%ebp),%eax
  105beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bf1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  105bf8:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c03:	8b 45 08             	mov    0x8(%ebp),%eax
  105c06:	89 04 24             	mov    %eax,(%esp)
  105c09:	e8 0a 00 00 00       	call   105c18 <vsnprintf>
  105c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c14:	89 ec                	mov    %ebp,%esp
  105c16:	5d                   	pop    %ebp
  105c17:	c3                   	ret    

00105c18 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105c18:	55                   	push   %ebp
  105c19:	89 e5                	mov    %esp,%ebp
  105c1b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c27:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2d:	01 d0                	add    %edx,%eax
  105c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c3d:	74 0a                	je     105c49 <vsnprintf+0x31>
  105c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c45:	39 c2                	cmp    %eax,%edx
  105c47:	76 07                	jbe    105c50 <vsnprintf+0x38>
        return -E_INVAL;
  105c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c4e:	eb 2a                	jmp    105c7a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c50:	8b 45 14             	mov    0x14(%ebp),%eax
  105c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c57:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c65:	c7 04 24 ac 5b 10 00 	movl   $0x105bac,(%esp)
  105c6c:	e8 62 fb ff ff       	call   1057d3 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c74:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c7a:	89 ec                	mov    %ebp,%esp
  105c7c:	5d                   	pop    %ebp
  105c7d:	c3                   	ret    

00105c7e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105c7e:	55                   	push   %ebp
  105c7f:	89 e5                	mov    %esp,%ebp
  105c81:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105c8b:	eb 03                	jmp    105c90 <strlen+0x12>
        cnt ++;
  105c8d:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105c90:	8b 45 08             	mov    0x8(%ebp),%eax
  105c93:	8d 50 01             	lea    0x1(%eax),%edx
  105c96:	89 55 08             	mov    %edx,0x8(%ebp)
  105c99:	0f b6 00             	movzbl (%eax),%eax
  105c9c:	84 c0                	test   %al,%al
  105c9e:	75 ed                	jne    105c8d <strlen+0xf>
    }
    return cnt;
  105ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ca3:	89 ec                	mov    %ebp,%esp
  105ca5:	5d                   	pop    %ebp
  105ca6:	c3                   	ret    

00105ca7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105ca7:	55                   	push   %ebp
  105ca8:	89 e5                	mov    %esp,%ebp
  105caa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105cb4:	eb 03                	jmp    105cb9 <strnlen+0x12>
        cnt ++;
  105cb6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105cbc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105cbf:	73 10                	jae    105cd1 <strnlen+0x2a>
  105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc4:	8d 50 01             	lea    0x1(%eax),%edx
  105cc7:	89 55 08             	mov    %edx,0x8(%ebp)
  105cca:	0f b6 00             	movzbl (%eax),%eax
  105ccd:	84 c0                	test   %al,%al
  105ccf:	75 e5                	jne    105cb6 <strnlen+0xf>
    }
    return cnt;
  105cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105cd4:	89 ec                	mov    %ebp,%esp
  105cd6:	5d                   	pop    %ebp
  105cd7:	c3                   	ret    

00105cd8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105cd8:	55                   	push   %ebp
  105cd9:	89 e5                	mov    %esp,%ebp
  105cdb:	57                   	push   %edi
  105cdc:	56                   	push   %esi
  105cdd:	83 ec 20             	sub    $0x20,%esp
  105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105cec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cf2:	89 d1                	mov    %edx,%ecx
  105cf4:	89 c2                	mov    %eax,%edx
  105cf6:	89 ce                	mov    %ecx,%esi
  105cf8:	89 d7                	mov    %edx,%edi
  105cfa:	ac                   	lods   %ds:(%esi),%al
  105cfb:	aa                   	stos   %al,%es:(%edi)
  105cfc:	84 c0                	test   %al,%al
  105cfe:	75 fa                	jne    105cfa <strcpy+0x22>
  105d00:	89 fa                	mov    %edi,%edx
  105d02:	89 f1                	mov    %esi,%ecx
  105d04:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d07:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105d10:	83 c4 20             	add    $0x20,%esp
  105d13:	5e                   	pop    %esi
  105d14:	5f                   	pop    %edi
  105d15:	5d                   	pop    %ebp
  105d16:	c3                   	ret    

00105d17 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105d17:	55                   	push   %ebp
  105d18:	89 e5                	mov    %esp,%ebp
  105d1a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d20:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105d23:	eb 1e                	jmp    105d43 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d28:	0f b6 10             	movzbl (%eax),%edx
  105d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d2e:	88 10                	mov    %dl,(%eax)
  105d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d33:	0f b6 00             	movzbl (%eax),%eax
  105d36:	84 c0                	test   %al,%al
  105d38:	74 03                	je     105d3d <strncpy+0x26>
            src ++;
  105d3a:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105d3d:	ff 45 fc             	incl   -0x4(%ebp)
  105d40:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d47:	75 dc                	jne    105d25 <strncpy+0xe>
    }
    return dst;
  105d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d4c:	89 ec                	mov    %ebp,%esp
  105d4e:	5d                   	pop    %ebp
  105d4f:	c3                   	ret    

00105d50 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d50:	55                   	push   %ebp
  105d51:	89 e5                	mov    %esp,%ebp
  105d53:	57                   	push   %edi
  105d54:	56                   	push   %esi
  105d55:	83 ec 20             	sub    $0x20,%esp
  105d58:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d6a:	89 d1                	mov    %edx,%ecx
  105d6c:	89 c2                	mov    %eax,%edx
  105d6e:	89 ce                	mov    %ecx,%esi
  105d70:	89 d7                	mov    %edx,%edi
  105d72:	ac                   	lods   %ds:(%esi),%al
  105d73:	ae                   	scas   %es:(%edi),%al
  105d74:	75 08                	jne    105d7e <strcmp+0x2e>
  105d76:	84 c0                	test   %al,%al
  105d78:	75 f8                	jne    105d72 <strcmp+0x22>
  105d7a:	31 c0                	xor    %eax,%eax
  105d7c:	eb 04                	jmp    105d82 <strcmp+0x32>
  105d7e:	19 c0                	sbb    %eax,%eax
  105d80:	0c 01                	or     $0x1,%al
  105d82:	89 fa                	mov    %edi,%edx
  105d84:	89 f1                	mov    %esi,%ecx
  105d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d89:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105d92:	83 c4 20             	add    $0x20,%esp
  105d95:	5e                   	pop    %esi
  105d96:	5f                   	pop    %edi
  105d97:	5d                   	pop    %ebp
  105d98:	c3                   	ret    

00105d99 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105d99:	55                   	push   %ebp
  105d9a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d9c:	eb 09                	jmp    105da7 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105d9e:	ff 4d 10             	decl   0x10(%ebp)
  105da1:	ff 45 08             	incl   0x8(%ebp)
  105da4:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dab:	74 1a                	je     105dc7 <strncmp+0x2e>
  105dad:	8b 45 08             	mov    0x8(%ebp),%eax
  105db0:	0f b6 00             	movzbl (%eax),%eax
  105db3:	84 c0                	test   %al,%al
  105db5:	74 10                	je     105dc7 <strncmp+0x2e>
  105db7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dba:	0f b6 10             	movzbl (%eax),%edx
  105dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc0:	0f b6 00             	movzbl (%eax),%eax
  105dc3:	38 c2                	cmp    %al,%dl
  105dc5:	74 d7                	je     105d9e <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dcb:	74 18                	je     105de5 <strncmp+0x4c>
  105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd0:	0f b6 00             	movzbl (%eax),%eax
  105dd3:	0f b6 d0             	movzbl %al,%edx
  105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd9:	0f b6 00             	movzbl (%eax),%eax
  105ddc:	0f b6 c8             	movzbl %al,%ecx
  105ddf:	89 d0                	mov    %edx,%eax
  105de1:	29 c8                	sub    %ecx,%eax
  105de3:	eb 05                	jmp    105dea <strncmp+0x51>
  105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105dea:	5d                   	pop    %ebp
  105deb:	c3                   	ret    

00105dec <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105dec:	55                   	push   %ebp
  105ded:	89 e5                	mov    %esp,%ebp
  105def:	83 ec 04             	sub    $0x4,%esp
  105df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105df8:	eb 13                	jmp    105e0d <strchr+0x21>
        if (*s == c) {
  105dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfd:	0f b6 00             	movzbl (%eax),%eax
  105e00:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e03:	75 05                	jne    105e0a <strchr+0x1e>
            return (char *)s;
  105e05:	8b 45 08             	mov    0x8(%ebp),%eax
  105e08:	eb 12                	jmp    105e1c <strchr+0x30>
        }
        s ++;
  105e0a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e10:	0f b6 00             	movzbl (%eax),%eax
  105e13:	84 c0                	test   %al,%al
  105e15:	75 e3                	jne    105dfa <strchr+0xe>
    }
    return NULL;
  105e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e1c:	89 ec                	mov    %ebp,%esp
  105e1e:	5d                   	pop    %ebp
  105e1f:	c3                   	ret    

00105e20 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105e20:	55                   	push   %ebp
  105e21:	89 e5                	mov    %esp,%ebp
  105e23:	83 ec 04             	sub    $0x4,%esp
  105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e2c:	eb 0e                	jmp    105e3c <strfind+0x1c>
        if (*s == c) {
  105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e31:	0f b6 00             	movzbl (%eax),%eax
  105e34:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e37:	74 0f                	je     105e48 <strfind+0x28>
            break;
        }
        s ++;
  105e39:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e3f:	0f b6 00             	movzbl (%eax),%eax
  105e42:	84 c0                	test   %al,%al
  105e44:	75 e8                	jne    105e2e <strfind+0xe>
  105e46:	eb 01                	jmp    105e49 <strfind+0x29>
            break;
  105e48:	90                   	nop
    }
    return (char *)s;
  105e49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e4c:	89 ec                	mov    %ebp,%esp
  105e4e:	5d                   	pop    %ebp
  105e4f:	c3                   	ret    

00105e50 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e50:	55                   	push   %ebp
  105e51:	89 e5                	mov    %esp,%ebp
  105e53:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105e5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e64:	eb 03                	jmp    105e69 <strtol+0x19>
        s ++;
  105e66:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105e69:	8b 45 08             	mov    0x8(%ebp),%eax
  105e6c:	0f b6 00             	movzbl (%eax),%eax
  105e6f:	3c 20                	cmp    $0x20,%al
  105e71:	74 f3                	je     105e66 <strtol+0x16>
  105e73:	8b 45 08             	mov    0x8(%ebp),%eax
  105e76:	0f b6 00             	movzbl (%eax),%eax
  105e79:	3c 09                	cmp    $0x9,%al
  105e7b:	74 e9                	je     105e66 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e80:	0f b6 00             	movzbl (%eax),%eax
  105e83:	3c 2b                	cmp    $0x2b,%al
  105e85:	75 05                	jne    105e8c <strtol+0x3c>
        s ++;
  105e87:	ff 45 08             	incl   0x8(%ebp)
  105e8a:	eb 14                	jmp    105ea0 <strtol+0x50>
    }
    else if (*s == '-') {
  105e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8f:	0f b6 00             	movzbl (%eax),%eax
  105e92:	3c 2d                	cmp    $0x2d,%al
  105e94:	75 0a                	jne    105ea0 <strtol+0x50>
        s ++, neg = 1;
  105e96:	ff 45 08             	incl   0x8(%ebp)
  105e99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ea4:	74 06                	je     105eac <strtol+0x5c>
  105ea6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105eaa:	75 22                	jne    105ece <strtol+0x7e>
  105eac:	8b 45 08             	mov    0x8(%ebp),%eax
  105eaf:	0f b6 00             	movzbl (%eax),%eax
  105eb2:	3c 30                	cmp    $0x30,%al
  105eb4:	75 18                	jne    105ece <strtol+0x7e>
  105eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb9:	40                   	inc    %eax
  105eba:	0f b6 00             	movzbl (%eax),%eax
  105ebd:	3c 78                	cmp    $0x78,%al
  105ebf:	75 0d                	jne    105ece <strtol+0x7e>
        s += 2, base = 16;
  105ec1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105ec5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105ecc:	eb 29                	jmp    105ef7 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ed2:	75 16                	jne    105eea <strtol+0x9a>
  105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed7:	0f b6 00             	movzbl (%eax),%eax
  105eda:	3c 30                	cmp    $0x30,%al
  105edc:	75 0c                	jne    105eea <strtol+0x9a>
        s ++, base = 8;
  105ede:	ff 45 08             	incl   0x8(%ebp)
  105ee1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105ee8:	eb 0d                	jmp    105ef7 <strtol+0xa7>
    }
    else if (base == 0) {
  105eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105eee:	75 07                	jne    105ef7 <strtol+0xa7>
        base = 10;
  105ef0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  105efa:	0f b6 00             	movzbl (%eax),%eax
  105efd:	3c 2f                	cmp    $0x2f,%al
  105eff:	7e 1b                	jle    105f1c <strtol+0xcc>
  105f01:	8b 45 08             	mov    0x8(%ebp),%eax
  105f04:	0f b6 00             	movzbl (%eax),%eax
  105f07:	3c 39                	cmp    $0x39,%al
  105f09:	7f 11                	jg     105f1c <strtol+0xcc>
            dig = *s - '0';
  105f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0e:	0f b6 00             	movzbl (%eax),%eax
  105f11:	0f be c0             	movsbl %al,%eax
  105f14:	83 e8 30             	sub    $0x30,%eax
  105f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f1a:	eb 48                	jmp    105f64 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1f:	0f b6 00             	movzbl (%eax),%eax
  105f22:	3c 60                	cmp    $0x60,%al
  105f24:	7e 1b                	jle    105f41 <strtol+0xf1>
  105f26:	8b 45 08             	mov    0x8(%ebp),%eax
  105f29:	0f b6 00             	movzbl (%eax),%eax
  105f2c:	3c 7a                	cmp    $0x7a,%al
  105f2e:	7f 11                	jg     105f41 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105f30:	8b 45 08             	mov    0x8(%ebp),%eax
  105f33:	0f b6 00             	movzbl (%eax),%eax
  105f36:	0f be c0             	movsbl %al,%eax
  105f39:	83 e8 57             	sub    $0x57,%eax
  105f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f3f:	eb 23                	jmp    105f64 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f41:	8b 45 08             	mov    0x8(%ebp),%eax
  105f44:	0f b6 00             	movzbl (%eax),%eax
  105f47:	3c 40                	cmp    $0x40,%al
  105f49:	7e 3b                	jle    105f86 <strtol+0x136>
  105f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f4e:	0f b6 00             	movzbl (%eax),%eax
  105f51:	3c 5a                	cmp    $0x5a,%al
  105f53:	7f 31                	jg     105f86 <strtol+0x136>
            dig = *s - 'A' + 10;
  105f55:	8b 45 08             	mov    0x8(%ebp),%eax
  105f58:	0f b6 00             	movzbl (%eax),%eax
  105f5b:	0f be c0             	movsbl %al,%eax
  105f5e:	83 e8 37             	sub    $0x37,%eax
  105f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f67:	3b 45 10             	cmp    0x10(%ebp),%eax
  105f6a:	7d 19                	jge    105f85 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105f6c:	ff 45 08             	incl   0x8(%ebp)
  105f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f72:	0f af 45 10          	imul   0x10(%ebp),%eax
  105f76:	89 c2                	mov    %eax,%edx
  105f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f7b:	01 d0                	add    %edx,%eax
  105f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105f80:	e9 72 ff ff ff       	jmp    105ef7 <strtol+0xa7>
            break;
  105f85:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f8a:	74 08                	je     105f94 <strtol+0x144>
        *endptr = (char *) s;
  105f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  105f92:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105f98:	74 07                	je     105fa1 <strtol+0x151>
  105f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f9d:	f7 d8                	neg    %eax
  105f9f:	eb 03                	jmp    105fa4 <strtol+0x154>
  105fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105fa4:	89 ec                	mov    %ebp,%esp
  105fa6:	5d                   	pop    %ebp
  105fa7:	c3                   	ret    

00105fa8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105fa8:	55                   	push   %ebp
  105fa9:	89 e5                	mov    %esp,%ebp
  105fab:	83 ec 28             	sub    $0x28,%esp
  105fae:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fb4:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105fb7:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105fc1:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  105fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105fca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105fcd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105fd1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105fd4:	89 d7                	mov    %edx,%edi
  105fd6:	f3 aa                	rep stos %al,%es:(%edi)
  105fd8:	89 fa                	mov    %edi,%edx
  105fda:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105fdd:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105fe3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105fe6:	89 ec                	mov    %ebp,%esp
  105fe8:	5d                   	pop    %ebp
  105fe9:	c3                   	ret    

00105fea <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105fea:	55                   	push   %ebp
  105feb:	89 e5                	mov    %esp,%ebp
  105fed:	57                   	push   %edi
  105fee:	56                   	push   %esi
  105fef:	53                   	push   %ebx
  105ff0:	83 ec 30             	sub    $0x30,%esp
  105ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fff:	8b 45 10             	mov    0x10(%ebp),%eax
  106002:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106008:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10600b:	73 42                	jae    10604f <memmove+0x65>
  10600d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106016:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10601c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10601f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106022:	c1 e8 02             	shr    $0x2,%eax
  106025:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10602a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10602d:	89 d7                	mov    %edx,%edi
  10602f:	89 c6                	mov    %eax,%esi
  106031:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106033:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106036:	83 e1 03             	and    $0x3,%ecx
  106039:	74 02                	je     10603d <memmove+0x53>
  10603b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10603d:	89 f0                	mov    %esi,%eax
  10603f:	89 fa                	mov    %edi,%edx
  106041:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106044:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106047:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  10604a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10604d:	eb 36                	jmp    106085 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10604f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106052:	8d 50 ff             	lea    -0x1(%eax),%edx
  106055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106058:	01 c2                	add    %eax,%edx
  10605a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10605d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106063:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  106066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106069:	89 c1                	mov    %eax,%ecx
  10606b:	89 d8                	mov    %ebx,%eax
  10606d:	89 d6                	mov    %edx,%esi
  10606f:	89 c7                	mov    %eax,%edi
  106071:	fd                   	std    
  106072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106074:	fc                   	cld    
  106075:	89 f8                	mov    %edi,%eax
  106077:	89 f2                	mov    %esi,%edx
  106079:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10607c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10607f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106082:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106085:	83 c4 30             	add    $0x30,%esp
  106088:	5b                   	pop    %ebx
  106089:	5e                   	pop    %esi
  10608a:	5f                   	pop    %edi
  10608b:	5d                   	pop    %ebp
  10608c:	c3                   	ret    

0010608d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10608d:	55                   	push   %ebp
  10608e:	89 e5                	mov    %esp,%ebp
  106090:	57                   	push   %edi
  106091:	56                   	push   %esi
  106092:	83 ec 20             	sub    $0x20,%esp
  106095:	8b 45 08             	mov    0x8(%ebp),%eax
  106098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10609b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10609e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1060a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1060a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060aa:	c1 e8 02             	shr    $0x2,%eax
  1060ad:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1060af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1060b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060b5:	89 d7                	mov    %edx,%edi
  1060b7:	89 c6                	mov    %eax,%esi
  1060b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1060bb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1060be:	83 e1 03             	and    $0x3,%ecx
  1060c1:	74 02                	je     1060c5 <memcpy+0x38>
  1060c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060c5:	89 f0                	mov    %esi,%eax
  1060c7:	89 fa                	mov    %edi,%edx
  1060c9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1060cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1060cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1060d5:	83 c4 20             	add    $0x20,%esp
  1060d8:	5e                   	pop    %esi
  1060d9:	5f                   	pop    %edi
  1060da:	5d                   	pop    %ebp
  1060db:	c3                   	ret    

001060dc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1060dc:	55                   	push   %ebp
  1060dd:	89 e5                	mov    %esp,%ebp
  1060df:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1060e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1060e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1060e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1060ee:	eb 2e                	jmp    10611e <memcmp+0x42>
        if (*s1 != *s2) {
  1060f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060f3:	0f b6 10             	movzbl (%eax),%edx
  1060f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060f9:	0f b6 00             	movzbl (%eax),%eax
  1060fc:	38 c2                	cmp    %al,%dl
  1060fe:	74 18                	je     106118 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106103:	0f b6 00             	movzbl (%eax),%eax
  106106:	0f b6 d0             	movzbl %al,%edx
  106109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10610c:	0f b6 00             	movzbl (%eax),%eax
  10610f:	0f b6 c8             	movzbl %al,%ecx
  106112:	89 d0                	mov    %edx,%eax
  106114:	29 c8                	sub    %ecx,%eax
  106116:	eb 18                	jmp    106130 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  106118:	ff 45 fc             	incl   -0x4(%ebp)
  10611b:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10611e:	8b 45 10             	mov    0x10(%ebp),%eax
  106121:	8d 50 ff             	lea    -0x1(%eax),%edx
  106124:	89 55 10             	mov    %edx,0x10(%ebp)
  106127:	85 c0                	test   %eax,%eax
  106129:	75 c5                	jne    1060f0 <memcmp+0x14>
    }
    return 0;
  10612b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106130:	89 ec                	mov    %ebp,%esp
  106132:	5d                   	pop    %ebp
  106133:	c3                   	ret    
