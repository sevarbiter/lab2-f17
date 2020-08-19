
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2e 10 80       	mov    $0x80102e40,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 80 6e 10 	movl   $0x80106e80,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 40 40 00 00       	call   801040a0 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 87 6e 10 	movl   $0x80106e87,0x4(%esp)
8010009b:	80 
8010009c:	e8 ef 3e 00 00       	call   80103f90 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 a5 40 00 00       	call   80104190 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 1a 41 00 00       	call   80104280 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 5f 3e 00 00       	call   80103fd0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 f2 1f 00 00       	call   80102170 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 8e 6e 10 80 	movl   $0x80106e8e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 bb 3e 00 00       	call   80104070 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 a7 1f 00 00       	jmp    80102170 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 9f 6e 10 80 	movl   $0x80106e9f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 7a 3e 00 00       	call   80104070 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 2e 3e 00 00       	call   80104030 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 82 3f 00 00       	call   80104190 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 2b 40 00 00       	jmp    80104280 <release>
    panic("brelse");
80100255:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 59 15 00 00       	call   801017e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 fd 3e 00 00       	call   80104190 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 43 34 00 00       	call   801036f0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 88 39 00 00       	call   80103c50 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 6a 3f 00 00       	call   80104280 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 e2 13 00 00       	call   80101700 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 4c 3f 00 00       	call   80104280 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 c4 13 00 00       	call   80101700 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 35 24 00 00       	call   801027b0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ad 6e 10 80 	movl   $0x80106ead,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 67 78 10 80 	movl   $0x80107867,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 0c 3d 00 00       	call   801040c0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 c1 6e 10 80 	movl   $0x80106ec1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 82 54 00 00       	call   80105890 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 d2 53 00 00       	call   80105890 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 c6 53 00 00       	call   80105890 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ba 53 00 00       	call   80105890 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 6f 3e 00 00       	call   80104370 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 b2 3d 00 00       	call   801042d0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 c5 6e 10 80 	movl   $0x80106ec5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 f0 6e 10 80 	movzbl -0x7fef9110(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 d9 11 00 00       	call   801017e0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 7d 3b 00 00       	call   80104190 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 45 3c 00 00       	call   80104280 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 ba 10 00 00       	call   80101700 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 88 3b 00 00       	call   80104280 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 d8 6e 10 80       	mov    $0x80106ed8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 f4 39 00 00       	call   80104190 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 c6 39 00 00       	call   80104190 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 54 3a 00 00       	call   80104280 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 29 35 00 00       	call   80103de0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 94 35 00 00       	jmp    80103ec0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 e8 6e 10 	movl   $0x80106ee8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 36 37 00 00       	call   801040a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 64 19 00 00       	call   80102300 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 3f 2d 00 00       	call   801036f0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 a4 21 00 00       	call   80102b60 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 89 15 00 00       	call   80101f50 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c4 01 00 00    	je     80100b95 <exec+0x1f5>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 27 0d 00 00       	call   80101700 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 b5 0f 00 00       	call   801019b0 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 58 0f 00 00       	call   80101960 <iunlockput>
    end_op();
80100a08:	e8 c3 21 00 00       	call   80102bd0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 6f 60 00 00       	call   80106aa0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 1d 0f 00 00       	call   801019b0 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 29 5e 00 00       	call   80106900 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 28 5d 00 00       	call   80106840 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 f2 5e 00 00       	call   80106a20 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 25 0e 00 00       	call   80101960 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 8b 20 00 00       	call   80102bd0 <end_op>
  cprintf("%d\n", ustackbase);
80100b45:	c7 44 24 04 fc ff ff 	movl   $0x7ffffffc,0x4(%esp)
80100b4c:	7f 
80100b4d:	c7 04 24 74 73 10 80 	movl   $0x80107374,(%esp)
80100b54:	e8 f7 fa ff ff       	call   80100650 <cprintf>
  sp = allocuvm(pgdir, ustackbase - PGSIZE, ustackbase);
80100b59:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b5f:	c7 44 24 08 fc ff ff 	movl   $0x7ffffffc,0x8(%esp)
80100b66:	7f 
80100b67:	c7 44 24 04 fc ef ff 	movl   $0x7fffeffc,0x4(%esp)
80100b6e:	7f 
80100b6f:	89 04 24             	mov    %eax,(%esp)
80100b72:	e8 89 5d 00 00       	call   80106900 <allocuvm>
  if(!sp)
80100b77:	85 c0                	test   %eax,%eax
  sp = allocuvm(pgdir, ustackbase - PGSIZE, ustackbase);
80100b79:	89 c3                	mov    %eax,%ebx
  if(!sp)
80100b7b:	75 33                	jne    80100bb0 <exec+0x210>
    freevm(pgdir);
80100b7d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b83:	89 04 24             	mov    %eax,(%esp)
80100b86:	e8 95 5e 00 00       	call   80106a20 <freevm>
  return -1;
80100b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b90:	e9 7d fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b95:	e8 36 20 00 00       	call   80102bd0 <end_op>
    cprintf("exec: fail\n");
80100b9a:	c7 04 24 01 6f 10 80 	movl   $0x80106f01,(%esp)
80100ba1:	e8 aa fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bab:	e9 62 fe ff ff       	jmp    80100a12 <exec+0x72>
  curproc->userStack_pages = 1;
80100bb0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bb6:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  sz = PGROUNDUP(sz);
80100bbd:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bc3:	05 ff 0f 00 00       	add    $0xfff,%eax
  sz = PGROUNDUP(sz);
80100bc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bcd:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bd7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bdd:	89 54 24 08          	mov    %edx,0x8(%esp)
80100be1:	89 04 24             	mov    %eax,(%esp)
80100be4:	e8 17 5d 00 00       	call   80106900 <allocuvm>
80100be9:	85 c0                	test   %eax,%eax
80100beb:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100bf1:	74 8a                	je     80100b7d <exec+0x1dd>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf3:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c02:	89 04 24             	mov    %eax,(%esp)
80100c05:	e8 46 5f 00 00       	call   80106b50 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0d:	8b 00                	mov    (%eax),%eax
80100c0f:	85 c0                	test   %eax,%eax
80100c11:	0f 84 61 01 00 00    	je     80100d78 <exec+0x3d8>
80100c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100c1a:	31 f6                	xor    %esi,%esi
80100c1c:	8d 51 04             	lea    0x4(%ecx),%edx
80100c1f:	89 cf                	mov    %ecx,%edi
80100c21:	89 d1                	mov    %edx,%ecx
80100c23:	89 f2                	mov    %esi,%edx
80100c25:	89 fe                	mov    %edi,%esi
80100c27:	89 cf                	mov    %ecx,%edi
80100c29:	eb 11                	jmp    80100c3c <exec+0x29c>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c30:	83 c7 04             	add    $0x4,%edi
    if(argc >= MAXARG)
80100c33:	83 fa 20             	cmp    $0x20,%edx
80100c36:	0f 84 41 ff ff ff    	je     80100b7d <exec+0x1dd>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3c:	89 04 24             	mov    %eax,(%esp)
80100c3f:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c45:	e8 a6 38 00 00       	call   801044f0 <strlen>
80100c4a:	f7 d0                	not    %eax
80100c4c:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4e:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c50:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 95 38 00 00       	call   801044f0 <strlen>
80100c5b:	83 c0 01             	add    $0x1,%eax
80100c5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c62:	8b 06                	mov    (%esi),%eax
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c68:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c6c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c72:	89 04 24             	mov    %eax,(%esp)
80100c75:	e8 f6 60 00 00       	call   80106d70 <copyout>
80100c7a:	85 c0                	test   %eax,%eax
80100c7c:	0f 88 fb fe ff ff    	js     80100b7d <exec+0x1dd>
    ustack[3+argc] = sp;
80100c82:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c88:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100c8e:	89 fe                	mov    %edi,%esi
80100c90:	8b 07                	mov    (%edi),%eax
    ustack[3+argc] = sp;
80100c92:	89 9c 95 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100c99:	83 c2 01             	add    $0x1,%edx
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	75 90                	jne    80100c30 <exec+0x290>
80100ca0:	89 d6                	mov    %edx,%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca2:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100ca9:	89 da                	mov    %ebx,%edx
80100cab:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100cad:	83 c0 0c             	add    $0xc,%eax
80100cb0:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100cb6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cbc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100cc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[3+argc] = 0;
80100cc4:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100ccb:	00 00 00 00 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ccf:	89 04 24             	mov    %eax,(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100cd2:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cd9:	ff ff ff 
  ustack[1] = argc;
80100cdc:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce2:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ce8:	e8 83 60 00 00       	call   80106d70 <copyout>
80100ced:	85 c0                	test   %eax,%eax
80100cef:	0f 88 88 fe ff ff    	js     80100b7d <exec+0x1dd>
  for(last=s=path; *s; s++)
80100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80100cf8:	0f b6 10             	movzbl (%eax),%edx
80100cfb:	84 d2                	test   %dl,%dl
80100cfd:	74 1a                	je     80100d19 <exec+0x379>
80100cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d02:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100d05:	80 fa 2f             	cmp    $0x2f,%dl
80100d08:	0f 44 c8             	cmove  %eax,%ecx
80100d0b:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100d0e:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100d12:	84 d2                	test   %dl,%dl
80100d14:	75 ef                	jne    80100d05 <exec+0x365>
80100d16:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d19:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d22:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100d29:	00 
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	89 f8                	mov    %edi,%eax
80100d30:	83 c0 6c             	add    $0x6c,%eax
80100d33:	89 04 24             	mov    %eax,(%esp)
80100d36:	e8 75 37 00 00       	call   801044b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d3b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d41:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100d44:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d47:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d4a:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d50:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d52:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d58:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d5b:	8b 47 18             	mov    0x18(%edi),%eax
80100d5e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d61:	89 3c 24             	mov    %edi,(%esp)
80100d64:	e8 37 59 00 00       	call   801066a0 <switchuvm>
  freevm(oldpgdir);
80100d69:	89 34 24             	mov    %esi,(%esp)
80100d6c:	e8 af 5c 00 00       	call   80106a20 <freevm>
  return 0;
80100d71:	31 c0                	xor    %eax,%eax
80100d73:	e9 9a fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d78:	31 f6                	xor    %esi,%esi
80100d7a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d80:	e9 1d ff ff ff       	jmp    80100ca2 <exec+0x302>
80100d85:	66 90                	xchg   %ax,%ax
80100d87:	66 90                	xchg   %ax,%ax
80100d89:	66 90                	xchg   %ax,%ax
80100d8b:	66 90                	xchg   %ax,%ax
80100d8d:	66 90                	xchg   %ax,%ax
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	c7 44 24 04 0d 6f 10 	movl   $0x80106f0d,0x4(%esp)
80100d9d:	80 
80100d9e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da5:	e8 f6 32 00 00       	call   801040a0 <initlock>
}
80100daa:	c9                   	leave  
80100dab:	c3                   	ret    
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100db9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100dbc:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc3:	e8 c8 33 00 00       	call   80104190 <acquire>
80100dc8:	eb 11                	jmp    80100ddb <filealloc+0x2b>
80100dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dd9:	74 25                	je     80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100de9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100df0:	e8 8b 34 00 00       	call   80104280 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df5:	83 c4 14             	add    $0x14,%esp
      return f;
80100df8:	89 d8                	mov    %ebx,%eax
}
80100dfa:	5b                   	pop    %ebx
80100dfb:	5d                   	pop    %ebp
80100dfc:	c3                   	ret    
80100dfd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100e00:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e07:	e8 74 34 00 00       	call   80104280 <release>
}
80100e0c:	83 c4 14             	add    $0x14,%esp
  return 0;
80100e0f:	31 c0                	xor    %eax,%eax
}
80100e11:	5b                   	pop    %ebx
80100e12:	5d                   	pop    %ebp
80100e13:	c3                   	ret    
80100e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 14             	sub    $0x14,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e31:	e8 5a 33 00 00       	call   80104190 <acquire>
  if(f->ref < 1)
80100e36:	8b 43 04             	mov    0x4(%ebx),%eax
80100e39:	85 c0                	test   %eax,%eax
80100e3b:	7e 1a                	jle    80100e57 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e3d:	83 c0 01             	add    $0x1,%eax
80100e40:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e43:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e4a:	e8 31 34 00 00       	call   80104280 <release>
  return f;
}
80100e4f:	83 c4 14             	add    $0x14,%esp
80100e52:	89 d8                	mov    %ebx,%eax
80100e54:	5b                   	pop    %ebx
80100e55:	5d                   	pop    %ebp
80100e56:	c3                   	ret    
    panic("filedup");
80100e57:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
80100e5e:	e8 fd f4 ff ff       	call   80100360 <panic>
80100e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 1c             	sub    $0x1c,%esp
80100e79:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e83:	e8 08 33 00 00       	call   80104190 <acquire>
  if(f->ref < 1)
80100e88:	8b 57 04             	mov    0x4(%edi),%edx
80100e8b:	85 d2                	test   %edx,%edx
80100e8d:	0f 8e 89 00 00 00    	jle    80100f1c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e93:	83 ea 01             	sub    $0x1,%edx
80100e96:	85 d2                	test   %edx,%edx
80100e98:	89 57 04             	mov    %edx,0x4(%edi)
80100e9b:	74 13                	je     80100eb0 <fileclose+0x40>
    release(&ftable.lock);
80100e9d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea4:	83 c4 1c             	add    $0x1c,%esp
80100ea7:	5b                   	pop    %ebx
80100ea8:	5e                   	pop    %esi
80100ea9:	5f                   	pop    %edi
80100eaa:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eab:	e9 d0 33 00 00       	jmp    80104280 <release>
  ff = *f;
80100eb0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100eb4:	8b 37                	mov    (%edi),%esi
80100eb6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100eb9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100ebf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ec2:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100ec5:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ecf:	e8 ac 33 00 00       	call   80104280 <release>
  if(ff.type == FD_PIPE)
80100ed4:	83 fe 01             	cmp    $0x1,%esi
80100ed7:	74 0f                	je     80100ee8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ed9:	83 fe 02             	cmp    $0x2,%esi
80100edc:	74 22                	je     80100f00 <fileclose+0x90>
}
80100ede:	83 c4 1c             	add    $0x1c,%esp
80100ee1:	5b                   	pop    %ebx
80100ee2:	5e                   	pop    %esi
80100ee3:	5f                   	pop    %edi
80100ee4:	5d                   	pop    %ebp
80100ee5:	c3                   	ret    
80100ee6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eec:	89 1c 24             	mov    %ebx,(%esp)
80100eef:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ef3:	e8 b8 23 00 00       	call   801032b0 <pipeclose>
80100ef8:	eb e4                	jmp    80100ede <fileclose+0x6e>
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100f00:	e8 5b 1c 00 00       	call   80102b60 <begin_op>
    iput(ff.ip);
80100f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f08:	89 04 24             	mov    %eax,(%esp)
80100f0b:	e8 10 09 00 00       	call   80101820 <iput>
}
80100f10:	83 c4 1c             	add    $0x1c,%esp
80100f13:	5b                   	pop    %ebx
80100f14:	5e                   	pop    %esi
80100f15:	5f                   	pop    %edi
80100f16:	5d                   	pop    %ebp
    end_op();
80100f17:	e9 b4 1c 00 00       	jmp    80102bd0 <end_op>
    panic("fileclose");
80100f1c:	c7 04 24 1c 6f 10 80 	movl   $0x80106f1c,(%esp)
80100f23:	e8 38 f4 ff ff       	call   80100360 <panic>
80100f28:	90                   	nop
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 14             	sub    $0x14,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f42:	89 04 24             	mov    %eax,(%esp)
80100f45:	e8 b6 07 00 00       	call   80101700 <ilock>
    stati(f->ip, st);
80100f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 04 24             	mov    %eax,(%esp)
80100f57:	e8 24 0a 00 00       	call   80101980 <stati>
    iunlock(f->ip);
80100f5c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f5f:	89 04 24             	mov    %eax,(%esp)
80100f62:	e8 79 08 00 00       	call   801017e0 <iunlock>
    return 0;
  }
  return -1;
}
80100f67:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f6a:	31 c0                	xor    %eax,%eax
}
80100f6c:	5b                   	pop    %ebx
80100f6d:	5d                   	pop    %ebp
80100f6e:	c3                   	ret    
80100f6f:	90                   	nop
80100f70:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f78:	5b                   	pop    %ebx
80100f79:	5d                   	pop    %ebp
80100f7a:	c3                   	ret    
80100f7b:	90                   	nop
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 1c             	sub    $0x1c,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 68                	je     80101000 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 49                	je     80100fe8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 63                	jne    80101007 <fileread+0x87>
    ilock(f->ip);
80100fa4:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa7:	89 04 24             	mov    %eax,(%esp)
80100faa:	e8 51 07 00 00       	call   80101700 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fb3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fb6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100fba:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fbe:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc1:	89 04 24             	mov    %eax,(%esp)
80100fc4:	e8 e7 09 00 00       	call   801019b0 <readi>
80100fc9:	85 c0                	test   %eax,%eax
80100fcb:	89 c6                	mov    %eax,%esi
80100fcd:	7e 03                	jle    80100fd2 <fileread+0x52>
      f->off += r;
80100fcf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fd5:	89 04 24             	mov    %eax,(%esp)
80100fd8:	e8 03 08 00 00       	call   801017e0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fdd:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100fdf:	83 c4 1c             	add    $0x1c,%esp
80100fe2:	5b                   	pop    %ebx
80100fe3:	5e                   	pop    %esi
80100fe4:	5f                   	pop    %edi
80100fe5:	5d                   	pop    %ebp
80100fe6:	c3                   	ret    
80100fe7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fe8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100feb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fee:	83 c4 1c             	add    $0x1c,%esp
80100ff1:	5b                   	pop    %ebx
80100ff2:	5e                   	pop    %esi
80100ff3:	5f                   	pop    %edi
80100ff4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ff5:	e9 36 24 00 00       	jmp    80103430 <piperead>
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb d8                	jmp    80100fdf <fileread+0x5f>
  panic("fileread");
80101007:	c7 04 24 26 6f 10 80 	movl   $0x80106f26,(%esp)
8010100e:	e8 4d f3 ff ff       	call   80100360 <panic>
80101013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 2c             	sub    $0x2c,%esp
80101029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010102c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010102f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101032:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101035:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 ae 00 00 00    	je     801010f0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 07                	mov    (%edi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c2 00 00 00    	je     8010110f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d7 00 00 00    	jne    8010112d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101059:	31 db                	xor    %ebx,%ebx
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 31                	jg     80101090 <filewrite+0x70>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101068:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010106b:	01 47 14             	add    %eax,0x14(%edi)
8010106e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101071:	89 0c 24             	mov    %ecx,(%esp)
80101074:	e8 67 07 00 00       	call   801017e0 <iunlock>
      end_op();
80101079:	e8 52 1b 00 00       	call   80102bd0 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101081:	39 f0                	cmp    %esi,%eax
80101083:	0f 85 98 00 00 00    	jne    80101121 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101089:	01 c3                	add    %eax,%ebx
    while(i < n){
8010108b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010108e:	7e 70                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101090:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101093:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101098:	29 de                	sub    %ebx,%esi
8010109a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
801010a0:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
801010a3:	e8 b8 1a 00 00       	call   80102b60 <begin_op>
      ilock(f->ip);
801010a8:	8b 47 10             	mov    0x10(%edi),%eax
801010ab:	89 04 24             	mov    %eax,(%esp)
801010ae:	e8 4d 06 00 00       	call   80101700 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010b7:	8b 47 14             	mov    0x14(%edi),%eax
801010ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801010be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c1:	01 d8                	add    %ebx,%eax
801010c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010c7:	8b 47 10             	mov    0x10(%edi),%eax
801010ca:	89 04 24             	mov    %eax,(%esp)
801010cd:	e8 de 09 00 00       	call   80101ab0 <writei>
801010d2:	85 c0                	test   %eax,%eax
801010d4:	7f 92                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010d6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010dc:	89 0c 24             	mov    %ecx,(%esp)
801010df:	e8 fc 06 00 00       	call   801017e0 <iunlock>
      end_op();
801010e4:	e8 e7 1a 00 00       	call   80102bd0 <end_op>
      if(r < 0)
801010e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ec:	85 c0                	test   %eax,%eax
801010ee:	74 91                	je     80101081 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
801010fc:	c3                   	ret    
801010fd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
80101100:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101103:	89 d8                	mov    %ebx,%eax
80101105:	75 e9                	jne    801010f0 <filewrite+0xd0>
}
80101107:	83 c4 2c             	add    $0x2c,%esp
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010110f:	8b 47 0c             	mov    0xc(%edi),%eax
80101112:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101115:	83 c4 2c             	add    $0x2c,%esp
80101118:	5b                   	pop    %ebx
80101119:	5e                   	pop    %esi
8010111a:	5f                   	pop    %edi
8010111b:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111c:	e9 1f 22 00 00       	jmp    80103340 <pipewrite>
        panic("short filewrite");
80101121:	c7 04 24 2f 6f 10 80 	movl   $0x80106f2f,(%esp)
80101128:	e8 33 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
8010112d:	c7 04 24 35 6f 10 80 	movl   $0x80106f35,(%esp)
80101134:	e8 27 f2 ff ff       	call   80100360 <panic>
80101139:	66 90                	xchg   %ax,%ax
8010113b:	66 90                	xchg   %ax,%ax
8010113d:	66 90                	xchg   %ax,%ax
8010113f:	90                   	nop

80101140 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 2c             	sub    $0x2c,%esp
80101149:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010114c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101151:	85 c0                	test   %eax,%eax
80101153:	0f 84 8c 00 00 00    	je     801011e5 <balloc+0xa5>
80101159:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101160:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101163:	89 f0                	mov    %esi,%eax
80101165:	c1 f8 0c             	sar    $0xc,%eax
80101168:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010116e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101172:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101175:	89 04 24             	mov    %eax,(%esp)
80101178:	e8 53 ef ff ff       	call   801000d0 <bread>
8010117d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101180:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101185:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101188:	31 c0                	xor    %eax,%eax
8010118a:	eb 33                	jmp    801011bf <balloc+0x7f>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101190:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101193:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101195:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101197:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010119a:	83 e1 07             	and    $0x7,%ecx
8010119d:	bf 01 00 00 00       	mov    $0x1,%edi
801011a2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011a4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011a9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ab:	0f b6 fb             	movzbl %bl,%edi
801011ae:	85 cf                	test   %ecx,%edi
801011b0:	74 46                	je     801011f8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b2:	83 c0 01             	add    $0x1,%eax
801011b5:	83 c6 01             	add    $0x1,%esi
801011b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011bd:	74 05                	je     801011c4 <balloc+0x84>
801011bf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011c2:	72 cc                	jb     80101190 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011c7:	89 04 24             	mov    %eax,(%esp)
801011ca:	e8 11 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011cf:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d9:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
801011df:	0f 82 7b ff ff ff    	jb     80101160 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011e5:	c7 04 24 3f 6f 10 80 	movl   $0x80106f3f,(%esp)
801011ec:	e8 6f f1 ff ff       	call   80100360 <panic>
801011f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011f8:	09 d9                	or     %ebx,%ecx
801011fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011fd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101201:	89 1c 24             	mov    %ebx,(%esp)
80101204:	e8 f7 1a 00 00       	call   80102d00 <log_write>
        brelse(bp);
80101209:	89 1c 24             	mov    %ebx,(%esp)
8010120c:	e8 cf ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101211:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101214:	89 74 24 04          	mov    %esi,0x4(%esp)
80101218:	89 04 24             	mov    %eax,(%esp)
8010121b:	e8 b0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101220:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101227:	00 
80101228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010122f:	00 
  bp = bread(dev, bno);
80101230:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101232:	8d 40 5c             	lea    0x5c(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 93 30 00 00       	call   801042d0 <memset>
  log_write(bp);
8010123d:	89 1c 24             	mov    %ebx,(%esp)
80101240:	e8 bb 1a 00 00       	call   80102d00 <log_write>
  brelse(bp);
80101245:	89 1c 24             	mov    %ebx,(%esp)
80101248:	e8 93 ef ff ff       	call   801001e0 <brelse>
}
8010124d:	83 c4 2c             	add    $0x2c,%esp
80101250:	89 f0                	mov    %esi,%eax
80101252:	5b                   	pop    %ebx
80101253:	5e                   	pop    %esi
80101254:	5f                   	pop    %edi
80101255:	5d                   	pop    %ebp
80101256:	c3                   	ret    
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	89 c7                	mov    %eax,%edi
80101266:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101267:	31 f6                	xor    %esi,%esi
{
80101269:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010126f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101272:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101279:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010127c:	e8 0f 2f 00 00       	call   80104190 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101281:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101284:	eb 14                	jmp    8010129a <iget+0x3a>
80101286:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 f6                	test   %esi,%esi
8010128a:	74 3c                	je     801012c8 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101292:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101298:	74 46                	je     801012e0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010129a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010129d:	85 c9                	test   %ecx,%ecx
8010129f:	7e e7                	jle    80101288 <iget+0x28>
801012a1:	39 3b                	cmp    %edi,(%ebx)
801012a3:	75 e3                	jne    80101288 <iget+0x28>
801012a5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012a8:	75 de                	jne    80101288 <iget+0x28>
      ip->ref++;
801012aa:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012ad:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012af:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
801012b6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012b9:	e8 c2 2f 00 00       	call   80104280 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012be:	83 c4 1c             	add    $0x1c,%esp
801012c1:	89 f0                	mov    %esi,%eax
801012c3:	5b                   	pop    %ebx
801012c4:	5e                   	pop    %esi
801012c5:	5f                   	pop    %edi
801012c6:	5d                   	pop    %ebp
801012c7:	c3                   	ret    
801012c8:	85 c9                	test   %ecx,%ecx
801012ca:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012d9:	75 bf                	jne    8010129a <iget+0x3a>
801012db:	90                   	nop
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012e0:	85 f6                	test   %esi,%esi
801012e2:	74 29                	je     8010130d <iget+0xad>
  ip->dev = dev;
801012e4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012e6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012e9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012f0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012f7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012fe:	e8 7d 2f 00 00       	call   80104280 <release>
}
80101303:	83 c4 1c             	add    $0x1c,%esp
80101306:	89 f0                	mov    %esi,%eax
80101308:	5b                   	pop    %ebx
80101309:	5e                   	pop    %esi
8010130a:	5f                   	pop    %edi
8010130b:	5d                   	pop    %ebp
8010130c:	c3                   	ret    
    panic("iget: no inodes");
8010130d:	c7 04 24 55 6f 10 80 	movl   $0x80106f55,(%esp)
80101314:	e8 47 f0 ff ff       	call   80100360 <panic>
80101319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c3                	mov    %eax,%ebx
80101328:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010132b:	83 fa 0b             	cmp    $0xb,%edx
8010132e:	77 18                	ja     80101348 <bmap+0x28>
80101330:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101333:	8b 46 5c             	mov    0x5c(%esi),%eax
80101336:	85 c0                	test   %eax,%eax
80101338:	74 66                	je     801013a0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	83 c4 1c             	add    $0x1c,%esp
8010133d:	5b                   	pop    %ebx
8010133e:	5e                   	pop    %esi
8010133f:	5f                   	pop    %edi
80101340:	5d                   	pop    %ebp
80101341:	c3                   	ret    
80101342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101348:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010134b:	83 fe 7f             	cmp    $0x7f,%esi
8010134e:	77 77                	ja     801013c7 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101350:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101356:	85 c0                	test   %eax,%eax
80101358:	74 5e                	je     801013b8 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010135a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010135e:	8b 03                	mov    (%ebx),%eax
80101360:	89 04 24             	mov    %eax,(%esp)
80101363:	e8 68 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101368:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010136c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010136e:	8b 32                	mov    (%edx),%esi
80101370:	85 f6                	test   %esi,%esi
80101372:	75 19                	jne    8010138d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101374:	8b 03                	mov    (%ebx),%eax
80101376:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101379:	e8 c2 fd ff ff       	call   80101140 <balloc>
8010137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101381:	89 02                	mov    %eax,(%edx)
80101383:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101385:	89 3c 24             	mov    %edi,(%esp)
80101388:	e8 73 19 00 00       	call   80102d00 <log_write>
    brelse(bp);
8010138d:	89 3c 24             	mov    %edi,(%esp)
80101390:	e8 4b ee ff ff       	call   801001e0 <brelse>
}
80101395:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101398:	89 f0                	mov    %esi,%eax
}
8010139a:	5b                   	pop    %ebx
8010139b:	5e                   	pop    %esi
8010139c:	5f                   	pop    %edi
8010139d:	5d                   	pop    %ebp
8010139e:	c3                   	ret    
8010139f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013a0:	8b 03                	mov    (%ebx),%eax
801013a2:	e8 99 fd ff ff       	call   80101140 <balloc>
801013a7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013aa:	83 c4 1c             	add    $0x1c,%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5f                   	pop    %edi
801013b0:	5d                   	pop    %ebp
801013b1:	c3                   	ret    
801013b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013b8:	8b 03                	mov    (%ebx),%eax
801013ba:	e8 81 fd ff ff       	call   80101140 <balloc>
801013bf:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013c5:	eb 93                	jmp    8010135a <bmap+0x3a>
  panic("bmap: out of range");
801013c7:	c7 04 24 65 6f 10 80 	movl   $0x80106f65,(%esp)
801013ce:	e8 8d ef ff ff       	call   80100360 <panic>
801013d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <readsb>:
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013e8:	8b 45 08             	mov    0x8(%ebp),%eax
801013eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013f2:	00 
{
801013f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013f6:	89 04 24             	mov    %eax,(%esp)
801013f9:	e8 d2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013fe:	89 34 24             	mov    %esi,(%esp)
80101401:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101408:	00 
  bp = bread(dev, 1);
80101409:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010140b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010140e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101412:	e8 59 2f 00 00       	call   80104370 <memmove>
  brelse(bp);
80101417:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010141a:	83 c4 10             	add    $0x10,%esp
8010141d:	5b                   	pop    %ebx
8010141e:	5e                   	pop    %esi
8010141f:	5d                   	pop    %ebp
  brelse(bp);
80101420:	e9 bb ed ff ff       	jmp    801001e0 <brelse>
80101425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <bfree>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	89 d7                	mov    %edx,%edi
80101436:	56                   	push   %esi
80101437:	53                   	push   %ebx
80101438:	89 c3                	mov    %eax,%ebx
8010143a:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
8010143d:	89 04 24             	mov    %eax,(%esp)
80101440:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101447:	80 
80101448:	e8 93 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010144d:	89 fa                	mov    %edi,%edx
8010144f:	c1 ea 0c             	shr    $0xc,%edx
80101452:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101458:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010145b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101460:	89 54 24 04          	mov    %edx,0x4(%esp)
80101464:	e8 67 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101469:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010146b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101471:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101473:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101476:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101479:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010147b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010147d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101482:	0f b6 c8             	movzbl %al,%ecx
80101485:	85 d9                	test   %ebx,%ecx
80101487:	74 20                	je     801014a9 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101489:	f7 d3                	not    %ebx
8010148b:	21 c3                	and    %eax,%ebx
8010148d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101491:	89 34 24             	mov    %esi,(%esp)
80101494:	e8 67 18 00 00       	call   80102d00 <log_write>
  brelse(bp);
80101499:	89 34 24             	mov    %esi,(%esp)
8010149c:	e8 3f ed ff ff       	call   801001e0 <brelse>
}
801014a1:	83 c4 1c             	add    $0x1c,%esp
801014a4:	5b                   	pop    %ebx
801014a5:	5e                   	pop    %esi
801014a6:	5f                   	pop    %edi
801014a7:	5d                   	pop    %ebp
801014a8:	c3                   	ret    
    panic("freeing free block");
801014a9:	c7 04 24 78 6f 10 80 	movl   $0x80106f78,(%esp)
801014b0:	e8 ab ee ff ff       	call   80100360 <panic>
801014b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014c9:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801014cc:	c7 44 24 04 8b 6f 10 	movl   $0x80106f8b,0x4(%esp)
801014d3:	80 
801014d4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014db:	e8 c0 2b 00 00       	call   801040a0 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	89 1c 24             	mov    %ebx,(%esp)
801014e3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014e9:	c7 44 24 04 92 6f 10 	movl   $0x80106f92,0x4(%esp)
801014f0:	80 
801014f1:	e8 9a 2a 00 00       	call   80103f90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014fc:	75 e2                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101501:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101508:	80 
80101509:	89 04 24             	mov    %eax,(%esp)
8010150c:	e8 cf fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101511:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101516:	c7 04 24 f8 6f 10 80 	movl   $0x80106ff8,(%esp)
8010151d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101521:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101526:	89 44 24 18          	mov    %eax,0x18(%esp)
8010152a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010152f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101533:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101538:	89 44 24 10          	mov    %eax,0x10(%esp)
8010153c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101541:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101545:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010154a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010154e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101553:	89 44 24 04          	mov    %eax,0x4(%esp)
80101557:	e8 f4 f0 ff ff       	call   80100650 <cprintf>
}
8010155c:	83 c4 24             	add    $0x24,%esp
8010155f:	5b                   	pop    %ebx
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret    
80101562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101570 <ialloc>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 2c             	sub    $0x2c,%esp
80101579:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101583:	8b 7d 08             	mov    0x8(%ebp),%edi
80101586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101589:	0f 86 a2 00 00 00    	jbe    80101631 <ialloc+0xc1>
8010158f:	be 01 00 00 00       	mov    $0x1,%esi
80101594:	bb 01 00 00 00       	mov    $0x1,%ebx
80101599:	eb 1a                	jmp    801015b5 <ialloc+0x45>
8010159b:	90                   	nop
8010159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
801015a0:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015a3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015a6:	e8 35 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ab:	89 de                	mov    %ebx,%esi
801015ad:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015b3:	73 7c                	jae    80101631 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015b5:	89 f0                	mov    %esi,%eax
801015b7:	c1 e8 03             	shr    $0x3,%eax
801015ba:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015c0:	89 3c 24             	mov    %edi,(%esp)
801015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
801015cc:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ce:	89 f0                	mov    %esi,%eax
801015d0:	83 e0 07             	and    $0x7,%eax
801015d3:	c1 e0 06             	shl    $0x6,%eax
801015d6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015da:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015de:	75 c0                	jne    801015a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015e0:	89 0c 24             	mov    %ecx,(%esp)
801015e3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ea:	00 
801015eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015f2:	00 
801015f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015f9:	e8 d2 2c 00 00       	call   801042d0 <memset>
      dip->type = type;
801015fe:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101602:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
80101605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101608:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
8010160b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010160e:	89 14 24             	mov    %edx,(%esp)
80101611:	e8 ea 16 00 00       	call   80102d00 <log_write>
      brelse(bp);
80101616:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101619:	89 14 24             	mov    %edx,(%esp)
8010161c:	e8 bf eb ff ff       	call   801001e0 <brelse>
}
80101621:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101624:	89 f2                	mov    %esi,%edx
}
80101626:	5b                   	pop    %ebx
      return iget(dev, inum);
80101627:	89 f8                	mov    %edi,%eax
}
80101629:	5e                   	pop    %esi
8010162a:	5f                   	pop    %edi
8010162b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010162c:	e9 2f fc ff ff       	jmp    80101260 <iget>
  panic("ialloc: no inodes");
80101631:	c7 04 24 98 6f 10 80 	movl   $0x80106f98,(%esp)
80101638:	e8 23 ed ff ff       	call   80100360 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <iupdate>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	83 ec 10             	sub    $0x10,%esp
80101648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010164b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101651:	c1 e8 03             	shr    $0x3,%eax
80101654:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010165a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010165e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101661:	89 04 24             	mov    %eax,(%esp)
80101664:	e8 67 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101669:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010166c:	83 e2 07             	and    $0x7,%edx
8010166f:	c1 e2 06             	shl    $0x6,%edx
80101672:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101676:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101678:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010167f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101683:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101687:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010168b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010168f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101693:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101697:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010169b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010169e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801016a5:	89 14 24             	mov    %edx,(%esp)
801016a8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801016af:	00 
801016b0:	e8 bb 2c 00 00       	call   80104370 <memmove>
  log_write(bp);
801016b5:	89 34 24             	mov    %esi,(%esp)
801016b8:	e8 43 16 00 00       	call   80102d00 <log_write>
  brelse(bp);
801016bd:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016c0:	83 c4 10             	add    $0x10,%esp
801016c3:	5b                   	pop    %ebx
801016c4:	5e                   	pop    %esi
801016c5:	5d                   	pop    %ebp
  brelse(bp);
801016c6:	e9 15 eb ff ff       	jmp    801001e0 <brelse>
801016cb:	90                   	nop
801016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016d0 <idup>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	53                   	push   %ebx
801016d4:	83 ec 14             	sub    $0x14,%esp
801016d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016da:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016e1:	e8 aa 2a 00 00       	call   80104190 <acquire>
  ip->ref++;
801016e6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ea:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016f1:	e8 8a 2b 00 00       	call   80104280 <release>
}
801016f6:	83 c4 14             	add    $0x14,%esp
801016f9:	89 d8                	mov    %ebx,%eax
801016fb:	5b                   	pop    %ebx
801016fc:	5d                   	pop    %ebp
801016fd:	c3                   	ret    
801016fe:	66 90                	xchg   %ax,%ax

80101700 <ilock>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	83 ec 10             	sub    $0x10,%esp
80101708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010170b:	85 db                	test   %ebx,%ebx
8010170d:	0f 84 b3 00 00 00    	je     801017c6 <ilock+0xc6>
80101713:	8b 53 08             	mov    0x8(%ebx),%edx
80101716:	85 d2                	test   %edx,%edx
80101718:	0f 8e a8 00 00 00    	jle    801017c6 <ilock+0xc6>
  acquiresleep(&ip->lock);
8010171e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 a7 28 00 00       	call   80103fd0 <acquiresleep>
  if(ip->valid == 0){
80101729:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010172c:	85 c0                	test   %eax,%eax
8010172e:	74 08                	je     80101738 <ilock+0x38>
}
80101730:	83 c4 10             	add    $0x10,%esp
80101733:	5b                   	pop    %ebx
80101734:	5e                   	pop    %esi
80101735:	5d                   	pop    %ebp
80101736:	c3                   	ret    
80101737:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
8010173b:	c1 e8 03             	shr    $0x3,%eax
8010173e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101744:	89 44 24 04          	mov    %eax,0x4(%esp)
80101748:	8b 03                	mov    (%ebx),%eax
8010174a:	89 04 24             	mov    %eax,(%esp)
8010174d:	e8 7e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101752:	8b 53 04             	mov    0x4(%ebx),%edx
80101755:	83 e2 07             	and    $0x7,%edx
80101758:	c1 e2 06             	shl    $0x6,%edx
8010175b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101761:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101764:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101767:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010176b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010176f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101773:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101777:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010177b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010177f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101783:	8b 42 fc             	mov    -0x4(%edx),%eax
80101786:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101789:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010178c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101790:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101797:	00 
80101798:	89 04 24             	mov    %eax,(%esp)
8010179b:	e8 d0 2b 00 00       	call   80104370 <memmove>
    brelse(bp);
801017a0:	89 34 24             	mov    %esi,(%esp)
801017a3:	e8 38 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017b4:	0f 85 76 ff ff ff    	jne    80101730 <ilock+0x30>
      panic("ilock: no type");
801017ba:	c7 04 24 b0 6f 10 80 	movl   $0x80106fb0,(%esp)
801017c1:	e8 9a eb ff ff       	call   80100360 <panic>
    panic("ilock");
