
bin/kernel:     file format elf32-i386


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
c0100059:	e8 4a 5f 00 00       	call   c0105fa8 <memset>

    cons_init();                // init the console
c010005e:	e8 f7 15 00 00       	call   c010165a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 40 61 10 c0 	movl   $0xc0106140,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 5c 61 10 c0 	movl   $0xc010615c,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 82 44 00 00       	call   c010450e <pmm_init>

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
c0100167:	c7 04 24 61 61 10 c0 	movl   $0xc0106161,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 6f 61 10 c0 	movl   $0xc010616f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 7d 61 10 c0 	movl   $0xc010617d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 8b 61 10 c0 	movl   $0xc010618b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 99 61 10 c0 	movl   $0xc0106199,(%esp)
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
c0100216:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 c8 61 10 c0 	movl   $0xc01061c8,(%esp)
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
c010025a:	c7 04 24 e7 61 10 c0 	movl   $0xc01061e7,(%esp)
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
c010034a:	e8 84 54 00 00       	call   c01057d3 <vprintfmt>
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
c010055a:	c7 00 ec 61 10 c0    	movl   $0xc01061ec,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 ec 61 10 c0 	movl   $0xc01061ec,0x8(%eax)
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
c0100591:	c7 45 f4 c4 74 10 c0 	movl   $0xc01074c4,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 88 2e 11 c0 	movl   $0xc0112e88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec 89 2e 11 c0 	movl   $0xc0112e89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 36 64 11 c0 	movl   $0xc0116436,-0x18(%ebp)

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
c01006f9:	e8 22 57 00 00       	call   c0105e20 <strfind>
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
c010087f:	c7 04 24 f6 61 10 c0 	movl   $0xc01061f6,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 0f 62 10 c0 	movl   $0xc010620f,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 34 61 10 	movl   $0xc0106134,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 27 62 10 c0 	movl   $0xc0106227,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 3f 62 10 c0 	movl   $0xc010623f,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c cf 11 	movl   $0xc011cf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 57 62 10 c0 	movl   $0xc0106257,(%esp)
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
c01008fc:	c7 04 24 70 62 10 c0 	movl   $0xc0106270,(%esp)
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
c0100933:	c7 04 24 9a 62 10 c0 	movl   $0xc010629a,(%esp)
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
c01009a1:	c7 04 24 b6 62 10 c0 	movl   $0xc01062b6,(%esp)
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
c0100a05:	c7 04 24 c8 62 10 c0 	movl   $0xc01062c8,(%esp)
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
c0100a41:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c0100a48:	e8 09 f9 ff ff       	call   c0100356 <cprintf>

        cprintf("\n");
c0100a4d:	c7 04 24 01 63 10 c0 	movl   $0xc0106301,(%esp)
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
c0100ac2:	c7 04 24 84 63 10 c0 	movl   $0xc0106384,(%esp)
c0100ac9:	e8 1e 53 00 00       	call   c0105dec <strchr>
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
c0100aea:	c7 04 24 89 63 10 c0 	movl   $0xc0106389,(%esp)
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
c0100b2c:	c7 04 24 84 63 10 c0 	movl   $0xc0106384,(%esp)
c0100b33:	e8 b4 52 00 00       	call   c0105dec <strchr>
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
c0100b9d:	e8 ae 51 00 00       	call   c0105d50 <strcmp>
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
c0100be9:	c7 04 24 a7 63 10 c0 	movl   $0xc01063a7,(%esp)
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
c0100c07:	c7 04 24 c0 63 10 c0 	movl   $0xc01063c0,(%esp)
c0100c0e:	e8 43 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c13:	c7 04 24 e8 63 10 c0 	movl   $0xc01063e8,(%esp)
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
c0100c30:	c7 04 24 0d 64 10 c0 	movl   $0xc010640d,(%esp)
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
c0100ca0:	c7 04 24 11 64 10 c0 	movl   $0xc0106411,(%esp)
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
c0100d15:	c7 04 24 1a 64 10 c0 	movl   $0xc010641a,(%esp)
c0100d1c:	e8 35 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d28:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2b:	89 04 24             	mov    %eax,(%esp)
c0100d2e:	e8 ee f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d33:	c7 04 24 36 64 10 c0 	movl   $0xc0106436,(%esp)
c0100d3a:	e8 17 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3f:	c7 04 24 38 64 10 c0 	movl   $0xc0106438,(%esp)
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
c0100d80:	c7 04 24 4a 64 10 c0 	movl   $0xc010644a,(%esp)
c0100d87:	e8 ca f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d93:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d96:	89 04 24             	mov    %eax,(%esp)
c0100d99:	e8 83 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d9e:	c7 04 24 36 64 10 c0 	movl   $0xc0106436,(%esp)
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
c0100e05:	c7 04 24 68 64 10 c0 	movl   $0xc0106468,(%esp)
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
c010126f:	e8 76 4d 00 00       	call   c0105fea <memmove>
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
c0101601:	c7 04 24 83 64 10 c0 	movl   $0xc0106483,(%esp)
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
c0101678:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
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
c0101933:	c7 04 24 c0 64 10 c0 	movl   $0xc01064c0,(%esp)
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
c0101a3d:	c7 04 24 ca 64 10 c0 	movl   $0xc01064ca,(%esp)
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
c0101a5c:	8b 04 85 20 68 10 c0 	mov    -0x3fef97e0(,%eax,4),%eax
c0101a63:	eb 18                	jmp    c0101a7d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a65:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a69:	7e 0d                	jle    c0101a78 <trapname+0x2a>
c0101a6b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6f:	7f 07                	jg     c0101a78 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a71:	b8 cf 64 10 c0       	mov    $0xc01064cf,%eax
c0101a76:	eb 05                	jmp    c0101a7d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a78:	b8 e2 64 10 c0       	mov    $0xc01064e2,%eax
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
c0101aa1:	c7 04 24 23 65 10 c0 	movl   $0xc0106523,(%esp)
c0101aa8:	e8 a9 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	89 04 24             	mov    %eax,(%esp)
c0101ab3:	e8 8f 01 00 00       	call   c0101c47 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 34 65 10 c0 	movl   $0xc0106534,(%esp)
c0101aca:	e8 87 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ada:	c7 04 24 47 65 10 c0 	movl   $0xc0106547,(%esp)
c0101ae1:	e8 70 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af1:	c7 04 24 5a 65 10 c0 	movl   $0xc010655a,(%esp)
c0101af8:	e8 59 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b08:	c7 04 24 6d 65 10 c0 	movl   $0xc010656d,(%esp)
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
c0101b30:	c7 04 24 80 65 10 c0 	movl   $0xc0106580,(%esp)
c0101b37:	e8 1a e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	8b 40 34             	mov    0x34(%eax),%eax
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 92 65 10 c0 	movl   $0xc0106592,(%esp)
c0101b4d:	e8 04 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	8b 40 38             	mov    0x38(%eax),%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 a1 65 10 c0 	movl   $0xc01065a1,(%esp)
c0101b63:	e8 ee e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b73:	c7 04 24 b0 65 10 c0 	movl   $0xc01065b0,(%esp)
c0101b7a:	e8 d7 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b82:	8b 40 40             	mov    0x40(%eax),%eax
c0101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b89:	c7 04 24 c3 65 10 c0 	movl   $0xc01065c3,(%esp)
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
c0101bd0:	c7 04 24 d2 65 10 c0 	movl   $0xc01065d2,(%esp)
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
c0101bfa:	c7 04 24 d6 65 10 c0 	movl   $0xc01065d6,(%esp)
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
c0101c1f:	c7 04 24 df 65 10 c0 	movl   $0xc01065df,(%esp)
c0101c26:	e8 2b e7 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c36:	c7 04 24 ee 65 10 c0 	movl   $0xc01065ee,(%esp)
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
c0101c56:	c7 04 24 01 66 10 c0 	movl   $0xc0106601,(%esp)
c0101c5d:	e8 f4 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c65:	8b 40 04             	mov    0x4(%eax),%eax
c0101c68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6c:	c7 04 24 10 66 10 c0 	movl   $0xc0106610,(%esp)
c0101c73:	e8 de e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c82:	c7 04 24 1f 66 10 c0 	movl   $0xc010661f,(%esp)
c0101c89:	e8 c8 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c98:	c7 04 24 2e 66 10 c0 	movl   $0xc010662e,(%esp)
c0101c9f:	e8 b2 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 10             	mov    0x10(%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 3d 66 10 c0 	movl   $0xc010663d,(%esp)
c0101cb5:	e8 9c e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 4c 66 10 c0 	movl   $0xc010664c,(%esp)
c0101ccb:	e8 86 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 18             	mov    0x18(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 5b 66 10 c0 	movl   $0xc010665b,(%esp)
c0101ce1:	e8 70 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 6a 66 10 c0 	movl   $0xc010666a,(%esp)
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
c0101dac:	c7 04 24 79 66 10 c0 	movl   $0xc0106679,(%esp)
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
c0101dd2:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0101dd9:	e8 78 e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101dde:	eb 55                	jmp    c0101e35 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de0:	c7 44 24 08 9a 66 10 	movl   $0xc010669a,0x8(%esp)
c0101de7:	c0 
c0101de8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101def:	00 
c0101df0:	c7 04 24 aa 66 10 c0 	movl   $0xc01066aa,(%esp)
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
c0101e15:	c7 44 24 08 bb 66 10 	movl   $0xc01066bb,0x8(%esp)
c0101e1c:	c0 
c0101e1d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0101e24:	00 
c0101e25:	c7 04 24 aa 66 10 c0 	movl   $0xc01066aa,(%esp)
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
c010296a:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c0102971:	c0 
c0102972:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102979:	c0 
c010297a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102981:	00 
c0102982:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
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
c01029c2:	c7 44 24 0c a1 68 10 	movl   $0xc01068a1,0xc(%esp)
c01029c9:	c0 
c01029ca:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01029d1:	c0 
c01029d2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01029d9:	00 
c01029da:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
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
c0102acc:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c0102ad3:	c0 
c0102ad4:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102adb:	c0 
c0102adc:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102ae3:	00 
c0102ae4:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
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
c0102c65:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c0102c6c:	c0 
c0102c6d:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102c74:	c0 
c0102c75:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0102c7c:	00 
c0102c7d:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
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
c0102cec:	c7 44 24 0c b4 68 10 	movl   $0xc01068b4,0xc(%esp)
c0102cf3:	c0 
c0102cf4:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102cfb:	c0 
c0102cfc:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0102d03:	00 
c0102d04:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
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

    nr_free += n;
c0102ea1:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102eaa:	01 d0                	add    %edx,%eax
c0102eac:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
c0102eb1:	c7 45 9c 80 ce 11 c0 	movl   $0xc011ce80,-0x64(%ebp)
    return listelm->next;
c0102eb8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102ebb:	8b 40 04             	mov    0x4(%eax),%eax

    le = list_next(&free_list);
c0102ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102ec1:	eb 34                	jmp    c0102ef7 <default_free_pages+0x2a1>
        p = le2page(le, page_link);
c0102ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec6:	83 e8 0c             	sub    $0xc,%eax
c0102ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ecf:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102ed2:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ed5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property < p) {
c0102edb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ede:	8b 50 08             	mov    0x8(%eax),%edx
c0102ee1:	89 d0                	mov    %edx,%eax
c0102ee3:	c1 e0 02             	shl    $0x2,%eax
c0102ee6:	01 d0                	add    %edx,%eax
c0102ee8:	c1 e0 02             	shl    $0x2,%eax
c0102eeb:	89 c2                	mov    %eax,%edx
c0102eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef0:	01 d0                	add    %edx,%eax
c0102ef2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ef5:	77 0b                	ja     c0102f02 <default_free_pages+0x2ac>
    while (le != &free_list) {
c0102ef7:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102efe:	75 c3                	jne    c0102ec3 <default_free_pages+0x26d>
c0102f00:	eb 01                	jmp    c0102f03 <default_free_pages+0x2ad>
            break;
c0102f02:	90                   	nop
        }

    }

    //这里理解为什么要用add——before，因为是FF，先进先出
    list_add_before(le, &(base->page_link));
c0102f03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f06:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f0c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f0f:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102f12:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f15:	8b 00                	mov    (%eax),%eax
c0102f17:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f1a:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102f1d:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102f20:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f23:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102f26:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f29:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102f2c:	89 10                	mov    %edx,(%eax)
c0102f2e:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f31:	8b 10                	mov    (%eax),%edx
c0102f33:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f39:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f3c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f42:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f45:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102f48:	89 10                	mov    %edx,(%eax)
}
c0102f4a:	90                   	nop
}
c0102f4b:	90                   	nop
//        cprintf("le:%x page:%x",le1 , p1);
//        le1=list_next(le1);
//    }
//    cprintf("\n\n");

}
c0102f4c:	90                   	nop
c0102f4d:	89 ec                	mov    %ebp,%esp
c0102f4f:	5d                   	pop    %ebp
c0102f50:	c3                   	ret    

c0102f51 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102f51:	55                   	push   %ebp
c0102f52:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102f54:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
}
c0102f59:	5d                   	pop    %ebp
c0102f5a:	c3                   	ret    

c0102f5b <basic_check>:

static void
basic_check(void) {
c0102f5b:	55                   	push   %ebp
c0102f5c:	89 e5                	mov    %esp,%ebp
c0102f5e:	83 ec 58             	sub    $0x58,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f7b:	e8 9f 0f 00 00       	call   c0103f1f <alloc_pages>
c0102f80:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102f83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102f87:	75 24                	jne    c0102fad <basic_check+0x52>
c0102f89:	c7 44 24 0c d9 68 10 	movl   $0xc01068d9,0xc(%esp)
c0102f90:	c0 
c0102f91:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102f98:	c0 
c0102f99:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0102fa0:	00 
c0102fa1:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0102fa8:	e8 3b dd ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fb4:	e8 66 0f 00 00       	call   c0103f1f <alloc_pages>
c0102fb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102fbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102fc0:	75 24                	jne    c0102fe6 <basic_check+0x8b>
c0102fc2:	c7 44 24 0c f5 68 10 	movl   $0xc01068f5,0xc(%esp)
c0102fc9:	c0 
c0102fca:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0102fd1:	c0 
c0102fd2:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0102fd9:	00 
c0102fda:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0102fe1:	e8 02 dd ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102fe6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fed:	e8 2d 0f 00 00       	call   c0103f1f <alloc_pages>
c0102ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ff5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ff9:	75 24                	jne    c010301f <basic_check+0xc4>
c0102ffb:	c7 44 24 0c 11 69 10 	movl   $0xc0106911,0xc(%esp)
c0103002:	c0 
c0103003:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010300a:	c0 
c010300b:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103012:	00 
c0103013:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010301a:	e8 c9 dc ff ff       	call   c0100ce8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103022:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103025:	74 10                	je     c0103037 <basic_check+0xdc>
c0103027:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010302a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010302d:	74 08                	je     c0103037 <basic_check+0xdc>
c010302f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103032:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103035:	75 24                	jne    c010305b <basic_check+0x100>
c0103037:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c010303e:	c0 
c010303f:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103046:	c0 
c0103047:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010304e:	00 
c010304f:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103056:	e8 8d dc ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010305e:	89 04 24             	mov    %eax,(%esp)
c0103061:	e8 af f8 ff ff       	call   c0102915 <page_ref>
c0103066:	85 c0                	test   %eax,%eax
c0103068:	75 1e                	jne    c0103088 <basic_check+0x12d>
c010306a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010306d:	89 04 24             	mov    %eax,(%esp)
c0103070:	e8 a0 f8 ff ff       	call   c0102915 <page_ref>
c0103075:	85 c0                	test   %eax,%eax
c0103077:	75 0f                	jne    c0103088 <basic_check+0x12d>
c0103079:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010307c:	89 04 24             	mov    %eax,(%esp)
c010307f:	e8 91 f8 ff ff       	call   c0102915 <page_ref>
c0103084:	85 c0                	test   %eax,%eax
c0103086:	74 24                	je     c01030ac <basic_check+0x151>
c0103088:	c7 44 24 0c 54 69 10 	movl   $0xc0106954,0xc(%esp)
c010308f:	c0 
c0103090:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103097:	c0 
c0103098:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010309f:	00 
c01030a0:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01030a7:	e8 3c dc ff ff       	call   c0100ce8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030af:	89 04 24             	mov    %eax,(%esp)
c01030b2:	e8 46 f8 ff ff       	call   c01028fd <page2pa>
c01030b7:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01030bd:	c1 e2 0c             	shl    $0xc,%edx
c01030c0:	39 d0                	cmp    %edx,%eax
c01030c2:	72 24                	jb     c01030e8 <basic_check+0x18d>
c01030c4:	c7 44 24 0c 90 69 10 	movl   $0xc0106990,0xc(%esp)
c01030cb:	c0 
c01030cc:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01030d3:	c0 
c01030d4:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01030db:	00 
c01030dc:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01030e3:	e8 00 dc ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030eb:	89 04 24             	mov    %eax,(%esp)
c01030ee:	e8 0a f8 ff ff       	call   c01028fd <page2pa>
c01030f3:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01030f9:	c1 e2 0c             	shl    $0xc,%edx
c01030fc:	39 d0                	cmp    %edx,%eax
c01030fe:	72 24                	jb     c0103124 <basic_check+0x1c9>
c0103100:	c7 44 24 0c ad 69 10 	movl   $0xc01069ad,0xc(%esp)
c0103107:	c0 
c0103108:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010310f:	c0 
c0103110:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103117:	00 
c0103118:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010311f:	e8 c4 db ff ff       	call   c0100ce8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103124:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103127:	89 04 24             	mov    %eax,(%esp)
c010312a:	e8 ce f7 ff ff       	call   c01028fd <page2pa>
c010312f:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103135:	c1 e2 0c             	shl    $0xc,%edx
c0103138:	39 d0                	cmp    %edx,%eax
c010313a:	72 24                	jb     c0103160 <basic_check+0x205>
c010313c:	c7 44 24 0c ca 69 10 	movl   $0xc01069ca,0xc(%esp)
c0103143:	c0 
c0103144:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010314b:	c0 
c010314c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103153:	00 
c0103154:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010315b:	e8 88 db ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c0103160:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103165:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c010316b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010316e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103171:	c7 45 d4 80 ce 11 c0 	movl   $0xc011ce80,-0x2c(%ebp)
    elm->prev = elm->next = elm;
c0103178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010317b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010317e:	89 50 04             	mov    %edx,0x4(%eax)
c0103181:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103184:	8b 50 04             	mov    0x4(%eax),%edx
c0103187:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010318a:	89 10                	mov    %edx,(%eax)
}
c010318c:	90                   	nop
c010318d:	c7 45 d8 80 ce 11 c0 	movl   $0xc011ce80,-0x28(%ebp)
    return list->next == list;
c0103194:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103197:	8b 40 04             	mov    0x4(%eax),%eax
c010319a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010319d:	0f 94 c0             	sete   %al
c01031a0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01031a3:	85 c0                	test   %eax,%eax
c01031a5:	75 24                	jne    c01031cb <basic_check+0x270>
c01031a7:	c7 44 24 0c e7 69 10 	movl   $0xc01069e7,0xc(%esp)
c01031ae:	c0 
c01031af:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01031b6:	c0 
c01031b7:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01031be:	00 
c01031bf:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01031c6:	e8 1d db ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c01031cb:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01031d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01031d3:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c01031da:	00 00 00 

    assert(alloc_page() == NULL);
c01031dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e4:	e8 36 0d 00 00       	call   c0103f1f <alloc_pages>
c01031e9:	85 c0                	test   %eax,%eax
c01031eb:	74 24                	je     c0103211 <basic_check+0x2b6>
c01031ed:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c01031f4:	c0 
c01031f5:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01031fc:	c0 
c01031fd:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103204:	00 
c0103205:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010320c:	e8 d7 da ff ff       	call   c0100ce8 <__panic>

    free_page(p0);
c0103211:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103218:	00 
c0103219:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010321c:	89 04 24             	mov    %eax,(%esp)
c010321f:	e8 35 0d 00 00       	call   c0103f59 <free_pages>
    free_page(p1);
c0103224:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010322b:	00 
c010322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010322f:	89 04 24             	mov    %eax,(%esp)
c0103232:	e8 22 0d 00 00       	call   c0103f59 <free_pages>
    free_page(p2);
c0103237:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010323e:	00 
c010323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103242:	89 04 24             	mov    %eax,(%esp)
c0103245:	e8 0f 0d 00 00       	call   c0103f59 <free_pages>
    assert(nr_free == 3);
