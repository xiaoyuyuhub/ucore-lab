
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
c0100059:	e8 fa 5e 00 00       	call   c0105f58 <memset>

    cons_init();                // init the console
c010005e:	e8 f7 15 00 00       	call   c010165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 00 61 10 c0 	movl   $0xc0106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 1c 61 10 c0 	movl   $0xc010611c,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 99 44 00 00       	call   c0104525 <pmm_init>

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
c0100167:	c7 04 24 21 61 10 c0 	movl   $0xc0106121,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 2f 61 10 c0 	movl   $0xc010612f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 3d 61 10 c0 	movl   $0xc010613d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 4b 61 10 c0 	movl   $0xc010614b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 59 61 10 c0 	movl   $0xc0106159,(%esp)
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
c0100216:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
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
c010025a:	c7 04 24 a7 61 10 c0 	movl   $0xc01061a7,(%esp)
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
c010034a:	e8 34 54 00 00       	call   c0105783 <vprintfmt>
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
c010055a:	c7 00 ac 61 10 c0    	movl   $0xc01061ac,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 ac 61 10 c0 	movl   $0xc01061ac,0x8(%eax)
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
c0100591:	c7 45 f4 80 74 10 c0 	movl   $0xc0107480,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 d8 2d 11 c0 	movl   $0xc0112dd8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec d9 2d 11 c0 	movl   $0xc0112dd9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 86 63 11 c0 	movl   $0xc0116386,-0x18(%ebp)

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
c01006f9:	e8 d2 56 00 00       	call   c0105dd0 <strfind>
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
c010087f:	c7 04 24 b6 61 10 c0 	movl   $0xc01061b6,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 cf 61 10 c0 	movl   $0xc01061cf,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 e4 60 10 	movl   $0xc01060e4,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 e7 61 10 c0 	movl   $0xc01061e7,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 ff 61 10 c0 	movl   $0xc01061ff,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c cf 11 	movl   $0xc011cf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 17 62 10 c0 	movl   $0xc0106217,(%esp)
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
c01008fc:	c7 04 24 30 62 10 c0 	movl   $0xc0106230,(%esp)
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
c0100933:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
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
c01009a1:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
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
c0100a05:	c7 04 24 88 62 10 c0 	movl   $0xc0106288,(%esp)
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
c0100a41:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c0100a48:	e8 09 f9 ff ff       	call   c0100356 <cprintf>

        cprintf("\n");
c0100a4d:	c7 04 24 c1 62 10 c0 	movl   $0xc01062c1,(%esp)
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
c0100ac2:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100ac9:	e8 ce 52 00 00       	call   c0105d9c <strchr>
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
c0100aea:	c7 04 24 49 63 10 c0 	movl   $0xc0106349,(%esp)
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
c0100b2c:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100b33:	e8 64 52 00 00       	call   c0105d9c <strchr>
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
c0100b9d:	e8 5e 51 00 00       	call   c0105d00 <strcmp>
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
c0100be9:	c7 04 24 67 63 10 c0 	movl   $0xc0106367,(%esp)
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
c0100c07:	c7 04 24 80 63 10 c0 	movl   $0xc0106380,(%esp)
c0100c0e:	e8 43 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c13:	c7 04 24 a8 63 10 c0 	movl   $0xc01063a8,(%esp)
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
c0100c30:	c7 04 24 cd 63 10 c0 	movl   $0xc01063cd,(%esp)
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
c0100ca0:	c7 04 24 d1 63 10 c0 	movl   $0xc01063d1,(%esp)
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
c0100d15:	c7 04 24 da 63 10 c0 	movl   $0xc01063da,(%esp)
c0100d1c:	e8 35 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d28:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2b:	89 04 24             	mov    %eax,(%esp)
c0100d2e:	e8 ee f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d33:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
c0100d3a:	e8 17 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3f:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
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
c0100d80:	c7 04 24 0a 64 10 c0 	movl   $0xc010640a,(%esp)
c0100d87:	e8 ca f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d96:	89 04 24             	mov    %eax,(%esp)
c0100d99:	e8 83 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d9e:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
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
c0100e05:	c7 04 24 28 64 10 c0 	movl   $0xc0106428,(%esp)
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
c010126f:	e8 26 4d 00 00       	call   c0105f9a <memmove>
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
c0101601:	c7 04 24 43 64 10 c0 	movl   $0xc0106443,(%esp)
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
c0101678:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
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
c0101933:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
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
c0101a3d:	c7 04 24 8a 64 10 c0 	movl   $0xc010648a,(%esp)
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
c0101a5c:	8b 04 85 e0 67 10 c0 	mov    -0x3fef9820(,%eax,4),%eax
c0101a63:	eb 18                	jmp    c0101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a69:	7e 0d                	jle    c0101a78 <trapname+0x2a>
c0101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6f:	7f 07                	jg     c0101a78 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a71:	b8 8f 64 10 c0       	mov    $0xc010648f,%eax
c0101a76:	eb 05                	jmp    c0101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a78:	b8 a2 64 10 c0       	mov    $0xc01064a2,%eax
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
c0101aa1:	c7 04 24 e3 64 10 c0 	movl   $0xc01064e3,(%esp)
c0101aa8:	e8 a9 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	89 04 24             	mov    %eax,(%esp)
c0101ab3:	e8 8f 01 00 00       	call   c0101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 f4 64 10 c0 	movl   $0xc01064f4,(%esp)
c0101aca:	e8 87 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ada:	c7 04 24 07 65 10 c0 	movl   $0xc0106507,(%esp)
c0101ae1:	e8 70 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af1:	c7 04 24 1a 65 10 c0 	movl   $0xc010651a,(%esp)
c0101af8:	e8 59 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b08:	c7 04 24 2d 65 10 c0 	movl   $0xc010652d,(%esp)
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
c0101b30:	c7 04 24 40 65 10 c0 	movl   $0xc0106540,(%esp)
c0101b37:	e8 1a e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	8b 40 34             	mov    0x34(%eax),%eax
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 52 65 10 c0 	movl   $0xc0106552,(%esp)
c0101b4d:	e8 04 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	8b 40 38             	mov    0x38(%eax),%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 61 65 10 c0 	movl   $0xc0106561,(%esp)
c0101b63:	e8 ee e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b73:	c7 04 24 70 65 10 c0 	movl   $0xc0106570,(%esp)
c0101b7a:	e8 d7 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b82:	8b 40 40             	mov    0x40(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 83 65 10 c0 	movl   $0xc0106583,(%esp)
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
c0101bd0:	c7 04 24 92 65 10 c0 	movl   $0xc0106592,(%esp)
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
c0101bfa:	c7 04 24 96 65 10 c0 	movl   $0xc0106596,(%esp)
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
c0101c1f:	c7 04 24 9f 65 10 c0 	movl   $0xc010659f,(%esp)
c0101c26:	e8 2b e7 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c36:	c7 04 24 ae 65 10 c0 	movl   $0xc01065ae,(%esp)
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
c0101c56:	c7 04 24 c1 65 10 c0 	movl   $0xc01065c1,(%esp)
c0101c5d:	e8 f4 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c65:	8b 40 04             	mov    0x4(%eax),%eax
c0101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6c:	c7 04 24 d0 65 10 c0 	movl   $0xc01065d0,(%esp)
c0101c73:	e8 de e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c82:	c7 04 24 df 65 10 c0 	movl   $0xc01065df,(%esp)
c0101c89:	e8 c8 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c98:	c7 04 24 ee 65 10 c0 	movl   $0xc01065ee,(%esp)
c0101c9f:	e8 b2 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 10             	mov    0x10(%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 fd 65 10 c0 	movl   $0xc01065fd,(%esp)
c0101cb5:	e8 9c e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 0c 66 10 c0 	movl   $0xc010660c,(%esp)
c0101ccb:	e8 86 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 18             	mov    0x18(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 1b 66 10 c0 	movl   $0xc010661b,(%esp)
c0101ce1:	e8 70 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 2a 66 10 c0 	movl   $0xc010662a,(%esp)
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
c0101dac:	c7 04 24 39 66 10 c0 	movl   $0xc0106639,(%esp)
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
c0101dd2:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0101dd9:	e8 78 e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101dde:	eb 55                	jmp    c0101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de0:	c7 44 24 08 5a 66 10 	movl   $0xc010665a,0x8(%esp)
c0101de7:	c0 
c0101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101def:	00 
c0101df0:	c7 04 24 6a 66 10 c0 	movl   $0xc010666a,(%esp)
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
c0101e15:	c7 44 24 08 7b 66 10 	movl   $0xc010667b,0x8(%esp)
c0101e1c:	c0 
c0101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0101e24:	00 
c0101e25:	c7 04 24 6a 66 10 c0 	movl   $0xc010666a,(%esp)
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
c010296a:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102971:	c0 
c0102972:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102979:	c0 
c010297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102981:	00 
c0102982:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
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
c01029c2:	c7 44 24 0c 61 68 10 	movl   $0xc0106861,0xc(%esp)
c01029c9:	c0 
c01029ca:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01029d1:	c0 
c01029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01029d9:	00 
c01029da:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
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
c0102acc:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102ad3:	c0 
c0102ad4:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102adb:	c0 
c0102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102ae3:	00 
c0102ae4:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
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
c0102c59:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c63:	75 24                	jne    c0102c89 <default_free_pages+0x33>
c0102c65:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102c6c:	c0 
c0102c6d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102c74:	c0 
c0102c75:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0102c7c:	00 
c0102c7d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102c84:	e8 5f e0 ff ff       	call   c0100ce8 <__panic>
//        cprintf("le:%x page:%x",le1 , p1);
//        le1=list_next(le1);
//    }
//    cprintf("\n\n");

    struct Page *p = base;
c0102c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++) {
c0102c8f:	e9 9d 00 00 00       	jmp    c0102d31 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c97:	83 c0 04             	add    $0x4,%eax
c0102c9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ca7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102caa:	0f a3 10             	bt     %edx,(%eax)
c0102cad:	19 c0                	sbb    %eax,%eax
c0102caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102cb6:	0f 95 c0             	setne  %al
c0102cb9:	0f b6 c0             	movzbl %al,%eax
c0102cbc:	85 c0                	test   %eax,%eax
c0102cbe:	75 2c                	jne    c0102cec <default_free_pages+0x96>
c0102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cc3:	83 c0 04             	add    $0x4,%eax
c0102cc6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102ccd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cd3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cd6:	0f a3 10             	bt     %edx,(%eax)
c0102cd9:	19 c0                	sbb    %eax,%eax
c0102cdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102cde:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102ce2:	0f 95 c0             	setne  %al
c0102ce5:	0f b6 c0             	movzbl %al,%eax
c0102ce8:	85 c0                	test   %eax,%eax
c0102cea:	74 24                	je     c0102d10 <default_free_pages+0xba>
c0102cec:	c7 44 24 0c 74 68 10 	movl   $0xc0106874,0xc(%esp)
c0102cf3:	c0 
c0102cf4:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102cfb:	c0 
c0102cfc:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0102d03:	00 
c0102d04:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102d0b:	e8 d8 df ff ff       	call   c0100ce8 <__panic>
        p->flags = 0;
c0102d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d21:	00 
c0102d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d25:	89 04 24             	mov    %eax,(%esp)
c0102d28:	e8 f2 fb ff ff       	call   c010291f <set_page_ref>
    for (; p != base + n; p++) {
c0102d2d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d31:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d34:	89 d0                	mov    %edx,%eax
c0102d36:	c1 e0 02             	shl    $0x2,%eax
c0102d39:	01 d0                	add    %edx,%eax
c0102d3b:	c1 e0 02             	shl    $0x2,%eax
c0102d3e:	89 c2                	mov    %eax,%edx
c0102d40:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d43:	01 d0                	add    %edx,%eax
c0102d45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102d48:	0f 85 46 ff ff ff    	jne    c0102c94 <default_free_pages+0x3e>
    }
    base->property = n;
c0102d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d54:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5a:	83 c0 04             	add    $0x4,%eax
c0102d5d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102d64:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d67:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d6a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d6d:	0f ab 10             	bts    %edx,(%eax)
}
c0102d70:	90                   	nop
c0102d71:	c7 45 d4 80 ce 11 c0 	movl   $0xc011ce80,-0x2c(%ebp)
    return listelm->next;
c0102d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d7b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d81:	e9 0e 01 00 00       	jmp    c0102e94 <default_free_pages+0x23e>
        p = le2page(le, page_link);
c0102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d89:	83 e8 0c             	sub    $0xc,%eax
c0102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d92:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d95:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d98:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da1:	8b 50 08             	mov    0x8(%eax),%edx
c0102da4:	89 d0                	mov    %edx,%eax
c0102da6:	c1 e0 02             	shl    $0x2,%eax
c0102da9:	01 d0                	add    %edx,%eax
c0102dab:	c1 e0 02             	shl    $0x2,%eax
c0102dae:	89 c2                	mov    %eax,%edx
c0102db0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db3:	01 d0                	add    %edx,%eax
c0102db5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102db8:	75 5d                	jne    c0102e17 <default_free_pages+0x1c1>
            base->property += p->property;
c0102dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbd:	8b 50 08             	mov    0x8(%eax),%edx
c0102dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc3:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc6:	01 c2                	add    %eax,%edx
c0102dc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd1:	83 c0 04             	add    $0x4,%eax
c0102dd4:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102de1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102de4:	0f b3 10             	btr    %edx,(%eax)
}
c0102de7:	90                   	nop
            list_del(&(p->page_link));
c0102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102deb:	83 c0 0c             	add    $0xc,%eax
c0102dee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102df1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102df4:	8b 40 04             	mov    0x4(%eax),%eax
c0102df7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102dfa:	8b 12                	mov    (%edx),%edx
c0102dfc:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102dff:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102e02:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e05:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e08:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e0b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102e0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102e11:	89 10                	mov    %edx,(%eax)
}
c0102e13:	90                   	nop
}
c0102e14:	90                   	nop
c0102e15:	eb 7d                	jmp    c0102e94 <default_free_pages+0x23e>
        } else if (p + p->property == base) {
c0102e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1a:	8b 50 08             	mov    0x8(%eax),%edx
c0102e1d:	89 d0                	mov    %edx,%eax
c0102e1f:	c1 e0 02             	shl    $0x2,%eax
c0102e22:	01 d0                	add    %edx,%eax
c0102e24:	c1 e0 02             	shl    $0x2,%eax
c0102e27:	89 c2                	mov    %eax,%edx
c0102e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2c:	01 d0                	add    %edx,%eax
c0102e2e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e31:	75 61                	jne    c0102e94 <default_free_pages+0x23e>
            p->property += base->property;
c0102e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e36:	8b 50 08             	mov    0x8(%eax),%edx
c0102e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3c:	8b 40 08             	mov    0x8(%eax),%eax
c0102e3f:	01 c2                	add    %eax,%edx
c0102e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e44:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4a:	83 c0 04             	add    $0x4,%eax
c0102e4d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102e54:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e57:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e5a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e5d:	0f b3 10             	btr    %edx,(%eax)
}
c0102e60:	90                   	nop
            base = p;//?
c0102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e64:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6a:	83 c0 0c             	add    $0xc,%eax
c0102e6d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e70:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e73:	8b 40 04             	mov    0x4(%eax),%eax
c0102e76:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e79:	8b 12                	mov    (%edx),%edx
c0102e7b:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102e7e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102e81:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e84:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e8a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e8d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e90:	89 10                	mov    %edx,(%eax)
}
c0102e92:	90                   	nop
}
c0102e93:	90                   	nop
    while (le != &free_list) {
c0102e94:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102e9b:	0f 85 e5 fe ff ff    	jne    c0102d86 <default_free_pages+0x130>
        }
    }


    cprintf("%d",nr_free);
c0102ea1:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102eaa:	c7 04 24 99 68 10 c0 	movl   $0xc0106899,(%esp)
c0102eb1:	e8 a0 d4 ff ff       	call   c0100356 <cprintf>
    nr_free += n;
c0102eb6:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ebf:	01 d0                	add    %edx,%eax
c0102ec1:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
    cprintf("%d",nr_free);
c0102ec6:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102ecf:	c7 04 24 99 68 10 c0 	movl   $0xc0106899,(%esp)
c0102ed6:	e8 7b d4 ff ff       	call   c0100356 <cprintf>
c0102edb:	c7 45 9c 80 ce 11 c0 	movl   $0xc011ce80,-0x64(%ebp)
    return listelm->next;
c0102ee2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102ee5:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102eeb:	eb 34                	jmp    c0102f21 <default_free_pages+0x2cb>
        p = le2page(le, page_link);
c0102eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ef0:	83 e8 0c             	sub    $0xc,%eax
c0102ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ef9:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102efc:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102eff:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property < p) {
c0102f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f08:	8b 50 08             	mov    0x8(%eax),%edx
c0102f0b:	89 d0                	mov    %edx,%eax
c0102f0d:	c1 e0 02             	shl    $0x2,%eax
c0102f10:	01 d0                	add    %edx,%eax
c0102f12:	c1 e0 02             	shl    $0x2,%eax
c0102f15:	89 c2                	mov    %eax,%edx
c0102f17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f1a:	01 d0                	add    %edx,%eax
c0102f1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102f1f:	77 0b                	ja     c0102f2c <default_free_pages+0x2d6>
    while (le != &free_list) {
c0102f21:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102f28:	75 c3                	jne    c0102eed <default_free_pages+0x297>
c0102f2a:	eb 01                	jmp    c0102f2d <default_free_pages+0x2d7>
            break;
c0102f2c:	90                   	nop
        }

    }

    //这里理解为什么要用add——before，因为是FF，先进先出
    list_add_before(le, &(base->page_link));
c0102f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f30:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f36:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f39:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102f3c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f3f:	8b 00                	mov    (%eax),%eax
c0102f41:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f44:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102f47:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102f4a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f4d:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102f50:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f53:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102f56:	89 10                	mov    %edx,(%eax)
c0102f58:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f5b:	8b 10                	mov    (%eax),%edx
c0102f5d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f60:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f63:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f66:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f69:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f6c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f6f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102f72:	89 10                	mov    %edx,(%eax)
}
c0102f74:	90                   	nop
}
c0102f75:	90                   	nop
//        cprintf("le:%x page:%x",le1 , p1);
//        le1=list_next(le1);
//    }
//    cprintf("\n\n");

}
c0102f76:	90                   	nop
c0102f77:	89 ec                	mov    %ebp,%esp
c0102f79:	5d                   	pop    %ebp
c0102f7a:	c3                   	ret    

c0102f7b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102f7b:	55                   	push   %ebp
c0102f7c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102f7e:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
}
c0102f83:	5d                   	pop    %ebp
c0102f84:	c3                   	ret    

c0102f85 <basic_check>:

static void
basic_check(void) {
c0102f85:	55                   	push   %ebp
c0102f86:	89 e5                	mov    %esp,%ebp
c0102f88:	83 ec 58             	sub    $0x58,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f95:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fa5:	e8 9f 0f 00 00       	call   c0103f49 <alloc_pages>
c0102faa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102fad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102fb1:	75 24                	jne    c0102fd7 <basic_check+0x52>
c0102fb3:	c7 44 24 0c 9c 68 10 	movl   $0xc010689c,0xc(%esp)
c0102fba:	c0 
c0102fbb:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102fc2:	c0 
c0102fc3:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0102fca:	00 
c0102fcb:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102fd2:	e8 11 dd ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102fd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fde:	e8 66 0f 00 00       	call   c0103f49 <alloc_pages>
c0102fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102fe6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102fea:	75 24                	jne    c0103010 <basic_check+0x8b>
c0102fec:	c7 44 24 0c b8 68 10 	movl   $0xc01068b8,0xc(%esp)
c0102ff3:	c0 
c0102ff4:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102ffb:	c0 
c0102ffc:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103003:	00 
c0103004:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010300b:	e8 d8 dc ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103010:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103017:	e8 2d 0f 00 00       	call   c0103f49 <alloc_pages>
c010301c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010301f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103023:	75 24                	jne    c0103049 <basic_check+0xc4>
c0103025:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c010302c:	c0 
c010302d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103034:	c0 
c0103035:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010303c:	00 
c010303d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103044:	e8 9f dc ff ff       	call   c0100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103049:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010304c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010304f:	74 10                	je     c0103061 <basic_check+0xdc>
c0103051:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103054:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103057:	74 08                	je     c0103061 <basic_check+0xdc>
c0103059:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010305c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010305f:	75 24                	jne    c0103085 <basic_check+0x100>
c0103061:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c0103068:	c0 
c0103069:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103070:	c0 
c0103071:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103078:	00 
c0103079:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103080:	e8 63 dc ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103085:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103088:	89 04 24             	mov    %eax,(%esp)
c010308b:	e8 85 f8 ff ff       	call   c0102915 <page_ref>
c0103090:	85 c0                	test   %eax,%eax
c0103092:	75 1e                	jne    c01030b2 <basic_check+0x12d>
c0103094:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103097:	89 04 24             	mov    %eax,(%esp)
c010309a:	e8 76 f8 ff ff       	call   c0102915 <page_ref>
c010309f:	85 c0                	test   %eax,%eax
c01030a1:	75 0f                	jne    c01030b2 <basic_check+0x12d>
c01030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030a6:	89 04 24             	mov    %eax,(%esp)
c01030a9:	e8 67 f8 ff ff       	call   c0102915 <page_ref>
c01030ae:	85 c0                	test   %eax,%eax
c01030b0:	74 24                	je     c01030d6 <basic_check+0x151>
c01030b2:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c01030b9:	c0 
c01030ba:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01030c1:	c0 
c01030c2:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01030c9:	00 
c01030ca:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01030d1:	e8 12 dc ff ff       	call   c0100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030d9:	89 04 24             	mov    %eax,(%esp)
c01030dc:	e8 1c f8 ff ff       	call   c01028fd <page2pa>
c01030e1:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01030e7:	c1 e2 0c             	shl    $0xc,%edx
c01030ea:	39 d0                	cmp    %edx,%eax
c01030ec:	72 24                	jb     c0103112 <basic_check+0x18d>
c01030ee:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c01030f5:	c0 
c01030f6:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01030fd:	c0 
c01030fe:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103105:	00 
c0103106:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010310d:	e8 d6 db ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103112:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103115:	89 04 24             	mov    %eax,(%esp)
c0103118:	e8 e0 f7 ff ff       	call   c01028fd <page2pa>
c010311d:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103123:	c1 e2 0c             	shl    $0xc,%edx
c0103126:	39 d0                	cmp    %edx,%eax
c0103128:	72 24                	jb     c010314e <basic_check+0x1c9>
c010312a:	c7 44 24 0c 6d 69 10 	movl   $0xc010696d,0xc(%esp)
c0103131:	c0 
c0103132:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103139:	c0 
c010313a:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103141:	00 
c0103142:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103149:	e8 9a db ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010314e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103151:	89 04 24             	mov    %eax,(%esp)
c0103154:	e8 a4 f7 ff ff       	call   c01028fd <page2pa>
c0103159:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c010315f:	c1 e2 0c             	shl    $0xc,%edx
c0103162:	39 d0                	cmp    %edx,%eax
c0103164:	72 24                	jb     c010318a <basic_check+0x205>
c0103166:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c010316d:	c0 
c010316e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103175:	c0 
c0103176:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010317d:	00 
c010317e:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103185:	e8 5e db ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c010318a:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010318f:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c0103195:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103198:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010319b:	c7 45 d4 80 ce 11 c0 	movl   $0xc011ce80,-0x2c(%ebp)
    elm->prev = elm->next = elm;
c01031a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01031a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031a8:	89 50 04             	mov    %edx,0x4(%eax)
c01031ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01031ae:	8b 50 04             	mov    0x4(%eax),%edx
c01031b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01031b4:	89 10                	mov    %edx,(%eax)
}
c01031b6:	90                   	nop
c01031b7:	c7 45 d8 80 ce 11 c0 	movl   $0xc011ce80,-0x28(%ebp)
    return list->next == list;
c01031be:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01031c1:	8b 40 04             	mov    0x4(%eax),%eax
c01031c4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01031c7:	0f 94 c0             	sete   %al
c01031ca:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01031cd:	85 c0                	test   %eax,%eax
c01031cf:	75 24                	jne    c01031f5 <basic_check+0x270>
c01031d1:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c01031d8:	c0 
c01031d9:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01031e0:	c0 
c01031e1:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01031e8:	00 
c01031e9:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01031f0:	e8 f3 da ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c01031f5:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01031fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01031fd:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c0103204:	00 00 00 

    assert(alloc_page() == NULL);
c0103207:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010320e:	e8 36 0d 00 00       	call   c0103f49 <alloc_pages>
c0103213:	85 c0                	test   %eax,%eax
c0103215:	74 24                	je     c010323b <basic_check+0x2b6>
c0103217:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c010321e:	c0 
c010321f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103226:	c0 
c0103227:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010322e:	00 
c010322f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103236:	e8 ad da ff ff       	call   c0100ce8 <__panic>

    free_page(p0);
c010323b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103242:	00 
c0103243:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103246:	89 04 24             	mov    %eax,(%esp)
c0103249:	e8 35 0d 00 00       	call   c0103f83 <free_pages>
    free_page(p1);
c010324e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103255:	00 
c0103256:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103259:	89 04 24             	mov    %eax,(%esp)
c010325c:	e8 22 0d 00 00       	call   c0103f83 <free_pages>
    free_page(p2);
c0103261:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103268:	00 
c0103269:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010326c:	89 04 24             	mov    %eax,(%esp)
c010326f:	e8 0f 0d 00 00       	call   c0103f83 <free_pages>
    assert(nr_free == 3);
c0103274:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103279:	83 f8 03             	cmp    $0x3,%eax
c010327c:	74 24                	je     c01032a2 <basic_check+0x31d>
c010327e:	c7 44 24 0c d3 69 10 	movl   $0xc01069d3,0xc(%esp)
c0103285:	c0 
c0103286:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010328d:	c0 
c010328e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103295:	00 
c0103296:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010329d:	e8 46 da ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01032a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032a9:	e8 9b 0c 00 00       	call   c0103f49 <alloc_pages>
c01032ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032b5:	75 24                	jne    c01032db <basic_check+0x356>
c01032b7:	c7 44 24 0c 9c 68 10 	movl   $0xc010689c,0xc(%esp)
c01032be:	c0 
c01032bf:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01032c6:	c0 
c01032c7:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01032ce:	00 
c01032cf:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01032d6:	e8 0d da ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01032db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032e2:	e8 62 0c 00 00       	call   c0103f49 <alloc_pages>
c01032e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01032ee:	75 24                	jne    c0103314 <basic_check+0x38f>
c01032f0:	c7 44 24 0c b8 68 10 	movl   $0xc01068b8,0xc(%esp)
c01032f7:	c0 
c01032f8:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01032ff:	c0 
c0103300:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103307:	00 
c0103308:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010330f:	e8 d4 d9 ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103314:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010331b:	e8 29 0c 00 00       	call   c0103f49 <alloc_pages>
c0103320:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103327:	75 24                	jne    c010334d <basic_check+0x3c8>
c0103329:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c0103330:	c0 
c0103331:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103338:	c0 
c0103339:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103340:	00 
c0103341:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103348:	e8 9b d9 ff ff       	call   c0100ce8 <__panic>

    assert(alloc_page() == NULL);
c010334d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103354:	e8 f0 0b 00 00       	call   c0103f49 <alloc_pages>
c0103359:	85 c0                	test   %eax,%eax
c010335b:	74 24                	je     c0103381 <basic_check+0x3fc>
c010335d:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103364:	c0 
c0103365:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010336c:	c0 
c010336d:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103374:	00 
c0103375:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010337c:	e8 67 d9 ff ff       	call   c0100ce8 <__panic>
c0103381:	c7 45 d0 80 ce 11 c0 	movl   $0xc011ce80,-0x30(%ebp)
    return listelm->next;
c0103388:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010338b:	8b 40 04             	mov    0x4(%eax),%eax

    struct Page *pp1;

    list_entry_t *le1 = list_next(&free_list);
c010338e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c0103391:	eb 32                	jmp    c01033c5 <basic_check+0x440>
        pp1 = le2page(le1, page_link);
c0103393:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103396:	83 e8 0c             	sub    $0xc,%eax
c0103399:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010339f:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01033a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033a5:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c01033a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c01033ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033ae:	89 44 24 08          	mov    %eax,0x8(%esp)
c01033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033b9:	c7 04 24 e0 69 10 c0 	movl   $0xc01069e0,(%esp)
c01033c0:	e8 91 cf ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c01033c5:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c01033cc:	75 c5                	jne    c0103393 <basic_check+0x40e>
    }
    cprintf("\n\n");
c01033ce:	c7 04 24 ee 69 10 c0 	movl   $0xc01069ee,(%esp)
c01033d5:	e8 7c cf ff ff       	call   c0100356 <cprintf>

    free_page(p0);
c01033da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033e1:	00 
c01033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033e5:	89 04 24             	mov    %eax,(%esp)
c01033e8:	e8 96 0b 00 00       	call   c0103f83 <free_pages>
c01033ed:	c7 45 c8 80 ce 11 c0 	movl   $0xc011ce80,-0x38(%ebp)
c01033f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033f7:	8b 40 04             	mov    0x4(%eax),%eax

    le1 = list_next(&free_list);
c01033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c01033fd:	eb 32                	jmp    c0103431 <basic_check+0x4ac>
        pp1 = le2page(le1, page_link);
c01033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103402:	83 e8 0c             	sub    $0xc,%eax
c0103405:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010340e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103411:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c0103414:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c0103417:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010341a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103421:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103425:	c7 04 24 e0 69 10 c0 	movl   $0xc01069e0,(%esp)
c010342c:	e8 25 cf ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c0103431:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c0103438:	75 c5                	jne    c01033ff <basic_check+0x47a>
    }
    cprintf("\n\n");
c010343a:	c7 04 24 ee 69 10 c0 	movl   $0xc01069ee,(%esp)
c0103441:	e8 10 cf ff ff       	call   c0100356 <cprintf>
c0103446:	c7 45 c0 80 ce 11 c0 	movl   $0xc011ce80,-0x40(%ebp)
    return list->next == list;
c010344d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103450:	8b 40 04             	mov    0x4(%eax),%eax
c0103453:	39 45 c0             	cmp    %eax,-0x40(%ebp)
c0103456:	0f 94 c0             	sete   %al
c0103459:	0f b6 c0             	movzbl %al,%eax


    assert(!list_empty(&free_list));
c010345c:	85 c0                	test   %eax,%eax
c010345e:	74 24                	je     c0103484 <basic_check+0x4ff>
c0103460:	c7 44 24 0c f1 69 10 	movl   $0xc01069f1,0xc(%esp)
c0103467:	c0 
c0103468:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010346f:	c0 
c0103470:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103477:	00 
c0103478:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010347f:	e8 64 d8 ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103484:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010348b:	e8 b9 0a 00 00       	call   c0103f49 <alloc_pages>
c0103490:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103493:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103496:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103499:	74 24                	je     c01034bf <basic_check+0x53a>
c010349b:	c7 44 24 0c 09 6a 10 	movl   $0xc0106a09,0xc(%esp)
c01034a2:	c0 
c01034a3:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01034aa:	c0 
c01034ab:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01034b2:	00 
c01034b3:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01034ba:	e8 29 d8 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c01034bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034c6:	e8 7e 0a 00 00       	call   c0103f49 <alloc_pages>
c01034cb:	85 c0                	test   %eax,%eax
c01034cd:	74 24                	je     c01034f3 <basic_check+0x56e>
c01034cf:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c01034d6:	c0 
c01034d7:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01034de:	c0 
c01034df:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01034e6:	00 
c01034e7:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01034ee:	e8 f5 d7 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c01034f3:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01034f8:	85 c0                	test   %eax,%eax
c01034fa:	74 24                	je     c0103520 <basic_check+0x59b>
c01034fc:	c7 44 24 0c 22 6a 10 	movl   $0xc0106a22,0xc(%esp)
c0103503:	c0 
c0103504:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010350b:	c0 
c010350c:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103513:	00 
c0103514:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010351b:	e8 c8 d7 ff ff       	call   c0100ce8 <__panic>
    free_list = free_list_store;
c0103520:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103523:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103526:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c010352b:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    nr_free = nr_free_store;
c0103531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103534:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_page(p);
c0103539:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103540:	00 
c0103541:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103544:	89 04 24             	mov    %eax,(%esp)
c0103547:	e8 37 0a 00 00       	call   c0103f83 <free_pages>
    free_page(p1);
c010354c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103553:	00 
c0103554:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103557:	89 04 24             	mov    %eax,(%esp)
c010355a:	e8 24 0a 00 00       	call   c0103f83 <free_pages>
    free_page(p2);
c010355f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103566:	00 
c0103567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010356a:	89 04 24             	mov    %eax,(%esp)
c010356d:	e8 11 0a 00 00       	call   c0103f83 <free_pages>
}
c0103572:	90                   	nop
c0103573:	89 ec                	mov    %ebp,%esp
c0103575:	5d                   	pop    %ebp
c0103576:	c3                   	ret    

c0103577 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103577:	55                   	push   %ebp
c0103578:	89 e5                	mov    %esp,%ebp
c010357a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103587:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010358e:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103595:	eb 6a                	jmp    c0103601 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0103597:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010359a:	83 e8 0c             	sub    $0xc,%eax
c010359d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035a3:	83 c0 04             	add    $0x4,%eax
c01035a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035b3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035b6:	0f a3 10             	bt     %edx,(%eax)
c01035b9:	19 c0                	sbb    %eax,%eax
c01035bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035c2:	0f 95 c0             	setne  %al
c01035c5:	0f b6 c0             	movzbl %al,%eax
c01035c8:	85 c0                	test   %eax,%eax
c01035ca:	75 24                	jne    c01035f0 <default_check+0x79>
c01035cc:	c7 44 24 0c 2f 6a 10 	movl   $0xc0106a2f,0xc(%esp)
c01035d3:	c0 
c01035d4:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01035db:	c0 
c01035dc:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01035e3:	00 
c01035e4:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01035eb:	e8 f8 d6 ff ff       	call   c0100ce8 <__panic>
        count++, total += p->property;
c01035f0:	ff 45 f4             	incl   -0xc(%ebp)
c01035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035f6:	8b 50 08             	mov    0x8(%eax),%edx
c01035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035fc:	01 d0                	add    %edx,%eax
c01035fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103601:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103604:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103607:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010360a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010360d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103610:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103617:	0f 85 7a ff ff ff    	jne    c0103597 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010361d:	e8 96 09 00 00       	call   c0103fb8 <nr_free_pages>
c0103622:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103625:	39 d0                	cmp    %edx,%eax
c0103627:	74 24                	je     c010364d <default_check+0xd6>
c0103629:	c7 44 24 0c 3f 6a 10 	movl   $0xc0106a3f,0xc(%esp)
c0103630:	c0 
c0103631:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103638:	c0 
c0103639:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103640:	00 
c0103641:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103648:	e8 9b d6 ff ff       	call   c0100ce8 <__panic>

    basic_check();
c010364d:	e8 33 f9 ff ff       	call   c0102f85 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103652:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103659:	e8 eb 08 00 00       	call   c0103f49 <alloc_pages>
c010365e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103661:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103665:	75 24                	jne    c010368b <default_check+0x114>
c0103667:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c010366e:	c0 
c010366f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103676:	c0 
c0103677:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c010367e:	00 
c010367f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103686:	e8 5d d6 ff ff       	call   c0100ce8 <__panic>
    assert(!PageProperty(p0));
c010368b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010368e:	83 c0 04             	add    $0x4,%eax
c0103691:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103698:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010369b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010369e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036a1:	0f a3 10             	bt     %edx,(%eax)
c01036a4:	19 c0                	sbb    %eax,%eax
c01036a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036a9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036ad:	0f 95 c0             	setne  %al
c01036b0:	0f b6 c0             	movzbl %al,%eax
c01036b3:	85 c0                	test   %eax,%eax
c01036b5:	74 24                	je     c01036db <default_check+0x164>
c01036b7:	c7 44 24 0c 63 6a 10 	movl   $0xc0106a63,0xc(%esp)
c01036be:	c0 
c01036bf:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01036c6:	c0 
c01036c7:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01036ce:	00 
c01036cf:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01036d6:	e8 0d d6 ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c01036db:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01036e0:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c01036e6:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036e9:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036ec:	c7 45 b0 80 ce 11 c0 	movl   $0xc011ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01036f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01036f9:	89 50 04             	mov    %edx,0x4(%eax)
c01036fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036ff:	8b 50 04             	mov    0x4(%eax),%edx
c0103702:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103705:	89 10                	mov    %edx,(%eax)
}
c0103707:	90                   	nop
c0103708:	c7 45 b4 80 ce 11 c0 	movl   $0xc011ce80,-0x4c(%ebp)
    return list->next == list;
c010370f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103712:	8b 40 04             	mov    0x4(%eax),%eax
c0103715:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103718:	0f 94 c0             	sete   %al
c010371b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010371e:	85 c0                	test   %eax,%eax
c0103720:	75 24                	jne    c0103746 <default_check+0x1cf>
c0103722:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c0103729:	c0 
c010372a:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103731:	c0 
c0103732:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0103739:	00 
c010373a:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103741:	e8 a2 d5 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103746:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010374d:	e8 f7 07 00 00       	call   c0103f49 <alloc_pages>
c0103752:	85 c0                	test   %eax,%eax
c0103754:	74 24                	je     c010377a <default_check+0x203>
c0103756:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c010375d:	c0 
c010375e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103765:	c0 
c0103766:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010376d:	00 
c010376e:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103775:	e8 6e d5 ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c010377a:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c010377f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103782:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c0103789:	00 00 00 

    free_pages(p0 + 2, 3);
c010378c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010378f:	83 c0 28             	add    $0x28,%eax
c0103792:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103799:	00 
c010379a:	89 04 24             	mov    %eax,(%esp)
c010379d:	e8 e1 07 00 00       	call   c0103f83 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037a2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037a9:	e8 9b 07 00 00       	call   c0103f49 <alloc_pages>
c01037ae:	85 c0                	test   %eax,%eax
c01037b0:	74 24                	je     c01037d6 <default_check+0x25f>
c01037b2:	c7 44 24 0c 75 6a 10 	movl   $0xc0106a75,0xc(%esp)
c01037b9:	c0 
c01037ba:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01037c1:	c0 
c01037c2:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c01037c9:	00 
c01037ca:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01037d1:	e8 12 d5 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037d9:	83 c0 28             	add    $0x28,%eax
c01037dc:	83 c0 04             	add    $0x4,%eax
c01037df:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037e6:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037e9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037ec:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037ef:	0f a3 10             	bt     %edx,(%eax)
c01037f2:	19 c0                	sbb    %eax,%eax
c01037f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01037f7:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01037fb:	0f 95 c0             	setne  %al
c01037fe:	0f b6 c0             	movzbl %al,%eax
c0103801:	85 c0                	test   %eax,%eax
c0103803:	74 0e                	je     c0103813 <default_check+0x29c>
c0103805:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103808:	83 c0 28             	add    $0x28,%eax
c010380b:	8b 40 08             	mov    0x8(%eax),%eax
c010380e:	83 f8 03             	cmp    $0x3,%eax
c0103811:	74 24                	je     c0103837 <default_check+0x2c0>
c0103813:	c7 44 24 0c 8c 6a 10 	movl   $0xc0106a8c,0xc(%esp)
c010381a:	c0 
c010381b:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103822:	c0 
c0103823:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c010382a:	00 
c010382b:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103832:	e8 b1 d4 ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103837:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010383e:	e8 06 07 00 00       	call   c0103f49 <alloc_pages>
c0103843:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103846:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010384a:	75 24                	jne    c0103870 <default_check+0x2f9>
c010384c:	c7 44 24 0c b8 6a 10 	movl   $0xc0106ab8,0xc(%esp)
c0103853:	c0 
c0103854:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010385b:	c0 
c010385c:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103863:	00 
c0103864:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010386b:	e8 78 d4 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103870:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103877:	e8 cd 06 00 00       	call   c0103f49 <alloc_pages>
c010387c:	85 c0                	test   %eax,%eax
c010387e:	74 24                	je     c01038a4 <default_check+0x32d>
c0103880:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103887:	c0 
c0103888:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010388f:	c0 
c0103890:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0103897:	00 
c0103898:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010389f:	e8 44 d4 ff ff       	call   c0100ce8 <__panic>
    assert(p0 + 2 == p1);
c01038a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038a7:	83 c0 28             	add    $0x28,%eax
c01038aa:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01038ad:	74 24                	je     c01038d3 <default_check+0x35c>
c01038af:	c7 44 24 0c d6 6a 10 	movl   $0xc0106ad6,0xc(%esp)
c01038b6:	c0 
c01038b7:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01038be:	c0 
c01038bf:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c01038c6:	00 
c01038c7:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01038ce:	e8 15 d4 ff ff       	call   c0100ce8 <__panic>

    //h
    p2 = p0 + 1;
c01038d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038d6:	83 c0 14             	add    $0x14,%eax
c01038d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038e3:	00 
c01038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038e7:	89 04 24             	mov    %eax,(%esp)
c01038ea:	e8 94 06 00 00       	call   c0103f83 <free_pages>
    free_pages(p1, 3);
