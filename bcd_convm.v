// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//   BCD：  Converts binary numbers to decimal numbers sequentially.
//
// create by Hatakeyama Shinichi	2022/12/17
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


`define bindigit 27
// バイナリ値のビット幅。
// 内部のアルゴリズムでも使用しているので下記のように決定します。
// 1，bin_inの入力値を最大 26bit で 11111111111111111111111111 bin とした場合、
// 2，10進で表記すると、67108863 dec
// 3,最大桁のみを8、以降の桁は0 つまり 80000000 dec にする。
// 4,これをバイナリに変換してこれを表現可能なビット幅 100110001001011010000000000 bin → 27 bit
// 5,bindigitに27を設定します。

`define decdigit 8
// 出力する10進変換した数値の桁数
// 上記bindigitを決定する際の2，の桁数


module bcd_convm (
    input   wire    clk,
    input   wire    reset_n,

	input	wire	bin_req_pls,				// bcd start requested
	input	wire	[`bindigit-1:0]bin_in,
	input	wire	next_quotient_pls,			// 次の下位の桁を算出します。
	output	wire	[3:0]dec_out
   );
	
	reg	[3:0]	curr_digit ;			// ビット幅は、桁数によって決定して下さい。
	reg	[3:0]	dec_sta ;				// 1桁あたりの足しこむ値 0:idle 8-1:operation
	reg	[3:0]	dec_val ;				// 1桁あたりの数値保持用

	wire 	[`bindigit-1:0]	present_truss8 ;	// 各桁の8値
	reg		[`bindigit-1:0]	present_truss ;
	reg 	[`bindigit-1:0]	curr_bin	;		// 現在のbinデータ
	wire 	[`bindigit-1:0]	sub_bin ;
	wire 	[3:0]	add_dec ;

	assign present_truss8 = 8 * 10**(`decdigit -1);	// 

	assign sub_bin = curr_bin - present_truss ;
	assign add_dec = dec_val | dec_sta ;
	assign dec_out	= dec_val ;

 	always  @(posedge clk or negedge reset_n)begin
		if(!reset_n) begin
			curr_digit			<= 4'h0 ;
			dec_sta				<= 4'h0 ;
			present_truss		<= `bindigit'h0000000 ;
			dec_val				<= 4'h0 ;
			curr_bin			<= `bindigit'h0000000 ;
		end
		else if(bin_req_pls == 1'h1) begin
			// decode start requested
			curr_digit			<= 4'h`decdigit ;

			dec_sta				<= 4'h8 ;	// start bit?
			present_truss 		<= present_truss8 ;
			dec_val				<= 4'h0 ;
			curr_bin			<= bin_in;
		end
		else if(next_quotient_pls == 1'h1)begin
			// 次の下位桁
			if(curr_digit != 4'h0) begin
				dec_sta			<= 4'h8 ;
				present_truss 	<= present_truss8 ;
				dec_val			<= 4'h0 ;
				curr_bin		<= (curr_bin << 3) + (curr_bin << 1);	// ten times the value
			end
		end
		else if(dec_sta != 4'h0)begin
			if(curr_bin >= present_truss) begin
				curr_bin		<= sub_bin ;
				dec_val 		<= add_dec ;
			end
			if((dec_sta == 4'h1) && (curr_digit != 4'h0)) begin
				// one digit is end
				// next Lower digit is set
				curr_digit	<= curr_digit - 1 ;
			end
			dec_sta			<= { 1'h0 ,dec_sta[3:1] 					};
			present_truss	<= { 1'h0 ,present_truss[`bindigit-1:1] 	};
		end
	end
		 
endmodule

