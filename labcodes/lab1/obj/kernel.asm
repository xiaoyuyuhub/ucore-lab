
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 08 0d 11 00       	mov    $0x110d08,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 f9 32 00 00       	call   103321 <memset>

    cons_init();                // init the console
  100028:	e8 b5 15 00 00       	call   1015e2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100042:	e8 d9 02 00 00       	call   100320 <cprintf>

    print_kerninfo();
  100047:	e8 f7 07 00 00       	call   100843 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 90 00 00 00       	call   1000e1 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 22 29 00 00       	call   102978 <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 e2 16 00 00       	call   10173d <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 46 18 00 00       	call   1018a6 <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 1e 0d 00 00       	call   100d83 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 31 16 00 00       	call   10169b <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100079:	00 
  10007a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100081:	00 
  100082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100089:	e8 10 0c 00 00       	call   100c9e <mon_backtrace>
}
  10008e:	90                   	nop
  10008f:	89 ec                	mov    %ebp,%esp
  100091:	5d                   	pop    %ebp
  100092:	c3                   	ret    

00100093 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100093:	55                   	push   %ebp
  100094:	89 e5                	mov    %esp,%ebp
  100096:	83 ec 18             	sub    $0x18,%esp
  100099:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b0 ff ff ff       	call   10006c <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c0:	89 ec                	mov    %ebp,%esp
  1000c2:	5d                   	pop    %ebp
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d4:	89 04 24             	mov    %eax,(%esp)
  1000d7:	e8 b7 ff ff ff       	call   100093 <grade_backtrace1>
}
  1000dc:	90                   	nop
  1000dd:	89 ec                	mov    %ebp,%esp
  1000df:	5d                   	pop    %ebp
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e7:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ec:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f3:	ff 
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000ff:	e8 c0 ff ff ff       	call   1000c4 <grade_backtrace0>
}
  100104:	90                   	nop
  100105:	89 ec                	mov    %ebp,%esp
  100107:	5d                   	pop    %ebp
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 e1 34 10 00 	movl   $0x1034e1,(%esp)
  100138:	e8 e3 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 ef 34 10 00 	movl   $0x1034ef,(%esp)
  100157:	e8 c4 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 fd 34 10 00 	movl   $0x1034fd,(%esp)
  100176:	e8 a5 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 0b 35 10 00 	movl   $0x10350b,(%esp)
  100195:	e8 86 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 19 35 10 00 	movl   $0x103519,(%esp)
  1001b4:	e8 67 01 00 00       	call   100320 <cprintf>
    round ++;
  1001b9:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c4:	90                   	nop
  1001c5:	89 ec                	mov    %ebp,%esp
  1001c7:	5d                   	pop    %ebp
  1001c8:	c3                   	ret    

001001c9 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c9:	55                   	push   %ebp
  1001ca:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cc:	90                   	nop
  1001cd:	5d                   	pop    %ebp
  1001ce:	c3                   	ret    

001001cf <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cf:	55                   	push   %ebp
  1001d0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d2:	90                   	nop
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 29 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001e7:	e8 34 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 d8 ff ff ff       	call   1001c9 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 13 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001fd:	e8 1e 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c8 ff ff ff       	call   1001cf <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 fd fe ff ff       	call   100109 <lab1_print_cur_status>
}
  10020c:	90                   	nop
  10020d:	89 ec                	mov    %ebp,%esp
  10020f:	5d                   	pop    %ebp
  100210:	c3                   	ret    

00100211 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100211:	55                   	push   %ebp
  100212:	89 e5                	mov    %esp,%ebp
  100214:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10021b:	74 13                	je     100230 <readline+0x1f>
        cprintf("%s", prompt);
  10021d:	8b 45 08             	mov    0x8(%ebp),%eax
  100220:	89 44 24 04          	mov    %eax,0x4(%esp)
  100224:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10022b:	e8 f0 00 00 00       	call   100320 <cprintf>
    }
    int i = 0, c;
  100230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100237:	e8 73 01 00 00       	call   1003af <getchar>
  10023c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100243:	79 07                	jns    10024c <readline+0x3b>
            return NULL;
  100245:	b8 00 00 00 00       	mov    $0x0,%eax
  10024a:	eb 78                	jmp    1002c4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100250:	7e 28                	jle    10027a <readline+0x69>
  100252:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100259:	7f 1f                	jg     10027a <readline+0x69>
            cputchar(c);
  10025b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025e:	89 04 24             	mov    %eax,(%esp)
  100261:	e8 e2 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100269:	8d 50 01             	lea    0x1(%eax),%edx
  10026c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100272:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100278:	eb 45                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10027a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027e:	75 16                	jne    100296 <readline+0x85>
  100280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100284:	7e 10                	jle    100296 <readline+0x85>
            cputchar(c);
  100286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100289:	89 04 24             	mov    %eax,(%esp)
  10028c:	e8 b7 00 00 00       	call   100348 <cputchar>
            i --;
  100291:	ff 4d f4             	decl   -0xc(%ebp)
  100294:	eb 29                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100296:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10029a:	74 06                	je     1002a2 <readline+0x91>
  10029c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a0:	75 95                	jne    100237 <readline+0x26>
            cputchar(c);
  1002a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a5:	89 04 24             	mov    %eax,(%esp)
  1002a8:	e8 9b 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002b5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002bd:	eb 05                	jmp    1002c4 <readline+0xb3>
        c = getchar();
  1002bf:	e9 73 ff ff ff       	jmp    100237 <readline+0x26>
        }
    }
}
  1002c4:	89 ec                	mov    %ebp,%esp
  1002c6:	5d                   	pop    %ebp
  1002c7:	c3                   	ret    

001002c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 38 13 00 00       	call   101611 <cons_putc>
    (*cnt) ++;
  1002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dc:	8b 00                	mov    (%eax),%eax
  1002de:	8d 50 01             	lea    0x1(%eax),%edx
  1002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e4:	89 10                	mov    %edx,(%eax)
}
  1002e6:	90                   	nop
  1002e7:	89 ec                	mov    %ebp,%esp
  1002e9:	5d                   	pop    %ebp
  1002ea:	c3                   	ret    

001002eb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  100302:	89 44 24 08          	mov    %eax,0x8(%esp)
  100306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100309:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030d:	c7 04 24 c8 02 10 00 	movl   $0x1002c8,(%esp)
  100314:	e8 33 28 00 00       	call   102b4c <vprintfmt>
    return cnt;
  100319:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031c:	89 ec                	mov    %ebp,%esp
  10031e:	5d                   	pop    %ebp
  10031f:	c3                   	ret    

00100320 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100320:	55                   	push   %ebp
  100321:	89 e5                	mov    %esp,%ebp
  100323:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100326:	8d 45 0c             	lea    0xc(%ebp),%eax
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100333:	8b 45 08             	mov    0x8(%ebp),%eax
  100336:	89 04 24             	mov    %eax,(%esp)
  100339:	e8 ad ff ff ff       	call   1002eb <vcprintf>
  10033e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100341:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100344:	89 ec                	mov    %ebp,%esp
  100346:	5d                   	pop    %ebp
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 b8 12 00 00       	call   101611 <cons_putc>
}
  100359:	90                   	nop
  10035a:	89 ec                	mov    %ebp,%esp
  10035c:	5d                   	pop    %ebp
  10035d:	c3                   	ret    

0010035e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10036b:	eb 13                	jmp    100380 <cputs+0x22>
        cputch(c, &cnt);
  10036d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100371:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100374:	89 54 24 04          	mov    %edx,0x4(%esp)
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 48 ff ff ff       	call   1002c8 <cputch>
    while ((c = *str ++) != '\0') {
  100380:	8b 45 08             	mov    0x8(%ebp),%eax
  100383:	8d 50 01             	lea    0x1(%eax),%edx
  100386:	89 55 08             	mov    %edx,0x8(%ebp)
  100389:	0f b6 00             	movzbl (%eax),%eax
  10038c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100393:	75 d8                	jne    10036d <cputs+0xf>
    }
    cputch('\n', &cnt);
  100395:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10039c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a3:	e8 20 ff ff ff       	call   1002c8 <cputch>
    return cnt;
  1003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ab:	89 ec                	mov    %ebp,%esp
  1003ad:	5d                   	pop    %ebp
  1003ae:	c3                   	ret    

001003af <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003af:	55                   	push   %ebp
  1003b0:	89 e5                	mov    %esp,%ebp
  1003b2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b5:	90                   	nop
  1003b6:	e8 82 12 00 00       	call   10163d <cons_getc>
  1003bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c2:	74 f2                	je     1003b6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c7:	89 ec                	mov    %ebp,%esp
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003dc:	8b 00                	mov    (%eax),%eax
  1003de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e8:	e9 ca 00 00 00       	jmp    1004b7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	89 c2                	mov    %eax,%edx
  1003f7:	c1 ea 1f             	shr    $0x1f,%edx
  1003fa:	01 d0                	add    %edx,%eax
  1003fc:	d1 f8                	sar    %eax
  1003fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100407:	eb 03                	jmp    10040c <stab_binsearch+0x41>
            m --;
  100409:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100412:	7c 1f                	jl     100433 <stab_binsearch+0x68>
  100414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100417:	89 d0                	mov    %edx,%eax
  100419:	01 c0                	add    %eax,%eax
  10041b:	01 d0                	add    %edx,%eax
  10041d:	c1 e0 02             	shl    $0x2,%eax
  100420:	89 c2                	mov    %eax,%edx
  100422:	8b 45 08             	mov    0x8(%ebp),%eax
  100425:	01 d0                	add    %edx,%eax
  100427:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10042b:	0f b6 c0             	movzbl %al,%eax
  10042e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100431:	75 d6                	jne    100409 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100436:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100439:	7d 09                	jge    100444 <stab_binsearch+0x79>
            l = true_m + 1;
  10043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043e:	40                   	inc    %eax
  10043f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100442:	eb 73                	jmp    1004b7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100444:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10044b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044e:	89 d0                	mov    %edx,%eax
  100450:	01 c0                	add    %eax,%eax
  100452:	01 d0                	add    %edx,%eax
  100454:	c1 e0 02             	shl    $0x2,%eax
  100457:	89 c2                	mov    %eax,%edx
  100459:	8b 45 08             	mov    0x8(%ebp),%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	8b 40 08             	mov    0x8(%eax),%eax
  100461:	39 45 18             	cmp    %eax,0x18(%ebp)
  100464:	76 11                	jbe    100477 <stab_binsearch+0xac>
            *region_left = m;
  100466:	8b 45 0c             	mov    0xc(%ebp),%eax
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100471:	40                   	inc    %eax
  100472:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100475:	eb 40                	jmp    1004b7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047a:	89 d0                	mov    %edx,%eax
  10047c:	01 c0                	add    %eax,%eax
  10047e:	01 d0                	add    %edx,%eax
  100480:	c1 e0 02             	shl    $0x2,%eax
  100483:	89 c2                	mov    %eax,%edx
  100485:	8b 45 08             	mov    0x8(%ebp),%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	8b 40 08             	mov    0x8(%eax),%eax
  10048d:	39 45 18             	cmp    %eax,0x18(%ebp)
  100490:	73 14                	jae    1004a6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  100492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100495:	8d 50 ff             	lea    -0x1(%eax),%edx
  100498:	8b 45 10             	mov    0x10(%ebp),%eax
  10049b:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	48                   	dec    %eax
  1004a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a4:	eb 11                	jmp    1004b7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ac:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 2a ff ff ff    	jle    1003ed <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004d6:	eb 3e                	jmp    100516 <stab_binsearch+0x14b>
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 03                	jmp    1004e5 <stab_binsearch+0x11a>
  1004e2:	ff 4d fc             	decl   -0x4(%ebp)
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004ed:	7e 1f                	jle    10050e <stab_binsearch+0x143>
  1004ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f2:	89 d0                	mov    %edx,%eax
  1004f4:	01 c0                	add    %eax,%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	c1 e0 02             	shl    $0x2,%eax
  1004fb:	89 c2                	mov    %eax,%edx
  1004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100506:	0f b6 c0             	movzbl %al,%eax
  100509:	39 45 14             	cmp    %eax,0x14(%ebp)
  10050c:	75 d4                	jne    1004e2 <stab_binsearch+0x117>
        *region_left = l;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 10                	mov    %edx,(%eax)
}
  100516:	90                   	nop
  100517:	89 ec                	mov    %ebp,%esp
  100519:	5d                   	pop    %ebp
  10051a:	c3                   	ret    

0010051b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10051b:	55                   	push   %ebp
  10051c:	89 e5                	mov    %esp,%ebp
  10051e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100521:	8b 45 0c             	mov    0xc(%ebp),%eax
  100524:	c7 00 6c 35 10 00    	movl   $0x10356c,(%eax)
    info->eip_line = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	c7 40 08 6c 35 10 00 	movl   $0x10356c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100541:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054b:	8b 55 08             	mov    0x8(%ebp),%edx
  10054e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10055b:	c7 45 f4 ec 3d 10 00 	movl   $0x103dec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100562:	c7 45 f0 44 bb 10 00 	movl   $0x10bb44,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100569:	c7 45 ec 45 bb 10 00 	movl   $0x10bb45,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100570:	c7 45 e8 a1 e4 10 00 	movl   $0x10e4a1,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057d:	76 0b                	jbe    10058a <debuginfo_eip+0x6f>
  10057f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100582:	48                   	dec    %eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x79>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 ab 02 00 00       	jmp    10083f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005a1:	c1 f8 02             	sar    $0x2,%eax
  1005a4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005aa:	48                   	dec    %eax
  1005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005bc:	00 
  1005bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ce:	89 04 24             	mov    %eax,(%esp)
  1005d1:	e8 f5 fd ff ff       	call   1003cb <stab_binsearch>
    if (lfile == 0)
  1005d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d9:	85 c0                	test   %eax,%eax
  1005db:	75 0a                	jne    1005e7 <debuginfo_eip+0xcc>
        return -1;
  1005dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e2:	e9 58 02 00 00       	jmp    10083f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fa:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100601:	00 
  100602:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100605:	89 44 24 08          	mov    %eax,0x8(%esp)
  100609:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100613:	89 04 24             	mov    %eax,(%esp)
  100616:	e8 b0 fd ff ff       	call   1003cb <stab_binsearch>

    if (lfun <= rfun) {
  10061b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10061e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100621:	39 c2                	cmp    %eax,%edx
  100623:	7f 78                	jg     10069d <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100628:	89 c2                	mov    %eax,%edx
  10062a:	89 d0                	mov    %edx,%eax
  10062c:	01 c0                	add    %eax,%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	c1 e0 02             	shl    $0x2,%eax
  100633:	89 c2                	mov    %eax,%edx
  100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100638:	01 d0                	add    %edx,%eax
  10063a:	8b 10                	mov    (%eax),%edx
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100642:	39 c2                	cmp    %eax,%edx
  100644:	73 22                	jae    100668 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100649:	89 c2                	mov    %eax,%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	8b 10                	mov    (%eax),%edx
  10065d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100660:	01 c2                	add    %eax,%edx
  100662:	8b 45 0c             	mov    0xc(%ebp),%eax
  100665:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066b:	89 c2                	mov    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	01 c0                	add    %eax,%eax
  100671:	01 d0                	add    %edx,%eax
  100673:	c1 e0 02             	shl    $0x2,%eax
  100676:	89 c2                	mov    %eax,%edx
  100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	8b 50 08             	mov    0x8(%eax),%edx
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	8b 40 10             	mov    0x10(%eax),%eax
  10068c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100698:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069b:	eb 15                	jmp    1006b2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006af:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b5:	8b 40 08             	mov    0x8(%eax),%eax
  1006b8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006bf:	00 
  1006c0:	89 04 24             	mov    %eax,(%esp)
  1006c3:	e8 d1 2a 00 00       	call   103199 <strfind>
  1006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006cb:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006ce:	29 c8                	sub    %ecx,%eax
  1006d0:	89 c2                	mov    %eax,%edx
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006db:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006df:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e6:	00 
  1006e7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f8:	89 04 24             	mov    %eax,(%esp)
  1006fb:	e8 cb fc ff ff       	call   1003cb <stab_binsearch>
    if (lline <= rline) {
  100700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100703:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100706:	39 c2                	cmp    %eax,%edx
  100708:	7f 23                	jg     10072d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10070a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100723:	89 c2                	mov    %eax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 11                	jmp    10073e <debuginfo_eip+0x223>
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 08 01 00 00       	jmp    10083f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	48                   	dec    %eax
  10073b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10073e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100744:	39 c2                	cmp    %eax,%edx
  100746:	7c 56                	jl     10079e <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074b:	89 c2                	mov    %eax,%edx
  10074d:	89 d0                	mov    %edx,%eax
  10074f:	01 c0                	add    %eax,%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	c1 e0 02             	shl    $0x2,%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075b:	01 d0                	add    %edx,%eax
  10075d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100761:	3c 84                	cmp    $0x84,%al
  100763:	74 39                	je     10079e <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100768:	89 c2                	mov    %eax,%edx
  10076a:	89 d0                	mov    %edx,%eax
  10076c:	01 c0                	add    %eax,%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	c1 e0 02             	shl    $0x2,%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077e:	3c 64                	cmp    $0x64,%al
  100780:	75 b5                	jne    100737 <debuginfo_eip+0x21c>
  100782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 40 08             	mov    0x8(%eax),%eax
  10079a:	85 c0                	test   %eax,%eax
  10079c:	74 99                	je     100737 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a4:	39 c2                	cmp    %eax,%edx
  1007a6:	7c 42                	jl     1007ea <debuginfo_eip+0x2cf>
  1007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	89 d0                	mov    %edx,%eax
  1007af:	01 c0                	add    %eax,%eax
  1007b1:	01 d0                	add    %edx,%eax
  1007b3:	c1 e0 02             	shl    $0x2,%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bb:	01 d0                	add    %edx,%eax
  1007bd:	8b 10                	mov    (%eax),%edx
  1007bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007c5:	39 c2                	cmp    %eax,%edx
  1007c7:	73 21                	jae    1007ea <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cc:	89 c2                	mov    %eax,%edx
  1007ce:	89 d0                	mov    %edx,%eax
  1007d0:	01 c0                	add    %eax,%eax
  1007d2:	01 d0                	add    %edx,%eax
  1007d4:	c1 e0 02             	shl    $0x2,%eax
  1007d7:	89 c2                	mov    %eax,%edx
  1007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dc:	01 d0                	add    %edx,%eax
  1007de:	8b 10                	mov    (%eax),%edx
  1007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e3:	01 c2                	add    %eax,%edx
  1007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	7d 46                	jge    10083a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1007f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f7:	40                   	inc    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fb:	eb 16                	jmp    100813 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	8b 40 14             	mov    0x14(%eax),%eax
  100803:	8d 50 01             	lea    0x1(%eax),%edx
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10080c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080f:	40                   	inc    %eax
  100810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100813:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100819:	39 c2                	cmp    %eax,%edx
  10081b:	7d 1d                	jge    10083a <debuginfo_eip+0x31f>
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	89 d0                	mov    %edx,%eax
  100824:	01 c0                	add    %eax,%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	c1 e0 02             	shl    $0x2,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100836:	3c a0                	cmp    $0xa0,%al
  100838:	74 c3                	je     1007fd <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10083a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10083f:	89 ec                	mov    %ebp,%esp
  100841:	5d                   	pop    %ebp
  100842:	c3                   	ret    

00100843 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100843:	55                   	push   %ebp
  100844:	89 e5                	mov    %esp,%ebp
  100846:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100849:	c7 04 24 76 35 10 00 	movl   $0x103576,(%esp)
  100850:	e8 cb fa ff ff       	call   100320 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100855:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085c:	00 
  10085d:	c7 04 24 8f 35 10 00 	movl   $0x10358f,(%esp)
  100864:	e8 b7 fa ff ff       	call   100320 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100869:	c7 44 24 04 ad 34 10 	movl   $0x1034ad,0x4(%esp)
  100870:	00 
  100871:	c7 04 24 a7 35 10 00 	movl   $0x1035a7,(%esp)
  100878:	e8 a3 fa ff ff       	call   100320 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10087d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100884:	00 
  100885:	c7 04 24 bf 35 10 00 	movl   $0x1035bf,(%esp)
  10088c:	e8 8f fa ff ff       	call   100320 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100891:	c7 44 24 04 08 0d 11 	movl   $0x110d08,0x4(%esp)
  100898:	00 
  100899:	c7 04 24 d7 35 10 00 	movl   $0x1035d7,(%esp)
  1008a0:	e8 7b fa ff ff       	call   100320 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a5:	b8 08 0d 11 00       	mov    $0x110d08,%eax
  1008aa:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008af:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008b4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ba:	85 c0                	test   %eax,%eax
  1008bc:	0f 48 c2             	cmovs  %edx,%eax
  1008bf:	c1 f8 0a             	sar    $0xa,%eax
  1008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008c6:	c7 04 24 f0 35 10 00 	movl   $0x1035f0,(%esp)
  1008cd:	e8 4e fa ff ff       	call   100320 <cprintf>
}
  1008d2:	90                   	nop
  1008d3:	89 ec                	mov    %ebp,%esp
  1008d5:	5d                   	pop    %ebp
  1008d6:	c3                   	ret    

001008d7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	e8 29 fc ff ff       	call   10051b <debuginfo_eip>
  1008f2:	85 c0                	test   %eax,%eax
  1008f4:	74 15                	je     10090b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fd:	c7 04 24 1a 36 10 00 	movl   $0x10361a,(%esp)
  100904:	e8 17 fa ff ff       	call   100320 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100909:	eb 6c                	jmp    100977 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10090b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100912:	eb 1b                	jmp    10092f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091a:	01 d0                	add    %edx,%eax
  10091c:	0f b6 10             	movzbl (%eax),%edx
  10091f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100928:	01 c8                	add    %ecx,%eax
  10092a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10092c:	ff 45 f4             	incl   -0xc(%ebp)
  10092f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100935:	7c dd                	jl     100914 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100937:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100940:	01 d0                	add    %edx,%eax
  100942:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100945:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100948:	8b 45 08             	mov    0x8(%ebp),%eax
  10094b:	29 d0                	sub    %edx,%eax
  10094d:	89 c1                	mov    %eax,%ecx
  10094f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100955:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100963:	89 54 24 08          	mov    %edx,0x8(%esp)
  100967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10096b:	c7 04 24 36 36 10 00 	movl   $0x103636,(%esp)
  100972:	e8 a9 f9 ff ff       	call   100320 <cprintf>
}
  100977:	90                   	nop
  100978:	89 ec                	mov    %ebp,%esp
  10097a:	5d                   	pop    %ebp
  10097b:	c3                   	ret    