c010324a:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c010324f:	83 f8 03             	cmp    $0x3,%eax
c0103252:	74 24                	je     c0103278 <basic_check+0x31d>
c0103254:	c7 44 24 0c 13 6a 10 	movl   $0xc0106a13,0xc(%esp)
c010325b:	c0 
c010325c:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103263:	c0 
c0103264:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010326b:	00 
c010326c:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103273:	e8 70 da ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103278:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010327f:	e8 9b 0c 00 00       	call   c0103f1f <alloc_pages>
c0103284:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103287:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010328b:	75 24                	jne    c01032b1 <basic_check+0x356>
c010328d:	c7 44 24 0c d9 68 10 	movl   $0xc01068d9,0xc(%esp)
c0103294:	c0 
c0103295:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010329c:	c0 
c010329d:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01032a4:	00 
c01032a5:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01032ac:	e8 37 da ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01032b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b8:	e8 62 0c 00 00       	call   c0103f1f <alloc_pages>
c01032bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01032c4:	75 24                	jne    c01032ea <basic_check+0x38f>
c01032c6:	c7 44 24 0c f5 68 10 	movl   $0xc01068f5,0xc(%esp)
c01032cd:	c0 
c01032ce:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01032d5:	c0 
c01032d6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01032dd:	00 
c01032de:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01032e5:	e8 fe d9 ff ff       	call   c0100ce8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01032ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f1:	e8 29 0c 00 00       	call   c0103f1f <alloc_pages>
c01032f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032fd:	75 24                	jne    c0103323 <basic_check+0x3c8>
c01032ff:	c7 44 24 0c 11 69 10 	movl   $0xc0106911,0xc(%esp)
c0103306:	c0 
c0103307:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010330e:	c0 
c010330f:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103316:	00 
c0103317:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010331e:	e8 c5 d9 ff ff       	call   c0100ce8 <__panic>

    assert(alloc_page() == NULL);
c0103323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010332a:	e8 f0 0b 00 00       	call   c0103f1f <alloc_pages>
c010332f:	85 c0                	test   %eax,%eax
c0103331:	74 24                	je     c0103357 <basic_check+0x3fc>
c0103333:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c010333a:	c0 
c010333b:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103342:	c0 
c0103343:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010334a:	00 
c010334b:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103352:	e8 91 d9 ff ff       	call   c0100ce8 <__panic>
c0103357:	c7 45 d0 80 ce 11 c0 	movl   $0xc011ce80,-0x30(%ebp)
    return listelm->next;
c010335e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103361:	8b 40 04             	mov    0x4(%eax),%eax

    struct Page *pp1;

    list_entry_t *le1 = list_next(&free_list);
c0103364:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c0103367:	eb 32                	jmp    c010339b <basic_check+0x440>
        pp1 = le2page(le1, page_link);
c0103369:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336c:	83 e8 0c             	sub    $0xc,%eax
c010336f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103375:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0103378:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010337b:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c010337e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c0103381:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103384:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103388:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010338f:	c7 04 24 20 6a 10 c0 	movl   $0xc0106a20,(%esp)
c0103396:	e8 bb cf ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c010339b:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c01033a2:	75 c5                	jne    c0103369 <basic_check+0x40e>
    }
    cprintf("\n\n");
c01033a4:	c7 04 24 2e 6a 10 c0 	movl   $0xc0106a2e,(%esp)
c01033ab:	e8 a6 cf ff ff       	call   c0100356 <cprintf>

    free_page(p0);
c01033b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033b7:	00 
c01033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033bb:	89 04 24             	mov    %eax,(%esp)
c01033be:	e8 96 0b 00 00       	call   c0103f59 <free_pages>
c01033c3:	c7 45 c8 80 ce 11 c0 	movl   $0xc011ce80,-0x38(%ebp)
c01033ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033cd:	8b 40 04             	mov    0x4(%eax),%eax

    le1 = list_next(&free_list);
c01033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (le1 != &free_list) {
c01033d3:	eb 32                	jmp    c0103407 <basic_check+0x4ac>
        pp1 = le2page(le1, page_link);
c01033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d8:	83 e8 0c             	sub    $0xc,%eax
c01033db:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01033e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033e7:	8b 40 04             	mov    0x4(%eax),%eax
        le1=list_next(le1);
c01033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("le:%x page:%x",le1 , pp1);
c01033ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033fb:	c7 04 24 20 6a 10 c0 	movl   $0xc0106a20,(%esp)
c0103402:	e8 4f cf ff ff       	call   c0100356 <cprintf>
    while (le1 != &free_list) {
c0103407:	81 7d f4 80 ce 11 c0 	cmpl   $0xc011ce80,-0xc(%ebp)
c010340e:	75 c5                	jne    c01033d5 <basic_check+0x47a>
    }
    cprintf("\n\n");
c0103410:	c7 04 24 2e 6a 10 c0 	movl   $0xc0106a2e,(%esp)
c0103417:	e8 3a cf ff ff       	call   c0100356 <cprintf>
c010341c:	c7 45 c0 80 ce 11 c0 	movl   $0xc011ce80,-0x40(%ebp)
    return list->next == list;
c0103423:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103426:	8b 40 04             	mov    0x4(%eax),%eax
c0103429:	39 45 c0             	cmp    %eax,-0x40(%ebp)
c010342c:	0f 94 c0             	sete   %al
c010342f:	0f b6 c0             	movzbl %al,%eax


    assert(!list_empty(&free_list));
c0103432:	85 c0                	test   %eax,%eax
c0103434:	74 24                	je     c010345a <basic_check+0x4ff>
c0103436:	c7 44 24 0c 31 6a 10 	movl   $0xc0106a31,0xc(%esp)
c010343d:	c0 
c010343e:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103445:	c0 
c0103446:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010344d:	00 
c010344e:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103455:	e8 8e d8 ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010345a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103461:	e8 b9 0a 00 00       	call   c0103f1f <alloc_pages>
c0103466:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103469:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010346c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010346f:	74 24                	je     c0103495 <basic_check+0x53a>
c0103471:	c7 44 24 0c 49 6a 10 	movl   $0xc0106a49,0xc(%esp)
c0103478:	c0 
c0103479:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103480:	c0 
c0103481:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103488:	00 
c0103489:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103490:	e8 53 d8 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103495:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010349c:	e8 7e 0a 00 00       	call   c0103f1f <alloc_pages>
c01034a1:	85 c0                	test   %eax,%eax
c01034a3:	74 24                	je     c01034c9 <basic_check+0x56e>
c01034a5:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c01034ac:	c0 
c01034ad:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01034b4:	c0 
c01034b5:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01034bc:	00 
c01034bd:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01034c4:	e8 1f d8 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c01034c9:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01034ce:	85 c0                	test   %eax,%eax
c01034d0:	74 24                	je     c01034f6 <basic_check+0x59b>
c01034d2:	c7 44 24 0c 62 6a 10 	movl   $0xc0106a62,0xc(%esp)
c01034d9:	c0 
c01034da:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01034e1:	c0 
c01034e2:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01034e9:	00 
c01034ea:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01034f1:	e8 f2 d7 ff ff       	call   c0100ce8 <__panic>
    free_list = free_list_store;
c01034f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01034f9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01034fc:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103501:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    nr_free = nr_free_store;
c0103507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010350a:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_page(p);
c010350f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103516:	00 
c0103517:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010351a:	89 04 24             	mov    %eax,(%esp)
c010351d:	e8 37 0a 00 00       	call   c0103f59 <free_pages>
    free_page(p1);
c0103522:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103529:	00 
c010352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010352d:	89 04 24             	mov    %eax,(%esp)
c0103530:	e8 24 0a 00 00       	call   c0103f59 <free_pages>
    free_page(p2);
c0103535:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010353c:	00 
c010353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103540:	89 04 24             	mov    %eax,(%esp)
c0103543:	e8 11 0a 00 00       	call   c0103f59 <free_pages>
}
c0103548:	90                   	nop
c0103549:	89 ec                	mov    %ebp,%esp
c010354b:	5d                   	pop    %ebp
c010354c:	c3                   	ret    

c010354d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010354d:	55                   	push   %ebp
c010354e:	89 e5                	mov    %esp,%ebp
c0103550:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010355d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103564:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010356b:	eb 6a                	jmp    c01035d7 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010356d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103570:	83 e8 0c             	sub    $0xc,%eax
c0103573:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103579:	83 c0 04             	add    $0x4,%eax
c010357c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103583:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103586:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103589:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010358c:	0f a3 10             	bt     %edx,(%eax)
c010358f:	19 c0                	sbb    %eax,%eax
c0103591:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103594:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103598:	0f 95 c0             	setne  %al
c010359b:	0f b6 c0             	movzbl %al,%eax
c010359e:	85 c0                	test   %eax,%eax
c01035a0:	75 24                	jne    c01035c6 <default_check+0x79>
c01035a2:	c7 44 24 0c 6f 6a 10 	movl   $0xc0106a6f,0xc(%esp)
c01035a9:	c0 
c01035aa:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01035b1:	c0 
c01035b2:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01035b9:	00 
c01035ba:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01035c1:	e8 22 d7 ff ff       	call   c0100ce8 <__panic>
        count++, total += p->property;
c01035c6:	ff 45 f4             	incl   -0xc(%ebp)
c01035c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035cc:	8b 50 08             	mov    0x8(%eax),%edx
c01035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035d2:	01 d0                	add    %edx,%eax
c01035d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01035dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035e0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01035e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035e6:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c01035ed:	0f 85 7a ff ff ff    	jne    c010356d <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01035f3:	e8 96 09 00 00       	call   c0103f8e <nr_free_pages>
c01035f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01035fb:	39 d0                	cmp    %edx,%eax
c01035fd:	74 24                	je     c0103623 <default_check+0xd6>
c01035ff:	c7 44 24 0c 7f 6a 10 	movl   $0xc0106a7f,0xc(%esp)
c0103606:	c0 
c0103607:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010360e:	c0 
c010360f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103616:	00 
c0103617:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010361e:	e8 c5 d6 ff ff       	call   c0100ce8 <__panic>

    basic_check();
c0103623:	e8 33 f9 ff ff       	call   c0102f5b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103628:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010362f:	e8 eb 08 00 00       	call   c0103f1f <alloc_pages>
c0103634:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103637:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010363b:	75 24                	jne    c0103661 <default_check+0x114>
c010363d:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c0103644:	c0 
c0103645:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010364c:	c0 
c010364d:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0103654:	00 
c0103655:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010365c:	e8 87 d6 ff ff       	call   c0100ce8 <__panic>
    assert(!PageProperty(p0));
c0103661:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103664:	83 c0 04             	add    $0x4,%eax
c0103667:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010366e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103671:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103674:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103677:	0f a3 10             	bt     %edx,(%eax)
c010367a:	19 c0                	sbb    %eax,%eax
c010367c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010367f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103683:	0f 95 c0             	setne  %al
c0103686:	0f b6 c0             	movzbl %al,%eax
c0103689:	85 c0                	test   %eax,%eax
c010368b:	74 24                	je     c01036b1 <default_check+0x164>
c010368d:	c7 44 24 0c a3 6a 10 	movl   $0xc0106aa3,0xc(%esp)
c0103694:	c0 
c0103695:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010369c:	c0 
c010369d:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01036a4:	00 
c01036a5:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01036ac:	e8 37 d6 ff ff       	call   c0100ce8 <__panic>

    list_entry_t free_list_store = free_list;
c01036b1:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01036b6:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c01036bc:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036bf:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036c2:	c7 45 b0 80 ce 11 c0 	movl   $0xc011ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01036c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01036cf:	89 50 04             	mov    %edx,0x4(%eax)
c01036d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036d5:	8b 50 04             	mov    0x4(%eax),%edx
c01036d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036db:	89 10                	mov    %edx,(%eax)
}
c01036dd:	90                   	nop
c01036de:	c7 45 b4 80 ce 11 c0 	movl   $0xc011ce80,-0x4c(%ebp)
    return list->next == list;
c01036e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036e8:	8b 40 04             	mov    0x4(%eax),%eax
c01036eb:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01036ee:	0f 94 c0             	sete   %al
c01036f1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01036f4:	85 c0                	test   %eax,%eax
c01036f6:	75 24                	jne    c010371c <default_check+0x1cf>
c01036f8:	c7 44 24 0c e7 69 10 	movl   $0xc01069e7,0xc(%esp)
c01036ff:	c0 
c0103700:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103707:	c0 
c0103708:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c010370f:	00 
c0103710:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103717:	e8 cc d5 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c010371c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103723:	e8 f7 07 00 00       	call   c0103f1f <alloc_pages>
c0103728:	85 c0                	test   %eax,%eax
c010372a:	74 24                	je     c0103750 <default_check+0x203>
c010372c:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c0103733:	c0 
c0103734:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010373b:	c0 
c010373c:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0103743:	00 
c0103744:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010374b:	e8 98 d5 ff ff       	call   c0100ce8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103750:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103755:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103758:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c010375f:	00 00 00 

    free_pages(p0 + 2, 3);
c0103762:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103765:	83 c0 28             	add    $0x28,%eax
c0103768:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010376f:	00 
c0103770:	89 04 24             	mov    %eax,(%esp)
c0103773:	e8 e1 07 00 00       	call   c0103f59 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103778:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010377f:	e8 9b 07 00 00       	call   c0103f1f <alloc_pages>
c0103784:	85 c0                	test   %eax,%eax
c0103786:	74 24                	je     c01037ac <default_check+0x25f>
c0103788:	c7 44 24 0c b5 6a 10 	movl   $0xc0106ab5,0xc(%esp)
c010378f:	c0 
c0103790:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103797:	c0 
c0103798:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c010379f:	00 
c01037a0:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01037a7:	e8 3c d5 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037af:	83 c0 28             	add    $0x28,%eax
c01037b2:	83 c0 04             	add    $0x4,%eax
c01037b5:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037bc:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037c2:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037c5:	0f a3 10             	bt     %edx,(%eax)
c01037c8:	19 c0                	sbb    %eax,%eax
c01037ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01037cd:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01037d1:	0f 95 c0             	setne  %al
c01037d4:	0f b6 c0             	movzbl %al,%eax
c01037d7:	85 c0                	test   %eax,%eax
c01037d9:	74 0e                	je     c01037e9 <default_check+0x29c>
c01037db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037de:	83 c0 28             	add    $0x28,%eax
c01037e1:	8b 40 08             	mov    0x8(%eax),%eax
c01037e4:	83 f8 03             	cmp    $0x3,%eax
c01037e7:	74 24                	je     c010380d <default_check+0x2c0>
c01037e9:	c7 44 24 0c cc 6a 10 	movl   $0xc0106acc,0xc(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01037f8:	c0 
c01037f9:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103800:	00 
c0103801:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103808:	e8 db d4 ff ff       	call   c0100ce8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010380d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103814:	e8 06 07 00 00       	call   c0103f1f <alloc_pages>
c0103819:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010381c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103820:	75 24                	jne    c0103846 <default_check+0x2f9>
c0103822:	c7 44 24 0c f8 6a 10 	movl   $0xc0106af8,0xc(%esp)
c0103829:	c0 
c010382a:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103831:	c0 
c0103832:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0103839:	00 
c010383a:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103841:	e8 a2 d4 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010384d:	e8 cd 06 00 00       	call   c0103f1f <alloc_pages>
c0103852:	85 c0                	test   %eax,%eax
c0103854:	74 24                	je     c010387a <default_check+0x32d>
c0103856:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c010385d:	c0 
c010385e:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103865:	c0 
c0103866:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c010386d:	00 
c010386e:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103875:	e8 6e d4 ff ff       	call   c0100ce8 <__panic>
    assert(p0 + 2 == p1);
c010387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010387d:	83 c0 28             	add    $0x28,%eax
c0103880:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103883:	74 24                	je     c01038a9 <default_check+0x35c>
c0103885:	c7 44 24 0c 16 6b 10 	movl   $0xc0106b16,0xc(%esp)
c010388c:	c0 
c010388d:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103894:	c0 
c0103895:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c010389c:	00 
c010389d:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01038a4:	e8 3f d4 ff ff       	call   c0100ce8 <__panic>

    //h
    p2 = p0 + 1;
c01038a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038ac:	83 c0 14             	add    $0x14,%eax
c01038af:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038b9:	00 
c01038ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038bd:	89 04 24             	mov    %eax,(%esp)
c01038c0:	e8 94 06 00 00       	call   c0103f59 <free_pages>
    free_pages(p1, 3);
c01038c5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01038cc:	00 
c01038cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038d0:	89 04 24             	mov    %eax,(%esp)
c01038d3:	e8 81 06 00 00       	call   c0103f59 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01038d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038db:	83 c0 04             	add    $0x4,%eax
c01038de:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01038e5:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01038eb:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01038ee:	0f a3 10             	bt     %edx,(%eax)
c01038f1:	19 c0                	sbb    %eax,%eax
c01038f3:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01038f6:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01038fa:	0f 95 c0             	setne  %al
c01038fd:	0f b6 c0             	movzbl %al,%eax
c0103900:	85 c0                	test   %eax,%eax
c0103902:	74 0b                	je     c010390f <default_check+0x3c2>
c0103904:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103907:	8b 40 08             	mov    0x8(%eax),%eax
c010390a:	83 f8 01             	cmp    $0x1,%eax
c010390d:	74 24                	je     c0103933 <default_check+0x3e6>
c010390f:	c7 44 24 0c 24 6b 10 	movl   $0xc0106b24,0xc(%esp)
c0103916:	c0 
c0103917:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c010391e:	c0 
c010391f:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0103926:	00 
c0103927:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c010392e:	e8 b5 d3 ff ff       	call   c0100ce8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103933:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103936:	83 c0 04             	add    $0x4,%eax
c0103939:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103940:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103943:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103946:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103949:	0f a3 10             	bt     %edx,(%eax)
c010394c:	19 c0                	sbb    %eax,%eax
c010394e:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103951:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103955:	0f 95 c0             	setne  %al
c0103958:	0f b6 c0             	movzbl %al,%eax
c010395b:	85 c0                	test   %eax,%eax
c010395d:	74 0b                	je     c010396a <default_check+0x41d>
c010395f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103962:	8b 40 08             	mov    0x8(%eax),%eax
c0103965:	83 f8 03             	cmp    $0x3,%eax
c0103968:	74 24                	je     c010398e <default_check+0x441>
c010396a:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c0103971:	c0 
c0103972:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103979:	c0 
c010397a:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0103981:	00 
c0103982:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103989:	e8 5a d3 ff ff       	call   c0100ce8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010398e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103995:	e8 85 05 00 00       	call   c0103f1f <alloc_pages>
c010399a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010399d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039a0:	83 e8 14             	sub    $0x14,%eax
c01039a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039a6:	74 24                	je     c01039cc <default_check+0x47f>
c01039a8:	c7 44 24 0c 72 6b 10 	movl   $0xc0106b72,0xc(%esp)
c01039af:	c0 
c01039b0:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c01039b7:	c0 
c01039b8:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c01039bf:	00 
c01039c0:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c01039c7:	e8 1c d3 ff ff       	call   c0100ce8 <__panic>
    free_page(p0);
c01039cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039d3:	00 
c01039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039d7:	89 04 24             	mov    %eax,(%esp)
c01039da:	e8 7a 05 00 00       	call   c0103f59 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01039df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01039e6:	e8 34 05 00 00       	call   c0103f1f <alloc_pages>
c01039eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039f1:	83 c0 14             	add    $0x14,%eax
c01039f4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039f7:	74 24                	je     c0103a1d <default_check+0x4d0>
c01039f9:	c7 44 24 0c 90 6b 10 	movl   $0xc0106b90,0xc(%esp)
c0103a00:	c0 
c0103a01:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c0103a10:	00 
c0103a11:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103a18:	e8 cb d2 ff ff       	call   c0100ce8 <__panic>

    free_pages(p0, 2);
c0103a1d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a24:	00 
c0103a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a28:	89 04 24             	mov    %eax,(%esp)
c0103a2b:	e8 29 05 00 00       	call   c0103f59 <free_pages>
    free_page(p2);
c0103a30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a37:	00 
c0103a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a3b:	89 04 24             	mov    %eax,(%esp)
c0103a3e:	e8 16 05 00 00       	call   c0103f59 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a43:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a4a:	e8 d0 04 00 00       	call   c0103f1f <alloc_pages>
c0103a4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103a56:	75 24                	jne    c0103a7c <default_check+0x52f>
c0103a58:	c7 44 24 0c b0 6b 10 	movl   $0xc0106bb0,0xc(%esp)
c0103a5f:	c0 
c0103a60:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103a67:	c0 
c0103a68:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
c0103a6f:	00 
c0103a70:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103a77:	e8 6c d2 ff ff       	call   c0100ce8 <__panic>
    assert(alloc_page() == NULL);
c0103a7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a83:	e8 97 04 00 00       	call   c0103f1f <alloc_pages>
c0103a88:	85 c0                	test   %eax,%eax
c0103a8a:	74 24                	je     c0103ab0 <default_check+0x563>
c0103a8c:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c0103a93:	c0 
c0103a94:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103a9b:	c0 
c0103a9c:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c0103aa3:	00 
c0103aa4:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103aab:	e8 38 d2 ff ff       	call   c0100ce8 <__panic>

    assert(nr_free == 0);
c0103ab0:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103ab5:	85 c0                	test   %eax,%eax
c0103ab7:	74 24                	je     c0103add <default_check+0x590>
c0103ab9:	c7 44 24 0c 62 6a 10 	movl   $0xc0106a62,0xc(%esp)
c0103ac0:	c0 
c0103ac1:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103ac8:	c0 
c0103ac9:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
c0103ad0:	00 
c0103ad1:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103ad8:	e8 0b d2 ff ff       	call   c0100ce8 <__panic>
    nr_free = nr_free_store;
c0103add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ae0:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_list = free_list_store;
c0103ae5:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103ae8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103aeb:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103af0:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    free_pages(p0, 5);
c0103af6:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103afd:	00 
c0103afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b01:	89 04 24             	mov    %eax,(%esp)
c0103b04:	e8 50 04 00 00       	call   c0103f59 <free_pages>

    le = &free_list;
c0103b09:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b10:	eb 5a                	jmp    c0103b6c <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b15:	8b 40 04             	mov    0x4(%eax),%eax
c0103b18:	8b 00                	mov    (%eax),%eax
c0103b1a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b1d:	75 0d                	jne    c0103b2c <default_check+0x5df>
c0103b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b22:	8b 00                	mov    (%eax),%eax
c0103b24:	8b 40 04             	mov    0x4(%eax),%eax
c0103b27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b2a:	74 24                	je     c0103b50 <default_check+0x603>
c0103b2c:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c0103b33:	c0 
c0103b34:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103b3b:	c0 
c0103b3c:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
c0103b43:	00 
c0103b44:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103b4b:	e8 98 d1 ff ff       	call   c0100ce8 <__panic>
        struct Page *p = le2page(le, page_link);
c0103b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b53:	83 e8 0c             	sub    $0xc,%eax
c0103b56:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103b59:	ff 4d f4             	decl   -0xc(%ebp)
c0103b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b62:	8b 48 08             	mov    0x8(%eax),%ecx
c0103b65:	89 d0                	mov    %edx,%eax
c0103b67:	29 c8                	sub    %ecx,%eax
c0103b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b6f:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103b72:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b75:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b7b:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103b82:	75 8e                	jne    c0103b12 <default_check+0x5c5>
    }
    assert(count == 0);
