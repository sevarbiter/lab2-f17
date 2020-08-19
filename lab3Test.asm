
_lab3Test:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
}
//#pragma GCC pop_options

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	83 ec 10             	sub    $0x10,%esp
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  int n, m;

  if(argc != 2){
    100d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    1011:	74 1f                	je     1032 <main+0x32>
    printf(1, "Usage: %s levels\n", argv[0]);
    1013:	8b 00                	mov    (%eax),%eax
    1015:	c7 44 24 04 b1 17 00 	movl   $0x17b1,0x4(%esp)
    101c:	00 
    101d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1024:	89 44 24 08          	mov    %eax,0x8(%esp)
    1028:	e8 e3 03 00 00       	call   1410 <printf>
    exit();
    102d:	e8 80 02 00 00       	call   12b2 <exit>
  }

  n = atoi(argv[1]);
    1032:	8b 40 04             	mov    0x4(%eax),%eax
    1035:	89 04 24             	mov    %eax,(%esp)
    1038:	e8 13 02 00 00       	call   1250 <atoi>
  printf(1, "Lab 3: Recursing %d levels\n", n);
    103d:	c7 44 24 04 c3 17 00 	movl   $0x17c3,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  n = atoi(argv[1]);
    104c:	89 c3                	mov    %eax,%ebx
  printf(1, "Lab 3: Recursing %d levels\n", n);
    104e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1052:	e8 b9 03 00 00       	call   1410 <printf>
  if(n == 0)
    1057:	31 c0                	xor    %eax,%eax
    1059:	85 db                	test   %ebx,%ebx
    105b:	74 0a                	je     1067 <main+0x67>
    105d:	8d 76 00             	lea    0x0(%esi),%esi
    1060:	01 d8                	add    %ebx,%eax
    1062:	83 eb 01             	sub    $0x1,%ebx
    1065:	75 f9                	jne    1060 <main+0x60>
  m = recurse(n);
  printf(1, "Lab 3: Yielded a value of %d\n", m);
    1067:	89 44 24 08          	mov    %eax,0x8(%esp)
    106b:	c7 44 24 04 df 17 00 	movl   $0x17df,0x4(%esp)
    1072:	00 
    1073:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    107a:	e8 91 03 00 00       	call   1410 <printf>
  exit();
    107f:	e8 2e 02 00 00       	call   12b2 <exit>
    1084:	66 90                	xchg   %ax,%ax
    1086:	66 90                	xchg   %ax,%ax
    1088:	66 90                	xchg   %ax,%ax
    108a:	66 90                	xchg   %ax,%ax
    108c:	66 90                	xchg   %ax,%ax
    108e:	66 90                	xchg   %ax,%ax

00001090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1099:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    109a:	89 c2                	mov    %eax,%edx
    109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10a0:	83 c1 01             	add    $0x1,%ecx
    10a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    10a7:	83 c2 01             	add    $0x1,%edx
    10aa:	84 db                	test   %bl,%bl
    10ac:	88 5a ff             	mov    %bl,-0x1(%edx)
    10af:	75 ef                	jne    10a0 <strcpy+0x10>
    ;
  return os;
}
    10b1:	5b                   	pop    %ebx
    10b2:	5d                   	pop    %ebp
    10b3:	c3                   	ret    
    10b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000010c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	8b 55 08             	mov    0x8(%ebp),%edx
    10c6:	53                   	push   %ebx
    10c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    10ca:	0f b6 02             	movzbl (%edx),%eax
    10cd:	84 c0                	test   %al,%al
    10cf:	74 2d                	je     10fe <strcmp+0x3e>
    10d1:	0f b6 19             	movzbl (%ecx),%ebx
    10d4:	38 d8                	cmp    %bl,%al
    10d6:	74 0e                	je     10e6 <strcmp+0x26>
    10d8:	eb 2b                	jmp    1105 <strcmp+0x45>
    10da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10e0:	38 c8                	cmp    %cl,%al
    10e2:	75 15                	jne    10f9 <strcmp+0x39>
    p++, q++;
    10e4:	89 d9                	mov    %ebx,%ecx
    10e6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10e9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    10ec:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    10ef:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    10f3:	84 c0                	test   %al,%al
    10f5:	75 e9                	jne    10e0 <strcmp+0x20>
    10f7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    10f9:	29 c8                	sub    %ecx,%eax
}
    10fb:	5b                   	pop    %ebx
    10fc:	5d                   	pop    %ebp
    10fd:	c3                   	ret    
    10fe:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
    1101:	31 c0                	xor    %eax,%eax
    1103:	eb f4                	jmp    10f9 <strcmp+0x39>
    1105:	0f b6 cb             	movzbl %bl,%ecx
    1108:	eb ef                	jmp    10f9 <strcmp+0x39>
    110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001110 <strlen>:

uint
strlen(char *s)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1116:	80 39 00             	cmpb   $0x0,(%ecx)
    1119:	74 12                	je     112d <strlen+0x1d>
    111b:	31 d2                	xor    %edx,%edx
    111d:	8d 76 00             	lea    0x0(%esi),%esi
    1120:	83 c2 01             	add    $0x1,%edx
    1123:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1127:	89 d0                	mov    %edx,%eax
    1129:	75 f5                	jne    1120 <strlen+0x10>
    ;
  return n;
}
    112b:	5d                   	pop    %ebp
    112c:	c3                   	ret    
  for(n = 0; s[n]; n++)
    112d:	31 c0                	xor    %eax,%eax
}
    112f:	5d                   	pop    %ebp
    1130:	c3                   	ret    
    1131:	eb 0d                	jmp    1140 <memset>
    1133:	90                   	nop
    1134:	90                   	nop
    1135:	90                   	nop
    1136:	90                   	nop
    1137:	90                   	nop
    1138:	90                   	nop
    1139:	90                   	nop
    113a:	90                   	nop
    113b:	90                   	nop
    113c:	90                   	nop
    113d:	90                   	nop
    113e:	90                   	nop
    113f:	90                   	nop

00001140 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1140:	55                   	push   %ebp
    1141:	89 e5                	mov    %esp,%ebp
    1143:	8b 55 08             	mov    0x8(%ebp),%edx
    1146:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1147:	8b 4d 10             	mov    0x10(%ebp),%ecx
    114a:	8b 45 0c             	mov    0xc(%ebp),%eax
    114d:	89 d7                	mov    %edx,%edi
    114f:	fc                   	cld    
    1150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1152:	89 d0                	mov    %edx,%eax
    1154:	5f                   	pop    %edi
    1155:	5d                   	pop    %ebp
    1156:	c3                   	ret    
    1157:	89 f6                	mov    %esi,%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001160 <strchr>:

char*
strchr(const char *s, char c)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	8b 45 08             	mov    0x8(%ebp),%eax
    1166:	53                   	push   %ebx
    1167:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    116a:	0f b6 18             	movzbl (%eax),%ebx
    116d:	84 db                	test   %bl,%bl
    116f:	74 1d                	je     118e <strchr+0x2e>
    if(*s == c)
    1171:	38 d3                	cmp    %dl,%bl
    1173:	89 d1                	mov    %edx,%ecx
    1175:	75 0d                	jne    1184 <strchr+0x24>
    1177:	eb 17                	jmp    1190 <strchr+0x30>
    1179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1180:	38 ca                	cmp    %cl,%dl
    1182:	74 0c                	je     1190 <strchr+0x30>
  for(; *s; s++)
    1184:	83 c0 01             	add    $0x1,%eax
    1187:	0f b6 10             	movzbl (%eax),%edx
    118a:	84 d2                	test   %dl,%dl
    118c:	75 f2                	jne    1180 <strchr+0x20>
      return (char*)s;
  return 0;
    118e:	31 c0                	xor    %eax,%eax
}
    1190:	5b                   	pop    %ebx
    1191:	5d                   	pop    %ebp
    1192:	c3                   	ret    
    1193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011a0 <gets>:

char*
gets(char *buf, int max)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	57                   	push   %edi
    11a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a5:	31 f6                	xor    %esi,%esi
{
    11a7:	53                   	push   %ebx
    11a8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
    11ab:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11ae:	eb 31                	jmp    11e1 <gets+0x41>
    cc = read(0, &c, 1);
    11b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11b7:	00 
    11b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
    11bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c3:	e8 02 01 00 00       	call   12ca <read>
    if(cc < 1)
    11c8:	85 c0                	test   %eax,%eax
    11ca:	7e 1d                	jle    11e9 <gets+0x49>
      break;
    buf[i++] = c;
    11cc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
    11d0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
    11d2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    11d5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
    11d7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    11db:	74 0c                	je     11e9 <gets+0x49>
    11dd:	3c 0a                	cmp    $0xa,%al
    11df:	74 08                	je     11e9 <gets+0x49>
  for(i=0; i+1 < max; ){
    11e1:	8d 5e 01             	lea    0x1(%esi),%ebx
    11e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11e7:	7c c7                	jl     11b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    11e9:	8b 45 08             	mov    0x8(%ebp),%eax
    11ec:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    11f0:	83 c4 2c             	add    $0x2c,%esp
    11f3:	5b                   	pop    %ebx
    11f4:	5e                   	pop    %esi
    11f5:	5f                   	pop    %edi
    11f6:	5d                   	pop    %ebp
    11f7:	c3                   	ret    
    11f8:	90                   	nop
    11f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001200 <stat>:

int
stat(char *n, struct stat *st)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	56                   	push   %esi
    1204:	53                   	push   %ebx
    1205:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1208:	8b 45 08             	mov    0x8(%ebp),%eax
    120b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1212:	00 
    1213:	89 04 24             	mov    %eax,(%esp)
    1216:	e8 d7 00 00 00       	call   12f2 <open>
  if(fd < 0)
    121b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
    121d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    121f:	78 27                	js     1248 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1221:	8b 45 0c             	mov    0xc(%ebp),%eax
    1224:	89 1c 24             	mov    %ebx,(%esp)
    1227:	89 44 24 04          	mov    %eax,0x4(%esp)
    122b:	e8 da 00 00 00       	call   130a <fstat>
  close(fd);
    1230:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    1233:	89 c6                	mov    %eax,%esi
  close(fd);
    1235:	e8 a0 00 00 00       	call   12da <close>
  return r;
    123a:	89 f0                	mov    %esi,%eax
}
    123c:	83 c4 10             	add    $0x10,%esp
    123f:	5b                   	pop    %ebx
    1240:	5e                   	pop    %esi
    1241:	5d                   	pop    %ebp
    1242:	c3                   	ret    
    1243:	90                   	nop
    1244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    124d:	eb ed                	jmp    123c <stat+0x3c>
    124f:	90                   	nop

00001250 <atoi>:

int
atoi(const char *s)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1256:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1257:	0f be 11             	movsbl (%ecx),%edx
    125a:	8d 42 d0             	lea    -0x30(%edx),%eax
    125d:	3c 09                	cmp    $0x9,%al
  n = 0;
    125f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1264:	77 17                	ja     127d <atoi+0x2d>
    1266:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1268:	83 c1 01             	add    $0x1,%ecx
    126b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    126e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1272:	0f be 11             	movsbl (%ecx),%edx
    1275:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1278:	80 fb 09             	cmp    $0x9,%bl
    127b:	76 eb                	jbe    1268 <atoi+0x18>
  return n;
}
    127d:	5b                   	pop    %ebx
    127e:	5d                   	pop    %ebp
    127f:	c3                   	ret    

00001280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1280:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1281:	31 d2                	xor    %edx,%edx
{
    1283:	89 e5                	mov    %esp,%ebp
    1285:	56                   	push   %esi
    1286:	8b 45 08             	mov    0x8(%ebp),%eax
    1289:	53                   	push   %ebx
    128a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    128d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
    1290:	85 db                	test   %ebx,%ebx
    1292:	7e 12                	jle    12a6 <memmove+0x26>
    1294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1298:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    129c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    129f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12a2:	39 da                	cmp    %ebx,%edx
    12a4:	75 f2                	jne    1298 <memmove+0x18>
  return vdst;
}
    12a6:	5b                   	pop    %ebx
    12a7:	5e                   	pop    %esi
    12a8:	5d                   	pop    %ebp
    12a9:	c3                   	ret    