0010097c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097c:	55                   	push   %ebp
  10097d:	89 e5                	mov    %esp,%ebp
  10097f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100982:	8b 45 04             	mov    0x4(%ebp),%eax
  100985:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098b:	89 ec                	mov    %ebp,%esp
  10098d:	5d                   	pop    %ebp
  10098e:	c3                   	ret    

0010098f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 38             	sub    $0x38,%esp
  100995:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100998:	89 e8                	mov    %ebp,%eax
  10099a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  10099d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */


    uint32_t ebp = read_ebp();
  1009a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  1009a3:	e8 d4 ff ff ff       	call   10097c <read_eip>
  1009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  1009ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b2:	e9 8e 00 00 00       	jmp    100a45 <print_stackframe+0xb6>
        if (ebp == 0) break;
  1009b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009bb:	0f 84 90 00 00 00    	je     100a51 <print_stackframe+0xc2>

        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1009d6:	e8 45 f9 ff ff       	call   100320 <cprintf>

        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  1009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009de:	83 c0 14             	add    $0x14,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  1009e1:	8b 18                	mov    (%eax),%ebx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  1009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e6:	83 c0 10             	add    $0x10,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  1009e9:	8b 08                	mov    (%eax),%ecx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  1009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ee:	83 c0 0c             	add    $0xc,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8),
  1009f1:	8b 10                	mov    (%eax),%edx
  1009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f6:	83 c0 08             	add    $0x8,%eax
  1009f9:	8b 00                	mov    (%eax),%eax
  1009fb:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  1009ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a03:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0b:	c7 04 24 60 36 10 00 	movl   $0x103660,(%esp)
  100a12:	e8 09 f9 ff ff       	call   100320 <cprintf>

        cprintf("\n");
  100a17:	c7 04 24 81 36 10 00 	movl   $0x103681,(%esp)
  100a1e:	e8 fd f8 ff ff       	call   100320 <cprintf>

        print_debuginfo(eip - 1);
  100a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a26:	48                   	dec    %eax
  100a27:	89 04 24             	mov    %eax,(%esp)
  100a2a:	e8 a8 fe ff ff       	call   1008d7 <print_debuginfo>

        eip = *(uint32_t *)(ebp + 4);
  100a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a32:	83 c0 04             	add    $0x4,%eax
  100a35:	8b 00                	mov    (%eax),%eax
  100a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)(ebp);
  100a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3d:	8b 00                	mov    (%eax),%eax
  100a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i < STACKFRAME_DEPTH; i++) {
  100a42:	ff 45 ec             	incl   -0x14(%ebp)
  100a45:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a49:	0f 8e 68 ff ff ff    	jle    1009b7 <print_stackframe+0x28>
        // eip = ((uint32_t *)ebp)[1];
        // ebp = ((uint32_t *)ebp)[0];
    }

}
  100a4f:	eb 01                	jmp    100a52 <print_stackframe+0xc3>
        if (ebp == 0) break;
  100a51:	90                   	nop
}
  100a52:	90                   	nop
  100a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a56:	89 ec                	mov    %ebp,%esp
  100a58:	5d                   	pop    %ebp
  100a59:	c3                   	ret    

00100a5a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a5a:	55                   	push   %ebp
  100a5b:	89 e5                	mov    %esp,%ebp
  100a5d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a67:	eb 0c                	jmp    100a75 <parse+0x1b>
            *buf ++ = '\0';
  100a69:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6c:	8d 50 01             	lea    0x1(%eax),%edx
  100a6f:	89 55 08             	mov    %edx,0x8(%ebp)
  100a72:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a75:	8b 45 08             	mov    0x8(%ebp),%eax
  100a78:	0f b6 00             	movzbl (%eax),%eax
  100a7b:	84 c0                	test   %al,%al
  100a7d:	74 1d                	je     100a9c <parse+0x42>
  100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a82:	0f b6 00             	movzbl (%eax),%eax
  100a85:	0f be c0             	movsbl %al,%eax
  100a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8c:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100a93:	e8 cd 26 00 00       	call   103165 <strchr>
  100a98:	85 c0                	test   %eax,%eax
  100a9a:	75 cd                	jne    100a69 <parse+0xf>
        }
        if (*buf == '\0') {
  100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	84 c0                	test   %al,%al
  100aa4:	74 65                	je     100b0b <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aaa:	75 14                	jne    100ac0 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aac:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab3:	00 
  100ab4:	c7 04 24 09 37 10 00 	movl   $0x103709,(%esp)
  100abb:	e8 60 f8 ff ff       	call   100320 <cprintf>
        }
        argv[argc ++] = buf;
  100ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac3:	8d 50 01             	lea    0x1(%eax),%edx
  100ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad3:	01 c2                	add    %eax,%edx
  100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ada:	eb 03                	jmp    100adf <parse+0x85>
            buf ++;
  100adc:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae2:	0f b6 00             	movzbl (%eax),%eax
  100ae5:	84 c0                	test   %al,%al
  100ae7:	74 8c                	je     100a75 <parse+0x1b>
  100ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aec:	0f b6 00             	movzbl (%eax),%eax
  100aef:	0f be c0             	movsbl %al,%eax
  100af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af6:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100afd:	e8 63 26 00 00       	call   103165 <strchr>
  100b02:	85 c0                	test   %eax,%eax
  100b04:	74 d6                	je     100adc <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b06:	e9 6a ff ff ff       	jmp    100a75 <parse+0x1b>
            break;
  100b0b:	90                   	nop
        }
    }
    return argc;
  100b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b0f:	89 ec                	mov    %ebp,%esp
  100b11:	5d                   	pop    %ebp
  100b12:	c3                   	ret    

00100b13 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b13:	55                   	push   %ebp
  100b14:	89 e5                	mov    %esp,%ebp
  100b16:	83 ec 68             	sub    $0x68,%esp
  100b19:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b23:	8b 45 08             	mov    0x8(%ebp),%eax
  100b26:	89 04 24             	mov    %eax,(%esp)
  100b29:	e8 2c ff ff ff       	call   100a5a <parse>
  100b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b35:	75 0a                	jne    100b41 <runcmd+0x2e>
        return 0;
  100b37:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3c:	e9 83 00 00 00       	jmp    100bc4 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b48:	eb 5a                	jmp    100ba4 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b4d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b50:	89 c8                	mov    %ecx,%eax
  100b52:	01 c0                	add    %eax,%eax
  100b54:	01 c8                	add    %ecx,%eax
  100b56:	c1 e0 02             	shl    $0x2,%eax
  100b59:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b5e:	8b 00                	mov    (%eax),%eax
  100b60:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b64:	89 04 24             	mov    %eax,(%esp)
  100b67:	e8 5d 25 00 00       	call   1030c9 <strcmp>
  100b6c:	85 c0                	test   %eax,%eax
  100b6e:	75 31                	jne    100ba1 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b73:	89 d0                	mov    %edx,%eax
  100b75:	01 c0                	add    %eax,%eax
  100b77:	01 d0                	add    %edx,%eax
  100b79:	c1 e0 02             	shl    $0x2,%eax
  100b7c:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b81:	8b 10                	mov    (%eax),%edx
  100b83:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b86:	83 c0 04             	add    $0x4,%eax
  100b89:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b8c:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9a:	89 1c 24             	mov    %ebx,(%esp)
  100b9d:	ff d2                	call   *%edx
  100b9f:	eb 23                	jmp    100bc4 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba1:	ff 45 f4             	incl   -0xc(%ebp)
  100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba7:	83 f8 02             	cmp    $0x2,%eax
  100baa:	76 9e                	jbe    100b4a <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb3:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  100bba:	e8 61 f7 ff ff       	call   100320 <cprintf>
    return 0;
  100bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bc7:	89 ec                	mov    %ebp,%esp
  100bc9:	5d                   	pop    %ebp
  100bca:	c3                   	ret    

00100bcb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bcb:	55                   	push   %ebp
  100bcc:	89 e5                	mov    %esp,%ebp
  100bce:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd1:	c7 04 24 40 37 10 00 	movl   $0x103740,(%esp)
  100bd8:	e8 43 f7 ff ff       	call   100320 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bdd:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  100be4:	e8 37 f7 ff ff       	call   100320 <cprintf>

    if (tf != NULL) {
  100be9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bed:	74 0b                	je     100bfa <kmonitor+0x2f>
        print_trapframe(tf);
  100bef:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf2:	89 04 24             	mov    %eax,(%esp)
  100bf5:	e8 fc 0d 00 00       	call   1019f6 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bfa:	c7 04 24 8d 37 10 00 	movl   $0x10378d,(%esp)
  100c01:	e8 0b f6 ff ff       	call   100211 <readline>
  100c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0d:	74 eb                	je     100bfa <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c19:	89 04 24             	mov    %eax,(%esp)
  100c1c:	e8 f2 fe ff ff       	call   100b13 <runcmd>
  100c21:	85 c0                	test   %eax,%eax
  100c23:	78 02                	js     100c27 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c25:	eb d3                	jmp    100bfa <kmonitor+0x2f>
                break;
  100c27:	90                   	nop
            }
        }
    }
}
  100c28:	90                   	nop
  100c29:	89 ec                	mov    %ebp,%esp
  100c2b:	5d                   	pop    %ebp
  100c2c:	c3                   	ret    

00100c2d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c2d:	55                   	push   %ebp
  100c2e:	89 e5                	mov    %esp,%ebp
  100c30:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c3a:	eb 3d                	jmp    100c79 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3f:	89 d0                	mov    %edx,%eax
  100c41:	01 c0                	add    %eax,%eax
  100c43:	01 d0                	add    %edx,%eax
  100c45:	c1 e0 02             	shl    $0x2,%eax
  100c48:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c4d:	8b 10                	mov    (%eax),%edx
  100c4f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c52:	89 c8                	mov    %ecx,%eax
  100c54:	01 c0                	add    %eax,%eax
  100c56:	01 c8                	add    %ecx,%eax
  100c58:	c1 e0 02             	shl    $0x2,%eax
  100c5b:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c60:	8b 00                	mov    (%eax),%eax
  100c62:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6a:	c7 04 24 91 37 10 00 	movl   $0x103791,(%esp)
  100c71:	e8 aa f6 ff ff       	call   100320 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c76:	ff 45 f4             	incl   -0xc(%ebp)
  100c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7c:	83 f8 02             	cmp    $0x2,%eax
  100c7f:	76 bb                	jbe    100c3c <mon_help+0xf>
    }
    return 0;
  100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c86:	89 ec                	mov    %ebp,%esp
  100c88:	5d                   	pop    %ebp
  100c89:	c3                   	ret    

00100c8a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c90:	e8 ae fb ff ff       	call   100843 <print_kerninfo>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	89 ec                	mov    %ebp,%esp
  100c9c:	5d                   	pop    %ebp
  100c9d:	c3                   	ret    

00100c9e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c9e:	55                   	push   %ebp
  100c9f:	89 e5                	mov    %esp,%ebp
  100ca1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca4:	e8 e6 fc ff ff       	call   10098f <print_stackframe>
    return 0;
  100ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cae:	89 ec                	mov    %ebp,%esp
  100cb0:	5d                   	pop    %ebp
  100cb1:	c3                   	ret    

00100cb2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb2:	55                   	push   %ebp
  100cb3:	89 e5                	mov    %esp,%ebp
  100cb5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb8:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100cbd:	85 c0                	test   %eax,%eax
  100cbf:	75 5b                	jne    100d1c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cc1:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100cc8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ccb:	8d 45 14             	lea    0x14(%ebp),%eax
  100cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdf:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100ce6:	e8 35 f6 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf5:	89 04 24             	mov    %eax,(%esp)
  100cf8:	e8 ee f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100cfd:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d04:	e8 17 f6 ff ff       	call   100320 <cprintf>
    
    cprintf("stack trackback:\n");
  100d09:	c7 04 24 b8 37 10 00 	movl   $0x1037b8,(%esp)
  100d10:	e8 0b f6 ff ff       	call   100320 <cprintf>
    print_stackframe();
  100d15:	e8 75 fc ff ff       	call   10098f <print_stackframe>
  100d1a:	eb 01                	jmp    100d1d <__panic+0x6b>
        goto panic_dead;
  100d1c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d1d:	e8 81 09 00 00       	call   1016a3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d29:	e8 9d fe ff ff       	call   100bcb <kmonitor>
  100d2e:	eb f2                	jmp    100d22 <__panic+0x70>

00100d30 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d36:	8d 45 14             	lea    0x14(%ebp),%eax
  100d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d43:	8b 45 08             	mov    0x8(%ebp),%eax
  100d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4a:	c7 04 24 ca 37 10 00 	movl   $0x1037ca,(%esp)
  100d51:	e8 ca f5 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d60:	89 04 24             	mov    %eax,(%esp)
  100d63:	e8 83 f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100d68:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d6f:	e8 ac f5 ff ff       	call   100320 <cprintf>
    va_end(ap);
}
  100d74:	90                   	nop
  100d75:	89 ec                	mov    %ebp,%esp
  100d77:	5d                   	pop    %ebp
  100d78:	c3                   	ret    

00100d79 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d79:	55                   	push   %ebp
  100d7a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7c:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d81:	5d                   	pop    %ebp
  100d82:	c3                   	ret    

00100d83 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d83:	55                   	push   %ebp
  100d84:	89 e5                	mov    %esp,%ebp
  100d86:	83 ec 28             	sub    $0x28,%esp
  100d89:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d8f:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d93:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d97:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
}
  100d9c:	90                   	nop
  100d9d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100da7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100daf:	ee                   	out    %al,(%dx)
}
  100db0:	90                   	nop
  100db1:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100db7:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dbb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dbf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc3:	ee                   	out    %al,(%dx)
}
  100dc4:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc5:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100dcc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcf:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100dd6:	e8 45 f5 ff ff       	call   100320 <cprintf>
    pic_enable(IRQ_TIMER);
  100ddb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de2:	e8 21 09 00 00       	call   101708 <pic_enable>
}
  100de7:	90                   	nop
  100de8:	89 ec                	mov    %ebp,%esp
  100dea:	5d                   	pop    %ebp
  100deb:	c3                   	ret    

00100dec <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 10             	sub    $0x10,%esp
  100df2:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100df8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e02:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e08:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e12:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e18:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e1c:	89 c2                	mov    %eax,%edx
  100e1e:	ec                   	in     (%dx),%al
  100e1f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e22:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e28:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e2c:	89 c2                	mov    %eax,%edx
  100e2e:	ec                   	in     (%dx),%al
  100e2f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e32:	90                   	nop
  100e33:	89 ec                	mov    %ebp,%esp
  100e35:	5d                   	pop    %ebp
  100e36:	c3                   	ret    

00100e37 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e37:	55                   	push   %ebp
  100e38:	89 e5                	mov    %esp,%ebp
  100e3a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e3d:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e47:	0f b7 00             	movzwl (%eax),%eax
  100e4a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e51:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e59:	0f b7 00             	movzwl (%eax),%eax
  100e5c:	0f b7 c0             	movzwl %ax,%eax
  100e5f:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e64:	74 12                	je     100e78 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e66:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e6d:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e74:	b4 03 
  100e76:	eb 13                	jmp    100e8b <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e7f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e82:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e89:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e8b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e92:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e96:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e9e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ea2:	ee                   	out    %al,(%dx)
}
  100ea3:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ea4:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eab:	40                   	inc    %eax
  100eac:	0f b7 c0             	movzwl %ax,%eax
  100eaf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eb7:	89 c2                	mov    %eax,%edx
  100eb9:	ec                   	in     (%dx),%al
  100eba:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ebd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec1:	0f b6 c0             	movzbl %al,%eax
  100ec4:	c1 e0 08             	shl    $0x8,%eax
  100ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eca:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ed5:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100edd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ee1:	ee                   	out    %al,(%dx)
}
  100ee2:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ee3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eea:	40                   	inc    %eax
  100eeb:	0f b7 c0             	movzwl %ax,%eax
  100eee:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ef6:	89 c2                	mov    %eax,%edx
  100ef8:	ec                   	in     (%dx),%al
  100ef9:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100efc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f00:	0f b6 c0             	movzbl %al,%eax
  100f03:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f09:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f11:	0f b7 c0             	movzwl %ax,%eax
  100f14:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f1a:	90                   	nop
  100f1b:	89 ec                	mov    %ebp,%esp
  100f1d:	5d                   	pop    %ebp
  100f1e:	c3                   	ret    

00100f1f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f1f:	55                   	push   %ebp
  100f20:	89 e5                	mov    %esp,%ebp
  100f22:	83 ec 48             	sub    $0x48,%esp
  100f25:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f2b:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f33:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f37:	ee                   	out    %al,(%dx)
}
  100f38:	90                   	nop
  100f39:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f3f:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f43:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f47:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f4b:	ee                   	out    %al,(%dx)
}
  100f4c:	90                   	nop
  100f4d:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f53:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f57:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f5b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
}
  100f60:	90                   	nop
  100f61:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f67:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f6b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f6f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
}
  100f74:	90                   	nop
  100f75:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f7b:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f7f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f83:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f87:	ee                   	out    %al,(%dx)
}
  100f88:	90                   	nop
  100f89:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f8f:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f93:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f97:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f9b:	ee                   	out    %al,(%dx)
}
  100f9c:	90                   	nop
  100f9d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fab:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100faf:	ee                   	out    %al,(%dx)
}
  100fb0:	90                   	nop
  100fb1:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fbb:	89 c2                	mov    %eax,%edx
  100fbd:	ec                   	in     (%dx),%al
  100fbe:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc5:	3c ff                	cmp    $0xff,%al
  100fc7:	0f 95 c0             	setne  %al
  100fca:	0f b6 c0             	movzbl %al,%eax
  100fcd:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fd2:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fd8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fdc:	89 c2                	mov    %eax,%edx
  100fde:	ec                   	in     (%dx),%al
  100fdf:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fe2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fe8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff2:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100ff7:	85 c0                	test   %eax,%eax
  100ff9:	74 0c                	je     101007 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100ffb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101002:	e8 01 07 00 00       	call   101708 <pic_enable>
    }
}
  101007:	90                   	nop
  101008:	89 ec                	mov    %ebp,%esp
  10100a:	5d                   	pop    %ebp
  10100b:	c3                   	ret    

0010100c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100c:	55                   	push   %ebp
  10100d:	89 e5                	mov    %esp,%ebp
  10100f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101019:	eb 08                	jmp    101023 <lpt_putc_sub+0x17>
        delay();
  10101b:	e8 cc fd ff ff       	call   100dec <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101020:	ff 45 fc             	incl   -0x4(%ebp)
  101023:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101029:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10102d:	89 c2                	mov    %eax,%edx
  10102f:	ec                   	in     (%dx),%al
  101030:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101033:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101037:	84 c0                	test   %al,%al
  101039:	78 09                	js     101044 <lpt_putc_sub+0x38>
  10103b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101042:	7e d7                	jle    10101b <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101044:	8b 45 08             	mov    0x8(%ebp),%eax
  101047:	0f b6 c0             	movzbl %al,%eax
  10104a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101050:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101053:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101057:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105b:	ee                   	out    %al,(%dx)
}
  10105c:	90                   	nop
  10105d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101063:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101067:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10106f:	ee                   	out    %al,(%dx)
}
  101070:	90                   	nop
  101071:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101077:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
}
  101084:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101085:	90                   	nop
  101086:	89 ec                	mov    %ebp,%esp
  101088:	5d                   	pop    %ebp
  101089:	c3                   	ret    

0010108a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10108a:	55                   	push   %ebp
  10108b:	89 e5                	mov    %esp,%ebp
  10108d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101090:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101094:	74 0d                	je     1010a3 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101096:	8b 45 08             	mov    0x8(%ebp),%eax
  101099:	89 04 24             	mov    %eax,(%esp)
  10109c:	e8 6b ff ff ff       	call   10100c <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010a1:	eb 24                	jmp    1010c7 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010a3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010aa:	e8 5d ff ff ff       	call   10100c <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010af:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010b6:	e8 51 ff ff ff       	call   10100c <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010bb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c2:	e8 45 ff ff ff       	call   10100c <lpt_putc_sub>
}
  1010c7:	90                   	nop
  1010c8:	89 ec                	mov    %ebp,%esp
  1010ca:	5d                   	pop    %ebp
  1010cb:	c3                   	ret    

