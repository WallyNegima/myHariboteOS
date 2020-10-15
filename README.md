# 『30日でできる！OS自作入門』 for macOS Catalina

[『30日でできる！OS自作入門』](https://book.mynavi.jp/ec/products/detail/id=22078)を macOS 10.15 Catalinaで実行する時のメモ。

→・[Qiita記事](https://qiita.com/noanoa07/items/8828c37c2e286522c7ee)


## A. 環境構築
### 1. バイナリエディタ [HEX FRIEND](https://ridiculousfish.com/hexfiend/)
 [AppStore版](https://apps.apple.com/us/app/hex-fiend/id1342896380?mt=12) など、好みのものを。


### 2. アセンブラ [NASM](https://www.nasm.us)

```zsh
# Homebrewでインストール
% brew install nasm

# NASMで helloos.nasをコンパイルして、helloos.imgを作る
％ nasm helloos.nas -o helloos.img
```

#### ※著者作成の nask と NASM の違い
・[naskについてのページ - hrb-wiki](http://hrb.osask.jp/wiki/?tools/nask)


| nask                      | NASM                      |
|:--------------------------|:--------------------------|
| RESB 18                   | TIMES 18 DB 0             |
| RESB 0x7dfe-$             | TIMES 0x1fe-($-$$) DB 0   |
| ALIGNB 16                 | ALIGN 16, DB 0            |
| [FORMAT "WCOFF"]          | この行削除                  |
| [INSTRSET "i486p"]        | この行削除                  |
| [FILE "naskfunc.nas"]     | この行削除                  |
| [FORMAT "WCOFF"]          | この行削除                  |
| JMP entry（修正の必要なし?） | JMP SHORT entry            |
| \_io_hlt（ \_ の付くもの）   |io_hlt（ \_ を削除）        |


### 3. エミュレータ [QEMU](https://www.qemu.org)

```zsh
# Homebrewでインストール
% brew install qemu

# イメージファイル helloos.imgを QEMUで実行（なるべく警告の出ないコマンドラインオプション）
% qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a

# マウスが消えてしまった時は、control + option + g でマウスをリリース
```


### 4. エディタ
好みのテキストエディタを使う。


### 5. [Mtools](https://www.gnu.org/software/mtools/)
ディスクイメージの作成に Mtoolsの mformat と mcopyを使う。

```zsh
# Homebrewでインストール
% brew install mtools

#ディスクイメージ helloos.imgを作る
% mformat -f 1440 -C -B ipl.bin -i helloos.img ::

# ディスクイメージ haribote.imgを作る
% mformat -f 1440 -C -B ipl.bin -i haribote.img ::
% mcopy -i haribote.img haribote.sys ::
```


### 6. Cコンパイラ [i386-elf-gcc](https://github.com/nativeos/homebrew-i386-elf-toolchain)

```zsh
# Homebrew公式でなく、i386-elf-toolchain tapからインストール
% brew tap nativeos/i386-elf-toolchain
% brew install i386-elf-binutils i386-elf-gcc
```


### 7. リンカスクリプト
[「『30日でできる！OS自作入門』のメモ」](https://vanya.jp.net/os/haribote.html#hrb)
のページの「OS用リンカスクリプト」を hrb.ldとして使わせて頂いた。

```zsh
# bootpack.cを、リンクスクリプト hrb.ldを利用してコンパイルし、bootpack.hrbを作る
% i386-elf-gcc -march=i486 -m32 -nostdlib -T hrb.ld bootpack.c -o bootpack.hrb
```


### 8. フォントファイル hankaku.txtを変換するためのプログラム
[「GDT（グローバルディスクリプタテーブル） - OS自作入門 5日目-1 【Linux】 - サラリーマンがハッカーを真剣に目指す」]( http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/13/makeos-5-1/)
のページの「フォントファイルのリンクについて」を convHankakuTxt.cとして使わせて頂いた。

```zsh
# convHankakuTxt.cは標準ライブラリが必要なので、macOS標準のgccを使う
% gcc convHankakuTxt.c -o convHankakuTxt
% ./convHankakuTxt

# 出来た hankaku.cファイルを他のファイルとリンクする
% i386-elf-gcc -march=i486 -m32 -nostdlib -T hrb.ld -g bootpack.c hankaku.c naskfunc.o -o bootpack.hrb
```


### 9. sprintf関数
[「sprintfを実装する - OS自作入門 5日目-2 【Linux】 - サラリーマンがハッカーを真剣に目指す」](http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/17/makeos-5-2/)

のページの sprintf関数を mysprintf.cとして使わせて頂いた。


警告が出たので、mysprintf.cを少し修正。
`second parameter of 'va_start' not last named argument`

```mysprintf.c
//va_start (list, 2);
va_start (list, fmt);
```

bootpack.cを修正。

```bootpack.c
//#include <stdio.h>   // mysprintf.cを独自に作成したので、この行削除
```

Makefileも修正。

```Makefile
# -fno-builtinオプションを追加
% i386-elf-gcc -march=i486 -m32 -nostdlib -fno-builtin -T hrb.ld -g bootpack.c hankaku.c naskfunc.o mysprintf.c -o bootpack.hrb
```

ソースコードの、"%02X" は "%x" に、"%3d" は "%d" に書き換える。


## B. 実行方法

```zsh
#このレポジトリを clone
% git clone git@github.com:noanoa07/myHariboteOS.git

% cd HariboteOS/01_day/helloos0
% make run
```

以下のようなウィンドウが表示されれば、成功！
<img width="720" alt="day1-2" src="https://user-images.githubusercontent.com/1836817/70053144-27bdd580-1618-11ea-9cbc-f466aba2c5f6.png">


### 実行コマンド

```zsh
# コンパイルして、実行
% make run

# イメージファイ ルharibote.img を作成
% make img

# デフォルトは make img
% make

# コンパイルしてできたファイルの内、haribote.img以外を削除
% make clean

# ソースファイル以外（haribote.imgも含め）をすべて削除
% make src_only

# ipl.nasをコンパイル （03_day/harib00dまで）
% make asm

# make installは無い
```


## C. 書籍のソースコード
[マイナビ出版のサポートサイト](https://book.mynavi.jp/supportsite/detail/4839919844.html)より、[HariboteOS.zip](https://book.mynavi.jp/files/user/support/4839919844/HariboteOS.zip) 。


## 参考
+ [正誤表](http://hrb.osask.jp/bugfix.html)
+ [サポートページ](http://hrb.osask.jp)
+ [Wiki 一覧 - os-wiki](http://oswiki.osask.jp/?cmd=list)
+ [Wiki 目次 - hrb-wiki](http://hrb.osask.jp/wiki/?index)
+ [OSを作るときによく使うBIOSファンクション (AT互換機) - os-wiki](http://oswiki.osask.jp/?%28AT%29BIOS)
+ [AT互換機でのメモリマップ - os-wiki](http://oswiki.osask.jp/?cmd=read&page=%28AT%29memorymap&word=bios)
+ [naskについてのページ - hrb-wiki](http://hrb.osask.jp/wiki/?tools/nask)
+ [VGA - ビデオDAコンバータ - os-wiki](http://oswiki.osask.jp/?VGA#o2d4bfd3)
+ [(PIC)8259A - os-wiki](http://oswiki.osask.jp/?%28PIC%298259A)
+ [(AT)keyboard - os-wiki](http://oswiki.osask.jp/?%28AT%29keyboard)


### 謝意
・ [「リンカスクリプト」](https://vanya.jp.net/os/haribote.html#hrb)の作者 ivan ivanov（ivan111）さん

・ [「フォントファイルのリンクについて」](http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/13/makeos-5-1/)及び[「sprintf」](http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/17/makeos-5-2/)の作者 サラリーマンがハッカーを真剣に目指す さん

に感謝します。