801017c6:	c7 04 24 aa 6f 10 80 	movl   $0x80106faa,(%esp)
801017cd:	e8 8e eb ff ff       	call   80100360 <panic>
801017d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017e0 <iunlock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	83 ec 10             	sub    $0x10,%esp
801017e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017eb:	85 db                	test   %ebx,%ebx
801017ed:	74 24                	je     80101813 <iunlock+0x33>
801017ef:	8d 73 0c             	lea    0xc(%ebx),%esi
801017f2:	89 34 24             	mov    %esi,(%esp)
801017f5:	e8 76 28 00 00       	call   80104070 <holdingsleep>
801017fa:	85 c0                	test   %eax,%eax
801017fc:	74 15                	je     80101813 <iunlock+0x33>
801017fe:	8b 43 08             	mov    0x8(%ebx),%eax
80101801:	85 c0                	test   %eax,%eax
80101803:	7e 0e                	jle    80101813 <iunlock+0x33>
  releasesleep(&ip->lock);
80101805:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	5b                   	pop    %ebx
8010180c:	5e                   	pop    %esi
8010180d:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010180e:	e9 1d 28 00 00       	jmp    80104030 <releasesleep>
    panic("iunlock");
80101813:	c7 04 24 bf 6f 10 80 	movl   $0x80106fbf,(%esp)
8010181a:	e8 41 eb ff ff       	call   80100360 <panic>
8010181f:	90                   	nop

80101820 <iput>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	56                   	push   %esi
80101825:	53                   	push   %ebx
80101826:	83 ec 1c             	sub    $0x1c,%esp
80101829:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010182c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010182f:	89 3c 24             	mov    %edi,(%esp)
80101832:	e8 99 27 00 00       	call   80103fd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101837:	8b 56 4c             	mov    0x4c(%esi),%edx
8010183a:	85 d2                	test   %edx,%edx
8010183c:	74 07                	je     80101845 <iput+0x25>
8010183e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101843:	74 2b                	je     80101870 <iput+0x50>
  releasesleep(&ip->lock);
80101845:	89 3c 24             	mov    %edi,(%esp)
80101848:	e8 e3 27 00 00       	call   80104030 <releasesleep>
  acquire(&icache.lock);
8010184d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101854:	e8 37 29 00 00       	call   80104190 <acquire>
  ip->ref--;
80101859:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010185d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101864:	83 c4 1c             	add    $0x1c,%esp
80101867:	5b                   	pop    %ebx
80101868:	5e                   	pop    %esi
80101869:	5f                   	pop    %edi
8010186a:	5d                   	pop    %ebp
  release(&icache.lock);
8010186b:	e9 10 2a 00 00       	jmp    80104280 <release>
    acquire(&icache.lock);
80101870:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101877:	e8 14 29 00 00       	call   80104190 <acquire>
    int r = ip->ref;
8010187c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 f5 29 00 00       	call   80104280 <release>
    if(r == 1){
8010188b:	83 fb 01             	cmp    $0x1,%ebx
8010188e:	75 b5                	jne    80101845 <iput+0x25>
80101890:	8d 4e 30             	lea    0x30(%esi),%ecx
80101893:	89 f3                	mov    %esi,%ebx
80101895:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101898:	89 cf                	mov    %ecx,%edi
8010189a:	eb 0b                	jmp    801018a7 <iput+0x87>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018a0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018a3:	39 fb                	cmp    %edi,%ebx
801018a5:	74 19                	je     801018c0 <iput+0xa0>
    if(ip->addrs[i]){
801018a7:	8b 53 5c             	mov    0x5c(%ebx),%edx
801018aa:	85 d2                	test   %edx,%edx
801018ac:	74 f2                	je     801018a0 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
801018ae:	8b 06                	mov    (%esi),%eax
801018b0:	e8 7b fb ff ff       	call   80101430 <bfree>
      ip->addrs[i] = 0;
801018b5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018bc:	eb e2                	jmp    801018a0 <iput+0x80>
801018be:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018c0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018c9:	85 c0                	test   %eax,%eax
801018cb:	75 2b                	jne    801018f8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018cd:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018d4:	89 34 24             	mov    %esi,(%esp)
801018d7:	e8 64 fd ff ff       	call   80101640 <iupdate>
      ip->type = 0;
801018dc:	31 c0                	xor    %eax,%eax
801018de:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018e2:	89 34 24             	mov    %esi,(%esp)
801018e5:	e8 56 fd ff ff       	call   80101640 <iupdate>
      ip->valid = 0;
801018ea:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018f1:	e9 4f ff ff ff       	jmp    80101845 <iput+0x25>
801018f6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018fc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018fe:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101900:	89 04 24             	mov    %eax,(%esp)
80101903:	e8 c8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101908:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
8010190b:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010190e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101911:	89 cf                	mov    %ecx,%edi
80101913:	31 c0                	xor    %eax,%eax
80101915:	eb 0e                	jmp    80101925 <iput+0x105>
80101917:	90                   	nop
80101918:	83 c3 01             	add    $0x1,%ebx
8010191b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101921:	89 d8                	mov    %ebx,%eax
80101923:	74 10                	je     80101935 <iput+0x115>
      if(a[j])
80101925:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101928:	85 d2                	test   %edx,%edx
8010192a:	74 ec                	je     80101918 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010192c:	8b 06                	mov    (%esi),%eax
8010192e:	e8 fd fa ff ff       	call   80101430 <bfree>
80101933:	eb e3                	jmp    80101918 <iput+0xf8>
    brelse(bp);
80101935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101938:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010193b:	89 04 24             	mov    %eax,(%esp)
8010193e:	e8 9d e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101943:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101949:	8b 06                	mov    (%esi),%eax
8010194b:	e8 e0 fa ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
80101950:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101957:	00 00 00 
8010195a:	e9 6e ff ff ff       	jmp    801018cd <iput+0xad>
8010195f:	90                   	nop

80101960 <iunlockput>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	53                   	push   %ebx
80101964:	83 ec 14             	sub    $0x14,%esp
80101967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010196a:	89 1c 24             	mov    %ebx,(%esp)
8010196d:	e8 6e fe ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101972:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101975:	83 c4 14             	add    $0x14,%esp
80101978:	5b                   	pop    %ebx
80101979:	5d                   	pop    %ebp
  iput(ip);
8010197a:	e9 a1 fe ff ff       	jmp    80101820 <iput>
8010197f:	90                   	nop

80101980 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	8b 55 08             	mov    0x8(%ebp),%edx
80101986:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101989:	8b 0a                	mov    (%edx),%ecx
8010198b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010198e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101991:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101994:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101998:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010199b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010199f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019a3:	8b 52 58             	mov    0x58(%edx),%edx
801019a6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019a9:	5d                   	pop    %ebp
801019aa:	c3                   	ret    
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	56                   	push   %esi
801019b5:	53                   	push   %ebx
801019b6:	83 ec 2c             	sub    $0x2c,%esp
801019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019bc:	8b 7d 08             	mov    0x8(%ebp),%edi
801019bf:	8b 75 10             	mov    0x10(%ebp),%esi
801019c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019c8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
801019cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019d0:	0f 84 aa 00 00 00    	je     80101a80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019d6:	8b 47 58             	mov    0x58(%edi),%eax
801019d9:	39 f0                	cmp    %esi,%eax
801019db:	0f 82 c7 00 00 00    	jb     80101aa8 <readi+0xf8>
801019e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019e4:	89 da                	mov    %ebx,%edx
801019e6:	01 f2                	add    %esi,%edx
801019e8:	0f 82 ba 00 00 00    	jb     80101aa8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ee:	89 c1                	mov    %eax,%ecx
801019f0:	29 f1                	sub    %esi,%ecx
801019f2:	39 d0                	cmp    %edx,%eax
801019f4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f7:	31 c0                	xor    %eax,%eax
801019f9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019fb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	74 70                	je     80101a70 <readi+0xc0>
80101a00:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a03:	89 c7                	mov    %eax,%edi
80101a05:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a08:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a0b:	89 f2                	mov    %esi,%edx
80101a0d:	c1 ea 09             	shr    $0x9,%edx
80101a10:	89 d8                	mov    %ebx,%eax
80101a12:	e8 09 f9 ff ff       	call   80101320 <bmap>
80101a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a1b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a22:	89 04 24             	mov    %eax,(%esp)
80101a25:	e8 a6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a2a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a2d:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a2f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a31:	89 f0                	mov    %esi,%eax
80101a33:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a38:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a40:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a47:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a4a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a4e:	01 df                	add    %ebx,%edi
80101a50:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a55:	89 04 24             	mov    %eax,(%esp)
80101a58:	e8 13 29 00 00       	call   80104370 <memmove>
    brelse(bp);
80101a5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a60:	89 14 24             	mov    %edx,(%esp)
80101a63:	e8 78 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a68:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a6b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a6e:	77 98                	ja     80101a08 <readi+0x58>
  }
  return n;
80101a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a73:	83 c4 2c             	add    $0x2c,%esp
80101a76:	5b                   	pop    %ebx
80101a77:	5e                   	pop    %esi
80101a78:	5f                   	pop    %edi
80101a79:	5d                   	pop    %ebp
80101a7a:	c3                   	ret    
80101a7b:	90                   	nop
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a80:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a84:	66 83 f8 09          	cmp    $0x9,%ax
80101a88:	77 1e                	ja     80101aa8 <readi+0xf8>
80101a8a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a91:	85 c0                	test   %eax,%eax
80101a93:	74 13                	je     80101aa8 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a95:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a98:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a9b:	83 c4 2c             	add    $0x2c,%esp
80101a9e:	5b                   	pop    %ebx
80101a9f:	5e                   	pop    %esi
80101aa0:	5f                   	pop    %edi
80101aa1:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aa2:	ff e0                	jmp    *%eax
80101aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aad:	eb c4                	jmp    80101a73 <readi+0xc3>
80101aaf:	90                   	nop

80101ab0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 2c             	sub    $0x2c,%esp
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101abf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ac7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aca:	8b 75 10             	mov    0x10(%ebp),%esi
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 b7 00 00 00    	je     80101b90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	39 70 58             	cmp    %esi,0x58(%eax)
80101adf:	0f 82 e3 00 00 00    	jb     80101bc8 <writei+0x118>
80101ae5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ae8:	89 c8                	mov    %ecx,%eax
80101aea:	01 f0                	add    %esi,%eax
80101aec:	0f 82 d6 00 00 00    	jb     80101bc8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101af2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101af7:	0f 87 cb 00 00 00    	ja     80101bc8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101afd:	85 c9                	test   %ecx,%ecx
80101aff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b06:	74 77                	je     80101b7f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b08:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b0b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	c1 ea 09             	shr    $0x9,%edx
80101b15:	89 f8                	mov    %edi,%eax
80101b17:	e8 04 f8 ff ff       	call   80101320 <bmap>
80101b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b20:	8b 07                	mov    (%edi),%eax
80101b22:	89 04 24             	mov    %eax,(%esp)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b2d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b30:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b33:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b35:	89 f0                	mov    %esi,%eax
80101b37:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3c:	29 c3                	sub    %eax,%ebx
80101b3e:	39 cb                	cmp    %ecx,%ebx
80101b40:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b43:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b47:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b49:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b51:	89 04 24             	mov    %eax,(%esp)
80101b54:	e8 17 28 00 00       	call   80104370 <memmove>
    log_write(bp);
80101b59:	89 3c 24             	mov    %edi,(%esp)
80101b5c:	e8 9f 11 00 00       	call   80102d00 <log_write>
    brelse(bp);
80101b61:	89 3c 24             	mov    %edi,(%esp)
80101b64:	e8 77 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b69:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b6f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b72:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b75:	77 91                	ja     80101b08 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b7d:	72 39                	jb     80101bb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b82:	83 c4 2c             	add    $0x2c,%esp
80101b85:	5b                   	pop    %ebx
80101b86:	5e                   	pop    %esi
80101b87:	5f                   	pop    %edi
80101b88:	5d                   	pop    %ebp
80101b89:	c3                   	ret    
80101b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b94:	66 83 f8 09          	cmp    $0x9,%ax
80101b98:	77 2e                	ja     80101bc8 <writei+0x118>
80101b9a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101ba1:	85 c0                	test   %eax,%eax
80101ba3:	74 23                	je     80101bc8 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101ba5:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
80101bab:	5b                   	pop    %ebx
80101bac:	5e                   	pop    %esi
80101bad:	5f                   	pop    %edi
80101bae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101baf:	ff e0                	jmp    *%eax
80101bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbb:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bbe:	89 04 24             	mov    %eax,(%esp)
80101bc1:	e8 7a fa ff ff       	call   80101640 <iupdate>
80101bc6:	eb b7                	jmp    80101b7f <writei+0xcf>
}
80101bc8:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101bd0:	5b                   	pop    %ebx
80101bd1:	5e                   	pop    %esi
80101bd2:	5f                   	pop    %edi
80101bd3:	5d                   	pop    %ebp
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101be6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101be9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bf0:	00 
80101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf8:	89 04 24             	mov    %eax,(%esp)
80101bfb:	e8 f0 27 00 00       	call   801043f0 <strncmp>
}
80101c00:	c9                   	leave  
80101c01:	c3                   	ret    
80101c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 2c             	sub    $0x2c,%esp
80101c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c21:	0f 85 97 00 00 00    	jne    80101cbe <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c27:	8b 53 58             	mov    0x58(%ebx),%edx
80101c2a:	31 ff                	xor    %edi,%edi
80101c2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c2f:	85 d2                	test   %edx,%edx
80101c31:	75 0d                	jne    80101c40 <dirlookup+0x30>
80101c33:	eb 73                	jmp    80101ca8 <dirlookup+0x98>
80101c35:	8d 76 00             	lea    0x0(%esi),%esi
80101c38:	83 c7 10             	add    $0x10,%edi
80101c3b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c3e:	76 68                	jbe    80101ca8 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c40:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c47:	00 
80101c48:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c4c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c50:	89 1c 24             	mov    %ebx,(%esp)
80101c53:	e8 58 fd ff ff       	call   801019b0 <readi>
80101c58:	83 f8 10             	cmp    $0x10,%eax
80101c5b:	75 55                	jne    80101cb2 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c5d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c62:	74 d4                	je     80101c38 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c6e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c75:	00 
80101c76:	89 04 24             	mov    %eax,(%esp)
80101c79:	e8 72 27 00 00       	call   801043f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c7e:	85 c0                	test   %eax,%eax
80101c80:	75 b6                	jne    80101c38 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c82:	8b 45 10             	mov    0x10(%ebp),%eax
80101c85:	85 c0                	test   %eax,%eax
80101c87:	74 05                	je     80101c8e <dirlookup+0x7e>
        *poff = off;
80101c89:	8b 45 10             	mov    0x10(%ebp),%eax
80101c8c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c8e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c92:	8b 03                	mov    (%ebx),%eax
80101c94:	e8 c7 f5 ff ff       	call   80101260 <iget>
    }
  }

  return 0;
}
80101c99:	83 c4 2c             	add    $0x2c,%esp
80101c9c:	5b                   	pop    %ebx
80101c9d:	5e                   	pop    %esi
80101c9e:	5f                   	pop    %edi
80101c9f:	5d                   	pop    %ebp
80101ca0:	c3                   	ret    
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ca8:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101cab:	31 c0                	xor    %eax,%eax
}
80101cad:	5b                   	pop    %ebx
80101cae:	5e                   	pop    %esi
80101caf:	5f                   	pop    %edi
80101cb0:	5d                   	pop    %ebp
80101cb1:	c3                   	ret    
      panic("dirlookup read");
80101cb2:	c7 04 24 d9 6f 10 80 	movl   $0x80106fd9,(%esp)
80101cb9:	e8 a2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101cbe:	c7 04 24 c7 6f 10 80 	movl   $0x80106fc7,(%esp)
80101cc5:	e8 96 e6 ff ff       	call   80100360 <panic>
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	89 cf                	mov    %ecx,%edi
80101cd6:	56                   	push   %esi
80101cd7:	53                   	push   %ebx
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ce3:	0f 84 51 01 00 00    	je     80101e3a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce9:	e8 02 1a 00 00       	call   801036f0 <myproc>
80101cee:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cf1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cf8:	e8 93 24 00 00       	call   80104190 <acquire>
  ip->ref++;
80101cfd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d01:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d08:	e8 73 25 00 00       	call   80104280 <release>
80101d0d:	eb 04                	jmp    80101d13 <namex+0x43>
80101d0f:	90                   	nop
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	0f b6 03             	movzbl (%ebx),%eax
80101d16:	3c 2f                	cmp    $0x2f,%al
80101d18:	74 f6                	je     80101d10 <namex+0x40>
  if(*path == 0)
80101d1a:	84 c0                	test   %al,%al
80101d1c:	0f 84 ed 00 00 00    	je     80101e0f <namex+0x13f>
  while(*path != '/' && *path != 0)
80101d22:	0f b6 03             	movzbl (%ebx),%eax
80101d25:	89 da                	mov    %ebx,%edx
80101d27:	84 c0                	test   %al,%al
80101d29:	0f 84 b1 00 00 00    	je     80101de0 <namex+0x110>
80101d2f:	3c 2f                	cmp    $0x2f,%al
80101d31:	75 0f                	jne    80101d42 <namex+0x72>
80101d33:	e9 a8 00 00 00       	jmp    80101de0 <namex+0x110>
80101d38:	3c 2f                	cmp    $0x2f,%al
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d40:	74 0a                	je     80101d4c <namex+0x7c>
    path++;
80101d42:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d45:	0f b6 02             	movzbl (%edx),%eax
80101d48:	84 c0                	test   %al,%al
80101d4a:	75 ec                	jne    80101d38 <namex+0x68>
80101d4c:	89 d1                	mov    %edx,%ecx
80101d4e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d50:	83 f9 0d             	cmp    $0xd,%ecx
80101d53:	0f 8e 8f 00 00 00    	jle    80101de8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d5d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d64:	00 
80101d65:	89 3c 24             	mov    %edi,(%esp)
80101d68:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d6b:	e8 00 26 00 00       	call   80104370 <memmove>
    path++;
80101d70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d73:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d75:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d78:	75 0e                	jne    80101d88 <namex+0xb8>
80101d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	89 34 24             	mov    %esi,(%esp)
80101d8b:	e8 70 f9 ff ff       	call   80101700 <ilock>
    if(ip->type != T_DIR){
80101d90:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d95:	0f 85 85 00 00 00    	jne    80101e20 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d9e:	85 d2                	test   %edx,%edx
80101da0:	74 09                	je     80101dab <namex+0xdb>
80101da2:	80 3b 00             	cmpb   $0x0,(%ebx)
80101da5:	0f 84 a5 00 00 00    	je     80101e50 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101db2:	00 
80101db3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101db7:	89 34 24             	mov    %esi,(%esp)
80101dba:	e8 51 fe ff ff       	call   80101c10 <dirlookup>
80101dbf:	85 c0                	test   %eax,%eax
80101dc1:	74 5d                	je     80101e20 <namex+0x150>
  iunlock(ip);
80101dc3:	89 34 24             	mov    %esi,(%esp)
80101dc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dc9:	e8 12 fa ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101dce:	89 34 24             	mov    %esi,(%esp)
80101dd1:	e8 4a fa ff ff       	call   80101820 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 33 ff ff ff       	jmp    80101d13 <namex+0x43>
  while(*path != '/' && *path != 0)
80101de0:	31 c9                	xor    %ecx,%ecx
80101de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101de8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101df0:	89 3c 24             	mov    %edi,(%esp)
80101df3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101df9:	e8 72 25 00 00       	call   80104370 <memmove>
    name[len] = 0;
80101dfe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e04:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e08:	89 d3                	mov    %edx,%ebx
80101e0a:	e9 66 ff ff ff       	jmp    80101d75 <namex+0xa5>
  }
  if(nameiparent){
80101e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e12:	85 c0                	test   %eax,%eax
80101e14:	75 4c                	jne    80101e62 <namex+0x192>
80101e16:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
  iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 b8 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e28:	89 34 24             	mov    %esi,(%esp)
80101e2b:	e8 f0 f9 ff ff       	call   80101820 <iput>
}
80101e30:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e33:	31 c0                	xor    %eax,%eax
}
80101e35:	5b                   	pop    %ebx
80101e36:	5e                   	pop    %esi
80101e37:	5f                   	pop    %edi
80101e38:	5d                   	pop    %ebp
80101e39:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e3a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e44:	e8 17 f4 ff ff       	call   80101260 <iget>
80101e49:	89 c6                	mov    %eax,%esi
80101e4b:	e9 c3 fe ff ff       	jmp    80101d13 <namex+0x43>
      iunlock(ip);
80101e50:	89 34 24             	mov    %esi,(%esp)
80101e53:	e8 88 f9 ff ff       	call   801017e0 <iunlock>
}
80101e58:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e5b:	89 f0                	mov    %esi,%eax
}
80101e5d:	5b                   	pop    %ebx
80101e5e:	5e                   	pop    %esi
80101e5f:	5f                   	pop    %edi
80101e60:	5d                   	pop    %ebp
80101e61:	c3                   	ret    
    iput(ip);
80101e62:	89 34 24             	mov    %esi,(%esp)
80101e65:	e8 b6 f9 ff ff       	call   80101820 <iput>
    return 0;
80101e6a:	31 c0                	xor    %eax,%eax
80101e6c:	eb aa                	jmp    80101e18 <namex+0x148>
80101e6e:	66 90                	xchg   %ax,%ax

80101e70 <dirlink>:
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 2c             	sub    $0x2c,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e86:	00 
80101e87:	89 1c 24             	mov    %ebx,(%esp)
80101e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8e:	e8 7d fd ff ff       	call   80101c10 <dirlookup>
80101e93:	85 c0                	test   %eax,%eax
80101e95:	0f 85 8b 00 00 00    	jne    80101f26 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e9b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e9e:	31 ff                	xor    %edi,%edi
80101ea0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	75 13                	jne    80101eba <dirlink+0x4a>
80101ea7:	eb 35                	jmp    80101ede <dirlink+0x6e>
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb0:	8d 57 10             	lea    0x10(%edi),%edx
80101eb3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101eb6:	89 d7                	mov    %edx,%edi
80101eb8:	76 24                	jbe    80101ede <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eba:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec1:	00 
80101ec2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eca:	89 1c 24             	mov    %ebx,(%esp)
80101ecd:	e8 de fa ff ff       	call   801019b0 <readi>
80101ed2:	83 f8 10             	cmp    $0x10,%eax
80101ed5:	75 5e                	jne    80101f35 <dirlink+0xc5>
    if(de.inum == 0)
80101ed7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101edc:	75 d2                	jne    80101eb0 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101ede:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ee8:	00 
80101ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101eed:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ef0:	89 04 24             	mov    %eax,(%esp)
80101ef3:	e8 68 25 00 00       	call   80104460 <strncpy>
  de.inum = inum;
80101ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101efb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f02:	00 
80101f03:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f07:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f0b:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101f0e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f12:	e8 99 fb ff ff       	call   80101ab0 <writei>
80101f17:	83 f8 10             	cmp    $0x10,%eax
80101f1a:	75 25                	jne    80101f41 <dirlink+0xd1>
  return 0;
80101f1c:	31 c0                	xor    %eax,%eax
}
80101f1e:	83 c4 2c             	add    $0x2c,%esp
80101f21:	5b                   	pop    %ebx
80101f22:	5e                   	pop    %esi
80101f23:	5f                   	pop    %edi
80101f24:	5d                   	pop    %ebp
80101f25:	c3                   	ret    
    iput(ip);
80101f26:	89 04 24             	mov    %eax,(%esp)
80101f29:	e8 f2 f8 ff ff       	call   80101820 <iput>
    return -1;
80101f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f33:	eb e9                	jmp    80101f1e <dirlink+0xae>
      panic("dirlink read");
80101f35:	c7 04 24 e8 6f 10 80 	movl   $0x80106fe8,(%esp)
80101f3c:	e8 1f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f41:	c7 04 24 e6 75 10 80 	movl   $0x801075e6,(%esp)
80101f48:	e8 13 e4 ff ff       	call   80100360 <panic>
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi

80101f50 <namei>:

struct inode*
namei(char *path)
{
80101f50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f51:	31 d2                	xor    %edx,%edx
{
80101f53:	89 e5                	mov    %esp,%ebp
80101f55:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f5e:	e8 6d fd ff ff       	call   80101cd0 <namex>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    
80101f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f70:	55                   	push   %ebp
  return namex(path, 1, name);
80101f71:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f7e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f7f:	e9 4c fd ff ff       	jmp    80101cd0 <namex>
80101f84:	66 90                	xchg   %ax,%ax
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	66 90                	xchg   %ax,%ax
80101f8a:	66 90                	xchg   %ax,%ax
80101f8c:	66 90                	xchg   %ax,%ax
80101f8e:	66 90                	xchg   %ax,%ax

80101f90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	56                   	push   %esi
80101f94:	89 c6                	mov    %eax,%esi
80101f96:	53                   	push   %ebx
80101f97:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f9a:	85 c0                	test   %eax,%eax
80101f9c:	0f 84 99 00 00 00    	je     8010203b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fa2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fa5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101fab:	0f 87 7e 00 00 00    	ja     8010202f <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb6:	66 90                	xchg   %ax,%ax
80101fb8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fb9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fbc:	3c 40                	cmp    $0x40,%al
80101fbe:	75 f8                	jne    80101fb8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fc0:	31 db                	xor    %ebx,%ebx
80101fc2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fc7:	89 d8                	mov    %ebx,%eax
80101fc9:	ee                   	out    %al,(%dx)
80101fca:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd4:	ee                   	out    %al,(%dx)
80101fd5:	0f b6 c1             	movzbl %cl,%eax
80101fd8:	b2 f3                	mov    $0xf3,%dl
80101fda:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fdb:	89 c8                	mov    %ecx,%eax
80101fdd:	b2 f4                	mov    $0xf4,%dl
80101fdf:	c1 f8 08             	sar    $0x8,%eax
80101fe2:	ee                   	out    %al,(%dx)
80101fe3:	b2 f5                	mov    $0xf5,%dl
80101fe5:	89 d8                	mov    %ebx,%eax
80101fe7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fe8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fec:	b2 f6                	mov    $0xf6,%dl
80101fee:	83 e0 01             	and    $0x1,%eax
80101ff1:	c1 e0 04             	shl    $0x4,%eax
80101ff4:	83 c8 e0             	or     $0xffffffe0,%eax
80101ff7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ff8:	f6 06 04             	testb  $0x4,(%esi)
80101ffb:	75 13                	jne    80102010 <idestart+0x80>
80101ffd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102002:	b8 20 00 00 00       	mov    $0x20,%eax
80102007:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
8010200f:	90                   	nop
80102010:	b2 f7                	mov    $0xf7,%dl
80102012:	b8 30 00 00 00       	mov    $0x30,%eax
80102017:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102018:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010201d:	83 c6 5c             	add    $0x5c,%esi
80102020:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102025:	fc                   	cld    
80102026:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102028:	83 c4 10             	add    $0x10,%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5d                   	pop    %ebp
8010202e:	c3                   	ret    
    panic("incorrect blockno");
8010202f:	c7 04 24 54 70 10 80 	movl   $0x80107054,(%esp)
80102036:	e8 25 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010203b:	c7 04 24 4b 70 10 80 	movl   $0x8010704b,(%esp)
80102042:	e8 19 e3 ff ff       	call   80100360 <panic>
80102047:	89 f6                	mov    %esi,%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102050 <ideinit>:
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102056:	c7 44 24 04 66 70 10 	movl   $0x80107066,0x4(%esp)
8010205d:	80 
8010205e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102065:	e8 36 20 00 00       	call   801040a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010206a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010206f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102076:	83 e8 01             	sub    $0x1,%eax
80102079:	89 44 24 04          	mov    %eax,0x4(%esp)
8010207d:	e8 7e 02 00 00       	call   80102300 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102082:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102087:	90                   	nop
80102088:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102089:	83 e0 c0             	and    $0xffffffc0,%eax
8010208c:	3c 40                	cmp    $0x40,%al
8010208e:	75 f8                	jne    80102088 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102090:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102095:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010209a:	ee                   	out    %al,(%dx)
8010209b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a0:	b2 f7                	mov    $0xf7,%dl
801020a2:	eb 09                	jmp    801020ad <ideinit+0x5d>
801020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
801020a8:	83 e9 01             	sub    $0x1,%ecx
801020ab:	74 0f                	je     801020bc <ideinit+0x6c>
801020ad:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020ae:	84 c0                	test   %al,%al
801020b0:	74 f6                	je     801020a8 <ideinit+0x58>
      havedisk1 = 1;
801020b2:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020b9:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020bc:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020c1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020c6:	ee                   	out    %al,(%dx)
}
801020c7:	c9                   	leave  
801020c8:	c3                   	ret    
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020d9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e0:	e8 ab 20 00 00       	call   80104190 <acquire>

  if((b = idequeue) == 0){
801020e5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020eb:	85 db                	test   %ebx,%ebx
801020ed:	74 30                	je     8010211f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020ef:	8b 43 58             	mov    0x58(%ebx),%eax
801020f2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020f7:	8b 33                	mov    (%ebx),%esi
801020f9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020ff:	74 37                	je     80102138 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102101:	83 e6 fb             	and    $0xfffffffb,%esi
80102104:	83 ce 02             	or     $0x2,%esi
80102107:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102109:	89 1c 24             	mov    %ebx,(%esp)
8010210c:	e8 cf 1c 00 00       	call   80103de0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102111:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102116:	85 c0                	test   %eax,%eax
80102118:	74 05                	je     8010211f <ideintr+0x4f>
    idestart(idequeue);
8010211a:	e8 71 fe ff ff       	call   80101f90 <idestart>
    release(&idelock);
8010211f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102126:	e8 55 21 00 00       	call   80104280 <release>

  release(&idelock);
}
8010212b:	83 c4 1c             	add    $0x1c,%esp
8010212e:	5b                   	pop    %ebx
8010212f:	5e                   	pop    %esi
80102130:	5f                   	pop    %edi
80102131:	5d                   	pop    %ebp
80102132:	c3                   	ret    
80102133:	90                   	nop
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102138:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010213d:	8d 76 00             	lea    0x0(%esi),%esi
80102140:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102141:	89 c1                	mov    %eax,%ecx
80102143:	83 e1 c0             	and    $0xffffffc0,%ecx
80102146:	80 f9 40             	cmp    $0x40,%cl
80102149:	75 f5                	jne    80102140 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010214b:	a8 21                	test   $0x21,%al
8010214d:	75 b2                	jne    80102101 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010214f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102152:	b9 80 00 00 00       	mov    $0x80,%ecx
80102157:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010215c:	fc                   	cld    
8010215d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010215f:	8b 33                	mov    (%ebx),%esi
80102161:	eb 9e                	jmp    80102101 <ideintr+0x31>
80102163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102170 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	53                   	push   %ebx
80102174:	83 ec 14             	sub    $0x14,%esp
80102177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010217a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010217d:	89 04 24             	mov    %eax,(%esp)
80102180:	e8 eb 1e 00 00       	call   80104070 <holdingsleep>
80102185:	85 c0                	test   %eax,%eax
80102187:	0f 84 9e 00 00 00    	je     8010222b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010218d:	8b 03                	mov    (%ebx),%eax
8010218f:	83 e0 06             	and    $0x6,%eax
80102192:	83 f8 02             	cmp    $0x2,%eax
80102195:	0f 84 a8 00 00 00    	je     80102243 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010219b:	8b 53 04             	mov    0x4(%ebx),%edx
8010219e:	85 d2                	test   %edx,%edx
801021a0:	74 0d                	je     801021af <iderw+0x3f>
801021a2:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021a7:	85 c0                	test   %eax,%eax
801021a9:	0f 84 88 00 00 00    	je     80102237 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021af:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021b6:	e8 d5 1f 00 00       	call   80104190 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801021c0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021c7:	85 c0                	test   %eax,%eax
801021c9:	75 07                	jne    801021d2 <iderw+0x62>
801021cb:	eb 4e                	jmp    8010221b <iderw+0xab>
801021cd:	8d 76 00             	lea    0x0(%esi),%esi
801021d0:	89 d0                	mov    %edx,%eax
801021d2:	8b 50 58             	mov    0x58(%eax),%edx
801021d5:	85 d2                	test   %edx,%edx
801021d7:	75 f7                	jne    801021d0 <iderw+0x60>
801021d9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021dc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021de:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021e4:	74 3c                	je     80102222 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e6:	8b 03                	mov    (%ebx),%eax
801021e8:	83 e0 06             	and    $0x6,%eax
801021eb:	83 f8 02             	cmp    $0x2,%eax
801021ee:	74 1a                	je     8010220a <iderw+0x9a>
    sleep(b, &idelock);
801021f0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021f7:	80 
801021f8:	89 1c 24             	mov    %ebx,(%esp)
801021fb:	e8 50 1a 00 00       	call   80103c50 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102200:	8b 13                	mov    (%ebx),%edx
80102202:	83 e2 06             	and    $0x6,%edx
80102205:	83 fa 02             	cmp    $0x2,%edx
80102208:	75 e6                	jne    801021f0 <iderw+0x80>
  }


  release(&idelock);
8010220a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102211:	83 c4 14             	add    $0x14,%esp
80102214:	5b                   	pop    %ebx
80102215:	5d                   	pop    %ebp
  release(&idelock);
80102216:	e9 65 20 00 00       	jmp    80104280 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010221b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102220:	eb ba                	jmp    801021dc <iderw+0x6c>
    idestart(b);
80102222:	89 d8                	mov    %ebx,%eax
80102224:	e8 67 fd ff ff       	call   80101f90 <idestart>
80102229:	eb bb                	jmp    801021e6 <iderw+0x76>
    panic("iderw: buf not locked");
8010222b:	c7 04 24 6a 70 10 80 	movl   $0x8010706a,(%esp)
80102232:	e8 29 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102237:	c7 04 24 95 70 10 80 	movl   $0x80107095,(%esp)
8010223e:	e8 1d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102243:	c7 04 24 80 70 10 80 	movl   $0x80107080,(%esp)
8010224a:	e8 11 e1 ff ff       	call   80100360 <panic>
8010224f:	90                   	nop

80102250 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	56                   	push   %esi
80102254:	53                   	push   %ebx
80102255:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102258:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010225f:	00 c0 fe 
  ioapic->reg = reg;
80102262:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102269:	00 00 00 
  return ioapic->data;
8010226c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102272:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102275:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010227b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102281:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102288:	c1 e8 10             	shr    $0x10,%eax
8010228b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010228e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102291:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102294:	39 c2                	cmp    %eax,%edx
80102296:	74 12                	je     801022aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102298:	c7 04 24 b4 70 10 80 	movl   $0x801070b4,(%esp)
8010229f:	e8 ac e3 ff ff       	call   80100650 <cprintf>
801022a4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022aa:	ba 10 00 00 00       	mov    $0x10,%edx
801022af:	31 c0                	xor    %eax,%eax
801022b1:	eb 07                	jmp    801022ba <ioapicinit+0x6a>
801022b3:	90                   	nop
801022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022b8:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
801022ba:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022bc:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022c2:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022c5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
801022cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ce:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022d1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022d4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022d7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022d9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022df:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022e1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022e8:	7d ce                	jge    801022b8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ea:	83 c4 10             	add    $0x10,%esp
801022ed:	5b                   	pop    %ebx
801022ee:	5e                   	pop    %esi
801022ef:	5d                   	pop    %ebp
801022f0:	c3                   	ret    
801022f1:	eb 0d                	jmp    80102300 <ioapicenable>
801022f3:	90                   	nop
801022f4:	90                   	nop
801022f5:	90                   	nop
801022f6:	90                   	nop
801022f7:	90                   	nop
801022f8:	90                   	nop
801022f9:	90                   	nop
801022fa:	90                   	nop
801022fb:	90                   	nop
801022fc:	90                   	nop
801022fd:	90                   	nop
801022fe:	90                   	nop
801022ff:	90                   	nop

80102300 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	8b 55 08             	mov    0x8(%ebp),%edx
80102306:	53                   	push   %ebx
80102307:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010230a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010230d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
80102311:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102317:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
8010231a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010231c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102322:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
80102325:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
80102328:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010232a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102330:	89 42 10             	mov    %eax,0x10(%edx)
}
80102333:	5b                   	pop    %ebx
80102334:	5d                   	pop    %ebp
80102335:	c3                   	ret    
80102336:	66 90                	xchg   %ax,%ax
80102338:	66 90                	xchg   %ax,%ax
8010233a:	66 90                	xchg   %ax,%ax
8010233c:	66 90                	xchg   %ax,%ax
8010233e:	66 90                	xchg   %ax,%ax

80102340 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 14             	sub    $0x14,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010234a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102350:	75 7c                	jne    801023ce <kfree+0x8e>
80102352:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
80102358:	72 74                	jb     801023ce <kfree+0x8e>
8010235a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102360:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102365:	77 67                	ja     801023ce <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102367:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010236e:	00 
8010236f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102376:	00 
80102377:	89 1c 24             	mov    %ebx,(%esp)
8010237a:	e8 51 1f 00 00       	call   801042d0 <memset>

  if(kmem.use_lock)
8010237f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102385:	85 d2                	test   %edx,%edx
80102387:	75 37                	jne    801023c0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102389:	a1 78 26 11 80       	mov    0x80112678,%eax
8010238e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102390:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102395:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010239b:	85 c0                	test   %eax,%eax
8010239d:	75 09                	jne    801023a8 <kfree+0x68>
    release(&kmem.lock);
}
8010239f:	83 c4 14             	add    $0x14,%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5d                   	pop    %ebp
801023a4:	c3                   	ret    
801023a5:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
801023a8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023af:	83 c4 14             	add    $0x14,%esp
801023b2:	5b                   	pop    %ebx
801023b3:	5d                   	pop    %ebp
    release(&kmem.lock);
801023b4:	e9 c7 1e 00 00       	jmp    80104280 <release>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801023c0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023c7:	e8 c4 1d 00 00       	call   80104190 <acquire>
801023cc:	eb bb                	jmp    80102389 <kfree+0x49>
    panic("kfree");
801023ce:	c7 04 24 e6 70 10 80 	movl   $0x801070e6,(%esp)
801023d5:	e8 86 df ff ff       	call   80100360 <panic>
801023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ee:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023f4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102400:	39 de                	cmp    %ebx,%esi
80102402:	73 08                	jae    8010240c <freerange+0x2c>
80102404:	eb 18                	jmp    8010241e <freerange+0x3e>
80102406:	66 90                	xchg   %ax,%ax
80102408:	89 da                	mov    %ebx,%edx
8010240a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010240c:	89 14 24             	mov    %edx,(%esp)
8010240f:	e8 2c ff ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102414:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010241a:	39 f0                	cmp    %esi,%eax
8010241c:	76 ea                	jbe    80102408 <freerange+0x28>
}
8010241e:	83 c4 10             	add    $0x10,%esp
80102421:	5b                   	pop    %ebx
80102422:	5e                   	pop    %esi
80102423:	5d                   	pop    %ebp
80102424:	c3                   	ret    
80102425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	83 ec 10             	sub    $0x10,%esp
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010243b:	c7 44 24 04 ec 70 10 	movl   $0x801070ec,0x4(%esp)
80102442:	80 
80102443:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010244a:	e8 51 1c 00 00       	call   801040a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102452:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102459:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102462:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102468:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010246e:	39 de                	cmp    %ebx,%esi
80102470:	73 0a                	jae    8010247c <kinit1+0x4c>
80102472:	eb 1a                	jmp    8010248e <kinit1+0x5e>
80102474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 bc fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit1+0x48>
}
8010248e:	83 c4 10             	add    $0x10,%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801024a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 08                	jae    801024cc <kinit2+0x2c>
801024c4:	eb 18                	jmp    801024de <kinit2+0x3e>
801024c6:	66 90                	xchg   %ax,%ax
801024c8:	89 da                	mov    %ebx,%edx
801024ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024cc:	89 14 24             	mov    %edx,(%esp)
801024cf:	e8 6c fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024da:	39 c6                	cmp    %eax,%esi
801024dc:	73 ea                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024de:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024e5:	00 00 00 
}
801024e8:	83 c4 10             	add    $0x10,%esp
801024eb:	5b                   	pop    %ebx
801024ec:	5e                   	pop    %esi
801024ed:	5d                   	pop    %ebp
801024ee:	c3                   	ret    
801024ef:	90                   	nop