001010cc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010cc:	55                   	push   %ebp
  1010cd:	89 e5                	mov    %esp,%ebp
  1010cf:	83 ec 38             	sub    $0x38,%esp
  1010d2:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010dd:	85 c0                	test   %eax,%eax
  1010df:	75 07                	jne    1010e8 <cga_putc+0x1c>
        c |= 0x0700;
  1010e1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010eb:	0f b6 c0             	movzbl %al,%eax
  1010ee:	83 f8 0d             	cmp    $0xd,%eax
  1010f1:	74 72                	je     101165 <cga_putc+0x99>
  1010f3:	83 f8 0d             	cmp    $0xd,%eax
  1010f6:	0f 8f a3 00 00 00    	jg     10119f <cga_putc+0xd3>
  1010fc:	83 f8 08             	cmp    $0x8,%eax
  1010ff:	74 0a                	je     10110b <cga_putc+0x3f>
  101101:	83 f8 0a             	cmp    $0xa,%eax
  101104:	74 4c                	je     101152 <cga_putc+0x86>
  101106:	e9 94 00 00 00       	jmp    10119f <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10110b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101112:	85 c0                	test   %eax,%eax
  101114:	0f 84 af 00 00 00    	je     1011c9 <cga_putc+0xfd>
            crt_pos --;
  10111a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101121:	48                   	dec    %eax
  101122:	0f b7 c0             	movzwl %ax,%eax
  101125:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112b:	8b 45 08             	mov    0x8(%ebp),%eax
  10112e:	98                   	cwtl   
  10112f:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101134:	98                   	cwtl   
  101135:	83 c8 20             	or     $0x20,%eax
  101138:	98                   	cwtl   
  101139:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10113f:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 ca                	add    %ecx,%edx
  10114a:	0f b7 c0             	movzwl %ax,%eax
  10114d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101150:	eb 77                	jmp    1011c9 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101152:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101159:	83 c0 50             	add    $0x50,%eax
  10115c:	0f b7 c0             	movzwl %ax,%eax
  10115f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101165:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10116c:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101173:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101178:	89 c8                	mov    %ecx,%eax
  10117a:	f7 e2                	mul    %edx
  10117c:	c1 ea 06             	shr    $0x6,%edx
  10117f:	89 d0                	mov    %edx,%eax
  101181:	c1 e0 02             	shl    $0x2,%eax
  101184:	01 d0                	add    %edx,%eax
  101186:	c1 e0 04             	shl    $0x4,%eax
  101189:	29 c1                	sub    %eax,%ecx
  10118b:	89 ca                	mov    %ecx,%edx
  10118d:	0f b7 d2             	movzwl %dx,%edx
  101190:	89 d8                	mov    %ebx,%eax
  101192:	29 d0                	sub    %edx,%eax
  101194:	0f b7 c0             	movzwl %ax,%eax
  101197:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  10119d:	eb 2b                	jmp    1011ca <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10119f:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011a5:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011ac:	8d 50 01             	lea    0x1(%eax),%edx
  1011af:	0f b7 d2             	movzwl %dx,%edx
  1011b2:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011b9:	01 c0                	add    %eax,%eax
  1011bb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011be:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c1:	0f b7 c0             	movzwl %ax,%eax
  1011c4:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c7:	eb 01                	jmp    1011ca <cga_putc+0xfe>
        break;
  1011c9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ca:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011d1:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011d6:	76 5e                	jbe    101236 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d8:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011dd:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e3:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011e8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ef:	00 
  1011f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f4:	89 04 24             	mov    %eax,(%esp)
  1011f7:	e8 67 21 00 00       	call   103363 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fc:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101203:	eb 15                	jmp    10121a <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101205:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10120b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10120e:	01 c0                	add    %eax,%eax
  101210:	01 d0                	add    %edx,%eax
  101212:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101217:	ff 45 f4             	incl   -0xc(%ebp)
  10121a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101221:	7e e2                	jle    101205 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101223:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10122a:	83 e8 50             	sub    $0x50,%eax
  10122d:	0f b7 c0             	movzwl %ax,%eax
  101230:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101236:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10123d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101241:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101245:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101249:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124d:	ee                   	out    %al,(%dx)
}
  10124e:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10124f:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101256:	c1 e8 08             	shr    $0x8,%eax
  101259:	0f b7 c0             	movzwl %ax,%eax
  10125c:	0f b6 c0             	movzbl %al,%eax
  10125f:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101266:	42                   	inc    %edx
  101267:	0f b7 d2             	movzwl %dx,%edx
  10126a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10126e:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101271:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101275:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101279:	ee                   	out    %al,(%dx)
}
  10127a:	90                   	nop
    outb(addr_6845, 15);
  10127b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101282:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101286:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10128a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101292:	ee                   	out    %al,(%dx)
}
  101293:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101294:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10129b:	0f b6 c0             	movzbl %al,%eax
  10129e:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012a5:	42                   	inc    %edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012ad:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	90                   	nop
}
  1012ba:	90                   	nop
  1012bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012be:	89 ec                	mov    %ebp,%esp
  1012c0:	5d                   	pop    %ebp
  1012c1:	c3                   	ret    

001012c2 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c2:	55                   	push   %ebp
  1012c3:	89 e5                	mov    %esp,%ebp
  1012c5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cf:	eb 08                	jmp    1012d9 <serial_putc_sub+0x17>
        delay();
  1012d1:	e8 16 fb ff ff       	call   100dec <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d6:	ff 45 fc             	incl   -0x4(%ebp)
  1012d9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012df:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e3:	89 c2                	mov    %eax,%edx
  1012e5:	ec                   	in     (%dx),%al
  1012e6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ed:	0f b6 c0             	movzbl %al,%eax
  1012f0:	83 e0 20             	and    $0x20,%eax
  1012f3:	85 c0                	test   %eax,%eax
  1012f5:	75 09                	jne    101300 <serial_putc_sub+0x3e>
  1012f7:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fe:	7e d1                	jle    1012d1 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101300:	8b 45 08             	mov    0x8(%ebp),%eax
  101303:	0f b6 c0             	movzbl %al,%eax
  101306:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10130f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101313:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101317:	ee                   	out    %al,(%dx)
}
  101318:	90                   	nop
}
  101319:	90                   	nop
  10131a:	89 ec                	mov    %ebp,%esp
  10131c:	5d                   	pop    %ebp
  10131d:	c3                   	ret    

0010131e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131e:	55                   	push   %ebp
  10131f:	89 e5                	mov    %esp,%ebp
  101321:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101324:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101328:	74 0d                	je     101337 <serial_putc+0x19>
        serial_putc_sub(c);
  10132a:	8b 45 08             	mov    0x8(%ebp),%eax
  10132d:	89 04 24             	mov    %eax,(%esp)
  101330:	e8 8d ff ff ff       	call   1012c2 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101335:	eb 24                	jmp    10135b <serial_putc+0x3d>
        serial_putc_sub('\b');
  101337:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133e:	e8 7f ff ff ff       	call   1012c2 <serial_putc_sub>
        serial_putc_sub(' ');
  101343:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134a:	e8 73 ff ff ff       	call   1012c2 <serial_putc_sub>
        serial_putc_sub('\b');
  10134f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101356:	e8 67 ff ff ff       	call   1012c2 <serial_putc_sub>
}
  10135b:	90                   	nop
  10135c:	89 ec                	mov    %ebp,%esp
  10135e:	5d                   	pop    %ebp
  10135f:	c3                   	ret    

00101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101360:	55                   	push   %ebp
  101361:	89 e5                	mov    %esp,%ebp
  101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101366:	eb 33                	jmp    10139b <cons_intr+0x3b>
        if (c != 0) {
  101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136c:	74 2d                	je     10139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136e:	a1 84 00 11 00       	mov    0x110084,%eax
  101373:	8d 50 01             	lea    0x1(%eax),%edx
  101376:	89 15 84 00 11 00    	mov    %edx,0x110084
  10137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137f:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101385:	a1 84 00 11 00       	mov    0x110084,%eax
  10138a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138f:	75 0a                	jne    10139b <cons_intr+0x3b>
                cons.wpos = 0;
  101391:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  101398:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10139b:	8b 45 08             	mov    0x8(%ebp),%eax
  10139e:	ff d0                	call   *%eax
  1013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a7:	75 bf                	jne    101368 <cons_intr+0x8>
            }
        }
    }
}
  1013a9:	90                   	nop
  1013aa:	90                   	nop
  1013ab:	89 ec                	mov    %ebp,%esp
  1013ad:	5d                   	pop    %ebp
  1013ae:	c3                   	ret    

001013af <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013af:	55                   	push   %ebp
  1013b0:	89 e5                	mov    %esp,%ebp
  1013b2:	83 ec 10             	sub    $0x10,%esp
  1013b5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bf:	89 c2                	mov    %eax,%edx
  1013c1:	ec                   	in     (%dx),%al
  1013c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c9:	0f b6 c0             	movzbl %al,%eax
  1013cc:	83 e0 01             	and    $0x1,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	75 07                	jne    1013da <serial_proc_data+0x2b>
        return -1;
  1013d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d8:	eb 2a                	jmp    101404 <serial_proc_data+0x55>
  1013da:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e4:	89 c2                	mov    %eax,%edx
  1013e6:	ec                   	in     (%dx),%al
  1013e7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ea:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ee:	0f b6 c0             	movzbl %al,%eax
  1013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f4:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f8:	75 07                	jne    101401 <serial_proc_data+0x52>
        c = '\b';
  1013fa:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101401:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101404:	89 ec                	mov    %ebp,%esp
  101406:	5d                   	pop    %ebp
  101407:	c3                   	ret    

00101408 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101408:	55                   	push   %ebp
  101409:	89 e5                	mov    %esp,%ebp
  10140b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10140e:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101413:	85 c0                	test   %eax,%eax
  101415:	74 0c                	je     101423 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101417:	c7 04 24 af 13 10 00 	movl   $0x1013af,(%esp)
  10141e:	e8 3d ff ff ff       	call   101360 <cons_intr>
    }
}
  101423:	90                   	nop
  101424:	89 ec                	mov    %ebp,%esp
  101426:	5d                   	pop    %ebp
  101427:	c3                   	ret    

00101428 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 38             	sub    $0x38,%esp
  10142e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101437:	89 c2                	mov    %eax,%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10143d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	83 e0 01             	and    $0x1,%eax
  101447:	85 c0                	test   %eax,%eax
  101449:	75 0a                	jne    101455 <kbd_proc_data+0x2d>
        return -1;
  10144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101450:	e9 56 01 00 00       	jmp    1015ab <kbd_proc_data+0x183>
  101455:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10145e:	89 c2                	mov    %eax,%edx
  101460:	ec                   	in     (%dx),%al
  101461:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101464:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101468:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10146f:	75 17                	jne    101488 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101471:	a1 88 00 11 00       	mov    0x110088,%eax
  101476:	83 c8 40             	or     $0x40,%eax
  101479:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10147e:	b8 00 00 00 00       	mov    $0x0,%eax
  101483:	e9 23 01 00 00       	jmp    1015ab <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101488:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148c:	84 c0                	test   %al,%al
  10148e:	79 45                	jns    1014d5 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101490:	a1 88 00 11 00       	mov    0x110088,%eax
  101495:	83 e0 40             	and    $0x40,%eax
  101498:	85 c0                	test   %eax,%eax
  10149a:	75 08                	jne    1014a4 <kbd_proc_data+0x7c>
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	24 7f                	and    $0x7f,%al
  1014a2:	eb 04                	jmp    1014a8 <kbd_proc_data+0x80>
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014af:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014b6:	0c 40                	or     $0x40,%al
  1014b8:	0f b6 c0             	movzbl %al,%eax
  1014bb:	f7 d0                	not    %eax
  1014bd:	89 c2                	mov    %eax,%edx
  1014bf:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c4:	21 d0                	and    %edx,%eax
  1014c6:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d0:	e9 d6 00 00 00       	jmp    1015ab <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014d5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014da:	83 e0 40             	and    $0x40,%eax
  1014dd:	85 c0                	test   %eax,%eax
  1014df:	74 11                	je     1014f2 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e1:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ea:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ed:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1014f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f6:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014fd:	0f b6 d0             	movzbl %al,%edx
  101500:	a1 88 00 11 00       	mov    0x110088,%eax
  101505:	09 d0                	or     %edx,%eax
  101507:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101517:	0f b6 d0             	movzbl %al,%edx
  10151a:	a1 88 00 11 00       	mov    0x110088,%eax
  10151f:	31 d0                	xor    %edx,%eax
  101521:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101526:	a1 88 00 11 00       	mov    0x110088,%eax
  10152b:	83 e0 03             	and    $0x3,%eax
  10152e:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101535:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101539:	01 d0                	add    %edx,%eax
  10153b:	0f b6 00             	movzbl (%eax),%eax
  10153e:	0f b6 c0             	movzbl %al,%eax
  101541:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101544:	a1 88 00 11 00       	mov    0x110088,%eax
  101549:	83 e0 08             	and    $0x8,%eax
  10154c:	85 c0                	test   %eax,%eax
  10154e:	74 22                	je     101572 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101550:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101554:	7e 0c                	jle    101562 <kbd_proc_data+0x13a>
  101556:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10155a:	7f 06                	jg     101562 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10155c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101560:	eb 10                	jmp    101572 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101562:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101566:	7e 0a                	jle    101572 <kbd_proc_data+0x14a>
  101568:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10156c:	7f 04                	jg     101572 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10156e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101572:	a1 88 00 11 00       	mov    0x110088,%eax
  101577:	f7 d0                	not    %eax
  101579:	83 e0 06             	and    $0x6,%eax
  10157c:	85 c0                	test   %eax,%eax
  10157e:	75 28                	jne    1015a8 <kbd_proc_data+0x180>
  101580:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101587:	75 1f                	jne    1015a8 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101589:	c7 04 24 03 38 10 00 	movl   $0x103803,(%esp)
  101590:	e8 8b ed ff ff       	call   100320 <cprintf>
  101595:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10159f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015a6:	ee                   	out    %al,(%dx)
}
  1015a7:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ab:	89 ec                	mov    %ebp,%esp
  1015ad:	5d                   	pop    %ebp
  1015ae:	c3                   	ret    

001015af <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015af:	55                   	push   %ebp
  1015b0:	89 e5                	mov    %esp,%ebp
  1015b2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b5:	c7 04 24 28 14 10 00 	movl   $0x101428,(%esp)
  1015bc:	e8 9f fd ff ff       	call   101360 <cons_intr>
}
  1015c1:	90                   	nop
  1015c2:	89 ec                	mov    %ebp,%esp
  1015c4:	5d                   	pop    %ebp
  1015c5:	c3                   	ret    

001015c6 <kbd_init>:

static void
kbd_init(void) {
  1015c6:	55                   	push   %ebp
  1015c7:	89 e5                	mov    %esp,%ebp
  1015c9:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015cc:	e8 de ff ff ff       	call   1015af <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d8:	e8 2b 01 00 00       	call   101708 <pic_enable>
}
  1015dd:	90                   	nop
  1015de:	89 ec                	mov    %ebp,%esp
  1015e0:	5d                   	pop    %ebp
  1015e1:	c3                   	ret    

001015e2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e2:	55                   	push   %ebp
  1015e3:	89 e5                	mov    %esp,%ebp
  1015e5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e8:	e8 4a f8 ff ff       	call   100e37 <cga_init>
    serial_init();
  1015ed:	e8 2d f9 ff ff       	call   100f1f <serial_init>
    kbd_init();
  1015f2:	e8 cf ff ff ff       	call   1015c6 <kbd_init>
    if (!serial_exists) {
  1015f7:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1015fc:	85 c0                	test   %eax,%eax
  1015fe:	75 0c                	jne    10160c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101600:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  101607:	e8 14 ed ff ff       	call   100320 <cprintf>
    }
}
  10160c:	90                   	nop
  10160d:	89 ec                	mov    %ebp,%esp
  10160f:	5d                   	pop    %ebp
  101610:	c3                   	ret    

00101611 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101611:	55                   	push   %ebp
  101612:	89 e5                	mov    %esp,%ebp
  101614:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101617:	8b 45 08             	mov    0x8(%ebp),%eax
  10161a:	89 04 24             	mov    %eax,(%esp)
  10161d:	e8 68 fa ff ff       	call   10108a <lpt_putc>
    cga_putc(c);
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	89 04 24             	mov    %eax,(%esp)
  101628:	e8 9f fa ff ff       	call   1010cc <cga_putc>
    serial_putc(c);
  10162d:	8b 45 08             	mov    0x8(%ebp),%eax
  101630:	89 04 24             	mov    %eax,(%esp)
  101633:	e8 e6 fc ff ff       	call   10131e <serial_putc>
}
  101638:	90                   	nop
  101639:	89 ec                	mov    %ebp,%esp
  10163b:	5d                   	pop    %ebp
  10163c:	c3                   	ret    

0010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101643:	e8 c0 fd ff ff       	call   101408 <serial_intr>
    kbd_intr();
  101648:	e8 62 ff ff ff       	call   1015af <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10164d:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101653:	a1 84 00 11 00       	mov    0x110084,%eax
  101658:	39 c2                	cmp    %eax,%edx
  10165a:	74 36                	je     101692 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10165c:	a1 80 00 11 00       	mov    0x110080,%eax
  101661:	8d 50 01             	lea    0x1(%eax),%edx
  101664:	89 15 80 00 11 00    	mov    %edx,0x110080
  10166a:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101671:	0f b6 c0             	movzbl %al,%eax
  101674:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101677:	a1 80 00 11 00       	mov    0x110080,%eax
  10167c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101681:	75 0a                	jne    10168d <cons_getc+0x50>
            cons.rpos = 0;
  101683:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10168a:	00 00 00 
        }
        return c;
  10168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101690:	eb 05                	jmp    101697 <cons_getc+0x5a>
    }
    return 0;
  101692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101697:	89 ec                	mov    %ebp,%esp
  101699:	5d                   	pop    %ebp
  10169a:	c3                   	ret    

0010169b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10169b:	55                   	push   %ebp
  10169c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10169e:	fb                   	sti    
}
  10169f:	90                   	nop
    sti();
}
  1016a0:	90                   	nop
  1016a1:	5d                   	pop    %ebp
  1016a2:	c3                   	ret    

001016a3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016a6:	fa                   	cli    
}
  1016a7:	90                   	nop
    cli();
}
  1016a8:	90                   	nop
  1016a9:	5d                   	pop    %ebp
  1016aa:	c3                   	ret    

001016ab <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ab:	55                   	push   %ebp
  1016ac:	89 e5                	mov    %esp,%ebp
  1016ae:	83 ec 14             	sub    $0x14,%esp
  1016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016bb:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016c1:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016c6:	85 c0                	test   %eax,%eax
  1016c8:	74 39                	je     101703 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016cd:	0f b6 c0             	movzbl %al,%eax
  1016d0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016d9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016dd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e1:	ee                   	out    %al,(%dx)
}
  1016e2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e7:	c1 e8 08             	shr    $0x8,%eax
  1016ea:	0f b7 c0             	movzwl %ax,%eax
  1016ed:	0f b6 c0             	movzbl %al,%eax
  1016f0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016f6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016f9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016fd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
}
  101702:	90                   	nop
    }
}
  101703:	90                   	nop
  101704:	89 ec                	mov    %ebp,%esp
  101706:	5d                   	pop    %ebp
  101707:	c3                   	ret    

00101708 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101708:	55                   	push   %ebp
  101709:	89 e5                	mov    %esp,%ebp
  10170b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170e:	8b 45 08             	mov    0x8(%ebp),%eax
  101711:	ba 01 00 00 00       	mov    $0x1,%edx
  101716:	88 c1                	mov    %al,%cl
  101718:	d3 e2                	shl    %cl,%edx
  10171a:	89 d0                	mov    %edx,%eax
  10171c:	98                   	cwtl   
  10171d:	f7 d0                	not    %eax
  10171f:	0f bf d0             	movswl %ax,%edx
  101722:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101729:	98                   	cwtl   
  10172a:	21 d0                	and    %edx,%eax
  10172c:	98                   	cwtl   
  10172d:	0f b7 c0             	movzwl %ax,%eax
  101730:	89 04 24             	mov    %eax,(%esp)
  101733:	e8 73 ff ff ff       	call   1016ab <pic_setmask>
}
  101738:	90                   	nop
  101739:	89 ec                	mov    %ebp,%esp
  10173b:	5d                   	pop    %ebp
  10173c:	c3                   	ret    