c0103b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b88:	74 24                	je     c0103bae <default_check+0x661>
c0103b8a:	c7 44 24 0c fd 6b 10 	movl   $0xc0106bfd,0xc(%esp)
c0103b91:	c0 
c0103b92:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103b99:	c0 
c0103b9a:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
c0103ba1:	00 
c0103ba2:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103ba9:	e8 3a d1 ff ff       	call   c0100ce8 <__panic>
    assert(total == 0);
c0103bae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bb2:	74 24                	je     c0103bd8 <default_check+0x68b>
c0103bb4:	c7 44 24 0c 08 6c 10 	movl   $0xc0106c08,0xc(%esp)
c0103bbb:	c0 
c0103bbc:	c7 44 24 08 76 68 10 	movl   $0xc0106876,0x8(%esp)
c0103bc3:	c0 
c0103bc4:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
c0103bcb:	00 
c0103bcc:	c7 04 24 8b 68 10 c0 	movl   $0xc010688b,(%esp)
c0103bd3:	e8 10 d1 ff ff       	call   c0100ce8 <__panic>
}
c0103bd8:	90                   	nop
c0103bd9:	89 ec                	mov    %ebp,%esp
c0103bdb:	5d                   	pop    %ebp
c0103bdc:	c3                   	ret    

c0103bdd <page2ppn>:
page2ppn(struct Page *page) {
c0103bdd:	55                   	push   %ebp
c0103bde:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103be0:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0103be6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be9:	29 d0                	sub    %edx,%eax
c0103beb:	c1 f8 02             	sar    $0x2,%eax
c0103bee:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103bf4:	5d                   	pop    %ebp
c0103bf5:	c3                   	ret    

c0103bf6 <page2pa>:
page2pa(struct Page *page) {
c0103bf6:	55                   	push   %ebp
c0103bf7:	89 e5                	mov    %esp,%ebp
c0103bf9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bff:	89 04 24             	mov    %eax,(%esp)
c0103c02:	e8 d6 ff ff ff       	call   c0103bdd <page2ppn>
c0103c07:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c0a:	89 ec                	mov    %ebp,%esp
c0103c0c:	5d                   	pop    %ebp
c0103c0d:	c3                   	ret    

c0103c0e <pa2page>:
pa2page(uintptr_t pa) {
c0103c0e:	55                   	push   %ebp
c0103c0f:	89 e5                	mov    %esp,%ebp
c0103c11:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c17:	c1 e8 0c             	shr    $0xc,%eax
c0103c1a:	89 c2                	mov    %eax,%edx
c0103c1c:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c21:	39 c2                	cmp    %eax,%edx
c0103c23:	72 1c                	jb     c0103c41 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c25:	c7 44 24 08 44 6c 10 	movl   $0xc0106c44,0x8(%esp)
c0103c2c:	c0 
c0103c2d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c34:	00 
c0103c35:	c7 04 24 63 6c 10 c0 	movl   $0xc0106c63,(%esp)
c0103c3c:	e8 a7 d0 ff ff       	call   c0100ce8 <__panic>
    return &pages[PPN(pa)];
c0103c41:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0103c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c4a:	c1 e8 0c             	shr    $0xc,%eax
c0103c4d:	89 c2                	mov    %eax,%edx
c0103c4f:	89 d0                	mov    %edx,%eax
c0103c51:	c1 e0 02             	shl    $0x2,%eax
c0103c54:	01 d0                	add    %edx,%eax
c0103c56:	c1 e0 02             	shl    $0x2,%eax
c0103c59:	01 c8                	add    %ecx,%eax
}
c0103c5b:	89 ec                	mov    %ebp,%esp
c0103c5d:	5d                   	pop    %ebp
c0103c5e:	c3                   	ret    

c0103c5f <page2kva>:
page2kva(struct Page *page) {
c0103c5f:	55                   	push   %ebp
c0103c60:	89 e5                	mov    %esp,%ebp
c0103c62:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c68:	89 04 24             	mov    %eax,(%esp)
c0103c6b:	e8 86 ff ff ff       	call   c0103bf6 <page2pa>
c0103c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c76:	c1 e8 0c             	shr    $0xc,%eax
c0103c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c7c:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c81:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c84:	72 23                	jb     c0103ca9 <page2kva+0x4a>
c0103c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c89:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c8d:	c7 44 24 08 74 6c 10 	movl   $0xc0106c74,0x8(%esp)
c0103c94:	c0 
c0103c95:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103c9c:	00 
c0103c9d:	c7 04 24 63 6c 10 c0 	movl   $0xc0106c63,(%esp)
c0103ca4:	e8 3f d0 ff ff       	call   c0100ce8 <__panic>
c0103ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cac:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cb1:	89 ec                	mov    %ebp,%esp
c0103cb3:	5d                   	pop    %ebp
c0103cb4:	c3                   	ret    

c0103cb5 <pte2page>:
pte2page(pte_t pte) {
c0103cb5:	55                   	push   %ebp
c0103cb6:	89 e5                	mov    %esp,%ebp
c0103cb8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cbe:	83 e0 01             	and    $0x1,%eax
c0103cc1:	85 c0                	test   %eax,%eax
c0103cc3:	75 1c                	jne    c0103ce1 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103cc5:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c0103ccc:	c0 
c0103ccd:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cd4:	00 
c0103cd5:	c7 04 24 63 6c 10 c0 	movl   $0xc0106c63,(%esp)
c0103cdc:	e8 07 d0 ff ff       	call   c0100ce8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103ce1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ce9:	89 04 24             	mov    %eax,(%esp)
c0103cec:	e8 1d ff ff ff       	call   c0103c0e <pa2page>
}
c0103cf1:	89 ec                	mov    %ebp,%esp
c0103cf3:	5d                   	pop    %ebp
c0103cf4:	c3                   	ret    

c0103cf5 <pde2page>:
pde2page(pde_t pde) {
c0103cf5:	55                   	push   %ebp
c0103cf6:	89 e5                	mov    %esp,%ebp
c0103cf8:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cfe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d03:	89 04 24             	mov    %eax,(%esp)
c0103d06:	e8 03 ff ff ff       	call   c0103c0e <pa2page>
}
c0103d0b:	89 ec                	mov    %ebp,%esp
c0103d0d:	5d                   	pop    %ebp
c0103d0e:	c3                   	ret    

c0103d0f <page_ref>:
page_ref(struct Page *page) {
c0103d0f:	55                   	push   %ebp
c0103d10:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d15:	8b 00                	mov    (%eax),%eax
}
c0103d17:	5d                   	pop    %ebp
c0103d18:	c3                   	ret    

c0103d19 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103d19:	55                   	push   %ebp
c0103d1a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d22:	89 10                	mov    %edx,(%eax)
}
c0103d24:	90                   	nop
c0103d25:	5d                   	pop    %ebp
c0103d26:	c3                   	ret    

c0103d27 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d27:	55                   	push   %ebp
c0103d28:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2d:	8b 00                	mov    (%eax),%eax
c0103d2f:	8d 50 01             	lea    0x1(%eax),%edx
c0103d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d35:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3a:	8b 00                	mov    (%eax),%eax
}
c0103d3c:	5d                   	pop    %ebp
c0103d3d:	c3                   	ret    

c0103d3e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d3e:	55                   	push   %ebp
c0103d3f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d44:	8b 00                	mov    (%eax),%eax
c0103d46:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d4c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d51:	8b 00                	mov    (%eax),%eax
}
c0103d53:	5d                   	pop    %ebp
c0103d54:	c3                   	ret    

c0103d55 <__intr_save>:
__intr_save(void) {
c0103d55:	55                   	push   %ebp
c0103d56:	89 e5                	mov    %esp,%ebp
c0103d58:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d5b:	9c                   	pushf  
c0103d5c:	58                   	pop    %eax
c0103d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d63:	25 00 02 00 00       	and    $0x200,%eax
c0103d68:	85 c0                	test   %eax,%eax
c0103d6a:	74 0c                	je     c0103d78 <__intr_save+0x23>
        intr_disable();
c0103d6c:	e8 d0 d9 ff ff       	call   c0101741 <intr_disable>
        return 1;
c0103d71:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d76:	eb 05                	jmp    c0103d7d <__intr_save+0x28>
    return 0;
c0103d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d7d:	89 ec                	mov    %ebp,%esp
c0103d7f:	5d                   	pop    %ebp
c0103d80:	c3                   	ret    

c0103d81 <__intr_restore>:
__intr_restore(bool flag) {
c0103d81:	55                   	push   %ebp
c0103d82:	89 e5                	mov    %esp,%ebp
c0103d84:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d8b:	74 05                	je     c0103d92 <__intr_restore+0x11>
        intr_enable();
c0103d8d:	e8 a7 d9 ff ff       	call   c0101739 <intr_enable>
}
c0103d92:	90                   	nop
c0103d93:	89 ec                	mov    %ebp,%esp
c0103d95:	5d                   	pop    %ebp
c0103d96:	c3                   	ret    

c0103d97 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d97:	55                   	push   %ebp
c0103d98:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)"::"r" (pd));
c0103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9d:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs"::"a" (USER_DS));
c0103da0:	b8 23 00 00 00       	mov    $0x23,%eax
c0103da5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs"::"a" (USER_DS));
c0103da7:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dac:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es"::"a" (KERNEL_DS));
c0103dae:	b8 10 00 00 00       	mov    $0x10,%eax
c0103db3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds"::"a" (KERNEL_DS));
c0103db5:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dba:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss"::"a" (KERNEL_DS));
c0103dbc:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dc1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n"::"i" (KERNEL_CS));
c0103dc3:	ea ca 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103dca
}
c0103dca:	90                   	nop
c0103dcb:	5d                   	pop    %ebp
c0103dcc:	c3                   	ret    

c0103dcd <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103dcd:	55                   	push   %ebp
c0103dce:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103dd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dd3:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0103dd8:	90                   	nop
c0103dd9:	5d                   	pop    %ebp
c0103dda:	c3                   	ret    

c0103ddb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103ddb:	55                   	push   %ebp
c0103ddc:	89 e5                	mov    %esp,%ebp
c0103dde:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t) bootstacktop);
c0103de1:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0103de6:	89 04 24             	mov    %eax,(%esp)
c0103de9:	e8 df ff ff ff       	call   c0103dcd <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103dee:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0103df5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t) & ts, sizeof(ts), DPL_KERNEL);
c0103df7:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0103dfe:	68 00 
c0103e00:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e05:	0f b7 c0             	movzwl %ax,%eax
c0103e08:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0103e0e:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e13:	c1 e8 10             	shr    $0x10,%eax
c0103e16:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0103e1b:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e22:	24 f0                	and    $0xf0,%al
c0103e24:	0c 09                	or     $0x9,%al
c0103e26:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e2b:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e32:	24 ef                	and    $0xef,%al
c0103e34:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e39:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e40:	24 9f                	and    $0x9f,%al
c0103e42:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e47:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e4e:	0c 80                	or     $0x80,%al
c0103e50:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e55:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e5c:	24 f0                	and    $0xf0,%al
c0103e5e:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e63:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e6a:	24 ef                	and    $0xef,%al
c0103e6c:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e71:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e78:	24 df                	and    $0xdf,%al
c0103e7a:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e7f:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e86:	0c 40                	or     $0x40,%al
c0103e88:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e8d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e94:	24 7f                	and    $0x7f,%al
c0103e96:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e9b:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103ea0:	c1 e8 18             	shr    $0x18,%eax
c0103ea3:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ea8:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0103eaf:	e8 e3 fe ff ff       	call   c0103d97 <lgdt>
c0103eb4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103eba:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ebe:	0f 00 d8             	ltr    %ax
}
c0103ec1:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103ec2:	90                   	nop
c0103ec3:	89 ec                	mov    %ebp,%esp
c0103ec5:	5d                   	pop    %ebp
c0103ec6:	c3                   	ret    

c0103ec7 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ec7:	55                   	push   %ebp
c0103ec8:	89 e5                	mov    %esp,%ebp
c0103eca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ecd:	c7 05 ac ce 11 c0 28 	movl   $0xc0106c28,0xc011ceac
c0103ed4:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ed7:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103edc:	8b 00                	mov    (%eax),%eax
c0103ede:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ee2:	c7 04 24 c4 6c 10 c0 	movl   $0xc0106cc4,(%esp)
c0103ee9:	e8 68 c4 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103eee:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103ef3:	8b 40 04             	mov    0x4(%eax),%eax
c0103ef6:	ff d0                	call   *%eax
}
c0103ef8:	90                   	nop
c0103ef9:	89 ec                	mov    %ebp,%esp
c0103efb:	5d                   	pop    %ebp
c0103efc:	c3                   	ret    

c0103efd <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103efd:	55                   	push   %ebp
c0103efe:	89 e5                	mov    %esp,%ebp
c0103f00:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f03:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f08:	8b 40 08             	mov    0x8(%eax),%eax
c0103f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f0e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f12:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f15:	89 14 24             	mov    %edx,(%esp)
c0103f18:	ff d0                	call   *%eax
}
c0103f1a:	90                   	nop
c0103f1b:	89 ec                	mov    %ebp,%esp
c0103f1d:	5d                   	pop    %ebp
c0103f1e:	c3                   	ret    

c0103f1f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f1f:	55                   	push   %ebp
c0103f20:	89 e5                	mov    %esp,%ebp
c0103f22:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c0103f25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f2c:	e8 24 fe ff ff       	call   c0103d55 <__intr_save>
c0103f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f34:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f39:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f3c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f3f:	89 14 24             	mov    %edx,(%esp)
c0103f42:	ff d0                	call   *%eax
c0103f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f4a:	89 04 24             	mov    %eax,(%esp)
c0103f4d:	e8 2f fe ff ff       	call   c0103d81 <__intr_restore>
    return page;
c0103f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f55:	89 ec                	mov    %ebp,%esp
c0103f57:	5d                   	pop    %ebp
c0103f58:	c3                   	ret    

c0103f59 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f59:	55                   	push   %ebp
c0103f5a:	89 e5                	mov    %esp,%ebp
c0103f5c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f5f:	e8 f1 fd ff ff       	call   c0103d55 <__intr_save>
c0103f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f67:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f6c:	8b 40 10             	mov    0x10(%eax),%eax
c0103f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f76:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f79:	89 14 24             	mov    %edx,(%esp)
c0103f7c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f81:	89 04 24             	mov    %eax,(%esp)
c0103f84:	e8 f8 fd ff ff       	call   c0103d81 <__intr_restore>
}
c0103f89:	90                   	nop
c0103f8a:	89 ec                	mov    %ebp,%esp
c0103f8c:	5d                   	pop    %ebp
c0103f8d:	c3                   	ret    

c0103f8e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f8e:	55                   	push   %ebp
c0103f8f:	89 e5                	mov    %esp,%ebp
c0103f91:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f94:	e8 bc fd ff ff       	call   c0103d55 <__intr_save>
c0103f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f9c:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103fa1:	8b 40 14             	mov    0x14(%eax),%eax
c0103fa4:	ff d0                	call   *%eax
c0103fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fac:	89 04 24             	mov    %eax,(%esp)
c0103faf:	e8 cd fd ff ff       	call   c0103d81 <__intr_restore>
    return ret;
c0103fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fb7:	89 ec                	mov    %ebp,%esp
c0103fb9:	5d                   	pop    %ebp
c0103fba:	c3                   	ret    

c0103fbb <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fbb:	55                   	push   %ebp
c0103fbc:	89 e5                	mov    %esp,%ebp
c0103fbe:	57                   	push   %edi
c0103fbf:	56                   	push   %esi
c0103fc0:	53                   	push   %ebx
c0103fc1:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *) (0x8000 + KERNBASE);
c0103fc7:	c7 45 cc 00 80 00 c0 	movl   $0xc0008000,-0x34(%ebp)
    uint64_t maxpa = 0;
