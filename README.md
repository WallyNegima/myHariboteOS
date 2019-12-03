# 『30日でできる！OS自作入門』 for macOS Catalina

[『30日でできる！OS自作入門』](https://book.mynavi.jp/ec/products/detail/id=22078)を macOS 10.15 Catalinaで実行してみました。



## A. 環境構築
著者作成の独自ツール（tolsetフォルダ内のツール）は、Windows用であり macOS Catalinaでは動作させることが困難なため、Lunuxツールを使用することにする。


### 1. バイナリエディタ [HEX FRIEND](https://ridiculousfish.com/hexfiend/)
 [AppStore版](https://apps.apple.com/us/app/hex-fiend/id1342896380?mt=12) もある。
 好みのものでいいが、[0xED](http://www.suavetech.com/0xed/0xed.html) は不安定だった。

 「Chapter 1-1：とにかくやるのだぁ(helloos0)」では、
バイナリエディタ Bz の代わりに使う。


### 2. アセンブラ [NASM](https://www.nasm.us)
「Chapter 1-3：アセンブラ初体験(helloos1)」では、

著者作成のアセンブラ nask の代わりに NASM を使う。

```zsh
# Homebrewでインストール
% brew install nasm

# バージョンを確認 (現時点でバージョンは 2.14.02)
% nasm -v

# NASMで helloos.nasをコンパイルして、helloos.imgを作る
％ nasm helloos.nas -o helloos.img
```

##### ※著者作成の nask と NASM の違い
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

macOS用の QEMUを使う。
```zsh
# Homebrewでインストール
% brew install qemu

# バージョンを確認 (バージョン 4.1.1 以上でないと表示に不具合)
% qemu-system-i386 -version

# イメージファイルhelloos.imgを QEMUで実行（なるべく警告の出ないコマンドラインオプション）
% qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a

# マウスが消えてしまった時は、control + option + g でマウスをリリース
```


### 4. エディタ
「Chapter 2-1：まずはテキストエディタの紹介」では、

TeraPadの代わりに、macOS用の好みのテキストエディタを使う。


### 5. [Mtools](https://www.gnu.org/software/mtools/)
「Chapter 2-3：ブートセレクタだけを作るように整理（helloos4）」では、  
著者作成の edimg.exe の代わりに、ディスクイメージの作成に Mtools の mformat を使う。

```zsh
# Homebrewでインストール
% brew install mtools

# バージョンを確認 (現時点でバージョンは 4.0.23)
% mtools --version

#ディスクイメージ helloos.imgを作る
% mformat -f 1440 -C -B ipl.bin -i helloos.img ::
```

さらに、「Chapter 3-5：OS本体を書き始めてみる（harib00e）」では、  
ディスクイメージの作成に Mtools の mformat と mcopy を使う。

```zsh
# ディスクイメージ haribote.imgを作る
% mformat -f 1440 -C -B ipl.bin -i haribote.img ::
% mcopy -i haribote.img haribote.sys ::
```


### 6. Cコンパイラ [i386-elf-gcc](https://formulae.brew.sh/formula/i386-elf-gcc)
「Chapter 3-9：ついにC言語導入へ（harib00i）」では、

著者作成のCコンパイラ cc1.exe 等の代わりに、i386-elf-gcc を使う。
その際、6. のリンカスクリプトを併せることでコンパイルする。

```zsh
# Homebrewでインストール
% brew install i386-elf-gcc

#バージョンの確認(現時点でバージョンは 9.2.0)
% i386-elf-gcc -v
```


### 7. リンカスクリプト
「Chapter 3-9：ついにC言語導入へ（harib00i）」では、

[「『30日でできる！OS自作入門』のメモ」](https://vanya.jp.net/os/haribote.html#hrb)

のページの「OS用リンカスクリプト」を使わせて頂いた。hrb.ld として作成して、これを用いてコンパイルする。

```zsh
# bootpack.cを、リンクスクリプト hrb.ldを利用してコンパイルし、bootpack.hrbを作る
% i386-elf-gcc -march=i486 -m32 -nostdlib -T hrb.ld bootpack.c -o bootpack.hrb
```


### 8. フォントファイル hankaku.txtを変換するためのプログラム
「Chapter 5-5：フォントを増やしたい（harib02e）」では、

著者作成の makefont.exe の代わりに、

[「GDT（グローバルディスクリプタテーブル） - OS自作入門 5日目-1 【Linux】 - サラリーマンがハッカーを真剣に目指す」]( http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/13/makeos-5-1/)

のページの「フォントファイルのリンクについて」を使わせて頂いた。convHankakuTxt.c として作成し、これを用いてhankaku.txtを変換する。

```zsh
# convHankakuTxt.c は標準ライブラリが必要なので、macOS標準のgccを使う
% gcc convHankakuTxt.c -o convHankakuTxt
% ./convHankakuTxt

# 出来た hankaku.cファイルを他のファイルとリンクする
% i386-elf-gcc -march=i486 -m32 -nostdlib -T hrb.ld -g bootpack.c hankaku.c naskfunc.o -o bootpack.hrb
```


## 9. sprintf関数
「Chapter 5-7：変数の値の表示（harib02g）」では、

著者作成の GOコンパイラ付属の stdio のsprintf の代わりに、

[「sprintfを実装する - OS自作入門 5日目-2 【Linux】 - サラリーマンがハッカーを真剣に目指す」](http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/17/makeos-5-2/)

のページの sprintf関数を使わせて頂いた。mysprintf.c として作成する。

警告が出たので

`second parameter of 'va_start' not last named argument`

mysprintf.cを少し修正；

```mysprintf.c
//va_start (list, 2);
va_start (list, fmt); 
```

bootpack.c も少し修正

```bootpack.c
//#include <stdio.h>   // mysprintf.c を独自に作成したので、この行削除
```

Makefileも mysprintf.c に合わせる。

```Makefile
# 独自の mysprintf.cの sprintf関数ではコンパイル時に警告が出るので、-fno-builtinオプションを追加
% i386-elf-gcc -march=i486 -m32 -nostdlib -fno-builtin -T hrb.ld -g bootpack.c hankaku.c naskfunc.o mysprintf.c -o bootpack.hrb
```

#### ※ 註)

> このsprintfは”%d”と”%x”にしか対応させていません。

とのことなので、"%02X" は "%x"に、"%3d" は "%d" に書き換える必要がある。 


## B. 実行方法

### 1. このレポジトリをclone

```zsh
% git@github.com:noanoa07/myHariboteOS.git
```

※うまくいかない時は、右上の「Clone or download」ボタンで
「Download ZIP」でダウンロードして、ZIPファイルを解凍する
のでもOK。

### 2. 確認

```zsh
% cd HariboteOS/01_day/helloos0
% make run
```

実行して、以下のようなウィンドウが表示されれば、成功！
<img width="720" alt="day1-2" src="https://user-images.githubusercontent.com/1836817/70053144-27bdd580-1618-11ea-9cbc-f466aba2c5f6.png">

### 3. 実行コマンド

```zsh
# コンパイルして、実行
% make run

# イメージファイルharibote.img を作成
% make img

# コンパイルでできたファイルで、haribote.img以外を削除
% make clean

# ソースファイル以外（haribote.imgも含め）をすべて削除
% make src_only

# ipl.nasをコンパイル （03_day/harib00dまで）
% make asm
```

#### ※ 註)
フロッピーディスクに書き込むコマンド `make install` は省略。



## C. 書籍のソースコード
[マイナビ出版のサポートサイト](https://book.mynavi.jp/supportsite/detail/4839919844.html) より、[HariboteOS.zip](https://book.mynavi.jp/files/user/support/4839919844/HariboteOS.zip) がダウンロードできる。

#### ※註） Windows用のエンコーディング/改行コード（ShiftJIS/CRLF）なので、macOS/Linux用のUTF8/LFに変換した方が良い。エディタで変換するか、変換ツールがとしては nkf がある。

 ```zsh
# Homebrewでインストール
% brew install nkf

# バージョンを確認 (現時点でバージョンは 2.1.5)
% nkf -v

# 例） .cファイルをUTF8/LFに変換
% nkf -wLu --overwrite *.ｃ
```

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
+ [『30日でできる！OS自作入門』のメモ](https://vanya.jp.net/os/haribote.html)
+ [30日でできる！OS自作入門（記事一覧）[Ubuntu16.04/NASM] - pollenjp - Qiita](https://qiita.com/pollenjp/items/b7e4392d945b8aa4ff98)
+ [30日でできる!OS自作入門　まとめ - サラリーマンがハッカーを真剣に目指す](
http://bttb.s1.valueserver.jp/wordpress/blog/2018/04/17/makeos/)
+ [『30日でできる！ OS自作入門』 for macOS - tatsumack -Qiita](
https://github.com/tatsumack/30nichideosjisaku)
+ [『30日でできる！ OS自作入門』 for macOS - sandai/30nichideosjisaku -GitHub](https://github.com/sandai/30nichideosjisaku)
+ [始める前に 30日でできる！OS自作入門 - ねこめもmkII（マークツー）](
https://nekomemo2.hateblo.jp/?page=1567690715)
+ [OS自作入門1日目 - duloxetine - Qiita](
https://qiita.com/duloxetine/items/ce1fc1d861f0c3d33651)
+ [『30日でできる！OS自作入門』をLinuxでやってみる 1日目 - Akitsushima Design](https://syusui.tumblr.com/post/109637861048/30日でできるos自作入門をlinuxでやってみる-1日目)
+ [Linuxで書くOS自作入門 1日目 - Tsurugidake's diary](
http://tsurugidake.hatenablog.jp/entry/2017/08/12/205939)
+ [このリポジトリは「30日でできる！自作OS入門」の実践リポジトリです - Bo0km4n/os-practice - GitHub](https://github.com/Bo0km4n/os-practice)
+ [30日でできる! OS自作入門 - yishibashi/hariboteOS - GitHub ](
https://github.com/yishibashi/hariboteOS)
+ [『OS自作入門』を読んでみた。（その6） - いものやま。](https://yamaimo.hatenablog.jp/entry/2017/07/05/200000)
+ [自作OS入門の環境をOS Xで整える - SWEet](http://kk-river108.hatenablog.com/entry/2018/05/04/142549)
+ [macOSでi386-elf向けのGCCをインストールする - tatsumack - Qiita](https://qiita.com/tatsumack/items/900f22ab466de87071dc)
+ [8日目（マウスを動かすまで） - ねこめもmkII（マークツー）](https://nekomemo2.hateblo.jp/entry/2019/10/09/094730)

#### ※註）
macOSとはいえ、ほとんどLinux環境なので、検索キーワードには `Linux` を入れるとヒットすることがある。

ただし、macOS の gccは、実態は clangなので、そこで苦労したりするが…


### 謝意
・ リンカスクリプトの作者 ivan ivanov（ivan111）さん

・ フォントファイルのリンクについて、sprintf の作者 サラリーマンがハッカーを真剣に目指す さん

に感謝します。