0010173d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173d:	55                   	push   %ebp
  10173e:	89 e5                	mov    %esp,%ebp
  101740:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101743:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10174a:	00 00 00 
  10174d:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101753:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101757:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10175b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10175f:	ee                   	out    %al,(%dx)
}
  101760:	90                   	nop
  101761:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101767:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10176b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10176f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
}
  101774:	90                   	nop
  101775:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10177b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10177f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101783:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101787:	ee                   	out    %al,(%dx)
}
  101788:	90                   	nop
  101789:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10178f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101793:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101797:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
}
  10179c:	90                   	nop
  10179d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017a3:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a7:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ab:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017af:	ee                   	out    %al,(%dx)
}
  1017b0:	90                   	nop
  1017b1:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017b7:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017bb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017bf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017c3:	ee                   	out    %al,(%dx)
}
  1017c4:	90                   	nop
  1017c5:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017cb:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017cf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
}
  1017d8:	90                   	nop
  1017d9:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017df:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017eb:	ee                   	out    %al,(%dx)
}
  1017ec:	90                   	nop
  1017ed:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017f3:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017fb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
}
  101800:	90                   	nop
  101801:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101807:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10180f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101813:	ee                   	out    %al,(%dx)
}
  101814:	90                   	nop
  101815:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10181b:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101823:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101827:	ee                   	out    %al,(%dx)
}
  101828:	90                   	nop
  101829:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10182f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101833:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101837:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
}
  10183c:	90                   	nop
  10183d:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101843:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101847:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10184b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10184f:	ee                   	out    %al,(%dx)
}
  101850:	90                   	nop
  101851:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101857:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10185f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101863:	ee                   	out    %al,(%dx)
}
  101864:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101865:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10186c:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101871:	74 0f                	je     101882 <pic_init+0x145>
        pic_setmask(irq_mask);
  101873:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10187a:	89 04 24             	mov    %eax,(%esp)
  10187d:	e8 29 fe ff ff       	call   1016ab <pic_setmask>
    }
}
  101882:	90                   	nop
  101883:	89 ec                	mov    %ebp,%esp
  101885:	5d                   	pop    %ebp
  101886:	c3                   	ret    

00101887 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101887:	55                   	push   %ebp
  101888:	89 e5                	mov    %esp,%ebp
  10188a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  10188d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101894:	00 
  101895:	c7 04 24 40 38 10 00 	movl   $0x103840,(%esp)
  10189c:	e8 7f ea ff ff       	call   100320 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018a1:	90                   	nop
  1018a2:	89 ec                	mov    %ebp,%esp
  1018a4:	5d                   	pop    %ebp
  1018a5:	c3                   	ret    

001018a6 <idt_init>:
        sizeof(idt) - 1, (uintptr_t) idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018a6:	55                   	push   %ebp
  1018a7:	89 e5                	mov    %esp,%ebp
  1018a9:	83 ec 28             	sub    $0x28,%esp
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */

    extern uintptr_t __vectors[];

    uintptr_t a = __vectors;
  1018ac:	c7 45 f0 e0 f5 10 00 	movl   $0x10f5e0,-0x10(%ebp)

    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
  1018b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1018ba:	e9 c4 00 00 00       	jmp    101983 <idt_init+0xdd>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL)
  1018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018c2:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018c9:	0f b7 d0             	movzwl %ax,%edx
  1018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018cf:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  1018d6:	00 
  1018d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018da:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  1018e1:	00 08 00 
  1018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018e7:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  1018ee:	00 
  1018ef:	80 e2 e0             	and    $0xe0,%dl
  1018f2:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1018fc:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  101903:	00 
  101904:	80 e2 1f             	and    $0x1f,%dl
  101907:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  10190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101911:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101918:	00 
  101919:	80 e2 f0             	and    $0xf0,%dl
  10191c:	80 ca 0e             	or     $0xe,%dl
  10191f:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101929:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101930:	00 
  101931:	80 e2 ef             	and    $0xef,%dl
  101934:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  10193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10193e:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101945:	00 
  101946:	80 e2 9f             	and    $0x9f,%dl
  101949:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101953:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  10195a:	00 
  10195b:	80 ca 80             	or     $0x80,%dl
  10195e:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101968:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10196f:	c1 e8 10             	shr    $0x10,%eax
  101972:	0f b7 d0             	movzwl %ax,%edx
  101975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101978:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  10197f:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(idt[0]); i++) {
  101980:	ff 45 f4             	incl   -0xc(%ebp)
  101983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101986:	3d ff 00 00 00       	cmp    $0xff,%eax
  10198b:	0f 86 2e ff ff ff    	jbe    1018bf <idt_init+0x19>
  101991:	c7 45 ec 60 f5 10 00 	movl   $0x10f560,-0x14(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10199b:	0f 01 18             	lidtl  (%eax)
}
  10199e:	90                   	nop
    }

    lidt(&idt_pd);

    cprintf("test");
  10199f:	c7 04 24 4a 38 10 00 	movl   $0x10384a,(%esp)
  1019a6:	e8 75 e9 ff ff       	call   100320 <cprintf>

}
  1019ab:	90                   	nop
  1019ac:	89 ec                	mov    %ebp,%esp
  1019ae:	5d                   	pop    %ebp
  1019af:	c3                   	ret    

001019b0 <trapname>:

static const char *
trapname(int trapno) {
  1019b0:	55                   	push   %ebp
  1019b1:	89 e5                	mov    %esp,%ebp
            "Alignment Check",
            "Machine-Check",
            "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames) / sizeof(const char *const)) {
  1019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b6:	83 f8 13             	cmp    $0x13,%eax
  1019b9:	77 0c                	ja     1019c7 <trapname+0x17>
        return excnames[trapno];
  1019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019be:	8b 04 85 a0 3b 10 00 	mov    0x103ba0(,%eax,4),%eax
  1019c5:	eb 18                	jmp    1019df <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019cb:	7e 0d                	jle    1019da <trapname+0x2a>
  1019cd:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019d1:	7f 07                	jg     1019da <trapname+0x2a>
        return "Hardware Interrupt";
  1019d3:	b8 4f 38 10 00       	mov    $0x10384f,%eax
  1019d8:	eb 05                	jmp    1019df <trapname+0x2f>
    }
    return "(unknown trap)";
  1019da:	b8 62 38 10 00       	mov    $0x103862,%eax
}
  1019df:	5d                   	pop    %ebp
  1019e0:	c3                   	ret    

001019e1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019e1:	55                   	push   %ebp
  1019e2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t) KERNEL_CS);
  1019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019eb:	83 f8 08             	cmp    $0x8,%eax
  1019ee:	0f 94 c0             	sete   %al
  1019f1:	0f b6 c0             	movzbl %al,%eax
}
  1019f4:	5d                   	pop    %ebp
  1019f5:	c3                   	ret    

001019f6 <print_trapframe>:
        "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
        "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f6:	55                   	push   %ebp
  1019f7:	89 e5                	mov    %esp,%ebp
  1019f9:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a03:	c7 04 24 a3 38 10 00 	movl   $0x1038a3,(%esp)
  101a0a:	e8 11 e9 ff ff       	call   100320 <cprintf>
    print_regs(&tf->tf_regs);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	89 04 24             	mov    %eax,(%esp)
  101a15:	e8 8f 01 00 00       	call   101ba9 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a25:	c7 04 24 b4 38 10 00 	movl   $0x1038b4,(%esp)
  101a2c:	e8 ef e8 ff ff       	call   100320 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3c:	c7 04 24 c7 38 10 00 	movl   $0x1038c7,(%esp)
  101a43:	e8 d8 e8 ff ff       	call   100320 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a53:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  101a5a:	e8 c1 e8 ff ff       	call   100320 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a62:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6a:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  101a71:	e8 aa e8 ff ff       	call   100320 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a76:	8b 45 08             	mov    0x8(%ebp),%eax
  101a79:	8b 40 30             	mov    0x30(%eax),%eax
  101a7c:	89 04 24             	mov    %eax,(%esp)
  101a7f:	e8 2c ff ff ff       	call   1019b0 <trapname>
  101a84:	8b 55 08             	mov    0x8(%ebp),%edx
  101a87:	8b 52 30             	mov    0x30(%edx),%edx
  101a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a92:	c7 04 24 00 39 10 00 	movl   $0x103900,(%esp)
  101a99:	e8 82 e8 ff ff       	call   100320 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa1:	8b 40 34             	mov    0x34(%eax),%eax
  101aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa8:	c7 04 24 12 39 10 00 	movl   $0x103912,(%esp)
  101aaf:	e8 6c e8 ff ff       	call   100320 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab7:	8b 40 38             	mov    0x38(%eax),%eax
  101aba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abe:	c7 04 24 21 39 10 00 	movl   $0x103921,(%esp)
  101ac5:	e8 56 e8 ff ff       	call   100320 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aca:	8b 45 08             	mov    0x8(%ebp),%eax
  101acd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad5:	c7 04 24 30 39 10 00 	movl   $0x103930,(%esp)
  101adc:	e8 3f e8 ff ff       	call   100320 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae4:	8b 40 40             	mov    0x40(%eax),%eax
  101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aeb:	c7 04 24 43 39 10 00 	movl   $0x103943,(%esp)
  101af2:	e8 29 e8 ff ff       	call   100320 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1) {
  101af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101afe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b05:	eb 3d                	jmp    101b44 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	8b 50 40             	mov    0x40(%eax),%edx
  101b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b10:	21 d0                	and    %edx,%eax
  101b12:	85 c0                	test   %eax,%eax
  101b14:	74 28                	je     101b3e <print_trapframe+0x148>
  101b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b19:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b20:	85 c0                	test   %eax,%eax
  101b22:	74 1a                	je     101b3e <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b27:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 52 39 10 00 	movl   $0x103952,(%esp)
  101b39:	e8 e2 e7 ff ff       	call   100320 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1) {
  101b3e:	ff 45 f4             	incl   -0xc(%ebp)
  101b41:	d1 65 f0             	shll   -0x10(%ebp)
  101b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b47:	83 f8 17             	cmp    $0x17,%eax
  101b4a:	76 bb                	jbe    101b07 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	8b 40 40             	mov    0x40(%eax),%eax
  101b52:	c1 e8 0c             	shr    $0xc,%eax
  101b55:	83 e0 03             	and    $0x3,%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 56 39 10 00 	movl   $0x103956,(%esp)
  101b63:	e8 b8 e7 ff ff       	call   100320 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	89 04 24             	mov    %eax,(%esp)
  101b6e:	e8 6e fe ff ff       	call   1019e1 <trap_in_kernel>
  101b73:	85 c0                	test   %eax,%eax
  101b75:	75 2d                	jne    101ba4 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b77:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7a:	8b 40 44             	mov    0x44(%eax),%eax
  101b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b81:	c7 04 24 5f 39 10 00 	movl   $0x10395f,(%esp)
  101b88:	e8 93 e7 ff ff       	call   100320 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b90:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b98:	c7 04 24 6e 39 10 00 	movl   $0x10396e,(%esp)
  101b9f:	e8 7c e7 ff ff       	call   100320 <cprintf>
    }
}
  101ba4:	90                   	nop
  101ba5:	89 ec                	mov    %ebp,%esp
  101ba7:	5d                   	pop    %ebp
  101ba8:	c3                   	ret    

00101ba9 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ba9:	55                   	push   %ebp
  101baa:	89 e5                	mov    %esp,%ebp
  101bac:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101baf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb2:	8b 00                	mov    (%eax),%eax
  101bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb8:	c7 04 24 81 39 10 00 	movl   $0x103981,(%esp)
  101bbf:	e8 5c e7 ff ff       	call   100320 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc7:	8b 40 04             	mov    0x4(%eax),%eax
  101bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bce:	c7 04 24 90 39 10 00 	movl   $0x103990,(%esp)
  101bd5:	e8 46 e7 ff ff       	call   100320 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 08             	mov    0x8(%eax),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 9f 39 10 00 	movl   $0x10399f,(%esp)
  101beb:	e8 30 e7 ff ff       	call   100320 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	8b 40 0c             	mov    0xc(%eax),%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 ae 39 10 00 	movl   $0x1039ae,(%esp)
  101c01:	e8 1a e7 ff ff       	call   100320 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 10             	mov    0x10(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 bd 39 10 00 	movl   $0x1039bd,(%esp)
  101c17:	e8 04 e7 ff ff       	call   100320 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	8b 40 14             	mov    0x14(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 cc 39 10 00 	movl   $0x1039cc,(%esp)
  101c2d:	e8 ee e6 ff ff       	call   100320 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 18             	mov    0x18(%eax),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 db 39 10 00 	movl   $0x1039db,(%esp)
  101c43:	e8 d8 e6 ff ff       	call   100320 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c48:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4b:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 ea 39 10 00 	movl   $0x1039ea,(%esp)
  101c59:	e8 c2 e6 ff ff       	call   100320 <cprintf>
}
  101c5e:	90                   	nop
  101c5f:	89 ec                	mov    %ebp,%esp
  101c61:	5d                   	pop    %ebp
  101c62:	c3                   	ret    

00101c63 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c63:	55                   	push   %ebp
  101c64:	89 e5                	mov    %esp,%ebp
  101c66:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	8b 40 30             	mov    0x30(%eax),%eax
  101c6f:	83 f8 79             	cmp    $0x79,%eax
  101c72:	0f 87 e6 00 00 00    	ja     101d5e <trap_dispatch+0xfb>
  101c78:	83 f8 78             	cmp    $0x78,%eax
  101c7b:	0f 83 c1 00 00 00    	jae    101d42 <trap_dispatch+0xdf>
  101c81:	83 f8 2f             	cmp    $0x2f,%eax
  101c84:	0f 87 d4 00 00 00    	ja     101d5e <trap_dispatch+0xfb>
  101c8a:	83 f8 2e             	cmp    $0x2e,%eax
  101c8d:	0f 83 00 01 00 00    	jae    101d93 <trap_dispatch+0x130>
  101c93:	83 f8 24             	cmp    $0x24,%eax
  101c96:	74 5e                	je     101cf6 <trap_dispatch+0x93>
  101c98:	83 f8 24             	cmp    $0x24,%eax
  101c9b:	0f 87 bd 00 00 00    	ja     101d5e <trap_dispatch+0xfb>
  101ca1:	83 f8 20             	cmp    $0x20,%eax
  101ca4:	74 0a                	je     101cb0 <trap_dispatch+0x4d>
  101ca6:	83 f8 21             	cmp    $0x21,%eax
  101ca9:	74 71                	je     101d1c <trap_dispatch+0xb9>
  101cab:	e9 ae 00 00 00       	jmp    101d5e <trap_dispatch+0xfb>
             * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
             * (3) Too Simple? Yes, I think so!
             */

            extern volatile size_t ticks;
            ticks++;
  101cb0:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101cb5:	40                   	inc    %eax
  101cb6:	a3 44 fe 10 00       	mov    %eax,0x10fe44
            if (ticks % TICK_NUM == 0){
  101cbb:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101cc1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc6:	89 c8                	mov    %ecx,%eax
  101cc8:	f7 e2                	mul    %edx
  101cca:	c1 ea 05             	shr    $0x5,%edx
  101ccd:	89 d0                	mov    %edx,%eax
  101ccf:	c1 e0 02             	shl    $0x2,%eax
  101cd2:	01 d0                	add    %edx,%eax
  101cd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101cdb:	01 d0                	add    %edx,%eax
  101cdd:	c1 e0 02             	shl    $0x2,%eax
  101ce0:	29 c1                	sub    %eax,%ecx
  101ce2:	89 ca                	mov    %ecx,%edx
  101ce4:	85 d2                	test   %edx,%edx
  101ce6:	0f 85 aa 00 00 00    	jne    101d96 <trap_dispatch+0x133>
                print_ticks();
  101cec:	e8 96 fb ff ff       	call   101887 <print_ticks>
            }



            break;
  101cf1:	e9 a0 00 00 00       	jmp    101d96 <trap_dispatch+0x133>
        case IRQ_OFFSET + IRQ_COM1:
            c = cons_getc();
  101cf6:	e8 42 f9 ff ff       	call   10163d <cons_getc>
  101cfb:	88 45 f7             	mov    %al,-0x9(%ebp)
            cprintf("serial [%03d] %c\n", c, c);
  101cfe:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d02:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d06:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0e:	c7 04 24 f9 39 10 00 	movl   $0x1039f9,(%esp)
  101d15:	e8 06 e6 ff ff       	call   100320 <cprintf>
            break;
  101d1a:	eb 7b                	jmp    101d97 <trap_dispatch+0x134>
        case IRQ_OFFSET + IRQ_KBD:
            c = cons_getc();
  101d1c:	e8 1c f9 ff ff       	call   10163d <cons_getc>
  101d21:	88 45 f7             	mov    %al,-0x9(%ebp)
            cprintf("kbd [%03d] %c\n", c, c);
  101d24:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d28:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d2c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d34:	c7 04 24 0b 3a 10 00 	movl   $0x103a0b,(%esp)
  101d3b:	e8 e0 e5 ff ff       	call   100320 <cprintf>
            break;
  101d40:	eb 55                	jmp    101d97 <trap_dispatch+0x134>
            //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
        case T_SWITCH_TOU:
        case T_SWITCH_TOK:
            panic("T_SWITCH_** ??\n");
  101d42:	c7 44 24 08 1a 3a 10 	movl   $0x103a1a,0x8(%esp)
  101d49:	00 
  101d4a:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101d51:	00 
  101d52:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101d59:	e8 54 ef ff ff       	call   100cb2 <__panic>
        case IRQ_OFFSET + IRQ_IDE2:
            /* do nothing */
            break;
        default:
            // in kernel, it must be a mistake
            if ((tf->tf_cs & 3) == 0) {
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d65:	83 e0 03             	and    $0x3,%eax
  101d68:	85 c0                	test   %eax,%eax
  101d6a:	75 2b                	jne    101d97 <trap_dispatch+0x134>
                print_trapframe(tf);
  101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6f:	89 04 24             	mov    %eax,(%esp)
  101d72:	e8 7f fc ff ff       	call   1019f6 <print_trapframe>
                panic("unexpected trap in kernel.\n");
  101d77:	c7 44 24 08 3b 3a 10 	movl   $0x103a3b,0x8(%esp)
  101d7e:	00 
  101d7f:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  101d86:	00 
  101d87:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101d8e:	e8 1f ef ff ff       	call   100cb2 <__panic>
            break;
  101d93:	90                   	nop
  101d94:	eb 01                	jmp    101d97 <trap_dispatch+0x134>
            break;
  101d96:	90                   	nop
            }
    }
}
  101d97:	90                   	nop
  101d98:	89 ec                	mov    %ebp,%esp
  101d9a:	5d                   	pop    %ebp
  101d9b:	c3                   	ret    

00101d9c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d9c:	55                   	push   %ebp
  101d9d:	89 e5                	mov    %esp,%ebp
  101d9f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	89 04 24             	mov    %eax,(%esp)
  101da8:	e8 b6 fe ff ff       	call   101c63 <trap_dispatch>
}
  101dad:	90                   	nop
  101dae:	89 ec                	mov    %ebp,%esp
  101db0:	5d                   	pop    %ebp
  101db1:	c3                   	ret    

00101db2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101db2:	1e                   	push   %ds
    pushl %es
  101db3:	06                   	push   %es
    pushl %fs
  101db4:	0f a0                	push   %fs
    pushl %gs
  101db6:	0f a8                	push   %gs
    pushal
  101db8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101db9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101dbe:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101dc0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dc2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dc3:	e8 d4 ff ff ff       	call   101d9c <trap>

    # pop the pushed stack pointer
    popl %esp
  101dc8:	5c                   	pop    %esp

00101dc9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dc9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dca:	0f a9                	pop    %gs
    popl %fs
  101dcc:	0f a1                	pop    %fs
    popl %es
  101dce:	07                   	pop    %es
    popl %ds
  101dcf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dd0:	83 c4 08             	add    $0x8,%esp
    iret
  101dd3:	cf                   	iret   

00101dd4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dd4:	6a 00                	push   $0x0
  pushl $0
  101dd6:	6a 00                	push   $0x0
  jmp __alltraps
  101dd8:	e9 d5 ff ff ff       	jmp    101db2 <__alltraps>

00101ddd <vector1>:
.globl vector1
vector1:
  pushl $0
  101ddd:	6a 00                	push   $0x0
  pushl $1
  101ddf:	6a 01                	push   $0x1
  jmp __alltraps
  101de1:	e9 cc ff ff ff       	jmp    101db2 <__alltraps>

00101de6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $2
  101de8:	6a 02                	push   $0x2
  jmp __alltraps
  101dea:	e9 c3 ff ff ff       	jmp    101db2 <__alltraps>

00101def <vector3>:
.globl vector3
vector3:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $3
  101df1:	6a 03                	push   $0x3
  jmp __alltraps
  101df3:	e9 ba ff ff ff       	jmp    101db2 <__alltraps>

00101df8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $4
  101dfa:	6a 04                	push   $0x4
  jmp __alltraps
  101dfc:	e9 b1 ff ff ff       	jmp    101db2 <__alltraps>

00101e01 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $5
  101e03:	6a 05                	push   $0x5
  jmp __alltraps
  101e05:	e9 a8 ff ff ff       	jmp    101db2 <__alltraps>

00101e0a <vector6>:
.globl vector6
vector6:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $6
  101e0c:	6a 06                	push   $0x6
  jmp __alltraps
  101e0e:	e9 9f ff ff ff       	jmp    101db2 <__alltraps>

00101e13 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $7
  101e15:	6a 07                	push   $0x7
  jmp __alltraps
  101e17:	e9 96 ff ff ff       	jmp    101db2 <__alltraps>

00101e1c <vector8>:
.globl vector8
vector8:
  pushl $8
  101e1c:	6a 08                	push   $0x8
  jmp __alltraps
  101e1e:	e9 8f ff ff ff       	jmp    101db2 <__alltraps>

00101e23 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e23:	6a 00                	push   $0x0
  pushl $9
  101e25:	6a 09                	push   $0x9
  jmp __alltraps
  101e27:	e9 86 ff ff ff       	jmp    101db2 <__alltraps>

00101e2c <vector10>:
.globl vector10
vector10:
  pushl $10
  101e2c:	6a 0a                	push   $0xa
  jmp __alltraps
  101e2e:	e9 7f ff ff ff       	jmp    101db2 <__alltraps>

00101e33 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e33:	6a 0b                	push   $0xb
  jmp __alltraps
  101e35:	e9 78 ff ff ff       	jmp    101db2 <__alltraps>