801024f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024f7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024fc:	85 c0                	test   %eax,%eax
801024fe:	75 30                	jne    80102530 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102500:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102506:	85 db                	test   %ebx,%ebx
80102508:	74 08                	je     80102512 <kalloc+0x22>
    kmem.freelist = r->next;
8010250a:	8b 13                	mov    (%ebx),%edx
8010250c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102512:	85 c0                	test   %eax,%eax
80102514:	74 0c                	je     80102522 <kalloc+0x32>
    release(&kmem.lock);
80102516:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010251d:	e8 5e 1d 00 00       	call   80104280 <release>
  return (char*)r;
}
80102522:	83 c4 14             	add    $0x14,%esp
80102525:	89 d8                	mov    %ebx,%eax
80102527:	5b                   	pop    %ebx
80102528:	5d                   	pop    %ebp
80102529:	c3                   	ret    
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102530:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102537:	e8 54 1c 00 00       	call   80104190 <acquire>
8010253c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102541:	eb bd                	jmp    80102500 <kalloc+0x10>
80102543:	66 90                	xchg   %ax,%ax
80102545:	66 90                	xchg   %ax,%ax
80102547:	66 90                	xchg   %ax,%ax
80102549:	66 90                	xchg   %ax,%ax
8010254b:	66 90                	xchg   %ax,%ax
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102550:	ba 64 00 00 00       	mov    $0x64,%edx
80102555:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102556:	a8 01                	test   $0x1,%al
80102558:	0f 84 ba 00 00 00    	je     80102618 <kbdgetc+0xc8>
8010255e:	b2 60                	mov    $0x60,%dl
80102560:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102561:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102564:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010256a:	0f 84 88 00 00 00    	je     801025f8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102570:	84 c0                	test   %al,%al
80102572:	79 2c                	jns    801025a0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102574:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010257a:	f6 c2 40             	test   $0x40,%dl
8010257d:	75 05                	jne    80102584 <kbdgetc+0x34>
8010257f:	89 c1                	mov    %eax,%ecx
80102581:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102584:	0f b6 81 20 72 10 80 	movzbl -0x7fef8de0(%ecx),%eax
8010258b:	83 c8 40             	or     $0x40,%eax
8010258e:	0f b6 c0             	movzbl %al,%eax
80102591:	f7 d0                	not    %eax
80102593:	21 d0                	and    %edx,%eax
80102595:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010259a:	31 c0                	xor    %eax,%eax
8010259c:	c3                   	ret    
8010259d:	8d 76 00             	lea    0x0(%esi),%esi
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
801025aa:	f6 c3 40             	test   $0x40,%bl
801025ad:	74 09                	je     801025b8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025af:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025b2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801025b5:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801025b8:	0f b6 91 20 72 10 80 	movzbl -0x7fef8de0(%ecx),%edx
  shift ^= togglecode[data];
801025bf:	0f b6 81 20 71 10 80 	movzbl -0x7fef8ee0(%ecx),%eax
  shift |= shiftcode[data];
801025c6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025c8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025ca:	89 d0                	mov    %edx,%eax
801025cc:	83 e0 03             	and    $0x3,%eax
801025cf:	8b 04 85 00 71 10 80 	mov    -0x7fef8f00(,%eax,4),%eax
  shift ^= togglecode[data];
801025d6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025dc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025df:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025e3:	74 0b                	je     801025f0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025e5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e8:	83 fa 19             	cmp    $0x19,%edx
801025eb:	77 1b                	ja     80102608 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ed:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025f0:	5b                   	pop    %ebx
801025f1:	5d                   	pop    %ebp
801025f2:	c3                   	ret    
801025f3:	90                   	nop
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025f8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025ff:	31 c0                	xor    %eax,%eax
80102601:	c3                   	ret    
80102602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102608:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010260b:	8d 50 20             	lea    0x20(%eax),%edx
8010260e:	83 f9 19             	cmp    $0x19,%ecx
80102611:	0f 46 c2             	cmovbe %edx,%eax
  return c;
80102614:	eb da                	jmp    801025f0 <kbdgetc+0xa0>
80102616:	66 90                	xchg   %ax,%ax
    return -1;
80102618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010261d:	c3                   	ret    
8010261e:	66 90                	xchg   %ax,%ax

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102626:	c7 04 24 50 25 10 80 	movl   $0x80102550,(%esp)
8010262d:	e8 7e e1 ff ff       	call   801007b0 <consoleintr>
}
80102632:	c9                   	leave  
80102633:	c3                   	ret    
80102634:	66 90                	xchg   %ax,%ax
80102636:	66 90                	xchg   %ax,%ax
80102638:	66 90                	xchg   %ax,%ax
8010263a:	66 90                	xchg   %ax,%ax
8010263c:	66 90                	xchg   %ax,%ax
8010263e:	66 90                	xchg   %ax,%ax

80102640 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102640:	55                   	push   %ebp
80102641:	89 c1                	mov    %eax,%ecx
80102643:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102645:	ba 70 00 00 00       	mov    $0x70,%edx
8010264a:	53                   	push   %ebx
8010264b:	31 c0                	xor    %eax,%eax
8010264d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010264e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102653:	89 da                	mov    %ebx,%edx
80102655:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102656:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102659:	b2 70                	mov    $0x70,%dl
8010265b:	89 01                	mov    %eax,(%ecx)
8010265d:	b8 02 00 00 00       	mov    $0x2,%eax
80102662:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102663:	89 da                	mov    %ebx,%edx
80102665:	ec                   	in     (%dx),%al
80102666:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102669:	b2 70                	mov    $0x70,%dl
8010266b:	89 41 04             	mov    %eax,0x4(%ecx)
8010266e:	b8 04 00 00 00       	mov    $0x4,%eax
80102673:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102674:	89 da                	mov    %ebx,%edx
80102676:	ec                   	in     (%dx),%al
80102677:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267a:	b2 70                	mov    $0x70,%dl
8010267c:	89 41 08             	mov    %eax,0x8(%ecx)
8010267f:	b8 07 00 00 00       	mov    $0x7,%eax
80102684:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102685:	89 da                	mov    %ebx,%edx
80102687:	ec                   	in     (%dx),%al
80102688:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268b:	b2 70                	mov    $0x70,%dl
8010268d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102690:	b8 08 00 00 00       	mov    $0x8,%eax
80102695:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102696:	89 da                	mov    %ebx,%edx
80102698:	ec                   	in     (%dx),%al
80102699:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269c:	b2 70                	mov    $0x70,%dl
8010269e:	89 41 10             	mov    %eax,0x10(%ecx)
801026a1:	b8 09 00 00 00       	mov    $0x9,%eax
801026a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a7:	89 da                	mov    %ebx,%edx
801026a9:	ec                   	in     (%dx),%al
801026aa:	0f b6 d8             	movzbl %al,%ebx
801026ad:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026b0:	5b                   	pop    %ebx
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <lapicinit>:
  if(!lapic)
801026c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026c5:	55                   	push   %ebp
801026c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026c8:	85 c0                	test   %eax,%eax
801026ca:	0f 84 c0 00 00 00    	je     80102790 <lapicinit+0xd0>
  lapic[index] = value;
801026d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102701:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102704:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010270b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102711:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102718:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271b:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010271e:	8b 50 30             	mov    0x30(%eax),%edx
80102721:	c1 ea 10             	shr    $0x10,%edx
80102724:	80 fa 03             	cmp    $0x3,%dl
80102727:	77 6f                	ja     80102798 <lapicinit+0xd8>
  lapic[index] = value;
80102729:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102730:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102733:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102736:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102740:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102743:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102750:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102757:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102764:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102767:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102771:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102774:	8b 50 20             	mov    0x20(%eax),%edx
80102777:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102778:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010277e:	80 e6 10             	and    $0x10,%dh
80102781:	75 f5                	jne    80102778 <lapicinit+0xb8>
  lapic[index] = value;
80102783:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010278a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102790:	5d                   	pop    %ebp
80102791:	c3                   	ret    
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102798:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010279f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027a2:	8b 50 20             	mov    0x20(%eax),%edx
801027a5:	eb 82                	jmp    80102729 <lapicinit+0x69>
801027a7:	89 f6                	mov    %esi,%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicid>:
  if (!lapic)
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0c                	je     801027c8 <lapicid+0x18>
  return lapic[ID] >> 24;
801027bc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027bf:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801027c0:	c1 e8 18             	shr    $0x18,%eax
}
801027c3:	c3                   	ret    
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801027c8:	31 c0                	xor    %eax,%eax
}
801027ca:	5d                   	pop    %ebp
801027cb:	c3                   	ret    
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <lapiceoi>:
  if(lapic)
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 0d                	je     801027e9 <lapiceoi+0x19>
  lapic[index] = value;
801027dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <microdelay>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
}
801027f3:	5d                   	pop    %ebp
801027f4:	c3                   	ret    
801027f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <lapicstartap>:
{
80102800:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	ba 70 00 00 00       	mov    $0x70,%edx
80102806:	89 e5                	mov    %esp,%ebp
80102808:	b8 0f 00 00 00       	mov    $0xf,%eax
8010280d:	53                   	push   %ebx
8010280e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102811:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102814:	ee                   	out    %al,(%dx)
80102815:	b8 0a 00 00 00       	mov    $0xa,%eax
8010281a:	b2 71                	mov    $0x71,%dl
8010281c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010281d:	31 c0                	xor    %eax,%eax
8010281f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102825:	89 d8                	mov    %ebx,%eax
80102827:	c1 e8 04             	shr    $0x4,%eax
8010282a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102830:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102835:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102838:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010283b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010284b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102858:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102867:	89 da                	mov    %ebx,%edx
80102869:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010286c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102872:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102875:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010287e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 40 20             	mov    0x20(%eax),%eax
}
80102887:	5b                   	pop    %ebx
80102888:	5d                   	pop    %ebp
80102889:	c3                   	ret    
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102890:	55                   	push   %ebp
80102891:	ba 70 00 00 00       	mov    $0x70,%edx
80102896:	89 e5                	mov    %esp,%ebp
80102898:	b8 0b 00 00 00       	mov    $0xb,%eax
8010289d:	57                   	push   %edi
8010289e:	56                   	push   %esi
8010289f:	53                   	push   %ebx
801028a0:	83 ec 4c             	sub    $0x4c,%esp
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	b2 71                	mov    $0x71,%dl
801028a6:	ec                   	in     (%dx),%al
801028a7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028aa:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028ad:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028b1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028bd:	89 d8                	mov    %ebx,%eax
801028bf:	e8 7c fd ff ff       	call   80102640 <fill_rtcdate>
801028c4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c9:	89 f2                	mov    %esi,%edx
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	ba 71 00 00 00       	mov    $0x71,%edx
801028d1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d2:	84 c0                	test   %al,%al
801028d4:	78 e7                	js     801028bd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028d6:	89 f8                	mov    %edi,%eax
801028d8:	e8 63 fd ff ff       	call   80102640 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028e4:	00 
801028e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028e9:	89 1c 24             	mov    %ebx,(%esp)
801028ec:	e8 2f 1a 00 00       	call   80104320 <memcmp>
801028f1:	85 c0                	test   %eax,%eax
801028f3:	75 c3                	jne    801028b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028f5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f9:	75 78                	jne    80102973 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102923:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102926:	89 c2                	mov    %eax,%edx
80102928:	83 e0 0f             	and    $0xf,%eax
8010292b:	c1 ea 04             	shr    $0x4,%edx
8010292e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102931:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102934:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 c2                	mov    %eax,%edx
8010293c:	83 e0 0f             	and    $0xf,%eax
8010293f:	c1 ea 04             	shr    $0x4,%edx
80102942:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102945:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102948:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294e:	89 c2                	mov    %eax,%edx
80102950:	83 e0 0f             	and    $0xf,%eax
80102953:	c1 ea 04             	shr    $0x4,%edx
80102956:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102959:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102962:	89 c2                	mov    %eax,%edx
80102964:	83 e0 0f             	and    $0xf,%eax
80102967:	c1 ea 04             	shr    $0x4,%edx
8010296a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102970:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102973:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102976:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102979:	89 01                	mov    %eax,(%ecx)
8010297b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297e:	89 41 04             	mov    %eax,0x4(%ecx)
80102981:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102984:	89 41 08             	mov    %eax,0x8(%ecx)
80102987:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010298d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102990:	89 41 10             	mov    %eax,0x10(%ecx)
80102993:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102996:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102999:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029a0:	83 c4 4c             	add    $0x4c,%esp
801029a3:	5b                   	pop    %ebx
801029a4:	5e                   	pop    %esi
801029a5:	5f                   	pop    %edi
801029a6:	5d                   	pop    %ebp
801029a7:	c3                   	ret    
801029a8:	66 90                	xchg   %ax,%ax
801029aa:	66 90                	xchg   %ax,%ax
801029ac:	66 90                	xchg   %ax,%ax
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	57                   	push   %edi
801029b4:	56                   	push   %esi
801029b5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b6:	31 db                	xor    %ebx,%ebx
{
801029b8:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801029bb:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029c0:	85 c0                	test   %eax,%eax
801029c2:	7e 78                	jle    80102a3c <install_trans+0x8c>
801029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029cd:	01 d8                	add    %ebx,%eax
801029cf:	83 c0 01             	add    $0x1,%eax
801029d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029db:	89 04 24             	mov    %eax,(%esp)
801029de:	e8 ed d6 ff ff       	call   801000d0 <bread>
801029e3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029e5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029f8:	89 04 24             	mov    %eax,(%esp)
801029fb:	e8 d0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a00:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a07:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a08:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a0a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a11:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a14:	89 04 24             	mov    %eax,(%esp)
80102a17:	e8 54 19 00 00       	call   80104370 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a1c:	89 34 24             	mov    %esi,(%esp)
80102a1f:	e8 7c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a24:	89 3c 24             	mov    %edi,(%esp)
80102a27:	e8 b4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a2c:	89 34 24             	mov    %esi,(%esp)
80102a2f:	e8 ac d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a34:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a3a:	7f 8c                	jg     801029c8 <install_trans+0x18>
  }
}
80102a3c:	83 c4 1c             	add    $0x1c,%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	c3                   	ret    
80102a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	57                   	push   %edi
80102a54:	56                   	push   %esi
80102a55:	53                   	push   %ebx
80102a56:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a59:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a62:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a67:	89 04 24             	mov    %eax,(%esp)
80102a6a:	e8 61 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a6f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a75:	31 d2                	xor    %edx,%edx
80102a77:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a79:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a7b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a7e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a81:	7e 17                	jle    80102a9a <write_head+0x4a>
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a8f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a93:	83 c2 01             	add    $0x1,%edx
80102a96:	39 da                	cmp    %ebx,%edx
80102a98:	75 ee                	jne    80102a88 <write_head+0x38>
  }
  bwrite(buf);
80102a9a:	89 3c 24             	mov    %edi,(%esp)
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 3c 24             	mov    %edi,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	83 c4 1c             	add    $0x1c,%esp
80102aad:	5b                   	pop    %ebx
80102aae:	5e                   	pop    %esi
80102aaf:	5f                   	pop    %edi
80102ab0:	5d                   	pop    %ebp
80102ab1:	c3                   	ret    
80102ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <initlog>:
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
80102ac5:	83 ec 30             	sub    $0x30,%esp
80102ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102acb:	c7 44 24 04 20 73 10 	movl   $0x80107320,0x4(%esp)
80102ad2:	80 
80102ad3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ada:	e8 c1 15 00 00       	call   801040a0 <initlock>
  readsb(dev, &sb);
80102adf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ae6:	89 1c 24             	mov    %ebx,(%esp)
80102ae9:	e8 f2 e8 ff ff       	call   801013e0 <readsb>
  log.start = sb.logstart;
80102aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102af1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102af4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102af7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102b01:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b07:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b0c:	e8 bf d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102b11:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102b13:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b16:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b19:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b1b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b21:	7e 17                	jle    80102b3a <initlog+0x7a>
80102b23:	90                   	nop
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b28:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b2c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b33:	83 c2 01             	add    $0x1,%edx
80102b36:	39 da                	cmp    %ebx,%edx
80102b38:	75 ee                	jne    80102b28 <initlog+0x68>
  brelse(buf);
80102b3a:	89 04 24             	mov    %eax,(%esp)
80102b3d:	e8 9e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b42:	e8 69 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b47:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b4e:	00 00 00 
  write_head(); // clear the log
80102b51:	e8 fa fe ff ff       	call   80102a50 <write_head>
}
80102b56:	83 c4 30             	add    $0x30,%esp
80102b59:	5b                   	pop    %ebx
80102b5a:	5e                   	pop    %esi
80102b5b:	5d                   	pop    %ebp
80102b5c:	c3                   	ret    
80102b5d:	8d 76 00             	lea    0x0(%esi),%esi

80102b60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b66:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b6d:	e8 1e 16 00 00       	call   80104190 <acquire>
80102b72:	eb 18                	jmp    80102b8c <begin_op+0x2c>
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b78:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b7f:	80 
80102b80:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b87:	e8 c4 10 00 00       	call   80103c50 <sleep>
    if(log.committing){
80102b8c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b91:	85 c0                	test   %eax,%eax
80102b93:	75 e3                	jne    80102b78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b9a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ba0:	83 c0 01             	add    $0x1,%eax
80102ba3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ba6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102ba9:	83 fa 1e             	cmp    $0x1e,%edx
80102bac:	7f ca                	jg     80102b78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bae:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102bba:	e8 c1 16 00 00       	call   80104280 <release>
      break;
    }
  }
}
80102bbf:	c9                   	leave  
80102bc0:	c3                   	ret    
80102bc1:	eb 0d                	jmp    80102bd0 <end_op>
80102bc3:	90                   	nop
80102bc4:	90                   	nop
80102bc5:	90                   	nop
80102bc6:	90                   	nop
80102bc7:	90                   	nop
80102bc8:	90                   	nop
80102bc9:	90                   	nop
80102bca:	90                   	nop
80102bcb:	90                   	nop
80102bcc:	90                   	nop
80102bcd:	90                   	nop
80102bce:	90                   	nop
80102bcf:	90                   	nop

80102bd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bd9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102be0:	e8 ab 15 00 00       	call   80104190 <acquire>
  log.outstanding -= 1;
80102be5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bea:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bf0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bf3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bf5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bfa:	0f 85 f3 00 00 00    	jne    80102cf3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c00:	85 c0                	test   %eax,%eax
80102c02:	0f 85 cb 00 00 00    	jne    80102cd3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c0f:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102c11:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c18:	00 00 00 
  release(&log.lock);
80102c1b:	e8 60 16 00 00       	call   80104280 <release>
  if (log.lh.n > 0) {
80102c20:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c25:	85 c0                	test   %eax,%eax
80102c27:	0f 8e 90 00 00 00    	jle    80102cbd <end_op+0xed>
80102c2d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c35:	01 d8                	add    %ebx,%eax
80102c37:	83 c0 01             	add    $0x1,%eax
80102c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c3e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c43:	89 04 24             	mov    %eax,(%esp)
80102c46:	e8 85 d4 ff ff       	call   801000d0 <bread>
80102c4b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c4d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c54:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c57:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c60:	89 04 24             	mov    %eax,(%esp)
80102c63:	e8 68 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c68:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c6f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c70:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c72:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c75:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c79:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7c:	89 04 24             	mov    %eax,(%esp)
80102c7f:	e8 ec 16 00 00       	call   80104370 <memmove>
    bwrite(to);  // write the log
80102c84:	89 34 24             	mov    %esi,(%esp)
80102c87:	e8 14 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c8c:	89 3c 24             	mov    %edi,(%esp)
80102c8f:	e8 4c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c94:	89 34 24             	mov    %esi,(%esp)
80102c97:	e8 44 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102ca2:	7c 8c                	jl     80102c30 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ca4:	e8 a7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102ca9:	e8 02 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102cae:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cb5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cb8:	e8 93 fd ff ff       	call   80102a50 <write_head>
    acquire(&log.lock);
80102cbd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc4:	e8 c7 14 00 00       	call   80104190 <acquire>
    log.committing = 0;
80102cc9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cd0:	00 00 00 
    wakeup(&log);
80102cd3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cda:	e8 01 11 00 00       	call   80103de0 <wakeup>
    release(&log.lock);
80102cdf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ce6:	e8 95 15 00 00       	call   80104280 <release>
}
80102ceb:	83 c4 1c             	add    $0x1c,%esp
80102cee:	5b                   	pop    %ebx
80102cef:	5e                   	pop    %esi
80102cf0:	5f                   	pop    %edi
80102cf1:	5d                   	pop    %ebp
80102cf2:	c3                   	ret    
    panic("log.committing");
80102cf3:	c7 04 24 24 73 10 80 	movl   $0x80107324,(%esp)
80102cfa:	e8 61 d6 ff ff       	call   80100360 <panic>
80102cff:	90                   	nop

80102d00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d07:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d0f:	83 f8 1d             	cmp    $0x1d,%eax
80102d12:	0f 8f 98 00 00 00    	jg     80102db0 <log_write+0xb0>
80102d18:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102d1e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d21:	39 d0                	cmp    %edx,%eax
80102d23:	0f 8d 87 00 00 00    	jge    80102db0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d29:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	0f 8e 86 00 00 00    	jle    80102dbc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d36:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d3d:	e8 4e 14 00 00       	call   80104190 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d42:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d48:	83 fa 00             	cmp    $0x0,%edx
80102d4b:	7e 54                	jle    80102da1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d4d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d50:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d52:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d58:	75 0f                	jne    80102d69 <log_write+0x69>
80102d5a:	eb 3c                	jmp    80102d98 <log_write+0x98>
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d60:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d67:	74 2f                	je     80102d98 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d69:	83 c0 01             	add    $0x1,%eax
80102d6c:	39 d0                	cmp    %edx,%eax
80102d6e:	75 f0                	jne    80102d60 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d70:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d77:	83 c2 01             	add    $0x1,%edx
80102d7a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d80:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d83:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d8a:	83 c4 14             	add    $0x14,%esp
80102d8d:	5b                   	pop    %ebx
80102d8e:	5d                   	pop    %ebp
  release(&log.lock);
80102d8f:	e9 ec 14 00 00       	jmp    80104280 <release>
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d98:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d9f:	eb df                	jmp    80102d80 <log_write+0x80>
80102da1:	8b 43 08             	mov    0x8(%ebx),%eax
80102da4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102da9:	75 d5                	jne    80102d80 <log_write+0x80>
80102dab:	eb ca                	jmp    80102d77 <log_write+0x77>
80102dad:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102db0:	c7 04 24 33 73 10 80 	movl   $0x80107333,(%esp)
80102db7:	e8 a4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102dbc:	c7 04 24 49 73 10 80 	movl   $0x80107349,(%esp)
80102dc3:	e8 98 d5 ff ff       	call   80100360 <panic>
80102dc8:	66 90                	xchg   %ax,%ax
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102dd7:	e8 f4 08 00 00       	call   801036d0 <cpuid>
80102ddc:	89 c3                	mov    %eax,%ebx
80102dde:	e8 ed 08 00 00       	call   801036d0 <cpuid>
80102de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102de7:	c7 04 24 64 73 10 80 	movl   $0x80107364,(%esp)
80102dee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102df2:	e8 59 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102df7:	e8 44 27 00 00       	call   80105540 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dfc:	e8 4f 08 00 00       	call   80103650 <mycpu>
80102e01:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e03:	b8 01 00 00 00       	mov    $0x1,%eax
80102e08:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e0f:	e8 9c 0b 00 00       	call   801039b0 <scheduler>
80102e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e20 <mpenter>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e26:	e8 55 38 00 00       	call   80106680 <switchkvm>
  seginit();
80102e2b:	e8 10 37 00 00       	call   80106540 <seginit>
  lapicinit();
80102e30:	e8 8b f8 ff ff       	call   801026c0 <lapicinit>
  mpmain();
80102e35:	e8 96 ff ff ff       	call   80102dd0 <mpmain>
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <main>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e44:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e49:	83 e4 f0             	and    $0xfffffff0,%esp
80102e4c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e4f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e56:	80 
80102e57:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102e5e:	e8 cd f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102e63:	e8 c8 3c 00 00       	call   80106b30 <kvmalloc>
  mpinit();        // detect other processors
80102e68:	e8 73 01 00 00       	call   80102fe0 <mpinit>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e70:	e8 4b f8 ff ff       	call   801026c0 <lapicinit>
  seginit();       // segment descriptors
80102e75:	e8 c6 36 00 00       	call   80106540 <seginit>
  picinit();       // disable pic
80102e7a:	e8 21 03 00 00       	call   801031a0 <picinit>
80102e7f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e80:	e8 cb f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102e85:	e8 c6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e8a:	e8 51 2a 00 00       	call   801058e0 <uartinit>
80102e8f:	90                   	nop
  pinit();         // process table
80102e90:	e8 9b 07 00 00       	call   80103630 <pinit>
  shminit();       // shared memory
80102e95:	e8 66 3f 00 00       	call   80106e00 <shminit>
  tvinit();        // trap vectors
80102e9a:	e8 01 26 00 00       	call   801054a0 <tvinit>
80102e9f:	90                   	nop
  binit();         // buffer cache
80102ea0:	e8 9b d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ea5:	e8 e6 de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
80102eaa:	e8 a1 f1 ff ff       	call   80102050 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eaf:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102eb6:	00 
80102eb7:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102ebe:	80 
80102ebf:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ec6:	e8 a5 14 00 00       	call   80104370 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102ecb:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed2:	00 00 00 
80102ed5:	05 80 27 11 80       	add    $0x80112780,%eax
80102eda:	39 d8                	cmp    %ebx,%eax
80102edc:	76 65                	jbe    80102f43 <main+0x103>
80102ede:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102ee0:	e8 6b 07 00 00       	call   80103650 <mycpu>
80102ee5:	39 d8                	cmp    %ebx,%eax
80102ee7:	74 41                	je     80102f2a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ee9:	e8 02 f6 ff ff       	call   801024f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102eee:	c7 05 f8 6f 00 80 20 	movl   $0x80102e20,0x80006ff8
80102ef5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ef8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eff:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f02:	05 00 10 00 00       	add    $0x1000,%eax
80102f07:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f0c:	0f b6 03             	movzbl (%ebx),%eax
80102f0f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f16:	00 
80102f17:	89 04 24             	mov    %eax,(%esp)
80102f1a:	e8 e1 f8 ff ff       	call   80102800 <lapicstartap>
80102f1f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f20:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f26:	85 c0                	test   %eax,%eax
80102f28:	74 f6                	je     80102f20 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f2a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f31:	00 00 00 
80102f34:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f3a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f3f:	39 c3                	cmp    %eax,%ebx
80102f41:	72 9d                	jb     80102ee0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f43:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f4a:	8e 
80102f4b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f52:	e8 49 f5 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102f57:	e8 c4 07 00 00       	call   80103720 <userinit>
  mpmain();        // finish this processor's setup
80102f5c:	e8 6f fe ff ff       	call   80102dd0 <mpmain>
80102f61:	66 90                	xchg   %ax,%ax
80102f63:	66 90                	xchg   %ax,%ax
80102f65:	66 90                	xchg   %ax,%ax
80102f67:	66 90                	xchg   %ax,%ax
80102f69:	66 90                	xchg   %ax,%ax
80102f6b:	66 90                	xchg   %ax,%ax
80102f6d:	66 90                	xchg   %ax,%ax
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f74:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f7a:	53                   	push   %ebx
  e = addr+len;
80102f7b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f7e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f81:	39 de                	cmp    %ebx,%esi
80102f83:	73 3c                	jae    80102fc1 <mpsearch1+0x51>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f88:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f8f:	00 
80102f90:	c7 44 24 04 78 73 10 	movl   $0x80107378,0x4(%esp)
80102f97:	80 
80102f98:	89 34 24             	mov    %esi,(%esp)
80102f9b:	e8 80 13 00 00       	call   80104320 <memcmp>
80102fa0:	85 c0                	test   %eax,%eax
80102fa2:	75 16                	jne    80102fba <mpsearch1+0x4a>
80102fa4:	31 c9                	xor    %ecx,%ecx
80102fa6:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102fa8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102fac:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102faf:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102fb1:	83 fa 10             	cmp    $0x10,%edx
80102fb4:	75 f2                	jne    80102fa8 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb6:	84 c9                	test   %cl,%cl
80102fb8:	74 10                	je     80102fca <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102fba:	83 c6 10             	add    $0x10,%esi
80102fbd:	39 f3                	cmp    %esi,%ebx
80102fbf:	77 c7                	ja     80102f88 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102fc1:	83 c4 10             	add    $0x10,%esp
  return 0;
80102fc4:	31 c0                	xor    %eax,%eax
}
80102fc6:	5b                   	pop    %ebx
80102fc7:	5e                   	pop    %esi
80102fc8:	5d                   	pop    %ebp
80102fc9:	c3                   	ret    
80102fca:	83 c4 10             	add    $0x10,%esp
80102fcd:	89 f0                	mov    %esi,%eax
80102fcf:	5b                   	pop    %ebx
80102fd0:	5e                   	pop    %esi
80102fd1:	5d                   	pop    %ebp
80102fd2:	c3                   	ret    
80102fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fe9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ff0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ff7:	c1 e0 08             	shl    $0x8,%eax
80102ffa:	09 d0                	or     %edx,%eax
80102ffc:	c1 e0 04             	shl    $0x4,%eax
80102fff:	85 c0                	test   %eax,%eax
80103001:	75 1b                	jne    8010301e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103003:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010300a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103011:	c1 e0 08             	shl    $0x8,%eax
80103014:	09 d0                	or     %edx,%eax
80103016:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103019:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010301e:	ba 00 04 00 00       	mov    $0x400,%edx
80103023:	e8 48 ff ff ff       	call   80102f70 <mpsearch1>
80103028:	85 c0                	test   %eax,%eax
8010302a:	89 c7                	mov    %eax,%edi
8010302c:	0f 84 22 01 00 00    	je     80103154 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103032:	8b 77 04             	mov    0x4(%edi),%esi
80103035:	85 f6                	test   %esi,%esi
80103037:	0f 84 30 01 00 00    	je     8010316d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010303d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103043:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010304a:	00 
8010304b:	c7 44 24 04 7d 73 10 	movl   $0x8010737d,0x4(%esp)
80103052:	80 
80103053:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103056:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103059:	e8 c2 12 00 00       	call   80104320 <memcmp>
8010305e:	85 c0                	test   %eax,%eax
80103060:	0f 85 07 01 00 00    	jne    8010316d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103066:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010306d:	3c 04                	cmp    $0x4,%al
8010306f:	0f 85 0b 01 00 00    	jne    80103180 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103075:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010307c:	85 c0                	test   %eax,%eax
8010307e:	74 21                	je     801030a1 <mpinit+0xc1>
  sum = 0;
80103080:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103082:	31 d2                	xor    %edx,%edx
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103088:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010308f:	80 
  for(i=0; i<len; i++)
80103090:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103093:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103095:	39 d0                	cmp    %edx,%eax
80103097:	7f ef                	jg     80103088 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103099:	84 c9                	test   %cl,%cl
8010309b:	0f 85 cc 00 00 00    	jne    8010316d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a4:	85 c0                	test   %eax,%eax
801030a6:	0f 84 c1 00 00 00    	je     8010316d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030ac:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
801030b2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030b7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030bc:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030c3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030c9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030d0:	39 c2                	cmp    %eax,%edx
801030d2:	76 1b                	jbe    801030ef <mpinit+0x10f>
801030d4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030d7:	80 f9 04             	cmp    $0x4,%cl
801030da:	77 74                	ja     80103150 <mpinit+0x170>
801030dc:	ff 24 8d bc 73 10 80 	jmp    *-0x7fef8c44(,%ecx,4)
801030e3:	90                   	nop
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030e8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030eb:	39 c2                	cmp    %eax,%edx
801030ed:	77 e5                	ja     801030d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030ef:	85 db                	test   %ebx,%ebx
801030f1:	0f 84 93 00 00 00    	je     8010318a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030f7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030fb:	74 12                	je     8010310f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fd:	ba 22 00 00 00       	mov    $0x22,%edx
80103102:	b8 70 00 00 00       	mov    $0x70,%eax
80103107:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103108:	b2 23                	mov    $0x23,%dl
8010310a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010310b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310e:	ee                   	out    %al,(%dx)
  }
}
8010310f:	83 c4 1c             	add    $0x1c,%esp
80103112:	5b                   	pop    %ebx
80103113:	5e                   	pop    %esi
80103114:	5f                   	pop    %edi
80103115:	5d                   	pop    %ebp
80103116:	c3                   	ret    
80103117:	90                   	nop
      if(ncpu < NCPU) {
80103118:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010311e:	83 fe 07             	cmp    $0x7,%esi
80103121:	7f 17                	jg     8010313a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103123:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103127:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010312d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103134:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010313a:	83 c0 14             	add    $0x14,%eax
      continue;
8010313d:	eb 91                	jmp    801030d0 <mpinit+0xf0>
8010313f:	90                   	nop
      ioapicid = ioapic->apicno;
80103140:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103144:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103147:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010314d:	eb 81                	jmp    801030d0 <mpinit+0xf0>
8010314f:	90                   	nop
      ismp = 0;
80103150:	31 db                	xor    %ebx,%ebx
80103152:	eb 83                	jmp    801030d7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103154:	ba 00 00 01 00       	mov    $0x10000,%edx
80103159:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010315e:	e8 0d fe ff ff       	call   80102f70 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103163:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103165:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103167:	0f 85 c5 fe ff ff    	jne    80103032 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010316d:	c7 04 24 82 73 10 80 	movl   $0x80107382,(%esp)
80103174:	e8 e7 d1 ff ff       	call   80100360 <panic>
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103180:	3c 01                	cmp    $0x1,%al
80103182:	0f 84 ed fe ff ff    	je     80103075 <mpinit+0x95>
80103188:	eb e3                	jmp    8010316d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010318a:	c7 04 24 9c 73 10 80 	movl   $0x8010739c,(%esp)
80103191:	e8 ca d1 ff ff       	call   80100360 <panic>
80103196:	66 90                	xchg   %ax,%ax
80103198:	66 90                	xchg   %ax,%ax
8010319a:	66 90                	xchg   %ax,%ax
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031a0:	55                   	push   %ebp
801031a1:	ba 21 00 00 00       	mov    $0x21,%edx
801031a6:	89 e5                	mov    %esp,%ebp
801031a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031ad:	ee                   	out    %al,(%dx)
801031ae:	b2 a1                	mov    $0xa1,%dl
801031b0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031b1:	5d                   	pop    %ebp
801031b2:	c3                   	ret    
801031b3:	66 90                	xchg   %ax,%ax
801031b5:	66 90                	xchg   %ax,%ax
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
801031c5:	53                   	push   %ebx
801031c6:	83 ec 1c             	sub    $0x1c,%esp
801031c9:	8b 75 08             	mov    0x8(%ebp),%esi
801031cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031db:	e8 d0 db ff ff       	call   80100db0 <filealloc>
801031e0:	85 c0                	test   %eax,%eax
801031e2:	89 06                	mov    %eax,(%esi)
801031e4:	0f 84 a4 00 00 00    	je     8010328e <pipealloc+0xce>
801031ea:	e8 c1 db ff ff       	call   80100db0 <filealloc>
801031ef:	85 c0                	test   %eax,%eax
801031f1:	89 03                	mov    %eax,(%ebx)
801031f3:	0f 84 87 00 00 00    	je     80103280 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031f9:	e8 f2 f2 ff ff       	call   801024f0 <kalloc>
801031fe:	85 c0                	test   %eax,%eax
80103200:	89 c7                	mov    %eax,%edi
80103202:	74 7c                	je     80103280 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103204:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010320b:	00 00 00 
  p->writeopen = 1;
8010320e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103215:	00 00 00 
  p->nwrite = 0;
80103218:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010321f:	00 00 00 
  p->nread = 0;
80103222:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103229:	00 00 00 
  initlock(&p->lock, "pipe");
8010322c:	89 04 24             	mov    %eax,(%esp)
8010322f:	c7 44 24 04 d0 73 10 	movl   $0x801073d0,0x4(%esp)
80103236:	80 
80103237:	e8 64 0e 00 00       	call   801040a0 <initlock>
  (*f0)->type = FD_PIPE;
8010323c:	8b 06                	mov    (%esi),%eax
8010323e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103244:	8b 06                	mov    (%esi),%eax
80103246:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010324a:	8b 06                	mov    (%esi),%eax
8010324c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103250:	8b 06                	mov    (%esi),%eax
80103252:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103255:	8b 03                	mov    (%ebx),%eax
80103257:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010325d:	8b 03                	mov    (%ebx),%eax
8010325f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103263:	8b 03                	mov    (%ebx),%eax
80103265:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103269:	8b 03                	mov    (%ebx),%eax
  return 0;
8010326b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010326d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103270:	83 c4 1c             	add    $0x1c,%esp
80103273:	89 d8                	mov    %ebx,%eax
80103275:	5b                   	pop    %ebx
80103276:	5e                   	pop    %esi
80103277:	5f                   	pop    %edi
80103278:	5d                   	pop    %ebp
80103279:	c3                   	ret    
8010327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103280:	8b 06                	mov    (%esi),%eax
80103282:	85 c0                	test   %eax,%eax
80103284:	74 08                	je     8010328e <pipealloc+0xce>
    fileclose(*f0);
80103286:	89 04 24             	mov    %eax,(%esp)
80103289:	e8 e2 db ff ff       	call   80100e70 <fileclose>
  if(*f1)
8010328e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103290:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103295:	85 c0                	test   %eax,%eax
80103297:	74 d7                	je     80103270 <pipealloc+0xb0>
    fileclose(*f1);
80103299:	89 04 24             	mov    %eax,(%esp)
8010329c:	e8 cf db ff ff       	call   80100e70 <fileclose>
}
801032a1:	83 c4 1c             	add    $0x1c,%esp
801032a4:	89 d8                	mov    %ebx,%eax
801032a6:	5b                   	pop    %ebx
801032a7:	5e                   	pop    %esi
801032a8:	5f                   	pop    %edi
801032a9:	5d                   	pop    %ebp
801032aa:	c3                   	ret    
801032ab:	90                   	nop
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	56                   	push   %esi
801032b4:	53                   	push   %ebx
801032b5:	83 ec 10             	sub    $0x10,%esp
801032b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032be:	89 1c 24             	mov    %ebx,(%esp)
801032c1:	e8 ca 0e 00 00       	call   80104190 <acquire>
  if(writable){
801032c6:	85 f6                	test   %esi,%esi
801032c8:	74 3e                	je     80103308 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032ca:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032d0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032d7:	00 00 00 
    wakeup(&p->nread);
801032da:	89 04 24             	mov    %eax,(%esp)
801032dd:	e8 fe 0a 00 00       	call   80103de0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032e2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032e8:	85 d2                	test   %edx,%edx
801032ea:	75 0a                	jne    801032f6 <pipeclose+0x46>
801032ec:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 32                	je     80103328 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f9:	83 c4 10             	add    $0x10,%esp
801032fc:	5b                   	pop    %ebx
801032fd:	5e                   	pop    %esi
801032fe:	5d                   	pop    %ebp
    release(&p->lock);
801032ff:	e9 7c 0f 00 00       	jmp    80104280 <release>
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103308:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
8010330e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103315:	00 00 00 
    wakeup(&p->nwrite);
80103318:	89 04 24             	mov    %eax,(%esp)
8010331b:	e8 c0 0a 00 00       	call   80103de0 <wakeup>
80103320:	eb c0                	jmp    801032e2 <pipeclose+0x32>
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103328:	89 1c 24             	mov    %ebx,(%esp)
8010332b:	e8 50 0f 00 00       	call   80104280 <release>
    kfree((char*)p);
80103330:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103333:	83 c4 10             	add    $0x10,%esp
80103336:	5b                   	pop    %ebx
80103337:	5e                   	pop    %esi
80103338:	5d                   	pop    %ebp
    kfree((char*)p);
80103339:	e9 02 f0 ff ff       	jmp    80102340 <kfree>
8010333e:	66 90                	xchg   %ax,%ax

80103340 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 1c             	sub    $0x1c,%esp
80103349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010334c:	89 1c 24             	mov    %ebx,(%esp)
8010334f:	e8 3c 0e 00 00       	call   80104190 <acquire>
  for(i = 0; i < n; i++){
80103354:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103357:	85 c9                	test   %ecx,%ecx
80103359:	0f 8e b2 00 00 00    	jle    80103411 <pipewrite+0xd1>
8010335f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103362:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103368:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010336e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103374:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103377:	03 4d 10             	add    0x10(%ebp),%ecx
8010337a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010337d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103383:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103389:	39 c8                	cmp    %ecx,%eax
8010338b:	74 38                	je     801033c5 <pipewrite+0x85>
8010338d:	eb 55                	jmp    801033e4 <pipewrite+0xa4>
8010338f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103390:	e8 5b 03 00 00       	call   801036f0 <myproc>
80103395:	8b 40 24             	mov    0x24(%eax),%eax
80103398:	85 c0                	test   %eax,%eax
8010339a:	75 33                	jne    801033cf <pipewrite+0x8f>
      wakeup(&p->nread);
8010339c:	89 3c 24             	mov    %edi,(%esp)
8010339f:	e8 3c 0a 00 00       	call   80103de0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033a8:	89 34 24             	mov    %esi,(%esp)
801033ab:	e8 a0 08 00 00       	call   80103c50 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033b0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033b6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033bc:	05 00 02 00 00       	add    $0x200,%eax
801033c1:	39 c2                	cmp    %eax,%edx
801033c3:	75 23                	jne    801033e8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033c5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cb:	85 d2                	test   %edx,%edx
801033cd:	75 c1                	jne    80103390 <pipewrite+0x50>
        release(&p->lock);
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 a9 0e 00 00       	call   80104280 <release>
        return -1;
801033d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033dc:	83 c4 1c             	add    $0x1c,%esp
801033df:	5b                   	pop    %ebx
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033e4:	89 c2                	mov    %eax,%edx
801033e6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033eb:	8d 42 01             	lea    0x1(%edx),%eax
801033ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033f4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033fe:	0f b6 09             	movzbl (%ecx),%ecx
80103401:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103405:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103408:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010340b:	0f 85 6c ff ff ff    	jne    8010337d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103411:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103417:	89 04 24             	mov    %eax,(%esp)
8010341a:	e8 c1 09 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
8010341f:	89 1c 24             	mov    %ebx,(%esp)
80103422:	e8 59 0e 00 00       	call   80104280 <release>
  return n;
80103427:	8b 45 10             	mov    0x10(%ebp),%eax
8010342a:	eb b0                	jmp    801033dc <pipewrite+0x9c>
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103430 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
80103439:	8b 75 08             	mov    0x8(%ebp),%esi
8010343c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010343f:	89 34 24             	mov    %esi,(%esp)
80103442:	e8 49 0d 00 00       	call   80104190 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103447:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010344d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103453:	75 5b                	jne    801034b0 <piperead+0x80>
80103455:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010345b:	85 db                	test   %ebx,%ebx
8010345d:	74 51                	je     801034b0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010345f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103465:	eb 25                	jmp    8010348c <piperead+0x5c>
80103467:	90                   	nop
80103468:	89 74 24 04          	mov    %esi,0x4(%esp)
8010346c:	89 1c 24             	mov    %ebx,(%esp)
8010346f:	e8 dc 07 00 00       	call   80103c50 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103474:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010347a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103480:	75 2e                	jne    801034b0 <piperead+0x80>
80103482:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103488:	85 d2                	test   %edx,%edx
8010348a:	74 24                	je     801034b0 <piperead+0x80>
    if(myproc()->killed){
8010348c:	e8 5f 02 00 00       	call   801036f0 <myproc>
80103491:	8b 48 24             	mov    0x24(%eax),%ecx
80103494:	85 c9                	test   %ecx,%ecx
80103496:	74 d0                	je     80103468 <piperead+0x38>
      release(&p->lock);
80103498:	89 34 24             	mov    %esi,(%esp)
8010349b:	e8 e0 0d 00 00       	call   80104280 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034a0:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801034a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034a8:	5b                   	pop    %ebx
801034a9:	5e                   	pop    %esi
801034aa:	5f                   	pop    %edi
801034ab:	5d                   	pop    %ebp
801034ac:	c3                   	ret    
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034b3:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b5:	85 d2                	test   %edx,%edx
801034b7:	7f 2b                	jg     801034e4 <piperead+0xb4>
801034b9:	eb 31                	jmp    801034ec <piperead+0xbc>
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034c0:	8d 48 01             	lea    0x1(%eax),%ecx
801034c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034d6:	83 c3 01             	add    $0x1,%ebx
801034d9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034dc:	74 0e                	je     801034ec <piperead+0xbc>
    if(p->nread == p->nwrite)
801034de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ea:	75 d4                	jne    801034c0 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ec:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034f2:	89 04 24             	mov    %eax,(%esp)
801034f5:	e8 e6 08 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
801034fa:	89 34 24             	mov    %esi,(%esp)
801034fd:	e8 7e 0d 00 00       	call   80104280 <release>
}
80103502:	83 c4 1c             	add    $0x1c,%esp
  return i;
80103505:	89 d8                	mov    %ebx,%eax
}
80103507:	5b                   	pop    %ebx
80103508:	5e                   	pop    %esi
80103509:	5f                   	pop    %edi
8010350a:	5d                   	pop    %ebp
8010350b:	c3                   	ret    
8010350c:	66 90                	xchg   %ax,%ax
8010350e:	66 90                	xchg   %ax,%ax

80103510 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103514:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103519:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010351c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103523:	e8 68 0c 00 00       	call   80104190 <acquire>
80103528:	eb 11                	jmp    8010353b <allocproc+0x2b>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103530:	83 eb 80             	sub    $0xffffff80,%ebx
80103533:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103539:	74 7d                	je     801035b8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010353b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	75 ee                	jne    80103530 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103542:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103547:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
8010354e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103555:	8d 50 01             	lea    0x1(%eax),%edx
80103558:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010355e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103561:	e8 1a 0d 00 00       	call   80104280 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103566:	e8 85 ef ff ff       	call   801024f0 <kalloc>
8010356b:	85 c0                	test   %eax,%eax
8010356d:	89 43 08             	mov    %eax,0x8(%ebx)
80103570:	74 5a                	je     801035cc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103572:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103578:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010357d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103580:	c7 40 14 95 54 10 80 	movl   $0x80105495,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103587:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010358e:	00 
8010358f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103596:	00 
80103597:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010359a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010359d:	e8 2e 0d 00 00       	call   801042d0 <memset>
  p->context->eip = (uint)forkret;
801035a2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035a5:	c7 40 10 e0 35 10 80 	movl   $0x801035e0,0x10(%eax)

  return p;
801035ac:	89 d8                	mov    %ebx,%eax
}
801035ae:	83 c4 14             	add    $0x14,%esp
801035b1:	5b                   	pop    %ebx
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801035b8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bf:	e8 bc 0c 00 00       	call   80104280 <release>
}
801035c4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035c7:	31 c0                	xor    %eax,%eax
}
801035c9:	5b                   	pop    %ebx
801035ca:	5d                   	pop    %ebp
801035cb:	c3                   	ret    
    p->state = UNUSED;