000012aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12aa:	b8 01 00 00 00       	mov    $0x1,%eax
    12af:	cd 40                	int    $0x40
    12b1:	c3                   	ret    

000012b2 <exit>:
SYSCALL(exit)
    12b2:	b8 02 00 00 00       	mov    $0x2,%eax
    12b7:	cd 40                	int    $0x40
    12b9:	c3                   	ret    

000012ba <wait>:
SYSCALL(wait)
    12ba:	b8 03 00 00 00       	mov    $0x3,%eax
    12bf:	cd 40                	int    $0x40
    12c1:	c3                   	ret    

000012c2 <pipe>:
SYSCALL(pipe)
    12c2:	b8 04 00 00 00       	mov    $0x4,%eax
    12c7:	cd 40                	int    $0x40
    12c9:	c3                   	ret    

000012ca <read>:
SYSCALL(read)
    12ca:	b8 05 00 00 00       	mov    $0x5,%eax
    12cf:	cd 40                	int    $0x40
    12d1:	c3                   	ret    

000012d2 <write>:
SYSCALL(write)
    12d2:	b8 10 00 00 00       	mov    $0x10,%eax
    12d7:	cd 40                	int    $0x40
    12d9:	c3                   	ret    

000012da <close>:
SYSCALL(close)
    12da:	b8 15 00 00 00       	mov    $0x15,%eax
    12df:	cd 40                	int    $0x40
    12e1:	c3                   	ret    

000012e2 <kill>:
SYSCALL(kill)
    12e2:	b8 06 00 00 00       	mov    $0x6,%eax
    12e7:	cd 40                	int    $0x40
    12e9:	c3                   	ret    

000012ea <exec>:
SYSCALL(exec)
    12ea:	b8 07 00 00 00       	mov    $0x7,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <open>:
SYSCALL(open)
    12f2:	b8 0f 00 00 00       	mov    $0xf,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <mknod>:
SYSCALL(mknod)
    12fa:	b8 11 00 00 00       	mov    $0x11,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <unlink>:
SYSCALL(unlink)
    1302:	b8 12 00 00 00       	mov    $0x12,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    

0000130a <fstat>:
SYSCALL(fstat)
    130a:	b8 08 00 00 00       	mov    $0x8,%eax
    130f:	cd 40                	int    $0x40
    1311:	c3                   	ret    

00001312 <link>:
SYSCALL(link)
    1312:	b8 13 00 00 00       	mov    $0x13,%eax
    1317:	cd 40                	int    $0x40
    1319:	c3                   	ret    

0000131a <mkdir>:
SYSCALL(mkdir)
    131a:	b8 14 00 00 00       	mov    $0x14,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    

00001322 <chdir>:
SYSCALL(chdir)
    1322:	b8 09 00 00 00       	mov    $0x9,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <dup>:
SYSCALL(dup)
    132a:	b8 0a 00 00 00       	mov    $0xa,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <getpid>:
SYSCALL(getpid)
    1332:	b8 0b 00 00 00       	mov    $0xb,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <sbrk>:
SYSCALL(sbrk)
    133a:	b8 0c 00 00 00       	mov    $0xc,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <sleep>:
SYSCALL(sleep)
    1342:	b8 0d 00 00 00       	mov    $0xd,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <uptime>:
SYSCALL(uptime)
    134a:	b8 0e 00 00 00       	mov    $0xe,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <shm_open>:
SYSCALL(shm_open)
    1352:	b8 16 00 00 00       	mov    $0x16,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <shm_close>:
SYSCALL(shm_close)	
    135a:	b8 17 00 00 00       	mov    $0x17,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    
    1362:	66 90                	xchg   %ax,%ax
    1364:	66 90                	xchg   %ax,%ax
    1366:	66 90                	xchg   %ax,%ax
    1368:	66 90                	xchg   %ax,%ax
    136a:	66 90                	xchg   %ax,%ax
    136c:	66 90                	xchg   %ax,%ax
    136e:	66 90                	xchg   %ax,%ax