00101e3a <vector12>:
.globl vector12
vector12:
  pushl $12
  101e3a:	6a 0c                	push   $0xc
  jmp __alltraps
  101e3c:	e9 71 ff ff ff       	jmp    101db2 <__alltraps>

00101e41 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e41:	6a 0d                	push   $0xd
  jmp __alltraps
  101e43:	e9 6a ff ff ff       	jmp    101db2 <__alltraps>

00101e48 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e48:	6a 0e                	push   $0xe
  jmp __alltraps
  101e4a:	e9 63 ff ff ff       	jmp    101db2 <__alltraps>

00101e4f <vector15>:
.globl vector15
vector15:
  pushl $0
  101e4f:	6a 00                	push   $0x0
  pushl $15
  101e51:	6a 0f                	push   $0xf
  jmp __alltraps
  101e53:	e9 5a ff ff ff       	jmp    101db2 <__alltraps>

00101e58 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e58:	6a 00                	push   $0x0
  pushl $16
  101e5a:	6a 10                	push   $0x10
  jmp __alltraps
  101e5c:	e9 51 ff ff ff       	jmp    101db2 <__alltraps>

00101e61 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e61:	6a 11                	push   $0x11
  jmp __alltraps
  101e63:	e9 4a ff ff ff       	jmp    101db2 <__alltraps>

00101e68 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $18
  101e6a:	6a 12                	push   $0x12
  jmp __alltraps
  101e6c:	e9 41 ff ff ff       	jmp    101db2 <__alltraps>

00101e71 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $19
  101e73:	6a 13                	push   $0x13
  jmp __alltraps
  101e75:	e9 38 ff ff ff       	jmp    101db2 <__alltraps>

00101e7a <vector20>:
.globl vector20
vector20:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $20
  101e7c:	6a 14                	push   $0x14
  jmp __alltraps
  101e7e:	e9 2f ff ff ff       	jmp    101db2 <__alltraps>

00101e83 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $21
  101e85:	6a 15                	push   $0x15
  jmp __alltraps
  101e87:	e9 26 ff ff ff       	jmp    101db2 <__alltraps>

00101e8c <vector22>:
.globl vector22
vector22:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $22
  101e8e:	6a 16                	push   $0x16
  jmp __alltraps
  101e90:	e9 1d ff ff ff       	jmp    101db2 <__alltraps>

00101e95 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $23
  101e97:	6a 17                	push   $0x17
  jmp __alltraps
  101e99:	e9 14 ff ff ff       	jmp    101db2 <__alltraps>

00101e9e <vector24>:
.globl vector24
vector24:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $24
  101ea0:	6a 18                	push   $0x18
  jmp __alltraps
  101ea2:	e9 0b ff ff ff       	jmp    101db2 <__alltraps>

00101ea7 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $25
  101ea9:	6a 19                	push   $0x19
  jmp __alltraps
  101eab:	e9 02 ff ff ff       	jmp    101db2 <__alltraps>

00101eb0 <vector26>:
.globl vector26
vector26:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $26
  101eb2:	6a 1a                	push   $0x1a
  jmp __alltraps
  101eb4:	e9 f9 fe ff ff       	jmp    101db2 <__alltraps>

00101eb9 <vector27>:
.globl vector27
vector27:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $27
  101ebb:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ebd:	e9 f0 fe ff ff       	jmp    101db2 <__alltraps>

00101ec2 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $28
  101ec4:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ec6:	e9 e7 fe ff ff       	jmp    101db2 <__alltraps>

00101ecb <vector29>:
.globl vector29
vector29:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $29
  101ecd:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ecf:	e9 de fe ff ff       	jmp    101db2 <__alltraps>

00101ed4 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $30
  101ed6:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ed8:	e9 d5 fe ff ff       	jmp    101db2 <__alltraps>

00101edd <vector31>:
.globl vector31
vector31:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $31
  101edf:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ee1:	e9 cc fe ff ff       	jmp    101db2 <__alltraps>

00101ee6 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $32
  101ee8:	6a 20                	push   $0x20
  jmp __alltraps
  101eea:	e9 c3 fe ff ff       	jmp    101db2 <__alltraps>

00101eef <vector33>:
.globl vector33
vector33:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $33
  101ef1:	6a 21                	push   $0x21
  jmp __alltraps
  101ef3:	e9 ba fe ff ff       	jmp    101db2 <__alltraps>

00101ef8 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $34
  101efa:	6a 22                	push   $0x22
  jmp __alltraps
  101efc:	e9 b1 fe ff ff       	jmp    101db2 <__alltraps>

00101f01 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $35
  101f03:	6a 23                	push   $0x23
  jmp __alltraps
  101f05:	e9 a8 fe ff ff       	jmp    101db2 <__alltraps>

00101f0a <vector36>:
.globl vector36
vector36:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $36
  101f0c:	6a 24                	push   $0x24
  jmp __alltraps
  101f0e:	e9 9f fe ff ff       	jmp    101db2 <__alltraps>

00101f13 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $37
  101f15:	6a 25                	push   $0x25
  jmp __alltraps
  101f17:	e9 96 fe ff ff       	jmp    101db2 <__alltraps>

00101f1c <vector38>:
.globl vector38
vector38:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $38
  101f1e:	6a 26                	push   $0x26
  jmp __alltraps
  101f20:	e9 8d fe ff ff       	jmp    101db2 <__alltraps>

00101f25 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $39
  101f27:	6a 27                	push   $0x27
  jmp __alltraps
  101f29:	e9 84 fe ff ff       	jmp    101db2 <__alltraps>

00101f2e <vector40>:
.globl vector40
vector40:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $40
  101f30:	6a 28                	push   $0x28
  jmp __alltraps
  101f32:	e9 7b fe ff ff       	jmp    101db2 <__alltraps>

00101f37 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $41
  101f39:	6a 29                	push   $0x29
  jmp __alltraps
  101f3b:	e9 72 fe ff ff       	jmp    101db2 <__alltraps>

00101f40 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $42
  101f42:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f44:	e9 69 fe ff ff       	jmp    101db2 <__alltraps>

00101f49 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $43
  101f4b:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f4d:	e9 60 fe ff ff       	jmp    101db2 <__alltraps>

00101f52 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $44
  101f54:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f56:	e9 57 fe ff ff       	jmp    101db2 <__alltraps>

00101f5b <vector45>:
.globl vector45
vector45:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $45
  101f5d:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f5f:	e9 4e fe ff ff       	jmp    101db2 <__alltraps>

00101f64 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $46
  101f66:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f68:	e9 45 fe ff ff       	jmp    101db2 <__alltraps>

00101f6d <vector47>:
.globl vector47
vector47:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $47
  101f6f:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f71:	e9 3c fe ff ff       	jmp    101db2 <__alltraps>

00101f76 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $48
  101f78:	6a 30                	push   $0x30
  jmp __alltraps
  101f7a:	e9 33 fe ff ff       	jmp    101db2 <__alltraps>

00101f7f <vector49>:
.globl vector49
vector49:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $49
  101f81:	6a 31                	push   $0x31
  jmp __alltraps
  101f83:	e9 2a fe ff ff       	jmp    101db2 <__alltraps>

00101f88 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $50
  101f8a:	6a 32                	push   $0x32
  jmp __alltraps
  101f8c:	e9 21 fe ff ff       	jmp    101db2 <__alltraps>

00101f91 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $51
  101f93:	6a 33                	push   $0x33
  jmp __alltraps
  101f95:	e9 18 fe ff ff       	jmp    101db2 <__alltraps>

00101f9a <vector52>:
.globl vector52
vector52:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $52
  101f9c:	6a 34                	push   $0x34
  jmp __alltraps
  101f9e:	e9 0f fe ff ff       	jmp    101db2 <__alltraps>

00101fa3 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $53
  101fa5:	6a 35                	push   $0x35
  jmp __alltraps
  101fa7:	e9 06 fe ff ff       	jmp    101db2 <__alltraps>

00101fac <vector54>:
.globl vector54
vector54:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $54
  101fae:	6a 36                	push   $0x36
  jmp __alltraps
  101fb0:	e9 fd fd ff ff       	jmp    101db2 <__alltraps>

00101fb5 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $55
  101fb7:	6a 37                	push   $0x37
  jmp __alltraps
  101fb9:	e9 f4 fd ff ff       	jmp    101db2 <__alltraps>

00101fbe <vector56>:
.globl vector56
vector56:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $56
  101fc0:	6a 38                	push   $0x38
  jmp __alltraps
  101fc2:	e9 eb fd ff ff       	jmp    101db2 <__alltraps>

00101fc7 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $57
  101fc9:	6a 39                	push   $0x39
  jmp __alltraps
  101fcb:	e9 e2 fd ff ff       	jmp    101db2 <__alltraps>

00101fd0 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $58
  101fd2:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fd4:	e9 d9 fd ff ff       	jmp    101db2 <__alltraps>

00101fd9 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $59
  101fdb:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fdd:	e9 d0 fd ff ff       	jmp    101db2 <__alltraps>

00101fe2 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $60
  101fe4:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fe6:	e9 c7 fd ff ff       	jmp    101db2 <__alltraps>

00101feb <vector61>:
.globl vector61
vector61:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $61
  101fed:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fef:	e9 be fd ff ff       	jmp    101db2 <__alltraps>

00101ff4 <vector62>:
.globl vector62
vector62:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $62
  101ff6:	6a 3e                	push   $0x3e
  jmp __alltraps
  101ff8:	e9 b5 fd ff ff       	jmp    101db2 <__alltraps>

00101ffd <vector63>:
.globl vector63
vector63:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $63
  101fff:	6a 3f                	push   $0x3f
  jmp __alltraps
  102001:	e9 ac fd ff ff       	jmp    101db2 <__alltraps>

00102006 <vector64>:
.globl vector64
vector64:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $64
  102008:	6a 40                	push   $0x40
  jmp __alltraps
  10200a:	e9 a3 fd ff ff       	jmp    101db2 <__alltraps>

0010200f <vector65>:
.globl vector65
vector65:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $65
  102011:	6a 41                	push   $0x41
  jmp __alltraps
  102013:	e9 9a fd ff ff       	jmp    101db2 <__alltraps>

00102018 <vector66>:
.globl vector66
vector66:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $66
  10201a:	6a 42                	push   $0x42
  jmp __alltraps
  10201c:	e9 91 fd ff ff       	jmp    101db2 <__alltraps>

00102021 <vector67>:
.globl vector67
vector67:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $67
  102023:	6a 43                	push   $0x43
  jmp __alltraps
  102025:	e9 88 fd ff ff       	jmp    101db2 <__alltraps>

0010202a <vector68>:
.globl vector68
vector68:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $68
  10202c:	6a 44                	push   $0x44
  jmp __alltraps
  10202e:	e9 7f fd ff ff       	jmp    101db2 <__alltraps>

00102033 <vector69>:
.globl vector69
vector69:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $69
  102035:	6a 45                	push   $0x45
  jmp __alltraps
  102037:	e9 76 fd ff ff       	jmp    101db2 <__alltraps>

0010203c <vector70>:
.globl vector70
vector70:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $70
  10203e:	6a 46                	push   $0x46
  jmp __alltraps
  102040:	e9 6d fd ff ff       	jmp    101db2 <__alltraps>

00102045 <vector71>:
.globl vector71
vector71:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $71
  102047:	6a 47                	push   $0x47
  jmp __alltraps
  102049:	e9 64 fd ff ff       	jmp    101db2 <__alltraps>

0010204e <vector72>:
.globl vector72
vector72:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $72
  102050:	6a 48                	push   $0x48
  jmp __alltraps
  102052:	e9 5b fd ff ff       	jmp    101db2 <__alltraps>

00102057 <vector73>:
.globl vector73
vector73:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $73
  102059:	6a 49                	push   $0x49
  jmp __alltraps
  10205b:	e9 52 fd ff ff       	jmp    101db2 <__alltraps>

00102060 <vector74>:
.globl vector74
vector74:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $74
  102062:	6a 4a                	push   $0x4a
  jmp __alltraps
  102064:	e9 49 fd ff ff       	jmp    101db2 <__alltraps>

00102069 <vector75>:
.globl vector75
vector75:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $75
  10206b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10206d:	e9 40 fd ff ff       	jmp    101db2 <__alltraps>

00102072 <vector76>:
.globl vector76
vector76:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $76
  102074:	6a 4c                	push   $0x4c
  jmp __alltraps
  102076:	e9 37 fd ff ff       	jmp    101db2 <__alltraps>

0010207b <vector77>:
.globl vector77
vector77:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $77
  10207d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10207f:	e9 2e fd ff ff       	jmp    101db2 <__alltraps>

00102084 <vector78>:
.globl vector78
vector78:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $78
  102086:	6a 4e                	push   $0x4e
  jmp __alltraps
  102088:	e9 25 fd ff ff       	jmp    101db2 <__alltraps>

0010208d <vector79>:
.globl vector79
vector79:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $79
  10208f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102091:	e9 1c fd ff ff       	jmp    101db2 <__alltraps>

00102096 <vector80>:
.globl vector80
vector80:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $80
  102098:	6a 50                	push   $0x50
  jmp __alltraps
  10209a:	e9 13 fd ff ff       	jmp    101db2 <__alltraps>

0010209f <vector81>:
.globl vector81
vector81:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $81
  1020a1:	6a 51                	push   $0x51
  jmp __alltraps
  1020a3:	e9 0a fd ff ff       	jmp    101db2 <__alltraps>

001020a8 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $82
  1020aa:	6a 52                	push   $0x52
  jmp __alltraps
  1020ac:	e9 01 fd ff ff       	jmp    101db2 <__alltraps>

001020b1 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $83
  1020b3:	6a 53                	push   $0x53
  jmp __alltraps
  1020b5:	e9 f8 fc ff ff       	jmp    101db2 <__alltraps>

001020ba <vector84>:
.globl vector84
vector84:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $84
  1020bc:	6a 54                	push   $0x54
  jmp __alltraps
  1020be:	e9 ef fc ff ff       	jmp    101db2 <__alltraps>

001020c3 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $85
  1020c5:	6a 55                	push   $0x55
  jmp __alltraps
  1020c7:	e9 e6 fc ff ff       	jmp    101db2 <__alltraps>

001020cc <vector86>:
.globl vector86
vector86:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $86
  1020ce:	6a 56                	push   $0x56
  jmp __alltraps
  1020d0:	e9 dd fc ff ff       	jmp    101db2 <__alltraps>

001020d5 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $87
  1020d7:	6a 57                	push   $0x57
  jmp __alltraps
  1020d9:	e9 d4 fc ff ff       	jmp    101db2 <__alltraps>

001020de <vector88>:
.globl vector88
vector88:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $88
  1020e0:	6a 58                	push   $0x58
  jmp __alltraps
  1020e2:	e9 cb fc ff ff       	jmp    101db2 <__alltraps>

001020e7 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $89
  1020e9:	6a 59                	push   $0x59
  jmp __alltraps
  1020eb:	e9 c2 fc ff ff       	jmp    101db2 <__alltraps>

001020f0 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $90
  1020f2:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020f4:	e9 b9 fc ff ff       	jmp    101db2 <__alltraps>

001020f9 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $91
  1020fb:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020fd:	e9 b0 fc ff ff       	jmp    101db2 <__alltraps>

00102102 <vector92>:
.globl vector92
vector92:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $92
  102104:	6a 5c                	push   $0x5c
  jmp __alltraps
  102106:	e9 a7 fc ff ff       	jmp    101db2 <__alltraps>

0010210b <vector93>:
.globl vector93
vector93:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $93
  10210d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10210f:	e9 9e fc ff ff       	jmp    101db2 <__alltraps>

00102114 <vector94>:
.globl vector94
vector94:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $94
  102116:	6a 5e                	push   $0x5e
  jmp __alltraps
  102118:	e9 95 fc ff ff       	jmp    101db2 <__alltraps>

0010211d <vector95>:
.globl vector95
vector95:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $95
  10211f:	6a 5f                	push   $0x5f
  jmp __alltraps
  102121:	e9 8c fc ff ff       	jmp    101db2 <__alltraps>

00102126 <vector96>:
.globl vector96
vector96:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $96
  102128:	6a 60                	push   $0x60
  jmp __alltraps
  10212a:	e9 83 fc ff ff       	jmp    101db2 <__alltraps>

0010212f <vector97>:
.globl vector97
vector97:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $97
  102131:	6a 61                	push   $0x61
  jmp __alltraps
  102133:	e9 7a fc ff ff       	jmp    101db2 <__alltraps>

00102138 <vector98>:
.globl vector98
vector98:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $98
  10213a:	6a 62                	push   $0x62
  jmp __alltraps
  10213c:	e9 71 fc ff ff       	jmp    101db2 <__alltraps>

00102141 <vector99>:
.globl vector99
vector99:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $99
  102143:	6a 63                	push   $0x63
  jmp __alltraps
  102145:	e9 68 fc ff ff       	jmp    101db2 <__alltraps>

0010214a <vector100>:
.globl vector100
vector100:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $100
  10214c:	6a 64                	push   $0x64
  jmp __alltraps
  10214e:	e9 5f fc ff ff       	jmp    101db2 <__alltraps>

00102153 <vector101>:
.globl vector101
vector101:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $101
  102155:	6a 65                	push   $0x65
  jmp __alltraps
  102157:	e9 56 fc ff ff       	jmp    101db2 <__alltraps>

0010215c <vector102>:
.globl vector102
vector102:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $102
  10215e:	6a 66                	push   $0x66
  jmp __alltraps
  102160:	e9 4d fc ff ff       	jmp    101db2 <__alltraps>

00102165 <vector103>:
.globl vector103
vector103:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $103
  102167:	6a 67                	push   $0x67
  jmp __alltraps
  102169:	e9 44 fc ff ff       	jmp    101db2 <__alltraps>

0010216e <vector104>:
.globl vector104
vector104:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $104
  102170:	6a 68                	push   $0x68
  jmp __alltraps
  102172:	e9 3b fc ff ff       	jmp    101db2 <__alltraps>

00102177 <vector105>:
.globl vector105
vector105:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $105
  102179:	6a 69                	push   $0x69
  jmp __alltraps
  10217b:	e9 32 fc ff ff       	jmp    101db2 <__alltraps>

00102180 <vector106>:
.globl vector106
vector106:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $106
  102182:	6a 6a                	push   $0x6a
  jmp __alltraps
  102184:	e9 29 fc ff ff       	jmp    101db2 <__alltraps>

00102189 <vector107>:
.globl vector107
vector107:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $107
  10218b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10218d:	e9 20 fc ff ff       	jmp    101db2 <__alltraps>

00102192 <vector108>:
.globl vector108
vector108:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $108
  102194:	6a 6c                	push   $0x6c
  jmp __alltraps
  102196:	e9 17 fc ff ff       	jmp    101db2 <__alltraps>

0010219b <vector109>:
.globl vector109
vector109:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $109
  10219d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10219f:	e9 0e fc ff ff       	jmp    101db2 <__alltraps>

001021a4 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $110
  1021a6:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021a8:	e9 05 fc ff ff       	jmp    101db2 <__alltraps>

001021ad <vector111>:
.globl vector111
vector111:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $111
  1021af:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021b1:	e9 fc fb ff ff       	jmp    101db2 <__alltraps>

001021b6 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $112
  1021b8:	6a 70                	push   $0x70
  jmp __alltraps
  1021ba:	e9 f3 fb ff ff       	jmp    101db2 <__alltraps>

001021bf <vector113>:
.globl vector113
vector113:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $113
  1021c1:	6a 71                	push   $0x71
  jmp __alltraps
  1021c3:	e9 ea fb ff ff       	jmp    101db2 <__alltraps>

001021c8 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $114
  1021ca:	6a 72                	push   $0x72
  jmp __alltraps
  1021cc:	e9 e1 fb ff ff       	jmp    101db2 <__alltraps>

001021d1 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $115
  1021d3:	6a 73                	push   $0x73
  jmp __alltraps
  1021d5:	e9 d8 fb ff ff       	jmp    101db2 <__alltraps>

001021da <vector116>:
.globl vector116
vector116:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $116
  1021dc:	6a 74                	push   $0x74
  jmp __alltraps
  1021de:	e9 cf fb ff ff       	jmp    101db2 <__alltraps>

001021e3 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $117
  1021e5:	6a 75                	push   $0x75
  jmp __alltraps
  1021e7:	e9 c6 fb ff ff       	jmp    101db2 <__alltraps>

001021ec <vector118>:
.globl vector118
vector118:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $118
  1021ee:	6a 76                	push   $0x76
  jmp __alltraps
  1021f0:	e9 bd fb ff ff       	jmp    101db2 <__alltraps>

001021f5 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $119
  1021f7:	6a 77                	push   $0x77
  jmp __alltraps
  1021f9:	e9 b4 fb ff ff       	jmp    101db2 <__alltraps>

001021fe <vector120>:
.globl vector120
vector120:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $120
  102200:	6a 78                	push   $0x78
  jmp __alltraps
  102202:	e9 ab fb ff ff       	jmp    101db2 <__alltraps>

00102207 <vector121>:
.globl vector121
vector121:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $121
  102209:	6a 79                	push   $0x79
  jmp __alltraps
  10220b:	e9 a2 fb ff ff       	jmp    101db2 <__alltraps>

00102210 <vector122>:
.globl vector122
vector122:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $122
  102212:	6a 7a                	push   $0x7a
  jmp __alltraps
  102214:	e9 99 fb ff ff       	jmp    101db2 <__alltraps>