801035cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035d3:	eb d9                	jmp    801035ae <allocproc+0x9e>
801035d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035e6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035ed:	e8 8e 0c 00 00       	call   80104280 <release>

  if (first) {
801035f2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	75 05                	jne    80103600 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035fb:	c9                   	leave  
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
80103600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103607:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010360e:	00 00 00 
    iinit(ROOTDEV);
80103611:	e8 aa de ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103616:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010361d:	e8 9e f4 ff ff       	call   80102ac0 <initlog>
}
80103622:	c9                   	leave  
80103623:	c3                   	ret    
80103624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010362a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103630 <pinit>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103636:	c7 44 24 04 d5 73 10 	movl   $0x801073d5,0x4(%esp)
8010363d:	80 
8010363e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103645:	e8 56 0a 00 00       	call   801040a0 <initlock>
}
8010364a:	c9                   	leave  
8010364b:	c3                   	ret    
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103650 <mycpu>:
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	56                   	push   %esi
80103654:	53                   	push   %ebx
80103655:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103658:	9c                   	pushf  
80103659:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010365a:	f6 c4 02             	test   $0x2,%ah
8010365d:	75 57                	jne    801036b6 <mycpu+0x66>
  apicid = lapicid();
8010365f:	e8 4c f1 ff ff       	call   801027b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103664:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010366a:	85 f6                	test   %esi,%esi
8010366c:	7e 3c                	jle    801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010366e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103675:	39 c2                	cmp    %eax,%edx
80103677:	74 2d                	je     801036a6 <mycpu+0x56>
80103679:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010367e:	31 d2                	xor    %edx,%edx
80103680:	83 c2 01             	add    $0x1,%edx
80103683:	39 f2                	cmp    %esi,%edx
80103685:	74 23                	je     801036aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103687:	0f b6 19             	movzbl (%ecx),%ebx
8010368a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103690:	39 c3                	cmp    %eax,%ebx
80103692:	75 ec                	jne    80103680 <mycpu+0x30>
      return &cpus[i];
80103694:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5d                   	pop    %ebp
      return &cpus[i];
801036a0:	05 80 27 11 80       	add    $0x80112780,%eax
}
801036a5:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
801036a6:	31 d2                	xor    %edx,%edx
801036a8:	eb ea                	jmp    80103694 <mycpu+0x44>
  panic("unknown apicid\n");
801036aa:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
801036b1:	e8 aa cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036b6:	c7 04 24 b8 74 10 80 	movl   $0x801074b8,(%esp)
801036bd:	e8 9e cc ff ff       	call   80100360 <panic>
801036c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036d0 <cpuid>:
cpuid() {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036d6:	e8 75 ff ff ff       	call   80103650 <mycpu>
}
801036db:	c9                   	leave  
  return mycpu()-cpus;
801036dc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036e1:	c1 f8 04             	sar    $0x4,%eax
801036e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ea:	c3                   	ret    
801036eb:	90                   	nop
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <myproc>:
myproc(void) {
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036f7:	e8 54 0a 00 00       	call   80104150 <pushcli>
  c = mycpu();
801036fc:	e8 4f ff ff ff       	call   80103650 <mycpu>
  p = c->proc;
80103701:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103707:	e8 04 0b 00 00       	call   80104210 <popcli>
}
8010370c:	83 c4 04             	add    $0x4,%esp
8010370f:	89 d8                	mov    %ebx,%eax
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    
80103714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010371a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103720 <userinit>:
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103727:	e8 e4 fd ff ff       	call   80103510 <allocproc>
8010372c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010372e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103733:	e8 68 33 00 00       	call   80106aa0 <setupkvm>
80103738:	85 c0                	test   %eax,%eax
8010373a:	89 43 04             	mov    %eax,0x4(%ebx)
8010373d:	0f 84 d4 00 00 00    	je     80103817 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103743:	89 04 24             	mov    %eax,(%esp)
80103746:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010374d:	00 
8010374e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103755:	80 
80103756:	e8 55 30 00 00       	call   801067b0 <inituvm>
  p->sz = PGSIZE;
8010375b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103761:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103768:	00 
80103769:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103770:	00 
80103771:	8b 43 18             	mov    0x18(%ebx),%eax
80103774:	89 04 24             	mov    %eax,(%esp)
80103777:	e8 54 0b 00 00       	call   801042d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010377c:	8b 43 18             	mov    0x18(%ebx),%eax
8010377f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103784:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103789:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010378d:	8b 43 18             	mov    0x18(%ebx),%eax
80103790:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103794:	8b 43 18             	mov    0x18(%ebx),%eax
80103797:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010379b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010379f:	8b 43 18             	mov    0x18(%ebx),%eax
801037a2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037a6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037aa:	8b 43 18             	mov    0x18(%ebx),%eax
801037ad:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037b4:	8b 43 18             	mov    0x18(%ebx),%eax
801037b7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037be:	8b 43 18             	mov    0x18(%ebx),%eax
801037c1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037c8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037d2:	00 
801037d3:	c7 44 24 04 05 74 10 	movl   $0x80107405,0x4(%esp)
801037da:	80 
801037db:	89 04 24             	mov    %eax,(%esp)
801037de:	e8 cd 0c 00 00       	call   801044b0 <safestrcpy>
  p->cwd = namei("/");
801037e3:	c7 04 24 0e 74 10 80 	movl   $0x8010740e,(%esp)
801037ea:	e8 61 e7 ff ff       	call   80101f50 <namei>
801037ef:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037f2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037f9:	e8 92 09 00 00       	call   80104190 <acquire>
  p->state = RUNNABLE;
801037fe:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103805:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010380c:	e8 6f 0a 00 00       	call   80104280 <release>
}
80103811:	83 c4 14             	add    $0x14,%esp
80103814:	5b                   	pop    %ebx
80103815:	5d                   	pop    %ebp
80103816:	c3                   	ret    
    panic("userinit: out of memory?");
80103817:	c7 04 24 ec 73 10 80 	movl   $0x801073ec,(%esp)
8010381e:	e8 3d cb ff ff       	call   80100360 <panic>
80103823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <growproc>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	83 ec 10             	sub    $0x10,%esp
80103838:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010383b:	e8 b0 fe ff ff       	call   801036f0 <myproc>
  if(n > 0){
80103840:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103843:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103845:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103847:	7e 2f                	jle    80103878 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103849:	01 c6                	add    %eax,%esi
8010384b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010384f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103853:	8b 43 04             	mov    0x4(%ebx),%eax
80103856:	89 04 24             	mov    %eax,(%esp)
80103859:	e8 a2 30 00 00       	call   80106900 <allocuvm>
8010385e:	85 c0                	test   %eax,%eax
80103860:	74 36                	je     80103898 <growproc+0x68>
  curproc->sz = sz;
80103862:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103864:	89 1c 24             	mov    %ebx,(%esp)
80103867:	e8 34 2e 00 00       	call   801066a0 <switchuvm>
  return 0;
8010386c:	31 c0                	xor    %eax,%eax
}
8010386e:	83 c4 10             	add    $0x10,%esp
80103871:	5b                   	pop    %ebx
80103872:	5e                   	pop    %esi
80103873:	5d                   	pop    %ebp
80103874:	c3                   	ret    
80103875:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103878:	74 e8                	je     80103862 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010387a:	01 c6                	add    %eax,%esi
8010387c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103880:	89 44 24 04          	mov    %eax,0x4(%esp)
80103884:	8b 43 04             	mov    0x4(%ebx),%eax
80103887:	89 04 24             	mov    %eax,(%esp)
8010388a:	e8 71 31 00 00       	call   80106a00 <deallocuvm>
8010388f:	85 c0                	test   %eax,%eax
80103891:	75 cf                	jne    80103862 <growproc+0x32>
80103893:	90                   	nop
80103894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010389d:	eb cf                	jmp    8010386e <growproc+0x3e>
8010389f:	90                   	nop

801038a0 <fork>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801038a9:	e8 42 fe ff ff       	call   801036f0 <myproc>
801038ae:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038b0:	e8 5b fc ff ff       	call   80103510 <allocproc>
801038b5:	85 c0                	test   %eax,%eax
801038b7:	89 c7                	mov    %eax,%edi
801038b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038bc:	0f 84 bc 00 00 00    	je     8010397e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038c2:	8b 03                	mov    (%ebx),%eax
801038c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c8:	8b 43 04             	mov    0x4(%ebx),%eax
801038cb:	89 04 24             	mov    %eax,(%esp)
801038ce:	e8 ad 32 00 00       	call   80106b80 <copyuvm>
801038d3:	85 c0                	test   %eax,%eax
801038d5:	89 47 04             	mov    %eax,0x4(%edi)
801038d8:	0f 84 a7 00 00 00    	je     80103985 <fork+0xe5>
  np->sz = curproc->sz;
801038de:	8b 03                	mov    (%ebx),%eax
801038e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038e3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038e5:	8b 79 18             	mov    0x18(%ecx),%edi
801038e8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038ea:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038ed:	8b 73 18             	mov    0x18(%ebx),%esi
801038f0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038f7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038f9:	8b 40 18             	mov    0x18(%eax),%eax
801038fc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103903:	90                   	nop
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103908:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010390c:	85 c0                	test   %eax,%eax
8010390e:	74 0f                	je     8010391f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103910:	89 04 24             	mov    %eax,(%esp)
80103913:	e8 08 d5 ff ff       	call   80100e20 <filedup>
80103918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010391b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010391f:	83 c6 01             	add    $0x1,%esi
80103922:	83 fe 10             	cmp    $0x10,%esi
80103925:	75 e1                	jne    80103908 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103927:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010392a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010392d:	89 04 24             	mov    %eax,(%esp)
80103930:	e8 9b dd ff ff       	call   801016d0 <idup>
80103935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103938:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010393b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010393e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103942:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103949:	00 
8010394a:	89 04 24             	mov    %eax,(%esp)
8010394d:	e8 5e 0b 00 00       	call   801044b0 <safestrcpy>
  pid = np->pid;
80103952:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103955:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010395c:	e8 2f 08 00 00       	call   80104190 <acquire>
  np->state = RUNNABLE;
80103961:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103968:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010396f:	e8 0c 09 00 00       	call   80104280 <release>
  return pid;
80103974:	89 d8                	mov    %ebx,%eax
}
80103976:	83 c4 1c             	add    $0x1c,%esp
80103979:	5b                   	pop    %ebx
8010397a:	5e                   	pop    %esi
8010397b:	5f                   	pop    %edi
8010397c:	5d                   	pop    %ebp
8010397d:	c3                   	ret    
    return -1;
8010397e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103983:	eb f1                	jmp    80103976 <fork+0xd6>
    kfree(np->kstack);
80103985:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103988:	8b 47 08             	mov    0x8(%edi),%eax
8010398b:	89 04 24             	mov    %eax,(%esp)
8010398e:	e8 ad e9 ff ff       	call   80102340 <kfree>
    return -1;
80103993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103998:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010399f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039a6:	eb ce                	jmp    80103976 <fork+0xd6>
801039a8:	90                   	nop
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <scheduler>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801039b9:	e8 92 fc ff ff       	call   80103650 <mycpu>
801039be:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039c0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039c7:	00 00 00 
801039ca:	8d 78 04             	lea    0x4(%eax),%edi
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039d0:	fb                   	sti    
    acquire(&ptable.lock);
801039d1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039dd:	e8 ae 07 00 00       	call   80104190 <acquire>
801039e2:	eb 0f                	jmp    801039f3 <scheduler+0x43>
801039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e8:	83 eb 80             	sub    $0xffffff80,%ebx
801039eb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039f1:	74 45                	je     80103a38 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039f3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039f7:	75 ef                	jne    801039e8 <scheduler+0x38>
      c->proc = p;
801039f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039ff:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a02:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
80103a05:	e8 96 2c 00 00       	call   801066a0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a0a:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
80103a0d:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
80103a14:	89 3c 24             	mov    %edi,(%esp)
80103a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a1b:	e8 eb 0a 00 00       	call   8010450b <swtch>
      switchkvm();
80103a20:	e8 5b 2c 00 00       	call   80106680 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a25:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
80103a2b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a32:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a35:	75 bc                	jne    801039f3 <scheduler+0x43>
80103a37:	90                   	nop
    release(&ptable.lock);
80103a38:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a3f:	e8 3c 08 00 00       	call   80104280 <release>
  }
80103a44:	eb 8a                	jmp    801039d0 <scheduler+0x20>
80103a46:	8d 76 00             	lea    0x0(%esi),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <sched>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a58:	e8 93 fc ff ff       	call   801036f0 <myproc>
  if(!holding(&ptable.lock))
80103a5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a64:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a66:	e8 b5 06 00 00       	call   80104120 <holding>
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	74 4f                	je     80103abe <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a6f:	e8 dc fb ff ff       	call   80103650 <mycpu>
80103a74:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a7b:	75 65                	jne    80103ae2 <sched+0x92>
  if(p->state == RUNNING)
80103a7d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a81:	74 53                	je     80103ad6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a83:	9c                   	pushf  
80103a84:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a85:	f6 c4 02             	test   $0x2,%ah
80103a88:	75 40                	jne    80103aca <sched+0x7a>
  intena = mycpu()->intena;
80103a8a:	e8 c1 fb ff ff       	call   80103650 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a8f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a92:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a98:	e8 b3 fb ff ff       	call   80103650 <mycpu>
80103a9d:	8b 40 04             	mov    0x4(%eax),%eax
80103aa0:	89 1c 24             	mov    %ebx,(%esp)
80103aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aa7:	e8 5f 0a 00 00       	call   8010450b <swtch>
  mycpu()->intena = intena;
80103aac:	e8 9f fb ff ff       	call   80103650 <mycpu>
80103ab1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ab7:	83 c4 10             	add    $0x10,%esp
80103aba:	5b                   	pop    %ebx
80103abb:	5e                   	pop    %esi
80103abc:	5d                   	pop    %ebp
80103abd:	c3                   	ret    
    panic("sched ptable.lock");
80103abe:	c7 04 24 10 74 10 80 	movl   $0x80107410,(%esp)
80103ac5:	e8 96 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103aca:	c7 04 24 3c 74 10 80 	movl   $0x8010743c,(%esp)
80103ad1:	e8 8a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103ad6:	c7 04 24 2e 74 10 80 	movl   $0x8010742e,(%esp)
80103add:	e8 7e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ae2:	c7 04 24 22 74 10 80 	movl   $0x80107422,(%esp)
80103ae9:	e8 72 c8 ff ff       	call   80100360 <panic>
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <exit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
  if(curproc == initproc)
80103af4:	31 f6                	xor    %esi,%esi
{
80103af6:	53                   	push   %ebx
80103af7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103afa:	e8 f1 fb ff ff       	call   801036f0 <myproc>
  if(curproc == initproc)
80103aff:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b05:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b07:	0f 84 ea 00 00 00    	je     80103bf7 <exit+0x107>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b14:	85 c0                	test   %eax,%eax
80103b16:	74 10                	je     80103b28 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b18:	89 04 24             	mov    %eax,(%esp)
80103b1b:	e8 50 d3 ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
80103b20:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b27:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b28:	83 c6 01             	add    $0x1,%esi
80103b2b:	83 fe 10             	cmp    $0x10,%esi
80103b2e:	75 e0                	jne    80103b10 <exit+0x20>
  begin_op();
80103b30:	e8 2b f0 ff ff       	call   80102b60 <begin_op>
  iput(curproc->cwd);
80103b35:	8b 43 68             	mov    0x68(%ebx),%eax
80103b38:	89 04 24             	mov    %eax,(%esp)
80103b3b:	e8 e0 dc ff ff       	call   80101820 <iput>
  end_op();
80103b40:	e8 8b f0 ff ff       	call   80102bd0 <end_op>
  curproc->cwd = 0;
80103b45:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b53:	e8 38 06 00 00       	call   80104190 <acquire>
  wakeup1(curproc->parent);
80103b58:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b5b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b60:	eb 11                	jmp    80103b73 <exit+0x83>
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b68:	83 ea 80             	sub    $0xffffff80,%edx
80103b6b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b71:	74 1d                	je     80103b90 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b73:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b77:	75 ef                	jne    80103b68 <exit+0x78>
80103b79:	3b 42 20             	cmp    0x20(%edx),%eax
80103b7c:	75 ea                	jne    80103b68 <exit+0x78>
      p->state = RUNNABLE;
80103b7e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b85:	83 ea 80             	sub    $0xffffff80,%edx
80103b88:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b8e:	75 e3                	jne    80103b73 <exit+0x83>
      p->parent = initproc;
80103b90:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b95:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b9a:	eb 0f                	jmp    80103bab <exit+0xbb>
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba0:	83 e9 80             	sub    $0xffffff80,%ecx
80103ba3:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103ba9:	74 34                	je     80103bdf <exit+0xef>
    if(p->parent == curproc){
80103bab:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103bae:	75 f0                	jne    80103ba0 <exit+0xb0>
      if(p->state == ZOMBIE)
80103bb0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103bb4:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103bb7:	75 e7                	jne    80103ba0 <exit+0xb0>
80103bb9:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bbe:	eb 0b                	jmp    80103bcb <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bc0:	83 ea 80             	sub    $0xffffff80,%edx
80103bc3:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103bc9:	74 d5                	je     80103ba0 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bcb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bcf:	75 ef                	jne    80103bc0 <exit+0xd0>
80103bd1:	3b 42 20             	cmp    0x20(%edx),%eax
80103bd4:	75 ea                	jne    80103bc0 <exit+0xd0>
      p->state = RUNNABLE;
80103bd6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bdd:	eb e1                	jmp    80103bc0 <exit+0xd0>
  curproc->state = ZOMBIE;
80103bdf:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103be6:	e8 65 fe ff ff       	call   80103a50 <sched>
  panic("zombie exit");
80103beb:	c7 04 24 5d 74 10 80 	movl   $0x8010745d,(%esp)
80103bf2:	e8 69 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bf7:	c7 04 24 50 74 10 80 	movl   $0x80107450,(%esp)
80103bfe:	e8 5d c7 ff ff       	call   80100360 <panic>
80103c03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <yield>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c16:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c1d:	e8 6e 05 00 00       	call   80104190 <acquire>
  myproc()->state = RUNNABLE;
80103c22:	e8 c9 fa ff ff       	call   801036f0 <myproc>
80103c27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c2e:	e8 1d fe ff ff       	call   80103a50 <sched>
  release(&ptable.lock);
80103c33:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c3a:	e8 41 06 00 00       	call   80104280 <release>
}
80103c3f:	c9                   	leave  
80103c40:	c3                   	ret    
80103c41:	eb 0d                	jmp    80103c50 <sleep>
80103c43:	90                   	nop
80103c44:	90                   	nop
80103c45:	90                   	nop
80103c46:	90                   	nop
80103c47:	90                   	nop
80103c48:	90                   	nop
80103c49:	90                   	nop
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	90                   	nop
80103c4d:	90                   	nop
80103c4e:	90                   	nop
80103c4f:	90                   	nop

80103c50 <sleep>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
80103c59:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c5f:	e8 8c fa ff ff       	call   801036f0 <myproc>
  if(p == 0)
80103c64:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c66:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c68:	0f 84 7c 00 00 00    	je     80103cea <sleep+0x9a>
  if(lk == 0)
80103c6e:	85 f6                	test   %esi,%esi
80103c70:	74 6c                	je     80103cde <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c72:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c78:	74 46                	je     80103cc0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c7a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c81:	e8 0a 05 00 00       	call   80104190 <acquire>
    release(lk);
80103c86:	89 34 24             	mov    %esi,(%esp)
80103c89:	e8 f2 05 00 00       	call   80104280 <release>
  p->chan = chan;
80103c8e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c91:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c98:	e8 b3 fd ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103c9d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ca4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cab:	e8 d0 05 00 00       	call   80104280 <release>
    acquire(lk);
80103cb0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103cb3:	83 c4 1c             	add    $0x1c,%esp
80103cb6:	5b                   	pop    %ebx
80103cb7:	5e                   	pop    %esi
80103cb8:	5f                   	pop    %edi
80103cb9:	5d                   	pop    %ebp
    acquire(lk);
80103cba:	e9 d1 04 00 00       	jmp    80104190 <acquire>
80103cbf:	90                   	nop
  p->chan = chan;
80103cc0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cc3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103cca:	e8 81 fd ff ff       	call   80103a50 <sched>
  p->chan = 0;
80103ccf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103cd6:	83 c4 1c             	add    $0x1c,%esp
80103cd9:	5b                   	pop    %ebx
80103cda:	5e                   	pop    %esi
80103cdb:	5f                   	pop    %edi
80103cdc:	5d                   	pop    %ebp
80103cdd:	c3                   	ret    
    panic("sleep without lk");
80103cde:	c7 04 24 6f 74 10 80 	movl   $0x8010746f,(%esp)
80103ce5:	e8 76 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103cea:	c7 04 24 69 74 10 80 	movl   $0x80107469,(%esp)
80103cf1:	e8 6a c6 ff ff       	call   80100360 <panic>
80103cf6:	8d 76 00             	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <wait>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103d08:	e8 e3 f9 ff ff       	call   801036f0 <myproc>
  acquire(&ptable.lock);
80103d0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103d14:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d16:	e8 75 04 00 00       	call   80104190 <acquire>
    havekids = 0;
80103d1b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d22:	eb 0f                	jmp    80103d33 <wait+0x33>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	83 eb 80             	sub    $0xffffff80,%ebx
80103d2b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d31:	74 1d                	je     80103d50 <wait+0x50>
      if(p->parent != curproc)
80103d33:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d36:	75 f0                	jne    80103d28 <wait+0x28>
      if(p->state == ZOMBIE){
80103d38:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d3c:	74 2f                	je     80103d6d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d3e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103d41:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d46:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d4c:	75 e5                	jne    80103d33 <wait+0x33>
80103d4e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103d50:	85 c0                	test   %eax,%eax
80103d52:	74 6e                	je     80103dc2 <wait+0xc2>
80103d54:	8b 46 24             	mov    0x24(%esi),%eax
80103d57:	85 c0                	test   %eax,%eax
80103d59:	75 67                	jne    80103dc2 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d5b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d62:	80 
80103d63:	89 34 24             	mov    %esi,(%esp)
80103d66:	e8 e5 fe ff ff       	call   80103c50 <sleep>
  }
80103d6b:	eb ae                	jmp    80103d1b <wait+0x1b>
        kfree(p->kstack);
80103d6d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d70:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d73:	89 04 24             	mov    %eax,(%esp)
80103d76:	e8 c5 e5 ff ff       	call   80102340 <kfree>
        freevm(p->pgdir);
80103d7b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 93 2c 00 00       	call   80106a20 <freevm>
        release(&ptable.lock);
80103d8d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d94:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d9b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103da2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103da6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103dad:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103db4:	e8 c7 04 00 00       	call   80104280 <release>
}
80103db9:	83 c4 10             	add    $0x10,%esp
        return pid;
80103dbc:	89 f0                	mov    %esi,%eax
}
80103dbe:	5b                   	pop    %ebx
80103dbf:	5e                   	pop    %esi
80103dc0:	5d                   	pop    %ebp
80103dc1:	c3                   	ret    
      release(&ptable.lock);
80103dc2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc9:	e8 b2 04 00 00       	call   80104280 <release>
}
80103dce:	83 c4 10             	add    $0x10,%esp
      return -1;
80103dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dd6:	5b                   	pop    %ebx
80103dd7:	5e                   	pop    %esi
80103dd8:	5d                   	pop    %ebp
80103dd9:	c3                   	ret    
80103dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103de0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df1:	e8 9a 03 00 00       	call   80104190 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfb:	eb 0d                	jmp    80103e0a <wakeup+0x2a>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	83 e8 80             	sub    $0xffffff80,%eax
80103e03:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e08:	74 1e                	je     80103e28 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e0e:	75 f0                	jne    80103e00 <wakeup+0x20>
80103e10:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e13:	75 eb                	jne    80103e00 <wakeup+0x20>
      p->state = RUNNABLE;
80103e15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1c:	83 e8 80             	sub    $0xffffff80,%eax
80103e1f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e24:	75 e4                	jne    80103e0a <wakeup+0x2a>
80103e26:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103e28:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e2f:	83 c4 14             	add    $0x14,%esp
80103e32:	5b                   	pop    %ebx
80103e33:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e34:	e9 47 04 00 00       	jmp    80104280 <release>
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 14             	sub    $0x14,%esp
80103e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e51:	e8 3a 03 00 00       	call   80104190 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e56:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5b:	eb 0d                	jmp    80103e6a <kill+0x2a>
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
80103e60:	83 e8 80             	sub    $0xffffff80,%eax
80103e63:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e68:	74 36                	je     80103ea0 <kill+0x60>
    if(p->pid == pid){
80103e6a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e6d:	75 f1                	jne    80103e60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e6f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e7a:	74 14                	je     80103e90 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e83:	e8 f8 03 00 00       	call   80104280 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e88:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e8b:	31 c0                	xor    %eax,%eax
}
80103e8d:	5b                   	pop    %ebx
80103e8e:	5d                   	pop    %ebp
80103e8f:	c3                   	ret    
        p->state = RUNNABLE;
80103e90:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e97:	eb e3                	jmp    80103e7c <kill+0x3c>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ea0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ea7:	e8 d4 03 00 00       	call   80104280 <release>
}
80103eac:	83 c4 14             	add    $0x14,%esp
  return -1;
80103eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103eb4:	5b                   	pop    %ebx
80103eb5:	5d                   	pop    %ebp
80103eb6:	c3                   	ret    
80103eb7:	89 f6                	mov    %esi,%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103ecb:	83 ec 4c             	sub    $0x4c,%esp
80103ece:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ed1:	eb 20                	jmp    80103ef3 <procdump+0x33>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ed8:	c7 04 24 67 78 10 80 	movl   $0x80107867,(%esp)
80103edf:	e8 6c c7 ff ff       	call   80100650 <cprintf>
80103ee4:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee7:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103eed:	0f 84 8d 00 00 00    	je     80103f80 <procdump+0xc0>
    if(p->state == UNUSED)
80103ef3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ef6:	85 c0                	test   %eax,%eax
80103ef8:	74 ea                	je     80103ee4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103efa:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103efd:	ba 80 74 10 80       	mov    $0x80107480,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f02:	77 11                	ja     80103f15 <procdump+0x55>
80103f04:	8b 14 85 e0 74 10 80 	mov    -0x7fef8b20(,%eax,4),%edx
      state = "???";
80103f0b:	b8 80 74 10 80       	mov    $0x80107480,%eax
80103f10:	85 d2                	test   %edx,%edx
80103f12:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f15:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f18:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f1c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f20:	c7 04 24 84 74 10 80 	movl   $0x80107484,(%esp)
80103f27:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f2b:	e8 20 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f30:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f34:	75 a2                	jne    80103ed8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f36:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f39:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f40:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f43:	8b 40 0c             	mov    0xc(%eax),%eax
80103f46:	83 c0 08             	add    $0x8,%eax
80103f49:	89 04 24             	mov    %eax,(%esp)
80103f4c:	e8 6f 01 00 00       	call   801040c0 <getcallerpcs>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f58:	8b 17                	mov    (%edi),%edx
80103f5a:	85 d2                	test   %edx,%edx
80103f5c:	0f 84 76 ff ff ff    	je     80103ed8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f62:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f66:	83 c7 04             	add    $0x4,%edi
80103f69:	c7 04 24 c1 6e 10 80 	movl   $0x80106ec1,(%esp)
80103f70:	e8 db c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f75:	39 f7                	cmp    %esi,%edi
80103f77:	75 df                	jne    80103f58 <procdump+0x98>
80103f79:	e9 5a ff ff ff       	jmp    80103ed8 <procdump+0x18>
80103f7e:	66 90                	xchg   %ax,%ax
  }
}
80103f80:	83 c4 4c             	add    $0x4c,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5e                   	pop    %esi
80103f85:	5f                   	pop    %edi
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    
80103f88:	66 90                	xchg   %ax,%ax
80103f8a:	66 90                	xchg   %ax,%ax
80103f8c:	66 90                	xchg   %ax,%ax
80103f8e:	66 90                	xchg   %ax,%ax

80103f90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 14             	sub    $0x14,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f9a:	c7 44 24 04 f8 74 10 	movl   $0x801074f8,0x4(%esp)
80103fa1:	80 
80103fa2:	8d 43 04             	lea    0x4(%ebx),%eax
80103fa5:	89 04 24             	mov    %eax,(%esp)
80103fa8:	e8 f3 00 00 00       	call   801040a0 <initlock>
  lk->name = name;