c01038ef:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01038f6:	00 
c01038f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038fa:	89 04 24             	mov    %eax,(%esp)
c01038fd:	e8 81 06 00 00       	call   c0103f83 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103902:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103905:	83 c0 04             	add    $0x4,%eax
c0103908:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010390f:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103912:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103915:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103918:	0f a3 10             	bt     %edx,(%eax)
c010391b:	19 c0                	sbb    %eax,%eax
c010391d:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103920:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103924:	0f 95 c0             	setne  %al
c0103927:	0f b6 c0             	movzbl %al,%eax
c010392a:	85 c0                	test   %eax,%eax
c010392c:	74 0b                	je     c0103939 <default_check+0x3c2>
c010392e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103931:	8b 40 08             	mov    0x8(%eax),%eax
c0103934:	83 f8 01             	cmp    $0x1,%eax
c0103937:	74 24                	je     c010395d <default_check+0x3e6>
c0103939:	c7 44 24 0c e4 6a 10 	movl   $0xc0106ae4,0xc(%esp)
c0103940:	c0 
c0103941:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103948:	c0 
c0103949:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
c0103950:	00 
c0103951:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103958:	e8 8b d3 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010395d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103960:	83 c0 04             	add    $0x4,%eax
c0103963:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010396a:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010396d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103970:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103973:	0f a3 10             	bt     %edx,(%eax)
c0103976:	19 c0                	sbb    %eax,%eax
c0103978:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010397b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010397f:	0f 95 c0             	setne  %al
c0103982:	0f b6 c0             	movzbl %al,%eax
c0103985:	85 c0                	test   %eax,%eax
c0103987:	74 0b                	je     c0103994 <default_check+0x41d>
c0103989:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010398c:	8b 40 08             	mov    0x8(%eax),%eax
c010398f:	83 f8 03             	cmp    $0x3,%eax
c0103992:	74 24                	je     c01039b8 <default_check+0x441>
c0103994:	c7 44 24 0c 0c 6b 10 	movl   $0xc0106b0c,0xc(%esp)
c010399b:	c0 
c010399c:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01039a3:	c0 
c01039a4:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c01039ab:	00 
c01039ac:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01039b3:	e8 30 d3 ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039bf:	e8 85 05 00 00       	call   c0103f49 <alloc_pages>
c01039c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039ca:	83 e8 14             	sub    $0x14,%eax
c01039cd:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039d0:	74 24                	je     c01039f6 <default_check+0x47f>
c01039d2:	c7 44 24 0c 32 6b 10 	movl   $0xc0106b32,0xc(%esp)
c01039d9:	c0 
c01039da:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01039e1:	c0 
c01039e2:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c01039e9:	00 
c01039ea:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01039f1:	e8 f2 d2 ff ff       	call   c0100ce8 <__panic>
    free_page(p0);
c01039f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039fd:	00 
c01039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a01:	89 04 24             	mov    %eax,(%esp)
c0103a04:	e8 7a 05 00 00       	call   c0103f83 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a09:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a10:	e8 34 05 00 00       	call   c0103f49 <alloc_pages>
c0103a15:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a1b:	83 c0 14             	add    $0x14,%eax
c0103a1e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a21:	74 24                	je     c0103a47 <default_check+0x4d0>
c0103a23:	c7 44 24 0c 50 6b 10 	movl   $0xc0106b50,0xc(%esp)
c0103a2a:	c0 
c0103a2b:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a32:	c0 
c0103a33:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0103a3a:	00 
c0103a3b:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a42:	e8 a1 d2 ff ff       	call   c0100ce8 <__panic>

    free_pages(p0, 2);
c0103a47:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a4e:	00 
c0103a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a52:	89 04 24             	mov    %eax,(%esp)
c0103a55:	e8 29 05 00 00       	call   c0103f83 <free_pages>
    free_page(p2);
c0103a5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a61:	00 
c0103a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a65:	89 04 24             	mov    %eax,(%esp)
c0103a68:	e8 16 05 00 00       	call   c0103f83 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a6d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a74:	e8 d0 04 00 00       	call   c0103f49 <alloc_pages>
c0103a79:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103a80:	75 24                	jne    c0103aa6 <default_check+0x52f>
c0103a82:	c7 44 24 0c 70 6b 10 	movl   $0xc0106b70,0xc(%esp)
c0103a89:	c0 
c0103a8a:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a91:	c0 
c0103a92:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0103a99:	00 
c0103a9a:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103aa1:	e8 42 d2 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103aa6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aad:	e8 97 04 00 00       	call   c0103f49 <alloc_pages>
c0103ab2:	85 c0                	test   %eax,%eax
c0103ab4:	74 24                	je     c0103ada <default_check+0x563>
c0103ab6:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103abd:	c0 
c0103abe:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103ac5:	c0 
c0103ac6:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
c0103acd:	00 
c0103ace:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103ad5:	e8 0e d2 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c0103ada:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103adf:	85 c0                	test   %eax,%eax
c0103ae1:	74 24                	je     c0103b07 <default_check+0x590>
c0103ae3:	c7 44 24 0c 22 6a 10 	movl   $0xc0106a22,0xc(%esp)
c0103aea:	c0 
c0103aeb:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103af2:	c0 
c0103af3:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c0103afa:	00 
c0103afb:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b02:	e8 e1 d1 ff ff       	call   c0100ce8 <__panic>
    nr_free = nr_free_store;
c0103b07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b0a:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_list = free_list_store;
c0103b0f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b12:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b15:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103b1a:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    free_pages(p0, 5);
c0103b20:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b27:	00 
c0103b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b2b:	89 04 24             	mov    %eax,(%esp)
c0103b2e:	e8 50 04 00 00       	call   c0103f83 <free_pages>

    le = &free_list;
c0103b33:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b3a:	eb 5a                	jmp    c0103b96 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b42:	8b 00                	mov    (%eax),%eax
c0103b44:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b47:	75 0d                	jne    c0103b56 <default_check+0x5df>
c0103b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b4c:	8b 00                	mov    (%eax),%eax
c0103b4e:	8b 40 04             	mov    0x4(%eax),%eax
c0103b51:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b54:	74 24                	je     c0103b7a <default_check+0x603>
c0103b56:	c7 44 24 0c 90 6b 10 	movl   $0xc0106b90,0xc(%esp)
c0103b5d:	c0 
c0103b5e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 04 62 01 00 	movl   $0x162,0x4(%esp)
c0103b6d:	00 
c0103b6e:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b75:	e8 6e d1 ff ff       	call   c0100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
c0103b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7d:	83 e8 0c             	sub    $0xc,%eax
c0103b80:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103b83:	ff 4d f4             	decl   -0xc(%ebp)
c0103b86:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b8c:	8b 48 08             	mov    0x8(%eax),%ecx
c0103b8f:	89 d0                	mov    %edx,%eax
c0103b91:	29 c8                	sub    %ecx,%eax
c0103b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b99:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103b9c:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b9f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ba5:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103bac:	75 8e                	jne    c0103b3c <default_check+0x5c5>
    }
    assert(count == 0);
c0103bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bb2:	74 24                	je     c0103bd8 <default_check+0x661>
c0103bb4:	c7 44 24 0c bd 6b 10 	movl   $0xc0106bbd,0xc(%esp)
c0103bbb:	c0 
c0103bbc:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103bc3:	c0 
c0103bc4:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
c0103bcb:	00 
c0103bcc:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103bd3:	e8 10 d1 ff ff       	call   c0100ce8 <__panic>
    assert(total == 0);
c0103bd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bdc:	74 24                	je     c0103c02 <default_check+0x68b>
c0103bde:	c7 44 24 0c c8 6b 10 	movl   $0xc0106bc8,0xc(%esp)
c0103be5:	c0 
c0103be6:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103bed:	c0 
c0103bee:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
c0103bf5:	00 
c0103bf6:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103bfd:	e8 e6 d0 ff ff       	call   c0100ce8 <__panic>
}
c0103c02:	90                   	nop
c0103c03:	89 ec                	mov    %ebp,%esp
c0103c05:	5d                   	pop    %ebp
c0103c06:	c3                   	ret    

c0103c07 <page2ppn>:
page2ppn(struct Page *page) {
c0103c07:	55                   	push   %ebp
c0103c08:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c0a:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0103c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c13:	29 d0                	sub    %edx,%eax
c0103c15:	c1 f8 02             	sar    $0x2,%eax
c0103c18:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c1e:	5d                   	pop    %ebp
c0103c1f:	c3                   	ret    

c0103c20 <page2pa>:
page2pa(struct Page *page) {
c0103c20:	55                   	push   %ebp
c0103c21:	89 e5                	mov    %esp,%ebp
c0103c23:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c29:	89 04 24             	mov    %eax,(%esp)
c0103c2c:	e8 d6 ff ff ff       	call   c0103c07 <page2ppn>
c0103c31:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c34:	89 ec                	mov    %ebp,%esp
c0103c36:	5d                   	pop    %ebp
c0103c37:	c3                   	ret    

c0103c38 <pa2page>:
pa2page(uintptr_t pa) {
c0103c38:	55                   	push   %ebp
c0103c39:	89 e5                	mov    %esp,%ebp
c0103c3b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c41:	c1 e8 0c             	shr    $0xc,%eax
c0103c44:	89 c2                	mov    %eax,%edx
c0103c46:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c4b:	39 c2                	cmp    %eax,%edx
c0103c4d:	72 1c                	jb     c0103c6b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c4f:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c0103c56:	c0 
c0103c57:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c5e:	00 
c0103c5f:	c7 04 24 23 6c 10 c0 	movl   $0xc0106c23,(%esp)
c0103c66:	e8 7d d0 ff ff       	call   c0100ce8 <__panic>
    return &pages[PPN(pa)];
c0103c6b:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0103c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c74:	c1 e8 0c             	shr    $0xc,%eax
c0103c77:	89 c2                	mov    %eax,%edx
c0103c79:	89 d0                	mov    %edx,%eax
c0103c7b:	c1 e0 02             	shl    $0x2,%eax
c0103c7e:	01 d0                	add    %edx,%eax
c0103c80:	c1 e0 02             	shl    $0x2,%eax
c0103c83:	01 c8                	add    %ecx,%eax
}
c0103c85:	89 ec                	mov    %ebp,%esp
c0103c87:	5d                   	pop    %ebp
c0103c88:	c3                   	ret    

c0103c89 <page2kva>:
page2kva(struct Page *page) {
c0103c89:	55                   	push   %ebp
c0103c8a:	89 e5                	mov    %esp,%ebp
c0103c8c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c92:	89 04 24             	mov    %eax,(%esp)
c0103c95:	e8 86 ff ff ff       	call   c0103c20 <page2pa>
c0103c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ca0:	c1 e8 0c             	shr    $0xc,%eax
c0103ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ca6:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103cab:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103cae:	72 23                	jb     c0103cd3 <page2kva+0x4a>
c0103cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103cb7:	c7 44 24 08 34 6c 10 	movl   $0xc0106c34,0x8(%esp)
c0103cbe:	c0 
c0103cbf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cc6:	00 
c0103cc7:	c7 04 24 23 6c 10 c0 	movl   $0xc0106c23,(%esp)
c0103cce:	e8 15 d0 ff ff       	call   c0100ce8 <__panic>
c0103cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cd6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cdb:	89 ec                	mov    %ebp,%esp
c0103cdd:	5d                   	pop    %ebp
c0103cde:	c3                   	ret    

c0103cdf <pte2page>:
pte2page(pte_t pte) {
c0103cdf:	55                   	push   %ebp
c0103ce0:	89 e5                	mov    %esp,%ebp
c0103ce2:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce8:	83 e0 01             	and    $0x1,%eax
c0103ceb:	85 c0                	test   %eax,%eax
c0103ced:	75 1c                	jne    c0103d0b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103cef:	c7 44 24 08 58 6c 10 	movl   $0xc0106c58,0x8(%esp)
c0103cf6:	c0 
c0103cf7:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cfe:	00 
c0103cff:	c7 04 24 23 6c 10 c0 	movl   $0xc0106c23,(%esp)
c0103d06:	e8 dd cf ff ff       	call   c0100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d13:	89 04 24             	mov    %eax,(%esp)
c0103d16:	e8 1d ff ff ff       	call   c0103c38 <pa2page>
}
c0103d1b:	89 ec                	mov    %ebp,%esp
c0103d1d:	5d                   	pop    %ebp
c0103d1e:	c3                   	ret    

c0103d1f <pde2page>:
pde2page(pde_t pde) {
c0103d1f:	55                   	push   %ebp
c0103d20:	89 e5                	mov    %esp,%ebp
c0103d22:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d2d:	89 04 24             	mov    %eax,(%esp)
c0103d30:	e8 03 ff ff ff       	call   c0103c38 <pa2page>
}
c0103d35:	89 ec                	mov    %ebp,%esp
c0103d37:	5d                   	pop    %ebp
c0103d38:	c3                   	ret    

c0103d39 <page_ref>:
page_ref(struct Page *page) {
c0103d39:	55                   	push   %ebp
c0103d3a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3f:	8b 00                	mov    (%eax),%eax
}
c0103d41:	5d                   	pop    %ebp
c0103d42:	c3                   	ret    

c0103d43 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103d43:	55                   	push   %ebp
c0103d44:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d49:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d4c:	89 10                	mov    %edx,(%eax)
}
c0103d4e:	90                   	nop
c0103d4f:	5d                   	pop    %ebp
c0103d50:	c3                   	ret    

c0103d51 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d51:	55                   	push   %ebp
c0103d52:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d57:	8b 00                	mov    (%eax),%eax
c0103d59:	8d 50 01             	lea    0x1(%eax),%edx
c0103d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d5f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d64:	8b 00                	mov    (%eax),%eax
}
c0103d66:	5d                   	pop    %ebp
c0103d67:	c3                   	ret    

c0103d68 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d68:	55                   	push   %ebp
c0103d69:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6e:	8b 00                	mov    (%eax),%eax
c0103d70:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d76:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d7b:	8b 00                	mov    (%eax),%eax
}
c0103d7d:	5d                   	pop    %ebp
c0103d7e:	c3                   	ret    

c0103d7f <__intr_save>:
__intr_save(void) {
c0103d7f:	55                   	push   %ebp
c0103d80:	89 e5                	mov    %esp,%ebp
c0103d82:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d85:	9c                   	pushf  
c0103d86:	58                   	pop    %eax
c0103d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d8d:	25 00 02 00 00       	and    $0x200,%eax
c0103d92:	85 c0                	test   %eax,%eax
c0103d94:	74 0c                	je     c0103da2 <__intr_save+0x23>
        intr_disable();
c0103d96:	e8 a6 d9 ff ff       	call   c0101741 <intr_disable>
        return 1;
c0103d9b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103da0:	eb 05                	jmp    c0103da7 <__intr_save+0x28>
    return 0;
c0103da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103da7:	89 ec                	mov    %ebp,%esp
c0103da9:	5d                   	pop    %ebp
c0103daa:	c3                   	ret    

c0103dab <__intr_restore>:
__intr_restore(bool flag) {
c0103dab:	55                   	push   %ebp
c0103dac:	89 e5                	mov    %esp,%ebp
c0103dae:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103db5:	74 05                	je     c0103dbc <__intr_restore+0x11>
        intr_enable();
c0103db7:	e8 7d d9 ff ff       	call   c0101739 <intr_enable>
}
c0103dbc:	90                   	nop
c0103dbd:	89 ec                	mov    %ebp,%esp
c0103dbf:	5d                   	pop    %ebp
c0103dc0:	c3                   	ret    

c0103dc1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103dc1:	55                   	push   %ebp
c0103dc2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)"::"r" (pd));
c0103dc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs"::"a" (USER_DS));
c0103dca:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dcf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs"::"a" (USER_DS));
c0103dd1:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dd6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es"::"a" (KERNEL_DS));
c0103dd8:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ddd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds"::"a" (KERNEL_DS));
c0103ddf:	b8 10 00 00 00       	mov    $0x10,%eax
c0103de4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss"::"a" (KERNEL_DS));
c0103de6:	b8 10 00 00 00       	mov    $0x10,%eax
c0103deb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n"::"i" (KERNEL_CS));
c0103ded:	ea f4 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103df4
}
c0103df4:	90                   	nop
c0103df5:	5d                   	pop    %ebp
c0103df6:	c3                   	ret    

c0103df7 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103df7:	55                   	push   %ebp
c0103df8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dfd:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0103e02:	90                   	nop
c0103e03:	5d                   	pop    %ebp
c0103e04:	c3                   	ret    

c0103e05 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e05:	55                   	push   %ebp
c0103e06:	89 e5                	mov    %esp,%ebp
c0103e08:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t) bootstacktop);
c0103e0b:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0103e10:	89 04 24             	mov    %eax,(%esp)
c0103e13:	e8 df ff ff ff       	call   c0103df7 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e18:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0103e1f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t) & ts, sizeof(ts), DPL_KERNEL);
c0103e21:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0103e28:	68 00 
c0103e2a:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e2f:	0f b7 c0             	movzwl %ax,%eax
c0103e32:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0103e38:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e3d:	c1 e8 10             	shr    $0x10,%eax
c0103e40:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0103e45:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e4c:	24 f0                	and    $0xf0,%al
c0103e4e:	0c 09                	or     $0x9,%al
c0103e50:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e55:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e5c:	24 ef                	and    $0xef,%al
c0103e5e:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e63:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e6a:	24 9f                	and    $0x9f,%al
c0103e6c:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e71:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e78:	0c 80                	or     $0x80,%al
c0103e7a:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e7f:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e86:	24 f0                	and    $0xf0,%al
c0103e88:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e8d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e94:	24 ef                	and    $0xef,%al
c0103e96:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e9b:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ea2:	24 df                	and    $0xdf,%al
c0103ea4:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103ea9:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103eb0:	0c 40                	or     $0x40,%al
c0103eb2:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103eb7:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103ebe:	24 7f                	and    $0x7f,%al
c0103ec0:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103ec5:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103eca:	c1 e8 18             	shr    $0x18,%eax
c0103ecd:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ed2:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0103ed9:	e8 e3 fe ff ff       	call   c0103dc1 <lgdt>
c0103ede:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ee4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ee8:	0f 00 d8             	ltr    %ax
}
c0103eeb:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103eec:	90                   	nop
c0103eed:	89 ec                	mov    %ebp,%esp
c0103eef:	5d                   	pop    %ebp
c0103ef0:	c3                   	ret    

c0103ef1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ef1:	55                   	push   %ebp
c0103ef2:	89 e5                	mov    %esp,%ebp
c0103ef4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ef7:	c7 05 ac ce 11 c0 e8 	movl   $0xc0106be8,0xc011ceac
c0103efe:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f01:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f06:	8b 00                	mov    (%eax),%eax
c0103f08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f0c:	c7 04 24 84 6c 10 c0 	movl   $0xc0106c84,(%esp)
c0103f13:	e8 3e c4 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103f18:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f1d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f20:	ff d0                	call   *%eax
}
c0103f22:	90                   	nop
c0103f23:	89 ec                	mov    %ebp,%esp
c0103f25:	5d                   	pop    %ebp
c0103f26:	c3                   	ret    

c0103f27 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f27:	55                   	push   %ebp
c0103f28:	89 e5                	mov    %esp,%ebp
c0103f2a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f2d:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f32:	8b 40 08             	mov    0x8(%eax),%eax
c0103f35:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f38:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f3c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f3f:	89 14 24             	mov    %edx,(%esp)
c0103f42:	ff d0                	call   *%eax
}
c0103f44:	90                   	nop
c0103f45:	89 ec                	mov    %ebp,%esp
c0103f47:	5d                   	pop    %ebp
c0103f48:	c3                   	ret    

c0103f49 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f49:	55                   	push   %ebp
c0103f4a:	89 e5                	mov    %esp,%ebp
c0103f4c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c0103f4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f56:	e8 24 fe ff ff       	call   c0103d7f <__intr_save>
c0103f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f5e:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f63:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f66:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f69:	89 14 24             	mov    %edx,(%esp)
c0103f6c:	ff d0                	call   *%eax
c0103f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f74:	89 04 24             	mov    %eax,(%esp)
c0103f77:	e8 2f fe ff ff       	call   c0103dab <__intr_restore>
    return page;
c0103f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f7f:	89 ec                	mov    %ebp,%esp
c0103f81:	5d                   	pop    %ebp
c0103f82:	c3                   	ret    

c0103f83 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f83:	55                   	push   %ebp
c0103f84:	89 e5                	mov    %esp,%ebp
c0103f86:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f89:	e8 f1 fd ff ff       	call   c0103d7f <__intr_save>
c0103f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f91:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f96:	8b 40 10             	mov    0x10(%eax),%eax
c0103f99:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f9c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fa0:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fa3:	89 14 24             	mov    %edx,(%esp)
c0103fa6:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fab:	89 04 24             	mov    %eax,(%esp)
c0103fae:	e8 f8 fd ff ff       	call   c0103dab <__intr_restore>
}
c0103fb3:	90                   	nop
c0103fb4:	89 ec                	mov    %ebp,%esp
c0103fb6:	5d                   	pop    %ebp
c0103fb7:	c3                   	ret    

c0103fb8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fb8:	55                   	push   %ebp
c0103fb9:	89 e5                	mov    %esp,%ebp
c0103fbb:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fbe:	e8 bc fd ff ff       	call   c0103d7f <__intr_save>
c0103fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fc6:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103fcb:	8b 40 14             	mov    0x14(%eax),%eax
c0103fce:	ff d0                	call   *%eax
c0103fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fd6:	89 04 24             	mov    %eax,(%esp)
c0103fd9:	e8 cd fd ff ff       	call   c0103dab <__intr_restore>
    return ret;