c0103fce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103fdc:	c7 04 24 db 6c 10 c0 	movl   $0xc0106cdb,(%esp)
c0103fe3:	e8 6e c3 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++) {
c0103fe8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fef:	e9 0c 01 00 00       	jmp    c0104100 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103ff4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0103ff7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ffa:	89 d0                	mov    %edx,%eax
c0103ffc:	c1 e0 02             	shl    $0x2,%eax
c0103fff:	01 d0                	add    %edx,%eax
c0104001:	c1 e0 02             	shl    $0x2,%eax
c0104004:	01 c8                	add    %ecx,%eax
c0104006:	8b 50 08             	mov    0x8(%eax),%edx
c0104009:	8b 40 04             	mov    0x4(%eax),%eax
c010400c:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010400f:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104012:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104015:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104018:	89 d0                	mov    %edx,%eax
c010401a:	c1 e0 02             	shl    $0x2,%eax
c010401d:	01 d0                	add    %edx,%eax
c010401f:	c1 e0 02             	shl    $0x2,%eax
c0104022:	01 c8                	add    %ecx,%eax
c0104024:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104027:	8b 58 10             	mov    0x10(%eax),%ebx
c010402a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010402d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104030:	01 c8                	add    %ecx,%eax
c0104032:	11 da                	adc    %ebx,%edx
c0104034:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104037:	89 55 a4             	mov    %edx,-0x5c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010403a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010403d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104040:	89 d0                	mov    %edx,%eax
c0104042:	c1 e0 02             	shl    $0x2,%eax
c0104045:	01 d0                	add    %edx,%eax
c0104047:	c1 e0 02             	shl    $0x2,%eax
c010404a:	01 c8                	add    %ecx,%eax
c010404c:	83 c0 14             	add    $0x14,%eax
c010404f:	8b 00                	mov    (%eax),%eax
c0104051:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104057:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010405a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010405d:	83 c0 ff             	add    $0xffffffff,%eax
c0104060:	83 d2 ff             	adc    $0xffffffff,%edx
c0104063:	89 c6                	mov    %eax,%esi
c0104065:	89 d7                	mov    %edx,%edi
c0104067:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010406a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010406d:	89 d0                	mov    %edx,%eax
c010406f:	c1 e0 02             	shl    $0x2,%eax
c0104072:	01 d0                	add    %edx,%eax
c0104074:	c1 e0 02             	shl    $0x2,%eax
c0104077:	01 c8                	add    %ecx,%eax
c0104079:	8b 48 0c             	mov    0xc(%eax),%ecx
c010407c:	8b 58 10             	mov    0x10(%eax),%ebx
c010407f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104085:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104089:	89 74 24 14          	mov    %esi,0x14(%esp)
c010408d:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104091:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104094:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104097:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010409b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010409f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040a7:	c7 04 24 e8 6c 10 c0 	movl   $0xc0106ce8,(%esp)
c01040ae:	e8 a3 c2 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040b3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01040b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040b9:	89 d0                	mov    %edx,%eax
c01040bb:	c1 e0 02             	shl    $0x2,%eax
c01040be:	01 d0                	add    %edx,%eax
c01040c0:	c1 e0 02             	shl    $0x2,%eax
c01040c3:	01 c8                	add    %ecx,%eax
c01040c5:	83 c0 14             	add    $0x14,%eax
c01040c8:	8b 00                	mov    (%eax),%eax
c01040ca:	83 f8 01             	cmp    $0x1,%eax
c01040cd:	75 2e                	jne    c01040fd <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c01040cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040d5:	3b 45 a0             	cmp    -0x60(%ebp),%eax
c01040d8:	89 d0                	mov    %edx,%eax
c01040da:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c01040dd:	73 1e                	jae    c01040fd <page_init+0x142>
c01040df:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01040e4:	b8 00 00 00 00       	mov    $0x0,%eax
c01040e9:	3b 55 a8             	cmp    -0x58(%ebp),%edx
c01040ec:	1b 45 ac             	sbb    -0x54(%ebp),%eax
c01040ef:	72 0c                	jb     c01040fd <page_init+0x142>
                maxpa = end;
c01040f1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040f4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++) {
c01040fd:	ff 45 dc             	incl   -0x24(%ebp)
c0104100:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104103:	8b 00                	mov    (%eax),%eax
c0104105:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104108:	0f 8c e6 fe ff ff    	jl     c0103ff4 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010410e:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104113:	b8 00 00 00 00       	mov    $0x0,%eax
c0104118:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c010411b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c010411e:	73 0e                	jae    c010412e <page_init+0x173>
        maxpa = KMEMSIZE;
c0104120:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104127:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010412e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104131:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104134:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104138:	c1 ea 0c             	shr    $0xc,%edx
c010413b:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
    pages = (struct Page *) ROUNDUP((void *) end, PGSIZE);
c0104140:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
c0104147:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c010414c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010414f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104152:	01 d0                	add    %edx,%eax
c0104154:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104157:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010415a:	ba 00 00 00 00       	mov    $0x0,%edx
c010415f:	f7 75 c8             	divl   -0x38(%ebp)
c0104162:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104165:	29 d0                	sub    %edx,%eax
c0104167:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0

    for (i = 0; i < npage; i++) {
c010416c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104173:	eb 2f                	jmp    c01041a4 <page_init+0x1e9>
        SetPageReserved(pages + i);
c0104175:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c010417b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010417e:	89 d0                	mov    %edx,%eax
c0104180:	c1 e0 02             	shl    $0x2,%eax
c0104183:	01 d0                	add    %edx,%eax
c0104185:	c1 e0 02             	shl    $0x2,%eax
c0104188:	01 c8                	add    %ecx,%eax
c010418a:	83 c0 04             	add    $0x4,%eax
c010418d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
c0104194:	89 45 98             	mov    %eax,-0x68(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104197:	8b 45 98             	mov    -0x68(%ebp),%eax
c010419a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010419d:	0f ab 10             	bts    %edx,(%eax)
}
c01041a0:	90                   	nop
    for (i = 0; i < npage; i++) {
c01041a1:	ff 45 dc             	incl   -0x24(%ebp)
c01041a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041a7:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01041ac:	39 c2                	cmp    %eax,%edx
c01041ae:	72 c5                	jb     c0104175 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t) pages + sizeof(struct Page) * npage);
c01041b0:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01041b6:	89 d0                	mov    %edx,%eax
c01041b8:	c1 e0 02             	shl    $0x2,%eax
c01041bb:	01 d0                	add    %edx,%eax
c01041bd:	c1 e0 02             	shl    $0x2,%eax
c01041c0:	89 c2                	mov    %eax,%edx
c01041c2:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c01041c7:	01 d0                	add    %edx,%eax
c01041c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01041cc:	81 7d c0 ff ff ff bf 	cmpl   $0xbfffffff,-0x40(%ebp)
c01041d3:	77 23                	ja     c01041f8 <page_init+0x23d>
c01041d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01041d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041dc:	c7 44 24 08 18 6d 10 	movl   $0xc0106d18,0x8(%esp)
c01041e3:	c0 
c01041e4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01041eb:	00 
c01041ec:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01041f3:	e8 f0 ca ff ff       	call   c0100ce8 <__panic>
c01041f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01041fb:	05 00 00 00 40       	add    $0x40000000,%eax
c0104200:	89 45 bc             	mov    %eax,-0x44(%ebp)

    for (i = 0; i < memmap->nr_map; i++) {
c0104203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010420a:	e9 85 01 00 00       	jmp    c0104394 <page_init+0x3d9>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010420f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104212:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104215:	89 d0                	mov    %edx,%eax
c0104217:	c1 e0 02             	shl    $0x2,%eax
c010421a:	01 d0                	add    %edx,%eax
c010421c:	c1 e0 02             	shl    $0x2,%eax
c010421f:	01 c8                	add    %ecx,%eax
c0104221:	8b 50 08             	mov    0x8(%eax),%edx
c0104224:	8b 40 04             	mov    0x4(%eax),%eax
c0104227:	89 45 90             	mov    %eax,-0x70(%ebp)
c010422a:	89 55 94             	mov    %edx,-0x6c(%ebp)
c010422d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104230:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104233:	89 d0                	mov    %edx,%eax
c0104235:	c1 e0 02             	shl    $0x2,%eax
c0104238:	01 d0                	add    %edx,%eax
c010423a:	c1 e0 02             	shl    $0x2,%eax
c010423d:	01 c8                	add    %ecx,%eax
c010423f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104242:	8b 58 10             	mov    0x10(%eax),%ebx
c0104245:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104248:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010424b:	01 c8                	add    %ecx,%eax
c010424d:	11 da                	adc    %ebx,%edx
c010424f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104252:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104255:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0104258:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010425b:	89 d0                	mov    %edx,%eax
c010425d:	c1 e0 02             	shl    $0x2,%eax
c0104260:	01 d0                	add    %edx,%eax
c0104262:	c1 e0 02             	shl    $0x2,%eax
c0104265:	01 c8                	add    %ecx,%eax
c0104267:	83 c0 14             	add    $0x14,%eax
c010426a:	8b 00                	mov    (%eax),%eax
c010426c:	83 f8 01             	cmp    $0x1,%eax
c010426f:	0f 85 1c 01 00 00    	jne    c0104391 <page_init+0x3d6>
            if (begin < freemem) {
c0104275:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0104278:	bb 00 00 00 00       	mov    $0x0,%ebx
c010427d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104280:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104283:	39 c8                	cmp    %ecx,%eax
c0104285:	89 d0                	mov    %edx,%eax
c0104287:	19 d8                	sbb    %ebx,%eax
c0104289:	73 0e                	jae    c0104299 <page_init+0x2de>
                begin = freemem;
c010428b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010428e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104293:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104296:	89 55 94             	mov    %edx,-0x6c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104299:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010429e:	b8 00 00 00 00       	mov    $0x0,%eax
c01042a3:	3b 55 d0             	cmp    -0x30(%ebp),%edx
c01042a6:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01042a9:	73 0e                	jae    c01042b9 <page_init+0x2fe>
                end = KMEMSIZE;
c01042ab:	c7 45 d0 00 00 00 38 	movl   $0x38000000,-0x30(%ebp)
c01042b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (begin < end) {
c01042b9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042bf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01042c2:	89 d0                	mov    %edx,%eax
c01042c4:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c01042c7:	0f 83 c4 00 00 00    	jae    c0104391 <page_init+0x3d6>
                begin = ROUNDUP(begin, PGSIZE);
c01042cd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
c01042d4:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042d7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042da:	89 c2                	mov    %eax,%edx
c01042dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01042df:	01 d0                	add    %edx,%eax
c01042e1:	48                   	dec    %eax
c01042e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01042e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01042ed:	f7 75 b8             	divl   -0x48(%ebp)
c01042f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042f3:	29 d0                	sub    %edx,%eax
c01042f5:	ba 00 00 00 00       	mov    $0x0,%edx
c01042fa:	89 45 90             	mov    %eax,-0x70(%ebp)
c01042fd:	89 55 94             	mov    %edx,-0x6c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104300:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104303:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104306:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104309:	ba 00 00 00 00       	mov    $0x0,%edx
c010430e:	89 c7                	mov    %eax,%edi
c0104310:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104316:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104319:	89 d0                	mov    %edx,%eax
c010431b:	83 e0 00             	and    $0x0,%eax
c010431e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104321:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104324:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104327:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010432a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                if (begin < end) {
c010432d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104330:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104333:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104336:	89 d0                	mov    %edx,%eax
c0104338:	1b 45 d4             	sbb    -0x2c(%ebp),%eax
c010433b:	73 54                	jae    c0104391 <page_init+0x3d6>

                    cprintf("memory: %08llx,%08llx\n", begin, &begin);
c010433d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104340:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104343:	8d 4d 90             	lea    -0x70(%ebp),%ecx
c0104346:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010434a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010434e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104352:	c7 04 24 4a 6d 10 c0 	movl   $0xc0106d4a,(%esp)
c0104359:	e8 f8 bf ff ff       	call   c0100356 <cprintf>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010435e:	8b 4d 90             	mov    -0x70(%ebp),%ecx
c0104361:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
c0104364:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104367:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010436a:	29 c8                	sub    %ecx,%eax
c010436c:	19 da                	sbb    %ebx,%edx
c010436e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104372:	c1 ea 0c             	shr    $0xc,%edx
c0104375:	89 c3                	mov    %eax,%ebx
c0104377:	8b 45 90             	mov    -0x70(%ebp),%eax
c010437a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010437d:	89 04 24             	mov    %eax,(%esp)
c0104380:	e8 89 f8 ff ff       	call   c0103c0e <pa2page>
c0104385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104389:	89 04 24             	mov    %eax,(%esp)
c010438c:	e8 6c fb ff ff       	call   c0103efd <init_memmap>
    for (i = 0; i < memmap->nr_map; i++) {
c0104391:	ff 45 dc             	incl   -0x24(%ebp)
c0104394:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104397:	8b 00                	mov    (%eax),%eax
c0104399:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010439c:	0f 8c 6d fe ff ff    	jl     c010420f <page_init+0x254>
                }
            }
        }
    }
}
c01043a2:	90                   	nop
c01043a3:	90                   	nop
c01043a4:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043aa:	5b                   	pop    %ebx
c01043ab:	5e                   	pop    %esi
c01043ac:	5f                   	pop    %edi
c01043ad:	5d                   	pop    %ebp
c01043ae:	c3                   	ret    

c01043af <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043af:	55                   	push   %ebp
c01043b0:	89 e5                	mov    %esp,%ebp
c01043b2:	83 ec 38             	sub    $0x38,%esp
    cprintf("%08x",pgdir);
c01043b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043bc:	c7 04 24 61 6d 10 c0 	movl   $0xc0106d61,(%esp)
c01043c3:	e8 8e bf ff ff       	call   c0100356 <cprintf>
    assert(PGOFF(la) == PGOFF(pa));
c01043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043cb:	33 45 14             	xor    0x14(%ebp),%eax
c01043ce:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043d3:	85 c0                	test   %eax,%eax
c01043d5:	74 24                	je     c01043fb <boot_map_segment+0x4c>
c01043d7:	c7 44 24 0c 66 6d 10 	movl   $0xc0106d66,0xc(%esp)
c01043de:	c0 
c01043df:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01043e6:	c0 
c01043e7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01043ee:	00 
c01043ef:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01043f6:	e8 ed c8 ff ff       	call   c0100ce8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104402:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104405:	25 ff 0f 00 00       	and    $0xfff,%eax
c010440a:	89 c2                	mov    %eax,%edx
c010440c:	8b 45 10             	mov    0x10(%ebp),%eax
c010440f:	01 c2                	add    %eax,%edx
c0104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104414:	01 d0                	add    %edx,%eax
c0104416:	48                   	dec    %eax
c0104417:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010441a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010441d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104422:	f7 75 f0             	divl   -0x10(%ebp)
c0104425:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104428:	29 d0                	sub    %edx,%eax
c010442a:	c1 e8 0c             	shr    $0xc,%eax
c010442d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104430:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104433:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104436:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104439:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010443e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104441:	8b 45 14             	mov    0x14(%ebp),%eax
c0104444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010444a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010444f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
c0104452:	eb 68                	jmp    c01044bc <boot_map_segment+0x10d>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104454:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010445b:	00 
c010445c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010445f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104463:	8b 45 08             	mov    0x8(%ebp),%eax
c0104466:	89 04 24             	mov    %eax,(%esp)
c0104469:	e8 88 01 00 00       	call   c01045f6 <get_pte>
c010446e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104471:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104475:	75 24                	jne    c010449b <boot_map_segment+0xec>
c0104477:	c7 44 24 0c 92 6d 10 	movl   $0xc0106d92,0xc(%esp)
c010447e:	c0 
c010447f:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104486:	c0 
c0104487:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c010448e:	00 
c010448f:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104496:	e8 4d c8 ff ff       	call   c0100ce8 <__panic>
        *ptep = pa | PTE_P | perm;
c010449b:	8b 45 14             	mov    0x14(%ebp),%eax
c010449e:	0b 45 18             	or     0x18(%ebp),%eax
c01044a1:	83 c8 01             	or     $0x1,%eax
c01044a4:	89 c2                	mov    %eax,%edx
c01044a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044a9:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
c01044ab:	ff 4d f4             	decl   -0xc(%ebp)
c01044ae:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044b5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044c0:	75 92                	jne    c0104454 <boot_map_segment+0xa5>
    }
}
c01044c2:	90                   	nop
c01044c3:	90                   	nop
c01044c4:	89 ec                	mov    %ebp,%esp
c01044c6:	5d                   	pop    %ebp
c01044c7:	c3                   	ret    

c01044c8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044c8:	55                   	push   %ebp
c01044c9:	89 e5                	mov    %esp,%ebp
c01044cb:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044d5:	e8 45 fa ff ff       	call   c0103f1f <alloc_pages>
c01044da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044e1:	75 1c                	jne    c01044ff <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044e3:	c7 44 24 08 9f 6d 10 	movl   $0xc0106d9f,0x8(%esp)
c01044ea:	c0 
c01044eb:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01044f2:	00 
c01044f3:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01044fa:	e8 e9 c7 ff ff       	call   c0100ce8 <__panic>
    }
    return page2kva(p);
c01044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104502:	89 04 24             	mov    %eax,(%esp)
c0104505:	e8 55 f7 ff ff       	call   c0103c5f <page2kva>
}
c010450a:	89 ec                	mov    %ebp,%esp
c010450c:	5d                   	pop    %ebp
c010450d:	c3                   	ret    

c010450e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010450e:	55                   	push   %ebp
c010450f:	89 e5                	mov    %esp,%ebp
c0104511:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104514:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104519:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010451c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104523:	77 23                	ja     c0104548 <pmm_init+0x3a>
c0104525:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104528:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010452c:	c7 44 24 08 18 6d 10 	movl   $0xc0106d18,0x8(%esp)
c0104533:	c0 
c0104534:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c010453b:	00 
c010453c:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104543:	e8 a0 c7 ff ff       	call   c0100ce8 <__panic>
c0104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104550:	a3 a8 ce 11 c0       	mov    %eax,0xc011cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104555:	e8 6d f9 ff ff       	call   c0103ec7 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010455a:	e8 5c fa ff ff       	call   c0103fbb <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010455f:	e8 fe 03 00 00       	call   c0104962 <check_alloc_page>

    check_pgdir();
c0104564:	e8 1a 04 00 00       	call   c0104983 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104569:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010456e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104571:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104578:	77 23                	ja     c010459d <pmm_init+0x8f>
c010457a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010457d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104581:	c7 44 24 08 18 6d 10 	movl   $0xc0106d18,0x8(%esp)
c0104588:	c0 
c0104589:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0104590:	00 
c0104591:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104598:	e8 4b c7 ff ff       	call   c0100ce8 <__panic>
c010459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01045a6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045ab:	05 ac 0f 00 00       	add    $0xfac,%eax
c01045b0:	83 ca 03             	or     $0x3,%edx
c01045b3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045b5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01045ba:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045c1:	00 
c01045c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045c9:	00 
c01045ca:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045d1:	38 
c01045d2:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045d9:	c0 
c01045da:	89 04 24             	mov    %eax,(%esp)
c01045dd:	e8 cd fd ff ff       	call   c01043af <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045e2:	e8 f4 f7 ff ff       	call   c0103ddb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045e7:	e8 35 0a 00 00       	call   c0105021 <check_boot_pgdir>

    print_pgdir();
c01045ec:	e8 b2 0e 00 00       	call   c01054a3 <print_pgdir>

}
c01045f1:	90                   	nop
c01045f2:	89 ec                	mov    %ebp,%esp
c01045f4:	5d                   	pop    %ebp
c01045f5:	c3                   	ret    

c01045f6 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045f6:	55                   	push   %ebp
c01045f7:	89 e5                	mov    %esp,%ebp
c01045f9:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01045fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ff:	c1 e8 16             	shr    $0x16,%eax
c0104602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104609:	8b 45 08             	mov    0x8(%ebp),%eax
c010460c:	01 d0                	add    %edx,%eax
c010460e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t pa1, la2;

    if (!(*pdep & PTE_P)) {
c0104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104614:	8b 00                	mov    (%eax),%eax
c0104616:	83 e0 01             	and    $0x1,%eax
c0104619:	85 c0                	test   %eax,%eax
c010461b:	0f 85 b9 00 00 00    	jne    c01046da <get_pte+0xe4>
        struct Page *page;
        if (!create) {
c0104621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104625:	75 0a                	jne    c0104631 <get_pte+0x3b>
            return NULL;
c0104627:	b8 00 00 00 00       	mov    $0x0,%eax
c010462c:	e9 08 01 00 00       	jmp    c0104739 <get_pte+0x143>
        } else {
            page = alloc_page();
c0104631:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104638:	e8 e2 f8 ff ff       	call   c0103f1f <alloc_pages>
c010463d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if (page == NULL) return;
c0104640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104644:	0f 84 ef 00 00 00    	je     c0104739 <get_pte+0x143>
            set_page_ref(page, 1);
c010464a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104651:	00 
c0104652:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104655:	89 04 24             	mov    %eax,(%esp)
c0104658:	e8 bc f6 ff ff       	call   c0103d19 <set_page_ref>
            pa1 = page2pa(page);
c010465d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104660:	89 04 24             	mov    %eax,(%esp)
c0104663:	e8 8e f5 ff ff       	call   c0103bf6 <page2pa>
c0104668:	89 45 ec             	mov    %eax,-0x14(%ebp)
            la2 = KADDR(pa1);
c010466b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010466e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104671:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104674:	c1 e8 0c             	shr    $0xc,%eax
c0104677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010467a:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010467f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104682:	72 23                	jb     c01046a7 <get_pte+0xb1>
c0104684:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104687:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010468b:	c7 44 24 08 74 6c 10 	movl   $0xc0106c74,0x8(%esp)
c0104692:	c0 
c0104693:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
c010469a:	00 
c010469b:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01046a2:	e8 41 c6 ff ff       	call   c0100ce8 <__panic>
c01046a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046af:	89 45 e0             	mov    %eax,-0x20(%ebp)
            memset(la2, 0, PGSIZE);
c01046b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046bc:	00 
c01046bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046c4:	00 
c01046c5:	89 04 24             	mov    %eax,(%esp)
c01046c8:	e8 db 18 00 00       	call   c0105fa8 <memset>
            //set permission
            //这里为何要用物理地址？可能这个机制是物理寻址
//            *pdep = la2 | PTE_P | PTE_U | PTE_W;
            *pdep = pa1 | PTE_P | PTE_U | PTE_W;
c01046cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046d0:	83 c8 07             	or     $0x7,%eax
c01046d3:	89 c2                	mov    %eax,%edx
c01046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d8:	89 10                	mov    %edx,(%eax)
        }
    }