80103fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fb0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fb6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103fbd:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103fc0:	83 c4 14             	add    $0x14,%esp
80103fc3:	5b                   	pop    %ebx
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
80103fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fde:	89 34 24             	mov    %esi,(%esp)
80103fe1:	e8 aa 01 00 00       	call   80104190 <acquire>
  while (lk->locked) {
80103fe6:	8b 13                	mov    (%ebx),%edx
80103fe8:	85 d2                	test   %edx,%edx
80103fea:	74 16                	je     80104002 <acquiresleep+0x32>
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103ff0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103ff4:	89 1c 24             	mov    %ebx,(%esp)
80103ff7:	e8 54 fc ff ff       	call   80103c50 <sleep>
  while (lk->locked) {
80103ffc:	8b 03                	mov    (%ebx),%eax
80103ffe:	85 c0                	test   %eax,%eax
80104000:	75 ee                	jne    80103ff0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104002:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104008:	e8 e3 f6 ff ff       	call   801036f0 <myproc>
8010400d:	8b 40 10             	mov    0x10(%eax),%eax
80104010:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104013:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104016:	83 c4 10             	add    $0x10,%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
  release(&lk->lk);
8010401c:	e9 5f 02 00 00       	jmp    80104280 <release>
80104021:	eb 0d                	jmp    80104030 <releasesleep>
80104023:	90                   	nop
80104024:	90                   	nop
80104025:	90                   	nop
80104026:	90                   	nop
80104027:	90                   	nop
80104028:	90                   	nop
80104029:	90                   	nop
8010402a:	90                   	nop
8010402b:	90                   	nop
8010402c:	90                   	nop
8010402d:	90                   	nop
8010402e:	90                   	nop
8010402f:	90                   	nop

80104030 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	83 ec 10             	sub    $0x10,%esp
80104038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010403b:	8d 73 04             	lea    0x4(%ebx),%esi
8010403e:	89 34 24             	mov    %esi,(%esp)
80104041:	e8 4a 01 00 00       	call   80104190 <acquire>
  lk->locked = 0;
80104046:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010404c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104053:	89 1c 24             	mov    %ebx,(%esp)
80104056:	e8 85 fd ff ff       	call   80103de0 <wakeup>
  release(&lk->lk);
8010405b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010405e:	83 c4 10             	add    $0x10,%esp
80104061:	5b                   	pop    %ebx
80104062:	5e                   	pop    %esi
80104063:	5d                   	pop    %ebp
  release(&lk->lk);
80104064:	e9 17 02 00 00       	jmp    80104280 <release>
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	56                   	push   %esi
80104074:	53                   	push   %ebx
80104075:	83 ec 10             	sub    $0x10,%esp
80104078:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010407b:	8d 73 04             	lea    0x4(%ebx),%esi
8010407e:	89 34 24             	mov    %esi,(%esp)
80104081:	e8 0a 01 00 00       	call   80104190 <acquire>
  r = lk->locked;
80104086:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104088:	89 34 24             	mov    %esi,(%esp)
8010408b:	e8 f0 01 00 00       	call   80104280 <release>
  return r;
}
80104090:	83 c4 10             	add    $0x10,%esp
80104093:	89 d8                	mov    %ebx,%eax
80104095:	5b                   	pop    %ebx
80104096:	5e                   	pop    %esi
80104097:	5d                   	pop    %ebp
80104098:	c3                   	ret    
80104099:	66 90                	xchg   %ax,%ax
8010409b:	66 90                	xchg   %ax,%ax
8010409d:	66 90                	xchg   %ax,%ax
8010409f:	90                   	nop

801040a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801040af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801040b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040b9:	5d                   	pop    %ebp
801040ba:	c3                   	ret    
801040bb:	90                   	nop
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040c3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801040c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040c9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801040ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040cd:	31 c0                	xor    %eax,%eax
801040cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040dc:	77 1a                	ja     801040f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040de:	8b 5a 04             	mov    0x4(%edx),%ebx
801040e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040e9:	83 f8 0a             	cmp    $0xa,%eax
801040ec:	75 e2                	jne    801040d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040ee:	5b                   	pop    %ebx
801040ef:	5d                   	pop    %ebp
801040f0:	c3                   	ret    
801040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801040f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ff:	83 c0 01             	add    $0x1,%eax
80104102:	83 f8 0a             	cmp    $0xa,%eax
80104105:	74 e7                	je     801040ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104107:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010410e:	83 c0 01             	add    $0x1,%eax
80104111:	83 f8 0a             	cmp    $0xa,%eax
80104114:	75 e2                	jne    801040f8 <getcallerpcs+0x38>
80104116:	eb d6                	jmp    801040ee <getcallerpcs+0x2e>
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104120:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104121:	31 c0                	xor    %eax,%eax
{
80104123:	89 e5                	mov    %esp,%ebp
80104125:	53                   	push   %ebx
80104126:	83 ec 04             	sub    $0x4,%esp
80104129:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010412c:	8b 0a                	mov    (%edx),%ecx
8010412e:	85 c9                	test   %ecx,%ecx
80104130:	74 10                	je     80104142 <holding+0x22>
80104132:	8b 5a 08             	mov    0x8(%edx),%ebx
80104135:	e8 16 f5 ff ff       	call   80103650 <mycpu>
8010413a:	39 c3                	cmp    %eax,%ebx
8010413c:	0f 94 c0             	sete   %al
8010413f:	0f b6 c0             	movzbl %al,%eax
}
80104142:	83 c4 04             	add    $0x4,%esp
80104145:	5b                   	pop    %ebx
80104146:	5d                   	pop    %ebp
80104147:	c3                   	ret    
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 04             	sub    $0x4,%esp
80104157:	9c                   	pushf  
80104158:	5b                   	pop    %ebx
  asm volatile("cli");
80104159:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010415a:	e8 f1 f4 ff ff       	call   80103650 <mycpu>
8010415f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104165:	85 c0                	test   %eax,%eax
80104167:	75 11                	jne    8010417a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104169:	e8 e2 f4 ff ff       	call   80103650 <mycpu>
8010416e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104174:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010417a:	e8 d1 f4 ff ff       	call   80103650 <mycpu>
8010417f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104186:	83 c4 04             	add    $0x4,%esp
80104189:	5b                   	pop    %ebx
8010418a:	5d                   	pop    %ebp
8010418b:	c3                   	ret    
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <acquire>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104197:	e8 b4 ff ff ff       	call   80104150 <pushcli>
  if(holding(lk))
8010419c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010419f:	8b 02                	mov    (%edx),%eax
801041a1:	85 c0                	test   %eax,%eax
801041a3:	75 43                	jne    801041e8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
801041a5:	b9 01 00 00 00       	mov    $0x1,%ecx
801041aa:	eb 07                	jmp    801041b3 <acquire+0x23>
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b0:	8b 55 08             	mov    0x8(%ebp),%edx
801041b3:	89 c8                	mov    %ecx,%eax
801041b5:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801041b8:	85 c0                	test   %eax,%eax
801041ba:	75 f4                	jne    801041b0 <acquire+0x20>
  __sync_synchronize();
801041bc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801041bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041c2:	e8 89 f4 ff ff       	call   80103650 <mycpu>
801041c7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
801041cd:	83 c0 0c             	add    $0xc,%eax
801041d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041d4:	8d 45 08             	lea    0x8(%ebp),%eax
801041d7:	89 04 24             	mov    %eax,(%esp)
801041da:	e8 e1 fe ff ff       	call   801040c0 <getcallerpcs>
}
801041df:	83 c4 14             	add    $0x14,%esp
801041e2:	5b                   	pop    %ebx
801041e3:	5d                   	pop    %ebp
801041e4:	c3                   	ret    
801041e5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041e8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041eb:	e8 60 f4 ff ff       	call   80103650 <mycpu>
  if(holding(lk))
801041f0:	39 c3                	cmp    %eax,%ebx
801041f2:	74 05                	je     801041f9 <acquire+0x69>
801041f4:	8b 55 08             	mov    0x8(%ebp),%edx
801041f7:	eb ac                	jmp    801041a5 <acquire+0x15>
    panic("acquire");
801041f9:	c7 04 24 03 75 10 80 	movl   $0x80107503,(%esp)
80104200:	e8 5b c1 ff ff       	call   80100360 <panic>
80104205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <popcli>:

void
popcli(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104216:	9c                   	pushf  
80104217:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104218:	f6 c4 02             	test   $0x2,%ah
8010421b:	75 49                	jne    80104266 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010421d:	e8 2e f4 ff ff       	call   80103650 <mycpu>
80104222:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104228:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010422b:	85 d2                	test   %edx,%edx
8010422d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104233:	78 25                	js     8010425a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104235:	e8 16 f4 ff ff       	call   80103650 <mycpu>
8010423a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104240:	85 d2                	test   %edx,%edx
80104242:	74 04                	je     80104248 <popcli+0x38>
    sti();
}
80104244:	c9                   	leave  
80104245:	c3                   	ret    
80104246:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104248:	e8 03 f4 ff ff       	call   80103650 <mycpu>
8010424d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104253:	85 c0                	test   %eax,%eax
80104255:	74 ed                	je     80104244 <popcli+0x34>
  asm volatile("sti");
80104257:	fb                   	sti    
}
80104258:	c9                   	leave  
80104259:	c3                   	ret    
    panic("popcli");
8010425a:	c7 04 24 22 75 10 80 	movl   $0x80107522,(%esp)
80104261:	e8 fa c0 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104266:	c7 04 24 0b 75 10 80 	movl   $0x8010750b,(%esp)
8010426d:	e8 ee c0 ff ff       	call   80100360 <panic>
80104272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104280 <release>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
80104285:	83 ec 10             	sub    $0x10,%esp
80104288:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010428b:	8b 03                	mov    (%ebx),%eax
8010428d:	85 c0                	test   %eax,%eax
8010428f:	75 0f                	jne    801042a0 <release+0x20>
    panic("release");
80104291:	c7 04 24 29 75 10 80 	movl   $0x80107529,(%esp)
80104298:	e8 c3 c0 ff ff       	call   80100360 <panic>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801042a0:	8b 73 08             	mov    0x8(%ebx),%esi
801042a3:	e8 a8 f3 ff ff       	call   80103650 <mycpu>
  if(!holding(lk))
801042a8:	39 c6                	cmp    %eax,%esi
801042aa:	75 e5                	jne    80104291 <release+0x11>
  lk->pcs[0] = 0;
801042ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801042ba:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801042c3:	83 c4 10             	add    $0x10,%esp
801042c6:	5b                   	pop    %ebx
801042c7:	5e                   	pop    %esi
801042c8:	5d                   	pop    %ebp
  popcli();
801042c9:	e9 42 ff ff ff       	jmp    80104210 <popcli>
801042ce:	66 90                	xchg   %ax,%ax

801042d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	8b 55 08             	mov    0x8(%ebp),%edx
801042d6:	57                   	push   %edi
801042d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042da:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042db:	f6 c2 03             	test   $0x3,%dl
801042de:	75 05                	jne    801042e5 <memset+0x15>
801042e0:	f6 c1 03             	test   $0x3,%cl
801042e3:	74 13                	je     801042f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042e5:	89 d7                	mov    %edx,%edi
801042e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ea:	fc                   	cld    
801042eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042ed:	5b                   	pop    %ebx
801042ee:	89 d0                	mov    %edx,%eax
801042f0:	5f                   	pop    %edi
801042f1:	5d                   	pop    %ebp
801042f2:	c3                   	ret    
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801042f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042fc:	c1 e9 02             	shr    $0x2,%ecx
801042ff:	89 f8                	mov    %edi,%eax
80104301:	89 fb                	mov    %edi,%ebx
80104303:	c1 e0 18             	shl    $0x18,%eax
80104306:	c1 e3 10             	shl    $0x10,%ebx
80104309:	09 d8                	or     %ebx,%eax
8010430b:	09 f8                	or     %edi,%eax
8010430d:	c1 e7 08             	shl    $0x8,%edi
80104310:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104312:	89 d7                	mov    %edx,%edi
80104314:	fc                   	cld    
80104315:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104317:	5b                   	pop    %ebx
80104318:	89 d0                	mov    %edx,%eax
8010431a:	5f                   	pop    %edi
8010431b:	5d                   	pop    %ebp
8010431c:	c3                   	ret    
8010431d:	8d 76 00             	lea    0x0(%esi),%esi

80104320 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	8b 45 10             	mov    0x10(%ebp),%eax
80104326:	57                   	push   %edi
80104327:	56                   	push   %esi
80104328:	8b 75 0c             	mov    0xc(%ebp),%esi
8010432b:	53                   	push   %ebx
8010432c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010432f:	85 c0                	test   %eax,%eax
80104331:	8d 78 ff             	lea    -0x1(%eax),%edi
80104334:	74 26                	je     8010435c <memcmp+0x3c>
    if(*s1 != *s2)
80104336:	0f b6 03             	movzbl (%ebx),%eax
80104339:	31 d2                	xor    %edx,%edx
8010433b:	0f b6 0e             	movzbl (%esi),%ecx
8010433e:	38 c8                	cmp    %cl,%al
80104340:	74 16                	je     80104358 <memcmp+0x38>
80104342:	eb 24                	jmp    80104368 <memcmp+0x48>
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104348:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010434d:	83 c2 01             	add    $0x1,%edx
80104350:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104354:	38 c8                	cmp    %cl,%al
80104356:	75 10                	jne    80104368 <memcmp+0x48>
  while(n-- > 0){
80104358:	39 fa                	cmp    %edi,%edx
8010435a:	75 ec                	jne    80104348 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010435c:	5b                   	pop    %ebx
  return 0;
8010435d:	31 c0                	xor    %eax,%eax
}
8010435f:	5e                   	pop    %esi
80104360:	5f                   	pop    %edi
80104361:	5d                   	pop    %ebp
80104362:	c3                   	ret    
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104368:	5b                   	pop    %ebx
      return *s1 - *s2;
80104369:	29 c8                	sub    %ecx,%eax
}
8010436b:	5e                   	pop    %esi
8010436c:	5f                   	pop    %edi
8010436d:	5d                   	pop    %ebp
8010436e:	c3                   	ret    
8010436f:	90                   	nop

80104370 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	8b 45 08             	mov    0x8(%ebp),%eax
80104377:	56                   	push   %esi
80104378:	8b 75 0c             	mov    0xc(%ebp),%esi
8010437b:	53                   	push   %ebx
8010437c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010437f:	39 c6                	cmp    %eax,%esi
80104381:	73 35                	jae    801043b8 <memmove+0x48>
80104383:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104386:	39 c8                	cmp    %ecx,%eax
80104388:	73 2e                	jae    801043b8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010438a:	85 db                	test   %ebx,%ebx
    d += n;
8010438c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010438f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104392:	74 1b                	je     801043af <memmove+0x3f>
80104394:	f7 db                	neg    %ebx
80104396:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104399:	01 fb                	add    %edi,%ebx
8010439b:	90                   	nop
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043a4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
801043a7:	83 ea 01             	sub    $0x1,%edx
801043aa:	83 fa ff             	cmp    $0xffffffff,%edx
801043ad:	75 f1                	jne    801043a0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043af:	5b                   	pop    %ebx
801043b0:	5e                   	pop    %esi
801043b1:	5f                   	pop    %edi
801043b2:	5d                   	pop    %ebp
801043b3:	c3                   	ret    
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801043b8:	31 d2                	xor    %edx,%edx
801043ba:	85 db                	test   %ebx,%ebx
801043bc:	74 f1                	je     801043af <memmove+0x3f>
801043be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801043ca:	39 da                	cmp    %ebx,%edx
801043cc:	75 f2                	jne    801043c0 <memmove+0x50>
}
801043ce:	5b                   	pop    %ebx
801043cf:	5e                   	pop    %esi
801043d0:	5f                   	pop    %edi
801043d1:	5d                   	pop    %ebp
801043d2:	c3                   	ret    
801043d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043e4:	eb 8a                	jmp    80104370 <memmove>
801043e6:	8d 76 00             	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	8b 75 10             	mov    0x10(%ebp),%esi
801043f7:	53                   	push   %ebx
801043f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043fe:	85 f6                	test   %esi,%esi
80104400:	74 30                	je     80104432 <strncmp+0x42>
80104402:	0f b6 01             	movzbl (%ecx),%eax
80104405:	84 c0                	test   %al,%al
80104407:	74 2f                	je     80104438 <strncmp+0x48>
80104409:	0f b6 13             	movzbl (%ebx),%edx
8010440c:	38 d0                	cmp    %dl,%al
8010440e:	75 46                	jne    80104456 <strncmp+0x66>
80104410:	8d 51 01             	lea    0x1(%ecx),%edx
80104413:	01 ce                	add    %ecx,%esi
80104415:	eb 14                	jmp    8010442b <strncmp+0x3b>
80104417:	90                   	nop
80104418:	0f b6 02             	movzbl (%edx),%eax
8010441b:	84 c0                	test   %al,%al
8010441d:	74 31                	je     80104450 <strncmp+0x60>
8010441f:	0f b6 19             	movzbl (%ecx),%ebx
80104422:	83 c2 01             	add    $0x1,%edx
80104425:	38 d8                	cmp    %bl,%al
80104427:	75 17                	jne    80104440 <strncmp+0x50>
    n--, p++, q++;
80104429:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010442b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010442d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104430:	75 e6                	jne    80104418 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104432:	5b                   	pop    %ebx
    return 0;
80104433:	31 c0                	xor    %eax,%eax
}
80104435:	5e                   	pop    %esi
80104436:	5d                   	pop    %ebp
80104437:	c3                   	ret    
80104438:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010443b:	31 c0                	xor    %eax,%eax
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104440:	0f b6 d3             	movzbl %bl,%edx
80104443:	29 d0                	sub    %edx,%eax
}
80104445:	5b                   	pop    %ebx
80104446:	5e                   	pop    %esi
80104447:	5d                   	pop    %ebp
80104448:	c3                   	ret    
80104449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104450:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104454:	eb ea                	jmp    80104440 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104456:	89 d3                	mov    %edx,%ebx
80104458:	eb e6                	jmp    80104440 <strncmp+0x50>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
80104466:	56                   	push   %esi
80104467:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010446a:	53                   	push   %ebx
8010446b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010446e:	89 c2                	mov    %eax,%edx
80104470:	eb 19                	jmp    8010448b <strncpy+0x2b>
80104472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104478:	83 c3 01             	add    $0x1,%ebx
8010447b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010447f:	83 c2 01             	add    $0x1,%edx
80104482:	84 c9                	test   %cl,%cl
80104484:	88 4a ff             	mov    %cl,-0x1(%edx)
80104487:	74 09                	je     80104492 <strncpy+0x32>
80104489:	89 f1                	mov    %esi,%ecx
8010448b:	85 c9                	test   %ecx,%ecx
8010448d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104490:	7f e6                	jg     80104478 <strncpy+0x18>
    ;
  while(n-- > 0)
80104492:	31 c9                	xor    %ecx,%ecx
80104494:	85 f6                	test   %esi,%esi
80104496:	7e 0f                	jle    801044a7 <strncpy+0x47>
    *s++ = 0;
80104498:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010449c:	89 f3                	mov    %esi,%ebx
8010449e:	83 c1 01             	add    $0x1,%ecx
801044a1:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801044a3:	85 db                	test   %ebx,%ebx
801044a5:	7f f1                	jg     80104498 <strncpy+0x38>
  return os;
}
801044a7:	5b                   	pop    %ebx
801044a8:	5e                   	pop    %esi
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    
801044ab:	90                   	nop
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044b6:	56                   	push   %esi
801044b7:	8b 45 08             	mov    0x8(%ebp),%eax
801044ba:	53                   	push   %ebx
801044bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044be:	85 c9                	test   %ecx,%ecx
801044c0:	7e 26                	jle    801044e8 <safestrcpy+0x38>
801044c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044c6:	89 c1                	mov    %eax,%ecx
801044c8:	eb 17                	jmp    801044e1 <safestrcpy+0x31>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044d0:	83 c2 01             	add    $0x1,%edx
801044d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044d7:	83 c1 01             	add    $0x1,%ecx
801044da:	84 db                	test   %bl,%bl
801044dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044df:	74 04                	je     801044e5 <safestrcpy+0x35>
801044e1:	39 f2                	cmp    %esi,%edx
801044e3:	75 eb                	jne    801044d0 <safestrcpy+0x20>
    ;
  *s = 0;
801044e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044e8:	5b                   	pop    %ebx
801044e9:	5e                   	pop    %esi
801044ea:	5d                   	pop    %ebp
801044eb:	c3                   	ret    
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044f0 <strlen>:

int
strlen(const char *s)
{
801044f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044f1:	31 c0                	xor    %eax,%eax
{
801044f3:	89 e5                	mov    %esp,%ebp
801044f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801044f8:	80 3a 00             	cmpb   $0x0,(%edx)
801044fb:	74 0c                	je     80104509 <strlen+0x19>
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
80104500:	83 c0 01             	add    $0x1,%eax
80104503:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104507:	75 f7                	jne    80104500 <strlen+0x10>
    ;
  return n;
}
80104509:	5d                   	pop    %ebp
8010450a:	c3                   	ret    

8010450b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010450b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010450f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104513:	55                   	push   %ebp
  pushl %ebx
80104514:	53                   	push   %ebx
  pushl %esi
80104515:	56                   	push   %esi
  pushl %edi
80104516:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104517:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104519:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010451b:	5f                   	pop    %edi
  popl %esi
8010451c:	5e                   	pop    %esi
  popl %ebx
8010451d:	5b                   	pop    %ebx
  popl %ebp
8010451e:	5d                   	pop    %ebp
  ret
8010451f:	c3                   	ret    

80104520 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if(addr >= KERNBASE -4)
80104526:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010452b:	77 0b                	ja     80104538 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
8010452d:	8b 10                	mov    (%eax),%edx
8010452f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104532:	89 10                	mov    %edx,(%eax)
  return 0;
80104534:	31 c0                	xor    %eax,%eax
}
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
    return -1;
80104538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010453d:	5d                   	pop    %ebp
8010453e:	c3                   	ret    
8010453f:	90                   	nop

80104540 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE -4)
80104546:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
8010454c:	77 21                	ja     8010456f <fetchstr+0x2f>
    return -1;
  *pp = (char*)addr;
8010454e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104551:	89 d0                	mov    %edx,%eax
80104553:	89 11                	mov    %edx,(%ecx)
  ep = (char*)(KERNBASE -4);
  for(s = *pp; s < ep; s++){
    if(*s == 0)
80104555:	80 3a 00             	cmpb   $0x0,(%edx)
80104558:	75 0b                	jne    80104565 <fetchstr+0x25>
8010455a:	eb 1c                	jmp    80104578 <fetchstr+0x38>
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104560:	80 38 00             	cmpb   $0x0,(%eax)
80104563:	74 13                	je     80104578 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104565:	83 c0 01             	add    $0x1,%eax
80104568:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
8010456d:	75 f1                	jne    80104560 <fetchstr+0x20>
    return -1;
8010456f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
80104576:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104578:	29 d0                	sub    %edx,%eax
}
8010457a:	5d                   	pop    %ebp
8010457b:	c3                   	ret    
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104586:	e8 65 f1 ff ff       	call   801036f0 <myproc>
8010458b:	8b 55 08             	mov    0x8(%ebp),%edx
8010458e:	8b 40 18             	mov    0x18(%eax),%eax
80104591:	8b 40 44             	mov    0x44(%eax),%eax
80104594:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= KERNBASE -4)
80104598:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010459d:	77 11                	ja     801045b0 <argint+0x30>
  *ip = *(int*)(addr);
8010459f:	8b 10                	mov    (%eax),%edx
801045a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801045a4:	89 10                	mov    %edx,(%eax)
  return 0;
801045a6:	31 c0                	xor    %eax,%eax
}
801045a8:	c9                   	leave  
801045a9:	c3                   	ret    
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801045b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b5:	c9                   	leave  
801045b6:	c3                   	ret    
801045b7:	89 f6                	mov    %esi,%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 24             	sub    $0x24,%esp
801045c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  //struct proc *curproc = myproc();
  uint ustackbase = KERNBASE-4;

  if(argint(n, &i) < 0)
801045ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801045d1:	8b 45 08             	mov    0x8(%ebp),%eax
801045d4:	89 04 24             	mov    %eax,(%esp)
801045d7:	e8 a4 ff ff ff       	call   80104580 <argint>
801045dc:	85 c0                	test   %eax,%eax
801045de:	78 28                	js     80104608 <argptr+0x48>
    return -1;
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  if(size < 0 || (uint)i >= ustackbase || (uint)i+size > ustackbase)
801045e0:	85 db                	test   %ebx,%ebx
801045e2:	78 24                	js     80104608 <argptr+0x48>
801045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e7:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801045ec:	77 1a                	ja     80104608 <argptr+0x48>
801045ee:	01 c3                	add    %eax,%ebx
801045f0:	81 fb fc ff ff 7f    	cmp    $0x7ffffffc,%ebx
801045f6:	77 10                	ja     80104608 <argptr+0x48>
    return -1;
  *pp = (char*)i;
801045f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801045fb:	89 02                	mov    %eax,(%edx)
  return 0;
}
801045fd:	83 c4 24             	add    $0x24,%esp
  return 0;
80104600:	31 c0                	xor    %eax,%eax
}
80104602:	5b                   	pop    %ebx
80104603:	5d                   	pop    %ebp
80104604:	c3                   	ret    
80104605:	8d 76 00             	lea    0x0(%esi),%esi
80104608:	83 c4 24             	add    $0x24,%esp
    return -1;
8010460b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104610:	5b                   	pop    %ebx
80104611:	5d                   	pop    %ebp
80104612:	c3                   	ret    
80104613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010462d:	8b 45 08             	mov    0x8(%ebp),%eax
80104630:	89 04 24             	mov    %eax,(%esp)
80104633:	e8 48 ff ff ff       	call   80104580 <argint>
80104638:	85 c0                	test   %eax,%eax
8010463a:	78 2b                	js     80104667 <argstr+0x47>
    return -1;
  return fetchstr(addr, pp);
8010463c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(addr >= KERNBASE -4)
8010463f:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
80104645:	77 20                	ja     80104667 <argstr+0x47>
  *pp = (char*)addr;
80104647:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010464a:	89 d0                	mov    %edx,%eax
8010464c:	89 11                	mov    %edx,(%ecx)
    if(*s == 0)
8010464e:	80 3a 00             	cmpb   $0x0,(%edx)
80104651:	75 0a                	jne    8010465d <argstr+0x3d>
80104653:	eb 1b                	jmp    80104670 <argstr+0x50>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
80104658:	80 38 00             	cmpb   $0x0,(%eax)
8010465b:	74 13                	je     80104670 <argstr+0x50>
  for(s = *pp; s < ep; s++){
8010465d:	83 c0 01             	add    $0x1,%eax
80104660:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
80104665:	76 f1                	jbe    80104658 <argstr+0x38>
    return -1;
80104667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010466c:	c9                   	leave  
8010466d:	c3                   	ret    
8010466e:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104670:	29 d0                	sub    %edx,%eax
}
80104672:	c9                   	leave  
80104673:	c3                   	ret    
80104674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010467a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104680 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104688:	e8 63 f0 ff ff       	call   801036f0 <myproc>

  num = curproc->tf->eax;
8010468d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104690:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104692:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104695:	8d 50 ff             	lea    -0x1(%eax),%edx
80104698:	83 fa 16             	cmp    $0x16,%edx
8010469b:	77 1b                	ja     801046b8 <syscall+0x38>
8010469d:	8b 14 85 60 75 10 80 	mov    -0x7fef8aa0(,%eax,4),%edx
801046a4:	85 d2                	test   %edx,%edx
801046a6:	74 10                	je     801046b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046a8:	ff d2                	call   *%edx
801046aa:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046ad:	83 c4 10             	add    $0x10,%esp
801046b0:	5b                   	pop    %ebx
801046b1:	5e                   	pop    %esi
801046b2:	5d                   	pop    %ebp
801046b3:	c3                   	ret    
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801046b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046bf:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801046c3:	8b 43 10             	mov    0x10(%ebx),%eax
801046c6:	c7 04 24 31 75 10 80 	movl   $0x80107531,(%esp)
801046cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801046d1:	e8 7a bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801046d6:	8b 43 18             	mov    0x18(%ebx),%eax
801046d9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801046e0:	83 c4 10             	add    $0x10,%esp
801046e3:	5b                   	pop    %ebx
801046e4:	5e                   	pop    %esi
801046e5:	5d                   	pop    %ebp
801046e6:	c3                   	ret    
801046e7:	66 90                	xchg   %ax,%ax
801046e9:	66 90                	xchg   %ax,%ax
801046eb:	66 90                	xchg   %ax,%ax
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	89 c3                	mov    %eax,%ebx
801046f6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046f9:	e8 f2 ef ff ff       	call   801036f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046fe:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104700:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104704:	85 c9                	test   %ecx,%ecx
80104706:	74 18                	je     80104720 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104708:	83 c2 01             	add    $0x1,%edx
8010470b:	83 fa 10             	cmp    $0x10,%edx
8010470e:	75 f0                	jne    80104700 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104710:	83 c4 04             	add    $0x4,%esp
  return -1;
80104713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104718:	5b                   	pop    %ebx
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104720:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104724:	83 c4 04             	add    $0x4,%esp
      return fd;
80104727:	89 d0                	mov    %edx,%eax
}
80104729:	5b                   	pop    %ebx
8010472a:	5d                   	pop    %ebp
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
80104736:	83 ec 4c             	sub    $0x4c,%esp
80104739:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010473c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010473f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104746:	89 04 24             	mov    %eax,(%esp)
{
80104749:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010474c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010474f:	e8 1c d8 ff ff       	call   80101f70 <nameiparent>
80104754:	85 c0                	test   %eax,%eax
80104756:	89 c7                	mov    %eax,%edi
80104758:	0f 84 da 00 00 00    	je     80104838 <create+0x108>
    return 0;
  ilock(dp);
8010475e:	89 04 24             	mov    %eax,(%esp)
80104761:	e8 9a cf ff ff       	call   80101700 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104766:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104769:	89 44 24 08          	mov    %eax,0x8(%esp)
8010476d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104771:	89 3c 24             	mov    %edi,(%esp)
80104774:	e8 97 d4 ff ff       	call   80101c10 <dirlookup>
80104779:	85 c0                	test   %eax,%eax
8010477b:	89 c6                	mov    %eax,%esi
8010477d:	74 41                	je     801047c0 <create+0x90>
    iunlockput(dp);
8010477f:	89 3c 24             	mov    %edi,(%esp)
80104782:	e8 d9 d1 ff ff       	call   80101960 <iunlockput>
    ilock(ip);
80104787:	89 34 24             	mov    %esi,(%esp)
8010478a:	e8 71 cf ff ff       	call   80101700 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010478f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104794:	75 12                	jne    801047a8 <create+0x78>
80104796:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010479b:	89 f0                	mov    %esi,%eax
8010479d:	75 09                	jne    801047a8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010479f:	83 c4 4c             	add    $0x4c,%esp
801047a2:	5b                   	pop    %ebx
801047a3:	5e                   	pop    %esi
801047a4:	5f                   	pop    %edi
801047a5:	5d                   	pop    %ebp
801047a6:	c3                   	ret    
801047a7:	90                   	nop
    iunlockput(ip);
801047a8:	89 34 24             	mov    %esi,(%esp)
801047ab:	e8 b0 d1 ff ff       	call   80101960 <iunlockput>
}
801047b0:	83 c4 4c             	add    $0x4c,%esp
    return 0;
801047b3:	31 c0                	xor    %eax,%eax
}
801047b5:	5b                   	pop    %ebx
801047b6:	5e                   	pop    %esi
801047b7:	5f                   	pop    %edi
801047b8:	5d                   	pop    %ebp
801047b9:	c3                   	ret    
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801047c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c8:	8b 07                	mov    (%edi),%eax
801047ca:	89 04 24             	mov    %eax,(%esp)
801047cd:	e8 9e cd ff ff       	call   80101570 <ialloc>
801047d2:	85 c0                	test   %eax,%eax
801047d4:	89 c6                	mov    %eax,%esi
801047d6:	0f 84 bf 00 00 00    	je     8010489b <create+0x16b>
  ilock(ip);
801047dc:	89 04 24             	mov    %eax,(%esp)
801047df:	e8 1c cf ff ff       	call   80101700 <ilock>
  ip->major = major;
801047e4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047e8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047ec:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047f0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047f4:	b8 01 00 00 00       	mov    $0x1,%eax
801047f9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047fd:	89 34 24             	mov    %esi,(%esp)
80104800:	e8 3b ce ff ff       	call   80101640 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104805:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010480a:	74 34                	je     80104840 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010480c:	8b 46 04             	mov    0x4(%esi),%eax
8010480f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104813:	89 3c 24             	mov    %edi,(%esp)
80104816:	89 44 24 08          	mov    %eax,0x8(%esp)
8010481a:	e8 51 d6 ff ff       	call   80101e70 <dirlink>
8010481f:	85 c0                	test   %eax,%eax
80104821:	78 6c                	js     8010488f <create+0x15f>
  iunlockput(dp);
80104823:	89 3c 24             	mov    %edi,(%esp)
80104826:	e8 35 d1 ff ff       	call   80101960 <iunlockput>
}
8010482b:	83 c4 4c             	add    $0x4c,%esp
  return ip;
8010482e:	89 f0                	mov    %esi,%eax
}
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5f                   	pop    %edi
80104833:	5d                   	pop    %ebp
80104834:	c3                   	ret    
80104835:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104838:	31 c0                	xor    %eax,%eax
8010483a:	e9 60 ff ff ff       	jmp    8010479f <create+0x6f>
8010483f:	90                   	nop
    dp->nlink++;  // for ".."
80104840:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104845:	89 3c 24             	mov    %edi,(%esp)
80104848:	e8 f3 cd ff ff       	call   80101640 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010484d:	8b 46 04             	mov    0x4(%esi),%eax
80104850:	c7 44 24 04 dc 75 10 	movl   $0x801075dc,0x4(%esp)
80104857:	80 
80104858:	89 34 24             	mov    %esi,(%esp)
8010485b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485f:	e8 0c d6 ff ff       	call   80101e70 <dirlink>
80104864:	85 c0                	test   %eax,%eax
80104866:	78 1b                	js     80104883 <create+0x153>
80104868:	8b 47 04             	mov    0x4(%edi),%eax
8010486b:	c7 44 24 04 db 75 10 	movl   $0x801075db,0x4(%esp)
80104872:	80 
80104873:	89 34 24             	mov    %esi,(%esp)
80104876:	89 44 24 08          	mov    %eax,0x8(%esp)
8010487a:	e8 f1 d5 ff ff       	call   80101e70 <dirlink>
8010487f:	85 c0                	test   %eax,%eax
80104881:	79 89                	jns    8010480c <create+0xdc>
      panic("create dots");
80104883:	c7 04 24 cf 75 10 80 	movl   $0x801075cf,(%esp)
8010488a:	e8 d1 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010488f:	c7 04 24 de 75 10 80 	movl   $0x801075de,(%esp)
80104896:	e8 c5 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010489b:	c7 04 24 c0 75 10 80 	movl   $0x801075c0,(%esp)
801048a2:	e8 b9 ba ff ff       	call   80100360 <panic>
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	89 c6                	mov    %eax,%esi
801048b6:	53                   	push   %ebx
801048b7:	89 d3                	mov    %edx,%ebx
801048b9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
801048bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801048c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048ca:	e8 b1 fc ff ff       	call   80104580 <argint>
801048cf:	85 c0                	test   %eax,%eax
801048d1:	78 2d                	js     80104900 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048d3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048d7:	77 27                	ja     80104900 <argfd.constprop.0+0x50>
801048d9:	e8 12 ee ff ff       	call   801036f0 <myproc>
801048de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801048e5:	85 c0                	test   %eax,%eax
801048e7:	74 17                	je     80104900 <argfd.constprop.0+0x50>
  if(pfd)
801048e9:	85 f6                	test   %esi,%esi
801048eb:	74 02                	je     801048ef <argfd.constprop.0+0x3f>
    *pfd = fd;
801048ed:	89 16                	mov    %edx,(%esi)
  if(pf)
801048ef:	85 db                	test   %ebx,%ebx
801048f1:	74 1d                	je     80104910 <argfd.constprop.0+0x60>
    *pf = f;
801048f3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048f5:	31 c0                	xor    %eax,%eax
}
801048f7:	83 c4 20             	add    $0x20,%esp
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
801048fe:	66 90                	xchg   %ax,%ax
80104900:	83 c4 20             	add    $0x20,%esp
    return -1;
80104903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104908:	5b                   	pop    %ebx
80104909:	5e                   	pop    %esi
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104910:	31 c0                	xor    %eax,%eax
80104912:	eb e3                	jmp    801048f7 <argfd.constprop.0+0x47>
80104914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010491a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104920 <sys_dup>:
{
80104920:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104921:	31 c0                	xor    %eax,%eax
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	53                   	push   %ebx
80104926:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104929:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010492c:	e8 7f ff ff ff       	call   801048b0 <argfd.constprop.0>
80104931:	85 c0                	test   %eax,%eax
80104933:	78 23                	js     80104958 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104938:	e8 b3 fd ff ff       	call   801046f0 <fdalloc>
8010493d:	85 c0                	test   %eax,%eax
8010493f:	89 c3                	mov    %eax,%ebx
80104941:	78 15                	js     80104958 <sys_dup+0x38>
  filedup(f);
80104943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104946:	89 04 24             	mov    %eax,(%esp)
80104949:	e8 d2 c4 ff ff       	call   80100e20 <filedup>
  return fd;
8010494e:	89 d8                	mov    %ebx,%eax
}
80104950:	83 c4 24             	add    $0x24,%esp
80104953:	5b                   	pop    %ebx
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	66 90                	xchg   %ax,%ax
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495d:	eb f1                	jmp    80104950 <sys_dup+0x30>
8010495f:	90                   	nop

