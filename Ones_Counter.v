
// building a system that counts 1's with HA and FA

module FA_df(o, cout, x, y, cin);
	input x, y, cin;
	output o, cout;
	
	assign o = (x ^ y) ^ cin;
	assign cout = (x & y) | (cin & (x ^ y));

endmodule

module FA_bh (o, cout, x, y, cin);

	input x, y, cin;
	output reg o, cout;
	
	always @(*) begin
		o = (x ^ y) ^ cin;
		cout = (x & y) | (cin & (x ^ y));
	end
endmodule

module HA_df (o, cout, a, b);
	input a, b;
	output o, cout;
	
	assign o = a ^ b;
	assign cout = a & b;
	
endmodule

module HA_bh (o, cout, a, b);
	input a, b;
	output reg o, cout;
	
	always @(*) begin
		o = a ^ b;
		cout = a & b;
	end
endmodule


module ones_counter_str (o0, o1, o2, o3, x0, x1, x2, x3, x4, x5, x6, x7 );
	input x0, x1, x2, x3, x4, x5, x6, x7;
	output wire o0, o1, o2, o3;
	
	wire FA_o1, FA_c1, FA_o2, FA_c2, HA_o1, HA_c1, FA_c3, FA_o4, FA_c4, HA_c2;
	
	FA_bh FA1 (FA_o1, FA_c1, x0, x1, x2);
	FA_bh FA2 (FA_o2, FA_c2, x3, x4, x5);
	HA_bh HA1 (HA_o1, HA_c1, x6, x7);
	FA_bh FA3 (o0, FA_c3, FA_o1, FA_o2, HA_o1);
	FA_bh FA4 (FA_o4, FA_c4 ,FA_c3, FA_c1, FA_c2);
	HA_bh HA2 (o1, HA_c2, FA_o4, HA_c1);
	HA_bh HA3 (o2, o3, HA_c2, FA_c4);
	
endmodule


module ones_counter_TB;
	reg x0, x1, x2, x3, x4, x5, x6, x7;
	wire o0, o1, o2, o3;
	
	ones_counter_str counter_DUT(o0, o1, o2, o3, x0, x1, x2, x3, x4, x5, x6, x7);

	initial begin
		// Monitoring the signals
		$monitor("$time = %d \t x0 = %b \t x1 = %b \t x2 = %b \t x3 = %b \t x4 = %b \t x5 = %b \t x6 = %b \t x7 = %b \t o0 = %b \t o1 = %b \t o2 = %b \t o3 = %b", 
                 $time, x0, x1, x2, x3, x4, x5, x6, x7, o0, o1, o2, o3);

		// Initial values
		x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;

		// Applying test vectors
		#10 x0 = 1; x1 = 1; x5 = 1;
		#10 x0 = 0; x2 = 1; x6 = 1;
		#10 x0 = 1; x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
		#10 x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 1;

		// Stop the simulation
		#10 $stop;
	end
endmodule