00001370 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1370:	55                   	push   %ebp
    1371:	89 e5                	mov    %esp,%ebp
    1373:	57                   	push   %edi
    1374:	56                   	push   %esi
    1375:	89 c6                	mov    %eax,%esi
    1377:	53                   	push   %ebx
    1378:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    137b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    137e:	85 db                	test   %ebx,%ebx
    1380:	74 09                	je     138b <printint+0x1b>
    1382:	89 d0                	mov    %edx,%eax
    1384:	c1 e8 1f             	shr    $0x1f,%eax
    1387:	84 c0                	test   %al,%al
    1389:	75 75                	jne    1400 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    138b:	89 d0                	mov    %edx,%eax
  neg = 0;
    138d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1394:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
    1397:	31 ff                	xor    %edi,%edi
    1399:	89 ce                	mov    %ecx,%esi
    139b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    139e:	eb 02                	jmp    13a2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    13a0:	89 cf                	mov    %ecx,%edi
    13a2:	31 d2                	xor    %edx,%edx
    13a4:	f7 f6                	div    %esi
    13a6:	8d 4f 01             	lea    0x1(%edi),%ecx
    13a9:	0f b6 92 04 18 00 00 	movzbl 0x1804(%edx),%edx
  }while((x /= base) != 0);
    13b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    13b2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    13b5:	75 e9                	jne    13a0 <printint+0x30>
  if(neg)
    13b7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
    13ba:	89 c8                	mov    %ecx,%eax
    13bc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
    13bf:	85 d2                	test   %edx,%edx
    13c1:	74 08                	je     13cb <printint+0x5b>
    buf[i++] = '-';
    13c3:	8d 4f 02             	lea    0x2(%edi),%ecx
    13c6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    13cb:	8d 79 ff             	lea    -0x1(%ecx),%edi
    13ce:	66 90                	xchg   %ax,%ax
    13d0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    13d5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
    13d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13df:	00 
    13e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    13e4:	89 34 24             	mov    %esi,(%esp)
    13e7:	88 45 d7             	mov    %al,-0x29(%ebp)
    13ea:	e8 e3 fe ff ff       	call   12d2 <write>
  while(--i >= 0)
    13ef:	83 ff ff             	cmp    $0xffffffff,%edi
    13f2:	75 dc                	jne    13d0 <printint+0x60>
    putc(fd, buf[i]);
}
    13f4:	83 c4 4c             	add    $0x4c,%esp
    13f7:	5b                   	pop    %ebx
    13f8:	5e                   	pop    %esi
    13f9:	5f                   	pop    %edi
    13fa:	5d                   	pop    %ebp
    13fb:	c3                   	ret    
    13fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
    1400:	89 d0                	mov    %edx,%eax
    1402:	f7 d8                	neg    %eax
    neg = 1;
    1404:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    140b:	eb 87                	jmp    1394 <printint+0x24>
    140d:	8d 76 00             	lea    0x0(%esi),%esi