00102219 <vector123>:
.globl vector123
vector123:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $123
  10221b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10221d:	e9 90 fb ff ff       	jmp    101db2 <__alltraps>

00102222 <vector124>:
.globl vector124
vector124:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $124
  102224:	6a 7c                	push   $0x7c
  jmp __alltraps
  102226:	e9 87 fb ff ff       	jmp    101db2 <__alltraps>

0010222b <vector125>:
.globl vector125
vector125:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $125
  10222d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10222f:	e9 7e fb ff ff       	jmp    101db2 <__alltraps>

00102234 <vector126>:
.globl vector126
vector126:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $126
  102236:	6a 7e                	push   $0x7e
  jmp __alltraps
  102238:	e9 75 fb ff ff       	jmp    101db2 <__alltraps>

0010223d <vector127>:
.globl vector127
vector127:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $127
  10223f:	6a 7f                	push   $0x7f
  jmp __alltraps
  102241:	e9 6c fb ff ff       	jmp    101db2 <__alltraps>

00102246 <vector128>:
.globl vector128
vector128:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $128
  102248:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10224d:	e9 60 fb ff ff       	jmp    101db2 <__alltraps>

00102252 <vector129>:
.globl vector129
vector129:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $129
  102254:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102259:	e9 54 fb ff ff       	jmp    101db2 <__alltraps>

0010225e <vector130>:
.globl vector130
vector130:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $130
  102260:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102265:	e9 48 fb ff ff       	jmp    101db2 <__alltraps>

0010226a <vector131>:
.globl vector131
vector131:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $131
  10226c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102271:	e9 3c fb ff ff       	jmp    101db2 <__alltraps>

00102276 <vector132>:
.globl vector132
vector132:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $132
  102278:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10227d:	e9 30 fb ff ff       	jmp    101db2 <__alltraps>

00102282 <vector133>:
.globl vector133
vector133:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $133
  102284:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102289:	e9 24 fb ff ff       	jmp    101db2 <__alltraps>

0010228e <vector134>:
.globl vector134
vector134:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $134
  102290:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102295:	e9 18 fb ff ff       	jmp    101db2 <__alltraps>

0010229a <vector135>:
.globl vector135
vector135:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $135
  10229c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022a1:	e9 0c fb ff ff       	jmp    101db2 <__alltraps>

001022a6 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $136
  1022a8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022ad:	e9 00 fb ff ff       	jmp    101db2 <__alltraps>

001022b2 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $137
  1022b4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022b9:	e9 f4 fa ff ff       	jmp    101db2 <__alltraps>

001022be <vector138>:
.globl vector138
vector138:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $138
  1022c0:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022c5:	e9 e8 fa ff ff       	jmp    101db2 <__alltraps>

001022ca <vector139>:
.globl vector139
vector139:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $139
  1022cc:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022d1:	e9 dc fa ff ff       	jmp    101db2 <__alltraps>

001022d6 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $140
  1022d8:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022dd:	e9 d0 fa ff ff       	jmp    101db2 <__alltraps>

001022e2 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $141
  1022e4:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022e9:	e9 c4 fa ff ff       	jmp    101db2 <__alltraps>

001022ee <vector142>:
.globl vector142
vector142:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $142
  1022f0:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022f5:	e9 b8 fa ff ff       	jmp    101db2 <__alltraps>

001022fa <vector143>:
.globl vector143
vector143:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $143
  1022fc:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102301:	e9 ac fa ff ff       	jmp    101db2 <__alltraps>

00102306 <vector144>:
.globl vector144
vector144:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $144
  102308:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10230d:	e9 a0 fa ff ff       	jmp    101db2 <__alltraps>

00102312 <vector145>:
.globl vector145
vector145:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $145
  102314:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102319:	e9 94 fa ff ff       	jmp    101db2 <__alltraps>

0010231e <vector146>:
.globl vector146
vector146:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $146
  102320:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102325:	e9 88 fa ff ff       	jmp    101db2 <__alltraps>

0010232a <vector147>:
.globl vector147
vector147:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $147
  10232c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102331:	e9 7c fa ff ff       	jmp    101db2 <__alltraps>

00102336 <vector148>:
.globl vector148
vector148:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $148
  102338:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10233d:	e9 70 fa ff ff       	jmp    101db2 <__alltraps>

00102342 <vector149>:
.globl vector149
vector149:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $149
  102344:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102349:	e9 64 fa ff ff       	jmp    101db2 <__alltraps>

0010234e <vector150>:
.globl vector150
vector150:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $150
  102350:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102355:	e9 58 fa ff ff       	jmp    101db2 <__alltraps>

0010235a <vector151>:
.globl vector151
vector151:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $151
  10235c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102361:	e9 4c fa ff ff       	jmp    101db2 <__alltraps>

00102366 <vector152>:
.globl vector152
vector152:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $152
  102368:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10236d:	e9 40 fa ff ff       	jmp    101db2 <__alltraps>

00102372 <vector153>:
.globl vector153
vector153:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $153
  102374:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102379:	e9 34 fa ff ff       	jmp    101db2 <__alltraps>

0010237e <vector154>:
.globl vector154
vector154:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $154
  102380:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102385:	e9 28 fa ff ff       	jmp    101db2 <__alltraps>

0010238a <vector155>:
.globl vector155
vector155:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $155
  10238c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102391:	e9 1c fa ff ff       	jmp    101db2 <__alltraps>

00102396 <vector156>:
.globl vector156
vector156:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $156
  102398:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10239d:	e9 10 fa ff ff       	jmp    101db2 <__alltraps>

001023a2 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $157
  1023a4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023a9:	e9 04 fa ff ff       	jmp    101db2 <__alltraps>

001023ae <vector158>:
.globl vector158
vector158:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $158
  1023b0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023b5:	e9 f8 f9 ff ff       	jmp    101db2 <__alltraps>

001023ba <vector159>:
.globl vector159
vector159:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $159
  1023bc:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023c1:	e9 ec f9 ff ff       	jmp    101db2 <__alltraps>

001023c6 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $160
  1023c8:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023cd:	e9 e0 f9 ff ff       	jmp    101db2 <__alltraps>

001023d2 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $161
  1023d4:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023d9:	e9 d4 f9 ff ff       	jmp    101db2 <__alltraps>

001023de <vector162>:
.globl vector162
vector162:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $162
  1023e0:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023e5:	e9 c8 f9 ff ff       	jmp    101db2 <__alltraps>

001023ea <vector163>:
.globl vector163
vector163:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $163
  1023ec:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023f1:	e9 bc f9 ff ff       	jmp    101db2 <__alltraps>

001023f6 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $164
  1023f8:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023fd:	e9 b0 f9 ff ff       	jmp    101db2 <__alltraps>

00102402 <vector165>:
.globl vector165
vector165:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $165
  102404:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102409:	e9 a4 f9 ff ff       	jmp    101db2 <__alltraps>

0010240e <vector166>:
.globl vector166
vector166:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $166
  102410:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102415:	e9 98 f9 ff ff       	jmp    101db2 <__alltraps>

0010241a <vector167>:
.globl vector167
vector167:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $167
  10241c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102421:	e9 8c f9 ff ff       	jmp    101db2 <__alltraps>

00102426 <vector168>:
.globl vector168
vector168:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $168
  102428:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10242d:	e9 80 f9 ff ff       	jmp    101db2 <__alltraps>

00102432 <vector169>:
.globl vector169
vector169:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $169
  102434:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102439:	e9 74 f9 ff ff       	jmp    101db2 <__alltraps>

0010243e <vector170>:
.globl vector170
vector170:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $170
  102440:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102445:	e9 68 f9 ff ff       	jmp    101db2 <__alltraps>

0010244a <vector171>:
.globl vector171
vector171:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $171
  10244c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102451:	e9 5c f9 ff ff       	jmp    101db2 <__alltraps>

00102456 <vector172>:
.globl vector172
vector172:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $172
  102458:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10245d:	e9 50 f9 ff ff       	jmp    101db2 <__alltraps>

00102462 <vector173>:
.globl vector173
vector173:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $173
  102464:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102469:	e9 44 f9 ff ff       	jmp    101db2 <__alltraps>

0010246e <vector174>:
.globl vector174
vector174:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $174
  102470:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102475:	e9 38 f9 ff ff       	jmp    101db2 <__alltraps>

0010247a <vector175>:
.globl vector175
vector175:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $175
  10247c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102481:	e9 2c f9 ff ff       	jmp    101db2 <__alltraps>

00102486 <vector176>:
.globl vector176
vector176:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $176
  102488:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10248d:	e9 20 f9 ff ff       	jmp    101db2 <__alltraps>

00102492 <vector177>:
.globl vector177
vector177:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $177
  102494:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102499:	e9 14 f9 ff ff       	jmp    101db2 <__alltraps>

0010249e <vector178>:
.globl vector178
vector178:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $178
  1024a0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024a5:	e9 08 f9 ff ff       	jmp    101db2 <__alltraps>

001024aa <vector179>:
.globl vector179
vector179:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $179
  1024ac:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024b1:	e9 fc f8 ff ff       	jmp    101db2 <__alltraps>

001024b6 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $180
  1024b8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024bd:	e9 f0 f8 ff ff       	jmp    101db2 <__alltraps>

001024c2 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $181
  1024c4:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024c9:	e9 e4 f8 ff ff       	jmp    101db2 <__alltraps>

001024ce <vector182>:
.globl vector182
vector182:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $182
  1024d0:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024d5:	e9 d8 f8 ff ff       	jmp    101db2 <__alltraps>

001024da <vector183>:
.globl vector183
vector183:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $183
  1024dc:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024e1:	e9 cc f8 ff ff       	jmp    101db2 <__alltraps>

001024e6 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $184
  1024e8:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024ed:	e9 c0 f8 ff ff       	jmp    101db2 <__alltraps>

001024f2 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $185
  1024f4:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024f9:	e9 b4 f8 ff ff       	jmp    101db2 <__alltraps>

001024fe <vector186>:
.globl vector186
vector186:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $186
  102500:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102505:	e9 a8 f8 ff ff       	jmp    101db2 <__alltraps>

0010250a <vector187>:
.globl vector187
vector187:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $187
  10250c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102511:	e9 9c f8 ff ff       	jmp    101db2 <__alltraps>

00102516 <vector188>:
.globl vector188
vector188:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $188
  102518:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10251d:	e9 90 f8 ff ff       	jmp    101db2 <__alltraps>

00102522 <vector189>:
.globl vector189
vector189:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $189
  102524:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102529:	e9 84 f8 ff ff       	jmp    101db2 <__alltraps>

0010252e <vector190>:
.globl vector190
vector190:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $190
  102530:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102535:	e9 78 f8 ff ff       	jmp    101db2 <__alltraps>

0010253a <vector191>:
.globl vector191
vector191:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $191
  10253c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102541:	e9 6c f8 ff ff       	jmp    101db2 <__alltraps>

00102546 <vector192>:
.globl vector192
vector192:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $192
  102548:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10254d:	e9 60 f8 ff ff       	jmp    101db2 <__alltraps>

00102552 <vector193>:
.globl vector193
vector193:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $193
  102554:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102559:	e9 54 f8 ff ff       	jmp    101db2 <__alltraps>

0010255e <vector194>:
.globl vector194
vector194:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $194
  102560:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102565:	e9 48 f8 ff ff       	jmp    101db2 <__alltraps>

0010256a <vector195>:
.globl vector195
vector195:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $195
  10256c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102571:	e9 3c f8 ff ff       	jmp    101db2 <__alltraps>

00102576 <vector196>:
.globl vector196
vector196:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $196
  102578:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10257d:	e9 30 f8 ff ff       	jmp    101db2 <__alltraps>

00102582 <vector197>:
.globl vector197
vector197:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $197
  102584:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102589:	e9 24 f8 ff ff       	jmp    101db2 <__alltraps>

0010258e <vector198>:
.globl vector198
vector198:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $198
  102590:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102595:	e9 18 f8 ff ff       	jmp    101db2 <__alltraps>

0010259a <vector199>:
.globl vector199
vector199:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $199
  10259c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025a1:	e9 0c f8 ff ff       	jmp    101db2 <__alltraps>

001025a6 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $200
  1025a8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025ad:	e9 00 f8 ff ff       	jmp    101db2 <__alltraps>

001025b2 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $201
  1025b4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025b9:	e9 f4 f7 ff ff       	jmp    101db2 <__alltraps>

001025be <vector202>:
.globl vector202
vector202:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $202
  1025c0:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025c5:	e9 e8 f7 ff ff       	jmp    101db2 <__alltraps>

001025ca <vector203>:
.globl vector203
vector203:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $203
  1025cc:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025d1:	e9 dc f7 ff ff       	jmp    101db2 <__alltraps>

001025d6 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $204
  1025d8:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025dd:	e9 d0 f7 ff ff       	jmp    101db2 <__alltraps>

001025e2 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $205
  1025e4:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025e9:	e9 c4 f7 ff ff       	jmp    101db2 <__alltraps>

001025ee <vector206>:
.globl vector206
vector206:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $206
  1025f0:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025f5:	e9 b8 f7 ff ff       	jmp    101db2 <__alltraps>

001025fa <vector207>:
.globl vector207
vector207:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $207
  1025fc:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102601:	e9 ac f7 ff ff       	jmp    101db2 <__alltraps>

00102606 <vector208>:
.globl vector208
vector208:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $208
  102608:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10260d:	e9 a0 f7 ff ff       	jmp    101db2 <__alltraps>

00102612 <vector209>:
.globl vector209
vector209:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $209
  102614:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102619:	e9 94 f7 ff ff       	jmp    101db2 <__alltraps>

0010261e <vector210>:
.globl vector210
vector210:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $210
  102620:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102625:	e9 88 f7 ff ff       	jmp    101db2 <__alltraps>

0010262a <vector211>:
.globl vector211
vector211:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $211
  10262c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102631:	e9 7c f7 ff ff       	jmp    101db2 <__alltraps>

00102636 <vector212>:
.globl vector212
vector212:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $212
  102638:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10263d:	e9 70 f7 ff ff       	jmp    101db2 <__alltraps>

00102642 <vector213>:
.globl vector213
vector213:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $213
  102644:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102649:	e9 64 f7 ff ff       	jmp    101db2 <__alltraps>

0010264e <vector214>:
.globl vector214
vector214:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $214
  102650:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102655:	e9 58 f7 ff ff       	jmp    101db2 <__alltraps>

0010265a <vector215>:
.globl vector215
vector215:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $215
  10265c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102661:	e9 4c f7 ff ff       	jmp    101db2 <__alltraps>

00102666 <vector216>:
.globl vector216
vector216:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $216
  102668:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10266d:	e9 40 f7 ff ff       	jmp    101db2 <__alltraps>

00102672 <vector217>:
.globl vector217
vector217:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $217
  102674:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102679:	e9 34 f7 ff ff       	jmp    101db2 <__alltraps>

0010267e <vector218>:
.globl vector218
vector218:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $218
  102680:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102685:	e9 28 f7 ff ff       	jmp    101db2 <__alltraps>

0010268a <vector219>:
.globl vector219
vector219:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $219
  10268c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102691:	e9 1c f7 ff ff       	jmp    101db2 <__alltraps>

00102696 <vector220>:
.globl vector220
vector220:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $220
  102698:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10269d:	e9 10 f7 ff ff       	jmp    101db2 <__alltraps>

001026a2 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $221
  1026a4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026a9:	e9 04 f7 ff ff       	jmp    101db2 <__alltraps>

001026ae <vector222>:
.globl vector222
vector222:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $222
  1026b0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026b5:	e9 f8 f6 ff ff       	jmp    101db2 <__alltraps>

001026ba <vector223>:
.globl vector223
vector223:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $223
  1026bc:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026c1:	e9 ec f6 ff ff       	jmp    101db2 <__alltraps>

001026c6 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $224
  1026c8:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026cd:	e9 e0 f6 ff ff       	jmp    101db2 <__alltraps>

001026d2 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $225
  1026d4:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026d9:	e9 d4 f6 ff ff       	jmp    101db2 <__alltraps>

001026de <vector226>:
.globl vector226
vector226:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $226
  1026e0:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026e5:	e9 c8 f6 ff ff       	jmp    101db2 <__alltraps>

001026ea <vector227>:
.globl vector227
vector227:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $227
  1026ec:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026f1:	e9 bc f6 ff ff       	jmp    101db2 <__alltraps>

001026f6 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $228
  1026f8:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026fd:	e9 b0 f6 ff ff       	jmp    101db2 <__alltraps>

00102702 <vector229>:
.globl vector229
vector229:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $229
  102704:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102709:	e9 a4 f6 ff ff       	jmp    101db2 <__alltraps>

0010270e <vector230>:
.globl vector230
vector230:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $230
  102710:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102715:	e9 98 f6 ff ff       	jmp    101db2 <__alltraps>

0010271a <vector231>:
.globl vector231
vector231:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $231
  10271c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102721:	e9 8c f6 ff ff       	jmp    101db2 <__alltraps>

00102726 <vector232>:
.globl vector232
vector232:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $232
  102728:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10272d:	e9 80 f6 ff ff       	jmp    101db2 <__alltraps>

00102732 <vector233>:
.globl vector233
vector233:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $233
  102734:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102739:	e9 74 f6 ff ff       	jmp    101db2 <__alltraps>

0010273e <vector234>:
.globl vector234
vector234:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $234
  102740:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102745:	e9 68 f6 ff ff       	jmp    101db2 <__alltraps>

0010274a <vector235>:
.globl vector235
vector235:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $235
  10274c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102751:	e9 5c f6 ff ff       	jmp    101db2 <__alltraps>

00102756 <vector236>:
.globl vector236
vector236:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $236
  102758:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10275d:	e9 50 f6 ff ff       	jmp    101db2 <__alltraps>

00102762 <vector237>:
.globl vector237
vector237:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $237
  102764:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102769:	e9 44 f6 ff ff       	jmp    101db2 <__alltraps>

0010276e <vector238>:
.globl vector238
vector238:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $238
  102770:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102775:	e9 38 f6 ff ff       	jmp    101db2 <__alltraps>

0010277a <vector239>:
.globl vector239
vector239:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $239
  10277c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102781:	e9 2c f6 ff ff       	jmp    101db2 <__alltraps>

00102786 <vector240>:
.globl vector240
vector240:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $240
  102788:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10278d:	e9 20 f6 ff ff       	jmp    101db2 <__alltraps>

00102792 <vector241>:
.globl vector241
vector241:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $241
  102794:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102799:	e9 14 f6 ff ff       	jmp    101db2 <__alltraps>

0010279e <vector242>:
.globl vector242
vector242:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $242
  1027a0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027a5:	e9 08 f6 ff ff       	jmp    101db2 <__alltraps>

001027aa <vector243>:
.globl vector243
vector243:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $243
  1027ac:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027b1:	e9 fc f5 ff ff       	jmp    101db2 <__alltraps>

001027b6 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $244
  1027b8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027bd:	e9 f0 f5 ff ff       	jmp    101db2 <__alltraps>

001027c2 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $245
  1027c4:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027c9:	e9 e4 f5 ff ff       	jmp    101db2 <__alltraps>

001027ce <vector246>:
.globl vector246
vector246:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $246
  1027d0:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027d5:	e9 d8 f5 ff ff       	jmp    101db2 <__alltraps>

001027da <vector247>:
.globl vector247
vector247:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $247
  1027dc:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027e1:	e9 cc f5 ff ff       	jmp    101db2 <__alltraps>

001027e6 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $248
  1027e8:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027ed:	e9 c0 f5 ff ff       	jmp    101db2 <__alltraps>

001027f2 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $249
  1027f4:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027f9:	e9 b4 f5 ff ff       	jmp    101db2 <__alltraps>

001027fe <vector250>:
.globl vector250
vector250:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $250
  102800:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102805:	e9 a8 f5 ff ff       	jmp    101db2 <__alltraps>

0010280a <vector251>:
.globl vector251
vector251:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $251
  10280c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102811:	e9 9c f5 ff ff       	jmp    101db2 <__alltraps>

00102816 <vector252>:
.globl vector252
vector252:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $252
  102818:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10281d:	e9 90 f5 ff ff       	jmp    101db2 <__alltraps>

00102822 <vector253>:
.globl vector253
vector253:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $253
  102824:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102829:	e9 84 f5 ff ff       	jmp    101db2 <__alltraps>

0010282e <vector254>:
.globl vector254
vector254:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $254
  102830:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102835:	e9 78 f5 ff ff       	jmp    101db2 <__alltraps>

0010283a <vector255>:
.globl vector255
vector255:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $255
  10283c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102841:	e9 6c f5 ff ff       	jmp    101db2 <__alltraps>

00102846 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102846:	55                   	push   %ebp
  102847:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102849:	8b 45 08             	mov    0x8(%ebp),%eax
  10284c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10284f:	b8 23 00 00 00       	mov    $0x23,%eax
  102854:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102856:	b8 23 00 00 00       	mov    $0x23,%eax
  10285b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10285d:	b8 10 00 00 00       	mov    $0x10,%eax
  102862:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102864:	b8 10 00 00 00       	mov    $0x10,%eax
  102869:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10286b:	b8 10 00 00 00       	mov    $0x10,%eax
  102870:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102872:	ea 79 28 10 00 08 00 	ljmp   $0x8,$0x102879
}
  102879:	90                   	nop
  10287a:	5d                   	pop    %ebp
  10287b:	c3                   	ret    

