/* 他のファイルで作った関数がありますとCコンパイラに教える */

void io_hlt(void);
void write_mem8(int addr, int data);

/* 関数宣言なのに、{}がなくていきなり;を書くと、
	他のファイルにあるからよろしくね、という意味になるのです。 */

void HariMain(void)
{

  int i;
  char *p;

  p = (char *) 0xa0000;

  for (i=0; i <= 0xaffff; i++) {
    p[i] = i & 0x0f;
  }
  
  for(;;){
    io_hlt();
  }
}