c0103fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fe1:	89 ec                	mov    %ebp,%esp
c0103fe3:	5d                   	pop    %ebp
c0103fe4:	c3                   	ret    

c0103fe5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fe5:	55                   	push   %ebp
c0103fe6:	89 e5                	mov    %esp,%ebp
c0103fe8:	57                   	push   %edi
c0103fe9:	56                   	push   %esi
c0103fea:	53                   	push   %ebx
c0103feb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *) (0x8000 + KERNBASE);
c0103ff1:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
c0103ff8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104006:	c7 04 24 9b 6c 10 c0 	movl   $0xc0106c9b,(%esp)
c010400d:	e8 44 c3 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++) {
c0104012:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104019:	e9 0c 01 00 00       	jmp    c010412a <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010401e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104021:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104024:	89 d0                	mov    %edx,%eax
c0104026:	c1 e0 02             	shl    $0x2,%eax
c0104029:	01 d0                	add    %edx,%eax
c010402b:	c1 e0 02             	shl    $0x2,%eax
c010402e:	01 c8                	add    %ecx,%eax
c0104030:	8b 50 08             	mov    0x8(%eax),%edx
c0104033:	8b 40 04             	mov    0x4(%eax),%eax
c0104036:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104039:	89 55 ac             	mov    %edx,-0x54(%ebp)
c010403c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010403f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104042:	89 d0                	mov    %edx,%eax
c0104044:	c1 e0 02             	shl    $0x2,%eax
c0104047:	01 d0                	add    %edx,%eax
c0104049:	c1 e0 02             	shl    $0x2,%eax
c010404c:	01 c8                	add    %ecx,%eax
c010404e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104051:	8b 58 10             	mov    0x10(%eax),%ebx
c0104054:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104057:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010405a:	01 c8                	add    %ecx,%eax
c010405c:	11 da                	adc    %ebx,%edx
c010405e:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104061:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104064:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104067:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010406a:	89 d0                	mov    %edx,%eax
c010406c:	c1 e0 02             	shl    $0x2,%eax
c010406f:	01 d0                	add    %edx,%eax
c0104071:	c1 e0 02             	shl    $0x2,%eax
c0104074:	01 c8                	add    %ecx,%eax
c0104076:	83 c0 14             	add    $0x14,%eax
c0104079:	8b 00                	mov    (%eax),%eax
c010407b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104081:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104084:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104087:	83 c0 ff             	add    $0xffffffff,%eax
c010408a:	83 d2 ff             	adc    $0xffffffff,%edx
c010408d:	89 c6                	mov    %eax,%esi
c010408f:	89 d7                	mov    %edx,%edi
c0104091:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104094:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104097:	89 d0                	mov    %edx,%eax
c0104099:	c1 e0 02             	shl    $0x2,%eax
c010409c:	01 d0                	add    %edx,%eax
c010409e:	c1 e0 02             	shl    $0x2,%eax
c01040a1:	01 c8                	add    %ecx,%eax
c01040a3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040a6:	8b 58 10             	mov    0x10(%eax),%ebx
c01040a9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01040af:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040b3:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040b7:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040bb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01040be:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01040c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040c5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040c9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040cd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040d1:	c7 04 24 a8 6c 10 c0 	movl   $0xc0106ca8,(%esp)
c01040d8:	e8 79 c2 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040dd:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01040e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040e3:	89 d0                	mov    %edx,%eax
c01040e5:	c1 e0 02             	shl    $0x2,%eax
c01040e8:	01 d0                	add    %edx,%eax
c01040ea:	c1 e0 02             	shl    $0x2,%eax
c01040ed:	01 c8                	add    %ecx,%eax
c01040ef:	83 c0 14             	add    $0x14,%eax
c01040f2:	8b 00                	mov    (%eax),%eax
c01040f4:	83 f8 01             	cmp    $0x1,%eax
c01040f7:	75 2e                	jne    c0104127 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c01040f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040ff:	3b 45 a0             	cmp    -0x60(%ebp),%eax
c0104102:	89 d0                	mov    %edx,%eax
c0104104:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104107:	73 1e                	jae    c0104127 <page_init+0x142>
c0104109:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c010410e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104113:	3b 55 a8             	cmp    -0x58(%ebp),%edx
c0104116:	1b 45 ac             	sbb    -0x54(%ebp),%eax
c0104119:	72 0c                	jb     c0104127 <page_init+0x142>
                maxpa = end;
c010411b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010411e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104121:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104124:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++) {
c0104127:	ff 45 dc             	incl   -0x24(%ebp)
c010412a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010412d:	8b 00                	mov    (%eax),%eax
c010412f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104132:	0f 8c e6 fe ff ff    	jl     c010401e <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104138:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010413d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104142:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104145:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104148:	73 0e                	jae    c0104158 <page_init+0x173>
        maxpa = KMEMSIZE;
c010414a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104151:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104158:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010415b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010415e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104162:	c1 ea 0c             	shr    $0xc,%edx
c0104165:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
    pages = (struct Page *) ROUNDUP((void *) end, PGSIZE);
c010416a:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
c0104171:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c0104176:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104179:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010417c:	01 d0                	add    %edx,%eax
c010417e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104181:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104184:	ba 00 00 00 00       	mov    $0x0,%edx
c0104189:	f7 75 c8             	divl   -0x38(%ebp)
c010418c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010418f:	29 d0                	sub    %edx,%eax
c0104191:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0

    for (i = 0; i < npage; i++) {
c0104196:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010419d:	eb 2f                	jmp    c01041ce <page_init+0x1e9>
        SetPageReserved(pages + i);
c010419f:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c01041a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041a8:	89 d0                	mov    %edx,%eax
c01041aa:	c1 e0 02             	shl    $0x2,%eax
c01041ad:	01 d0                	add    %edx,%eax
c01041af:	c1 e0 02             	shl    $0x2,%eax
c01041b2:	01 c8                	add    %ecx,%eax
c01041b4:	83 c0 04             	add    $0x4,%eax
c01041b7:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
c01041be:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041c1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01041c4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01041c7:	0f ab 10             	bts    %edx,(%eax)
}
c01041ca:	90                   	nop
    for (i = 0; i < npage; i++) {
c01041cb:	ff 45 dc             	incl   -0x24(%ebp)
c01041ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041d1:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01041d6:	39 c2                	cmp    %eax,%edx
c01041d8:	72 c5                	jb     c010419f <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t) pages + sizeof(struct Page) * npage);
c01041da:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01041e0:	89 d0                	mov    %edx,%eax
c01041e2:	c1 e0 02             	shl    $0x2,%eax
c01041e5:	01 d0                	add    %edx,%eax
c01041e7:	c1 e0 02             	shl    $0x2,%eax
c01041ea:	89 c2                	mov    %eax,%edx
c01041ec:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c01041f1:	01 d0                	add    %edx,%eax
c01041f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01041f6:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
c01041fd:	77 23                	ja     c0104222 <page_init+0x23d>
c01041ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104202:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104206:	c7 44 24 08 d8 6c 10 	movl   $0xc0106cd8,0x8(%esp)
c010420d:	c0 
c010420e:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104215:	00 
c0104216:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010421d:	e8 c6 ca ff ff       	call   c0100ce8 <__panic>
c0104222:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104225:	05 00 00 00 40       	add    $0x40000000,%eax
c010422a:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i++) {
c010422d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104234:	e9 85 01 00 00       	jmp    c01043be <page_init+0x3d9>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104239:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010423c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010423f:	89 d0                	mov    %edx,%eax
c0104241:	c1 e0 02             	shl    $0x2,%eax
c0104244:	01 d0                	add    %edx,%eax
c0104246:	c1 e0 02             	shl    $0x2,%eax
c0104249:	01 c8                	add    %ecx,%eax
c010424b:	8b 50 08             	mov    0x8(%eax),%edx
c010424e:	8b 40 04             	mov    0x4(%eax),%eax
c0104251:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104254:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0104257:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010425a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010425d:	89 d0                	mov    %edx,%eax
c010425f:	c1 e0 02             	shl    $0x2,%eax
c0104262:	01 d0                	add    %edx,%eax
c0104264:	c1 e0 02             	shl    $0x2,%eax
c0104267:	01 c8                	add    %ecx,%eax
c0104269:	8b 48 0c             	mov    0xc(%eax),%ecx
c010426c:	8b 58 10             	mov    0x10(%eax),%ebx
c010426f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104272:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104275:	01 c8                	add    %ecx,%eax
c0104277:	11 da                	adc    %ebx,%edx
c0104279:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010427c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010427f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104282:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104285:	89 d0                	mov    %edx,%eax
c0104287:	c1 e0 02             	shl    $0x2,%eax
c010428a:	01 d0                	add    %edx,%eax
c010428c:	c1 e0 02             	shl    $0x2,%eax
c010428f:	01 c8                	add    %ecx,%eax
c0104291:	83 c0 14             	add    $0x14,%eax
c0104294:	8b 00                	mov    (%eax),%eax
c0104296:	83 f8 01             	cmp    $0x1,%eax
c0104299:	0f 85 1c 01 00 00    	jne    c01043bb <page_init+0x3d6>
            if (begin < freemem) {
c010429f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c01042a2:	bb 00 00 00 00       	mov    $0x0,%ebx
c01042a7:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042aa:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042ad:	39 c8                	cmp    %ecx,%eax
c01042af:	89 d0                	mov    %edx,%eax
c01042b1:	19 d8                	sbb    %ebx,%eax
c01042b3:	73 0e                	jae    c01042c3 <page_init+0x2de>
                begin = freemem;
c01042b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01042bd:	89 45 90             	mov    %eax,-0x70(%ebp)
c01042c0:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042c3:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01042c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01042cd:	3b 55 d0             	cmp    -0x30(%ebp),%edx
c01042d0:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01042d3:	73 0e                	jae    c01042e3 <page_init+0x2fe>
                end = KMEMSIZE;
c01042d5:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
c01042dc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
c01042e3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042e6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042e9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01042ec:	89 d0                	mov    %edx,%eax
c01042ee:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01042f1:	0f 83 c4 00 00 00    	jae    c01043bb <page_init+0x3d6>
                begin = ROUNDUP(begin, PGSIZE);
c01042f7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
c01042fe:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104301:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104304:	89 c2                	mov    %eax,%edx
c0104306:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104309:	01 d0                	add    %edx,%eax
c010430b:	48                   	dec    %eax
c010430c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010430f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104312:	ba 00 00 00 00       	mov    $0x0,%edx
c0104317:	f7 75 b8             	divl   -0x48(%ebp)
c010431a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010431d:	29 d0                	sub    %edx,%eax
c010431f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104324:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104327:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010432a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010432d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104330:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104333:	ba 00 00 00 00       	mov    $0x0,%edx
c0104338:	89 c7                	mov    %eax,%edi
c010433a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104340:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104343:	89 d0                	mov    %edx,%eax
c0104345:	83 e0 00             	and    $0x0,%eax
c0104348:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010434b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010434e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104351:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                if (begin < end) {
c0104357:	8b 45 90             	mov    -0x70(%ebp),%eax
c010435a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010435d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104360:	89 d0                	mov    %edx,%eax
c0104362:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c0104365:	73 54                	jae    c01043bb <page_init+0x3d6>

                    cprintf("memory: %08llx,%08llx\n", begin, &begin);
c0104367:	8b 45 90             	mov    -0x70(%ebp),%eax
c010436a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010436d:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c0104370:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104374:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104378:	89 54 24 08          	mov    %edx,0x8(%esp)
c010437c:	c7 04 24 0a 6d 10 c0 	movl   $0xc0106d0a,(%esp)
c0104383:	e8 ce bf ff ff       	call   c0100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104388:	8b 4d 90             	mov    -0x70(%ebp),%ecx
c010438b:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
c010438e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104391:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104394:	29 c8                	sub    %ecx,%eax
c0104396:	19 da                	sbb    %ebx,%edx
c0104398:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010439c:	c1 ea 0c             	shr    $0xc,%edx
c010439f:	89 c3                	mov    %eax,%ebx
c01043a1:	8b 45 90             	mov    -0x70(%ebp),%eax
c01043a4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01043a7:	89 04 24             	mov    %eax,(%esp)
c01043aa:	e8 89 f8 ff ff       	call   c0103c38 <pa2page>
c01043af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01043b3:	89 04 24             	mov    %eax,(%esp)
c01043b6:	e8 6c fb ff ff       	call   c0103f27 <init_memmap>
    for (i = 0; i < memmap->nr_map; i++) {
c01043bb:	ff 45 dc             	incl   -0x24(%ebp)
c01043be:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043c1:	8b 00                	mov    (%eax),%eax
c01043c3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01043c6:	0f 8c 6d fe ff ff    	jl     c0104239 <page_init+0x254>
                }
            }
        }
    }
}
c01043cc:	90                   	nop
c01043cd:	90                   	nop
c01043ce:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043d4:	5b                   	pop    %ebx
c01043d5:	5e                   	pop    %esi
c01043d6:	5f                   	pop    %edi
c01043d7:	5d                   	pop    %ebp
c01043d8:	c3                   	ret    

c01043d9 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043d9:	55                   	push   %ebp
c01043da:	89 e5                	mov    %esp,%ebp
c01043dc:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043e2:	33 45 14             	xor    0x14(%ebp),%eax
c01043e5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043ea:	85 c0                	test   %eax,%eax
c01043ec:	74 24                	je     c0104412 <boot_map_segment+0x39>
c01043ee:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c01043f5:	c0 
c01043f6:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01043fd:	c0 
c01043fe:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104405:	00 
c0104406:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010440d:	e8 d6 c8 ff ff       	call   c0100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104412:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104419:	8b 45 0c             	mov    0xc(%ebp),%eax
c010441c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104421:	89 c2                	mov    %eax,%edx
c0104423:	8b 45 10             	mov    0x10(%ebp),%eax
c0104426:	01 c2                	add    %eax,%edx
c0104428:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010442b:	01 d0                	add    %edx,%eax
c010442d:	48                   	dec    %eax
c010442e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104431:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104434:	ba 00 00 00 00       	mov    $0x0,%edx
c0104439:	f7 75 f0             	divl   -0x10(%ebp)
c010443c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010443f:	29 d0                	sub    %edx,%eax
c0104441:	c1 e8 0c             	shr    $0xc,%eax
c0104444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104447:	8b 45 0c             	mov    0xc(%ebp),%eax
c010444a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010444d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104455:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104458:	8b 45 14             	mov    0x14(%ebp),%eax
c010445b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010445e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104461:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104466:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
c0104469:	eb 68                	jmp    c01044d3 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010446b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104472:	00 
c0104473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104476:	89 44 24 04          	mov    %eax,0x4(%esp)
c010447a:	8b 45 08             	mov    0x8(%ebp),%eax
c010447d:	89 04 24             	mov    %eax,(%esp)
c0104480:	e8 88 01 00 00       	call   c010460d <get_pte>
c0104485:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010448c:	75 24                	jne    c01044b2 <boot_map_segment+0xd9>
c010448e:	c7 44 24 0c 4d 6d 10 	movl   $0xc0106d4d,0xc(%esp)
c0104495:	c0 
c0104496:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010449d:	c0 
c010449e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01044a5:	00 
c01044a6:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01044ad:	e8 36 c8 ff ff       	call   c0100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
c01044b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01044b5:	0b 45 18             	or     0x18(%ebp),%eax
c01044b8:	83 c8 01             	or     $0x1,%eax
c01044bb:	89 c2                	mov    %eax,%edx
c01044bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044c0:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
c01044c2:	ff 4d f4             	decl   -0xc(%ebp)
c01044c5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044cc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d7:	75 92                	jne    c010446b <boot_map_segment+0x92>
    }
}
c01044d9:	90                   	nop
c01044da:	90                   	nop
c01044db:	89 ec                	mov    %ebp,%esp
c01044dd:	5d                   	pop    %ebp
c01044de:	c3                   	ret    

c01044df <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044df:	55                   	push   %ebp
c01044e0:	89 e5                	mov    %esp,%ebp
c01044e2:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ec:	e8 58 fa ff ff       	call   c0103f49 <alloc_pages>
c01044f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044f8:	75 1c                	jne    c0104516 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044fa:	c7 44 24 08 5a 6d 10 	movl   $0xc0106d5a,0x8(%esp)
c0104501:	c0 
c0104502:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0104509:	00 
c010450a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104511:	e8 d2 c7 ff ff       	call   c0100ce8 <__panic>
    }
    return page2kva(p);
c0104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104519:	89 04 24             	mov    %eax,(%esp)
c010451c:	e8 68 f7 ff ff       	call   c0103c89 <page2kva>
}
c0104521:	89 ec                	mov    %ebp,%esp
c0104523:	5d                   	pop    %ebp
c0104524:	c3                   	ret    

c0104525 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104525:	55                   	push   %ebp
c0104526:	89 e5                	mov    %esp,%ebp
c0104528:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010452b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104530:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104533:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010453a:	77 23                	ja     c010455f <pmm_init+0x3a>
c010453c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104543:	c7 44 24 08 d8 6c 10 	movl   $0xc0106cd8,0x8(%esp)
c010454a:	c0 
c010454b:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104552:	00 
c0104553:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010455a:	e8 89 c7 ff ff       	call   c0100ce8 <__panic>
c010455f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104562:	05 00 00 00 40       	add    $0x40000000,%eax
c0104567:	a3 a8 ce 11 c0       	mov    %eax,0xc011cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010456c:	e8 80 f9 ff ff       	call   c0103ef1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104571:	e8 6f fa ff ff       	call   c0103fe5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104576:	e8 97 03 00 00       	call   c0104912 <check_alloc_page>

    check_pgdir();
c010457b:	e8 b3 03 00 00       	call   c0104933 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104580:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104585:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104588:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010458f:	77 23                	ja     c01045b4 <pmm_init+0x8f>
c0104591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104594:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104598:	c7 44 24 08 d8 6c 10 	movl   $0xc0106cd8,0x8(%esp)
c010459f:	c0 
c01045a0:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01045a7:	00 
c01045a8:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01045af:	e8 34 c7 ff ff       	call   c0100ce8 <__panic>
c01045b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b7:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01045bd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045c2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01045c7:	83 ca 03             	or     $0x3,%edx
c01045ca:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045cc:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045d1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045d8:	00 
c01045d9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045e0:	00 
c01045e1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045e8:	38 
c01045e9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045f0:	c0 
c01045f1:	89 04 24             	mov    %eax,(%esp)
c01045f4:	e8 e0 fd ff ff       	call   c01043d9 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045f9:	e8 07 f8 ff ff       	call   c0103e05 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045fe:	e8 ce 09 00 00       	call   c0104fd1 <check_boot_pgdir>

    print_pgdir();
c0104603:	e8 4b 0e 00 00       	call   c0105453 <print_pgdir>

}
c0104608:	90                   	nop
c0104609:	89 ec                	mov    %ebp,%esp
c010460b:	5d                   	pop    %ebp
c010460c:	c3                   	ret    

c010460d <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010460d:	55                   	push   %ebp
c010460e:	89 e5                	mov    %esp,%ebp
c0104610:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104616:	c1 e8 16             	shr    $0x16,%eax
c0104619:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104620:	8b 45 08             	mov    0x8(%ebp),%eax
c0104623:	01 d0                	add    %edx,%eax
c0104625:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t pa1, la2;

    if (!(*pdep & PTE_P)) {
c0104628:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462b:	8b 00                	mov    (%eax),%eax
c010462d:	83 e0 01             	and    $0x1,%eax
c0104630:	85 c0                	test   %eax,%eax
c0104632:	0f 85 b3 00 00 00    	jne    c01046eb <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) return;
c0104638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010463c:	0f 84 08 01 00 00    	je     c010474a <get_pte+0x13d>
c0104642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104649:	e8 fb f8 ff ff       	call   c0103f49 <alloc_pages>
c010464e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104651:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104655:	0f 84 ef 00 00 00    	je     c010474a <get_pte+0x13d>
        set_page_ref(page, 1);
c010465b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104662:	00 
c0104663:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104666:	89 04 24             	mov    %eax,(%esp)
c0104669:	e8 d5 f6 ff ff       	call   c0103d43 <set_page_ref>
        pa1 = page2pa(page);
c010466e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104671:	89 04 24             	mov    %eax,(%esp)
c0104674:	e8 a7 f5 ff ff       	call   c0103c20 <page2pa>
c0104679:	89 45 ec             	mov    %eax,-0x14(%ebp)
        la2 = KADDR(pa1);
c010467c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010467f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104682:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104685:	c1 e8 0c             	shr    $0xc,%eax
c0104688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010468b:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104690:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104693:	72 23                	jb     c01046b8 <get_pte+0xab>
c0104695:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104698:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010469c:	c7 44 24 08 34 6c 10 	movl   $0xc0106c34,0x8(%esp)
c01046a3:	c0 
c01046a4:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c01046ab:	00 
c01046ac:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01046b3:	e8 30 c6 ff ff       	call   c0100ce8 <__panic>
c01046b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046bb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        memset(la2, 0, PGSIZE);
c01046c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046cd:	00 
c01046ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046d5:	00 
c01046d6:	89 04 24             	mov    %eax,(%esp)
c01046d9:	e8 7a 18 00 00       	call   c0105f58 <memset>
        //set permission
        //这里为何要用物理地址？可能这个机制是物理寻址
