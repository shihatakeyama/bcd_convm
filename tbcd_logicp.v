//
// Copyright 1991-2016 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//   

`timescale 10ns / 1ns
module test_bcdm;

	reg clk, reset_n;

	wire    [26:0]bin_in;
	wire	[7:0]dec_out;

	assign bin_in = { 27'd91234567 };
	reg bin_req_pls;
	reg next_quotient_pls;

bcd_convm bcd_convm0(
    .clk (clk),
    .reset_n (reset_n),

	.bin_req_pls (bin_req_pls),				// 変換要求された。
	.bin_in (bin_in),
	.next_quotient_pls(next_quotient_pls),		// 次の下位の桁を算出します。
	.dec_out()
   );

initial	// decode 
begin
	bin_req_pls = 0;
	next_quotient_pls = 0;
    #10
	bin_req_pls = 1;
	next_quotient_pls = 0;
	#2
	bin_req_pls = 0;
	repeat(8) begin
      #12
	  next_quotient_pls = 1;
	  #2
	  next_quotient_pls = 0;
    end
    #20;
end


initial // Clock generator
  begin
    clk = 0;
    #3
    forever #1 clk = !clk;
  end
  
initial	// Reset generator
  begin
    reset_n = 1;
    #5 reset_n = 0;
    #4 reset_n = 1;
  end
  
    
endmodule    