//    PTE_ADDR(pte)
//    &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
    return &((pte_t *) KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046dd:	8b 00                	mov    (%eax),%eax
c01046df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046ea:	c1 e8 0c             	shr    $0xc,%eax
c01046ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01046f0:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01046f5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01046f8:	72 23                	jb     c010471d <get_pte+0x127>
c01046fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104701:	c7 44 24 08 74 6c 10 	movl   $0xc0106c74,0x8(%esp)
c0104708:	c0 
c0104709:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c0104710:	00 
c0104711:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104718:	e8 cb c5 ff ff       	call   c0100ce8 <__panic>
c010471d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104720:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104725:	89 c2                	mov    %eax,%edx
c0104727:	8b 45 0c             	mov    0xc(%ebp),%eax
c010472a:	c1 e8 0c             	shr    $0xc,%eax
c010472d:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104732:	c1 e0 02             	shl    $0x2,%eax
c0104735:	01 d0                	add    %edx,%eax
c0104737:	eb 00                	jmp    c0104739 <get_pte+0x143>
//        // 之后该页面就是其中的一个二级页面
//        *pdep = pa | PTE_U | PTE_W | PTE_P;
//    }
//    // 返回在pgdir中对应于la的二级页表项
//    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
c0104739:	89 ec                	mov    %ebp,%esp
c010473b:	5d                   	pop    %ebp
c010473c:	c3                   	ret    

c010473d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010473d:	55                   	push   %ebp
c010473e:	89 e5                	mov    %esp,%ebp
c0104740:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104743:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010474a:	00 
c010474b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104752:	8b 45 08             	mov    0x8(%ebp),%eax
c0104755:	89 04 24             	mov    %eax,(%esp)
c0104758:	e8 99 fe ff ff       	call   c01045f6 <get_pte>
c010475d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104760:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104764:	74 08                	je     c010476e <get_page+0x31>
        *ptep_store = ptep;
c0104766:	8b 45 10             	mov    0x10(%ebp),%eax
c0104769:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010476c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010476e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104772:	74 1b                	je     c010478f <get_page+0x52>
c0104774:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104777:	8b 00                	mov    (%eax),%eax
c0104779:	83 e0 01             	and    $0x1,%eax
c010477c:	85 c0                	test   %eax,%eax
c010477e:	74 0f                	je     c010478f <get_page+0x52>
        return pte2page(*ptep);
c0104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104783:	8b 00                	mov    (%eax),%eax
c0104785:	89 04 24             	mov    %eax,(%esp)
c0104788:	e8 28 f5 ff ff       	call   c0103cb5 <pte2page>
c010478d:	eb 05                	jmp    c0104794 <get_page+0x57>
    }
    return NULL;
c010478f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104794:	89 ec                	mov    %ebp,%esp
c0104796:	5d                   	pop    %ebp
c0104797:	c3                   	ret    

c0104798 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104798:	55                   	push   %ebp
c0104799:	89 e5                	mov    %esp,%ebp
c010479b:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P){
c010479e:	8b 45 10             	mov    0x10(%ebp),%eax
c01047a1:	8b 00                	mov    (%eax),%eax
c01047a3:	83 e0 01             	and    $0x1,%eax
c01047a6:	85 c0                	test   %eax,%eax
c01047a8:	74 52                	je     c01047fc <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
c01047aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01047ad:	8b 00                	mov    (%eax),%eax
c01047af:	89 04 24             	mov    %eax,(%esp)
c01047b2:	e8 fe f4 ff ff       	call   c0103cb5 <pte2page>
c01047b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
c01047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bd:	89 04 24             	mov    %eax,(%esp)
c01047c0:	e8 79 f5 ff ff       	call   c0103d3e <page_ref_dec>
    if (page->ref == 0) {
c01047c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c8:	8b 00                	mov    (%eax),%eax
c01047ca:	85 c0                	test   %eax,%eax
c01047cc:	75 13                	jne    c01047e1 <page_remove_pte+0x49>
        free_page(page);
c01047ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047d5:	00 
c01047d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d9:	89 04 24             	mov    %eax,(%esp)
c01047dc:	e8 78 f7 ff ff       	call   c0103f59 <free_pages>
    }
    *ptep=0;
c01047e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01047e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);
c01047ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f4:	89 04 24             	mov    %eax,(%esp)
c01047f7:	e8 07 01 00 00       	call   c0104903 <tlb_invalidate>
    }

}
c01047fc:	90                   	nop
c01047fd:	89 ec                	mov    %ebp,%esp
c01047ff:	5d                   	pop    %ebp
c0104800:	c3                   	ret    

c0104801 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104801:	55                   	push   %ebp
c0104802:	89 e5                	mov    %esp,%ebp
c0104804:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104807:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010480e:	00 
c010480f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104812:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104816:	8b 45 08             	mov    0x8(%ebp),%eax
c0104819:	89 04 24             	mov    %eax,(%esp)
c010481c:	e8 d5 fd ff ff       	call   c01045f6 <get_pte>
c0104821:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104828:	74 19                	je     c0104843 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104831:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104834:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104838:	8b 45 08             	mov    0x8(%ebp),%eax
c010483b:	89 04 24             	mov    %eax,(%esp)
c010483e:	e8 55 ff ff ff       	call   c0104798 <page_remove_pte>
    }
}
c0104843:	90                   	nop
c0104844:	89 ec                	mov    %ebp,%esp
c0104846:	5d                   	pop    %ebp
c0104847:	c3                   	ret    

c0104848 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104848:	55                   	push   %ebp
c0104849:	89 e5                	mov    %esp,%ebp
c010484b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010484e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104855:	00 
c0104856:	8b 45 10             	mov    0x10(%ebp),%eax
c0104859:	89 44 24 04          	mov    %eax,0x4(%esp)
c010485d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104860:	89 04 24             	mov    %eax,(%esp)
c0104863:	e8 8e fd ff ff       	call   c01045f6 <get_pte>
c0104868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010486b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010486f:	75 0a                	jne    c010487b <page_insert+0x33>
        return -E_NO_MEM;
c0104871:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104876:	e9 84 00 00 00       	jmp    c01048ff <page_insert+0xb7>
    }
    page_ref_inc(page);
c010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010487e:	89 04 24             	mov    %eax,(%esp)
c0104881:	e8 a1 f4 ff ff       	call   c0103d27 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104889:	8b 00                	mov    (%eax),%eax
c010488b:	83 e0 01             	and    $0x1,%eax
c010488e:	85 c0                	test   %eax,%eax
c0104890:	74 3e                	je     c01048d0 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104895:	8b 00                	mov    (%eax),%eax
c0104897:	89 04 24             	mov    %eax,(%esp)
c010489a:	e8 16 f4 ff ff       	call   c0103cb5 <pte2page>
c010489f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01048a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01048a8:	75 0d                	jne    c01048b7 <page_insert+0x6f>
            page_ref_dec(page);
c01048aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048ad:	89 04 24             	mov    %eax,(%esp)
c01048b0:	e8 89 f4 ff ff       	call   c0103d3e <page_ref_dec>
c01048b5:	eb 19                	jmp    c01048d0 <page_insert+0x88>
        } else {
            page_remove_pte(pgdir, la, ptep);
c01048b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048be:	8b 45 10             	mov    0x10(%ebp),%eax
c01048c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c8:	89 04 24             	mov    %eax,(%esp)
c01048cb:	e8 c8 fe ff ff       	call   c0104798 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01048d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048d3:	89 04 24             	mov    %eax,(%esp)
c01048d6:	e8 1b f3 ff ff       	call   c0103bf6 <page2pa>
c01048db:	0b 45 14             	or     0x14(%ebp),%eax
c01048de:	83 c8 01             	or     $0x1,%eax
c01048e1:	89 c2                	mov    %eax,%edx
c01048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e6:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01048e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01048eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f2:	89 04 24             	mov    %eax,(%esp)
c01048f5:	e8 09 00 00 00       	call   c0104903 <tlb_invalidate>
    return 0;
c01048fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048ff:	89 ec                	mov    %ebp,%esp
c0104901:	5d                   	pop    %ebp
c0104902:	c3                   	ret    

c0104903 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104903:	55                   	push   %ebp
c0104904:	89 e5                	mov    %esp,%ebp
c0104906:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104909:	0f 20 d8             	mov    %cr3,%eax
c010490c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010490f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104912:	8b 45 08             	mov    0x8(%ebp),%eax
c0104915:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104918:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010491f:	77 23                	ja     c0104944 <tlb_invalidate+0x41>
c0104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104924:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104928:	c7 44 24 08 18 6d 10 	movl   $0xc0106d18,0x8(%esp)
c010492f:	c0 
c0104930:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104937:	00 
c0104938:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010493f:	e8 a4 c3 ff ff       	call   c0100ce8 <__panic>
c0104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104947:	05 00 00 00 40       	add    $0x40000000,%eax
c010494c:	39 d0                	cmp    %edx,%eax
c010494e:	75 0d                	jne    c010495d <tlb_invalidate+0x5a>
        invlpg((void *) la);
c0104950:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104953:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104956:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104959:	0f 01 38             	invlpg (%eax)
}
c010495c:	90                   	nop
    }
}
c010495d:	90                   	nop
c010495e:	89 ec                	mov    %ebp,%esp
c0104960:	5d                   	pop    %ebp
c0104961:	c3                   	ret    

c0104962 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104962:	55                   	push   %ebp
c0104963:	89 e5                	mov    %esp,%ebp
c0104965:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104968:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c010496d:	8b 40 18             	mov    0x18(%eax),%eax
c0104970:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104972:	c7 04 24 b8 6d 10 c0 	movl   $0xc0106db8,(%esp)
c0104979:	e8 d8 b9 ff ff       	call   c0100356 <cprintf>
}
c010497e:	90                   	nop
c010497f:	89 ec                	mov    %ebp,%esp
c0104981:	5d                   	pop    %ebp
c0104982:	c3                   	ret    

c0104983 <check_pgdir>:

static void
check_pgdir(void) {
c0104983:	55                   	push   %ebp
c0104984:	89 e5                	mov    %esp,%ebp
c0104986:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104989:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010498e:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104993:	76 24                	jbe    c01049b9 <check_pgdir+0x36>
c0104995:	c7 44 24 0c d7 6d 10 	movl   $0xc0106dd7,0xc(%esp)
c010499c:	c0 
c010499d:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01049a4:	c0 
c01049a5:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01049ac:	00 
c01049ad:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01049b4:	e8 2f c3 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t) PGOFF(boot_pgdir) == 0);
c01049b9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049be:	85 c0                	test   %eax,%eax
c01049c0:	74 0e                	je     c01049d0 <check_pgdir+0x4d>
c01049c2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049c7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049cc:	85 c0                	test   %eax,%eax
c01049ce:	74 24                	je     c01049f4 <check_pgdir+0x71>
c01049d0:	c7 44 24 0c f4 6d 10 	movl   $0xc0106df4,0xc(%esp)
c01049d7:	c0 
c01049d8:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01049df:	c0 
c01049e0:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c01049e7:	00 
c01049e8:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01049ef:	e8 f4 c2 ff ff       	call   c0100ce8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01049f4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a00:	00 
c0104a01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a08:	00 
c0104a09:	89 04 24             	mov    %eax,(%esp)
c0104a0c:	e8 2c fd ff ff       	call   c010473d <get_page>
c0104a11:	85 c0                	test   %eax,%eax
c0104a13:	74 24                	je     c0104a39 <check_pgdir+0xb6>
c0104a15:	c7 44 24 0c 2c 6e 10 	movl   $0xc0106e2c,0xc(%esp)
c0104a1c:	c0 
c0104a1d:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104a24:	c0 
c0104a25:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a2c:	00 
c0104a2d:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104a34:	e8 af c2 ff ff       	call   c0100ce8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a40:	e8 da f4 ff ff       	call   c0103f1f <alloc_pages>
c0104a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a48:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a4d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a54:	00 
c0104a55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a5c:	00 
c0104a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a60:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a64:	89 04 24             	mov    %eax,(%esp)
c0104a67:	e8 dc fd ff ff       	call   c0104848 <page_insert>
c0104a6c:	85 c0                	test   %eax,%eax
c0104a6e:	74 24                	je     c0104a94 <check_pgdir+0x111>
c0104a70:	c7 44 24 0c 54 6e 10 	movl   $0xc0106e54,0xc(%esp)
c0104a77:	c0 
c0104a78:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104a7f:	c0 
c0104a80:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104a87:	00 
c0104a88:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104a8f:	e8 54 c2 ff ff       	call   c0100ce8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a94:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aa0:	00 
c0104aa1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104aa8:	00 
c0104aa9:	89 04 24             	mov    %eax,(%esp)
c0104aac:	e8 45 fb ff ff       	call   c01045f6 <get_pte>
c0104ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ab8:	75 24                	jne    c0104ade <check_pgdir+0x15b>
c0104aba:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104ac9:	c0 
c0104aca:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104ad1:	00 
c0104ad2:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104ad9:	e8 0a c2 ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae1:	8b 00                	mov    (%eax),%eax
c0104ae3:	89 04 24             	mov    %eax,(%esp)
c0104ae6:	e8 ca f1 ff ff       	call   c0103cb5 <pte2page>
c0104aeb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104aee:	74 24                	je     c0104b14 <check_pgdir+0x191>
c0104af0:	c7 44 24 0c ad 6e 10 	movl   $0xc0106ead,0xc(%esp)
c0104af7:	c0 
c0104af8:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104aff:	c0 
c0104b00:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104b07:	00 
c0104b08:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104b0f:	e8 d4 c1 ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 1);
c0104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b17:	89 04 24             	mov    %eax,(%esp)
c0104b1a:	e8 f0 f1 ff ff       	call   c0103d0f <page_ref>
c0104b1f:	83 f8 01             	cmp    $0x1,%eax
c0104b22:	74 24                	je     c0104b48 <check_pgdir+0x1c5>
c0104b24:	c7 44 24 0c c3 6e 10 	movl   $0xc0106ec3,0xc(%esp)
c0104b2b:	c0 
c0104b2c:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104b33:	c0 
c0104b34:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b3b:	00 
c0104b3c:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104b43:	e8 a0 c1 ff ff       	call   c0100ce8 <__panic>

    ptep = &((pte_t *) KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b48:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b4d:	8b 00                	mov    (%eax),%eax
c0104b4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b5a:	c1 e8 0c             	shr    $0xc,%eax
c0104b5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b60:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104b65:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b68:	72 23                	jb     c0104b8d <check_pgdir+0x20a>
c0104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b71:	c7 44 24 08 74 6c 10 	movl   $0xc0106c74,0x8(%esp)
c0104b78:	c0 
c0104b79:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104b80:	00 
c0104b81:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104b88:	e8 5b c1 ff ff       	call   c0100ce8 <__panic>
c0104b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b90:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b95:	83 c0 04             	add    $0x4,%eax
c0104b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b9b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ba0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ba7:	00 
c0104ba8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104baf:	00 
c0104bb0:	89 04 24             	mov    %eax,(%esp)
c0104bb3:	e8 3e fa ff ff       	call   c01045f6 <get_pte>
c0104bb8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104bbb:	74 24                	je     c0104be1 <check_pgdir+0x25e>
c0104bbd:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104bc4:	c0 
c0104bc5:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104bcc:	c0 
c0104bcd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104bd4:	00 
c0104bd5:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104bdc:	e8 07 c1 ff ff       	call   c0100ce8 <__panic>

    p2 = alloc_page();
c0104be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104be8:	e8 32 f3 ff ff       	call   c0103f1f <alloc_pages>
c0104bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104bf0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104bf5:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104bfc:	00 
c0104bfd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c04:	00 
c0104c05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c08:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c0c:	89 04 24             	mov    %eax,(%esp)
c0104c0f:	e8 34 fc ff ff       	call   c0104848 <page_insert>
c0104c14:	85 c0                	test   %eax,%eax
c0104c16:	74 24                	je     c0104c3c <check_pgdir+0x2b9>
c0104c18:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104c1f:	c0 
c0104c20:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104c27:	c0 
c0104c28:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104c2f:	00 
c0104c30:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104c37:	e8 ac c0 ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c3c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104c41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c48:	00 
c0104c49:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c50:	00 
c0104c51:	89 04 24             	mov    %eax,(%esp)
c0104c54:	e8 9d f9 ff ff       	call   c01045f6 <get_pte>
c0104c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c60:	75 24                	jne    c0104c86 <check_pgdir+0x303>
c0104c62:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0104c69:	c0 
c0104c6a:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104c71:	c0 
c0104c72:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104c79:	00 
c0104c7a:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104c81:	e8 62 c0 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_U);
c0104c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c89:	8b 00                	mov    (%eax),%eax
c0104c8b:	83 e0 04             	and    $0x4,%eax
c0104c8e:	85 c0                	test   %eax,%eax
c0104c90:	75 24                	jne    c0104cb6 <check_pgdir+0x333>
c0104c92:	c7 44 24 0c 68 6f 10 	movl   $0xc0106f68,0xc(%esp)
c0104c99:	c0 
c0104c9a:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104ca1:	c0 
c0104ca2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104ca9:	00 
c0104caa:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104cb1:	e8 32 c0 ff ff       	call   c0100ce8 <__panic>
    assert(*ptep & PTE_W);
c0104cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb9:	8b 00                	mov    (%eax),%eax
c0104cbb:	83 e0 02             	and    $0x2,%eax
c0104cbe:	85 c0                	test   %eax,%eax
c0104cc0:	75 24                	jne    c0104ce6 <check_pgdir+0x363>
c0104cc2:	c7 44 24 0c 76 6f 10 	movl   $0xc0106f76,0xc(%esp)
c0104cc9:	c0 
c0104cca:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104cd1:	c0 
c0104cd2:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104cd9:	00 
c0104cda:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104ce1:	e8 02 c0 ff ff       	call   c0100ce8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104ce6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ceb:	8b 00                	mov    (%eax),%eax
c0104ced:	83 e0 04             	and    $0x4,%eax
c0104cf0:	85 c0                	test   %eax,%eax
c0104cf2:	75 24                	jne    c0104d18 <check_pgdir+0x395>
c0104cf4:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0104cfb:	c0 
c0104cfc:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104d03:	c0 
c0104d04:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104d0b:	00 
c0104d0c:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104d13:	e8 d0 bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 1);
c0104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d1b:	89 04 24             	mov    %eax,(%esp)
c0104d1e:	e8 ec ef ff ff       	call   c0103d0f <page_ref>
c0104d23:	83 f8 01             	cmp    $0x1,%eax
c0104d26:	74 24                	je     c0104d4c <check_pgdir+0x3c9>
c0104d28:	c7 44 24 0c 9a 6f 10 	movl   $0xc0106f9a,0xc(%esp)
c0104d2f:	c0 
c0104d30:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104d37:	c0 
c0104d38:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d3f:	00 
c0104d40:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104d47:	e8 9c bf ff ff       	call   c0100ce8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d4c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104d51:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d58:	00 
c0104d59:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d60:	00 
c0104d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d64:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d68:	89 04 24             	mov    %eax,(%esp)
c0104d6b:	e8 d8 fa ff ff       	call   c0104848 <page_insert>
c0104d70:	85 c0                	test   %eax,%eax
c0104d72:	74 24                	je     c0104d98 <check_pgdir+0x415>
c0104d74:	c7 44 24 0c ac 6f 10 	movl   $0xc0106fac,0xc(%esp)
c0104d7b:	c0 
c0104d7c:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104d83:	c0 
c0104d84:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104d8b:	00 
c0104d8c:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104d93:	e8 50 bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p1) == 2);
c0104d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9b:	89 04 24             	mov    %eax,(%esp)
c0104d9e:	e8 6c ef ff ff       	call   c0103d0f <page_ref>
c0104da3:	83 f8 02             	cmp    $0x2,%eax
c0104da6:	74 24                	je     c0104dcc <check_pgdir+0x449>
c0104da8:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c0104daf:	c0 
c0104db0:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104db7:	c0 
c0104db8:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104dbf:	00 
c0104dc0:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104dc7:	e8 1c bf ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dcf:	89 04 24             	mov    %eax,(%esp)
c0104dd2:	e8 38 ef ff ff       	call   c0103d0f <page_ref>
c0104dd7:	85 c0                	test   %eax,%eax
c0104dd9:	74 24                	je     c0104dff <check_pgdir+0x47c>
c0104ddb:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104de2:	c0 
c0104de3:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104dea:	c0 
c0104deb:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104df2:	00 
c0104df3:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104dfa:	e8 e9 be ff ff       	call   c0100ce8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104dff:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e0b:	00 
c0104e0c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e13:	00 
c0104e14:	89 04 24             	mov    %eax,(%esp)
c0104e17:	e8 da f7 ff ff       	call   c01045f6 <get_pte>
c0104e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e23:	75 24                	jne    c0104e49 <check_pgdir+0x4c6>
c0104e25:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0104e2c:	c0 
c0104e2d:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104e34:	c0 
c0104e35:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104e3c:	00 
c0104e3d:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104e44:	e8 9f be ff ff       	call   c0100ce8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e4c:	8b 00                	mov    (%eax),%eax
c0104e4e:	89 04 24             	mov    %eax,(%esp)
c0104e51:	e8 5f ee ff ff       	call   c0103cb5 <pte2page>
c0104e56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e59:	74 24                	je     c0104e7f <check_pgdir+0x4fc>
c0104e5b:	c7 44 24 0c ad 6e 10 	movl   $0xc0106ead,0xc(%esp)
c0104e62:	c0 
c0104e63:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104e6a:	c0 
c0104e6b:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104e72:	00 
c0104e73:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104e7a:	e8 69 be ff ff       	call   c0100ce8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e82:	8b 00                	mov    (%eax),%eax
c0104e84:	83 e0 04             	and    $0x4,%eax
c0104e87:	85 c0                	test   %eax,%eax
c0104e89:	74 24                	je     c0104eaf <check_pgdir+0x52c>
c0104e8b:	c7 44 24 0c fc 6f 10 	movl   $0xc0106ffc,0xc(%esp)
c0104e92:	c0 
c0104e93:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104e9a:	c0 
c0104e9b:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104ea2:	00 
c0104ea3:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104eaa:	e8 39 be ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104eaf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104eb4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ebb:	00 
c0104ebc:	89 04 24             	mov    %eax,(%esp)
c0104ebf:	e8 3d f9 ff ff       	call   c0104801 <page_remove>
    assert(page_ref(p1) == 1);