//            *pdep = la2 | PTE_P | PTE_U | PTE_W;
        *pdep = pa1 | PTE_P | PTE_U | PTE_W;
c01046de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046e1:	83 c8 07             	or     $0x7,%eax
c01046e4:	89 c2                	mov    %eax,%edx
c01046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e9:	89 10                	mov    %edx,(%eax)

    }
//    PTE_ADDR(pte)
//    &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
    return &((pte_t *) KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01046eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ee:	8b 00                	mov    (%eax),%eax
c01046f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046fb:	c1 e8 0c             	shr    $0xc,%eax
c01046fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104701:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104706:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104709:	72 23                	jb     c010472e <get_pte+0x121>
c010470b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010470e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104712:	c7 44 24 08 34 6c 10 	movl   $0xc0106c34,0x8(%esp)
c0104719:	c0 
c010471a:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
c0104721:	00 
c0104722:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104729:	e8 ba c5 ff ff       	call   c0100ce8 <__panic>
c010472e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104731:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104736:	89 c2                	mov    %eax,%edx
c0104738:	8b 45 0c             	mov    0xc(%ebp),%eax
c010473b:	c1 e8 0c             	shr    $0xc,%eax
c010473e:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104743:	c1 e0 02             	shl    $0x2,%eax
c0104746:	01 d0                	add    %edx,%eax
c0104748:	eb 02                	jmp    c010474c <get_pte+0x13f>
        if (!create || (page = alloc_page()) == NULL) return;
c010474a:	90                   	nop
c010474b:	90                   	nop
//        // 之后该页面就是其中的一个二级页面
//        *pdep = pa | PTE_U | PTE_W | PTE_P;
//    }
//    // 返回在pgdir中对应于la的二级页表项
//    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
c010474c:	89 ec                	mov    %ebp,%esp
c010474e:	5d                   	pop    %ebp
c010474f:	c3                   	ret    

c0104750 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104750:	55                   	push   %ebp
c0104751:	89 e5                	mov    %esp,%ebp
c0104753:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104756:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010475d:	00 
c010475e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104761:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104765:	8b 45 08             	mov    0x8(%ebp),%eax
c0104768:	89 04 24             	mov    %eax,(%esp)
c010476b:	e8 9d fe ff ff       	call   c010460d <get_pte>
c0104770:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104773:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104777:	74 08                	je     c0104781 <get_page+0x31>
        *ptep_store = ptep;
c0104779:	8b 45 10             	mov    0x10(%ebp),%eax
c010477c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010477f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104785:	74 1b                	je     c01047a2 <get_page+0x52>
c0104787:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478a:	8b 00                	mov    (%eax),%eax
c010478c:	83 e0 01             	and    $0x1,%eax
c010478f:	85 c0                	test   %eax,%eax
c0104791:	74 0f                	je     c01047a2 <get_page+0x52>
        return pte2page(*ptep);
c0104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104796:	8b 00                	mov    (%eax),%eax
c0104798:	89 04 24             	mov    %eax,(%esp)
c010479b:	e8 3f f5 ff ff       	call   c0103cdf <pte2page>
c01047a0:	eb 05                	jmp    c01047a7 <get_page+0x57>
    }
    return NULL;
c01047a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047a7:	89 ec                	mov    %ebp,%esp
c01047a9:	5d                   	pop    %ebp
c01047aa:	c3                   	ret    

c01047ab <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01047ab:	55                   	push   %ebp
c01047ac:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01047ae:	90                   	nop
c01047af:	5d                   	pop    %ebp
c01047b0:	c3                   	ret    

c01047b1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01047b1:	55                   	push   %ebp
c01047b2:	89 e5                	mov    %esp,%ebp
c01047b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047be:	00 
c01047bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c9:	89 04 24             	mov    %eax,(%esp)
c01047cc:	e8 3c fe ff ff       	call   c010460d <get_pte>
c01047d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01047d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047d8:	74 19                	je     c01047f3 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01047da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01047e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047eb:	89 04 24             	mov    %eax,(%esp)
c01047ee:	e8 b8 ff ff ff       	call   c01047ab <page_remove_pte>
    }
}
c01047f3:	90                   	nop
c01047f4:	89 ec                	mov    %ebp,%esp
c01047f6:	5d                   	pop    %ebp
c01047f7:	c3                   	ret    

c01047f8 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01047f8:	55                   	push   %ebp
c01047f9:	89 e5                	mov    %esp,%ebp
c01047fb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01047fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104805:	00 
c0104806:	8b 45 10             	mov    0x10(%ebp),%eax
c0104809:	89 44 24 04          	mov    %eax,0x4(%esp)
c010480d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104810:	89 04 24             	mov    %eax,(%esp)
c0104813:	e8 f5 fd ff ff       	call   c010460d <get_pte>
c0104818:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010481b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010481f:	75 0a                	jne    c010482b <page_insert+0x33>
        return -E_NO_MEM;
c0104821:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104826:	e9 84 00 00 00       	jmp    c01048af <page_insert+0xb7>
    }
    page_ref_inc(page);
c010482b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010482e:	89 04 24             	mov    %eax,(%esp)
c0104831:	e8 1b f5 ff ff       	call   c0103d51 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104839:	8b 00                	mov    (%eax),%eax
c010483b:	83 e0 01             	and    $0x1,%eax
c010483e:	85 c0                	test   %eax,%eax
c0104840:	74 3e                	je     c0104880 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104845:	8b 00                	mov    (%eax),%eax
c0104847:	89 04 24             	mov    %eax,(%esp)
c010484a:	e8 90 f4 ff ff       	call   c0103cdf <pte2page>
c010484f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104852:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104855:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104858:	75 0d                	jne    c0104867 <page_insert+0x6f>
            page_ref_dec(page);
c010485a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010485d:	89 04 24             	mov    %eax,(%esp)
c0104860:	e8 03 f5 ff ff       	call   c0103d68 <page_ref_dec>
c0104865:	eb 19                	jmp    c0104880 <page_insert+0x88>
        } else {
            page_remove_pte(pgdir, la, ptep);
c0104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010486e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104871:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104875:	8b 45 08             	mov    0x8(%ebp),%eax
c0104878:	89 04 24             	mov    %eax,(%esp)
c010487b:	e8 2b ff ff ff       	call   c01047ab <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104880:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104883:	89 04 24             	mov    %eax,(%esp)
c0104886:	e8 95 f3 ff ff       	call   c0103c20 <page2pa>
c010488b:	0b 45 14             	or     0x14(%ebp),%eax
c010488e:	83 c8 01             	or     $0x1,%eax
c0104891:	89 c2                	mov    %eax,%edx
c0104893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104896:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104898:	8b 45 10             	mov    0x10(%ebp),%eax
c010489b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010489f:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a2:	89 04 24             	mov    %eax,(%esp)
c01048a5:	e8 09 00 00 00       	call   c01048b3 <tlb_invalidate>
    return 0;
c01048aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048af:	89 ec                	mov    %ebp,%esp
c01048b1:	5d                   	pop    %ebp
c01048b2:	c3                   	ret    

c01048b3 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01048b3:	55                   	push   %ebp
c01048b4:	89 e5                	mov    %esp,%ebp
c01048b6:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01048b9:	0f 20 d8             	mov    %cr3,%eax
c01048bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01048bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01048c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048c8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01048cf:	77 23                	ja     c01048f4 <tlb_invalidate+0x41>
c01048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048d8:	c7 44 24 08 d8 6c 10 	movl   $0xc0106cd8,0x8(%esp)
c01048df:	c0 
c01048e0:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c01048e7:	00 
c01048e8:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01048ef:	e8 f4 c3 ff ff       	call   c0100ce8 <__panic>
c01048f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048f7:	05 00 00 00 40       	add    $0x40000000,%eax
c01048fc:	39 d0                	cmp    %edx,%eax
c01048fe:	75 0d                	jne    c010490d <tlb_invalidate+0x5a>
        invlpg((void *) la);
c0104900:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104903:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104906:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104909:	0f 01 38             	invlpg (%eax)
}
c010490c:	90                   	nop
    }
}
c010490d:	90                   	nop
c010490e:	89 ec                	mov    %ebp,%esp
c0104910:	5d                   	pop    %ebp
c0104911:	c3                   	ret    

c0104912 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104912:	55                   	push   %ebp
c0104913:	89 e5                	mov    %esp,%ebp
c0104915:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104918:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c010491d:	8b 40 18             	mov    0x18(%eax),%eax
c0104920:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104922:	c7 04 24 74 6d 10 c0 	movl   $0xc0106d74,(%esp)
c0104929:	e8 28 ba ff ff       	call   c0100356 <cprintf>
}
c010492e:	90                   	nop
c010492f:	89 ec                	mov    %ebp,%esp
c0104931:	5d                   	pop    %ebp
c0104932:	c3                   	ret    

c0104933 <check_pgdir>:

static void
check_pgdir(void) {
c0104933:	55                   	push   %ebp
c0104934:	89 e5                	mov    %esp,%ebp
c0104936:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104939:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010493e:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104943:	76 24                	jbe    c0104969 <check_pgdir+0x36>
c0104945:	c7 44 24 0c 93 6d 10 	movl   $0xc0106d93,0xc(%esp)
c010494c:	c0 
c010494d:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104954:	c0 
c0104955:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c010495c:	00 
c010495d:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104964:	e8 7f c3 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t) PGOFF(boot_pgdir) == 0);
c0104969:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010496e:	85 c0                	test   %eax,%eax
c0104970:	74 0e                	je     c0104980 <check_pgdir+0x4d>
c0104972:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104977:	25 ff 0f 00 00       	and    $0xfff,%eax
c010497c:	85 c0                	test   %eax,%eax
c010497e:	74 24                	je     c01049a4 <check_pgdir+0x71>
c0104980:	c7 44 24 0c b0 6d 10 	movl   $0xc0106db0,0xc(%esp)
c0104987:	c0 
c0104988:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010498f:	c0 
c0104990:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104997:	00 
c0104998:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010499f:	e8 44 c3 ff ff       	call   c0100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01049a4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049b0:	00 
c01049b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049b8:	00 
c01049b9:	89 04 24             	mov    %eax,(%esp)
c01049bc:	e8 8f fd ff ff       	call   c0104750 <get_page>
c01049c1:	85 c0                	test   %eax,%eax
c01049c3:	74 24                	je     c01049e9 <check_pgdir+0xb6>
c01049c5:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c01049cc:	c0 
c01049cd:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01049d4:	c0 
c01049d5:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c01049dc:	00 
c01049dd:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01049e4:	e8 ff c2 ff ff       	call   c0100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01049e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049f0:	e8 54 f5 ff ff       	call   c0103f49 <alloc_pages>
c01049f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01049f8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a04:	00 
c0104a05:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a0c:	00 
c0104a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a10:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a14:	89 04 24             	mov    %eax,(%esp)
c0104a17:	e8 dc fd ff ff       	call   c01047f8 <page_insert>
c0104a1c:	85 c0                	test   %eax,%eax
c0104a1e:	74 24                	je     c0104a44 <check_pgdir+0x111>
c0104a20:	c7 44 24 0c 10 6e 10 	movl   $0xc0106e10,0xc(%esp)
c0104a27:	c0 
c0104a28:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104a2f:	c0 
c0104a30:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104a37:	00 
c0104a38:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104a3f:	e8 a4 c2 ff ff       	call   c0100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a44:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a50:	00 
c0104a51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a58:	00 
c0104a59:	89 04 24             	mov    %eax,(%esp)
c0104a5c:	e8 ac fb ff ff       	call   c010460d <get_pte>
c0104a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a68:	75 24                	jne    c0104a8e <check_pgdir+0x15b>
c0104a6a:	c7 44 24 0c 3c 6e 10 	movl   $0xc0106e3c,0xc(%esp)
c0104a71:	c0 
c0104a72:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104a79:	c0 
c0104a7a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104a81:	00 
c0104a82:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104a89:	e8 5a c2 ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a91:	8b 00                	mov    (%eax),%eax
c0104a93:	89 04 24             	mov    %eax,(%esp)
c0104a96:	e8 44 f2 ff ff       	call   c0103cdf <pte2page>
c0104a9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104a9e:	74 24                	je     c0104ac4 <check_pgdir+0x191>
c0104aa0:	c7 44 24 0c 69 6e 10 	movl   $0xc0106e69,0xc(%esp)
c0104aa7:	c0 
c0104aa8:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104aaf:	c0 
c0104ab0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104ab7:	00 
c0104ab8:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104abf:	e8 24 c2 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 1);
c0104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac7:	89 04 24             	mov    %eax,(%esp)
c0104aca:	e8 6a f2 ff ff       	call   c0103d39 <page_ref>
c0104acf:	83 f8 01             	cmp    $0x1,%eax
c0104ad2:	74 24                	je     c0104af8 <check_pgdir+0x1c5>
c0104ad4:	c7 44 24 0c 7f 6e 10 	movl   $0xc0106e7f,0xc(%esp)
c0104adb:	c0 
c0104adc:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104ae3:	c0 
c0104ae4:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104aeb:	00 
c0104aec:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104af3:	e8 f0 c1 ff ff       	call   c0100ce8 <__panic>

    ptep = &((pte_t *) KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104af8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104afd:	8b 00                	mov    (%eax),%eax
c0104aff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b0a:	c1 e8 0c             	shr    $0xc,%eax
c0104b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b10:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104b15:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b18:	72 23                	jb     c0104b3d <check_pgdir+0x20a>
c0104b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b21:	c7 44 24 08 34 6c 10 	movl   $0xc0106c34,0x8(%esp)
c0104b28:	c0 
c0104b29:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104b30:	00 
c0104b31:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104b38:	e8 ab c1 ff ff       	call   c0100ce8 <__panic>
c0104b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b40:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b45:	83 c0 04             	add    $0x4,%eax
c0104b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b4b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b57:	00 
c0104b58:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b5f:	00 
c0104b60:	89 04 24             	mov    %eax,(%esp)
c0104b63:	e8 a5 fa ff ff       	call   c010460d <get_pte>
c0104b68:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104b6b:	74 24                	je     c0104b91 <check_pgdir+0x25e>
c0104b6d:	c7 44 24 0c 94 6e 10 	movl   $0xc0106e94,0xc(%esp)
c0104b74:	c0 
c0104b75:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104b7c:	c0 
c0104b7d:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104b84:	00 
c0104b85:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104b8c:	e8 57 c1 ff ff       	call   c0100ce8 <__panic>

    p2 = alloc_page();
c0104b91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b98:	e8 ac f3 ff ff       	call   c0103f49 <alloc_pages>
c0104b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104ba0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ba5:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104bac:	00 
c0104bad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bb4:	00 
c0104bb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bbc:	89 04 24             	mov    %eax,(%esp)
c0104bbf:	e8 34 fc ff ff       	call   c01047f8 <page_insert>
c0104bc4:	85 c0                	test   %eax,%eax
c0104bc6:	74 24                	je     c0104bec <check_pgdir+0x2b9>
c0104bc8:	c7 44 24 0c bc 6e 10 	movl   $0xc0106ebc,0xc(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104bd7:	c0 
c0104bd8:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104bdf:	00 
c0104be0:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104be7:	e8 fc c0 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104bec:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104bf1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bf8:	00 
c0104bf9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c00:	00 
c0104c01:	89 04 24             	mov    %eax,(%esp)
c0104c04:	e8 04 fa ff ff       	call   c010460d <get_pte>
c0104c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c10:	75 24                	jne    c0104c36 <check_pgdir+0x303>
c0104c12:	c7 44 24 0c f4 6e 10 	movl   $0xc0106ef4,0xc(%esp)
c0104c19:	c0 
c0104c1a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104c21:	c0 
c0104c22:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c29:	00 
c0104c2a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104c31:	e8 b2 c0 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_U);
c0104c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c39:	8b 00                	mov    (%eax),%eax
c0104c3b:	83 e0 04             	and    $0x4,%eax
c0104c3e:	85 c0                	test   %eax,%eax
c0104c40:	75 24                	jne    c0104c66 <check_pgdir+0x333>
c0104c42:	c7 44 24 0c 24 6f 10 	movl   $0xc0106f24,0xc(%esp)
c0104c49:	c0 
c0104c4a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104c51:	c0 
c0104c52:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104c59:	00 
c0104c5a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104c61:	e8 82 c0 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_W);
c0104c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c69:	8b 00                	mov    (%eax),%eax
c0104c6b:	83 e0 02             	and    $0x2,%eax
c0104c6e:	85 c0                	test   %eax,%eax
c0104c70:	75 24                	jne    c0104c96 <check_pgdir+0x363>
c0104c72:	c7 44 24 0c 32 6f 10 	movl   $0xc0106f32,0xc(%esp)
c0104c79:	c0 
c0104c7a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104c89:	00 
c0104c8a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104c91:	e8 52 c0 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104c96:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104c9b:	8b 00                	mov    (%eax),%eax
c0104c9d:	83 e0 04             	and    $0x4,%eax
c0104ca0:	85 c0                	test   %eax,%eax
c0104ca2:	75 24                	jne    c0104cc8 <check_pgdir+0x395>
c0104ca4:	c7 44 24 0c 40 6f 10 	movl   $0xc0106f40,0xc(%esp)
c0104cab:	c0 
c0104cac:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104cb3:	c0 
c0104cb4:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104cbb:	00 
c0104cbc:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104cc3:	e8 20 c0 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 1);
c0104cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ccb:	89 04 24             	mov    %eax,(%esp)
c0104cce:	e8 66 f0 ff ff       	call   c0103d39 <page_ref>
c0104cd3:	83 f8 01             	cmp    $0x1,%eax
c0104cd6:	74 24                	je     c0104cfc <check_pgdir+0x3c9>
c0104cd8:	c7 44 24 0c 56 6f 10 	movl   $0xc0106f56,0xc(%esp)
c0104cdf:	c0 
c0104ce0:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104ce7:	c0 
c0104ce8:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104cef:	00 
c0104cf0:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104cf7:	e8 ec bf ff ff       	call   c0100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104cfc:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104d01:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d08:	00 
c0104d09:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d10:	00 
c0104d11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d14:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d18:	89 04 24             	mov    %eax,(%esp)
c0104d1b:	e8 d8 fa ff ff       	call   c01047f8 <page_insert>
c0104d20:	85 c0                	test   %eax,%eax
c0104d22:	74 24                	je     c0104d48 <check_pgdir+0x415>
c0104d24:	c7 44 24 0c 68 6f 10 	movl   $0xc0106f68,0xc(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104d33:	c0 
c0104d34:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104d3b:	00 
c0104d3c:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104d43:	e8 a0 bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 2);
c0104d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d4b:	89 04 24             	mov    %eax,(%esp)
c0104d4e:	e8 e6 ef ff ff       	call   c0103d39 <page_ref>
c0104d53:	83 f8 02             	cmp    $0x2,%eax
c0104d56:	74 24                	je     c0104d7c <check_pgdir+0x449>
c0104d58:	c7 44 24 0c 94 6f 10 	movl   $0xc0106f94,0xc(%esp)
c0104d5f:	c0 
c0104d60:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104d67:	c0 
c0104d68:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104d6f:	00 
c0104d70:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104d77:	e8 6c bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d7f:	89 04 24             	mov    %eax,(%esp)
c0104d82:	e8 b2 ef ff ff       	call   c0103d39 <page_ref>
c0104d87:	85 c0                	test   %eax,%eax
c0104d89:	74 24                	je     c0104daf <check_pgdir+0x47c>
c0104d8b:	c7 44 24 0c a6 6f 10 	movl   $0xc0106fa6,0xc(%esp)
c0104d92:	c0 
c0104d93:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104d9a:	c0 
c0104d9b:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104da2:	00 
c0104da3:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104daa:	e8 39 bf ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104daf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104db4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104dbb:	00 
c0104dbc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dc3:	00 
c0104dc4:	89 04 24             	mov    %eax,(%esp)
c0104dc7:	e8 41 f8 ff ff       	call   c010460d <get_pte>
c0104dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dd3:	75 24                	jne    c0104df9 <check_pgdir+0x4c6>
c0104dd5:	c7 44 24 0c f4 6e 10 	movl   $0xc0106ef4,0xc(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104de4:	c0 
c0104de5:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104dec:	00 
c0104ded:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104df4:	e8 ef be ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dfc:	8b 00                	mov    (%eax),%eax
c0104dfe:	89 04 24             	mov    %eax,(%esp)
c0104e01:	e8 d9 ee ff ff       	call   c0103cdf <pte2page>
c0104e06:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e09:	74 24                	je     c0104e2f <check_pgdir+0x4fc>
c0104e0b:	c7 44 24 0c 69 6e 10 	movl   $0xc0106e69,0xc(%esp)
c0104e12:	c0 
c0104e13:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104e1a:	c0 
c0104e1b:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104e22:	00 
c0104e23:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104e2a:	e8 b9 be ff ff       	call   c0100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e32:	8b 00                	mov    (%eax),%eax
c0104e34:	83 e0 04             	and    $0x4,%eax
c0104e37:	85 c0                	test   %eax,%eax
c0104e39:	74 24                	je     c0104e5f <check_pgdir+0x52c>
c0104e3b:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c0104e42:	c0 
c0104e43:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104e4a:	c0 
c0104e4b:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104e52:	00 
c0104e53:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104e5a:	e8 89 be ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104e5f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e6b:	00 
c0104e6c:	89 04 24             	mov    %eax,(%esp)
c0104e6f:	e8 3d f9 ff ff       	call   c01047b1 <page_remove>
    assert(page_ref(p1) == 1);
c0104e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e77:	89 04 24             	mov    %eax,(%esp)
c0104e7a:	e8 ba ee ff ff       	call   c0103d39 <page_ref>
c0104e7f:	83 f8 01             	cmp    $0x1,%eax
c0104e82:	74 24                	je     c0104ea8 <check_pgdir+0x575>
c0104e84:	c7 44 24 0c 7f 6e 10 	movl   $0xc0106e7f,0xc(%esp)
c0104e8b:	c0 
c0104e8c:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104e93:	c0 
c0104e94:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104e9b:	00 
c0104e9c:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104ea3:	e8 40 be ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eab:	89 04 24             	mov    %eax,(%esp)
c0104eae:	e8 86 ee ff ff       	call   c0103d39 <page_ref>
c0104eb3:	85 c0                	test   %eax,%eax
c0104eb5:	74 24                	je     c0104edb <check_pgdir+0x5a8>
c0104eb7:	c7 44 24 0c a6 6f 10 	movl   $0xc0106fa6,0xc(%esp)
c0104ebe:	c0 
c0104ebf:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104ec6:	c0 
c0104ec7:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104ece:	00 
c0104ecf:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104ed6:	e8 0d be ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104edb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ee0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ee7:	00 
c0104ee8:	89 04 24             	mov    %eax,(%esp)
c0104eeb:	e8 c1 f8 ff ff       	call   c01047b1 <page_remove>
    assert(page_ref(p1) == 0);
c0104ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef3:	89 04 24             	mov    %eax,(%esp)
c0104ef6:	e8 3e ee ff ff       	call   c0103d39 <page_ref>
c0104efb:	85 c0                	test   %eax,%eax
c0104efd:	74 24                	je     c0104f23 <check_pgdir+0x5f0>
c0104eff:	c7 44 24 0c cd 6f 10 	movl   $0xc0106fcd,0xc(%esp)
c0104f06:	c0 
c0104f07:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104f0e:	c0 
c0104f0f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104f16:	00 
c0104f17:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104f1e:	e8 c5 bd ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f26:	89 04 24             	mov    %eax,(%esp)
c0104f29:	e8 0b ee ff ff       	call   c0103d39 <page_ref>
c0104f2e:	85 c0                	test   %eax,%eax
c0104f30:	74 24                	je     c0104f56 <check_pgdir+0x623>
c0104f32:	c7 44 24 0c a6 6f 10 	movl   $0xc0106fa6,0xc(%esp)
c0104f39:	c0 
c0104f3a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104f41:	c0 
c0104f42:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104f49:	00 
c0104f4a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104f51:	e8 92 bd ff ff       	call   c0100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104f56:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f5b:	8b 00                	mov    (%eax),%eax
c0104f5d:	89 04 24             	mov    %eax,(%esp)
c0104f60:	e8 ba ed ff ff       	call   c0103d1f <pde2page>
c0104f65:	89 04 24             	mov    %eax,(%esp)
c0104f68:	e8 cc ed ff ff       	call   c0103d39 <page_ref>
c0104f6d:	83 f8 01             	cmp    $0x1,%eax
c0104f70:	74 24                	je     c0104f96 <check_pgdir+0x663>
c0104f72:	c7 44 24 0c e0 6f 10 	movl   $0xc0106fe0,0xc(%esp)
c0104f79:	c0 
c0104f7a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0104f81:	c0 
c0104f82:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104f89:	00 
c0104f8a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0104f91:	e8 52 bd ff ff       	call   c0100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104f96:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f9b:	8b 00                	mov    (%eax),%eax
c0104f9d:	89 04 24             	mov    %eax,(%esp)
c0104fa0:	e8 7a ed ff ff       	call   c0103d1f <pde2page>
c0104fa5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fac:	00 
c0104fad:	89 04 24             	mov    %eax,(%esp)
c0104fb0:	e8 ce ef ff ff       	call   c0103f83 <free_pages>
    boot_pgdir[0] = 0;
c0104fb5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104fc0:	c7 04 24 07 70 10 c0 	movl   $0xc0107007,(%esp)
c0104fc7:	e8 8a b3 ff ff       	call   c0100356 <cprintf>
}
c0104fcc:	90                   	nop
c0104fcd:	89 ec                	mov    %ebp,%esp
c0104fcf:	5d                   	pop    %ebp
c0104fd0:	c3                   	ret    