0010287c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10287c:	55                   	push   %ebp
  10287d:	89 e5                	mov    %esp,%ebp
  10287f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102882:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102887:	05 00 04 00 00       	add    $0x400,%eax
  10288c:	a3 a4 0c 11 00       	mov    %eax,0x110ca4
    ts.ts_ss0 = KERNEL_DS;
  102891:	66 c7 05 a8 0c 11 00 	movw   $0x10,0x110ca8
  102898:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10289a:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1028a1:	68 00 
  1028a3:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  1028a8:	0f b7 c0             	movzwl %ax,%eax
  1028ab:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1028b1:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  1028b6:	c1 e8 10             	shr    $0x10,%eax
  1028b9:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1028be:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028c5:	24 f0                	and    $0xf0,%al
  1028c7:	0c 09                	or     $0x9,%al
  1028c9:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028ce:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028d5:	0c 10                	or     $0x10,%al
  1028d7:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028dc:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028e3:	24 9f                	and    $0x9f,%al
  1028e5:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028ea:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028f1:	0c 80                	or     $0x80,%al
  1028f3:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028f8:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  1028ff:	24 f0                	and    $0xf0,%al
  102901:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102906:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10290d:	24 ef                	and    $0xef,%al
  10290f:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102914:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10291b:	24 df                	and    $0xdf,%al
  10291d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102922:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102929:	0c 40                	or     $0x40,%al
  10292b:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102930:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102937:	24 7f                	and    $0x7f,%al
  102939:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10293e:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  102943:	c1 e8 18             	shr    $0x18,%eax
  102946:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  10294b:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102952:	24 ef                	and    $0xef,%al
  102954:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102959:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102960:	e8 e1 fe ff ff       	call   102846 <lgdt>
  102965:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10296b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10296f:	0f 00 d8             	ltr    %ax
}
  102972:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102973:	90                   	nop
  102974:	89 ec                	mov    %ebp,%esp
  102976:	5d                   	pop    %ebp
  102977:	c3                   	ret    

00102978 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102978:	55                   	push   %ebp
  102979:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10297b:	e8 fc fe ff ff       	call   10287c <gdt_init>
}
  102980:	90                   	nop
  102981:	5d                   	pop    %ebp
  102982:	c3                   	ret    

00102983 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102983:	55                   	push   %ebp
  102984:	89 e5                	mov    %esp,%ebp
  102986:	83 ec 58             	sub    $0x58,%esp
  102989:	8b 45 10             	mov    0x10(%ebp),%eax
  10298c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10298f:	8b 45 14             	mov    0x14(%ebp),%eax
  102992:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102995:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102998:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10299b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10299e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1029a1:	8b 45 18             	mov    0x18(%ebp),%eax
  1029a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1029a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029b0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029bd:	74 1c                	je     1029db <printnum+0x58>
  1029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1029c7:	f7 75 e4             	divl   -0x1c(%ebp)
  1029ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029d0:	ba 00 00 00 00       	mov    $0x0,%edx
  1029d5:	f7 75 e4             	divl   -0x1c(%ebp)
  1029d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029e1:	f7 75 e4             	divl   -0x1c(%ebp)
  1029e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029f9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029fc:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ff:	ba 00 00 00 00       	mov    $0x0,%edx
  102a04:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102a07:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102a0a:	19 d1                	sbb    %edx,%ecx
  102a0c:	72 4c                	jb     102a5a <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a0e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a11:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a14:	8b 45 20             	mov    0x20(%ebp),%eax
  102a17:	89 44 24 18          	mov    %eax,0x18(%esp)
  102a1b:	89 54 24 14          	mov    %edx,0x14(%esp)
  102a1f:	8b 45 18             	mov    0x18(%ebp),%eax
  102a22:	89 44 24 10          	mov    %eax,0x10(%esp)
  102a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a30:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3e:	89 04 24             	mov    %eax,(%esp)
  102a41:	e8 3d ff ff ff       	call   102983 <printnum>
  102a46:	eb 1b                	jmp    102a63 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a4f:	8b 45 20             	mov    0x20(%ebp),%eax
  102a52:	89 04 24             	mov    %eax,(%esp)
  102a55:	8b 45 08             	mov    0x8(%ebp),%eax
  102a58:	ff d0                	call   *%eax
        while (-- width > 0)
  102a5a:	ff 4d 1c             	decl   0x1c(%ebp)
  102a5d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a61:	7f e5                	jg     102a48 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a66:	05 70 3c 10 00       	add    $0x103c70,%eax
  102a6b:	0f b6 00             	movzbl (%eax),%eax
  102a6e:	0f be c0             	movsbl %al,%eax
  102a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a74:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a78:	89 04 24             	mov    %eax,(%esp)
  102a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7e:	ff d0                	call   *%eax
}
  102a80:	90                   	nop
  102a81:	89 ec                	mov    %ebp,%esp
  102a83:	5d                   	pop    %ebp
  102a84:	c3                   	ret    

00102a85 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a85:	55                   	push   %ebp
  102a86:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a88:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a8c:	7e 14                	jle    102aa2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a91:	8b 00                	mov    (%eax),%eax
  102a93:	8d 48 08             	lea    0x8(%eax),%ecx
  102a96:	8b 55 08             	mov    0x8(%ebp),%edx
  102a99:	89 0a                	mov    %ecx,(%edx)
  102a9b:	8b 50 04             	mov    0x4(%eax),%edx
  102a9e:	8b 00                	mov    (%eax),%eax
  102aa0:	eb 30                	jmp    102ad2 <getuint+0x4d>
    }
    else if (lflag) {
  102aa2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102aa6:	74 16                	je     102abe <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	8b 00                	mov    (%eax),%eax
  102aad:	8d 48 04             	lea    0x4(%eax),%ecx
  102ab0:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab3:	89 0a                	mov    %ecx,(%edx)
  102ab5:	8b 00                	mov    (%eax),%eax
  102ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  102abc:	eb 14                	jmp    102ad2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102abe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac1:	8b 00                	mov    (%eax),%eax
  102ac3:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac9:	89 0a                	mov    %ecx,(%edx)
  102acb:	8b 00                	mov    (%eax),%eax
  102acd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ad2:	5d                   	pop    %ebp
  102ad3:	c3                   	ret    

00102ad4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ad4:	55                   	push   %ebp
  102ad5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ad7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102adb:	7e 14                	jle    102af1 <getint+0x1d>
        return va_arg(*ap, long long);
  102add:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae0:	8b 00                	mov    (%eax),%eax
  102ae2:	8d 48 08             	lea    0x8(%eax),%ecx
  102ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae8:	89 0a                	mov    %ecx,(%edx)
  102aea:	8b 50 04             	mov    0x4(%eax),%edx
  102aed:	8b 00                	mov    (%eax),%eax
  102aef:	eb 28                	jmp    102b19 <getint+0x45>
    }
    else if (lflag) {
  102af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102af5:	74 12                	je     102b09 <getint+0x35>
        return va_arg(*ap, long);
  102af7:	8b 45 08             	mov    0x8(%ebp),%eax
  102afa:	8b 00                	mov    (%eax),%eax
  102afc:	8d 48 04             	lea    0x4(%eax),%ecx
  102aff:	8b 55 08             	mov    0x8(%ebp),%edx
  102b02:	89 0a                	mov    %ecx,(%edx)
  102b04:	8b 00                	mov    (%eax),%eax
  102b06:	99                   	cltd   
  102b07:	eb 10                	jmp    102b19 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102b09:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0c:	8b 00                	mov    (%eax),%eax
  102b0e:	8d 48 04             	lea    0x4(%eax),%ecx
  102b11:	8b 55 08             	mov    0x8(%ebp),%edx
  102b14:	89 0a                	mov    %ecx,(%edx)
  102b16:	8b 00                	mov    (%eax),%eax
  102b18:	99                   	cltd   
    }
}
  102b19:	5d                   	pop    %ebp
  102b1a:	c3                   	ret    

00102b1b <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b1b:	55                   	push   %ebp
  102b1c:	89 e5                	mov    %esp,%ebp
  102b1e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102b21:	8d 45 14             	lea    0x14(%ebp),%eax
  102b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102b31:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	89 04 24             	mov    %eax,(%esp)
  102b42:	e8 05 00 00 00       	call   102b4c <vprintfmt>
    va_end(ap);
}
  102b47:	90                   	nop
  102b48:	89 ec                	mov    %ebp,%esp
  102b4a:	5d                   	pop    %ebp
  102b4b:	c3                   	ret    

00102b4c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b4c:	55                   	push   %ebp
  102b4d:	89 e5                	mov    %esp,%ebp
  102b4f:	56                   	push   %esi
  102b50:	53                   	push   %ebx
  102b51:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b54:	eb 17                	jmp    102b6d <vprintfmt+0x21>
            if (ch == '\0') {
  102b56:	85 db                	test   %ebx,%ebx
  102b58:	0f 84 bf 03 00 00    	je     102f1d <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b65:	89 1c 24             	mov    %ebx,(%esp)
  102b68:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6b:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  102b70:	8d 50 01             	lea    0x1(%eax),%edx
  102b73:	89 55 10             	mov    %edx,0x10(%ebp)
  102b76:	0f b6 00             	movzbl (%eax),%eax
  102b79:	0f b6 d8             	movzbl %al,%ebx
  102b7c:	83 fb 25             	cmp    $0x25,%ebx
  102b7f:	75 d5                	jne    102b56 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b81:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b85:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b92:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  102ba2:	8d 50 01             	lea    0x1(%eax),%edx
  102ba5:	89 55 10             	mov    %edx,0x10(%ebp)
  102ba8:	0f b6 00             	movzbl (%eax),%eax
  102bab:	0f b6 d8             	movzbl %al,%ebx
  102bae:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102bb1:	83 f8 55             	cmp    $0x55,%eax
  102bb4:	0f 87 37 03 00 00    	ja     102ef1 <vprintfmt+0x3a5>
  102bba:	8b 04 85 94 3c 10 00 	mov    0x103c94(,%eax,4),%eax
  102bc1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102bc3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bc7:	eb d6                	jmp    102b9f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bc9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bcd:	eb d0                	jmp    102b9f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bcf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102bd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bd9:	89 d0                	mov    %edx,%eax
  102bdb:	c1 e0 02             	shl    $0x2,%eax
  102bde:	01 d0                	add    %edx,%eax
  102be0:	01 c0                	add    %eax,%eax
  102be2:	01 d8                	add    %ebx,%eax
  102be4:	83 e8 30             	sub    $0x30,%eax
  102be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bea:	8b 45 10             	mov    0x10(%ebp),%eax
  102bed:	0f b6 00             	movzbl (%eax),%eax
  102bf0:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bf3:	83 fb 2f             	cmp    $0x2f,%ebx
  102bf6:	7e 38                	jle    102c30 <vprintfmt+0xe4>
  102bf8:	83 fb 39             	cmp    $0x39,%ebx
  102bfb:	7f 33                	jg     102c30 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102bfd:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102c00:	eb d4                	jmp    102bd6 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102c02:	8b 45 14             	mov    0x14(%ebp),%eax
  102c05:	8d 50 04             	lea    0x4(%eax),%edx
  102c08:	89 55 14             	mov    %edx,0x14(%ebp)
  102c0b:	8b 00                	mov    (%eax),%eax
  102c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c10:	eb 1f                	jmp    102c31 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102c12:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c16:	79 87                	jns    102b9f <vprintfmt+0x53>
                width = 0;
  102c18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c1f:	e9 7b ff ff ff       	jmp    102b9f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102c24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c2b:	e9 6f ff ff ff       	jmp    102b9f <vprintfmt+0x53>
            goto process_precision;
  102c30:	90                   	nop

        process_precision:
            if (width < 0)
  102c31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c35:	0f 89 64 ff ff ff    	jns    102b9f <vprintfmt+0x53>
                width = precision, precision = -1;
  102c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c41:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c48:	e9 52 ff ff ff       	jmp    102b9f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c4d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102c50:	e9 4a ff ff ff       	jmp    102b9f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c55:	8b 45 14             	mov    0x14(%ebp),%eax
  102c58:	8d 50 04             	lea    0x4(%eax),%edx
  102c5b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c5e:	8b 00                	mov    (%eax),%eax
  102c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c63:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c67:	89 04 24             	mov    %eax,(%esp)
  102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6d:	ff d0                	call   *%eax
            break;
  102c6f:	e9 a4 02 00 00       	jmp    102f18 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c74:	8b 45 14             	mov    0x14(%ebp),%eax
  102c77:	8d 50 04             	lea    0x4(%eax),%edx
  102c7a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c7d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c7f:	85 db                	test   %ebx,%ebx
  102c81:	79 02                	jns    102c85 <vprintfmt+0x139>
                err = -err;
  102c83:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c85:	83 fb 06             	cmp    $0x6,%ebx
  102c88:	7f 0b                	jg     102c95 <vprintfmt+0x149>
  102c8a:	8b 34 9d 54 3c 10 00 	mov    0x103c54(,%ebx,4),%esi
  102c91:	85 f6                	test   %esi,%esi
  102c93:	75 23                	jne    102cb8 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102c95:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c99:	c7 44 24 08 81 3c 10 	movl   $0x103c81,0x8(%esp)
  102ca0:	00 
  102ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cab:	89 04 24             	mov    %eax,(%esp)
  102cae:	e8 68 fe ff ff       	call   102b1b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102cb3:	e9 60 02 00 00       	jmp    102f18 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102cb8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102cbc:	c7 44 24 08 8a 3c 10 	movl   $0x103c8a,0x8(%esp)
  102cc3:	00 
  102cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cce:	89 04 24             	mov    %eax,(%esp)
  102cd1:	e8 45 fe ff ff       	call   102b1b <printfmt>
            break;
  102cd6:	e9 3d 02 00 00       	jmp    102f18 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cdb:	8b 45 14             	mov    0x14(%ebp),%eax
  102cde:	8d 50 04             	lea    0x4(%eax),%edx
  102ce1:	89 55 14             	mov    %edx,0x14(%ebp)
  102ce4:	8b 30                	mov    (%eax),%esi
  102ce6:	85 f6                	test   %esi,%esi
  102ce8:	75 05                	jne    102cef <vprintfmt+0x1a3>
                p = "(null)";
  102cea:	be 8d 3c 10 00       	mov    $0x103c8d,%esi
            }
            if (width > 0 && padc != '-') {
  102cef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cf3:	7e 76                	jle    102d6b <vprintfmt+0x21f>
  102cf5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cf9:	74 70                	je     102d6b <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d02:	89 34 24             	mov    %esi,(%esp)
  102d05:	e8 16 03 00 00       	call   103020 <strnlen>
  102d0a:	89 c2                	mov    %eax,%edx
  102d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d0f:	29 d0                	sub    %edx,%eax
  102d11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d14:	eb 16                	jmp    102d2c <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102d16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d21:	89 04 24             	mov    %eax,(%esp)
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d29:	ff 4d e8             	decl   -0x18(%ebp)
  102d2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d30:	7f e4                	jg     102d16 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d32:	eb 37                	jmp    102d6b <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d38:	74 1f                	je     102d59 <vprintfmt+0x20d>
  102d3a:	83 fb 1f             	cmp    $0x1f,%ebx
  102d3d:	7e 05                	jle    102d44 <vprintfmt+0x1f8>
  102d3f:	83 fb 7e             	cmp    $0x7e,%ebx
  102d42:	7e 15                	jle    102d59 <vprintfmt+0x20d>
                    putch('?', putdat);
  102d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d4b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d52:	8b 45 08             	mov    0x8(%ebp),%eax
  102d55:	ff d0                	call   *%eax
  102d57:	eb 0f                	jmp    102d68 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d60:	89 1c 24             	mov    %ebx,(%esp)
  102d63:	8b 45 08             	mov    0x8(%ebp),%eax
  102d66:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d68:	ff 4d e8             	decl   -0x18(%ebp)
  102d6b:	89 f0                	mov    %esi,%eax
  102d6d:	8d 70 01             	lea    0x1(%eax),%esi
  102d70:	0f b6 00             	movzbl (%eax),%eax
  102d73:	0f be d8             	movsbl %al,%ebx
  102d76:	85 db                	test   %ebx,%ebx
  102d78:	74 27                	je     102da1 <vprintfmt+0x255>
  102d7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d7e:	78 b4                	js     102d34 <vprintfmt+0x1e8>
  102d80:	ff 4d e4             	decl   -0x1c(%ebp)
  102d83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d87:	79 ab                	jns    102d34 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102d89:	eb 16                	jmp    102da1 <vprintfmt+0x255>
                putch(' ', putdat);
  102d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d92:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d99:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9c:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102d9e:	ff 4d e8             	decl   -0x18(%ebp)
  102da1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102da5:	7f e4                	jg     102d8b <vprintfmt+0x23f>
            }
            break;
  102da7:	e9 6c 01 00 00       	jmp    102f18 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102db3:	8d 45 14             	lea    0x14(%ebp),%eax
  102db6:	89 04 24             	mov    %eax,(%esp)
  102db9:	e8 16 fd ff ff       	call   102ad4 <getint>
  102dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dca:	85 d2                	test   %edx,%edx
  102dcc:	79 26                	jns    102df4 <vprintfmt+0x2a8>
                putch('-', putdat);
  102dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddf:	ff d0                	call   *%eax
                num = -(long long)num;
  102de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102de7:	f7 d8                	neg    %eax
  102de9:	83 d2 00             	adc    $0x0,%edx
  102dec:	f7 da                	neg    %edx
  102dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102df1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102df4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dfb:	e9 a8 00 00 00       	jmp    102ea8 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e07:	8d 45 14             	lea    0x14(%ebp),%eax
  102e0a:	89 04 24             	mov    %eax,(%esp)
  102e0d:	e8 73 fc ff ff       	call   102a85 <getuint>
  102e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e15:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e18:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e1f:	e9 84 00 00 00       	jmp    102ea8 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e27:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e2b:	8d 45 14             	lea    0x14(%ebp),%eax
  102e2e:	89 04 24             	mov    %eax,(%esp)
  102e31:	e8 4f fc ff ff       	call   102a85 <getuint>
  102e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e3c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e43:	eb 63                	jmp    102ea8 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e4c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	ff d0                	call   *%eax
            putch('x', putdat);
  102e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e5f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e66:	8b 45 08             	mov    0x8(%ebp),%eax
  102e69:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  102e6e:	8d 50 04             	lea    0x4(%eax),%edx
  102e71:	89 55 14             	mov    %edx,0x14(%ebp)
  102e74:	8b 00                	mov    (%eax),%eax
  102e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e87:	eb 1f                	jmp    102ea8 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e90:	8d 45 14             	lea    0x14(%ebp),%eax
  102e93:	89 04 24             	mov    %eax,(%esp)
  102e96:	e8 ea fb ff ff       	call   102a85 <getuint>
  102e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102ea1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102ea8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eaf:	89 54 24 18          	mov    %edx,0x18(%esp)
  102eb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102eb6:	89 54 24 14          	mov    %edx,0x14(%esp)
  102eba:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ec4:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ec8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed6:	89 04 24             	mov    %eax,(%esp)
  102ed9:	e8 a5 fa ff ff       	call   102983 <printnum>
            break;
  102ede:	eb 38                	jmp    102f18 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee7:	89 1c 24             	mov    %ebx,(%esp)
  102eea:	8b 45 08             	mov    0x8(%ebp),%eax
  102eed:	ff d0                	call   *%eax
            break;
  102eef:	eb 27                	jmp    102f18 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102f04:	ff 4d 10             	decl   0x10(%ebp)
  102f07:	eb 03                	jmp    102f0c <vprintfmt+0x3c0>
  102f09:	ff 4d 10             	decl   0x10(%ebp)
  102f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f0f:	48                   	dec    %eax
  102f10:	0f b6 00             	movzbl (%eax),%eax
  102f13:	3c 25                	cmp    $0x25,%al
  102f15:	75 f2                	jne    102f09 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  102f17:	90                   	nop
    while (1) {
  102f18:	e9 37 fc ff ff       	jmp    102b54 <vprintfmt+0x8>
                return;
  102f1d:	90                   	nop
        }
    }
}
  102f1e:	83 c4 40             	add    $0x40,%esp
  102f21:	5b                   	pop    %ebx
  102f22:	5e                   	pop    %esi
  102f23:	5d                   	pop    %ebp
  102f24:	c3                   	ret    

00102f25 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f25:	55                   	push   %ebp
  102f26:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2b:	8b 40 08             	mov    0x8(%eax),%eax
  102f2e:	8d 50 01             	lea    0x1(%eax),%edx
  102f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f34:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3a:	8b 10                	mov    (%eax),%edx
  102f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3f:	8b 40 04             	mov    0x4(%eax),%eax
  102f42:	39 c2                	cmp    %eax,%edx
  102f44:	73 12                	jae    102f58 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f49:	8b 00                	mov    (%eax),%eax
  102f4b:	8d 48 01             	lea    0x1(%eax),%ecx
  102f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f51:	89 0a                	mov    %ecx,(%edx)
  102f53:	8b 55 08             	mov    0x8(%ebp),%edx
  102f56:	88 10                	mov    %dl,(%eax)
    }
}
  102f58:	90                   	nop
  102f59:	5d                   	pop    %ebp
  102f5a:	c3                   	ret    

00102f5b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f5b:	55                   	push   %ebp
  102f5c:	89 e5                	mov    %esp,%ebp
  102f5e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f61:	8d 45 14             	lea    0x14(%ebp),%eax
  102f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f71:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7f:	89 04 24             	mov    %eax,(%esp)
  102f82:	e8 0a 00 00 00       	call   102f91 <vsnprintf>
  102f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f8d:	89 ec                	mov    %ebp,%esp
  102f8f:	5d                   	pop    %ebp
  102f90:	c3                   	ret    

