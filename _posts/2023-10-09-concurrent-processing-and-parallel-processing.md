---
title: "並行処理と並列処理の違いをコンテキストから考える を読んで"
tags: ["cpu"]
---

[並行処理と並列処理の違いをコンテキストから考える - コネヒト開発者ブログ](https://tech.connehito.com/entry/2023/09/25/130605)

* コンテキストとは、プロセスの現在の実行状態を表す情報の集合を指す。(≒レジスタの内容)
  * プログラムカウンタ : 次に実行する命令が格納されているアドレス
  * スタックポインタ : 変数や一時的な計算結果など、プログラムの実行に必要なデータが格納されているアドレス
  * フラグレジスタ：条件分岐や算術命令の結果に基づくフラグの値
* 並行処理の定義は、「1つのCPUコアに対して複数のコンテキストを高速に入れ替えながらプロセスを実行する方式」
  * CPUから見ると、複数のプロセスを高速に１つずつ処理しているだけなのですが、
  * 人間から見ると、プロセスAとプロセスBが同時に動いているように見えると思います。
* コンテキストスイッチ
  * レジスタの値をプロセスAのコンテキストからプロセスBのコンテキストに切り替えるという処理がコンテキストスイッチ
  * コンテキストスイッチ = レジスタの値の入れ替え
* 並列処理の定義は、「並列処理は複数コアを使って、AとBのコンテキストをそれぞれ異なるコアに格納し、複数のプロセスを真に同時に実行する方式」
  * 並列処理は複数のコアを用いるのでコンテキストスイッチをすることなくそれぞれのコアにコンテキストを保持させて真に同時に実行が可能
* [ALU(Arithmetic Logic Unit)](https://e-words.jp/w/ALU.html)
  * 加算器や論理演算器などの演算回路を持ち、整数の加減算、論理否定（NOT）、論理和（OR）、論理積（AND）、排他的論理和（XOR）などの基本的な演算を行う