c0104fd1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104fd1:	55                   	push   %ebp
c0104fd2:	89 e5                	mov    %esp,%ebp
c0104fd4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104fde:	e9 ca 00 00 00       	jmp    c01050ad <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t) KADDR(i), 0)) != NULL);
c0104fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fec:	c1 e8 0c             	shr    $0xc,%eax
c0104fef:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ff2:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104ff7:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104ffa:	72 23                	jb     c010501f <check_boot_pgdir+0x4e>
c0104ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105003:	c7 44 24 08 34 6c 10 	movl   $0xc0106c34,0x8(%esp)
c010500a:	c0 
c010500b:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105012:	00 
c0105013:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010501a:	e8 c9 bc ff ff       	call   c0100ce8 <__panic>
c010501f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105022:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105027:	89 c2                	mov    %eax,%edx
c0105029:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010502e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105035:	00 
c0105036:	89 54 24 04          	mov    %edx,0x4(%esp)
c010503a:	89 04 24             	mov    %eax,(%esp)
c010503d:	e8 cb f5 ff ff       	call   c010460d <get_pte>
c0105042:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105045:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105049:	75 24                	jne    c010506f <check_boot_pgdir+0x9e>
c010504b:	c7 44 24 0c 24 70 10 	movl   $0xc0107024,0xc(%esp)
c0105052:	c0 
c0105053:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010505a:	c0 
c010505b:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105062:	00 
c0105063:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010506a:	e8 79 bc ff ff       	call   c0100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010506f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105072:	8b 00                	mov    (%eax),%eax
c0105074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105079:	89 c2                	mov    %eax,%edx
c010507b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010507e:	39 c2                	cmp    %eax,%edx
c0105080:	74 24                	je     c01050a6 <check_boot_pgdir+0xd5>
c0105082:	c7 44 24 0c 62 70 10 	movl   $0xc0107062,0xc(%esp)
c0105089:	c0 
c010508a:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0105091:	c0 
c0105092:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105099:	00 
c010509a:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01050a1:	e8 42 bc ff ff       	call   c0100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01050a6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050b0:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01050b5:	39 c2                	cmp    %eax,%edx
c01050b7:	0f 82 26 ff ff ff    	jb     c0104fe3 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01050bd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01050c2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01050c7:	8b 00                	mov    (%eax),%eax
c01050c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050ce:	89 c2                	mov    %eax,%edx
c01050d0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01050d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050d8:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01050df:	77 23                	ja     c0105104 <check_boot_pgdir+0x133>
c01050e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050e8:	c7 44 24 08 d8 6c 10 	movl   $0xc0106cd8,0x8(%esp)
c01050ef:	c0 
c01050f0:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01050f7:	00 
c01050f8:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01050ff:	e8 e4 bb ff ff       	call   c0100ce8 <__panic>
c0105104:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105107:	05 00 00 00 40       	add    $0x40000000,%eax
c010510c:	39 d0                	cmp    %edx,%eax
c010510e:	74 24                	je     c0105134 <check_boot_pgdir+0x163>
c0105110:	c7 44 24 0c 78 70 10 	movl   $0xc0107078,0xc(%esp)
c0105117:	c0 
c0105118:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010511f:	c0 
c0105120:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105127:	00 
c0105128:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010512f:	e8 b4 bb ff ff       	call   c0100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
c0105134:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105139:	8b 00                	mov    (%eax),%eax
c010513b:	85 c0                	test   %eax,%eax
c010513d:	74 24                	je     c0105163 <check_boot_pgdir+0x192>
c010513f:	c7 44 24 0c ac 70 10 	movl   $0xc01070ac,0xc(%esp)
c0105146:	c0 
c0105147:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010514e:	c0 
c010514f:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105156:	00 
c0105157:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010515e:	e8 85 bb ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
c0105163:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010516a:	e8 da ed ff ff       	call   c0103f49 <alloc_pages>
c010516f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105172:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105177:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010517e:	00 
c010517f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105186:	00 
c0105187:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010518a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010518e:	89 04 24             	mov    %eax,(%esp)
c0105191:	e8 62 f6 ff ff       	call   c01047f8 <page_insert>
c0105196:	85 c0                	test   %eax,%eax
c0105198:	74 24                	je     c01051be <check_boot_pgdir+0x1ed>
c010519a:	c7 44 24 0c c0 70 10 	movl   $0xc01070c0,0xc(%esp)
c01051a1:	c0 
c01051a2:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01051a9:	c0 
c01051aa:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01051b1:	00 
c01051b2:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01051b9:	e8 2a bb ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 1);
c01051be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051c1:	89 04 24             	mov    %eax,(%esp)
c01051c4:	e8 70 eb ff ff       	call   c0103d39 <page_ref>
c01051c9:	83 f8 01             	cmp    $0x1,%eax
c01051cc:	74 24                	je     c01051f2 <check_boot_pgdir+0x221>
c01051ce:	c7 44 24 0c ee 70 10 	movl   $0xc01070ee,0xc(%esp)
c01051d5:	c0 
c01051d6:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01051dd:	c0 
c01051de:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c01051e5:	00 
c01051e6:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01051ed:	e8 f6 ba ff ff       	call   c0100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01051f2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01051f7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01051fe:	00 
c01051ff:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105206:	00 
c0105207:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010520a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010520e:	89 04 24             	mov    %eax,(%esp)
c0105211:	e8 e2 f5 ff ff       	call   c01047f8 <page_insert>
c0105216:	85 c0                	test   %eax,%eax
c0105218:	74 24                	je     c010523e <check_boot_pgdir+0x26d>
c010521a:	c7 44 24 0c 00 71 10 	movl   $0xc0107100,0xc(%esp)
c0105221:	c0 
c0105222:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0105229:	c0 
c010522a:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105231:	00 
c0105232:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c0105239:	e8 aa ba ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 2);
c010523e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105241:	89 04 24             	mov    %eax,(%esp)
c0105244:	e8 f0 ea ff ff       	call   c0103d39 <page_ref>
c0105249:	83 f8 02             	cmp    $0x2,%eax
c010524c:	74 24                	je     c0105272 <check_boot_pgdir+0x2a1>
c010524e:	c7 44 24 0c 37 71 10 	movl   $0xc0107137,0xc(%esp)
c0105255:	c0 
c0105256:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010525d:	c0 
c010525e:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105265:	00 
c0105266:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010526d:	e8 76 ba ff ff       	call   c0100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
c0105272:	c7 45 e8 48 71 10 c0 	movl   $0xc0107148,-0x18(%ebp)
    strcpy((void *) 0x100, str);
c0105279:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010527c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105280:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105287:	e8 fc 09 00 00       	call   c0105c88 <strcpy>
    assert(strcmp((void *) 0x100, (void *) (0x100 + PGSIZE)) == 0);
c010528c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105293:	00 
c0105294:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010529b:	e8 60 0a 00 00       	call   c0105d00 <strcmp>
c01052a0:	85 c0                	test   %eax,%eax
c01052a2:	74 24                	je     c01052c8 <check_boot_pgdir+0x2f7>
c01052a4:	c7 44 24 0c 60 71 10 	movl   $0xc0107160,0xc(%esp)
c01052ab:	c0 
c01052ac:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01052b3:	c0 
c01052b4:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01052bb:	00 
c01052bc:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c01052c3:	e8 20 ba ff ff       	call   c0100ce8 <__panic>

    *(char *) (page2kva(p) + 0x100) = '\0';
c01052c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052cb:	89 04 24             	mov    %eax,(%esp)
c01052ce:	e8 b6 e9 ff ff       	call   c0103c89 <page2kva>
c01052d3:	05 00 01 00 00       	add    $0x100,%eax
c01052d8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *) 0x100) == 0);
c01052db:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052e2:	e8 47 09 00 00       	call   c0105c2e <strlen>
c01052e7:	85 c0                	test   %eax,%eax
c01052e9:	74 24                	je     c010530f <check_boot_pgdir+0x33e>
c01052eb:	c7 44 24 0c 98 71 10 	movl   $0xc0107198,0xc(%esp)
c01052f2:	c0 
c01052f3:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01052fa:	c0 
c01052fb:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105302:	00 
c0105303:	c7 04 24 fc 6c 10 c0 	movl   $0xc0106cfc,(%esp)
c010530a:	e8 d9 b9 ff ff       	call   c0100ce8 <__panic>

    free_page(p);
c010530f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105316:	00 
c0105317:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531a:	89 04 24             	mov    %eax,(%esp)
c010531d:	e8 61 ec ff ff       	call   c0103f83 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105322:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105327:	8b 00                	mov    (%eax),%eax
c0105329:	89 04 24             	mov    %eax,(%esp)
c010532c:	e8 ee e9 ff ff       	call   c0103d1f <pde2page>
c0105331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105338:	00 
c0105339:	89 04 24             	mov    %eax,(%esp)
c010533c:	e8 42 ec ff ff       	call   c0103f83 <free_pages>
    boot_pgdir[0] = 0;
c0105341:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010534c:	c7 04 24 bc 71 10 c0 	movl   $0xc01071bc,(%esp)
c0105353:	e8 fe af ff ff       	call   c0100356 <cprintf>
}
c0105358:	90                   	nop
c0105359:	89 ec                	mov    %ebp,%esp
c010535b:	5d                   	pop    %ebp
c010535c:	c3                   	ret    

c010535d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010535d:	55                   	push   %ebp
c010535e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105360:	8b 45 08             	mov    0x8(%ebp),%eax
c0105363:	83 e0 04             	and    $0x4,%eax
c0105366:	85 c0                	test   %eax,%eax
c0105368:	74 04                	je     c010536e <perm2str+0x11>
c010536a:	b0 75                	mov    $0x75,%al
c010536c:	eb 02                	jmp    c0105370 <perm2str+0x13>
c010536e:	b0 2d                	mov    $0x2d,%al
c0105370:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c0105375:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010537c:	8b 45 08             	mov    0x8(%ebp),%eax
c010537f:	83 e0 02             	and    $0x2,%eax
c0105382:	85 c0                	test   %eax,%eax
c0105384:	74 04                	je     c010538a <perm2str+0x2d>
c0105386:	b0 77                	mov    $0x77,%al
c0105388:	eb 02                	jmp    c010538c <perm2str+0x2f>
c010538a:	b0 2d                	mov    $0x2d,%al
c010538c:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c0105391:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c0105398:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c010539d:	5d                   	pop    %ebp
c010539e:	c3                   	ret    

c010539f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010539f:	55                   	push   %ebp
c01053a0:	89 e5                	mov    %esp,%ebp
c01053a2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01053a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053ab:	72 0d                	jb     c01053ba <get_pgtable_items+0x1b>
        return 0;
c01053ad:	b8 00 00 00 00       	mov    $0x0,%eax
c01053b2:	e9 98 00 00 00       	jmp    c010544f <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start++;
c01053b7:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01053ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01053bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053c0:	73 18                	jae    c01053da <get_pgtable_items+0x3b>
c01053c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01053cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01053cf:	01 d0                	add    %edx,%eax
c01053d1:	8b 00                	mov    (%eax),%eax
c01053d3:	83 e0 01             	and    $0x1,%eax
c01053d6:	85 c0                	test   %eax,%eax
c01053d8:	74 dd                	je     c01053b7 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01053da:	8b 45 10             	mov    0x10(%ebp),%eax
c01053dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053e0:	73 68                	jae    c010544a <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01053e2:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01053e6:	74 08                	je     c01053f0 <get_pgtable_items+0x51>
            *left_store = start;
c01053e8:	8b 45 18             	mov    0x18(%ebp),%eax
c01053eb:	8b 55 10             	mov    0x10(%ebp),%edx
c01053ee:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c01053f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f3:	8d 50 01             	lea    0x1(%eax),%edx
c01053f6:	89 55 10             	mov    %edx,0x10(%ebp)
c01053f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105400:	8b 45 14             	mov    0x14(%ebp),%eax
c0105403:	01 d0                	add    %edx,%eax
c0105405:	8b 00                	mov    (%eax),%eax
c0105407:	83 e0 07             	and    $0x7,%eax
c010540a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010540d:	eb 03                	jmp    c0105412 <get_pgtable_items+0x73>
            start++;
c010540f:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105412:	8b 45 10             	mov    0x10(%ebp),%eax
c0105415:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105418:	73 1d                	jae    c0105437 <get_pgtable_items+0x98>
c010541a:	8b 45 10             	mov    0x10(%ebp),%eax
c010541d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105424:	8b 45 14             	mov    0x14(%ebp),%eax
c0105427:	01 d0                	add    %edx,%eax
c0105429:	8b 00                	mov    (%eax),%eax
c010542b:	83 e0 07             	and    $0x7,%eax
c010542e:	89 c2                	mov    %eax,%edx
c0105430:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105433:	39 c2                	cmp    %eax,%edx
c0105435:	74 d8                	je     c010540f <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105437:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010543b:	74 08                	je     c0105445 <get_pgtable_items+0xa6>
            *right_store = start;
c010543d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105440:	8b 55 10             	mov    0x10(%ebp),%edx
c0105443:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105445:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105448:	eb 05                	jmp    c010544f <get_pgtable_items+0xb0>
    }
    return 0;
c010544a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010544f:	89 ec                	mov    %ebp,%esp
c0105451:	5d                   	pop    %ebp
c0105452:	c3                   	ret    

c0105453 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105453:	55                   	push   %ebp
c0105454:	89 e5                	mov    %esp,%ebp
c0105456:	57                   	push   %edi
c0105457:	56                   	push   %esi
c0105458:	53                   	push   %ebx
c0105459:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010545c:	c7 04 24 dc 71 10 c0 	movl   $0xc01071dc,(%esp)
c0105463:	e8 ee ae ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c0105468:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010546f:	e9 f2 00 00 00       	jmp    c0105566 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105477:	89 04 24             	mov    %eax,(%esp)
c010547a:	e8 de fe ff ff       	call   c010535d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010547f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105485:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105487:	89 d6                	mov    %edx,%esi
c0105489:	c1 e6 16             	shl    $0x16,%esi
c010548c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010548f:	89 d3                	mov    %edx,%ebx
c0105491:	c1 e3 16             	shl    $0x16,%ebx
c0105494:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105497:	89 d1                	mov    %edx,%ecx
c0105499:	c1 e1 16             	shl    $0x16,%ecx
c010549c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010549f:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01054a2:	29 fa                	sub    %edi,%edx
c01054a4:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054a8:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01054b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01054b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054b8:	c7 04 24 0d 72 10 c0 	movl   $0xc010720d,(%esp)
c01054bf:	e8 92 ae ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01054c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c7:	c1 e0 0a             	shl    $0xa,%eax
c01054ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01054cd:	eb 50                	jmp    c010551f <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054d2:	89 04 24             	mov    %eax,(%esp)
c01054d5:	e8 83 fe ff ff       	call   c010535d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01054da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054dd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01054e0:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054e2:	89 d6                	mov    %edx,%esi
c01054e4:	c1 e6 0c             	shl    $0xc,%esi
c01054e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054ea:	89 d3                	mov    %edx,%ebx
c01054ec:	c1 e3 0c             	shl    $0xc,%ebx
c01054ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01054f2:	89 d1                	mov    %edx,%ecx
c01054f4:	c1 e1 0c             	shl    $0xc,%ecx
c01054f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054fa:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01054fd:	29 fa                	sub    %edi,%edx
c01054ff:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105503:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105507:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010550b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010550f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105513:	c7 04 24 2c 72 10 c0 	movl   $0xc010722c,(%esp)
c010551a:	e8 37 ae ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010551f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105527:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010552a:	89 d3                	mov    %edx,%ebx
c010552c:	c1 e3 0a             	shl    $0xa,%ebx
c010552f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105532:	89 d1                	mov    %edx,%ecx
c0105534:	c1 e1 0a             	shl    $0xa,%ecx
c0105537:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010553a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010553e:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105541:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105545:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105549:	89 44 24 08          	mov    %eax,0x8(%esp)
c010554d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105551:	89 0c 24             	mov    %ecx,(%esp)
c0105554:	e8 46 fe ff ff       	call   c010539f <get_pgtable_items>
c0105559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010555c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105560:	0f 85 69 ff ff ff    	jne    c01054cf <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105566:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010556b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010556e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105571:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105575:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0105578:	89 54 24 10          	mov    %edx,0x10(%esp)
c010557c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105580:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105584:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010558b:	00 
c010558c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105593:	e8 07 fe ff ff       	call   c010539f <get_pgtable_items>
c0105598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010559b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010559f:	0f 85 cf fe ff ff    	jne    c0105474 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055a5:	c7 04 24 50 72 10 c0 	movl   $0xc0107250,(%esp)
c01055ac:	e8 a5 ad ff ff       	call   c0100356 <cprintf>
}
c01055b1:	90                   	nop
c01055b2:	83 c4 4c             	add    $0x4c,%esp
c01055b5:	5b                   	pop    %ebx
c01055b6:	5e                   	pop    %esi
c01055b7:	5f                   	pop    %edi
c01055b8:	5d                   	pop    %ebp
c01055b9:	c3                   	ret    