80104960 <sys_read>:
{
80104960:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104961:	31 c0                	xor    %eax,%eax
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104968:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010496b:	e8 40 ff ff ff       	call   801048b0 <argfd.constprop.0>
80104970:	85 c0                	test   %eax,%eax
80104972:	78 54                	js     801049c8 <sys_read+0x68>
80104974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104977:	89 44 24 04          	mov    %eax,0x4(%esp)
8010497b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104982:	e8 f9 fb ff ff       	call   80104580 <argint>
80104987:	85 c0                	test   %eax,%eax
80104989:	78 3d                	js     801049c8 <sys_read+0x68>
8010498b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104995:	89 44 24 08          	mov    %eax,0x8(%esp)
80104999:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499c:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a0:	e8 1b fc ff ff       	call   801045c0 <argptr>
801049a5:	85 c0                	test   %eax,%eax
801049a7:	78 1f                	js     801049c8 <sys_read+0x68>
  return fileread(f, p, n);
801049a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801049b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ba:	89 04 24             	mov    %eax,(%esp)
801049bd:	e8 be c5 ff ff       	call   80100f80 <fileread>
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049cd:	c9                   	leave  
801049ce:	c3                   	ret    
801049cf:	90                   	nop

801049d0 <sys_write>:
{
801049d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049d1:	31 c0                	xor    %eax,%eax
{
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049db:	e8 d0 fe ff ff       	call   801048b0 <argfd.constprop.0>
801049e0:	85 c0                	test   %eax,%eax
801049e2:	78 54                	js     80104a38 <sys_write+0x68>
801049e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049f2:	e8 89 fb ff ff       	call   80104580 <argint>
801049f7:	85 c0                	test   %eax,%eax
801049f9:	78 3d                	js     80104a38 <sys_write+0x68>
801049fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a10:	e8 ab fb ff ff       	call   801045c0 <argptr>
80104a15:	85 c0                	test   %eax,%eax
80104a17:	78 1f                	js     80104a38 <sys_write+0x68>
  return filewrite(f, p, n);
80104a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a2a:	89 04 24             	mov    %eax,(%esp)
80104a2d:	e8 ee c5 ff ff       	call   80101020 <filewrite>
}
80104a32:	c9                   	leave  
80104a33:	c3                   	ret    
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop

80104a40 <sys_close>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104a46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a4c:	e8 5f fe ff ff       	call   801048b0 <argfd.constprop.0>
80104a51:	85 c0                	test   %eax,%eax
80104a53:	78 23                	js     80104a78 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104a55:	e8 96 ec ff ff       	call   801036f0 <myproc>
80104a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a5d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a64:	00 
  fileclose(f);
80104a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a68:	89 04 24             	mov    %eax,(%esp)
80104a6b:	e8 00 c4 ff ff       	call   80100e70 <fileclose>
  return 0;
80104a70:	31 c0                	xor    %eax,%eax
}
80104a72:	c9                   	leave  
80104a73:	c3                   	ret    
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a7d:	c9                   	leave  
80104a7e:	c3                   	ret    
80104a7f:	90                   	nop

80104a80 <sys_fstat>:
{
80104a80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a81:	31 c0                	xor    %eax,%eax
{
80104a83:	89 e5                	mov    %esp,%ebp
80104a85:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a8b:	e8 20 fe ff ff       	call   801048b0 <argfd.constprop.0>
80104a90:	85 c0                	test   %eax,%eax
80104a92:	78 34                	js     80104ac8 <sys_fstat+0x48>
80104a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a97:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a9e:	00 
80104a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aaa:	e8 11 fb ff ff       	call   801045c0 <argptr>
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	78 15                	js     80104ac8 <sys_fstat+0x48>
  return filestat(f, st);
80104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104abd:	89 04 24             	mov    %eax,(%esp)
80104ac0:	e8 6b c4 ff ff       	call   80100f30 <filestat>
}
80104ac5:	c9                   	leave  
80104ac6:	c3                   	ret    
80104ac7:	90                   	nop
    return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_link>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ad9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ae7:	e8 34 fb ff ff       	call   80104620 <argstr>
80104aec:	85 c0                	test   %eax,%eax
80104aee:	0f 88 e6 00 00 00    	js     80104bda <sys_link+0x10a>
80104af4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104afb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b02:	e8 19 fb ff ff       	call   80104620 <argstr>
80104b07:	85 c0                	test   %eax,%eax
80104b09:	0f 88 cb 00 00 00    	js     80104bda <sys_link+0x10a>
  begin_op();
80104b0f:	e8 4c e0 ff ff       	call   80102b60 <begin_op>
  if((ip = namei(old)) == 0){
80104b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b17:	89 04 24             	mov    %eax,(%esp)
80104b1a:	e8 31 d4 ff ff       	call   80101f50 <namei>
80104b1f:	85 c0                	test   %eax,%eax
80104b21:	89 c3                	mov    %eax,%ebx
80104b23:	0f 84 ac 00 00 00    	je     80104bd5 <sys_link+0x105>
  ilock(ip);
80104b29:	89 04 24             	mov    %eax,(%esp)
80104b2c:	e8 cf cb ff ff       	call   80101700 <ilock>
  if(ip->type == T_DIR){
80104b31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b36:	0f 84 91 00 00 00    	je     80104bcd <sys_link+0xfd>
  ip->nlink++;
80104b3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104b41:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104b44:	89 1c 24             	mov    %ebx,(%esp)
80104b47:	e8 f4 ca ff ff       	call   80101640 <iupdate>
  iunlock(ip);
80104b4c:	89 1c 24             	mov    %ebx,(%esp)
80104b4f:	e8 8c cc ff ff       	call   801017e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104b54:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b57:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b5b:	89 04 24             	mov    %eax,(%esp)
80104b5e:	e8 0d d4 ff ff       	call   80101f70 <nameiparent>
80104b63:	85 c0                	test   %eax,%eax
80104b65:	89 c6                	mov    %eax,%esi
80104b67:	74 4f                	je     80104bb8 <sys_link+0xe8>
  ilock(dp);
80104b69:	89 04 24             	mov    %eax,(%esp)
80104b6c:	e8 8f cb ff ff       	call   80101700 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b71:	8b 03                	mov    (%ebx),%eax
80104b73:	39 06                	cmp    %eax,(%esi)
80104b75:	75 39                	jne    80104bb0 <sys_link+0xe0>
80104b77:	8b 43 04             	mov    0x4(%ebx),%eax
80104b7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b7e:	89 34 24             	mov    %esi,(%esp)
80104b81:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b85:	e8 e6 d2 ff ff       	call   80101e70 <dirlink>
80104b8a:	85 c0                	test   %eax,%eax
80104b8c:	78 22                	js     80104bb0 <sys_link+0xe0>
  iunlockput(dp);
80104b8e:	89 34 24             	mov    %esi,(%esp)
80104b91:	e8 ca cd ff ff       	call   80101960 <iunlockput>
  iput(ip);
80104b96:	89 1c 24             	mov    %ebx,(%esp)
80104b99:	e8 82 cc ff ff       	call   80101820 <iput>
  end_op();
80104b9e:	e8 2d e0 ff ff       	call   80102bd0 <end_op>
}
80104ba3:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104ba6:	31 c0                	xor    %eax,%eax
}
80104ba8:	5b                   	pop    %ebx
80104ba9:	5e                   	pop    %esi
80104baa:	5f                   	pop    %edi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104bb0:	89 34 24             	mov    %esi,(%esp)
80104bb3:	e8 a8 cd ff ff       	call   80101960 <iunlockput>
  ilock(ip);
80104bb8:	89 1c 24             	mov    %ebx,(%esp)
80104bbb:	e8 40 cb ff ff       	call   80101700 <ilock>
  ip->nlink--;
80104bc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bc5:	89 1c 24             	mov    %ebx,(%esp)
80104bc8:	e8 73 ca ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
80104bcd:	89 1c 24             	mov    %ebx,(%esp)
80104bd0:	e8 8b cd ff ff       	call   80101960 <iunlockput>
  end_op();
80104bd5:	e8 f6 df ff ff       	call   80102bd0 <end_op>
}
80104bda:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5f                   	pop    %edi
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <sys_unlink>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104bf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c07:	e8 14 fa ff ff       	call   80104620 <argstr>
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	0f 88 76 01 00 00    	js     80104d8a <sys_unlink+0x19a>
  begin_op();
80104c14:	e8 47 df ff ff       	call   80102b60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c19:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c1c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c23:	89 04 24             	mov    %eax,(%esp)
80104c26:	e8 45 d3 ff ff       	call   80101f70 <nameiparent>
80104c2b:	85 c0                	test   %eax,%eax
80104c2d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c30:	0f 84 4f 01 00 00    	je     80104d85 <sys_unlink+0x195>
  ilock(dp);
80104c36:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c39:	89 34 24             	mov    %esi,(%esp)
80104c3c:	e8 bf ca ff ff       	call   80101700 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c41:	c7 44 24 04 dc 75 10 	movl   $0x801075dc,0x4(%esp)
80104c48:	80 
80104c49:	89 1c 24             	mov    %ebx,(%esp)
80104c4c:	e8 8f cf ff ff       	call   80101be0 <namecmp>
80104c51:	85 c0                	test   %eax,%eax
80104c53:	0f 84 21 01 00 00    	je     80104d7a <sys_unlink+0x18a>
80104c59:	c7 44 24 04 db 75 10 	movl   $0x801075db,0x4(%esp)
80104c60:	80 
80104c61:	89 1c 24             	mov    %ebx,(%esp)
80104c64:	e8 77 cf ff ff       	call   80101be0 <namecmp>
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	0f 84 09 01 00 00    	je     80104d7a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c78:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c7c:	89 34 24             	mov    %esi,(%esp)
80104c7f:	e8 8c cf ff ff       	call   80101c10 <dirlookup>
80104c84:	85 c0                	test   %eax,%eax
80104c86:	89 c3                	mov    %eax,%ebx
80104c88:	0f 84 ec 00 00 00    	je     80104d7a <sys_unlink+0x18a>
  ilock(ip);
80104c8e:	89 04 24             	mov    %eax,(%esp)
80104c91:	e8 6a ca ff ff       	call   80101700 <ilock>
  if(ip->nlink < 1)
80104c96:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c9b:	0f 8e 24 01 00 00    	jle    80104dc5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ca6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ca9:	74 7d                	je     80104d28 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104cab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104cb2:	00 
80104cb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104cba:	00 
80104cbb:	89 34 24             	mov    %esi,(%esp)
80104cbe:	e8 0d f6 ff ff       	call   801042d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104cc6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ccd:	00 
80104cce:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cd9:	89 04 24             	mov    %eax,(%esp)
80104cdc:	e8 cf cd ff ff       	call   80101ab0 <writei>
80104ce1:	83 f8 10             	cmp    $0x10,%eax
80104ce4:	0f 85 cf 00 00 00    	jne    80104db9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104cea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cef:	0f 84 a3 00 00 00    	je     80104d98 <sys_unlink+0x1a8>
  iunlockput(dp);
80104cf5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cf8:	89 04 24             	mov    %eax,(%esp)
80104cfb:	e8 60 cc ff ff       	call   80101960 <iunlockput>
  ip->nlink--;
80104d00:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d05:	89 1c 24             	mov    %ebx,(%esp)
80104d08:	e8 33 c9 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
80104d0d:	89 1c 24             	mov    %ebx,(%esp)
80104d10:	e8 4b cc ff ff       	call   80101960 <iunlockput>
  end_op();
80104d15:	e8 b6 de ff ff       	call   80102bd0 <end_op>
}
80104d1a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104d1d:	31 c0                	xor    %eax,%eax
}
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5f                   	pop    %edi
80104d22:	5d                   	pop    %ebp
80104d23:	c3                   	ret    
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d28:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d2c:	0f 86 79 ff ff ff    	jbe    80104cab <sys_unlink+0xbb>
80104d32:	bf 20 00 00 00       	mov    $0x20,%edi
80104d37:	eb 15                	jmp    80104d4e <sys_unlink+0x15e>
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d40:	8d 57 10             	lea    0x10(%edi),%edx
80104d43:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d46:	0f 83 5f ff ff ff    	jae    80104cab <sys_unlink+0xbb>
80104d4c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d4e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d55:	00 
80104d56:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d5a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d5e:	89 1c 24             	mov    %ebx,(%esp)
80104d61:	e8 4a cc ff ff       	call   801019b0 <readi>
80104d66:	83 f8 10             	cmp    $0x10,%eax
80104d69:	75 42                	jne    80104dad <sys_unlink+0x1bd>
    if(de.inum != 0)
80104d6b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d70:	74 ce                	je     80104d40 <sys_unlink+0x150>
    iunlockput(ip);
80104d72:	89 1c 24             	mov    %ebx,(%esp)
80104d75:	e8 e6 cb ff ff       	call   80101960 <iunlockput>
  iunlockput(dp);
80104d7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d7d:	89 04 24             	mov    %eax,(%esp)
80104d80:	e8 db cb ff ff       	call   80101960 <iunlockput>
  end_op();
80104d85:	e8 46 de ff ff       	call   80102bd0 <end_op>
}
80104d8a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5f                   	pop    %edi
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    
80104d97:	90                   	nop
    dp->nlink--;
80104d98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d9b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104da0:	89 04 24             	mov    %eax,(%esp)
80104da3:	e8 98 c8 ff ff       	call   80101640 <iupdate>
80104da8:	e9 48 ff ff ff       	jmp    80104cf5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104dad:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80104db4:	e8 a7 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104db9:	c7 04 24 12 76 10 80 	movl   $0x80107612,(%esp)
80104dc0:	e8 9b b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104dc5:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80104dcc:	e8 8f b5 ff ff       	call   80100360 <panic>
80104dd1:	eb 0d                	jmp    80104de0 <sys_open>
80104dd3:	90                   	nop
80104dd4:	90                   	nop
80104dd5:	90                   	nop
80104dd6:	90                   	nop
80104dd7:	90                   	nop
80104dd8:	90                   	nop
80104dd9:	90                   	nop
80104dda:	90                   	nop
80104ddb:	90                   	nop
80104ddc:	90                   	nop
80104ddd:	90                   	nop
80104dde:	90                   	nop
80104ddf:	90                   	nop

80104de0 <sys_open>:

int
sys_open(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	53                   	push   %ebx
80104de6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104de9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104df7:	e8 24 f8 ff ff       	call   80104620 <argstr>
80104dfc:	85 c0                	test   %eax,%eax
80104dfe:	0f 88 d1 00 00 00    	js     80104ed5 <sys_open+0xf5>
80104e04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e12:	e8 69 f7 ff ff       	call   80104580 <argint>
80104e17:	85 c0                	test   %eax,%eax
80104e19:	0f 88 b6 00 00 00    	js     80104ed5 <sys_open+0xf5>
    return -1;

  begin_op();
80104e1f:	e8 3c dd ff ff       	call   80102b60 <begin_op>

  if(omode & O_CREATE){
80104e24:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e28:	0f 85 82 00 00 00    	jne    80104eb0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e31:	89 04 24             	mov    %eax,(%esp)
80104e34:	e8 17 d1 ff ff       	call   80101f50 <namei>
80104e39:	85 c0                	test   %eax,%eax
80104e3b:	89 c6                	mov    %eax,%esi
80104e3d:	0f 84 8d 00 00 00    	je     80104ed0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e43:	89 04 24             	mov    %eax,(%esp)
80104e46:	e8 b5 c8 ff ff       	call   80101700 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e50:	0f 84 92 00 00 00    	je     80104ee8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e56:	e8 55 bf ff ff       	call   80100db0 <filealloc>
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	89 c3                	mov    %eax,%ebx
80104e5f:	0f 84 93 00 00 00    	je     80104ef8 <sys_open+0x118>
80104e65:	e8 86 f8 ff ff       	call   801046f0 <fdalloc>
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	89 c7                	mov    %eax,%edi
80104e6e:	0f 88 94 00 00 00    	js     80104f08 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e74:	89 34 24             	mov    %esi,(%esp)
80104e77:	e8 64 c9 ff ff       	call   801017e0 <iunlock>
  end_op();
80104e7c:	e8 4f dd ff ff       	call   80102bd0 <end_op>

  f->type = FD_INODE;
80104e81:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e8a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e8d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e94:	89 c2                	mov    %eax,%edx
80104e96:	83 e2 01             	and    $0x1,%edx
80104e99:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e9c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e9e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104ea1:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ea3:	0f 95 43 09          	setne  0x9(%ebx)
}
80104ea7:	83 c4 2c             	add    $0x2c,%esp
80104eaa:	5b                   	pop    %ebx
80104eab:	5e                   	pop    %esi
80104eac:	5f                   	pop    %edi
80104ead:	5d                   	pop    %ebp
80104eae:	c3                   	ret    
80104eaf:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb3:	31 c9                	xor    %ecx,%ecx
80104eb5:	ba 02 00 00 00       	mov    $0x2,%edx
80104eba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec1:	e8 6a f8 ff ff       	call   80104730 <create>
    if(ip == 0){
80104ec6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104ec8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104eca:	75 8a                	jne    80104e56 <sys_open+0x76>
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104ed0:	e8 fb dc ff ff       	call   80102bd0 <end_op>
}
80104ed5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5f                   	pop    %edi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	0f 84 63 ff ff ff    	je     80104e56 <sys_open+0x76>
80104ef3:	90                   	nop
80104ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104ef8:	89 34 24             	mov    %esi,(%esp)
80104efb:	e8 60 ca ff ff       	call   80101960 <iunlockput>
80104f00:	eb ce                	jmp    80104ed0 <sys_open+0xf0>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104f08:	89 1c 24             	mov    %ebx,(%esp)
80104f0b:	e8 60 bf ff ff       	call   80100e70 <fileclose>
80104f10:	eb e6                	jmp    80104ef8 <sys_open+0x118>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_mkdir>:

int
sys_mkdir(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f26:	e8 35 dc ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f39:	e8 e2 f6 ff ff       	call   80104620 <argstr>
80104f3e:	85 c0                	test   %eax,%eax
80104f40:	78 2e                	js     80104f70 <sys_mkdir+0x50>
80104f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f45:	31 c9                	xor    %ecx,%ecx
80104f47:	ba 01 00 00 00       	mov    $0x1,%edx
80104f4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f53:	e8 d8 f7 ff ff       	call   80104730 <create>
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	74 14                	je     80104f70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f5c:	89 04 24             	mov    %eax,(%esp)
80104f5f:	e8 fc c9 ff ff       	call   80101960 <iunlockput>
  end_op();
80104f64:	e8 67 dc ff ff       	call   80102bd0 <end_op>
  return 0;
80104f69:	31 c0                	xor    %eax,%eax
}
80104f6b:	c9                   	leave  
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f70:	e8 5b dc ff ff       	call   80102bd0 <end_op>
    return -1;
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_mknod>:

int
sys_mknod(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f86:	e8 d5 db ff ff       	call   80102b60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f99:	e8 82 f6 ff ff       	call   80104620 <argstr>
80104f9e:	85 c0                	test   %eax,%eax
80104fa0:	78 5e                	js     80105000 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104fa2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fb0:	e8 cb f5 ff ff       	call   80104580 <argint>
  if((argstr(0, &path)) < 0 ||
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	78 47                	js     80105000 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104fc7:	e8 b4 f5 ff ff       	call   80104580 <argint>
     argint(1, &major) < 0 ||
80104fcc:	85 c0                	test   %eax,%eax
80104fce:	78 30                	js     80105000 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fd0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104fd4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fd9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fdd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fe3:	e8 48 f7 ff ff       	call   80104730 <create>
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 14                	je     80105000 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fec:	89 04 24             	mov    %eax,(%esp)
80104fef:	e8 6c c9 ff ff       	call   80101960 <iunlockput>
  end_op();
80104ff4:	e8 d7 db ff ff       	call   80102bd0 <end_op>
  return 0;
80104ff9:	31 c0                	xor    %eax,%eax
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105000:	e8 cb db ff ff       	call   80102bd0 <end_op>
    return -1;
80105005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_chdir>:

int
sys_chdir(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105018:	e8 d3 e6 ff ff       	call   801036f0 <myproc>
8010501d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010501f:	e8 3c db ff ff       	call   80102b60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105024:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105027:	89 44 24 04          	mov    %eax,0x4(%esp)
8010502b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105032:	e8 e9 f5 ff ff       	call   80104620 <argstr>
80105037:	85 c0                	test   %eax,%eax
80105039:	78 4a                	js     80105085 <sys_chdir+0x75>
8010503b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503e:	89 04 24             	mov    %eax,(%esp)
80105041:	e8 0a cf ff ff       	call   80101f50 <namei>
80105046:	85 c0                	test   %eax,%eax
80105048:	89 c3                	mov    %eax,%ebx
8010504a:	74 39                	je     80105085 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010504c:	89 04 24             	mov    %eax,(%esp)
8010504f:	e8 ac c6 ff ff       	call   80101700 <ilock>
  if(ip->type != T_DIR){
80105054:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105059:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010505c:	75 22                	jne    80105080 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010505e:	e8 7d c7 ff ff       	call   801017e0 <iunlock>
  iput(curproc->cwd);
80105063:	8b 46 68             	mov    0x68(%esi),%eax
80105066:	89 04 24             	mov    %eax,(%esp)
80105069:	e8 b2 c7 ff ff       	call   80101820 <iput>
  end_op();
8010506e:	e8 5d db ff ff       	call   80102bd0 <end_op>
  curproc->cwd = ip;
  return 0;
80105073:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105075:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105078:	83 c4 20             	add    $0x20,%esp
8010507b:	5b                   	pop    %ebx
8010507c:	5e                   	pop    %esi
8010507d:	5d                   	pop    %ebp
8010507e:	c3                   	ret    
8010507f:	90                   	nop
    iunlockput(ip);
80105080:	e8 db c8 ff ff       	call   80101960 <iunlockput>
    end_op();
80105085:	e8 46 db ff ff       	call   80102bd0 <end_op>
}
8010508a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010508d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105092:	5b                   	pop    %ebx
80105093:	5e                   	pop    %esi
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    
80105096:	8d 76 00             	lea    0x0(%esi),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_exec>:

int
sys_exec(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
801050a6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801050ac:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050bd:	e8 5e f5 ff ff       	call   80104620 <argstr>
801050c2:	85 c0                	test   %eax,%eax
801050c4:	0f 88 84 00 00 00    	js     8010514e <sys_exec+0xae>
801050ca:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050db:	e8 a0 f4 ff ff       	call   80104580 <argint>
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 6a                	js     8010514e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801050ea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801050ec:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050f3:	00 
801050f4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105101:	00 
80105102:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105108:	89 04 24             	mov    %eax,(%esp)
8010510b:	e8 c0 f1 ff ff       	call   801042d0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105110:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105116:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010511a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010511d:	89 04 24             	mov    %eax,(%esp)
80105120:	e8 fb f3 ff ff       	call   80104520 <fetchint>
80105125:	85 c0                	test   %eax,%eax
80105127:	78 25                	js     8010514e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105129:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010512f:	85 c0                	test   %eax,%eax
80105131:	74 2d                	je     80105160 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105133:	89 74 24 04          	mov    %esi,0x4(%esp)
80105137:	89 04 24             	mov    %eax,(%esp)
8010513a:	e8 01 f4 ff ff       	call   80104540 <fetchstr>
8010513f:	85 c0                	test   %eax,%eax
80105141:	78 0b                	js     8010514e <sys_exec+0xae>
  for(i=0;; i++){
80105143:	83 c3 01             	add    $0x1,%ebx
80105146:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105149:	83 fb 20             	cmp    $0x20,%ebx
8010514c:	75 c2                	jne    80105110 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010514e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5f                   	pop    %edi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105160:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010516a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105170:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105177:	00 00 00 00 
  return exec(path, argv);
8010517b:	89 04 24             	mov    %eax,(%esp)
8010517e:	e8 1d b8 ff ff       	call   801009a0 <exec>
}
80105183:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5f                   	pop    %edi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_pipe>:

int
sys_pipe(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105197:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010519a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801051a1:	00 
801051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051ad:	e8 0e f4 ff ff       	call   801045c0 <argptr>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	78 6d                	js     80105223 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801051b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c0:	89 04 24             	mov    %eax,(%esp)
801051c3:	e8 f8 df ff ff       	call   801031c0 <pipealloc>
801051c8:	85 c0                	test   %eax,%eax
801051ca:	78 57                	js     80105223 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051cf:	e8 1c f5 ff ff       	call   801046f0 <fdalloc>
801051d4:	85 c0                	test   %eax,%eax
801051d6:	89 c3                	mov    %eax,%ebx
801051d8:	78 33                	js     8010520d <sys_pipe+0x7d>
801051da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051dd:	e8 0e f5 ff ff       	call   801046f0 <fdalloc>
801051e2:	85 c0                	test   %eax,%eax
801051e4:	78 1a                	js     80105200 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801051e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051e9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801051eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ee:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801051f1:	83 c4 24             	add    $0x24,%esp
  return 0;
801051f4:	31 c0                	xor    %eax,%eax
}
801051f6:	5b                   	pop    %ebx
801051f7:	5d                   	pop    %ebp
801051f8:	c3                   	ret    
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105200:	e8 eb e4 ff ff       	call   801036f0 <myproc>
80105205:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010520c:	00 
    fileclose(rf);
8010520d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105210:	89 04 24             	mov    %eax,(%esp)
80105213:	e8 58 bc ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521b:	89 04 24             	mov    %eax,(%esp)
8010521e:	e8 4d bc ff ff       	call   80100e70 <fileclose>
}
80105223:	83 c4 24             	add    $0x24,%esp
    return -1;
80105226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010522b:	5b                   	pop    %ebx
8010522c:	5d                   	pop    %ebp
8010522d:	c3                   	ret    
8010522e:	66 90                	xchg   %ax,%ax

80105230 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105236:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105244:	e8 37 f3 ff ff       	call   80104580 <argint>
80105249:	85 c0                	test   %eax,%eax
8010524b:	78 33                	js     80105280 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010524d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105250:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105257:	00 
80105258:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105263:	e8 58 f3 ff ff       	call   801045c0 <argptr>
80105268:	85 c0                	test   %eax,%eax
8010526a:	78 14                	js     80105280 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010526c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105276:	89 04 24             	mov    %eax,(%esp)
80105279:	e8 e2 1b 00 00       	call   80106e60 <shm_open>
}
8010527e:	c9                   	leave  
8010527f:	c3                   	ret    
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_shm_close>:

int sys_shm_close(void) {
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052a4:	e8 d7 f2 ff ff       	call   80104580 <argint>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801052ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 b8 1b 00 00       	call   80106e70 <shm_close>
}
801052b8:	c9                   	leave  
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_fork>:

int
sys_fork(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052d3:	5d                   	pop    %ebp
  return fork();
801052d4:	e9 c7 e5 ff ff       	jmp    801038a0 <fork>
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_exit>:

int
sys_exit(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052e6:	e8 05 e8 ff ff       	call   80103af0 <exit>
  return 0;  // not reached
}
801052eb:	31 c0                	xor    %eax,%eax
801052ed:	c9                   	leave  
801052ee:	c3                   	ret    
801052ef:	90                   	nop

801052f0 <sys_wait>:

int
sys_wait(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052f3:	5d                   	pop    %ebp
  return wait();
801052f4:	e9 07 ea ff ff       	jmp    80103d00 <wait>
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_kill>:

int
sys_kill(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105306:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010530d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105314:	e8 67 f2 ff ff       	call   80104580 <argint>
80105319:	85 c0                	test   %eax,%eax
8010531b:	78 13                	js     80105330 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010531d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105320:	89 04 24             	mov    %eax,(%esp)
80105323:	e8 18 eb ff ff       	call   80103e40 <kill>
}
80105328:	c9                   	leave  
80105329:	c3                   	ret    
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_getpid>:

int
sys_getpid(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105346:	e8 a5 e3 ff ff       	call   801036f0 <myproc>
8010534b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010534e:	c9                   	leave  
8010534f:	c3                   	ret    

80105350 <sys_sbrk>:

int
sys_sbrk(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	53                   	push   %ebx
80105354:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105357:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105365:	e8 16 f2 ff ff       	call   80104580 <argint>
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 22                	js     80105390 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010536e:	e8 7d e3 ff ff       	call   801036f0 <myproc>
  if(growproc(n) < 0)
80105373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105376:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105378:	89 14 24             	mov    %edx,(%esp)
8010537b:	e8 b0 e4 ff ff       	call   80103830 <growproc>
80105380:	85 c0                	test   %eax,%eax
80105382:	78 0c                	js     80105390 <sys_sbrk+0x40>
    return -1;
  return addr;
80105384:	89 d8                	mov    %ebx,%eax
}
80105386:	83 c4 24             	add    $0x24,%esp
80105389:	5b                   	pop    %ebx
8010538a:	5d                   	pop    %ebp
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105395:	eb ef                	jmp    80105386 <sys_sbrk+0x36>
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_sleep>:

int
sys_sleep(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801053a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053b5:	e8 c6 f1 ff ff       	call   80104580 <argint>
801053ba:	85 c0                	test   %eax,%eax
801053bc:	78 7e                	js     8010543c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053be:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053c5:	e8 c6 ed ff ff       	call   80104190 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053cd:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801053d3:	85 d2                	test   %edx,%edx
801053d5:	75 29                	jne    80105400 <sys_sleep+0x60>
801053d7:	eb 4f                	jmp    80105428 <sys_sleep+0x88>
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053e0:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
801053e7:	80 
801053e8:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
801053ef:	e8 5c e8 ff ff       	call   80103c50 <sleep>
  while(ticks - ticks0 < n){
801053f4:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801053f9:	29 d8                	sub    %ebx,%eax
801053fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053fe:	73 28                	jae    80105428 <sys_sleep+0x88>
    if(myproc()->killed){
80105400:	e8 eb e2 ff ff       	call   801036f0 <myproc>
80105405:	8b 40 24             	mov    0x24(%eax),%eax
80105408:	85 c0                	test   %eax,%eax
8010540a:	74 d4                	je     801053e0 <sys_sleep+0x40>
      release(&tickslock);
8010540c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105413:	e8 68 ee ff ff       	call   80104280 <release>
      return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010541d:	83 c4 24             	add    $0x24,%esp
80105420:	5b                   	pop    %ebx
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	90                   	nop
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105428:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010542f:	e8 4c ee ff ff       	call   80104280 <release>
}
80105434:	83 c4 24             	add    $0x24,%esp
  return 0;
80105437:	31 c0                	xor    %eax,%eax
}
80105439:	5b                   	pop    %ebx
8010543a:	5d                   	pop    %ebp
8010543b:	c3                   	ret    
    return -1;
8010543c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105441:	eb da                	jmp    8010541d <sys_sleep+0x7d>
80105443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105457:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010545e:	e8 2d ed ff ff       	call   80104190 <acquire>
  xticks = ticks;
80105463:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105469:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105470:	e8 0b ee ff ff       	call   80104280 <release>
  return xticks;
}
80105475:	83 c4 14             	add    $0x14,%esp
80105478:	89 d8                	mov    %ebx,%eax
8010547a:	5b                   	pop    %ebx
8010547b:	5d                   	pop    %ebp
8010547c:	c3                   	ret    

8010547d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010547d:	1e                   	push   %ds
  pushl %es
8010547e:	06                   	push   %es
  pushl %fs
8010547f:	0f a0                	push   %fs
  pushl %gs
80105481:	0f a8                	push   %gs
  pushal
80105483:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105484:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105488:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010548a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010548c:	54                   	push   %esp
  call trap
8010548d:	e8 de 00 00 00       	call   80105570 <trap>
  addl $4, %esp
80105492:	83 c4 04             	add    $0x4,%esp

80105495 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105495:	61                   	popa   
  popl %gs
80105496:	0f a9                	pop    %gs
  popl %fs
80105498:	0f a1                	pop    %fs
  popl %es
8010549a:	07                   	pop    %es
  popl %ds
8010549b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010549c:	83 c4 08             	add    $0x8,%esp
  iret
8010549f:	cf                   	iret   

801054a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801054a0:	31 c0                	xor    %eax,%eax
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801054a8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801054af:	b9 08 00 00 00       	mov    $0x8,%ecx
801054b4:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
801054bb:	80 
801054bc:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
801054c3:	00 
801054c4:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
801054cb:	8e 
801054cc:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801054d3:	80 
801054d4:	c1 ea 10             	shr    $0x10,%edx
801054d7:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801054de:	80 
  for(i = 0; i < 256; i++)
801054df:	83 c0 01             	add    $0x1,%eax
801054e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054e7:	75 bf                	jne    801054a8 <tvinit+0x8>
{
801054e9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054ea:	ba 08 00 00 00       	mov    $0x8,%edx
{
801054ef:	89 e5                	mov    %esp,%ebp
801054f1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054f4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054f9:	c7 44 24 04 21 76 10 	movl   $0x80107621,0x4(%esp)
80105500:	80 
80105501:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105508:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010550f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105515:	c1 e8 10             	shr    $0x10,%eax
80105518:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
8010551f:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105526:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010552c:	e8 6f eb ff ff       	call   801040a0 <initlock>
}
80105531:	c9                   	leave  
80105532:	c3                   	ret    
80105533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <idtinit>:

void
idtinit(void)
{
80105540:	55                   	push   %ebp
  pd[0] = size-1;
80105541:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105546:	89 e5                	mov    %esp,%ebp
80105548:	83 ec 10             	sub    $0x10,%esp
8010554b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010554f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105554:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105558:	c1 e8 10             	shr    $0x10,%eax
8010555b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010555f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105562:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
80105576:	83 ec 3c             	sub    $0x3c,%esp
80105579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010557c:	8b 43 30             	mov    0x30(%ebx),%eax
8010557f:	83 f8 40             	cmp    $0x40,%eax
80105582:	0f 84 c0 01 00 00    	je     80105748 <trap+0x1d8>
    return;
  }

  uint lowAddress, highAddress, faultyAddress;

  switch(tf->trapno){
80105588:	83 e8 0e             	sub    $0xe,%eax
8010558b:	83 f8 31             	cmp    $0x31,%eax
8010558e:	77 2c                	ja     801055bc <trap+0x4c>
80105590:	ff 24 85 e8 76 10 80 	jmp    *-0x7fef8918(,%eax,4)
80105597:	90                   	nop
  case T_PGFLT:
    highAddress = KERNBASE - (myproc()->userStack_pages*PGSIZE); //lab3
80105598:	e8 53 e1 ff ff       	call   801036f0 <myproc>
8010559d:	8b 40 7c             	mov    0x7c(%eax),%eax
801055a0:	f7 d8                	neg    %eax
801055a2:	c1 e0 0c             	shl    $0xc,%eax
801055a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    lowAddress = highAddress - PGSIZE; //lab3
801055ab:	8d b8 00 f0 ff 7f    	lea    0x7ffff000(%eax),%edi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801055b1:	0f 20 d2             	mov    %cr2,%edx
    faultyAddress = rcr2();

    if(faultyAddress > lowAddress && faultyAddress < highAddress)
801055b4:	39 d6                	cmp    %edx,%esi
801055b6:	0f 87 d4 01 00 00    	ja     80105790 <trap+0x220>
    break;

  //PAGEBREAK: 13
  Default:
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801055bc:	e8 2f e1 ff ff       	call   801036f0 <myproc>
801055c1:	85 c0                	test   %eax,%eax
801055c3:	0f 84 5f 02 00 00    	je     80105828 <trap+0x2b8>
801055c9:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801055cd:	0f 84 55 02 00 00    	je     80105828 <trap+0x2b8>
801055d3:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d6:	8b 53 38             	mov    0x38(%ebx),%edx
801055d9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
801055df:	e8 ec e0 ff ff       	call   801036d0 <cpuid>
801055e4:	8b 73 30             	mov    0x30(%ebx),%esi
801055e7:	89 c7                	mov    %eax,%edi
801055e9:	8b 43 34             	mov    0x34(%ebx),%eax
801055ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055ef:	e8 fc e0 ff ff       	call   801036f0 <myproc>
801055f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055f7:	e8 f4 e0 ff ff       	call   801036f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055fc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801055ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105603:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105606:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105609:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010560d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105610:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105614:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105617:	89 54 24 18          	mov    %edx,0x18(%esp)
8010561b:	89 7c 24 10          	mov    %edi,0x10(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
8010561f:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105623:	8b 40 10             	mov    0x10(%eax),%eax
80105626:	c7 04 24 a4 76 10 80 	movl   $0x801076a4,(%esp)
8010562d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105631:	e8 1a b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105636:	e8 b5 e0 ff ff       	call   801036f0 <myproc>
8010563b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105642:	e8 a9 e0 ff ff       	call   801036f0 <myproc>
80105647:	85 c0                	test   %eax,%eax
80105649:	74 0c                	je     80105657 <trap+0xe7>
8010564b:	e8 a0 e0 ff ff       	call   801036f0 <myproc>
80105650:	8b 50 24             	mov    0x24(%eax),%edx
80105653:	85 d2                	test   %edx,%edx
80105655:	75 49                	jne    801056a0 <trap+0x130>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105657:	e8 94 e0 ff ff       	call   801036f0 <myproc>
8010565c:	85 c0                	test   %eax,%eax
8010565e:	74 0b                	je     8010566b <trap+0xfb>
80105660:	e8 8b e0 ff ff       	call   801036f0 <myproc>
80105665:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105669:	74 4d                	je     801056b8 <trap+0x148>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010566b:	e8 80 e0 ff ff       	call   801036f0 <myproc>
80105670:	85 c0                	test   %eax,%eax
80105672:	74 1d                	je     80105691 <trap+0x121>
80105674:	e8 77 e0 ff ff       	call   801036f0 <myproc>
80105679:	8b 40 24             	mov    0x24(%eax),%eax
8010567c:	85 c0                	test   %eax,%eax
8010567e:	74 11                	je     80105691 <trap+0x121>
80105680:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105684:	83 e0 03             	and    $0x3,%eax
80105687:	66 83 f8 03          	cmp    $0x3,%ax
8010568b:	0f 84 ec 00 00 00    	je     8010577d <trap+0x20d>
    exit();
}
80105691:	83 c4 3c             	add    $0x3c,%esp
80105694:	5b                   	pop    %ebx
80105695:	5e                   	pop    %esi
80105696:	5f                   	pop    %edi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056a0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056a4:	83 e0 03             	and    $0x3,%eax
801056a7:	66 83 f8 03          	cmp    $0x3,%ax
801056ab:	75 aa                	jne    80105657 <trap+0xe7>
    exit();
801056ad:	e8 3e e4 ff ff       	call   80103af0 <exit>
801056b2:	eb a3                	jmp    80105657 <trap+0xe7>
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801056b8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c0:	75 a9                	jne    8010566b <trap+0xfb>
    yield();
801056c2:	e8 49 e5 ff ff       	call   80103c10 <yield>
801056c7:	eb a2                	jmp    8010566b <trap+0xfb>
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801056d0:	e8 fb df ff ff       	call   801036d0 <cpuid>
801056d5:	85 c0                	test   %eax,%eax
801056d7:	0f 84 1b 01 00 00    	je     801057f8 <trap+0x288>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
801056e0:	e8 eb d0 ff ff       	call   801027d0 <lapiceoi>
    break;
801056e5:	e9 58 ff ff ff       	jmp    80105642 <trap+0xd2>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801056f0:	e8 2b cf ff ff       	call   80102620 <kbdintr>
    lapiceoi();
801056f5:	e8 d6 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
801056fa:	e9 43 ff ff ff       	jmp    80105642 <trap+0xd2>
801056ff:	90                   	nop
    uartintr();
80105700:	e8 7b 02 00 00       	call   80105980 <uartintr>
    lapiceoi();
80105705:	e8 c6 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
8010570a:	e9 33 ff ff ff       	jmp    80105642 <trap+0xd2>
8010570f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105710:	8b 7b 38             	mov    0x38(%ebx),%edi
80105713:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105717:	e8 b4 df ff ff       	call   801036d0 <cpuid>
8010571c:	c7 04 24 4c 76 10 80 	movl   $0x8010764c,(%esp)
80105723:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105727:	89 74 24 08          	mov    %esi,0x8(%esp)
8010572b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010572f:	e8 1c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105734:	e8 97 d0 ff ff       	call   801027d0 <lapiceoi>
    break;
80105739:	e9 04 ff ff ff       	jmp    80105642 <trap+0xd2>
8010573e:	66 90                	xchg   %ax,%ax
    ideintr();
80105740:	e8 8b c9 ff ff       	call   801020d0 <ideintr>
80105745:	eb 96                	jmp    801056dd <trap+0x16d>
80105747:	90                   	nop
80105748:	90                   	nop
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105750:	e8 9b df ff ff       	call   801036f0 <myproc>
80105755:	8b 70 24             	mov    0x24(%eax),%esi
80105758:	85 f6                	test   %esi,%esi
8010575a:	0f 85 88 00 00 00    	jne    801057e8 <trap+0x278>
    myproc()->tf = tf;
80105760:	e8 8b df ff ff       	call   801036f0 <myproc>
80105765:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105768:	e8 13 ef ff ff       	call   80104680 <syscall>
    if(myproc()->killed)
8010576d:	e8 7e df ff ff       	call   801036f0 <myproc>
80105772:	8b 48 24             	mov    0x24(%eax),%ecx
80105775:	85 c9                	test   %ecx,%ecx
80105777:	0f 84 14 ff ff ff    	je     80105691 <trap+0x121>
}
8010577d:	83 c4 3c             	add    $0x3c,%esp
80105780:	5b                   	pop    %ebx
80105781:	5e                   	pop    %esi
80105782:	5f                   	pop    %edi
80105783:	5d                   	pop    %ebp
      exit();
80105784:	e9 67 e3 ff ff       	jmp    80103af0 <exit>
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(faultyAddress > lowAddress && faultyAddress < highAddress)
80105790:	39 d7                	cmp    %edx,%edi
80105792:	0f 83 24 fe ff ff    	jae    801055bc <trap+0x4c>
      if(!allocuvm(myproc()->pgdir, lowAddress, highAddress)) //lab3
80105798:	e8 53 df ff ff       	call   801036f0 <myproc>
8010579d:	89 74 24 08          	mov    %esi,0x8(%esp)
801057a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
801057a5:	8b 40 04             	mov    0x4(%eax),%eax
801057a8:	89 04 24             	mov    %eax,(%esp)
801057ab:	e8 50 11 00 00       	call   80106900 <allocuvm>
801057b0:	85 c0                	test   %eax,%eax
801057b2:	0f 84 04 fe ff ff    	je     801055bc <trap+0x4c>
      myproc()->userStack_pages++;
801057b8:	e8 33 df ff ff       	call   801036f0 <myproc>
801057bd:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
      cprintf("Current top of user stack: %x\n", KERNBASE -(myproc()->userStack_pages*PGSIZE));
801057c1:	e8 2a df ff ff       	call   801036f0 <myproc>
801057c6:	8b 40 7c             	mov    0x7c(%eax),%eax
801057c9:	c7 04 24 2c 76 10 80 	movl   $0x8010762c,(%esp)
801057d0:	f7 d8                	neg    %eax
801057d2:	c1 e0 0c             	shl    $0xc,%eax
801057d5:	05 00 00 00 80       	add    $0x80000000,%eax
801057da:	89 44 24 04          	mov    %eax,0x4(%esp)
801057de:	e8 6d ae ff ff       	call   80100650 <cprintf>
    break;
801057e3:	e9 5a fe ff ff       	jmp    80105642 <trap+0xd2>
      exit();
801057e8:	e8 03 e3 ff ff       	call   80103af0 <exit>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
801057f0:	e9 6b ff ff ff       	jmp    80105760 <trap+0x1f0>
801057f5:	8d 76 00             	lea    0x0(%esi),%esi
      acquire(&tickslock);
801057f8:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801057ff:	e8 8c e9 ff ff       	call   80104190 <acquire>
      wakeup(&ticks);
80105804:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
8010580b:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105812:	e8 c9 e5 ff ff       	call   80103de0 <wakeup>
      release(&tickslock);
80105817:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010581e:	e8 5d ea ff ff       	call   80104280 <release>
80105823:	e9 b5 fe ff ff       	jmp    801056dd <trap+0x16d>
80105828:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010582b:	8b 73 38             	mov    0x38(%ebx),%esi
8010582e:	e8 9d de ff ff       	call   801036d0 <cpuid>
80105833:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105837:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010583b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010583f:	8b 43 30             	mov    0x30(%ebx),%eax
80105842:	c7 04 24 70 76 10 80 	movl   $0x80107670,(%esp)
80105849:	89 44 24 04          	mov    %eax,0x4(%esp)
8010584d:	e8 fe ad ff ff       	call   80100650 <cprintf>
      panic("trap");
80105852:	c7 04 24 26 76 10 80 	movl   $0x80107626,(%esp)
80105859:	e8 02 ab ff ff       	call   80100360 <panic>
8010585e:	66 90                	xchg   %ax,%ax

80105860 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105860:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105865:	55                   	push   %ebp
80105866:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105868:	85 c0                	test   %eax,%eax
8010586a:	74 14                	je     80105880 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010586c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105871:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105872:	a8 01                	test   $0x1,%al
80105874:	74 0a                	je     80105880 <uartgetc+0x20>
80105876:	b2 f8                	mov    $0xf8,%dl
80105878:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105879:	0f b6 c0             	movzbl %al,%eax
}
8010587c:	5d                   	pop    %ebp
8010587d:	c3                   	ret    
8010587e:	66 90                	xchg   %ax,%ax
    return -1;
80105880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105885:	5d                   	pop    %ebp
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <uartputc>:
  if(!uart)
80105890:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105895:	85 c0                	test   %eax,%eax
80105897:	74 3f                	je     801058d8 <uartputc+0x48>
{
80105899:	55                   	push   %ebp
8010589a:	89 e5                	mov    %esp,%ebp
8010589c:	56                   	push   %esi
8010589d:	be fd 03 00 00       	mov    $0x3fd,%esi
801058a2:	53                   	push   %ebx
  if(!uart)
801058a3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801058a8:	83 ec 10             	sub    $0x10,%esp
801058ab:	eb 14                	jmp    801058c1 <uartputc+0x31>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801058b0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801058b7:	e8 34 cf ff ff       	call   801027f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058bc:	83 eb 01             	sub    $0x1,%ebx
801058bf:	74 07                	je     801058c8 <uartputc+0x38>
801058c1:	89 f2                	mov    %esi,%edx
801058c3:	ec                   	in     (%dx),%al
801058c4:	a8 20                	test   $0x20,%al
801058c6:	74 e8                	je     801058b0 <uartputc+0x20>
  outb(COM1+0, c);
801058c8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058cc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058d1:	ee                   	out    %al,(%dx)
}
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	5b                   	pop    %ebx
801058d6:	5e                   	pop    %esi
801058d7:	5d                   	pop    %ebp
801058d8:	f3 c3                	repz ret 
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <uartinit>:
{
801058e0:	55                   	push   %ebp
801058e1:	31 c9                	xor    %ecx,%ecx
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	89 c8                	mov    %ecx,%eax
801058e7:	57                   	push   %edi
801058e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058ed:	56                   	push   %esi
801058ee:	89 fa                	mov    %edi,%edx
801058f0:	53                   	push   %ebx
801058f1:	83 ec 1c             	sub    $0x1c,%esp
801058f4:	ee                   	out    %al,(%dx)
801058f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801058fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058ff:	89 f2                	mov    %esi,%edx
80105901:	ee                   	out    %al,(%dx)
80105902:	b8 0c 00 00 00       	mov    $0xc,%eax
80105907:	b2 f8                	mov    $0xf8,%dl
80105909:	ee                   	out    %al,(%dx)
8010590a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010590f:	89 c8                	mov    %ecx,%eax
80105911:	89 da                	mov    %ebx,%edx
80105913:	ee                   	out    %al,(%dx)
80105914:	b8 03 00 00 00       	mov    $0x3,%eax
80105919:	89 f2                	mov    %esi,%edx
8010591b:	ee                   	out    %al,(%dx)
8010591c:	b2 fc                	mov    $0xfc,%dl
8010591e:	89 c8                	mov    %ecx,%eax
80105920:	ee                   	out    %al,(%dx)
80105921:	b8 01 00 00 00       	mov    $0x1,%eax
80105926:	89 da                	mov    %ebx,%edx
80105928:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105929:	b2 fd                	mov    $0xfd,%dl
8010592b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010592c:	3c ff                	cmp    $0xff,%al
8010592e:	74 42                	je     80105972 <uartinit+0x92>
  uart = 1;
80105930:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105937:	00 00 00 
8010593a:	89 fa                	mov    %edi,%edx
8010593c:	ec                   	in     (%dx),%al
8010593d:	b2 f8                	mov    $0xf8,%dl
8010593f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105940:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105947:	00 
  for(p="xv6...\n"; *p; p++)
80105948:	bb b0 77 10 80       	mov    $0x801077b0,%ebx
  ioapicenable(IRQ_COM1, 0);
8010594d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105954:	e8 a7 c9 ff ff       	call   80102300 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105959:	b8 78 00 00 00       	mov    $0x78,%eax
8010595e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105960:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105963:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105966:	e8 25 ff ff ff       	call   80105890 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010596b:	0f be 03             	movsbl (%ebx),%eax
8010596e:	84 c0                	test   %al,%al
80105970:	75 ee                	jne    80105960 <uartinit+0x80>
}
80105972:	83 c4 1c             	add    $0x1c,%esp
80105975:	5b                   	pop    %ebx
80105976:	5e                   	pop    %esi
80105977:	5f                   	pop    %edi
80105978:	5d                   	pop    %ebp
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105980 <uartintr>:

void
uartintr(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105986:	c7 04 24 60 58 10 80 	movl   $0x80105860,(%esp)
8010598d:	e8 1e ae ff ff       	call   801007b0 <consoleintr>
}
80105992:	c9                   	leave  
80105993:	c3                   	ret    

80105994 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105994:	6a 00                	push   $0x0
  pushl $0
80105996:	6a 00                	push   $0x0
  jmp alltraps
80105998:	e9 e0 fa ff ff       	jmp    8010547d <alltraps>

8010599d <vector1>:
.globl vector1
vector1:
  pushl $0
8010599d:	6a 00                	push   $0x0
  pushl $1
8010599f:	6a 01                	push   $0x1
  jmp alltraps
801059a1:	e9 d7 fa ff ff       	jmp    8010547d <alltraps>

801059a6 <vector2>:
.globl vector2
vector2:
  pushl $0
801059a6:	6a 00                	push   $0x0
  pushl $2
801059a8:	6a 02                	push   $0x2
  jmp alltraps
801059aa:	e9 ce fa ff ff       	jmp    8010547d <alltraps>

801059af <vector3>:
.globl vector3
vector3:
  pushl $0
801059af:	6a 00                	push   $0x0
  pushl $3
801059b1:	6a 03                	push   $0x3
  jmp alltraps
801059b3:	e9 c5 fa ff ff       	jmp    8010547d <alltraps>

801059b8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $4
801059ba:	6a 04                	push   $0x4
  jmp alltraps
801059bc:	e9 bc fa ff ff       	jmp    8010547d <alltraps>

801059c1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059c1:	6a 00                	push   $0x0
  pushl $5
801059c3:	6a 05                	push   $0x5
  jmp alltraps
801059c5:	e9 b3 fa ff ff       	jmp    8010547d <alltraps>

801059ca <vector6>:
.globl vector6
vector6:
  pushl $0
801059ca:	6a 00                	push   $0x0
  pushl $6
801059cc:	6a 06                	push   $0x6
  jmp alltraps
801059ce:	e9 aa fa ff ff       	jmp    8010547d <alltraps>

801059d3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $7
801059d5:	6a 07                	push   $0x7
  jmp alltraps
801059d7:	e9 a1 fa ff ff       	jmp    8010547d <alltraps>

801059dc <vector8>:
.globl vector8
vector8:
  pushl $8
801059dc:	6a 08                	push   $0x8
  jmp alltraps
801059de:	e9 9a fa ff ff       	jmp    8010547d <alltraps>

801059e3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $9
801059e5:	6a 09                	push   $0x9
  jmp alltraps
801059e7:	e9 91 fa ff ff       	jmp    8010547d <alltraps>

801059ec <vector10>:
.globl vector10
vector10:
  pushl $10
801059ec:	6a 0a                	push   $0xa
  jmp alltraps
801059ee:	e9 8a fa ff ff       	jmp    8010547d <alltraps>

801059f3 <vector11>:
.globl vector11
vector11:
  pushl $11
801059f3:	6a 0b                	push   $0xb
  jmp alltraps
801059f5:	e9 83 fa ff ff       	jmp    8010547d <alltraps>

801059fa <vector12>:
.globl vector12
vector12:
  pushl $12
801059fa:	6a 0c                	push   $0xc
  jmp alltraps
801059fc:	e9 7c fa ff ff       	jmp    8010547d <alltraps>

80105a01 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a01:	6a 0d                	push   $0xd
  jmp alltraps
80105a03:	e9 75 fa ff ff       	jmp    8010547d <alltraps>

80105a08 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a08:	6a 0e                	push   $0xe
  jmp alltraps
80105a0a:	e9 6e fa ff ff       	jmp    8010547d <alltraps>

80105a0f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $15
80105a11:	6a 0f                	push   $0xf
  jmp alltraps
80105a13:	e9 65 fa ff ff       	jmp    8010547d <alltraps>

80105a18 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $16
80105a1a:	6a 10                	push   $0x10
  jmp alltraps
80105a1c:	e9 5c fa ff ff       	jmp    8010547d <alltraps>

80105a21 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a21:	6a 11                	push   $0x11
  jmp alltraps
80105a23:	e9 55 fa ff ff       	jmp    8010547d <alltraps>

80105a28 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $18
80105a2a:	6a 12                	push   $0x12
  jmp alltraps
80105a2c:	e9 4c fa ff ff       	jmp    8010547d <alltraps>

80105a31 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $19
80105a33:	6a 13                	push   $0x13
  jmp alltraps
80105a35:	e9 43 fa ff ff       	jmp    8010547d <alltraps>

80105a3a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $20
80105a3c:	6a 14                	push   $0x14
  jmp alltraps
80105a3e:	e9 3a fa ff ff       	jmp    8010547d <alltraps>

80105a43 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $21
80105a45:	6a 15                	push   $0x15
  jmp alltraps
80105a47:	e9 31 fa ff ff       	jmp    8010547d <alltraps>

80105a4c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $22
80105a4e:	6a 16                	push   $0x16
  jmp alltraps
80105a50:	e9 28 fa ff ff       	jmp    8010547d <alltraps>

80105a55 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $23
80105a57:	6a 17                	push   $0x17
  jmp alltraps
80105a59:	e9 1f fa ff ff       	jmp    8010547d <alltraps>

80105a5e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $24
80105a60:	6a 18                	push   $0x18
  jmp alltraps
80105a62:	e9 16 fa ff ff       	jmp    8010547d <alltraps>

80105a67 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $25
80105a69:	6a 19                	push   $0x19
  jmp alltraps
80105a6b:	e9 0d fa ff ff       	jmp    8010547d <alltraps>

80105a70 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $26
80105a72:	6a 1a                	push   $0x1a
  jmp alltraps
80105a74:	e9 04 fa ff ff       	jmp    8010547d <alltraps>

80105a79 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $27
80105a7b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a7d:	e9 fb f9 ff ff       	jmp    8010547d <alltraps>

80105a82 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $28
80105a84:	6a 1c                	push   $0x1c
  jmp alltraps
80105a86:	e9 f2 f9 ff ff       	jmp    8010547d <alltraps>

80105a8b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $29
80105a8d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a8f:	e9 e9 f9 ff ff       	jmp    8010547d <alltraps>

80105a94 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $30
80105a96:	6a 1e                	push   $0x1e
  jmp alltraps
80105a98:	e9 e0 f9 ff ff       	jmp    8010547d <alltraps>

80105a9d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $31
80105a9f:	6a 1f                	push   $0x1f
  jmp alltraps
80105aa1:	e9 d7 f9 ff ff       	jmp    8010547d <alltraps>

80105aa6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $32
80105aa8:	6a 20                	push   $0x20
  jmp alltraps
80105aaa:	e9 ce f9 ff ff       	jmp    8010547d <alltraps>

80105aaf <vector33>:
.globl vector33
vector33:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $33
80105ab1:	6a 21                	push   $0x21
  jmp alltraps
80105ab3:	e9 c5 f9 ff ff       	jmp    8010547d <alltraps>

80105ab8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $34
80105aba:	6a 22                	push   $0x22
  jmp alltraps
80105abc:	e9 bc f9 ff ff       	jmp    8010547d <alltraps>

80105ac1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $35
80105ac3:	6a 23                	push   $0x23
  jmp alltraps
80105ac5:	e9 b3 f9 ff ff       	jmp    8010547d <alltraps>

80105aca <vector36>:
.globl vector36
vector36:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $36
80105acc:	6a 24                	push   $0x24
  jmp alltraps
80105ace:	e9 aa f9 ff ff       	jmp    8010547d <alltraps>

80105ad3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $37
80105ad5:	6a 25                	push   $0x25
  jmp alltraps
80105ad7:	e9 a1 f9 ff ff       	jmp    8010547d <alltraps>

80105adc <vector38>:
.globl vector38
vector38:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $38
80105ade:	6a 26                	push   $0x26
  jmp alltraps
80105ae0:	e9 98 f9 ff ff       	jmp    8010547d <alltraps>

80105ae5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $39
80105ae7:	6a 27                	push   $0x27
  jmp alltraps
80105ae9:	e9 8f f9 ff ff       	jmp    8010547d <alltraps>

80105aee <vector40>:
.globl vector40
vector40:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $40
80105af0:	6a 28                	push   $0x28
  jmp alltraps
80105af2:	e9 86 f9 ff ff       	jmp    8010547d <alltraps>

80105af7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $41
80105af9:	6a 29                	push   $0x29
  jmp alltraps
80105afb:	e9 7d f9 ff ff       	jmp    8010547d <alltraps>

80105b00 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $42
80105b02:	6a 2a                	push   $0x2a
  jmp alltraps
80105b04:	e9 74 f9 ff ff       	jmp    8010547d <alltraps>

80105b09 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $43
80105b0b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b0d:	e9 6b f9 ff ff       	jmp    8010547d <alltraps>

80105b12 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $44
80105b14:	6a 2c                	push   $0x2c
  jmp alltraps
80105b16:	e9 62 f9 ff ff       	jmp    8010547d <alltraps>

80105b1b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $45
80105b1d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b1f:	e9 59 f9 ff ff       	jmp    8010547d <alltraps>

80105b24 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $46
80105b26:	6a 2e                	push   $0x2e
  jmp alltraps
80105b28:	e9 50 f9 ff ff       	jmp    8010547d <alltraps>

80105b2d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $47
80105b2f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b31:	e9 47 f9 ff ff       	jmp    8010547d <alltraps>

80105b36 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $48
80105b38:	6a 30                	push   $0x30
  jmp alltraps
80105b3a:	e9 3e f9 ff ff       	jmp    8010547d <alltraps>

80105b3f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $49
80105b41:	6a 31                	push   $0x31
  jmp alltraps
80105b43:	e9 35 f9 ff ff       	jmp    8010547d <alltraps>

80105b48 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $50
80105b4a:	6a 32                	push   $0x32
  jmp alltraps
80105b4c:	e9 2c f9 ff ff       	jmp    8010547d <alltraps>

80105b51 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $51
80105b53:	6a 33                	push   $0x33
  jmp alltraps
80105b55:	e9 23 f9 ff ff       	jmp    8010547d <alltraps>

80105b5a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $52
80105b5c:	6a 34                	push   $0x34
  jmp alltraps
80105b5e:	e9 1a f9 ff ff       	jmp    8010547d <alltraps>

80105b63 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $53
80105b65:	6a 35                	push   $0x35
  jmp alltraps
80105b67:	e9 11 f9 ff ff       	jmp    8010547d <alltraps>

80105b6c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $54
80105b6e:	6a 36                	push   $0x36
  jmp alltraps
80105b70:	e9 08 f9 ff ff       	jmp    8010547d <alltraps>

80105b75 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $55
80105b77:	6a 37                	push   $0x37
  jmp alltraps
80105b79:	e9 ff f8 ff ff       	jmp    8010547d <alltraps>

80105b7e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $56
80105b80:	6a 38                	push   $0x38
  jmp alltraps
80105b82:	e9 f6 f8 ff ff       	jmp    8010547d <alltraps>

80105b87 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $57
80105b89:	6a 39                	push   $0x39
  jmp alltraps
80105b8b:	e9 ed f8 ff ff       	jmp    8010547d <alltraps>

80105b90 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $58
80105b92:	6a 3a                	push   $0x3a
  jmp alltraps
80105b94:	e9 e4 f8 ff ff       	jmp    8010547d <alltraps>

80105b99 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $59
80105b9b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b9d:	e9 db f8 ff ff       	jmp    8010547d <alltraps>

80105ba2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $60
80105ba4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ba6:	e9 d2 f8 ff ff       	jmp    8010547d <alltraps>

80105bab <vector61>:
.globl vector61
vector61:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $61
80105bad:	6a 3d                	push   $0x3d
  jmp alltraps
80105baf:	e9 c9 f8 ff ff       	jmp    8010547d <alltraps>

80105bb4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $62
80105bb6:	6a 3e                	push   $0x3e
  jmp alltraps
80105bb8:	e9 c0 f8 ff ff       	jmp    8010547d <alltraps>

80105bbd <vector63>:
.globl vector63
vector63:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $63
80105bbf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bc1:	e9 b7 f8 ff ff       	jmp    8010547d <alltraps>

80105bc6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $64
80105bc8:	6a 40                	push   $0x40
  jmp alltraps
80105bca:	e9 ae f8 ff ff       	jmp    8010547d <alltraps>

80105bcf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $65
80105bd1:	6a 41                	push   $0x41
  jmp alltraps
80105bd3:	e9 a5 f8 ff ff       	jmp    8010547d <alltraps>

80105bd8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $66
80105bda:	6a 42                	push   $0x42
  jmp alltraps
80105bdc:	e9 9c f8 ff ff       	jmp    8010547d <alltraps>

80105be1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $67
80105be3:	6a 43                	push   $0x43
  jmp alltraps
80105be5:	e9 93 f8 ff ff       	jmp    8010547d <alltraps>

80105bea <vector68>:
.globl vector68
vector68:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $68
80105bec:	6a 44                	push   $0x44
  jmp alltraps
80105bee:	e9 8a f8 ff ff       	jmp    8010547d <alltraps>

80105bf3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $69
80105bf5:	6a 45                	push   $0x45
  jmp alltraps
80105bf7:	e9 81 f8 ff ff       	jmp    8010547d <alltraps>

80105bfc <vector70>:
.globl vector70
vector70:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $70
80105bfe:	6a 46                	push   $0x46
  jmp alltraps
80105c00:	e9 78 f8 ff ff       	jmp    8010547d <alltraps>

80105c05 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $71
80105c07:	6a 47                	push   $0x47
  jmp alltraps
80105c09:	e9 6f f8 ff ff       	jmp    8010547d <alltraps>

80105c0e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $72
80105c10:	6a 48                	push   $0x48
  jmp alltraps
80105c12:	e9 66 f8 ff ff       	jmp    8010547d <alltraps>

80105c17 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $73
80105c19:	6a 49                	push   $0x49
  jmp alltraps
80105c1b:	e9 5d f8 ff ff       	jmp    8010547d <alltraps>

80105c20 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $74
80105c22:	6a 4a                	push   $0x4a
  jmp alltraps
80105c24:	e9 54 f8 ff ff       	jmp    8010547d <alltraps>

80105c29 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $75
80105c2b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c2d:	e9 4b f8 ff ff       	jmp    8010547d <alltraps>

80105c32 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $76
80105c34:	6a 4c                	push   $0x4c
  jmp alltraps
80105c36:	e9 42 f8 ff ff       	jmp    8010547d <alltraps>

80105c3b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $77
80105c3d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c3f:	e9 39 f8 ff ff       	jmp    8010547d <alltraps>

80105c44 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $78
80105c46:	6a 4e                	push   $0x4e
  jmp alltraps
80105c48:	e9 30 f8 ff ff       	jmp    8010547d <alltraps>

80105c4d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $79
80105c4f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c51:	e9 27 f8 ff ff       	jmp    8010547d <alltraps>

80105c56 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $80
80105c58:	6a 50                	push   $0x50
  jmp alltraps
80105c5a:	e9 1e f8 ff ff       	jmp    8010547d <alltraps>

80105c5f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $81
80105c61:	6a 51                	push   $0x51
  jmp alltraps
80105c63:	e9 15 f8 ff ff       	jmp    8010547d <alltraps>

80105c68 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $82
80105c6a:	6a 52                	push   $0x52
  jmp alltraps
80105c6c:	e9 0c f8 ff ff       	jmp    8010547d <alltraps>

80105c71 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $83
80105c73:	6a 53                	push   $0x53
  jmp alltraps
80105c75:	e9 03 f8 ff ff       	jmp    8010547d <alltraps>

80105c7a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $84
80105c7c:	6a 54                	push   $0x54
  jmp alltraps
80105c7e:	e9 fa f7 ff ff       	jmp    8010547d <alltraps>

80105c83 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $85
80105c85:	6a 55                	push   $0x55
  jmp alltraps
80105c87:	e9 f1 f7 ff ff       	jmp    8010547d <alltraps>

80105c8c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $86
80105c8e:	6a 56                	push   $0x56
  jmp alltraps
80105c90:	e9 e8 f7 ff ff       	jmp    8010547d <alltraps>

80105c95 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $87
80105c97:	6a 57                	push   $0x57
  jmp alltraps
80105c99:	e9 df f7 ff ff       	jmp    8010547d <alltraps>

80105c9e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $88
80105ca0:	6a 58                	push   $0x58
  jmp alltraps
80105ca2:	e9 d6 f7 ff ff       	jmp    8010547d <alltraps>

80105ca7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $89
80105ca9:	6a 59                	push   $0x59
  jmp alltraps
80105cab:	e9 cd f7 ff ff       	jmp    8010547d <alltraps>

80105cb0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $90
80105cb2:	6a 5a                	push   $0x5a
  jmp alltraps
80105cb4:	e9 c4 f7 ff ff       	jmp    8010547d <alltraps>

80105cb9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $91
80105cbb:	6a 5b                	push   $0x5b
  jmp alltraps
80105cbd:	e9 bb f7 ff ff       	jmp    8010547d <alltraps>

80105cc2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $92
80105cc4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cc6:	e9 b2 f7 ff ff       	jmp    8010547d <alltraps>

80105ccb <vector93>:
.globl vector93
vector93:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $93
80105ccd:	6a 5d                	push   $0x5d
  jmp alltraps
80105ccf:	e9 a9 f7 ff ff       	jmp    8010547d <alltraps>

80105cd4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $94
80105cd6:	6a 5e                	push   $0x5e
  jmp alltraps
80105cd8:	e9 a0 f7 ff ff       	jmp    8010547d <alltraps>

80105cdd <vector95>:
.globl vector95
vector95:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $95
80105cdf:	6a 5f                	push   $0x5f
  jmp alltraps
80105ce1:	e9 97 f7 ff ff       	jmp    8010547d <alltraps>

80105ce6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $96
80105ce8:	6a 60                	push   $0x60
  jmp alltraps
80105cea:	e9 8e f7 ff ff       	jmp    8010547d <alltraps>

80105cef <vector97>:
.globl vector97
vector97:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $97
80105cf1:	6a 61                	push   $0x61
  jmp alltraps
80105cf3:	e9 85 f7 ff ff       	jmp    8010547d <alltraps>

80105cf8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $98
80105cfa:	6a 62                	push   $0x62
  jmp alltraps
80105cfc:	e9 7c f7 ff ff       	jmp    8010547d <alltraps>

80105d01 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $99
80105d03:	6a 63                	push   $0x63
  jmp alltraps
80105d05:	e9 73 f7 ff ff       	jmp    8010547d <alltraps>

80105d0a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $100
80105d0c:	6a 64                	push   $0x64
  jmp alltraps
80105d0e:	e9 6a f7 ff ff       	jmp    8010547d <alltraps>

80105d13 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $101
80105d15:	6a 65                	push   $0x65
  jmp alltraps
80105d17:	e9 61 f7 ff ff       	jmp    8010547d <alltraps>

80105d1c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $102
80105d1e:	6a 66                	push   $0x66
  jmp alltraps
80105d20:	e9 58 f7 ff ff       	jmp    8010547d <alltraps>

80105d25 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $103
80105d27:	6a 67                	push   $0x67
  jmp alltraps
80105d29:	e9 4f f7 ff ff       	jmp    8010547d <alltraps>

80105d2e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $104
80105d30:	6a 68                	push   $0x68
  jmp alltraps
80105d32:	e9 46 f7 ff ff       	jmp    8010547d <alltraps>

80105d37 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $105
80105d39:	6a 69                	push   $0x69
  jmp alltraps
80105d3b:	e9 3d f7 ff ff       	jmp    8010547d <alltraps>

80105d40 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $106
80105d42:	6a 6a                	push   $0x6a
  jmp alltraps
80105d44:	e9 34 f7 ff ff       	jmp    8010547d <alltraps>

80105d49 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $107
80105d4b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d4d:	e9 2b f7 ff ff       	jmp    8010547d <alltraps>

80105d52 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $108
80105d54:	6a 6c                	push   $0x6c
  jmp alltraps
80105d56:	e9 22 f7 ff ff       	jmp    8010547d <alltraps>

80105d5b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $109
80105d5d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d5f:	e9 19 f7 ff ff       	jmp    8010547d <alltraps>

80105d64 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $110
80105d66:	6a 6e                	push   $0x6e
  jmp alltraps
80105d68:	e9 10 f7 ff ff       	jmp    8010547d <alltraps>

80105d6d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $111
80105d6f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d71:	e9 07 f7 ff ff       	jmp    8010547d <alltraps>

80105d76 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $112
80105d78:	6a 70                	push   $0x70
  jmp alltraps
80105d7a:	e9 fe f6 ff ff       	jmp    8010547d <alltraps>

80105d7f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $113
80105d81:	6a 71                	push   $0x71
  jmp alltraps
80105d83:	e9 f5 f6 ff ff       	jmp    8010547d <alltraps>

80105d88 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $114
80105d8a:	6a 72                	push   $0x72
  jmp alltraps
80105d8c:	e9 ec f6 ff ff       	jmp    8010547d <alltraps>

80105d91 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $115
80105d93:	6a 73                	push   $0x73
  jmp alltraps
80105d95:	e9 e3 f6 ff ff       	jmp    8010547d <alltraps>

80105d9a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $116
80105d9c:	6a 74                	push   $0x74
  jmp alltraps
80105d9e:	e9 da f6 ff ff       	jmp    8010547d <alltraps>

80105da3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $117
80105da5:	6a 75                	push   $0x75
  jmp alltraps
80105da7:	e9 d1 f6 ff ff       	jmp    8010547d <alltraps>

80105dac <vector118>:
.globl vector118
vector118:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $118
80105dae:	6a 76                	push   $0x76
  jmp alltraps
80105db0:	e9 c8 f6 ff ff       	jmp    8010547d <alltraps>

80105db5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $119
80105db7:	6a 77                	push   $0x77
  jmp alltraps
80105db9:	e9 bf f6 ff ff       	jmp    8010547d <alltraps>

80105dbe <vector120>:
.globl vector120
vector120:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $120
80105dc0:	6a 78                	push   $0x78
  jmp alltraps
80105dc2:	e9 b6 f6 ff ff       	jmp    8010547d <alltraps>

80105dc7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $121
80105dc9:	6a 79                	push   $0x79
  jmp alltraps
80105dcb:	e9 ad f6 ff ff       	jmp    8010547d <alltraps>

80105dd0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $122
80105dd2:	6a 7a                	push   $0x7a
  jmp alltraps
80105dd4:	e9 a4 f6 ff ff       	jmp    8010547d <alltraps>

80105dd9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $123
80105ddb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ddd:	e9 9b f6 ff ff       	jmp    8010547d <alltraps>

80105de2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $124
80105de4:	6a 7c                	push   $0x7c
  jmp alltraps
80105de6:	e9 92 f6 ff ff       	jmp    8010547d <alltraps>

80105deb <vector125>:
.globl vector125
vector125:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $125
80105ded:	6a 7d                	push   $0x7d
  jmp alltraps
80105def:	e9 89 f6 ff ff       	jmp    8010547d <alltraps>

80105df4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $126
80105df6:	6a 7e                	push   $0x7e
  jmp alltraps
80105df8:	e9 80 f6 ff ff       	jmp    8010547d <alltraps>

80105dfd <vector127>:
.globl vector127
vector127:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $127
80105dff:	6a 7f                	push   $0x7f
  jmp alltraps
80105e01:	e9 77 f6 ff ff       	jmp    8010547d <alltraps>

80105e06 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $128
80105e08:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e0d:	e9 6b f6 ff ff       	jmp    8010547d <alltraps>

80105e12 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $129
80105e14:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e19:	e9 5f f6 ff ff       	jmp    8010547d <alltraps>

80105e1e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $130
80105e20:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e25:	e9 53 f6 ff ff       	jmp    8010547d <alltraps>

80105e2a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $131
80105e2c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e31:	e9 47 f6 ff ff       	jmp    8010547d <alltraps>

80105e36 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $132
80105e38:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e3d:	e9 3b f6 ff ff       	jmp    8010547d <alltraps>

80105e42 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $133
80105e44:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e49:	e9 2f f6 ff ff       	jmp    8010547d <alltraps>

80105e4e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $134
80105e50:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e55:	e9 23 f6 ff ff       	jmp    8010547d <alltraps>

80105e5a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $135
80105e5c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e61:	e9 17 f6 ff ff       	jmp    8010547d <alltraps>

80105e66 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $136
80105e68:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e6d:	e9 0b f6 ff ff       	jmp    8010547d <alltraps>

80105e72 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $137
80105e74:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e79:	e9 ff f5 ff ff       	jmp    8010547d <alltraps>

80105e7e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $138
80105e80:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e85:	e9 f3 f5 ff ff       	jmp    8010547d <alltraps>

80105e8a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $139
80105e8c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e91:	e9 e7 f5 ff ff       	jmp    8010547d <alltraps>

80105e96 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $140
80105e98:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e9d:	e9 db f5 ff ff       	jmp    8010547d <alltraps>

80105ea2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $141
80105ea4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105ea9:	e9 cf f5 ff ff       	jmp    8010547d <alltraps>

80105eae <vector142>:
.globl vector142
vector142:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $142
80105eb0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105eb5:	e9 c3 f5 ff ff       	jmp    8010547d <alltraps>

80105eba <vector143>:
.globl vector143
vector143:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $143
80105ebc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105ec1:	e9 b7 f5 ff ff       	jmp    8010547d <alltraps>

80105ec6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $144
80105ec8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ecd:	e9 ab f5 ff ff       	jmp    8010547d <alltraps>

80105ed2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $145
80105ed4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ed9:	e9 9f f5 ff ff       	jmp    8010547d <alltraps>

80105ede <vector146>:
.globl vector146
vector146:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $146
80105ee0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ee5:	e9 93 f5 ff ff       	jmp    8010547d <alltraps>

80105eea <vector147>:
.globl vector147
vector147:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $147
80105eec:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ef1:	e9 87 f5 ff ff       	jmp    8010547d <alltraps>

80105ef6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $148
80105ef8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105efd:	e9 7b f5 ff ff       	jmp    8010547d <alltraps>

80105f02 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $149
80105f04:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f09:	e9 6f f5 ff ff       	jmp    8010547d <alltraps>

80105f0e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $150
80105f10:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f15:	e9 63 f5 ff ff       	jmp    8010547d <alltraps>

80105f1a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $151
80105f1c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f21:	e9 57 f5 ff ff       	jmp    8010547d <alltraps>

80105f26 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $152
80105f28:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f2d:	e9 4b f5 ff ff       	jmp    8010547d <alltraps>

80105f32 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $153
80105f34:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f39:	e9 3f f5 ff ff       	jmp    8010547d <alltraps>

80105f3e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $154
80105f40:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f45:	e9 33 f5 ff ff       	jmp    8010547d <alltraps>

80105f4a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $155
80105f4c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f51:	e9 27 f5 ff ff       	jmp    8010547d <alltraps>

80105f56 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $156
80105f58:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f5d:	e9 1b f5 ff ff       	jmp    8010547d <alltraps>

80105f62 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $157
80105f64:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f69:	e9 0f f5 ff ff       	jmp    8010547d <alltraps>

80105f6e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $158
80105f70:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f75:	e9 03 f5 ff ff       	jmp    8010547d <alltraps>

80105f7a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $159
80105f7c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f81:	e9 f7 f4 ff ff       	jmp    8010547d <alltraps>

80105f86 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $160
80105f88:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f8d:	e9 eb f4 ff ff       	jmp    8010547d <alltraps>

80105f92 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $161
80105f94:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f99:	e9 df f4 ff ff       	jmp    8010547d <alltraps>

80105f9e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $162
80105fa0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105fa5:	e9 d3 f4 ff ff       	jmp    8010547d <alltraps>

80105faa <vector163>:
.globl vector163
vector163:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $163
80105fac:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fb1:	e9 c7 f4 ff ff       	jmp    8010547d <alltraps>

80105fb6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $164
80105fb8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fbd:	e9 bb f4 ff ff       	jmp    8010547d <alltraps>

80105fc2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $165
80105fc4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fc9:	e9 af f4 ff ff       	jmp    8010547d <alltraps>

80105fce <vector166>:
.globl vector166
vector166:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $166
80105fd0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fd5:	e9 a3 f4 ff ff       	jmp    8010547d <alltraps>

80105fda <vector167>:
.globl vector167
vector167:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $167
80105fdc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105fe1:	e9 97 f4 ff ff       	jmp    8010547d <alltraps>

80105fe6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $168
80105fe8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105fed:	e9 8b f4 ff ff       	jmp    8010547d <alltraps>

80105ff2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $169
80105ff4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ff9:	e9 7f f4 ff ff       	jmp    8010547d <alltraps>

80105ffe <vector170>:
.globl vector170
vector170:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $170
80106000:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106005:	e9 73 f4 ff ff       	jmp    8010547d <alltraps>

8010600a <vector171>:
.globl vector171
vector171:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $171
8010600c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106011:	e9 67 f4 ff ff       	jmp    8010547d <alltraps>

80106016 <vector172>:
.globl vector172
vector172:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $172
80106018:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010601d:	e9 5b f4 ff ff       	jmp    8010547d <alltraps>

80106022 <vector173>:
.globl vector173
vector173:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $173
80106024:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106029:	e9 4f f4 ff ff       	jmp    8010547d <alltraps>

8010602e <vector174>:
.globl vector174
vector174:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $174
80106030:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106035:	e9 43 f4 ff ff       	jmp    8010547d <alltraps>

8010603a <vector175>:
.globl vector175
vector175:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $175
8010603c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106041:	e9 37 f4 ff ff       	jmp    8010547d <alltraps>

80106046 <vector176>:
.globl vector176
vector176:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $176
80106048:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010604d:	e9 2b f4 ff ff       	jmp    8010547d <alltraps>

80106052 <vector177>:
.globl vector177
vector177:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $177
80106054:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106059:	e9 1f f4 ff ff       	jmp    8010547d <alltraps>

8010605e <vector178>:
.globl vector178
vector178:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $178
80106060:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106065:	e9 13 f4 ff ff       	jmp    8010547d <alltraps>

8010606a <vector179>:
.globl vector179
vector179:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $179
8010606c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106071:	e9 07 f4 ff ff       	jmp    8010547d <alltraps>

80106076 <vector180>:
.globl vector180
vector180:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $180
80106078:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010607d:	e9 fb f3 ff ff       	jmp    8010547d <alltraps>

80106082 <vector181>:
.globl vector181
vector181:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $181
80106084:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106089:	e9 ef f3 ff ff       	jmp    8010547d <alltraps>

8010608e <vector182>:
.globl vector182
vector182:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $182
80106090:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106095:	e9 e3 f3 ff ff       	jmp    8010547d <alltraps>

8010609a <vector183>:
.globl vector183
vector183:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $183
8010609c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801060a1:	e9 d7 f3 ff ff       	jmp    8010547d <alltraps>

801060a6 <vector184>:
.globl vector184
vector184:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $184
801060a8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801060ad:	e9 cb f3 ff ff       	jmp    8010547d <alltraps>

801060b2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $185
801060b4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060b9:	e9 bf f3 ff ff       	jmp    8010547d <alltraps>

801060be <vector186>:
.globl vector186
vector186:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $186
801060c0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060c5:	e9 b3 f3 ff ff       	jmp    8010547d <alltraps>

801060ca <vector187>:
.globl vector187
vector187:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $187
801060cc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060d1:	e9 a7 f3 ff ff       	jmp    8010547d <alltraps>

801060d6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $188
801060d8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060dd:	e9 9b f3 ff ff       	jmp    8010547d <alltraps>

801060e2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $189
801060e4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060e9:	e9 8f f3 ff ff       	jmp    8010547d <alltraps>

801060ee <vector190>:
.globl vector190
vector190:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $190
801060f0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801060f5:	e9 83 f3 ff ff       	jmp    8010547d <alltraps>

801060fa <vector191>:
.globl vector191
vector191:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $191
801060fc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106101:	e9 77 f3 ff ff       	jmp    8010547d <alltraps>

80106106 <vector192>:
.globl vector192
vector192:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $192
80106108:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010610d:	e9 6b f3 ff ff       	jmp    8010547d <alltraps>

80106112 <vector193>:
.globl vector193
vector193:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $193
80106114:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106119:	e9 5f f3 ff ff       	jmp    8010547d <alltraps>

8010611e <vector194>:
.globl vector194
vector194:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $194
80106120:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106125:	e9 53 f3 ff ff       	jmp    8010547d <alltraps>

8010612a <vector195>:
.globl vector195
vector195:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $195
8010612c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106131:	e9 47 f3 ff ff       	jmp    8010547d <alltraps>

80106136 <vector196>:
.globl vector196
vector196:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $196
80106138:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010613d:	e9 3b f3 ff ff       	jmp    8010547d <alltraps>

80106142 <vector197>:
.globl vector197
vector197:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $197
80106144:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106149:	e9 2f f3 ff ff       	jmp    8010547d <alltraps>

8010614e <vector198>:
.globl vector198
vector198:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $198
80106150:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106155:	e9 23 f3 ff ff       	jmp    8010547d <alltraps>

8010615a <vector199>:
.globl vector199
vector199:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $199
8010615c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106161:	e9 17 f3 ff ff       	jmp    8010547d <alltraps>

80106166 <vector200>:
.globl vector200
vector200:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $200
80106168:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010616d:	e9 0b f3 ff ff       	jmp    8010547d <alltraps>

80106172 <vector201>:
.globl vector201
vector201:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $201
80106174:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106179:	e9 ff f2 ff ff       	jmp    8010547d <alltraps>

8010617e <vector202>:
.globl vector202
vector202:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $202
80106180:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106185:	e9 f3 f2 ff ff       	jmp    8010547d <alltraps>

8010618a <vector203>:
.globl vector203
vector203:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $203
8010618c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106191:	e9 e7 f2 ff ff       	jmp    8010547d <alltraps>

80106196 <vector204>:
.globl vector204
vector204:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $204
80106198:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010619d:	e9 db f2 ff ff       	jmp    8010547d <alltraps>

801061a2 <vector205>:
.globl vector205
vector205:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $205
801061a4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801061a9:	e9 cf f2 ff ff       	jmp    8010547d <alltraps>

801061ae <vector206>:
.globl vector206
vector206:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $206
801061b0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061b5:	e9 c3 f2 ff ff       	jmp    8010547d <alltraps>

801061ba <vector207>:
.globl vector207
vector207:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $207
801061bc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061c1:	e9 b7 f2 ff ff       	jmp    8010547d <alltraps>

801061c6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $208
801061c8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061cd:	e9 ab f2 ff ff       	jmp    8010547d <alltraps>

801061d2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $209
801061d4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061d9:	e9 9f f2 ff ff       	jmp    8010547d <alltraps>

801061de <vector210>:
.globl vector210
vector210:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $210
801061e0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061e5:	e9 93 f2 ff ff       	jmp    8010547d <alltraps>

801061ea <vector211>:
.globl vector211
vector211:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $211
801061ec:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801061f1:	e9 87 f2 ff ff       	jmp    8010547d <alltraps>

801061f6 <vector212>:
.globl vector212
vector212:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $212
801061f8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801061fd:	e9 7b f2 ff ff       	jmp    8010547d <alltraps>

80106202 <vector213>:
.globl vector213
vector213:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $213
80106204:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106209:	e9 6f f2 ff ff       	jmp    8010547d <alltraps>

8010620e <vector214>:
.globl vector214
vector214:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $214
80106210:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106215:	e9 63 f2 ff ff       	jmp    8010547d <alltraps>

8010621a <vector215>:
.globl vector215
vector215:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $215
8010621c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106221:	e9 57 f2 ff ff       	jmp    8010547d <alltraps>

80106226 <vector216>:
.globl vector216
vector216:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $216
80106228:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010622d:	e9 4b f2 ff ff       	jmp    8010547d <alltraps>

80106232 <vector217>:
.globl vector217
vector217:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $217
80106234:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106239:	e9 3f f2 ff ff       	jmp    8010547d <alltraps>

8010623e <vector218>:
.globl vector218
vector218:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $218
80106240:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106245:	e9 33 f2 ff ff       	jmp    8010547d <alltraps>

8010624a <vector219>:
.globl vector219
vector219:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $219
8010624c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106251:	e9 27 f2 ff ff       	jmp    8010547d <alltraps>

80106256 <vector220>:
.globl vector220
vector220:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $220
80106258:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010625d:	e9 1b f2 ff ff       	jmp    8010547d <alltraps>

80106262 <vector221>:
.globl vector221
vector221:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $221
80106264:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106269:	e9 0f f2 ff ff       	jmp    8010547d <alltraps>

8010626e <vector222>:
.globl vector222
vector222:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $222
80106270:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106275:	e9 03 f2 ff ff       	jmp    8010547d <alltraps>

8010627a <vector223>:
.globl vector223
vector223:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $223
8010627c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106281:	e9 f7 f1 ff ff       	jmp    8010547d <alltraps>

80106286 <vector224>:
.globl vector224
vector224:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $224
80106288:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010628d:	e9 eb f1 ff ff       	jmp    8010547d <alltraps>

80106292 <vector225>:
.globl vector225
vector225:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $225
80106294:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106299:	e9 df f1 ff ff       	jmp    8010547d <alltraps>

8010629e <vector226>:
.globl vector226
vector226:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $226
801062a0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801062a5:	e9 d3 f1 ff ff       	jmp    8010547d <alltraps>

801062aa <vector227>:
.globl vector227
vector227:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $227
801062ac:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062b1:	e9 c7 f1 ff ff       	jmp    8010547d <alltraps>

801062b6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $228
801062b8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062bd:	e9 bb f1 ff ff       	jmp    8010547d <alltraps>

801062c2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $229
801062c4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062c9:	e9 af f1 ff ff       	jmp    8010547d <alltraps>

801062ce <vector230>:
.globl vector230
vector230:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $230
801062d0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062d5:	e9 a3 f1 ff ff       	jmp    8010547d <alltraps>

801062da <vector231>:
.globl vector231
vector231:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $231
801062dc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062e1:	e9 97 f1 ff ff       	jmp    8010547d <alltraps>

801062e6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $232
801062e8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062ed:	e9 8b f1 ff ff       	jmp    8010547d <alltraps>

801062f2 <vector233>:
.globl vector233
vector233:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $233
801062f4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801062f9:	e9 7f f1 ff ff       	jmp    8010547d <alltraps>

801062fe <vector234>:
.globl vector234
vector234:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $234
80106300:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106305:	e9 73 f1 ff ff       	jmp    8010547d <alltraps>

8010630a <vector235>:
.globl vector235
vector235:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $235
8010630c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106311:	e9 67 f1 ff ff       	jmp    8010547d <alltraps>

80106316 <vector236>:
.globl vector236
vector236:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $236
80106318:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010631d:	e9 5b f1 ff ff       	jmp    8010547d <alltraps>

80106322 <vector237>:
.globl vector237
vector237:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $237
80106324:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106329:	e9 4f f1 ff ff       	jmp    8010547d <alltraps>

8010632e <vector238>:
.globl vector238
vector238:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $238
80106330:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106335:	e9 43 f1 ff ff       	jmp    8010547d <alltraps>

8010633a <vector239>:
.globl vector239
vector239:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $239
8010633c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106341:	e9 37 f1 ff ff       	jmp    8010547d <alltraps>

80106346 <vector240>:
.globl vector240
vector240:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $240
80106348:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010634d:	e9 2b f1 ff ff       	jmp    8010547d <alltraps>

80106352 <vector241>:
.globl vector241
vector241:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $241
80106354:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106359:	e9 1f f1 ff ff       	jmp    8010547d <alltraps>

8010635e <vector242>:
.globl vector242
vector242:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $242
80106360:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106365:	e9 13 f1 ff ff       	jmp    8010547d <alltraps>

8010636a <vector243>:
.globl vector243
vector243:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $243
8010636c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106371:	e9 07 f1 ff ff       	jmp    8010547d <alltraps>

80106376 <vector244>:
.globl vector244
vector244:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $244
80106378:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010637d:	e9 fb f0 ff ff       	jmp    8010547d <alltraps>

80106382 <vector245>:
.globl vector245
vector245:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $245
80106384:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106389:	e9 ef f0 ff ff       	jmp    8010547d <alltraps>

8010638e <vector246>:
.globl vector246
vector246:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $246
80106390:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106395:	e9 e3 f0 ff ff       	jmp    8010547d <alltraps>

8010639a <vector247>:
.globl vector247
vector247:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $247
8010639c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801063a1:	e9 d7 f0 ff ff       	jmp    8010547d <alltraps>

801063a6 <vector248>:
.globl vector248
vector248:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $248
801063a8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801063ad:	e9 cb f0 ff ff       	jmp    8010547d <alltraps>

801063b2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $249
801063b4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063b9:	e9 bf f0 ff ff       	jmp    8010547d <alltraps>

801063be <vector250>:
.globl vector250
vector250:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $250
801063c0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063c5:	e9 b3 f0 ff ff       	jmp    8010547d <alltraps>

801063ca <vector251>:
.globl vector251
vector251:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $251
801063cc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063d1:	e9 a7 f0 ff ff       	jmp    8010547d <alltraps>

801063d6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $252
801063d8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063dd:	e9 9b f0 ff ff       	jmp    8010547d <alltraps>

801063e2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $253
801063e4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063e9:	e9 8f f0 ff ff       	jmp    8010547d <alltraps>

801063ee <vector254>:
.globl vector254
vector254:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $254
801063f0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801063f5:	e9 83 f0 ff ff       	jmp    8010547d <alltraps>

801063fa <vector255>:
.globl vector255
vector255:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $255
801063fc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106401:	e9 77 f0 ff ff       	jmp    8010547d <alltraps>
80106406:	66 90                	xchg   %ax,%ax
80106408:	66 90                	xchg   %ax,%ax
8010640a:	66 90                	xchg   %ax,%ax
8010640c:	66 90                	xchg   %ax,%ax
8010640e:	66 90                	xchg   %ax,%ax

80106410 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	56                   	push   %esi
80106415:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106417:	c1 ea 16             	shr    $0x16,%edx
{
8010641a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010641b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010641e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106421:	8b 1f                	mov    (%edi),%ebx
80106423:	f6 c3 01             	test   $0x1,%bl
80106426:	74 28                	je     80106450 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106428:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010642e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106434:	c1 ee 0a             	shr    $0xa,%esi
}
80106437:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010643a:	89 f2                	mov    %esi,%edx
8010643c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106442:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106445:	5b                   	pop    %ebx
80106446:	5e                   	pop    %esi
80106447:	5f                   	pop    %edi
80106448:	5d                   	pop    %ebp
80106449:	c3                   	ret    
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106450:	85 c9                	test   %ecx,%ecx
80106452:	74 34                	je     80106488 <walkpgdir+0x78>
80106454:	e8 97 c0 ff ff       	call   801024f0 <kalloc>
80106459:	85 c0                	test   %eax,%eax
8010645b:	89 c3                	mov    %eax,%ebx
8010645d:	74 29                	je     80106488 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010645f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106466:	00 
80106467:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010646e:	00 
8010646f:	89 04 24             	mov    %eax,(%esp)
80106472:	e8 59 de ff ff       	call   801042d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106477:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010647d:	83 c8 07             	or     $0x7,%eax
80106480:	89 07                	mov    %eax,(%edi)
80106482:	eb b0                	jmp    80106434 <walkpgdir+0x24>
80106484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106488:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010648b:	31 c0                	xor    %eax,%eax
}
8010648d:	5b                   	pop    %ebx
8010648e:	5e                   	pop    %esi
8010648f:	5f                   	pop    %edi
80106490:	5d                   	pop    %ebp
80106491:	c3                   	ret    
80106492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	89 c7                	mov    %eax,%edi
801064a6:	56                   	push   %esi
801064a7:	89 d6                	mov    %edx,%esi
801064a9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801064aa:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064b0:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
801064b3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064b9:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801064be:	72 3b                	jb     801064fb <deallocuvm.part.0+0x5b>
801064c0:	eb 5e                	jmp    80106520 <deallocuvm.part.0+0x80>
801064c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801064c8:	8b 10                	mov    (%eax),%edx
801064ca:	f6 c2 01             	test   $0x1,%dl
801064cd:	74 22                	je     801064f1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801064cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801064d5:	74 54                	je     8010652b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801064d7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801064dd:	89 14 24             	mov    %edx,(%esp)
801064e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064e3:	e8 58 be ff ff       	call   80102340 <kfree>
      *pte = 0;
801064e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801064f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064f7:	39 f3                	cmp    %esi,%ebx
801064f9:	73 25                	jae    80106520 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801064fb:	31 c9                	xor    %ecx,%ecx
801064fd:	89 da                	mov    %ebx,%edx
801064ff:	89 f8                	mov    %edi,%eax
80106501:	e8 0a ff ff ff       	call   80106410 <walkpgdir>
    if(!pte)
80106506:	85 c0                	test   %eax,%eax
80106508:	75 be                	jne    801064c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010650a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106510:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010651c:	39 f3                	cmp    %esi,%ebx
8010651e:	72 db                	jb     801064fb <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106520:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106523:	83 c4 1c             	add    $0x1c,%esp
80106526:	5b                   	pop    %ebx
80106527:	5e                   	pop    %esi
80106528:	5f                   	pop    %edi
80106529:	5d                   	pop    %ebp
8010652a:	c3                   	ret    
        panic("kfree");
8010652b:	c7 04 24 e6 70 10 80 	movl   $0x801070e6,(%esp)
80106532:	e8 29 9e ff ff       	call   80100360 <panic>
80106537:	89 f6                	mov    %esi,%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106540 <seginit>:
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106546:	e8 85 d1 ff ff       	call   801036d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010654b:	31 c9                	xor    %ecx,%ecx
8010654d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106552:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106558:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010655d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106561:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106566:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106569:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010656d:	31 c9                	xor    %ecx,%ecx
8010656f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106573:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106578:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010657c:	31 c9                	xor    %ecx,%ecx
8010657e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106582:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106587:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010658b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010658d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106591:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106595:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106599:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010659d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801065a1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065a5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801065a9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801065ad:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
801065b1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065b6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801065ba:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065be:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801065c2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065c6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801065ca:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065ce:	66 89 48 22          	mov    %cx,0x22(%eax)
801065d2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801065d6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801065da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801065de:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801065e2:	c1 e8 10             	shr    $0x10,%eax
801065e5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801065e9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801065ec:	0f 01 10             	lgdtl  (%eax)
}
801065ef:	c9                   	leave  
801065f0:	c3                   	ret    
801065f1:	eb 0d                	jmp    80106600 <mappages>
801065f3:	90                   	nop
801065f4:	90                   	nop
801065f5:	90                   	nop
801065f6:	90                   	nop
801065f7:	90                   	nop
801065f8:	90                   	nop
801065f9:	90                   	nop
801065fa:	90                   	nop
801065fb:	90                   	nop
801065fc:	90                   	nop
801065fd:	90                   	nop
801065fe:	90                   	nop
801065ff:	90                   	nop

80106600 <mappages>:
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 1c             	sub    $0x1c,%esp
80106609:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010660c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010660f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106612:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106616:	89 c3                	mov    %eax,%ebx
80106618:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010661e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106622:	29 df                	sub    %ebx,%edi
80106624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106627:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010662e:	eb 15                	jmp    80106645 <mappages+0x45>
    if(*pte & PTE_P)
80106630:	f6 00 01             	testb  $0x1,(%eax)
80106633:	75 3d                	jne    80106672 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106635:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106638:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010663b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010663d:	74 29                	je     80106668 <mappages+0x68>
    a += PGSIZE;
8010663f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106645:	8b 45 08             	mov    0x8(%ebp),%eax
80106648:	b9 01 00 00 00       	mov    $0x1,%ecx
8010664d:	89 da                	mov    %ebx,%edx
8010664f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106652:	e8 b9 fd ff ff       	call   80106410 <walkpgdir>
80106657:	85 c0                	test   %eax,%eax
80106659:	75 d5                	jne    80106630 <mappages+0x30>
}
8010665b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010665e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106663:	5b                   	pop    %ebx
80106664:	5e                   	pop    %esi
80106665:	5f                   	pop    %edi
80106666:	5d                   	pop    %ebp
80106667:	c3                   	ret    
80106668:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010666b:	31 c0                	xor    %eax,%eax
}
8010666d:	5b                   	pop    %ebx
8010666e:	5e                   	pop    %esi
8010666f:	5f                   	pop    %edi
80106670:	5d                   	pop    %ebp
80106671:	c3                   	ret    
      panic("remap");
80106672:	c7 04 24 b8 77 10 80 	movl   $0x801077b8,(%esp)
80106679:	e8 e2 9c ff ff       	call   80100360 <panic>
8010667e:	66 90                	xchg   %ax,%ax

80106680 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106680:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
80106685:	55                   	push   %ebp
80106686:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106688:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010668d:	0f 22 d8             	mov    %eax,%cr3
}
80106690:	5d                   	pop    %ebp
80106691:	c3                   	ret    
80106692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <switchuvm>:
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	57                   	push   %edi
801066a4:	56                   	push   %esi
801066a5:	53                   	push   %ebx
801066a6:	83 ec 1c             	sub    $0x1c,%esp
801066a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801066ac:	85 f6                	test   %esi,%esi
801066ae:	0f 84 cd 00 00 00    	je     80106781 <switchuvm+0xe1>
  if(p->kstack == 0)
801066b4:	8b 46 08             	mov    0x8(%esi),%eax
801066b7:	85 c0                	test   %eax,%eax
801066b9:	0f 84 da 00 00 00    	je     80106799 <switchuvm+0xf9>
  if(p->pgdir == 0)
801066bf:	8b 7e 04             	mov    0x4(%esi),%edi
801066c2:	85 ff                	test   %edi,%edi
801066c4:	0f 84 c3 00 00 00    	je     8010678d <switchuvm+0xed>
  pushcli();
801066ca:	e8 81 da ff ff       	call   80104150 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801066cf:	e8 7c cf ff ff       	call   80103650 <mycpu>
801066d4:	89 c3                	mov    %eax,%ebx
801066d6:	e8 75 cf ff ff       	call   80103650 <mycpu>
801066db:	89 c7                	mov    %eax,%edi
801066dd:	e8 6e cf ff ff       	call   80103650 <mycpu>
801066e2:	83 c7 08             	add    $0x8,%edi
801066e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066e8:	e8 63 cf ff ff       	call   80103650 <mycpu>
801066ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801066f0:	ba 67 00 00 00       	mov    $0x67,%edx
801066f5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801066fc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106703:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010670a:	83 c1 08             	add    $0x8,%ecx
8010670d:	c1 e9 10             	shr    $0x10,%ecx
80106710:	83 c0 08             	add    $0x8,%eax
80106713:	c1 e8 18             	shr    $0x18,%eax
80106716:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010671c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106723:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106729:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010672e:	e8 1d cf ff ff       	call   80103650 <mycpu>
80106733:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010673a:	e8 11 cf ff ff       	call   80103650 <mycpu>
8010673f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106744:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106748:	e8 03 cf ff ff       	call   80103650 <mycpu>
8010674d:	8b 56 08             	mov    0x8(%esi),%edx
80106750:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106756:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106759:	e8 f2 ce ff ff       	call   80103650 <mycpu>
8010675e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106762:	b8 28 00 00 00       	mov    $0x28,%eax
80106767:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010676a:	8b 46 04             	mov    0x4(%esi),%eax
8010676d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106772:	0f 22 d8             	mov    %eax,%cr3
}
80106775:	83 c4 1c             	add    $0x1c,%esp
80106778:	5b                   	pop    %ebx
80106779:	5e                   	pop    %esi
8010677a:	5f                   	pop    %edi
8010677b:	5d                   	pop    %ebp
  popcli();