c0104ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ec7:	89 04 24             	mov    %eax,(%esp)
c0104eca:	e8 40 ee ff ff       	call   c0103d0f <page_ref>
c0104ecf:	83 f8 01             	cmp    $0x1,%eax
c0104ed2:	74 24                	je     c0104ef8 <check_pgdir+0x575>
c0104ed4:	c7 44 24 0c c3 6e 10 	movl   $0xc0106ec3,0xc(%esp)
c0104edb:	c0 
c0104edc:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104ee3:	c0 
c0104ee4:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104eeb:	00 
c0104eec:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104ef3:	e8 f0 bd ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104efb:	89 04 24             	mov    %eax,(%esp)
c0104efe:	e8 0c ee ff ff       	call   c0103d0f <page_ref>
c0104f03:	85 c0                	test   %eax,%eax
c0104f05:	74 24                	je     c0104f2b <check_pgdir+0x5a8>
c0104f07:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104f0e:	c0 
c0104f0f:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104f16:	c0 
c0104f17:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104f1e:	00 
c0104f1f:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104f26:	e8 bd bd ff ff       	call   c0100ce8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104f2b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f30:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f37:	00 
c0104f38:	89 04 24             	mov    %eax,(%esp)
c0104f3b:	e8 c1 f8 ff ff       	call   c0104801 <page_remove>
    assert(page_ref(p1) == 0);
c0104f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f43:	89 04 24             	mov    %eax,(%esp)
c0104f46:	e8 c4 ed ff ff       	call   c0103d0f <page_ref>
c0104f4b:	85 c0                	test   %eax,%eax
c0104f4d:	74 24                	je     c0104f73 <check_pgdir+0x5f0>
c0104f4f:	c7 44 24 0c 11 70 10 	movl   $0xc0107011,0xc(%esp)
c0104f56:	c0 
c0104f57:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104f5e:	c0 
c0104f5f:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0104f66:	00 
c0104f67:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104f6e:	e8 75 bd ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p2) == 0);
c0104f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f76:	89 04 24             	mov    %eax,(%esp)
c0104f79:	e8 91 ed ff ff       	call   c0103d0f <page_ref>
c0104f7e:	85 c0                	test   %eax,%eax
c0104f80:	74 24                	je     c0104fa6 <check_pgdir+0x623>
c0104f82:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104f89:	c0 
c0104f8a:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104f91:	c0 
c0104f92:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104f99:	00 
c0104f9a:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104fa1:	e8 42 bd ff ff       	call   c0100ce8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104fa6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fab:	8b 00                	mov    (%eax),%eax
c0104fad:	89 04 24             	mov    %eax,(%esp)
c0104fb0:	e8 40 ed ff ff       	call   c0103cf5 <pde2page>
c0104fb5:	89 04 24             	mov    %eax,(%esp)
c0104fb8:	e8 52 ed ff ff       	call   c0103d0f <page_ref>
c0104fbd:	83 f8 01             	cmp    $0x1,%eax
c0104fc0:	74 24                	je     c0104fe6 <check_pgdir+0x663>
c0104fc2:	c7 44 24 0c 24 70 10 	movl   $0xc0107024,0xc(%esp)
c0104fc9:	c0 
c0104fca:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0104fd1:	c0 
c0104fd2:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104fd9:	00 
c0104fda:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0104fe1:	e8 02 bd ff ff       	call   c0100ce8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104fe6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104feb:	8b 00                	mov    (%eax),%eax
c0104fed:	89 04 24             	mov    %eax,(%esp)
c0104ff0:	e8 00 ed ff ff       	call   c0103cf5 <pde2page>
c0104ff5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ffc:	00 
c0104ffd:	89 04 24             	mov    %eax,(%esp)
c0105000:	e8 54 ef ff ff       	call   c0103f59 <free_pages>
    boot_pgdir[0] = 0;
c0105005:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010500a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105010:	c7 04 24 4b 70 10 c0 	movl   $0xc010704b,(%esp)
c0105017:	e8 3a b3 ff ff       	call   c0100356 <cprintf>
}
c010501c:	90                   	nop
c010501d:	89 ec                	mov    %ebp,%esp
c010501f:	5d                   	pop    %ebp
c0105020:	c3                   	ret    

c0105021 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105021:	55                   	push   %ebp
c0105022:	89 e5                	mov    %esp,%ebp
c0105024:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010502e:	e9 ca 00 00 00       	jmp    c01050fd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t) KADDR(i), 0)) != NULL);
c0105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010503c:	c1 e8 0c             	shr    $0xc,%eax
c010503f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105042:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0105047:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010504a:	72 23                	jb     c010506f <check_boot_pgdir+0x4e>
c010504c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010504f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105053:	c7 44 24 08 74 6c 10 	movl   $0xc0106c74,0x8(%esp)
c010505a:	c0 
c010505b:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105062:	00 
c0105063:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010506a:	e8 79 bc ff ff       	call   c0100ce8 <__panic>
c010506f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105072:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105077:	89 c2                	mov    %eax,%edx
c0105079:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010507e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105085:	00 
c0105086:	89 54 24 04          	mov    %edx,0x4(%esp)
c010508a:	89 04 24             	mov    %eax,(%esp)
c010508d:	e8 64 f5 ff ff       	call   c01045f6 <get_pte>
c0105092:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105095:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105099:	75 24                	jne    c01050bf <check_boot_pgdir+0x9e>
c010509b:	c7 44 24 0c 68 70 10 	movl   $0xc0107068,0xc(%esp)
c01050a2:	c0 
c01050a3:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01050aa:	c0 
c01050ab:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01050b2:	00 
c01050b3:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01050ba:	e8 29 bc ff ff       	call   c0100ce8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01050bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050c2:	8b 00                	mov    (%eax),%eax
c01050c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050c9:	89 c2                	mov    %eax,%edx
c01050cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050ce:	39 c2                	cmp    %eax,%edx
c01050d0:	74 24                	je     c01050f6 <check_boot_pgdir+0xd5>
c01050d2:	c7 44 24 0c a6 70 10 	movl   $0xc01070a6,0xc(%esp)
c01050d9:	c0 
c01050da:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01050e1:	c0 
c01050e2:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01050e9:	00 
c01050ea:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01050f1:	e8 f2 bb ff ff       	call   c0100ce8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01050f6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105100:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0105105:	39 c2                	cmp    %eax,%edx
c0105107:	0f 82 26 ff ff ff    	jb     c0105033 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010510d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105112:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105117:	8b 00                	mov    (%eax),%eax
c0105119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010511e:	89 c2                	mov    %eax,%edx
c0105120:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105125:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105128:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010512f:	77 23                	ja     c0105154 <check_boot_pgdir+0x133>
c0105131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105134:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105138:	c7 44 24 08 18 6d 10 	movl   $0xc0106d18,0x8(%esp)
c010513f:	c0 
c0105140:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105147:	00 
c0105148:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010514f:	e8 94 bb ff ff       	call   c0100ce8 <__panic>
c0105154:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105157:	05 00 00 00 40       	add    $0x40000000,%eax
c010515c:	39 d0                	cmp    %edx,%eax
c010515e:	74 24                	je     c0105184 <check_boot_pgdir+0x163>
c0105160:	c7 44 24 0c bc 70 10 	movl   $0xc01070bc,0xc(%esp)
c0105167:	c0 
c0105168:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c010516f:	c0 
c0105170:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105177:	00 
c0105178:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010517f:	e8 64 bb ff ff       	call   c0100ce8 <__panic>

    assert(boot_pgdir[0] == 0);
c0105184:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105189:	8b 00                	mov    (%eax),%eax
c010518b:	85 c0                	test   %eax,%eax
c010518d:	74 24                	je     c01051b3 <check_boot_pgdir+0x192>
c010518f:	c7 44 24 0c f0 70 10 	movl   $0xc01070f0,0xc(%esp)
c0105196:	c0 
c0105197:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c010519e:	c0 
c010519f:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01051a6:	00 
c01051a7:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01051ae:	e8 35 bb ff ff       	call   c0100ce8 <__panic>

    struct Page *p;
    p = alloc_page();
c01051b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051ba:	e8 60 ed ff ff       	call   c0103f1f <alloc_pages>
c01051bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01051c2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01051c7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01051ce:	00 
c01051cf:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01051d6:	00 
c01051d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01051da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051de:	89 04 24             	mov    %eax,(%esp)
c01051e1:	e8 62 f6 ff ff       	call   c0104848 <page_insert>
c01051e6:	85 c0                	test   %eax,%eax
c01051e8:	74 24                	je     c010520e <check_boot_pgdir+0x1ed>
c01051ea:	c7 44 24 0c 04 71 10 	movl   $0xc0107104,0xc(%esp)
c01051f1:	c0 
c01051f2:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01051f9:	c0 
c01051fa:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105201:	00 
c0105202:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0105209:	e8 da ba ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 1);
c010520e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105211:	89 04 24             	mov    %eax,(%esp)
c0105214:	e8 f6 ea ff ff       	call   c0103d0f <page_ref>
c0105219:	83 f8 01             	cmp    $0x1,%eax
c010521c:	74 24                	je     c0105242 <check_boot_pgdir+0x221>
c010521e:	c7 44 24 0c 32 71 10 	movl   $0xc0107132,0xc(%esp)
c0105225:	c0 
c0105226:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c010522d:	c0 
c010522e:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0105235:	00 
c0105236:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010523d:	e8 a6 ba ff ff       	call   c0100ce8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105242:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105247:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010524e:	00 
c010524f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105256:	00 
c0105257:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010525a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010525e:	89 04 24             	mov    %eax,(%esp)
c0105261:	e8 e2 f5 ff ff       	call   c0104848 <page_insert>
c0105266:	85 c0                	test   %eax,%eax
c0105268:	74 24                	je     c010528e <check_boot_pgdir+0x26d>
c010526a:	c7 44 24 0c 44 71 10 	movl   $0xc0107144,0xc(%esp)
c0105271:	c0 
c0105272:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0105279:	c0 
c010527a:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0105281:	00 
c0105282:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0105289:	e8 5a ba ff ff       	call   c0100ce8 <__panic>
    assert(page_ref(p) == 2);
c010528e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105291:	89 04 24             	mov    %eax,(%esp)
c0105294:	e8 76 ea ff ff       	call   c0103d0f <page_ref>
c0105299:	83 f8 02             	cmp    $0x2,%eax
c010529c:	74 24                	je     c01052c2 <check_boot_pgdir+0x2a1>
c010529e:	c7 44 24 0c 7b 71 10 	movl   $0xc010717b,0xc(%esp)
c01052a5:	c0 
c01052a6:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c01052ad:	c0 
c01052ae:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c01052b5:	00 
c01052b6:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c01052bd:	e8 26 ba ff ff       	call   c0100ce8 <__panic>

    const char *str = "ucore: Hello world!!";
c01052c2:	c7 45 e8 8c 71 10 c0 	movl   $0xc010718c,-0x18(%ebp)
    strcpy((void *) 0x100, str);
c01052c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052d0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052d7:	e8 fc 09 00 00       	call   c0105cd8 <strcpy>
    assert(strcmp((void *) 0x100, (void *) (0x100 + PGSIZE)) == 0);
c01052dc:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01052e3:	00 
c01052e4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052eb:	e8 60 0a 00 00       	call   c0105d50 <strcmp>
c01052f0:	85 c0                	test   %eax,%eax
c01052f2:	74 24                	je     c0105318 <check_boot_pgdir+0x2f7>
c01052f4:	c7 44 24 0c a4 71 10 	movl   $0xc01071a4,0xc(%esp)
c01052fb:	c0 
c01052fc:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c0105303:	c0 
c0105304:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c010530b:	00 
c010530c:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c0105313:	e8 d0 b9 ff ff       	call   c0100ce8 <__panic>

    *(char *) (page2kva(p) + 0x100) = '\0';
c0105318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531b:	89 04 24             	mov    %eax,(%esp)
c010531e:	e8 3c e9 ff ff       	call   c0103c5f <page2kva>
c0105323:	05 00 01 00 00       	add    $0x100,%eax
c0105328:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *) 0x100) == 0);
c010532b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105332:	e8 47 09 00 00       	call   c0105c7e <strlen>
c0105337:	85 c0                	test   %eax,%eax
c0105339:	74 24                	je     c010535f <check_boot_pgdir+0x33e>
c010533b:	c7 44 24 0c dc 71 10 	movl   $0xc01071dc,0xc(%esp)
c0105342:	c0 
c0105343:	c7 44 24 08 7d 6d 10 	movl   $0xc0106d7d,0x8(%esp)
c010534a:	c0 
c010534b:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105352:	00 
c0105353:	c7 04 24 3c 6d 10 c0 	movl   $0xc0106d3c,(%esp)
c010535a:	e8 89 b9 ff ff       	call   c0100ce8 <__panic>

    free_page(p);
c010535f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105366:	00 
c0105367:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010536a:	89 04 24             	mov    %eax,(%esp)
c010536d:	e8 e7 eb ff ff       	call   c0103f59 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105372:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105377:	8b 00                	mov    (%eax),%eax
c0105379:	89 04 24             	mov    %eax,(%esp)
c010537c:	e8 74 e9 ff ff       	call   c0103cf5 <pde2page>
c0105381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105388:	00 
c0105389:	89 04 24             	mov    %eax,(%esp)
c010538c:	e8 c8 eb ff ff       	call   c0103f59 <free_pages>
    boot_pgdir[0] = 0;
c0105391:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010539c:	c7 04 24 00 72 10 c0 	movl   $0xc0107200,(%esp)
c01053a3:	e8 ae af ff ff       	call   c0100356 <cprintf>
}
c01053a8:	90                   	nop
c01053a9:	89 ec                	mov    %ebp,%esp
c01053ab:	5d                   	pop    %ebp
c01053ac:	c3                   	ret    

c01053ad <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01053ad:	55                   	push   %ebp
c01053ae:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01053b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b3:	83 e0 04             	and    $0x4,%eax
c01053b6:	85 c0                	test   %eax,%eax
c01053b8:	74 04                	je     c01053be <perm2str+0x11>
c01053ba:	b0 75                	mov    $0x75,%al
c01053bc:	eb 02                	jmp    c01053c0 <perm2str+0x13>
c01053be:	b0 2d                	mov    $0x2d,%al
c01053c0:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c01053c5:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01053cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cf:	83 e0 02             	and    $0x2,%eax
c01053d2:	85 c0                	test   %eax,%eax
c01053d4:	74 04                	je     c01053da <perm2str+0x2d>
c01053d6:	b0 77                	mov    $0x77,%al
c01053d8:	eb 02                	jmp    c01053dc <perm2str+0x2f>
c01053da:	b0 2d                	mov    $0x2d,%al
c01053dc:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c01053e1:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c01053e8:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c01053ed:	5d                   	pop    %ebp
c01053ee:	c3                   	ret    

c01053ef <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01053ef:	55                   	push   %ebp
c01053f0:	89 e5                	mov    %esp,%ebp
c01053f2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053fb:	72 0d                	jb     c010540a <get_pgtable_items+0x1b>
        return 0;
c01053fd:	b8 00 00 00 00       	mov    $0x0,%eax
c0105402:	e9 98 00 00 00       	jmp    c010549f <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start++;
c0105407:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010540a:	8b 45 10             	mov    0x10(%ebp),%eax
c010540d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105410:	73 18                	jae    c010542a <get_pgtable_items+0x3b>
c0105412:	8b 45 10             	mov    0x10(%ebp),%eax
c0105415:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010541c:	8b 45 14             	mov    0x14(%ebp),%eax
c010541f:	01 d0                	add    %edx,%eax
c0105421:	8b 00                	mov    (%eax),%eax
c0105423:	83 e0 01             	and    $0x1,%eax
c0105426:	85 c0                	test   %eax,%eax
c0105428:	74 dd                	je     c0105407 <get_pgtable_items+0x18>
    }
    if (start < right) {
c010542a:	8b 45 10             	mov    0x10(%ebp),%eax
c010542d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105430:	73 68                	jae    c010549a <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105432:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105436:	74 08                	je     c0105440 <get_pgtable_items+0x51>
            *left_store = start;
c0105438:	8b 45 18             	mov    0x18(%ebp),%eax
c010543b:	8b 55 10             	mov    0x10(%ebp),%edx
c010543e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c0105440:	8b 45 10             	mov    0x10(%ebp),%eax
c0105443:	8d 50 01             	lea    0x1(%eax),%edx
c0105446:	89 55 10             	mov    %edx,0x10(%ebp)
c0105449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105450:	8b 45 14             	mov    0x14(%ebp),%eax
c0105453:	01 d0                	add    %edx,%eax
c0105455:	8b 00                	mov    (%eax),%eax
c0105457:	83 e0 07             	and    $0x7,%eax
c010545a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010545d:	eb 03                	jmp    c0105462 <get_pgtable_items+0x73>
            start++;
c010545f:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105462:	8b 45 10             	mov    0x10(%ebp),%eax
c0105465:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105468:	73 1d                	jae    c0105487 <get_pgtable_items+0x98>
c010546a:	8b 45 10             	mov    0x10(%ebp),%eax
c010546d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105474:	8b 45 14             	mov    0x14(%ebp),%eax
c0105477:	01 d0                	add    %edx,%eax
c0105479:	8b 00                	mov    (%eax),%eax
c010547b:	83 e0 07             	and    $0x7,%eax
c010547e:	89 c2                	mov    %eax,%edx
c0105480:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105483:	39 c2                	cmp    %eax,%edx
c0105485:	74 d8                	je     c010545f <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105487:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010548b:	74 08                	je     c0105495 <get_pgtable_items+0xa6>
            *right_store = start;
c010548d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105490:	8b 55 10             	mov    0x10(%ebp),%edx
c0105493:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105498:	eb 05                	jmp    c010549f <get_pgtable_items+0xb0>
    }
    return 0;
c010549a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010549f:	89 ec                	mov    %ebp,%esp
c01054a1:	5d                   	pop    %ebp
c01054a2:	c3                   	ret    

c01054a3 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01054a3:	55                   	push   %ebp
c01054a4:	89 e5                	mov    %esp,%ebp
c01054a6:	57                   	push   %edi
c01054a7:	56                   	push   %esi
c01054a8:	53                   	push   %ebx
c01054a9:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01054ac:	c7 04 24 20 72 10 c0 	movl   $0xc0107220,(%esp)
c01054b3:	e8 9e ae ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c01054b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01054bf:	e9 f2 00 00 00       	jmp    c01055b6 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054c7:	89 04 24             	mov    %eax,(%esp)
c01054ca:	e8 de fe ff ff       	call   c01053ad <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01054cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01054d5:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054d7:	89 d6                	mov    %edx,%esi
c01054d9:	c1 e6 16             	shl    $0x16,%esi
c01054dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054df:	89 d3                	mov    %edx,%ebx
c01054e1:	c1 e3 16             	shl    $0x16,%ebx
c01054e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054e7:	89 d1                	mov    %edx,%ecx
c01054e9:	c1 e1 16             	shl    $0x16,%ecx
c01054ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054ef:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01054f2:	29 fa                	sub    %edi,%edx
c01054f4:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054f8:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105500:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105504:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105508:	c7 04 24 51 72 10 c0 	movl   $0xc0107251,(%esp)
c010550f:	e8 42 ae ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0105514:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105517:	c1 e0 0a             	shl    $0xa,%eax
c010551a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010551d:	eb 50                	jmp    c010556f <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010551f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105522:	89 04 24             	mov    %eax,(%esp)
c0105525:	e8 83 fe ff ff       	call   c01053ad <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010552a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010552d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105530:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105532:	89 d6                	mov    %edx,%esi
c0105534:	c1 e6 0c             	shl    $0xc,%esi
c0105537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010553a:	89 d3                	mov    %edx,%ebx
c010553c:	c1 e3 0c             	shl    $0xc,%ebx
c010553f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105542:	89 d1                	mov    %edx,%ecx
c0105544:	c1 e1 0c             	shl    $0xc,%ecx
c0105547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010554a:	8b 7d d8             	mov    -0x28(%ebp),%edi
c010554d:	29 fa                	sub    %edi,%edx
c010554f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105553:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105557:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010555b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010555f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105563:	c7 04 24 70 72 10 c0 	movl   $0xc0107270,(%esp)
c010556a:	e8 e7 ad ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010556f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105577:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010557a:	89 d3                	mov    %edx,%ebx
c010557c:	c1 e3 0a             	shl    $0xa,%ebx
c010557f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105582:	89 d1                	mov    %edx,%ecx
c0105584:	c1 e1 0a             	shl    $0xa,%ecx
c0105587:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010558a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010558e:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105591:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105595:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105599:	89 44 24 08          	mov    %eax,0x8(%esp)
c010559d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01055a1:	89 0c 24             	mov    %ecx,(%esp)
c01055a4:	e8 46 fe ff ff       	call   c01053ef <get_pgtable_items>
c01055a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055b0:	0f 85 69 ff ff ff    	jne    c010551f <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01055b6:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01055bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055be:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01055c1:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055c5:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01055c8:	89 54 24 10          	mov    %edx,0x10(%esp)
c01055cc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01055d0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055d4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01055db:	00 
c01055dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01055e3:	e8 07 fe ff ff       	call   c01053ef <get_pgtable_items>
c01055e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055ef:	0f 85 cf fe ff ff    	jne    c01054c4 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055f5:	c7 04 24 94 72 10 c0 	movl   $0xc0107294,(%esp)
c01055fc:	e8 55 ad ff ff       	call   c0100356 <cprintf>
}
c0105601:	90                   	nop
c0105602:	83 c4 4c             	add    $0x4c,%esp
c0105605:	5b                   	pop    %ebx
c0105606:	5e                   	pop    %esi
c0105607:	5f                   	pop    %edi
c0105608:	5d                   	pop    %ebp
c0105609:	c3                   	ret    