c01055ba <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055ba:	55                   	push   %ebp
c01055bb:	89 e5                	mov    %esp,%ebp
c01055bd:	83 ec 58             	sub    $0x58,%esp
c01055c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01055c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01055c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01055cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01055d8:	8b 45 18             	mov    0x18(%ebp),%eax
c01055db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01055ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055f4:	74 1c                	je     c0105612 <printnum+0x58>
c01055f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055f9:	ba 00 00 00 00       	mov    $0x0,%edx
c01055fe:	f7 75 e4             	divl   -0x1c(%ebp)
c0105601:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105604:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105607:	ba 00 00 00 00       	mov    $0x0,%edx
c010560c:	f7 75 e4             	divl   -0x1c(%ebp)
c010560f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105612:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105615:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105618:	f7 75 e4             	divl   -0x1c(%ebp)
c010561b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010561e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105621:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105624:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105627:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010562a:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010562d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105630:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105633:	8b 45 18             	mov    0x18(%ebp),%eax
c0105636:	ba 00 00 00 00       	mov    $0x0,%edx
c010563b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010563e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105641:	19 d1                	sbb    %edx,%ecx
c0105643:	72 4c                	jb     c0105691 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105645:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105648:	8d 50 ff             	lea    -0x1(%eax),%edx
c010564b:	8b 45 20             	mov    0x20(%ebp),%eax
c010564e:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105652:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105656:	8b 45 18             	mov    0x18(%ebp),%eax
c0105659:	89 44 24 10          	mov    %eax,0x10(%esp)
c010565d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105660:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105663:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105667:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105672:	8b 45 08             	mov    0x8(%ebp),%eax
c0105675:	89 04 24             	mov    %eax,(%esp)
c0105678:	e8 3d ff ff ff       	call   c01055ba <printnum>
c010567d:	eb 1b                	jmp    c010569a <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010567f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105682:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105686:	8b 45 20             	mov    0x20(%ebp),%eax
c0105689:	89 04 24             	mov    %eax,(%esp)
c010568c:	8b 45 08             	mov    0x8(%ebp),%eax
c010568f:	ff d0                	call   *%eax
        while (-- width > 0)
c0105691:	ff 4d 1c             	decl   0x1c(%ebp)
c0105694:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105698:	7f e5                	jg     c010567f <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010569a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010569d:	05 04 73 10 c0       	add    $0xc0107304,%eax
c01056a2:	0f b6 00             	movzbl (%eax),%eax
c01056a5:	0f be c0             	movsbl %al,%eax
c01056a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056af:	89 04 24             	mov    %eax,(%esp)
c01056b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b5:	ff d0                	call   *%eax
}
c01056b7:	90                   	nop
c01056b8:	89 ec                	mov    %ebp,%esp
c01056ba:	5d                   	pop    %ebp
c01056bb:	c3                   	ret    

c01056bc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056bc:	55                   	push   %ebp
c01056bd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056c3:	7e 14                	jle    c01056d9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c8:	8b 00                	mov    (%eax),%eax
c01056ca:	8d 48 08             	lea    0x8(%eax),%ecx
c01056cd:	8b 55 08             	mov    0x8(%ebp),%edx
c01056d0:	89 0a                	mov    %ecx,(%edx)
c01056d2:	8b 50 04             	mov    0x4(%eax),%edx
c01056d5:	8b 00                	mov    (%eax),%eax
c01056d7:	eb 30                	jmp    c0105709 <getuint+0x4d>
    }
    else if (lflag) {
c01056d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056dd:	74 16                	je     c01056f5 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01056df:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e2:	8b 00                	mov    (%eax),%eax
c01056e4:	8d 48 04             	lea    0x4(%eax),%ecx
c01056e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01056ea:	89 0a                	mov    %ecx,(%edx)
c01056ec:	8b 00                	mov    (%eax),%eax
c01056ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01056f3:	eb 14                	jmp    c0105709 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01056f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f8:	8b 00                	mov    (%eax),%eax
c01056fa:	8d 48 04             	lea    0x4(%eax),%ecx
c01056fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105700:	89 0a                	mov    %ecx,(%edx)
c0105702:	8b 00                	mov    (%eax),%eax
c0105704:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105709:	5d                   	pop    %ebp
c010570a:	c3                   	ret    

c010570b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010570b:	55                   	push   %ebp
c010570c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010570e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105712:	7e 14                	jle    c0105728 <getint+0x1d>
        return va_arg(*ap, long long);
c0105714:	8b 45 08             	mov    0x8(%ebp),%eax
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	8d 48 08             	lea    0x8(%eax),%ecx
c010571c:	8b 55 08             	mov    0x8(%ebp),%edx
c010571f:	89 0a                	mov    %ecx,(%edx)
c0105721:	8b 50 04             	mov    0x4(%eax),%edx
c0105724:	8b 00                	mov    (%eax),%eax
c0105726:	eb 28                	jmp    c0105750 <getint+0x45>
    }
    else if (lflag) {
c0105728:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010572c:	74 12                	je     c0105740 <getint+0x35>
        return va_arg(*ap, long);
c010572e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105731:	8b 00                	mov    (%eax),%eax
c0105733:	8d 48 04             	lea    0x4(%eax),%ecx
c0105736:	8b 55 08             	mov    0x8(%ebp),%edx
c0105739:	89 0a                	mov    %ecx,(%edx)
c010573b:	8b 00                	mov    (%eax),%eax
c010573d:	99                   	cltd   
c010573e:	eb 10                	jmp    c0105750 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105740:	8b 45 08             	mov    0x8(%ebp),%eax
c0105743:	8b 00                	mov    (%eax),%eax
c0105745:	8d 48 04             	lea    0x4(%eax),%ecx
c0105748:	8b 55 08             	mov    0x8(%ebp),%edx
c010574b:	89 0a                	mov    %ecx,(%edx)
c010574d:	8b 00                	mov    (%eax),%eax
c010574f:	99                   	cltd   
    }
}
c0105750:	5d                   	pop    %ebp
c0105751:	c3                   	ret    

c0105752 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105752:	55                   	push   %ebp
c0105753:	89 e5                	mov    %esp,%ebp
c0105755:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105758:	8d 45 14             	lea    0x14(%ebp),%eax
c010575b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010575e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105761:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105765:	8b 45 10             	mov    0x10(%ebp),%eax
c0105768:	89 44 24 08          	mov    %eax,0x8(%esp)
c010576c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010576f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105773:	8b 45 08             	mov    0x8(%ebp),%eax
c0105776:	89 04 24             	mov    %eax,(%esp)
c0105779:	e8 05 00 00 00       	call   c0105783 <vprintfmt>
    va_end(ap);
}
c010577e:	90                   	nop
c010577f:	89 ec                	mov    %ebp,%esp
c0105781:	5d                   	pop    %ebp
c0105782:	c3                   	ret    

c0105783 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105783:	55                   	push   %ebp
c0105784:	89 e5                	mov    %esp,%ebp
c0105786:	56                   	push   %esi
c0105787:	53                   	push   %ebx
c0105788:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010578b:	eb 17                	jmp    c01057a4 <vprintfmt+0x21>
            if (ch == '\0') {
c010578d:	85 db                	test   %ebx,%ebx
c010578f:	0f 84 bf 03 00 00    	je     c0105b54 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105798:	89 44 24 04          	mov    %eax,0x4(%esp)
c010579c:	89 1c 24             	mov    %ebx,(%esp)
c010579f:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01057a7:	8d 50 01             	lea    0x1(%eax),%edx
c01057aa:	89 55 10             	mov    %edx,0x10(%ebp)
c01057ad:	0f b6 00             	movzbl (%eax),%eax
c01057b0:	0f b6 d8             	movzbl %al,%ebx
c01057b3:	83 fb 25             	cmp    $0x25,%ebx
c01057b6:	75 d5                	jne    c010578d <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057b8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057d3:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01057d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01057d9:	8d 50 01             	lea    0x1(%eax),%edx
c01057dc:	89 55 10             	mov    %edx,0x10(%ebp)
c01057df:	0f b6 00             	movzbl (%eax),%eax
c01057e2:	0f b6 d8             	movzbl %al,%ebx
c01057e5:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01057e8:	83 f8 55             	cmp    $0x55,%eax
c01057eb:	0f 87 37 03 00 00    	ja     c0105b28 <vprintfmt+0x3a5>
c01057f1:	8b 04 85 28 73 10 c0 	mov    -0x3fef8cd8(,%eax,4),%eax
c01057f8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01057fa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01057fe:	eb d6                	jmp    c01057d6 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105800:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105804:	eb d0                	jmp    c01057d6 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105806:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010580d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105810:	89 d0                	mov    %edx,%eax
c0105812:	c1 e0 02             	shl    $0x2,%eax
c0105815:	01 d0                	add    %edx,%eax
c0105817:	01 c0                	add    %eax,%eax
c0105819:	01 d8                	add    %ebx,%eax
c010581b:	83 e8 30             	sub    $0x30,%eax
c010581e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105821:	8b 45 10             	mov    0x10(%ebp),%eax
c0105824:	0f b6 00             	movzbl (%eax),%eax
c0105827:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010582a:	83 fb 2f             	cmp    $0x2f,%ebx
c010582d:	7e 38                	jle    c0105867 <vprintfmt+0xe4>
c010582f:	83 fb 39             	cmp    $0x39,%ebx
c0105832:	7f 33                	jg     c0105867 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105834:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105837:	eb d4                	jmp    c010580d <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105839:	8b 45 14             	mov    0x14(%ebp),%eax
c010583c:	8d 50 04             	lea    0x4(%eax),%edx
c010583f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105842:	8b 00                	mov    (%eax),%eax
c0105844:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105847:	eb 1f                	jmp    c0105868 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105849:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010584d:	79 87                	jns    c01057d6 <vprintfmt+0x53>
                width = 0;
c010584f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105856:	e9 7b ff ff ff       	jmp    c01057d6 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010585b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105862:	e9 6f ff ff ff       	jmp    c01057d6 <vprintfmt+0x53>
            goto process_precision;
c0105867:	90                   	nop

        process_precision:
            if (width < 0)
c0105868:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010586c:	0f 89 64 ff ff ff    	jns    c01057d6 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105875:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105878:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010587f:	e9 52 ff ff ff       	jmp    c01057d6 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105884:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105887:	e9 4a ff ff ff       	jmp    c01057d6 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010588c:	8b 45 14             	mov    0x14(%ebp),%eax
c010588f:	8d 50 04             	lea    0x4(%eax),%edx
c0105892:	89 55 14             	mov    %edx,0x14(%ebp)
c0105895:	8b 00                	mov    (%eax),%eax
c0105897:	8b 55 0c             	mov    0xc(%ebp),%edx
c010589a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010589e:	89 04 24             	mov    %eax,(%esp)
c01058a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a4:	ff d0                	call   *%eax
            break;
c01058a6:	e9 a4 02 00 00       	jmp    c0105b4f <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058ab:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ae:	8d 50 04             	lea    0x4(%eax),%edx
c01058b1:	89 55 14             	mov    %edx,0x14(%ebp)
c01058b4:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058b6:	85 db                	test   %ebx,%ebx
c01058b8:	79 02                	jns    c01058bc <vprintfmt+0x139>
                err = -err;
c01058ba:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058bc:	83 fb 06             	cmp    $0x6,%ebx
c01058bf:	7f 0b                	jg     c01058cc <vprintfmt+0x149>
c01058c1:	8b 34 9d e8 72 10 c0 	mov    -0x3fef8d18(,%ebx,4),%esi
c01058c8:	85 f6                	test   %esi,%esi
c01058ca:	75 23                	jne    c01058ef <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01058cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01058d0:	c7 44 24 08 15 73 10 	movl   $0xc0107315,0x8(%esp)
c01058d7:	c0 
c01058d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058df:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e2:	89 04 24             	mov    %eax,(%esp)
c01058e5:	e8 68 fe ff ff       	call   c0105752 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01058ea:	e9 60 02 00 00       	jmp    c0105b4f <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01058ef:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01058f3:	c7 44 24 08 1e 73 10 	movl   $0xc010731e,0x8(%esp)
c01058fa:	c0 
c01058fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105902:	8b 45 08             	mov    0x8(%ebp),%eax
c0105905:	89 04 24             	mov    %eax,(%esp)
c0105908:	e8 45 fe ff ff       	call   c0105752 <printfmt>
            break;
c010590d:	e9 3d 02 00 00       	jmp    c0105b4f <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105912:	8b 45 14             	mov    0x14(%ebp),%eax
c0105915:	8d 50 04             	lea    0x4(%eax),%edx
c0105918:	89 55 14             	mov    %edx,0x14(%ebp)
c010591b:	8b 30                	mov    (%eax),%esi
c010591d:	85 f6                	test   %esi,%esi
c010591f:	75 05                	jne    c0105926 <vprintfmt+0x1a3>
                p = "(null)";
c0105921:	be 21 73 10 c0       	mov    $0xc0107321,%esi
            }
            if (width > 0 && padc != '-') {
c0105926:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010592a:	7e 76                	jle    c01059a2 <vprintfmt+0x21f>
c010592c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105930:	74 70                	je     c01059a2 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105935:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105939:	89 34 24             	mov    %esi,(%esp)
c010593c:	e8 16 03 00 00       	call   c0105c57 <strnlen>
c0105941:	89 c2                	mov    %eax,%edx
c0105943:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105946:	29 d0                	sub    %edx,%eax
c0105948:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010594b:	eb 16                	jmp    c0105963 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010594d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105951:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105954:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105958:	89 04 24             	mov    %eax,(%esp)
c010595b:	8b 45 08             	mov    0x8(%ebp),%eax
c010595e:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105960:	ff 4d e8             	decl   -0x18(%ebp)
c0105963:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105967:	7f e4                	jg     c010594d <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105969:	eb 37                	jmp    c01059a2 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010596b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010596f:	74 1f                	je     c0105990 <vprintfmt+0x20d>
c0105971:	83 fb 1f             	cmp    $0x1f,%ebx
c0105974:	7e 05                	jle    c010597b <vprintfmt+0x1f8>
c0105976:	83 fb 7e             	cmp    $0x7e,%ebx
c0105979:	7e 15                	jle    c0105990 <vprintfmt+0x20d>
                    putch('?', putdat);
c010597b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105982:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105989:	8b 45 08             	mov    0x8(%ebp),%eax
c010598c:	ff d0                	call   *%eax
c010598e:	eb 0f                	jmp    c010599f <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105990:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105993:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105997:	89 1c 24             	mov    %ebx,(%esp)
c010599a:	8b 45 08             	mov    0x8(%ebp),%eax
c010599d:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010599f:	ff 4d e8             	decl   -0x18(%ebp)
c01059a2:	89 f0                	mov    %esi,%eax
c01059a4:	8d 70 01             	lea    0x1(%eax),%esi
c01059a7:	0f b6 00             	movzbl (%eax),%eax
c01059aa:	0f be d8             	movsbl %al,%ebx
c01059ad:	85 db                	test   %ebx,%ebx
c01059af:	74 27                	je     c01059d8 <vprintfmt+0x255>
c01059b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059b5:	78 b4                	js     c010596b <vprintfmt+0x1e8>
c01059b7:	ff 4d e4             	decl   -0x1c(%ebp)
c01059ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059be:	79 ab                	jns    c010596b <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01059c0:	eb 16                	jmp    c01059d8 <vprintfmt+0x255>
                putch(' ', putdat);
c01059c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01059d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d3:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01059d5:	ff 4d e8             	decl   -0x18(%ebp)
c01059d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059dc:	7f e4                	jg     c01059c2 <vprintfmt+0x23f>
            }
            break;
c01059de:	e9 6c 01 00 00       	jmp    c0105b4f <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01059e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ea:	8d 45 14             	lea    0x14(%ebp),%eax
c01059ed:	89 04 24             	mov    %eax,(%esp)
c01059f0:	e8 16 fd ff ff       	call   c010570b <getint>
c01059f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a01:	85 d2                	test   %edx,%edx
c0105a03:	79 26                	jns    c0105a2b <vprintfmt+0x2a8>
                putch('-', putdat);
c0105a05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a0c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a16:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1e:	f7 d8                	neg    %eax
c0105a20:	83 d2 00             	adc    $0x0,%edx
c0105a23:	f7 da                	neg    %edx
c0105a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a28:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a32:	e9 a8 00 00 00       	jmp    c0105adf <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a41:	89 04 24             	mov    %eax,(%esp)
c0105a44:	e8 73 fc ff ff       	call   c01056bc <getuint>
c0105a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a56:	e9 84 00 00 00       	jmp    c0105adf <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a62:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a65:	89 04 24             	mov    %eax,(%esp)
c0105a68:	e8 4f fc ff ff       	call   c01056bc <getuint>
c0105a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105a73:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105a7a:	eb 63                	jmp    c0105adf <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a83:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8d:	ff d0                	call   *%eax
            putch('x', putdat);
c0105a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a96:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105aa2:	8b 45 14             	mov    0x14(%ebp),%eax
c0105aa5:	8d 50 04             	lea    0x4(%eax),%edx
c0105aa8:	89 55 14             	mov    %edx,0x14(%ebp)
c0105aab:	8b 00                	mov    (%eax),%eax
c0105aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ab7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105abe:	eb 1f                	jmp    c0105adf <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac7:	8d 45 14             	lea    0x14(%ebp),%eax
c0105aca:	89 04 24             	mov    %eax,(%esp)
c0105acd:	e8 ea fb ff ff       	call   c01056bc <getuint>
c0105ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ad5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105ad8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105adf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ae6:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105aea:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105aed:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105af1:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105afb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105aff:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0d:	89 04 24             	mov    %eax,(%esp)
c0105b10:	e8 a5 fa ff ff       	call   c01055ba <printnum>
            break;
c0105b15:	eb 38                	jmp    c0105b4f <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b1e:	89 1c 24             	mov    %ebx,(%esp)
c0105b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b24:	ff d0                	call   *%eax
            break;
c0105b26:	eb 27                	jmp    c0105b4f <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b2f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b39:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b3b:	ff 4d 10             	decl   0x10(%ebp)
c0105b3e:	eb 03                	jmp    c0105b43 <vprintfmt+0x3c0>
c0105b40:	ff 4d 10             	decl   0x10(%ebp)
c0105b43:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b46:	48                   	dec    %eax
c0105b47:	0f b6 00             	movzbl (%eax),%eax
c0105b4a:	3c 25                	cmp    $0x25,%al
c0105b4c:	75 f2                	jne    c0105b40 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105b4e:	90                   	nop
    while (1) {
c0105b4f:	e9 37 fc ff ff       	jmp    c010578b <vprintfmt+0x8>
                return;
c0105b54:	90                   	nop
        }
    }
}
c0105b55:	83 c4 40             	add    $0x40,%esp
c0105b58:	5b                   	pop    %ebx
c0105b59:	5e                   	pop    %esi
c0105b5a:	5d                   	pop    %ebp
c0105b5b:	c3                   	ret    

c0105b5c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b5c:	55                   	push   %ebp
c0105b5d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b62:	8b 40 08             	mov    0x8(%eax),%eax
c0105b65:	8d 50 01             	lea    0x1(%eax),%edx
c0105b68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b71:	8b 10                	mov    (%eax),%edx
c0105b73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b76:	8b 40 04             	mov    0x4(%eax),%eax
c0105b79:	39 c2                	cmp    %eax,%edx
c0105b7b:	73 12                	jae    c0105b8f <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b80:	8b 00                	mov    (%eax),%eax
c0105b82:	8d 48 01             	lea    0x1(%eax),%ecx
c0105b85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b88:	89 0a                	mov    %ecx,(%edx)
c0105b8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b8d:	88 10                	mov    %dl,(%eax)
    }
}
c0105b8f:	90                   	nop
c0105b90:	5d                   	pop    %ebp
c0105b91:	c3                   	ret    