8010677c:	e9 8f da ff ff       	jmp    80104210 <popcli>
    panic("switchuvm: no process");
80106781:	c7 04 24 be 77 10 80 	movl   $0x801077be,(%esp)
80106788:	e8 d3 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010678d:	c7 04 24 e9 77 10 80 	movl   $0x801077e9,(%esp)
80106794:	e8 c7 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106799:	c7 04 24 d4 77 10 80 	movl   $0x801077d4,(%esp)
801067a0:	e8 bb 9b ff ff       	call   80100360 <panic>
801067a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <inituvm>:
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
801067b6:	83 ec 2c             	sub    $0x2c,%esp
801067b9:	8b 75 10             	mov    0x10(%ebp),%esi
801067bc:	8b 55 08             	mov    0x8(%ebp),%edx
801067bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801067c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801067c8:	77 64                	ja     8010682e <inituvm+0x7e>
801067ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
801067cd:	e8 1e bd ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
801067d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067d9:	00 
801067da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067e1:	00 
801067e2:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
801067e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801067e7:	e8 e4 da ff ff       	call   801042d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801067ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801067ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067f5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801067fc:	00 
801067fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106801:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106808:	00 
80106809:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106810:	00 
80106811:	89 14 24             	mov    %edx,(%esp)
80106814:	e8 e7 fd ff ff       	call   80106600 <mappages>
  memmove(mem, init, sz);
80106819:	89 75 10             	mov    %esi,0x10(%ebp)
8010681c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010681f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106822:	83 c4 2c             	add    $0x2c,%esp
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106829:	e9 42 db ff ff       	jmp    80104370 <memmove>
    panic("inituvm: more than a page");
8010682e:	c7 04 24 fd 77 10 80 	movl   $0x801077fd,(%esp)
80106835:	e8 26 9b ff ff       	call   80100360 <panic>
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106840 <loaduvm>:
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
80106846:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106849:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106850:	0f 85 98 00 00 00    	jne    801068ee <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106856:	8b 75 18             	mov    0x18(%ebp),%esi
80106859:	31 db                	xor    %ebx,%ebx
8010685b:	85 f6                	test   %esi,%esi
8010685d:	75 1a                	jne    80106879 <loaduvm+0x39>
8010685f:	eb 77                	jmp    801068d8 <loaduvm+0x98>
80106861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106868:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010686e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106874:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106877:	76 5f                	jbe    801068d8 <loaduvm+0x98>
80106879:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010687c:	31 c9                	xor    %ecx,%ecx
8010687e:	8b 45 08             	mov    0x8(%ebp),%eax
80106881:	01 da                	add    %ebx,%edx
80106883:	e8 88 fb ff ff       	call   80106410 <walkpgdir>
80106888:	85 c0                	test   %eax,%eax
8010688a:	74 56                	je     801068e2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010688c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010688e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106893:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106896:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010689b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801068a1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068a4:	05 00 00 00 80       	add    $0x80000000,%eax
801068a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801068ad:	8b 45 10             	mov    0x10(%ebp),%eax
801068b0:	01 d9                	add    %ebx,%ecx
801068b2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801068b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068ba:	89 04 24             	mov    %eax,(%esp)
801068bd:	e8 ee b0 ff ff       	call   801019b0 <readi>
801068c2:	39 f8                	cmp    %edi,%eax
801068c4:	74 a2                	je     80106868 <loaduvm+0x28>
}
801068c6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801068c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ce:	5b                   	pop    %ebx
801068cf:	5e                   	pop    %esi
801068d0:	5f                   	pop    %edi
801068d1:	5d                   	pop    %ebp
801068d2:	c3                   	ret    
801068d3:	90                   	nop
801068d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068d8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801068db:	31 c0                	xor    %eax,%eax
}
801068dd:	5b                   	pop    %ebx
801068de:	5e                   	pop    %esi
801068df:	5f                   	pop    %edi
801068e0:	5d                   	pop    %ebp
801068e1:	c3                   	ret    
      panic("loaduvm: address should exist");
801068e2:	c7 04 24 17 78 10 80 	movl   $0x80107817,(%esp)
801068e9:	e8 72 9a ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
801068ee:	c7 04 24 b8 78 10 80 	movl   $0x801078b8,(%esp)
801068f5:	e8 66 9a ff ff       	call   80100360 <panic>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106900 <allocuvm>:
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 2c             	sub    $0x2c,%esp
80106909:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010690c:	85 ff                	test   %edi,%edi
8010690e:	0f 88 8f 00 00 00    	js     801069a3 <allocuvm+0xa3>
  if(newsz < oldsz)
80106914:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106917:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010691a:	0f 82 85 00 00 00    	jb     801069a5 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106920:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106926:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010692c:	39 df                	cmp    %ebx,%edi
8010692e:	77 57                	ja     80106987 <allocuvm+0x87>
80106930:	eb 7e                	jmp    801069b0 <allocuvm+0xb0>
80106932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106938:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010693f:	00 
80106940:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106947:	00 
80106948:	89 04 24             	mov    %eax,(%esp)
8010694b:	e8 80 d9 ff ff       	call   801042d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106950:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106956:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010695a:	8b 45 08             	mov    0x8(%ebp),%eax
8010695d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106964:	00 
80106965:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010696c:	00 
8010696d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106971:	89 04 24             	mov    %eax,(%esp)
80106974:	e8 87 fc ff ff       	call   80106600 <mappages>
80106979:	85 c0                	test   %eax,%eax
8010697b:	78 43                	js     801069c0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
8010697d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106983:	39 df                	cmp    %ebx,%edi
80106985:	76 29                	jbe    801069b0 <allocuvm+0xb0>
    mem = kalloc();
80106987:	e8 64 bb ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
8010698c:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010698e:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106990:	75 a6                	jne    80106938 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106992:	c7 04 24 35 78 10 80 	movl   $0x80107835,(%esp)
80106999:	e8 b2 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010699e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069a1:	77 47                	ja     801069ea <allocuvm+0xea>
      return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	83 c4 2c             	add    $0x2c,%esp
801069a8:	5b                   	pop    %ebx
801069a9:	5e                   	pop    %esi
801069aa:	5f                   	pop    %edi
801069ab:	5d                   	pop    %ebp
801069ac:	c3                   	ret    
801069ad:	8d 76 00             	lea    0x0(%esi),%esi
801069b0:	83 c4 2c             	add    $0x2c,%esp
801069b3:	89 f8                	mov    %edi,%eax
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5f                   	pop    %edi
801069b8:	5d                   	pop    %ebp
801069b9:	c3                   	ret    
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801069c0:	c7 04 24 4d 78 10 80 	movl   $0x8010784d,(%esp)
801069c7:	e8 84 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801069cc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069cf:	76 0d                	jbe    801069de <allocuvm+0xde>
801069d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069d4:	89 fa                	mov    %edi,%edx
801069d6:	8b 45 08             	mov    0x8(%ebp),%eax
801069d9:	e8 c2 fa ff ff       	call   801064a0 <deallocuvm.part.0>
      kfree(mem);
801069de:	89 34 24             	mov    %esi,(%esp)
801069e1:	e8 5a b9 ff ff       	call   80102340 <kfree>
      return 0;
801069e6:	31 c0                	xor    %eax,%eax
801069e8:	eb bb                	jmp    801069a5 <allocuvm+0xa5>
801069ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069ed:	89 fa                	mov    %edi,%edx
801069ef:	8b 45 08             	mov    0x8(%ebp),%eax
801069f2:	e8 a9 fa ff ff       	call   801064a0 <deallocuvm.part.0>
      return 0;
801069f7:	31 c0                	xor    %eax,%eax
801069f9:	eb aa                	jmp    801069a5 <allocuvm+0xa5>
801069fb:	90                   	nop
801069fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a00 <deallocuvm>:
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a09:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106a0c:	39 d1                	cmp    %edx,%ecx
80106a0e:	73 08                	jae    80106a18 <deallocuvm+0x18>
}
80106a10:	5d                   	pop    %ebp
80106a11:	e9 8a fa ff ff       	jmp    801064a0 <deallocuvm.part.0>
80106a16:	66 90                	xchg   %ax,%ax
80106a18:	89 d0                	mov    %edx,%eax
80106a1a:	5d                   	pop    %ebp
80106a1b:	c3                   	ret    
80106a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	56                   	push   %esi
80106a24:	53                   	push   %ebx
80106a25:	83 ec 10             	sub    $0x10,%esp
80106a28:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106a2b:	85 f6                	test   %esi,%esi
80106a2d:	74 59                	je     80106a88 <freevm+0x68>
80106a2f:	31 c9                	xor    %ecx,%ecx
80106a31:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106a36:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a38:	31 db                	xor    %ebx,%ebx
80106a3a:	e8 61 fa ff ff       	call   801064a0 <deallocuvm.part.0>
80106a3f:	eb 12                	jmp    80106a53 <freevm+0x33>
80106a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a48:	83 c3 01             	add    $0x1,%ebx
80106a4b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a51:	74 27                	je     80106a7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106a53:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106a56:	f6 c2 01             	test   $0x1,%dl
80106a59:	74 ed                	je     80106a48 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a5b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106a61:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a64:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a6a:	89 14 24             	mov    %edx,(%esp)
80106a6d:	e8 ce b8 ff ff       	call   80102340 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106a72:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a78:	75 d9                	jne    80106a53 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106a7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106a7d:	83 c4 10             	add    $0x10,%esp
80106a80:	5b                   	pop    %ebx
80106a81:	5e                   	pop    %esi
80106a82:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106a83:	e9 b8 b8 ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
80106a88:	c7 04 24 69 78 10 80 	movl   $0x80107869,(%esp)
80106a8f:	e8 cc 98 ff ff       	call   80100360 <panic>
80106a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106aa0 <setupkvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	56                   	push   %esi
80106aa4:	53                   	push   %ebx
80106aa5:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106aa8:	e8 43 ba ff ff       	call   801024f0 <kalloc>
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	89 c6                	mov    %eax,%esi
80106ab1:	74 75                	je     80106b28 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106ab3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aba:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106abb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ac0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ac7:	00 
80106ac8:	89 04 24             	mov    %eax,(%esp)
80106acb:	e8 00 d8 ff ff       	call   801042d0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ad0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ad3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ad6:	89 34 24             	mov    %esi,(%esp)
80106ad9:	89 54 24 10          	mov    %edx,0x10(%esp)
80106add:	8b 53 08             	mov    0x8(%ebx),%edx
80106ae0:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106ae4:	29 c2                	sub    %eax,%edx
80106ae6:	8b 03                	mov    (%ebx),%eax
80106ae8:	89 54 24 08          	mov    %edx,0x8(%esp)
80106aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80106af0:	e8 0b fb ff ff       	call   80106600 <mappages>
80106af5:	85 c0                	test   %eax,%eax
80106af7:	78 17                	js     80106b10 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106af9:	83 c3 10             	add    $0x10,%ebx
80106afc:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b02:	72 cc                	jb     80106ad0 <setupkvm+0x30>
80106b04:	89 f0                	mov    %esi,%eax
}
80106b06:	83 c4 20             	add    $0x20,%esp
80106b09:	5b                   	pop    %ebx
80106b0a:	5e                   	pop    %esi
80106b0b:	5d                   	pop    %ebp
80106b0c:	c3                   	ret    
80106b0d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106b10:	89 34 24             	mov    %esi,(%esp)
80106b13:	e8 08 ff ff ff       	call   80106a20 <freevm>
}
80106b18:	83 c4 20             	add    $0x20,%esp
      return 0;
80106b1b:	31 c0                	xor    %eax,%eax
}
80106b1d:	5b                   	pop    %ebx
80106b1e:	5e                   	pop    %esi
80106b1f:	5d                   	pop    %ebp
80106b20:	c3                   	ret    
80106b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106b28:	31 c0                	xor    %eax,%eax
80106b2a:	eb da                	jmp    80106b06 <setupkvm+0x66>
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <kvmalloc>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b36:	e8 65 ff ff ff       	call   80106aa0 <setupkvm>
80106b3b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b40:	05 00 00 00 80       	add    $0x80000000,%eax
80106b45:	0f 22 d8             	mov    %eax,%cr3
}
80106b48:	c9                   	leave  
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b51:	31 c9                	xor    %ecx,%ecx
{
80106b53:	89 e5                	mov    %esp,%ebp
80106b55:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106b58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5e:	e8 ad f8 ff ff       	call   80106410 <walkpgdir>
  if(pte == 0)
80106b63:	85 c0                	test   %eax,%eax
80106b65:	74 05                	je     80106b6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    
    panic("clearpteu");
80106b6c:	c7 04 24 7a 78 10 80 	movl   $0x8010787a,(%esp)
80106b73:	e8 e8 97 ff ff       	call   80100360 <panic>
80106b78:	90                   	nop
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b89:	e8 12 ff ff ff       	call   80106aa0 <setupkvm>
80106b8e:	85 c0                	test   %eax,%eax
80106b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b93:	0f 84 75 01 00 00    	je     80106d0e <copyuvm+0x18e>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b9c:	85 c0                	test   %eax,%eax
80106b9e:	0f 84 ac 00 00 00    	je     80106c50 <copyuvm+0xd0>
80106ba4:	31 db                	xor    %ebx,%ebx
80106ba6:	eb 51                	jmp    80106bf9 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ba8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106bae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bb5:	00 
80106bb6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106bba:	89 04 24             	mov    %eax,(%esp)
80106bbd:	e8 ae d7 ff ff       	call   80104370 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106bcb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106bcf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bd6:	00 
80106bd7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106bdb:	89 44 24 10          	mov    %eax,0x10(%esp)
80106bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106be2:	89 04 24             	mov    %eax,(%esp)
80106be5:	e8 16 fa ff ff       	call   80106600 <mappages>
80106bea:	85 c0                	test   %eax,%eax
80106bec:	78 4d                	js     80106c3b <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
80106bee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bf4:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106bf7:	76 57                	jbe    80106c50 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfc:	31 c9                	xor    %ecx,%ecx
80106bfe:	89 da                	mov    %ebx,%edx
80106c00:	e8 0b f8 ff ff       	call   80106410 <walkpgdir>
80106c05:	85 c0                	test   %eax,%eax
80106c07:	0f 84 14 01 00 00    	je     80106d21 <copyuvm+0x1a1>
    if(!(*pte & PTE_P))
80106c0d:	8b 30                	mov    (%eax),%esi
80106c0f:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c15:	0f 84 fa 00 00 00    	je     80106d15 <copyuvm+0x195>
    pa = PTE_ADDR(*pte);
80106c1b:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c1d:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c23:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c26:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106c2c:	e8 bf b8 ff ff       	call   801024f0 <kalloc>
80106c31:	85 c0                	test   %eax,%eax
80106c33:	89 c6                	mov    %eax,%esi
80106c35:	0f 85 6d ff ff ff    	jne    80106ba8 <copyuvm+0x28>


  return d;

bad:
  freevm(d);
80106c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c3e:	89 04 24             	mov    %eax,(%esp)
80106c41:	e8 da fd ff ff       	call   80106a20 <freevm>
  return 0;
80106c46:	31 c0                	xor    %eax,%eax
}
80106c48:	83 c4 2c             	add    $0x2c,%esp
80106c4b:	5b                   	pop    %ebx
80106c4c:	5e                   	pop    %esi
80106c4d:	5f                   	pop    %edi
80106c4e:	5d                   	pop    %ebp
80106c4f:	c3                   	ret    
  for(i = KERNBASE -(myproc()->userStack_pages*PGSIZE); i< KERNBASE - 4; i += PGSIZE){
80106c50:	e8 9b ca ff ff       	call   801036f0 <myproc>
80106c55:	8b 58 7c             	mov    0x7c(%eax),%ebx
80106c58:	f7 db                	neg    %ebx
80106c5a:	c1 e3 0c             	shl    $0xc,%ebx
80106c5d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106c63:	81 fb fb ff ff 7f    	cmp    $0x7ffffffb,%ebx
80106c69:	76 59                	jbe    80106cc4 <copyuvm+0x144>
80106c6b:	e9 93 00 00 00       	jmp    80106d03 <copyuvm+0x183>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c70:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c76:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c7d:	00 
80106c7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c82:	89 04 24             	mov    %eax,(%esp)
80106c85:	e8 e6 d6 ff ff       	call   80104370 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c8d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c93:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106c97:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c9e:	00 
80106c9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106ca3:	89 44 24 10          	mov    %eax,0x10(%esp)
80106ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106caa:	89 04 24             	mov    %eax,(%esp)
80106cad:	e8 4e f9 ff ff       	call   80106600 <mappages>
80106cb2:	85 c0                	test   %eax,%eax
80106cb4:	78 85                	js     80106c3b <copyuvm+0xbb>
  for(i = KERNBASE -(myproc()->userStack_pages*PGSIZE); i< KERNBASE - 4; i += PGSIZE){
80106cb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cbc:	81 fb fb ff ff 7f    	cmp    $0x7ffffffb,%ebx
80106cc2:	77 3f                	ja     80106d03 <copyuvm+0x183>
    if(!(pte = walkpgdir(pgdir, (void *) i, 0)))
80106cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc7:	31 c9                	xor    %ecx,%ecx
80106cc9:	89 da                	mov    %ebx,%edx
80106ccb:	e8 40 f7 ff ff       	call   80106410 <walkpgdir>
80106cd0:	85 c0                	test   %eax,%eax
80106cd2:	74 4d                	je     80106d21 <copyuvm+0x1a1>
    if(!(*pte & PTE_P))
80106cd4:	8b 30                	mov    (%eax),%esi
80106cd6:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106cdc:	74 37                	je     80106d15 <copyuvm+0x195>
    pa = PTE_ADDR(*pte);
80106cde:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106ce0:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106ce6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106ce9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if(!(mem = kalloc()))
80106cef:	e8 fc b7 ff ff       	call   801024f0 <kalloc>
80106cf4:	85 c0                	test   %eax,%eax
80106cf6:	89 c6                	mov    %eax,%esi
80106cf8:	0f 85 72 ff ff ff    	jne    80106c70 <copyuvm+0xf0>
80106cfe:	e9 38 ff ff ff       	jmp    80106c3b <copyuvm+0xbb>
80106d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106d06:	83 c4 2c             	add    $0x2c,%esp
80106d09:	5b                   	pop    %ebx
80106d0a:	5e                   	pop    %esi
80106d0b:	5f                   	pop    %edi
80106d0c:	5d                   	pop    %ebp
80106d0d:	c3                   	ret    
    return 0;
80106d0e:	31 c0                	xor    %eax,%eax
80106d10:	e9 33 ff ff ff       	jmp    80106c48 <copyuvm+0xc8>
      panic("copyuvm: page not present");
80106d15:	c7 04 24 9e 78 10 80 	movl   $0x8010789e,(%esp)
80106d1c:	e8 3f 96 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106d21:	c7 04 24 84 78 10 80 	movl   $0x80107884,(%esp)
80106d28:	e8 33 96 ff ff       	call   80100360 <panic>
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi

80106d30 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d31:	31 c9                	xor    %ecx,%ecx
{
80106d33:	89 e5                	mov    %esp,%ebp
80106d35:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106d38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3e:	e8 cd f6 ff ff       	call   80106410 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d43:	8b 00                	mov    (%eax),%eax
80106d45:	89 c2                	mov    %eax,%edx
80106d47:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d4a:	83 fa 05             	cmp    $0x5,%edx
80106d4d:	75 11                	jne    80106d60 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d54:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d59:	c9                   	leave  
80106d5a:	c3                   	ret    
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106d60:	31 c0                	xor    %eax,%eax
}
80106d62:	c9                   	leave  
80106d63:	c3                   	ret    
80106d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
80106d79:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d82:	85 db                	test   %ebx,%ebx
80106d84:	75 3a                	jne    80106dc0 <copyout+0x50>
80106d86:	eb 68                	jmp    80106df0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d88:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d8b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d8d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d91:	29 ca                	sub    %ecx,%edx
80106d93:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d99:	39 da                	cmp    %ebx,%edx
80106d9b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d9e:	29 f1                	sub    %esi,%ecx
80106da0:	01 c8                	add    %ecx,%eax
80106da2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106da6:	89 04 24             	mov    %eax,(%esp)
80106da9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106dac:	e8 bf d5 ff ff       	call   80104370 <memmove>
    len -= n;
    buf += n;
80106db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106db4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106dba:	01 d7                	add    %edx,%edi
  while(len > 0){
80106dbc:	29 d3                	sub    %edx,%ebx
80106dbe:	74 30                	je     80106df0 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106dc0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106dc3:	89 ce                	mov    %ecx,%esi
80106dc5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106dcb:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106dcf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106dd2:	89 04 24             	mov    %eax,(%esp)
80106dd5:	e8 56 ff ff ff       	call   80106d30 <uva2ka>
    if(pa0 == 0)
80106dda:	85 c0                	test   %eax,%eax
80106ddc:	75 aa                	jne    80106d88 <copyout+0x18>
  }
  return 0;
}
80106dde:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
80106dea:	c3                   	ret    
80106deb:	90                   	nop
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106df0:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106df3:	31 c0                	xor    %eax,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
80106dfa:	66 90                	xchg   %ax,%ax
80106dfc:	66 90                	xchg   %ax,%ax
80106dfe:	66 90                	xchg   %ax,%ax

80106e00 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106e06:	c7 44 24 04 dc 78 10 	movl   $0x801078dc,0x4(%esp)
80106e0d:	80 
80106e0e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106e15:	e8 86 d2 ff ff       	call   801040a0 <initlock>
  acquire(&(shm_table.lock));
80106e1a:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106e21:	e8 6a d3 ff ff       	call   80104190 <acquire>
80106e26:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106e2b:	90                   	nop
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106e36:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106e39:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106e40:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106e47:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106e4c:	75 e2                	jne    80106e30 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106e4e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106e55:	e8 26 d4 ff ff       	call   80104280 <release>
}
80106e5a:	c9                   	leave  
80106e5b:	c3                   	ret    
80106e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e60 <shm_open>:

int shm_open(int id, char **pointer) {
80106e60:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e61:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106e63:	89 e5                	mov    %esp,%ebp
}
80106e65:	5d                   	pop    %ebp
80106e66:	c3                   	ret    
80106e67:	89 f6                	mov    %esi,%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <shm_close>:


int shm_close(int id) {
80106e70:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e71:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106e73:	89 e5                	mov    %esp,%ebp
}
80106e75:	5d                   	pop    %ebp
80106e76:	c3                   	ret    