c010560a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010560a:	55                   	push   %ebp
c010560b:	89 e5                	mov    %esp,%ebp
c010560d:	83 ec 58             	sub    $0x58,%esp
c0105610:	8b 45 10             	mov    0x10(%ebp),%eax
c0105613:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105616:	8b 45 14             	mov    0x14(%ebp),%eax
c0105619:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010561c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010561f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105622:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105625:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105628:	8b 45 18             	mov    0x18(%ebp),%eax
c010562b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010562e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105631:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105634:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105637:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010563a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010563d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105644:	74 1c                	je     c0105662 <printnum+0x58>
c0105646:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105649:	ba 00 00 00 00       	mov    $0x0,%edx
c010564e:	f7 75 e4             	divl   -0x1c(%ebp)
c0105651:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105657:	ba 00 00 00 00       	mov    $0x0,%edx
c010565c:	f7 75 e4             	divl   -0x1c(%ebp)
c010565f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105662:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105665:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105668:	f7 75 e4             	divl   -0x1c(%ebp)
c010566b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010566e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105671:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105674:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105677:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010567a:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010567d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105680:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105683:	8b 45 18             	mov    0x18(%ebp),%eax
c0105686:	ba 00 00 00 00       	mov    $0x0,%edx
c010568b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010568e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105691:	19 d1                	sbb    %edx,%ecx
c0105693:	72 4c                	jb     c01056e1 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105695:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105698:	8d 50 ff             	lea    -0x1(%eax),%edx
c010569b:	8b 45 20             	mov    0x20(%ebp),%eax
c010569e:	89 44 24 18          	mov    %eax,0x18(%esp)
c01056a2:	89 54 24 14          	mov    %edx,0x14(%esp)
c01056a6:	8b 45 18             	mov    0x18(%ebp),%eax
c01056a9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01056ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01056b3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01056bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c5:	89 04 24             	mov    %eax,(%esp)
c01056c8:	e8 3d ff ff ff       	call   c010560a <printnum>
c01056cd:	eb 1b                	jmp    c01056ea <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d6:	8b 45 20             	mov    0x20(%ebp),%eax
c01056d9:	89 04 24             	mov    %eax,(%esp)
c01056dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056df:	ff d0                	call   *%eax
        while (-- width > 0)
c01056e1:	ff 4d 1c             	decl   0x1c(%ebp)
c01056e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056e8:	7f e5                	jg     c01056cf <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056ed:	05 48 73 10 c0       	add    $0xc0107348,%eax
c01056f2:	0f b6 00             	movzbl (%eax),%eax
c01056f5:	0f be c0             	movsbl %al,%eax
c01056f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056ff:	89 04 24             	mov    %eax,(%esp)
c0105702:	8b 45 08             	mov    0x8(%ebp),%eax
c0105705:	ff d0                	call   *%eax
}
c0105707:	90                   	nop
c0105708:	89 ec                	mov    %ebp,%esp
c010570a:	5d                   	pop    %ebp
c010570b:	c3                   	ret    

c010570c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010570c:	55                   	push   %ebp
c010570d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010570f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105713:	7e 14                	jle    c0105729 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105715:	8b 45 08             	mov    0x8(%ebp),%eax
c0105718:	8b 00                	mov    (%eax),%eax
c010571a:	8d 48 08             	lea    0x8(%eax),%ecx
c010571d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105720:	89 0a                	mov    %ecx,(%edx)
c0105722:	8b 50 04             	mov    0x4(%eax),%edx
c0105725:	8b 00                	mov    (%eax),%eax
c0105727:	eb 30                	jmp    c0105759 <getuint+0x4d>
    }
    else if (lflag) {
c0105729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010572d:	74 16                	je     c0105745 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010572f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105732:	8b 00                	mov    (%eax),%eax
c0105734:	8d 48 04             	lea    0x4(%eax),%ecx
c0105737:	8b 55 08             	mov    0x8(%ebp),%edx
c010573a:	89 0a                	mov    %ecx,(%edx)
c010573c:	8b 00                	mov    (%eax),%eax
c010573e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105743:	eb 14                	jmp    c0105759 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105745:	8b 45 08             	mov    0x8(%ebp),%eax
c0105748:	8b 00                	mov    (%eax),%eax
c010574a:	8d 48 04             	lea    0x4(%eax),%ecx
c010574d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105750:	89 0a                	mov    %ecx,(%edx)
c0105752:	8b 00                	mov    (%eax),%eax
c0105754:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105759:	5d                   	pop    %ebp
c010575a:	c3                   	ret    

c010575b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010575b:	55                   	push   %ebp
c010575c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010575e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105762:	7e 14                	jle    c0105778 <getint+0x1d>
        return va_arg(*ap, long long);
c0105764:	8b 45 08             	mov    0x8(%ebp),%eax
c0105767:	8b 00                	mov    (%eax),%eax
c0105769:	8d 48 08             	lea    0x8(%eax),%ecx
c010576c:	8b 55 08             	mov    0x8(%ebp),%edx
c010576f:	89 0a                	mov    %ecx,(%edx)
c0105771:	8b 50 04             	mov    0x4(%eax),%edx
c0105774:	8b 00                	mov    (%eax),%eax
c0105776:	eb 28                	jmp    c01057a0 <getint+0x45>
    }
    else if (lflag) {
c0105778:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010577c:	74 12                	je     c0105790 <getint+0x35>
        return va_arg(*ap, long);
c010577e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105781:	8b 00                	mov    (%eax),%eax
c0105783:	8d 48 04             	lea    0x4(%eax),%ecx
c0105786:	8b 55 08             	mov    0x8(%ebp),%edx
c0105789:	89 0a                	mov    %ecx,(%edx)
c010578b:	8b 00                	mov    (%eax),%eax
c010578d:	99                   	cltd   
c010578e:	eb 10                	jmp    c01057a0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	8b 00                	mov    (%eax),%eax
c0105795:	8d 48 04             	lea    0x4(%eax),%ecx
c0105798:	8b 55 08             	mov    0x8(%ebp),%edx
c010579b:	89 0a                	mov    %ecx,(%edx)
c010579d:	8b 00                	mov    (%eax),%eax
c010579f:	99                   	cltd   
    }
}
c01057a0:	5d                   	pop    %ebp
c01057a1:	c3                   	ret    

c01057a2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057a2:	55                   	push   %ebp
c01057a3:	89 e5                	mov    %esp,%ebp
c01057a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01057a8:	8d 45 14             	lea    0x14(%ebp),%eax
c01057ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01057b8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c6:	89 04 24             	mov    %eax,(%esp)
c01057c9:	e8 05 00 00 00       	call   c01057d3 <vprintfmt>
    va_end(ap);
}
c01057ce:	90                   	nop
c01057cf:	89 ec                	mov    %ebp,%esp
c01057d1:	5d                   	pop    %ebp
c01057d2:	c3                   	ret    

c01057d3 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057d3:	55                   	push   %ebp
c01057d4:	89 e5                	mov    %esp,%ebp
c01057d6:	56                   	push   %esi
c01057d7:	53                   	push   %ebx
c01057d8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057db:	eb 17                	jmp    c01057f4 <vprintfmt+0x21>
            if (ch == '\0') {
c01057dd:	85 db                	test   %ebx,%ebx
c01057df:	0f 84 bf 03 00 00    	je     c0105ba4 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01057e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ec:	89 1c 24             	mov    %ebx,(%esp)
c01057ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f7:	8d 50 01             	lea    0x1(%eax),%edx
c01057fa:	89 55 10             	mov    %edx,0x10(%ebp)
c01057fd:	0f b6 00             	movzbl (%eax),%eax
c0105800:	0f b6 d8             	movzbl %al,%ebx
c0105803:	83 fb 25             	cmp    $0x25,%ebx
c0105806:	75 d5                	jne    c01057dd <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105808:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010580c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105816:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105819:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105820:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105823:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105826:	8b 45 10             	mov    0x10(%ebp),%eax
c0105829:	8d 50 01             	lea    0x1(%eax),%edx
c010582c:	89 55 10             	mov    %edx,0x10(%ebp)
c010582f:	0f b6 00             	movzbl (%eax),%eax
c0105832:	0f b6 d8             	movzbl %al,%ebx
c0105835:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105838:	83 f8 55             	cmp    $0x55,%eax
c010583b:	0f 87 37 03 00 00    	ja     c0105b78 <vprintfmt+0x3a5>
c0105841:	8b 04 85 6c 73 10 c0 	mov    -0x3fef8c94(,%eax,4),%eax
c0105848:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010584a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010584e:	eb d6                	jmp    c0105826 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105850:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105854:	eb d0                	jmp    c0105826 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105856:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010585d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105860:	89 d0                	mov    %edx,%eax
c0105862:	c1 e0 02             	shl    $0x2,%eax
c0105865:	01 d0                	add    %edx,%eax
c0105867:	01 c0                	add    %eax,%eax
c0105869:	01 d8                	add    %ebx,%eax
c010586b:	83 e8 30             	sub    $0x30,%eax
c010586e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105871:	8b 45 10             	mov    0x10(%ebp),%eax
c0105874:	0f b6 00             	movzbl (%eax),%eax
c0105877:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010587a:	83 fb 2f             	cmp    $0x2f,%ebx
c010587d:	7e 38                	jle    c01058b7 <vprintfmt+0xe4>
c010587f:	83 fb 39             	cmp    $0x39,%ebx
c0105882:	7f 33                	jg     c01058b7 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105884:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105887:	eb d4                	jmp    c010585d <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105889:	8b 45 14             	mov    0x14(%ebp),%eax
c010588c:	8d 50 04             	lea    0x4(%eax),%edx
c010588f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105892:	8b 00                	mov    (%eax),%eax
c0105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105897:	eb 1f                	jmp    c01058b8 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105899:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010589d:	79 87                	jns    c0105826 <vprintfmt+0x53>
                width = 0;
c010589f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058a6:	e9 7b ff ff ff       	jmp    c0105826 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01058ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01058b2:	e9 6f ff ff ff       	jmp    c0105826 <vprintfmt+0x53>
            goto process_precision;
c01058b7:	90                   	nop

        process_precision:
            if (width < 0)
c01058b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058bc:	0f 89 64 ff ff ff    	jns    c0105826 <vprintfmt+0x53>
                width = precision, precision = -1;
c01058c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058cf:	e9 52 ff ff ff       	jmp    c0105826 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058d4:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01058d7:	e9 4a ff ff ff       	jmp    c0105826 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058dc:	8b 45 14             	mov    0x14(%ebp),%eax
c01058df:	8d 50 04             	lea    0x4(%eax),%edx
c01058e2:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e5:	8b 00                	mov    (%eax),%eax
c01058e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058ee:	89 04 24             	mov    %eax,(%esp)
c01058f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f4:	ff d0                	call   *%eax
            break;
c01058f6:	e9 a4 02 00 00       	jmp    c0105b9f <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01058fe:	8d 50 04             	lea    0x4(%eax),%edx
c0105901:	89 55 14             	mov    %edx,0x14(%ebp)
c0105904:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105906:	85 db                	test   %ebx,%ebx
c0105908:	79 02                	jns    c010590c <vprintfmt+0x139>
                err = -err;
c010590a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010590c:	83 fb 06             	cmp    $0x6,%ebx
c010590f:	7f 0b                	jg     c010591c <vprintfmt+0x149>
c0105911:	8b 34 9d 2c 73 10 c0 	mov    -0x3fef8cd4(,%ebx,4),%esi
c0105918:	85 f6                	test   %esi,%esi
c010591a:	75 23                	jne    c010593f <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c010591c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105920:	c7 44 24 08 59 73 10 	movl   $0xc0107359,0x8(%esp)
c0105927:	c0 
c0105928:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105932:	89 04 24             	mov    %eax,(%esp)
c0105935:	e8 68 fe ff ff       	call   c01057a2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010593a:	e9 60 02 00 00       	jmp    c0105b9f <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c010593f:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105943:	c7 44 24 08 62 73 10 	movl   $0xc0107362,0x8(%esp)
c010594a:	c0 
c010594b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105952:	8b 45 08             	mov    0x8(%ebp),%eax
c0105955:	89 04 24             	mov    %eax,(%esp)
c0105958:	e8 45 fe ff ff       	call   c01057a2 <printfmt>
            break;
c010595d:	e9 3d 02 00 00       	jmp    c0105b9f <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105962:	8b 45 14             	mov    0x14(%ebp),%eax
c0105965:	8d 50 04             	lea    0x4(%eax),%edx
c0105968:	89 55 14             	mov    %edx,0x14(%ebp)
c010596b:	8b 30                	mov    (%eax),%esi
c010596d:	85 f6                	test   %esi,%esi
c010596f:	75 05                	jne    c0105976 <vprintfmt+0x1a3>
                p = "(null)";
c0105971:	be 65 73 10 c0       	mov    $0xc0107365,%esi
            }
            if (width > 0 && padc != '-') {
c0105976:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010597a:	7e 76                	jle    c01059f2 <vprintfmt+0x21f>
c010597c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105980:	74 70                	je     c01059f2 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105985:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105989:	89 34 24             	mov    %esi,(%esp)
c010598c:	e8 16 03 00 00       	call   c0105ca7 <strnlen>
c0105991:	89 c2                	mov    %eax,%edx
c0105993:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105996:	29 d0                	sub    %edx,%eax
c0105998:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010599b:	eb 16                	jmp    c01059b3 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010599d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01059a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059a8:	89 04 24             	mov    %eax,(%esp)
c01059ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ae:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01059b0:	ff 4d e8             	decl   -0x18(%ebp)
c01059b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059b7:	7f e4                	jg     c010599d <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059b9:	eb 37                	jmp    c01059f2 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c01059bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059bf:	74 1f                	je     c01059e0 <vprintfmt+0x20d>
c01059c1:	83 fb 1f             	cmp    $0x1f,%ebx
c01059c4:	7e 05                	jle    c01059cb <vprintfmt+0x1f8>
c01059c6:	83 fb 7e             	cmp    $0x7e,%ebx
c01059c9:	7e 15                	jle    c01059e0 <vprintfmt+0x20d>
                    putch('?', putdat);
c01059cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01059d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059dc:	ff d0                	call   *%eax
c01059de:	eb 0f                	jmp    c01059ef <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e7:	89 1c 24             	mov    %ebx,(%esp)
c01059ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ed:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059ef:	ff 4d e8             	decl   -0x18(%ebp)
c01059f2:	89 f0                	mov    %esi,%eax
c01059f4:	8d 70 01             	lea    0x1(%eax),%esi
c01059f7:	0f b6 00             	movzbl (%eax),%eax
c01059fa:	0f be d8             	movsbl %al,%ebx
c01059fd:	85 db                	test   %ebx,%ebx
c01059ff:	74 27                	je     c0105a28 <vprintfmt+0x255>
c0105a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a05:	78 b4                	js     c01059bb <vprintfmt+0x1e8>
c0105a07:	ff 4d e4             	decl   -0x1c(%ebp)
c0105a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a0e:	79 ab                	jns    c01059bb <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105a10:	eb 16                	jmp    c0105a28 <vprintfmt+0x255>
                putch(' ', putdat);
c0105a12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a19:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a23:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105a25:	ff 4d e8             	decl   -0x18(%ebp)
c0105a28:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a2c:	7f e4                	jg     c0105a12 <vprintfmt+0x23f>
            }
            break;
c0105a2e:	e9 6c 01 00 00       	jmp    c0105b9f <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a3d:	89 04 24             	mov    %eax,(%esp)
c0105a40:	e8 16 fd ff ff       	call   c010575b <getint>
c0105a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a48:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a51:	85 d2                	test   %edx,%edx
c0105a53:	79 26                	jns    c0105a7b <vprintfmt+0x2a8>
                putch('-', putdat);
c0105a55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a5c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a66:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a6e:	f7 d8                	neg    %eax
c0105a70:	83 d2 00             	adc    $0x0,%edx
c0105a73:	f7 da                	neg    %edx
c0105a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a78:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a7b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a82:	e9 a8 00 00 00       	jmp    c0105b2f <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a8e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a91:	89 04 24             	mov    %eax,(%esp)
c0105a94:	e8 73 fc ff ff       	call   c010570c <getuint>
c0105a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a9f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105aa6:	e9 84 00 00 00       	jmp    c0105b2f <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab2:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ab5:	89 04 24             	mov    %eax,(%esp)
c0105ab8:	e8 4f fc ff ff       	call   c010570c <getuint>
c0105abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105ac3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105aca:	eb 63                	jmp    c0105b2f <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105acc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ad3:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0105add:	ff d0                	call   *%eax
            putch('x', putdat);
c0105adf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105af2:	8b 45 14             	mov    0x14(%ebp),%eax
c0105af5:	8d 50 04             	lea    0x4(%eax),%edx
c0105af8:	89 55 14             	mov    %edx,0x14(%ebp)
c0105afb:	8b 00                	mov    (%eax),%eax
c0105afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105b0e:	eb 1f                	jmp    c0105b2f <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b17:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b1a:	89 04 24             	mov    %eax,(%esp)
c0105b1d:	e8 ea fb ff ff       	call   c010570c <getuint>
c0105b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b25:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b36:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b3d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b41:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b4b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b4f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5d:	89 04 24             	mov    %eax,(%esp)
c0105b60:	e8 a5 fa ff ff       	call   c010560a <printnum>
            break;
c0105b65:	eb 38                	jmp    c0105b9f <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b6e:	89 1c 24             	mov    %ebx,(%esp)
c0105b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b74:	ff d0                	call   *%eax
            break;
c0105b76:	eb 27                	jmp    c0105b9f <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b7f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b89:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b8b:	ff 4d 10             	decl   0x10(%ebp)
c0105b8e:	eb 03                	jmp    c0105b93 <vprintfmt+0x3c0>
c0105b90:	ff 4d 10             	decl   0x10(%ebp)
c0105b93:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b96:	48                   	dec    %eax
c0105b97:	0f b6 00             	movzbl (%eax),%eax
c0105b9a:	3c 25                	cmp    $0x25,%al
c0105b9c:	75 f2                	jne    c0105b90 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105b9e:	90                   	nop
    while (1) {
c0105b9f:	e9 37 fc ff ff       	jmp    c01057db <vprintfmt+0x8>
                return;
c0105ba4:	90                   	nop
        }
    }
}
c0105ba5:	83 c4 40             	add    $0x40,%esp
c0105ba8:	5b                   	pop    %ebx
c0105ba9:	5e                   	pop    %esi
c0105baa:	5d                   	pop    %ebp
c0105bab:	c3                   	ret    

c0105bac <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105bac:	55                   	push   %ebp
c0105bad:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105baf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb2:	8b 40 08             	mov    0x8(%eax),%eax
c0105bb5:	8d 50 01             	lea    0x1(%eax),%edx
c0105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bbb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc1:	8b 10                	mov    (%eax),%edx
c0105bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc6:	8b 40 04             	mov    0x4(%eax),%eax
c0105bc9:	39 c2                	cmp    %eax,%edx
c0105bcb:	73 12                	jae    c0105bdf <sprintputch+0x33>
        *b->buf ++ = ch;
c0105bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd0:	8b 00                	mov    (%eax),%eax
c0105bd2:	8d 48 01             	lea    0x1(%eax),%ecx
c0105bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105bd8:	89 0a                	mov    %ecx,(%edx)
c0105bda:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bdd:	88 10                	mov    %dl,(%eax)
    }
}
c0105bdf:	90                   	nop
c0105be0:	5d                   	pop    %ebp
c0105be1:	c3                   	ret    