c0105b92 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105b92:	55                   	push   %ebp
c0105b93:	89 e5                	mov    %esp,%ebp
c0105b95:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b98:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ba1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ba5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ba8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105baf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb6:	89 04 24             	mov    %eax,(%esp)
c0105bb9:	e8 0a 00 00 00       	call   c0105bc8 <vsnprintf>
c0105bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bc4:	89 ec                	mov    %ebp,%esp
c0105bc6:	5d                   	pop    %ebp
c0105bc7:	c3                   	ret    

c0105bc8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bc8:	55                   	push   %ebp
c0105bc9:	89 e5                	mov    %esp,%ebp
c0105bcb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdd:	01 d0                	add    %edx,%eax
c0105bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105be9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105bed:	74 0a                	je     c0105bf9 <vsnprintf+0x31>
c0105bef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bf5:	39 c2                	cmp    %eax,%edx
c0105bf7:	76 07                	jbe    c0105c00 <vsnprintf+0x38>
        return -E_INVAL;
c0105bf9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105bfe:	eb 2a                	jmp    c0105c2a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c00:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c07:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c0a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c15:	c7 04 24 5c 5b 10 c0 	movl   $0xc0105b5c,(%esp)
c0105c1c:	e8 62 fb ff ff       	call   c0105783 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c24:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c2a:	89 ec                	mov    %ebp,%esp
c0105c2c:	5d                   	pop    %ebp
c0105c2d:	c3                   	ret    

c0105c2e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c2e:	55                   	push   %ebp
c0105c2f:	89 e5                	mov    %esp,%ebp
c0105c31:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c3b:	eb 03                	jmp    c0105c40 <strlen+0x12>
        cnt ++;
c0105c3d:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c43:	8d 50 01             	lea    0x1(%eax),%edx
c0105c46:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c49:	0f b6 00             	movzbl (%eax),%eax
c0105c4c:	84 c0                	test   %al,%al
c0105c4e:	75 ed                	jne    c0105c3d <strlen+0xf>
    }
    return cnt;
c0105c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c53:	89 ec                	mov    %ebp,%esp
c0105c55:	5d                   	pop    %ebp
c0105c56:	c3                   	ret    

c0105c57 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105c57:	55                   	push   %ebp
c0105c58:	89 e5                	mov    %esp,%ebp
c0105c5a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c64:	eb 03                	jmp    c0105c69 <strnlen+0x12>
        cnt ++;
c0105c66:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c6f:	73 10                	jae    c0105c81 <strnlen+0x2a>
c0105c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c74:	8d 50 01             	lea    0x1(%eax),%edx
c0105c77:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c7a:	0f b6 00             	movzbl (%eax),%eax
c0105c7d:	84 c0                	test   %al,%al
c0105c7f:	75 e5                	jne    c0105c66 <strnlen+0xf>
    }
    return cnt;
c0105c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c84:	89 ec                	mov    %ebp,%esp
c0105c86:	5d                   	pop    %ebp
c0105c87:	c3                   	ret    

c0105c88 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105c88:	55                   	push   %ebp
c0105c89:	89 e5                	mov    %esp,%ebp
c0105c8b:	57                   	push   %edi
c0105c8c:	56                   	push   %esi
c0105c8d:	83 ec 20             	sub    $0x20,%esp
c0105c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105c9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ca2:	89 d1                	mov    %edx,%ecx
c0105ca4:	89 c2                	mov    %eax,%edx
c0105ca6:	89 ce                	mov    %ecx,%esi
c0105ca8:	89 d7                	mov    %edx,%edi
c0105caa:	ac                   	lods   %ds:(%esi),%al
c0105cab:	aa                   	stos   %al,%es:(%edi)
c0105cac:	84 c0                	test   %al,%al
c0105cae:	75 fa                	jne    c0105caa <strcpy+0x22>
c0105cb0:	89 fa                	mov    %edi,%edx
c0105cb2:	89 f1                	mov    %esi,%ecx
c0105cb4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cb7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105cba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105cc0:	83 c4 20             	add    $0x20,%esp
c0105cc3:	5e                   	pop    %esi
c0105cc4:	5f                   	pop    %edi
c0105cc5:	5d                   	pop    %ebp
c0105cc6:	c3                   	ret    

c0105cc7 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105cc7:	55                   	push   %ebp
c0105cc8:	89 e5                	mov    %esp,%ebp
c0105cca:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105cd3:	eb 1e                	jmp    c0105cf3 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd8:	0f b6 10             	movzbl (%eax),%edx
c0105cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cde:	88 10                	mov    %dl,(%eax)
c0105ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ce3:	0f b6 00             	movzbl (%eax),%eax
c0105ce6:	84 c0                	test   %al,%al
c0105ce8:	74 03                	je     c0105ced <strncpy+0x26>
            src ++;
c0105cea:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105ced:	ff 45 fc             	incl   -0x4(%ebp)
c0105cf0:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105cf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cf7:	75 dc                	jne    c0105cd5 <strncpy+0xe>
    }
    return dst;
c0105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105cfc:	89 ec                	mov    %ebp,%esp
c0105cfe:	5d                   	pop    %ebp
c0105cff:	c3                   	ret    

c0105d00 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d00:	55                   	push   %ebp
c0105d01:	89 e5                	mov    %esp,%ebp
c0105d03:	57                   	push   %edi
c0105d04:	56                   	push   %esi
c0105d05:	83 ec 20             	sub    $0x20,%esp
c0105d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d1a:	89 d1                	mov    %edx,%ecx
c0105d1c:	89 c2                	mov    %eax,%edx
c0105d1e:	89 ce                	mov    %ecx,%esi
c0105d20:	89 d7                	mov    %edx,%edi
c0105d22:	ac                   	lods   %ds:(%esi),%al
c0105d23:	ae                   	scas   %es:(%edi),%al
c0105d24:	75 08                	jne    c0105d2e <strcmp+0x2e>
c0105d26:	84 c0                	test   %al,%al
c0105d28:	75 f8                	jne    c0105d22 <strcmp+0x22>
c0105d2a:	31 c0                	xor    %eax,%eax
c0105d2c:	eb 04                	jmp    c0105d32 <strcmp+0x32>
c0105d2e:	19 c0                	sbb    %eax,%eax
c0105d30:	0c 01                	or     $0x1,%al
c0105d32:	89 fa                	mov    %edi,%edx
c0105d34:	89 f1                	mov    %esi,%ecx
c0105d36:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d39:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d3c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d42:	83 c4 20             	add    $0x20,%esp
c0105d45:	5e                   	pop    %esi
c0105d46:	5f                   	pop    %edi
c0105d47:	5d                   	pop    %ebp
c0105d48:	c3                   	ret    

c0105d49 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d49:	55                   	push   %ebp
c0105d4a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d4c:	eb 09                	jmp    c0105d57 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105d4e:	ff 4d 10             	decl   0x10(%ebp)
c0105d51:	ff 45 08             	incl   0x8(%ebp)
c0105d54:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d5b:	74 1a                	je     c0105d77 <strncmp+0x2e>
c0105d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d60:	0f b6 00             	movzbl (%eax),%eax
c0105d63:	84 c0                	test   %al,%al
c0105d65:	74 10                	je     c0105d77 <strncmp+0x2e>
c0105d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6a:	0f b6 10             	movzbl (%eax),%edx
c0105d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d70:	0f b6 00             	movzbl (%eax),%eax
c0105d73:	38 c2                	cmp    %al,%dl
c0105d75:	74 d7                	je     c0105d4e <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d7b:	74 18                	je     c0105d95 <strncmp+0x4c>
c0105d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d80:	0f b6 00             	movzbl (%eax),%eax
c0105d83:	0f b6 d0             	movzbl %al,%edx
c0105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d89:	0f b6 00             	movzbl (%eax),%eax
c0105d8c:	0f b6 c8             	movzbl %al,%ecx
c0105d8f:	89 d0                	mov    %edx,%eax
c0105d91:	29 c8                	sub    %ecx,%eax
c0105d93:	eb 05                	jmp    c0105d9a <strncmp+0x51>
c0105d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d9a:	5d                   	pop    %ebp
c0105d9b:	c3                   	ret    

c0105d9c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105d9c:	55                   	push   %ebp
c0105d9d:	89 e5                	mov    %esp,%ebp
c0105d9f:	83 ec 04             	sub    $0x4,%esp
c0105da2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105da8:	eb 13                	jmp    c0105dbd <strchr+0x21>
        if (*s == c) {
c0105daa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dad:	0f b6 00             	movzbl (%eax),%eax
c0105db0:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105db3:	75 05                	jne    c0105dba <strchr+0x1e>
            return (char *)s;
c0105db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db8:	eb 12                	jmp    c0105dcc <strchr+0x30>
        }
        s ++;
c0105dba:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc0:	0f b6 00             	movzbl (%eax),%eax
c0105dc3:	84 c0                	test   %al,%al
c0105dc5:	75 e3                	jne    c0105daa <strchr+0xe>
    }
    return NULL;
c0105dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dcc:	89 ec                	mov    %ebp,%esp
c0105dce:	5d                   	pop    %ebp
c0105dcf:	c3                   	ret    

c0105dd0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105dd0:	55                   	push   %ebp
c0105dd1:	89 e5                	mov    %esp,%ebp
c0105dd3:	83 ec 04             	sub    $0x4,%esp
c0105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ddc:	eb 0e                	jmp    c0105dec <strfind+0x1c>
        if (*s == c) {
c0105dde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de1:	0f b6 00             	movzbl (%eax),%eax
c0105de4:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105de7:	74 0f                	je     c0105df8 <strfind+0x28>
            break;
        }
        s ++;
c0105de9:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105def:	0f b6 00             	movzbl (%eax),%eax
c0105df2:	84 c0                	test   %al,%al
c0105df4:	75 e8                	jne    c0105dde <strfind+0xe>
c0105df6:	eb 01                	jmp    c0105df9 <strfind+0x29>
            break;
c0105df8:	90                   	nop
    }
    return (char *)s;
c0105df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105dfc:	89 ec                	mov    %ebp,%esp
c0105dfe:	5d                   	pop    %ebp
c0105dff:	c3                   	ret    

c0105e00 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e00:	55                   	push   %ebp
c0105e01:	89 e5                	mov    %esp,%ebp
c0105e03:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e14:	eb 03                	jmp    c0105e19 <strtol+0x19>
        s ++;
c0105e16:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105e19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1c:	0f b6 00             	movzbl (%eax),%eax
c0105e1f:	3c 20                	cmp    $0x20,%al
c0105e21:	74 f3                	je     c0105e16 <strtol+0x16>
c0105e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e26:	0f b6 00             	movzbl (%eax),%eax
c0105e29:	3c 09                	cmp    $0x9,%al
c0105e2b:	74 e9                	je     c0105e16 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e30:	0f b6 00             	movzbl (%eax),%eax
c0105e33:	3c 2b                	cmp    $0x2b,%al
c0105e35:	75 05                	jne    c0105e3c <strtol+0x3c>
        s ++;
c0105e37:	ff 45 08             	incl   0x8(%ebp)
c0105e3a:	eb 14                	jmp    c0105e50 <strtol+0x50>
    }
    else if (*s == '-') {
c0105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3f:	0f b6 00             	movzbl (%eax),%eax
c0105e42:	3c 2d                	cmp    $0x2d,%al
c0105e44:	75 0a                	jne    c0105e50 <strtol+0x50>
        s ++, neg = 1;
c0105e46:	ff 45 08             	incl   0x8(%ebp)
c0105e49:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105e50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e54:	74 06                	je     c0105e5c <strtol+0x5c>
c0105e56:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105e5a:	75 22                	jne    c0105e7e <strtol+0x7e>
c0105e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5f:	0f b6 00             	movzbl (%eax),%eax
c0105e62:	3c 30                	cmp    $0x30,%al
c0105e64:	75 18                	jne    c0105e7e <strtol+0x7e>
c0105e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e69:	40                   	inc    %eax
c0105e6a:	0f b6 00             	movzbl (%eax),%eax
c0105e6d:	3c 78                	cmp    $0x78,%al
c0105e6f:	75 0d                	jne    c0105e7e <strtol+0x7e>
        s += 2, base = 16;
c0105e71:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105e75:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105e7c:	eb 29                	jmp    c0105ea7 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105e7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e82:	75 16                	jne    c0105e9a <strtol+0x9a>
c0105e84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e87:	0f b6 00             	movzbl (%eax),%eax
c0105e8a:	3c 30                	cmp    $0x30,%al
c0105e8c:	75 0c                	jne    c0105e9a <strtol+0x9a>
        s ++, base = 8;
c0105e8e:	ff 45 08             	incl   0x8(%ebp)
c0105e91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105e98:	eb 0d                	jmp    c0105ea7 <strtol+0xa7>
    }
    else if (base == 0) {
c0105e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e9e:	75 07                	jne    c0105ea7 <strtol+0xa7>
        base = 10;
c0105ea0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eaa:	0f b6 00             	movzbl (%eax),%eax
c0105ead:	3c 2f                	cmp    $0x2f,%al
c0105eaf:	7e 1b                	jle    c0105ecc <strtol+0xcc>
c0105eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb4:	0f b6 00             	movzbl (%eax),%eax
c0105eb7:	3c 39                	cmp    $0x39,%al
c0105eb9:	7f 11                	jg     c0105ecc <strtol+0xcc>
            dig = *s - '0';
c0105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebe:	0f b6 00             	movzbl (%eax),%eax
c0105ec1:	0f be c0             	movsbl %al,%eax
c0105ec4:	83 e8 30             	sub    $0x30,%eax
c0105ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eca:	eb 48                	jmp    c0105f14 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ecc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ecf:	0f b6 00             	movzbl (%eax),%eax
c0105ed2:	3c 60                	cmp    $0x60,%al
c0105ed4:	7e 1b                	jle    c0105ef1 <strtol+0xf1>
c0105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed9:	0f b6 00             	movzbl (%eax),%eax
c0105edc:	3c 7a                	cmp    $0x7a,%al
c0105ede:	7f 11                	jg     c0105ef1 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee3:	0f b6 00             	movzbl (%eax),%eax
c0105ee6:	0f be c0             	movsbl %al,%eax
c0105ee9:	83 e8 57             	sub    $0x57,%eax
c0105eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eef:	eb 23                	jmp    c0105f14 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef4:	0f b6 00             	movzbl (%eax),%eax
c0105ef7:	3c 40                	cmp    $0x40,%al
c0105ef9:	7e 3b                	jle    c0105f36 <strtol+0x136>
c0105efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efe:	0f b6 00             	movzbl (%eax),%eax
c0105f01:	3c 5a                	cmp    $0x5a,%al
c0105f03:	7f 31                	jg     c0105f36 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f08:	0f b6 00             	movzbl (%eax),%eax
c0105f0b:	0f be c0             	movsbl %al,%eax
c0105f0e:	83 e8 37             	sub    $0x37,%eax
c0105f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f17:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f1a:	7d 19                	jge    c0105f35 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105f1c:	ff 45 08             	incl   0x8(%ebp)
c0105f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f22:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f26:	89 c2                	mov    %eax,%edx
c0105f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f2b:	01 d0                	add    %edx,%eax
c0105f2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105f30:	e9 72 ff ff ff       	jmp    c0105ea7 <strtol+0xa7>
            break;
c0105f35:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f3a:	74 08                	je     c0105f44 <strtol+0x144>
        *endptr = (char *) s;
c0105f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f3f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f42:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f44:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f48:	74 07                	je     c0105f51 <strtol+0x151>
c0105f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f4d:	f7 d8                	neg    %eax
c0105f4f:	eb 03                	jmp    c0105f54 <strtol+0x154>
c0105f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105f54:	89 ec                	mov    %ebp,%esp
c0105f56:	5d                   	pop    %ebp
c0105f57:	c3                   	ret    

c0105f58 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105f58:	55                   	push   %ebp
c0105f59:	89 e5                	mov    %esp,%ebp
c0105f5b:	83 ec 28             	sub    $0x28,%esp
c0105f5e:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105f61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f64:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105f67:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105f6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105f71:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105f74:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105f7a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105f7d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105f81:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105f84:	89 d7                	mov    %edx,%edi
c0105f86:	f3 aa                	rep stos %al,%es:(%edi)
c0105f88:	89 fa                	mov    %edi,%edx
c0105f8a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105f8d:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105f93:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105f96:	89 ec                	mov    %ebp,%esp
c0105f98:	5d                   	pop    %ebp
c0105f99:	c3                   	ret    

c0105f9a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105f9a:	55                   	push   %ebp
c0105f9b:	89 e5                	mov    %esp,%ebp
c0105f9d:	57                   	push   %edi
c0105f9e:	56                   	push   %esi
c0105f9f:	53                   	push   %ebx
c0105fa0:	83 ec 30             	sub    $0x30,%esp
c0105fa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105faf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fb2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fb8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105fbb:	73 42                	jae    c0105fff <memmove+0x65>
c0105fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fd2:	c1 e8 02             	shr    $0x2,%eax
c0105fd5:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fdd:	89 d7                	mov    %edx,%edi
c0105fdf:	89 c6                	mov    %eax,%esi
c0105fe1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105fe3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105fe6:	83 e1 03             	and    $0x3,%ecx
c0105fe9:	74 02                	je     c0105fed <memmove+0x53>
c0105feb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105fed:	89 f0                	mov    %esi,%eax
c0105fef:	89 fa                	mov    %edi,%edx
c0105ff1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ff4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ff7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105ffd:	eb 36                	jmp    c0106035 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106002:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106005:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106008:	01 c2                	add    %eax,%edx
c010600a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010600d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106010:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106013:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0106016:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106019:	89 c1                	mov    %eax,%ecx
c010601b:	89 d8                	mov    %ebx,%eax
c010601d:	89 d6                	mov    %edx,%esi
c010601f:	89 c7                	mov    %eax,%edi
c0106021:	fd                   	std    
c0106022:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106024:	fc                   	cld    
c0106025:	89 f8                	mov    %edi,%eax
c0106027:	89 f2                	mov    %esi,%edx
c0106029:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010602c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010602f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106032:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106035:	83 c4 30             	add    $0x30,%esp
c0106038:	5b                   	pop    %ebx
c0106039:	5e                   	pop    %esi
c010603a:	5f                   	pop    %edi
c010603b:	5d                   	pop    %ebp
c010603c:	c3                   	ret    

c010603d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010603d:	55                   	push   %ebp
c010603e:	89 e5                	mov    %esp,%ebp
c0106040:	57                   	push   %edi
c0106041:	56                   	push   %esi
c0106042:	83 ec 20             	sub    $0x20,%esp
c0106045:	8b 45 08             	mov    0x8(%ebp),%eax
c0106048:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010604b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010604e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106051:	8b 45 10             	mov    0x10(%ebp),%eax
c0106054:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106057:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010605a:	c1 e8 02             	shr    $0x2,%eax
c010605d:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010605f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106065:	89 d7                	mov    %edx,%edi
c0106067:	89 c6                	mov    %eax,%esi
c0106069:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010606b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010606e:	83 e1 03             	and    $0x3,%ecx
c0106071:	74 02                	je     c0106075 <memcpy+0x38>
c0106073:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106075:	89 f0                	mov    %esi,%eax
c0106077:	89 fa                	mov    %edi,%edx
c0106079:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010607c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010607f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0106082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106085:	83 c4 20             	add    $0x20,%esp
c0106088:	5e                   	pop    %esi
c0106089:	5f                   	pop    %edi
c010608a:	5d                   	pop    %ebp
c010608b:	c3                   	ret    

c010608c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010608c:	55                   	push   %ebp
c010608d:	89 e5                	mov    %esp,%ebp
c010608f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106092:	8b 45 08             	mov    0x8(%ebp),%eax
c0106095:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106098:	8b 45 0c             	mov    0xc(%ebp),%eax
c010609b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010609e:	eb 2e                	jmp    c01060ce <memcmp+0x42>
        if (*s1 != *s2) {
c01060a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060a3:	0f b6 10             	movzbl (%eax),%edx
c01060a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060a9:	0f b6 00             	movzbl (%eax),%eax
c01060ac:	38 c2                	cmp    %al,%dl
c01060ae:	74 18                	je     c01060c8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01060b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060b3:	0f b6 00             	movzbl (%eax),%eax
c01060b6:	0f b6 d0             	movzbl %al,%edx
c01060b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060bc:	0f b6 00             	movzbl (%eax),%eax
c01060bf:	0f b6 c8             	movzbl %al,%ecx
c01060c2:	89 d0                	mov    %edx,%eax
c01060c4:	29 c8                	sub    %ecx,%eax
c01060c6:	eb 18                	jmp    c01060e0 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01060c8:	ff 45 fc             	incl   -0x4(%ebp)
c01060cb:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01060ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01060d1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01060d4:	89 55 10             	mov    %edx,0x10(%ebp)
c01060d7:	85 c0                	test   %eax,%eax
c01060d9:	75 c5                	jne    c01060a0 <memcmp+0x14>
    }
    return 0;
c01060db:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060e0:	89 ec                	mov    %ebp,%esp
c01060e2:	5d                   	pop    %ebp
c01060e3:	c3                   	ret    
