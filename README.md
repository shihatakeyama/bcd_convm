# bcd_convm
このモジュールは2進数を入力して、10進数を1桁づつ変換し出力します。

・1クロックで1ビットづつ答えを求めていきます。

シミュレーション画像
  bin_in  2進数入力
  dec_out 10進数出力
  bin_en 変換開始入力
  next_quotient 次の桁の変換を開始入力

変換手順
1、bin_in にバイナリ値を入力します。
2、bin_req_plsにHiパルスを1回入力します。
3、5クロック以上待ちます。
4、桁の数値がdec_outから出力されます。
     最初は最高位桁が出力されます。
5、next_quotient_plsにHiパルスを1回入力します。
6、以降は3に戻って最小位まで繰り返す。