c0105be2 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105be2:	55                   	push   %ebp
c0105be3:	89 e5                	mov    %esp,%ebp
c0105be5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105be8:	8d 45 14             	lea    0x14(%ebp),%eax
c0105beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bf1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bf8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c06:	89 04 24             	mov    %eax,(%esp)
c0105c09:	e8 0a 00 00 00       	call   c0105c18 <vsnprintf>
c0105c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c14:	89 ec                	mov    %ebp,%esp
c0105c16:	5d                   	pop    %ebp
c0105c17:	c3                   	ret    

c0105c18 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105c18:	55                   	push   %ebp
c0105c19:	89 e5                	mov    %esp,%ebp
c0105c1b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c27:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2d:	01 d0                	add    %edx,%eax
c0105c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c3d:	74 0a                	je     c0105c49 <vsnprintf+0x31>
c0105c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c45:	39 c2                	cmp    %eax,%edx
c0105c47:	76 07                	jbe    c0105c50 <vsnprintf+0x38>
        return -E_INVAL;
c0105c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c4e:	eb 2a                	jmp    c0105c7a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c50:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c65:	c7 04 24 ac 5b 10 c0 	movl   $0xc0105bac,(%esp)
c0105c6c:	e8 62 fb ff ff       	call   c01057d3 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c74:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c7a:	89 ec                	mov    %ebp,%esp
c0105c7c:	5d                   	pop    %ebp
c0105c7d:	c3                   	ret    

c0105c7e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c7e:	55                   	push   %ebp
c0105c7f:	89 e5                	mov    %esp,%ebp
c0105c81:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c8b:	eb 03                	jmp    c0105c90 <strlen+0x12>
        cnt ++;
c0105c8d:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c93:	8d 50 01             	lea    0x1(%eax),%edx
c0105c96:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c99:	0f b6 00             	movzbl (%eax),%eax
c0105c9c:	84 c0                	test   %al,%al
c0105c9e:	75 ed                	jne    c0105c8d <strlen+0xf>
    }
    return cnt;
c0105ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ca3:	89 ec                	mov    %ebp,%esp
c0105ca5:	5d                   	pop    %ebp
c0105ca6:	c3                   	ret    

c0105ca7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ca7:	55                   	push   %ebp
c0105ca8:	89 e5                	mov    %esp,%ebp
c0105caa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105cb4:	eb 03                	jmp    c0105cb9 <strnlen+0x12>
        cnt ++;
c0105cb6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cbc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cbf:	73 10                	jae    c0105cd1 <strnlen+0x2a>
c0105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc4:	8d 50 01             	lea    0x1(%eax),%edx
c0105cc7:	89 55 08             	mov    %edx,0x8(%ebp)
c0105cca:	0f b6 00             	movzbl (%eax),%eax
c0105ccd:	84 c0                	test   %al,%al
c0105ccf:	75 e5                	jne    c0105cb6 <strnlen+0xf>
    }
    return cnt;
c0105cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105cd4:	89 ec                	mov    %ebp,%esp
c0105cd6:	5d                   	pop    %ebp
c0105cd7:	c3                   	ret    

c0105cd8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105cd8:	55                   	push   %ebp
c0105cd9:	89 e5                	mov    %esp,%ebp
c0105cdb:	57                   	push   %edi
c0105cdc:	56                   	push   %esi
c0105cdd:	83 ec 20             	sub    $0x20,%esp
c0105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105cec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf2:	89 d1                	mov    %edx,%ecx
c0105cf4:	89 c2                	mov    %eax,%edx
c0105cf6:	89 ce                	mov    %ecx,%esi
c0105cf8:	89 d7                	mov    %edx,%edi
c0105cfa:	ac                   	lods   %ds:(%esi),%al
c0105cfb:	aa                   	stos   %al,%es:(%edi)
c0105cfc:	84 c0                	test   %al,%al
c0105cfe:	75 fa                	jne    c0105cfa <strcpy+0x22>
c0105d00:	89 fa                	mov    %edi,%edx
c0105d02:	89 f1                	mov    %esi,%ecx
c0105d04:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d07:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105d10:	83 c4 20             	add    $0x20,%esp
c0105d13:	5e                   	pop    %esi
c0105d14:	5f                   	pop    %edi
c0105d15:	5d                   	pop    %ebp
c0105d16:	c3                   	ret    

c0105d17 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105d17:	55                   	push   %ebp
c0105d18:	89 e5                	mov    %esp,%ebp
c0105d1a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d20:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105d23:	eb 1e                	jmp    c0105d43 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105d25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d28:	0f b6 10             	movzbl (%eax),%edx
c0105d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d2e:	88 10                	mov    %dl,(%eax)
c0105d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d33:	0f b6 00             	movzbl (%eax),%eax
c0105d36:	84 c0                	test   %al,%al
c0105d38:	74 03                	je     c0105d3d <strncpy+0x26>
            src ++;
c0105d3a:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105d3d:	ff 45 fc             	incl   -0x4(%ebp)
c0105d40:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d47:	75 dc                	jne    c0105d25 <strncpy+0xe>
    }
    return dst;
c0105d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d4c:	89 ec                	mov    %ebp,%esp
c0105d4e:	5d                   	pop    %ebp
c0105d4f:	c3                   	ret    

c0105d50 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d50:	55                   	push   %ebp
c0105d51:	89 e5                	mov    %esp,%ebp
c0105d53:	57                   	push   %edi
c0105d54:	56                   	push   %esi
c0105d55:	83 ec 20             	sub    $0x20,%esp
c0105d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d6a:	89 d1                	mov    %edx,%ecx
c0105d6c:	89 c2                	mov    %eax,%edx
c0105d6e:	89 ce                	mov    %ecx,%esi
c0105d70:	89 d7                	mov    %edx,%edi
c0105d72:	ac                   	lods   %ds:(%esi),%al
c0105d73:	ae                   	scas   %es:(%edi),%al
c0105d74:	75 08                	jne    c0105d7e <strcmp+0x2e>
c0105d76:	84 c0                	test   %al,%al
c0105d78:	75 f8                	jne    c0105d72 <strcmp+0x22>
c0105d7a:	31 c0                	xor    %eax,%eax
c0105d7c:	eb 04                	jmp    c0105d82 <strcmp+0x32>
c0105d7e:	19 c0                	sbb    %eax,%eax
c0105d80:	0c 01                	or     $0x1,%al
c0105d82:	89 fa                	mov    %edi,%edx
c0105d84:	89 f1                	mov    %esi,%ecx
c0105d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d89:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d92:	83 c4 20             	add    $0x20,%esp
c0105d95:	5e                   	pop    %esi
c0105d96:	5f                   	pop    %edi
c0105d97:	5d                   	pop    %ebp
c0105d98:	c3                   	ret    

c0105d99 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d99:	55                   	push   %ebp
c0105d9a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d9c:	eb 09                	jmp    c0105da7 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105d9e:	ff 4d 10             	decl   0x10(%ebp)
c0105da1:	ff 45 08             	incl   0x8(%ebp)
c0105da4:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dab:	74 1a                	je     c0105dc7 <strncmp+0x2e>
c0105dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db0:	0f b6 00             	movzbl (%eax),%eax
c0105db3:	84 c0                	test   %al,%al
c0105db5:	74 10                	je     c0105dc7 <strncmp+0x2e>
c0105db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dba:	0f b6 10             	movzbl (%eax),%edx
c0105dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc0:	0f b6 00             	movzbl (%eax),%eax
c0105dc3:	38 c2                	cmp    %al,%dl
c0105dc5:	74 d7                	je     c0105d9e <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dcb:	74 18                	je     c0105de5 <strncmp+0x4c>
c0105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd0:	0f b6 00             	movzbl (%eax),%eax
c0105dd3:	0f b6 d0             	movzbl %al,%edx
c0105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd9:	0f b6 00             	movzbl (%eax),%eax
c0105ddc:	0f b6 c8             	movzbl %al,%ecx
c0105ddf:	89 d0                	mov    %edx,%eax
c0105de1:	29 c8                	sub    %ecx,%eax
c0105de3:	eb 05                	jmp    c0105dea <strncmp+0x51>
c0105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dea:	5d                   	pop    %ebp
c0105deb:	c3                   	ret    

c0105dec <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105dec:	55                   	push   %ebp
c0105ded:	89 e5                	mov    %esp,%ebp
c0105def:	83 ec 04             	sub    $0x4,%esp
c0105df2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105df8:	eb 13                	jmp    c0105e0d <strchr+0x21>
        if (*s == c) {
c0105dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfd:	0f b6 00             	movzbl (%eax),%eax
c0105e00:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105e03:	75 05                	jne    c0105e0a <strchr+0x1e>
            return (char *)s;
c0105e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e08:	eb 12                	jmp    c0105e1c <strchr+0x30>
        }
        s ++;
c0105e0a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e10:	0f b6 00             	movzbl (%eax),%eax
c0105e13:	84 c0                	test   %al,%al
c0105e15:	75 e3                	jne    c0105dfa <strchr+0xe>
    }
    return NULL;
c0105e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e1c:	89 ec                	mov    %ebp,%esp
c0105e1e:	5d                   	pop    %ebp
c0105e1f:	c3                   	ret    

c0105e20 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105e20:	55                   	push   %ebp
c0105e21:	89 e5                	mov    %esp,%ebp
c0105e23:	83 ec 04             	sub    $0x4,%esp
c0105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e29:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e2c:	eb 0e                	jmp    c0105e3c <strfind+0x1c>
        if (*s == c) {
c0105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e31:	0f b6 00             	movzbl (%eax),%eax
c0105e34:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105e37:	74 0f                	je     c0105e48 <strfind+0x28>
            break;
        }
        s ++;
c0105e39:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3f:	0f b6 00             	movzbl (%eax),%eax
c0105e42:	84 c0                	test   %al,%al
c0105e44:	75 e8                	jne    c0105e2e <strfind+0xe>
c0105e46:	eb 01                	jmp    c0105e49 <strfind+0x29>
            break;
c0105e48:	90                   	nop
    }
    return (char *)s;
c0105e49:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e4c:	89 ec                	mov    %ebp,%esp
c0105e4e:	5d                   	pop    %ebp
c0105e4f:	c3                   	ret    

c0105e50 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e50:	55                   	push   %ebp
c0105e51:	89 e5                	mov    %esp,%ebp
c0105e53:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e64:	eb 03                	jmp    c0105e69 <strtol+0x19>
        s ++;
c0105e66:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e6c:	0f b6 00             	movzbl (%eax),%eax
c0105e6f:	3c 20                	cmp    $0x20,%al
c0105e71:	74 f3                	je     c0105e66 <strtol+0x16>
c0105e73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e76:	0f b6 00             	movzbl (%eax),%eax
c0105e79:	3c 09                	cmp    $0x9,%al
c0105e7b:	74 e9                	je     c0105e66 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e80:	0f b6 00             	movzbl (%eax),%eax
c0105e83:	3c 2b                	cmp    $0x2b,%al
c0105e85:	75 05                	jne    c0105e8c <strtol+0x3c>
        s ++;
c0105e87:	ff 45 08             	incl   0x8(%ebp)
c0105e8a:	eb 14                	jmp    c0105ea0 <strtol+0x50>
    }
    else if (*s == '-') {
c0105e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8f:	0f b6 00             	movzbl (%eax),%eax
c0105e92:	3c 2d                	cmp    $0x2d,%al
c0105e94:	75 0a                	jne    c0105ea0 <strtol+0x50>
        s ++, neg = 1;
c0105e96:	ff 45 08             	incl   0x8(%ebp)
c0105e99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ea4:	74 06                	je     c0105eac <strtol+0x5c>
c0105ea6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105eaa:	75 22                	jne    c0105ece <strtol+0x7e>
c0105eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eaf:	0f b6 00             	movzbl (%eax),%eax
c0105eb2:	3c 30                	cmp    $0x30,%al
c0105eb4:	75 18                	jne    c0105ece <strtol+0x7e>
c0105eb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb9:	40                   	inc    %eax
c0105eba:	0f b6 00             	movzbl (%eax),%eax
c0105ebd:	3c 78                	cmp    $0x78,%al
c0105ebf:	75 0d                	jne    c0105ece <strtol+0x7e>
        s += 2, base = 16;
c0105ec1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105ec5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105ecc:	eb 29                	jmp    c0105ef7 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ed2:	75 16                	jne    c0105eea <strtol+0x9a>
c0105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed7:	0f b6 00             	movzbl (%eax),%eax
c0105eda:	3c 30                	cmp    $0x30,%al
c0105edc:	75 0c                	jne    c0105eea <strtol+0x9a>
        s ++, base = 8;
c0105ede:	ff 45 08             	incl   0x8(%ebp)
c0105ee1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105ee8:	eb 0d                	jmp    c0105ef7 <strtol+0xa7>
    }
    else if (base == 0) {
c0105eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105eee:	75 07                	jne    c0105ef7 <strtol+0xa7>
        base = 10;
c0105ef0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105ef7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efa:	0f b6 00             	movzbl (%eax),%eax
c0105efd:	3c 2f                	cmp    $0x2f,%al
c0105eff:	7e 1b                	jle    c0105f1c <strtol+0xcc>
c0105f01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f04:	0f b6 00             	movzbl (%eax),%eax
c0105f07:	3c 39                	cmp    $0x39,%al
c0105f09:	7f 11                	jg     c0105f1c <strtol+0xcc>
            dig = *s - '0';
c0105f0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0e:	0f b6 00             	movzbl (%eax),%eax
c0105f11:	0f be c0             	movsbl %al,%eax
c0105f14:	83 e8 30             	sub    $0x30,%eax
c0105f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f1a:	eb 48                	jmp    c0105f64 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f1f:	0f b6 00             	movzbl (%eax),%eax
c0105f22:	3c 60                	cmp    $0x60,%al
c0105f24:	7e 1b                	jle    c0105f41 <strtol+0xf1>
c0105f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f29:	0f b6 00             	movzbl (%eax),%eax
c0105f2c:	3c 7a                	cmp    $0x7a,%al
c0105f2e:	7f 11                	jg     c0105f41 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105f30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f33:	0f b6 00             	movzbl (%eax),%eax
c0105f36:	0f be c0             	movsbl %al,%eax
c0105f39:	83 e8 57             	sub    $0x57,%eax
c0105f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f3f:	eb 23                	jmp    c0105f64 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f44:	0f b6 00             	movzbl (%eax),%eax
c0105f47:	3c 40                	cmp    $0x40,%al
c0105f49:	7e 3b                	jle    c0105f86 <strtol+0x136>
c0105f4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f4e:	0f b6 00             	movzbl (%eax),%eax
c0105f51:	3c 5a                	cmp    $0x5a,%al
c0105f53:	7f 31                	jg     c0105f86 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f58:	0f b6 00             	movzbl (%eax),%eax
c0105f5b:	0f be c0             	movsbl %al,%eax
c0105f5e:	83 e8 37             	sub    $0x37,%eax
c0105f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f67:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f6a:	7d 19                	jge    c0105f85 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105f6c:	ff 45 08             	incl   0x8(%ebp)
c0105f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f72:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f76:	89 c2                	mov    %eax,%edx
c0105f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f7b:	01 d0                	add    %edx,%eax
c0105f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105f80:	e9 72 ff ff ff       	jmp    c0105ef7 <strtol+0xa7>
            break;
c0105f85:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f8a:	74 08                	je     c0105f94 <strtol+0x144>
        *endptr = (char *) s;
c0105f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f8f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f92:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f98:	74 07                	je     c0105fa1 <strtol+0x151>
c0105f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f9d:	f7 d8                	neg    %eax
c0105f9f:	eb 03                	jmp    c0105fa4 <strtol+0x154>
c0105fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105fa4:	89 ec                	mov    %ebp,%esp
c0105fa6:	5d                   	pop    %ebp
c0105fa7:	c3                   	ret    

c0105fa8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105fa8:	55                   	push   %ebp
c0105fa9:	89 e5                	mov    %esp,%ebp
c0105fab:	83 ec 28             	sub    $0x28,%esp
c0105fae:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb4:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105fb7:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105fc1:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105fc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105fca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105fcd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105fd1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105fd4:	89 d7                	mov    %edx,%edi
c0105fd6:	f3 aa                	rep stos %al,%es:(%edi)
c0105fd8:	89 fa                	mov    %edi,%edx
c0105fda:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105fdd:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105fe3:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105fe6:	89 ec                	mov    %ebp,%esp
c0105fe8:	5d                   	pop    %ebp
c0105fe9:	c3                   	ret    

c0105fea <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105fea:	55                   	push   %ebp
c0105feb:	89 e5                	mov    %esp,%ebp
c0105fed:	57                   	push   %edi
c0105fee:	56                   	push   %esi
c0105fef:	53                   	push   %ebx
c0105ff0:	83 ec 30             	sub    $0x30,%esp
c0105ff3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fff:	8b 45 10             	mov    0x10(%ebp),%eax
c0106002:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0106005:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106008:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010600b:	73 42                	jae    c010604f <memmove+0x65>
c010600d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106013:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106016:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106019:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010601c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010601f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106022:	c1 e8 02             	shr    $0x2,%eax
c0106025:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010602a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010602d:	89 d7                	mov    %edx,%edi
c010602f:	89 c6                	mov    %eax,%esi
c0106031:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106033:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106036:	83 e1 03             	and    $0x3,%ecx
c0106039:	74 02                	je     c010603d <memmove+0x53>
c010603b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010603d:	89 f0                	mov    %esi,%eax
c010603f:	89 fa                	mov    %edi,%edx
c0106041:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106044:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106047:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010604a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c010604d:	eb 36                	jmp    c0106085 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010604f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106052:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106055:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106058:	01 c2                	add    %eax,%edx
c010605a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010605d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106060:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106063:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0106066:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106069:	89 c1                	mov    %eax,%ecx
c010606b:	89 d8                	mov    %ebx,%eax
c010606d:	89 d6                	mov    %edx,%esi
c010606f:	89 c7                	mov    %eax,%edi
c0106071:	fd                   	std    
c0106072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106074:	fc                   	cld    
c0106075:	89 f8                	mov    %edi,%eax
c0106077:	89 f2                	mov    %esi,%edx
c0106079:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010607c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010607f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106082:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106085:	83 c4 30             	add    $0x30,%esp
c0106088:	5b                   	pop    %ebx
c0106089:	5e                   	pop    %esi
c010608a:	5f                   	pop    %edi
c010608b:	5d                   	pop    %ebp
c010608c:	c3                   	ret    

c010608d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010608d:	55                   	push   %ebp
c010608e:	89 e5                	mov    %esp,%ebp
c0106090:	57                   	push   %edi
c0106091:	56                   	push   %esi
c0106092:	83 ec 20             	sub    $0x20,%esp
c0106095:	8b 45 08             	mov    0x8(%ebp),%eax
c0106098:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010609b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010609e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01060a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01060a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060aa:	c1 e8 02             	shr    $0x2,%eax
c01060ad:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01060af:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060b5:	89 d7                	mov    %edx,%edi
c01060b7:	89 c6                	mov    %eax,%esi
c01060b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01060bb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01060be:	83 e1 03             	and    $0x3,%ecx
c01060c1:	74 02                	je     c01060c5 <memcpy+0x38>
c01060c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01060c5:	89 f0                	mov    %esi,%eax
c01060c7:	89 fa                	mov    %edi,%edx
c01060c9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01060cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01060cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01060d5:	83 c4 20             	add    $0x20,%esp
c01060d8:	5e                   	pop    %esi
c01060d9:	5f                   	pop    %edi
c01060da:	5d                   	pop    %ebp
c01060db:	c3                   	ret    

c01060dc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01060dc:	55                   	push   %ebp
c01060dd:	89 e5                	mov    %esp,%ebp
c01060df:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01060e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01060e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01060ee:	eb 2e                	jmp    c010611e <memcmp+0x42>
        if (*s1 != *s2) {
c01060f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060f3:	0f b6 10             	movzbl (%eax),%edx
c01060f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060f9:	0f b6 00             	movzbl (%eax),%eax
c01060fc:	38 c2                	cmp    %al,%dl
c01060fe:	74 18                	je     c0106118 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106100:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106103:	0f b6 00             	movzbl (%eax),%eax
c0106106:	0f b6 d0             	movzbl %al,%edx
c0106109:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010610c:	0f b6 00             	movzbl (%eax),%eax
c010610f:	0f b6 c8             	movzbl %al,%ecx
c0106112:	89 d0                	mov    %edx,%eax
c0106114:	29 c8                	sub    %ecx,%eax
c0106116:	eb 18                	jmp    c0106130 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0106118:	ff 45 fc             	incl   -0x4(%ebp)
c010611b:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010611e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106121:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106124:	89 55 10             	mov    %edx,0x10(%ebp)
c0106127:	85 c0                	test   %eax,%eax
c0106129:	75 c5                	jne    c01060f0 <memcmp+0x14>
    }
    return 0;
c010612b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106130:	89 ec                	mov    %ebp,%esp
c0106132:	5d                   	pop    %ebp
c0106133:	c3                   	ret    