00001410 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1414:	31 ff                	xor    %edi,%edi
{
    1416:	56                   	push   %esi
    1417:	53                   	push   %ebx
    1418:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    141b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
    141e:	8d 45 10             	lea    0x10(%ebp),%eax
{
    1421:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
    1424:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1427:	0f b6 13             	movzbl (%ebx),%edx
    142a:	83 c3 01             	add    $0x1,%ebx
    142d:	84 d2                	test   %dl,%dl
    142f:	75 39                	jne    146a <printf+0x5a>
    1431:	e9 c2 00 00 00       	jmp    14f8 <printf+0xe8>
    1436:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1438:	83 fa 25             	cmp    $0x25,%edx
    143b:	0f 84 bf 00 00 00    	je     1500 <printf+0xf0>
  write(fd, &c, 1);
    1441:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1444:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    144b:	00 
    144c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1450:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
    1453:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
    1456:	e8 77 fe ff ff       	call   12d2 <write>
    145b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
    145e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1462:	84 d2                	test   %dl,%dl
    1464:	0f 84 8e 00 00 00    	je     14f8 <printf+0xe8>
    if(state == 0){
    146a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    146c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    146f:	74 c7                	je     1438 <printf+0x28>
      }
    } else if(state == '%'){
    1471:	83 ff 25             	cmp    $0x25,%edi
    1474:	75 e5                	jne    145b <printf+0x4b>
      if(c == 'd'){
    1476:	83 fa 64             	cmp    $0x64,%edx
    1479:	0f 84 31 01 00 00    	je     15b0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    147f:	25 f7 00 00 00       	and    $0xf7,%eax
    1484:	83 f8 70             	cmp    $0x70,%eax
    1487:	0f 84 83 00 00 00    	je     1510 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    148d:	83 fa 73             	cmp    $0x73,%edx
    1490:	0f 84 a2 00 00 00    	je     1538 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1496:	83 fa 63             	cmp    $0x63,%edx
    1499:	0f 84 35 01 00 00    	je     15d4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    149f:	83 fa 25             	cmp    $0x25,%edx
    14a2:	0f 84 e0 00 00 00    	je     1588 <printf+0x178>
  write(fd, &c, 1);
    14a8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    14ab:	83 c3 01             	add    $0x1,%ebx
    14ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14b5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    14b6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    14b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14bc:	89 34 24             	mov    %esi,(%esp)
    14bf:	89 55 d0             	mov    %edx,-0x30(%ebp)
    14c2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    14c6:	e8 07 fe ff ff       	call   12d2 <write>
        putc(fd, c);
    14cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
    14ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
    14d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14d8:	00 
    14d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    14dd:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
    14e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    14e3:	e8 ea fd ff ff       	call   12d2 <write>
  for(i = 0; fmt[i]; i++){
    14e8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    14ec:	84 d2                	test   %dl,%dl
    14ee:	0f 85 76 ff ff ff    	jne    146a <printf+0x5a>
    14f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
    14f8:	83 c4 3c             	add    $0x3c,%esp
    14fb:	5b                   	pop    %ebx
    14fc:	5e                   	pop    %esi
    14fd:	5f                   	pop    %edi
    14fe:	5d                   	pop    %ebp
    14ff:	c3                   	ret    
        state = '%';
    1500:	bf 25 00 00 00       	mov    $0x25,%edi
    1505:	e9 51 ff ff ff       	jmp    145b <printf+0x4b>
    150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1510:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1513:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
    1518:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
    151a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1521:	8b 10                	mov    (%eax),%edx
    1523:	89 f0                	mov    %esi,%eax
    1525:	e8 46 fe ff ff       	call   1370 <printint>
        ap++;
    152a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    152e:	e9 28 ff ff ff       	jmp    145b <printf+0x4b>
    1533:	90                   	nop
    1534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    153b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
    153f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
    1541:	b8 fd 17 00 00       	mov    $0x17fd,%eax
    1546:	85 ff                	test   %edi,%edi
    1548:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    154b:	0f b6 07             	movzbl (%edi),%eax
    154e:	84 c0                	test   %al,%al
    1550:	74 2a                	je     157c <printf+0x16c>
    1552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1558:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    155b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
    155e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
    1561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1568:	00 
    1569:	89 44 24 04          	mov    %eax,0x4(%esp)
    156d:	89 34 24             	mov    %esi,(%esp)
    1570:	e8 5d fd ff ff       	call   12d2 <write>
        while(*s != 0){
    1575:	0f b6 07             	movzbl (%edi),%eax
    1578:	84 c0                	test   %al,%al
    157a:	75 dc                	jne    1558 <printf+0x148>
      state = 0;
    157c:	31 ff                	xor    %edi,%edi
    157e:	e9 d8 fe ff ff       	jmp    145b <printf+0x4b>
    1583:	90                   	nop
    1584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
    1588:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
    158b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    158d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1594:	00 
    1595:	89 44 24 04          	mov    %eax,0x4(%esp)
    1599:	89 34 24             	mov    %esi,(%esp)
    159c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    15a0:	e8 2d fd ff ff       	call   12d2 <write>
    15a5:	e9 b1 fe ff ff       	jmp    145b <printf+0x4b>
    15aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    15b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    15b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
    15b8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
    15bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c2:	8b 10                	mov    (%eax),%edx
    15c4:	89 f0                	mov    %esi,%eax
    15c6:	e8 a5 fd ff ff       	call   1370 <printint>
        ap++;
    15cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    15cf:	e9 87 fe ff ff       	jmp    145b <printf+0x4b>
        putc(fd, *ap);
    15d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
    15d7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
    15d9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    15db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15e2:	00 
    15e3:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
    15e6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    15e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    15ec:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f0:	e8 dd fc ff ff       	call   12d2 <write>
        ap++;
    15f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    15f9:	e9 5d fe ff ff       	jmp    145b <printf+0x4b>
    15fe:	66 90                	xchg   %ax,%ax

00001600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1601:	a1 bc 1a 00 00       	mov    0x1abc,%eax
{
    1606:	89 e5                	mov    %esp,%ebp
    1608:	57                   	push   %edi
    1609:	56                   	push   %esi
    160a:	53                   	push   %ebx
    160b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    160e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
    1610:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1613:	39 d0                	cmp    %edx,%eax
    1615:	72 11                	jb     1628 <free+0x28>
    1617:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1618:	39 c8                	cmp    %ecx,%eax
    161a:	72 04                	jb     1620 <free+0x20>
    161c:	39 ca                	cmp    %ecx,%edx
    161e:	72 10                	jb     1630 <free+0x30>
    1620:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1622:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1624:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1626:	73 f0                	jae    1618 <free+0x18>
    1628:	39 ca                	cmp    %ecx,%edx
    162a:	72 04                	jb     1630 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    162c:	39 c8                	cmp    %ecx,%eax
    162e:	72 f0                	jb     1620 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1630:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1633:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    1636:	39 cf                	cmp    %ecx,%edi
    1638:	74 1e                	je     1658 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    163a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    163d:	8b 48 04             	mov    0x4(%eax),%ecx
    1640:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1643:	39 f2                	cmp    %esi,%edx
    1645:	74 28                	je     166f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1647:	89 10                	mov    %edx,(%eax)
  freep = p;
    1649:	a3 bc 1a 00 00       	mov    %eax,0x1abc
}
    164e:	5b                   	pop    %ebx
    164f:	5e                   	pop    %esi
    1650:	5f                   	pop    %edi
    1651:	5d                   	pop    %ebp
    1652:	c3                   	ret    
    1653:	90                   	nop
    1654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1658:	03 71 04             	add    0x4(%ecx),%esi
    165b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    165e:	8b 08                	mov    (%eax),%ecx
    1660:	8b 09                	mov    (%ecx),%ecx
    1662:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1665:	8b 48 04             	mov    0x4(%eax),%ecx
    1668:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    166b:	39 f2                	cmp    %esi,%edx
    166d:	75 d8                	jne    1647 <free+0x47>
    p->s.size += bp->s.size;
    166f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
    1672:	a3 bc 1a 00 00       	mov    %eax,0x1abc
    p->s.size += bp->s.size;
    1677:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    167a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    167d:	89 10                	mov    %edx,(%eax)
}
    167f:	5b                   	pop    %ebx
    1680:	5e                   	pop    %esi
    1681:	5f                   	pop    %edi
    1682:	5d                   	pop    %ebp
    1683:	c3                   	ret    
    1684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    168a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1690:	55                   	push   %ebp
    1691:	89 e5                	mov    %esp,%ebp
    1693:	57                   	push   %edi
    1694:	56                   	push   %esi
    1695:	53                   	push   %ebx
    1696:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    169c:	8b 1d bc 1a 00 00    	mov    0x1abc,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16a2:	8d 48 07             	lea    0x7(%eax),%ecx
    16a5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    16a8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16aa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    16ad:	0f 84 9b 00 00 00    	je     174e <malloc+0xbe>
    16b3:	8b 13                	mov    (%ebx),%edx
    16b5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    16b8:	39 fe                	cmp    %edi,%esi
    16ba:	76 64                	jbe    1720 <malloc+0x90>
    16bc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
    16c3:	bb 00 80 00 00       	mov    $0x8000,%ebx
    16c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    16cb:	eb 0e                	jmp    16db <malloc+0x4b>
    16cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16d2:	8b 78 04             	mov    0x4(%eax),%edi
    16d5:	39 fe                	cmp    %edi,%esi
    16d7:	76 4f                	jbe    1728 <malloc+0x98>
    16d9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16db:	3b 15 bc 1a 00 00    	cmp    0x1abc,%edx
    16e1:	75 ed                	jne    16d0 <malloc+0x40>
  if(nu < 4096)
    16e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16e6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    16ec:	bf 00 10 00 00       	mov    $0x1000,%edi
    16f1:	0f 43 fe             	cmovae %esi,%edi
    16f4:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
    16f7:	89 04 24             	mov    %eax,(%esp)
    16fa:	e8 3b fc ff ff       	call   133a <sbrk>
  if(p == (char*)-1)
    16ff:	83 f8 ff             	cmp    $0xffffffff,%eax
    1702:	74 18                	je     171c <malloc+0x8c>
  hp->s.size = nu;
    1704:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1707:	83 c0 08             	add    $0x8,%eax
    170a:	89 04 24             	mov    %eax,(%esp)
    170d:	e8 ee fe ff ff       	call   1600 <free>
  return freep;
    1712:	8b 15 bc 1a 00 00    	mov    0x1abc,%edx
      if((p = morecore(nunits)) == 0)
    1718:	85 d2                	test   %edx,%edx
    171a:	75 b4                	jne    16d0 <malloc+0x40>
        return 0;
    171c:	31 c0                	xor    %eax,%eax
    171e:	eb 20                	jmp    1740 <malloc+0xb0>
    if(p->s.size >= nunits){
    1720:	89 d0                	mov    %edx,%eax
    1722:	89 da                	mov    %ebx,%edx
    1724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1728:	39 fe                	cmp    %edi,%esi
    172a:	74 1c                	je     1748 <malloc+0xb8>
        p->s.size -= nunits;
    172c:	29 f7                	sub    %esi,%edi
    172e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    1731:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    1734:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    1737:	89 15 bc 1a 00 00    	mov    %edx,0x1abc
      return (void*)(p + 1);
    173d:	83 c0 08             	add    $0x8,%eax
  }
}
    1740:	83 c4 1c             	add    $0x1c,%esp
    1743:	5b                   	pop    %ebx
    1744:	5e                   	pop    %esi
    1745:	5f                   	pop    %edi
    1746:	5d                   	pop    %ebp
    1747:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1748:	8b 08                	mov    (%eax),%ecx
    174a:	89 0a                	mov    %ecx,(%edx)
    174c:	eb e9                	jmp    1737 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
    174e:	c7 05 bc 1a 00 00 c0 	movl   $0x1ac0,0x1abc
    1755:	1a 00 00 
    base.s.size = 0;
    1758:	ba c0 1a 00 00       	mov    $0x1ac0,%edx
    base.s.ptr = freep = prevp = &base;
    175d:	c7 05 c0 1a 00 00 c0 	movl   $0x1ac0,0x1ac0
    1764:	1a 00 00 
    base.s.size = 0;
    1767:	c7 05 c4 1a 00 00 00 	movl   $0x0,0x1ac4
    176e:	00 00 00 
    1771:	e9 46 ff ff ff       	jmp    16bc <malloc+0x2c>
    1776:	66 90                	xchg   %ax,%ax
    1778:	66 90                	xchg   %ax,%ax
    177a:	66 90                	xchg   %ax,%ax
    177c:	66 90                	xchg   %ax,%ax
    177e:	66 90                	xchg   %ax,%ax

00001780 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1780:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1781:	b9 01 00 00 00       	mov    $0x1,%ecx
    1786:	89 e5                	mov    %esp,%ebp
    1788:	8b 55 08             	mov    0x8(%ebp),%edx
    178b:	90                   	nop
    178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1790:	89 c8                	mov    %ecx,%eax
    1792:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1795:	85 c0                	test   %eax,%eax
    1797:	75 f7                	jne    1790 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1799:	0f ae f0             	mfence 
}
    179c:	5d                   	pop    %ebp
    179d:	c3                   	ret    
    179e:	66 90                	xchg   %ax,%ax

000017a0 <urelease>:

void urelease (struct uspinlock *lk) {
    17a0:	55                   	push   %ebp
    17a1:	89 e5                	mov    %esp,%ebp
    17a3:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    17a6:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    17a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    17af:	5d                   	pop    %ebp
    17b0:	c3                   	ret    