00102f91 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f91:	55                   	push   %ebp
  102f92:	89 e5                	mov    %esp,%ebp
  102f94:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f97:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa0:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa6:	01 d0                	add    %edx,%eax
  102fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102fb6:	74 0a                	je     102fc2 <vsnprintf+0x31>
  102fb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbe:	39 c2                	cmp    %eax,%edx
  102fc0:	76 07                	jbe    102fc9 <vsnprintf+0x38>
        return -E_INVAL;
  102fc2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fc7:	eb 2a                	jmp    102ff3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  102fcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fde:	c7 04 24 25 2f 10 00 	movl   $0x102f25,(%esp)
  102fe5:	e8 62 fb ff ff       	call   102b4c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fed:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ff3:	89 ec                	mov    %ebp,%esp
  102ff5:	5d                   	pop    %ebp
  102ff6:	c3                   	ret    

00102ff7 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ff7:	55                   	push   %ebp
  102ff8:	89 e5                	mov    %esp,%ebp
  102ffa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ffd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103004:	eb 03                	jmp    103009 <strlen+0x12>
        cnt ++;
  103006:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  103009:	8b 45 08             	mov    0x8(%ebp),%eax
  10300c:	8d 50 01             	lea    0x1(%eax),%edx
  10300f:	89 55 08             	mov    %edx,0x8(%ebp)
  103012:	0f b6 00             	movzbl (%eax),%eax
  103015:	84 c0                	test   %al,%al
  103017:	75 ed                	jne    103006 <strlen+0xf>
    }
    return cnt;
  103019:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10301c:	89 ec                	mov    %ebp,%esp
  10301e:	5d                   	pop    %ebp
  10301f:	c3                   	ret    

00103020 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
  103023:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10302d:	eb 03                	jmp    103032 <strnlen+0x12>
        cnt ++;
  10302f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103038:	73 10                	jae    10304a <strnlen+0x2a>
  10303a:	8b 45 08             	mov    0x8(%ebp),%eax
  10303d:	8d 50 01             	lea    0x1(%eax),%edx
  103040:	89 55 08             	mov    %edx,0x8(%ebp)
  103043:	0f b6 00             	movzbl (%eax),%eax
  103046:	84 c0                	test   %al,%al
  103048:	75 e5                	jne    10302f <strnlen+0xf>
    }
    return cnt;
  10304a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10304d:	89 ec                	mov    %ebp,%esp
  10304f:	5d                   	pop    %ebp
  103050:	c3                   	ret    

00103051 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103051:	55                   	push   %ebp
  103052:	89 e5                	mov    %esp,%ebp
  103054:	57                   	push   %edi
  103055:	56                   	push   %esi
  103056:	83 ec 20             	sub    $0x20,%esp
  103059:	8b 45 08             	mov    0x8(%ebp),%eax
  10305c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10305f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103062:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10306b:	89 d1                	mov    %edx,%ecx
  10306d:	89 c2                	mov    %eax,%edx
  10306f:	89 ce                	mov    %ecx,%esi
  103071:	89 d7                	mov    %edx,%edi
  103073:	ac                   	lods   %ds:(%esi),%al
  103074:	aa                   	stos   %al,%es:(%edi)
  103075:	84 c0                	test   %al,%al
  103077:	75 fa                	jne    103073 <strcpy+0x22>
  103079:	89 fa                	mov    %edi,%edx
  10307b:	89 f1                	mov    %esi,%ecx
  10307d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103080:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103086:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103089:	83 c4 20             	add    $0x20,%esp
  10308c:	5e                   	pop    %esi
  10308d:	5f                   	pop    %edi
  10308e:	5d                   	pop    %ebp
  10308f:	c3                   	ret    

00103090 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103090:	55                   	push   %ebp
  103091:	89 e5                	mov    %esp,%ebp
  103093:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103096:	8b 45 08             	mov    0x8(%ebp),%eax
  103099:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10309c:	eb 1e                	jmp    1030bc <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a1:	0f b6 10             	movzbl (%eax),%edx
  1030a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a7:	88 10                	mov    %dl,(%eax)
  1030a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ac:	0f b6 00             	movzbl (%eax),%eax
  1030af:	84 c0                	test   %al,%al
  1030b1:	74 03                	je     1030b6 <strncpy+0x26>
            src ++;
  1030b3:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1030b6:	ff 45 fc             	incl   -0x4(%ebp)
  1030b9:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1030bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c0:	75 dc                	jne    10309e <strncpy+0xe>
    }
    return dst;
  1030c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1030c5:	89 ec                	mov    %ebp,%esp
  1030c7:	5d                   	pop    %ebp
  1030c8:	c3                   	ret    

001030c9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030c9:	55                   	push   %ebp
  1030ca:	89 e5                	mov    %esp,%ebp
  1030cc:	57                   	push   %edi
  1030cd:	56                   	push   %esi
  1030ce:	83 ec 20             	sub    $0x20,%esp
  1030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1030dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e3:	89 d1                	mov    %edx,%ecx
  1030e5:	89 c2                	mov    %eax,%edx
  1030e7:	89 ce                	mov    %ecx,%esi
  1030e9:	89 d7                	mov    %edx,%edi
  1030eb:	ac                   	lods   %ds:(%esi),%al
  1030ec:	ae                   	scas   %es:(%edi),%al
  1030ed:	75 08                	jne    1030f7 <strcmp+0x2e>
  1030ef:	84 c0                	test   %al,%al
  1030f1:	75 f8                	jne    1030eb <strcmp+0x22>
  1030f3:	31 c0                	xor    %eax,%eax
  1030f5:	eb 04                	jmp    1030fb <strcmp+0x32>
  1030f7:	19 c0                	sbb    %eax,%eax
  1030f9:	0c 01                	or     $0x1,%al
  1030fb:	89 fa                	mov    %edi,%edx
  1030fd:	89 f1                	mov    %esi,%ecx
  1030ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103102:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103105:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  103108:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10310b:	83 c4 20             	add    $0x20,%esp
  10310e:	5e                   	pop    %esi
  10310f:	5f                   	pop    %edi
  103110:	5d                   	pop    %ebp
  103111:	c3                   	ret    

00103112 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103112:	55                   	push   %ebp
  103113:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103115:	eb 09                	jmp    103120 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  103117:	ff 4d 10             	decl   0x10(%ebp)
  10311a:	ff 45 08             	incl   0x8(%ebp)
  10311d:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103124:	74 1a                	je     103140 <strncmp+0x2e>
  103126:	8b 45 08             	mov    0x8(%ebp),%eax
  103129:	0f b6 00             	movzbl (%eax),%eax
  10312c:	84 c0                	test   %al,%al
  10312e:	74 10                	je     103140 <strncmp+0x2e>
  103130:	8b 45 08             	mov    0x8(%ebp),%eax
  103133:	0f b6 10             	movzbl (%eax),%edx
  103136:	8b 45 0c             	mov    0xc(%ebp),%eax
  103139:	0f b6 00             	movzbl (%eax),%eax
  10313c:	38 c2                	cmp    %al,%dl
  10313e:	74 d7                	je     103117 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103144:	74 18                	je     10315e <strncmp+0x4c>
  103146:	8b 45 08             	mov    0x8(%ebp),%eax
  103149:	0f b6 00             	movzbl (%eax),%eax
  10314c:	0f b6 d0             	movzbl %al,%edx
  10314f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103152:	0f b6 00             	movzbl (%eax),%eax
  103155:	0f b6 c8             	movzbl %al,%ecx
  103158:	89 d0                	mov    %edx,%eax
  10315a:	29 c8                	sub    %ecx,%eax
  10315c:	eb 05                	jmp    103163 <strncmp+0x51>
  10315e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103163:	5d                   	pop    %ebp
  103164:	c3                   	ret    

00103165 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103165:	55                   	push   %ebp
  103166:	89 e5                	mov    %esp,%ebp
  103168:	83 ec 04             	sub    $0x4,%esp
  10316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103171:	eb 13                	jmp    103186 <strchr+0x21>
        if (*s == c) {
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
  103176:	0f b6 00             	movzbl (%eax),%eax
  103179:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10317c:	75 05                	jne    103183 <strchr+0x1e>
            return (char *)s;
  10317e:	8b 45 08             	mov    0x8(%ebp),%eax
  103181:	eb 12                	jmp    103195 <strchr+0x30>
        }
        s ++;
  103183:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103186:	8b 45 08             	mov    0x8(%ebp),%eax
  103189:	0f b6 00             	movzbl (%eax),%eax
  10318c:	84 c0                	test   %al,%al
  10318e:	75 e3                	jne    103173 <strchr+0xe>
    }
    return NULL;
  103190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103195:	89 ec                	mov    %ebp,%esp
  103197:	5d                   	pop    %ebp
  103198:	c3                   	ret    

00103199 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103199:	55                   	push   %ebp
  10319a:	89 e5                	mov    %esp,%ebp
  10319c:	83 ec 04             	sub    $0x4,%esp
  10319f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1031a5:	eb 0e                	jmp    1031b5 <strfind+0x1c>
        if (*s == c) {
  1031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031aa:	0f b6 00             	movzbl (%eax),%eax
  1031ad:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1031b0:	74 0f                	je     1031c1 <strfind+0x28>
            break;
        }
        s ++;
  1031b2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b8:	0f b6 00             	movzbl (%eax),%eax
  1031bb:	84 c0                	test   %al,%al
  1031bd:	75 e8                	jne    1031a7 <strfind+0xe>
  1031bf:	eb 01                	jmp    1031c2 <strfind+0x29>
            break;
  1031c1:	90                   	nop
    }
    return (char *)s;
  1031c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031c5:	89 ec                	mov    %ebp,%esp
  1031c7:	5d                   	pop    %ebp
  1031c8:	c3                   	ret    

001031c9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031c9:	55                   	push   %ebp
  1031ca:	89 e5                	mov    %esp,%ebp
  1031cc:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031dd:	eb 03                	jmp    1031e2 <strtol+0x19>
        s ++;
  1031df:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e5:	0f b6 00             	movzbl (%eax),%eax
  1031e8:	3c 20                	cmp    $0x20,%al
  1031ea:	74 f3                	je     1031df <strtol+0x16>
  1031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ef:	0f b6 00             	movzbl (%eax),%eax
  1031f2:	3c 09                	cmp    $0x9,%al
  1031f4:	74 e9                	je     1031df <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f9:	0f b6 00             	movzbl (%eax),%eax
  1031fc:	3c 2b                	cmp    $0x2b,%al
  1031fe:	75 05                	jne    103205 <strtol+0x3c>
        s ++;
  103200:	ff 45 08             	incl   0x8(%ebp)
  103203:	eb 14                	jmp    103219 <strtol+0x50>
    }
    else if (*s == '-') {
  103205:	8b 45 08             	mov    0x8(%ebp),%eax
  103208:	0f b6 00             	movzbl (%eax),%eax
  10320b:	3c 2d                	cmp    $0x2d,%al
  10320d:	75 0a                	jne    103219 <strtol+0x50>
        s ++, neg = 1;
  10320f:	ff 45 08             	incl   0x8(%ebp)
  103212:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103219:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10321d:	74 06                	je     103225 <strtol+0x5c>
  10321f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103223:	75 22                	jne    103247 <strtol+0x7e>
  103225:	8b 45 08             	mov    0x8(%ebp),%eax
  103228:	0f b6 00             	movzbl (%eax),%eax
  10322b:	3c 30                	cmp    $0x30,%al
  10322d:	75 18                	jne    103247 <strtol+0x7e>
  10322f:	8b 45 08             	mov    0x8(%ebp),%eax
  103232:	40                   	inc    %eax
  103233:	0f b6 00             	movzbl (%eax),%eax
  103236:	3c 78                	cmp    $0x78,%al
  103238:	75 0d                	jne    103247 <strtol+0x7e>
        s += 2, base = 16;
  10323a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10323e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103245:	eb 29                	jmp    103270 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  103247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10324b:	75 16                	jne    103263 <strtol+0x9a>
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	0f b6 00             	movzbl (%eax),%eax
  103253:	3c 30                	cmp    $0x30,%al
  103255:	75 0c                	jne    103263 <strtol+0x9a>
        s ++, base = 8;
  103257:	ff 45 08             	incl   0x8(%ebp)
  10325a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103261:	eb 0d                	jmp    103270 <strtol+0xa7>
    }
    else if (base == 0) {
  103263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103267:	75 07                	jne    103270 <strtol+0xa7>
        base = 10;
  103269:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103270:	8b 45 08             	mov    0x8(%ebp),%eax
  103273:	0f b6 00             	movzbl (%eax),%eax
  103276:	3c 2f                	cmp    $0x2f,%al
  103278:	7e 1b                	jle    103295 <strtol+0xcc>
  10327a:	8b 45 08             	mov    0x8(%ebp),%eax
  10327d:	0f b6 00             	movzbl (%eax),%eax
  103280:	3c 39                	cmp    $0x39,%al
  103282:	7f 11                	jg     103295 <strtol+0xcc>
            dig = *s - '0';
  103284:	8b 45 08             	mov    0x8(%ebp),%eax
  103287:	0f b6 00             	movzbl (%eax),%eax
  10328a:	0f be c0             	movsbl %al,%eax
  10328d:	83 e8 30             	sub    $0x30,%eax
  103290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103293:	eb 48                	jmp    1032dd <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103295:	8b 45 08             	mov    0x8(%ebp),%eax
  103298:	0f b6 00             	movzbl (%eax),%eax
  10329b:	3c 60                	cmp    $0x60,%al
  10329d:	7e 1b                	jle    1032ba <strtol+0xf1>
  10329f:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a2:	0f b6 00             	movzbl (%eax),%eax
  1032a5:	3c 7a                	cmp    $0x7a,%al
  1032a7:	7f 11                	jg     1032ba <strtol+0xf1>
            dig = *s - 'a' + 10;
  1032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ac:	0f b6 00             	movzbl (%eax),%eax
  1032af:	0f be c0             	movsbl %al,%eax
  1032b2:	83 e8 57             	sub    $0x57,%eax
  1032b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032b8:	eb 23                	jmp    1032dd <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bd:	0f b6 00             	movzbl (%eax),%eax
  1032c0:	3c 40                	cmp    $0x40,%al
  1032c2:	7e 3b                	jle    1032ff <strtol+0x136>
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	0f b6 00             	movzbl (%eax),%eax
  1032ca:	3c 5a                	cmp    $0x5a,%al
  1032cc:	7f 31                	jg     1032ff <strtol+0x136>
            dig = *s - 'A' + 10;
  1032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d1:	0f b6 00             	movzbl (%eax),%eax
  1032d4:	0f be c0             	movsbl %al,%eax
  1032d7:	83 e8 37             	sub    $0x37,%eax
  1032da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032e3:	7d 19                	jge    1032fe <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1032e5:	ff 45 08             	incl   0x8(%ebp)
  1032e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032eb:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032ef:	89 c2                	mov    %eax,%edx
  1032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032f4:	01 d0                	add    %edx,%eax
  1032f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1032f9:	e9 72 ff ff ff       	jmp    103270 <strtol+0xa7>
            break;
  1032fe:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1032ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103303:	74 08                	je     10330d <strtol+0x144>
        *endptr = (char *) s;
  103305:	8b 45 0c             	mov    0xc(%ebp),%eax
  103308:	8b 55 08             	mov    0x8(%ebp),%edx
  10330b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10330d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103311:	74 07                	je     10331a <strtol+0x151>
  103313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103316:	f7 d8                	neg    %eax
  103318:	eb 03                	jmp    10331d <strtol+0x154>
  10331a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10331d:	89 ec                	mov    %ebp,%esp
  10331f:	5d                   	pop    %ebp
  103320:	c3                   	ret    

00103321 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103321:	55                   	push   %ebp
  103322:	89 e5                	mov    %esp,%ebp
  103324:	83 ec 28             	sub    $0x28,%esp
  103327:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10332a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10332d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103330:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103334:	8b 45 08             	mov    0x8(%ebp),%eax
  103337:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10333a:	88 55 f7             	mov    %dl,-0x9(%ebp)
  10333d:	8b 45 10             	mov    0x10(%ebp),%eax
  103340:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103343:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103346:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10334a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10334d:	89 d7                	mov    %edx,%edi
  10334f:	f3 aa                	rep stos %al,%es:(%edi)
  103351:	89 fa                	mov    %edi,%edx
  103353:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103356:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103359:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10335c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10335f:	89 ec                	mov    %ebp,%esp
  103361:	5d                   	pop    %ebp
  103362:	c3                   	ret    

00103363 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103363:	55                   	push   %ebp
  103364:	89 e5                	mov    %esp,%ebp
  103366:	57                   	push   %edi
  103367:	56                   	push   %esi
  103368:	53                   	push   %ebx
  103369:	83 ec 30             	sub    $0x30,%esp
  10336c:	8b 45 08             	mov    0x8(%ebp),%eax
  10336f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103372:	8b 45 0c             	mov    0xc(%ebp),%eax
  103375:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103378:	8b 45 10             	mov    0x10(%ebp),%eax
  10337b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103381:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103384:	73 42                	jae    1033c8 <memmove+0x65>
  103386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10338c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10338f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103395:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10339b:	c1 e8 02             	shr    $0x2,%eax
  10339e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1033a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1033a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033a6:	89 d7                	mov    %edx,%edi
  1033a8:	89 c6                	mov    %eax,%esi
  1033aa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1033af:	83 e1 03             	and    $0x3,%ecx
  1033b2:	74 02                	je     1033b6 <memmove+0x53>
  1033b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033b6:	89 f0                	mov    %esi,%eax
  1033b8:	89 fa                	mov    %edi,%edx
  1033ba:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1033bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1033c6:	eb 36                	jmp    1033fe <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d1:	01 c2                	add    %eax,%edx
  1033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d6:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033dc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e2:	89 c1                	mov    %eax,%ecx
  1033e4:	89 d8                	mov    %ebx,%eax
  1033e6:	89 d6                	mov    %edx,%esi
  1033e8:	89 c7                	mov    %eax,%edi
  1033ea:	fd                   	std    
  1033eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033ed:	fc                   	cld    
  1033ee:	89 f8                	mov    %edi,%eax
  1033f0:	89 f2                	mov    %esi,%edx
  1033f2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033f5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1033fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033fe:	83 c4 30             	add    $0x30,%esp
  103401:	5b                   	pop    %ebx
  103402:	5e                   	pop    %esi
  103403:	5f                   	pop    %edi
  103404:	5d                   	pop    %ebp
  103405:	c3                   	ret    

00103406 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103406:	55                   	push   %ebp
  103407:	89 e5                	mov    %esp,%ebp
  103409:	57                   	push   %edi
  10340a:	56                   	push   %esi
  10340b:	83 ec 20             	sub    $0x20,%esp
  10340e:	8b 45 08             	mov    0x8(%ebp),%eax
  103411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103414:	8b 45 0c             	mov    0xc(%ebp),%eax
  103417:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10341a:	8b 45 10             	mov    0x10(%ebp),%eax
  10341d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103423:	c1 e8 02             	shr    $0x2,%eax
  103426:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10342b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10342e:	89 d7                	mov    %edx,%edi
  103430:	89 c6                	mov    %eax,%esi
  103432:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103434:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103437:	83 e1 03             	and    $0x3,%ecx
  10343a:	74 02                	je     10343e <memcpy+0x38>
  10343c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10343e:	89 f0                	mov    %esi,%eax
  103440:	89 fa                	mov    %edi,%edx
  103442:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103445:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103448:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10344b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10344e:	83 c4 20             	add    $0x20,%esp
  103451:	5e                   	pop    %esi
  103452:	5f                   	pop    %edi
  103453:	5d                   	pop    %ebp
  103454:	c3                   	ret    

00103455 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103455:	55                   	push   %ebp
  103456:	89 e5                	mov    %esp,%ebp
  103458:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10345b:	8b 45 08             	mov    0x8(%ebp),%eax
  10345e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103461:	8b 45 0c             	mov    0xc(%ebp),%eax
  103464:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103467:	eb 2e                	jmp    103497 <memcmp+0x42>
        if (*s1 != *s2) {
  103469:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10346c:	0f b6 10             	movzbl (%eax),%edx
  10346f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103472:	0f b6 00             	movzbl (%eax),%eax
  103475:	38 c2                	cmp    %al,%dl
  103477:	74 18                	je     103491 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103479:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10347c:	0f b6 00             	movzbl (%eax),%eax
  10347f:	0f b6 d0             	movzbl %al,%edx
  103482:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103485:	0f b6 00             	movzbl (%eax),%eax
  103488:	0f b6 c8             	movzbl %al,%ecx
  10348b:	89 d0                	mov    %edx,%eax
  10348d:	29 c8                	sub    %ecx,%eax
  10348f:	eb 18                	jmp    1034a9 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103491:	ff 45 fc             	incl   -0x4(%ebp)
  103494:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103497:	8b 45 10             	mov    0x10(%ebp),%eax
  10349a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10349d:	89 55 10             	mov    %edx,0x10(%ebp)
  1034a0:	85 c0                	test   %eax,%eax
  1034a2:	75 c5                	jne    103469 <memcmp+0x14>
    }
    return 0;
  1034a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034a9:	89 ec                	mov    %ebp,%esp
  1034ab:	5d                   	pop    %ebp
  1034ac:	c3                   	ret    
