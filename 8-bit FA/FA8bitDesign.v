
// creating FA 1 bit and D-FF

 module bit1_full_adder(s, cout, a, b, cin); 
   input a, b, cin;
   output reg s, cout;

   always@(*) begin
     s=a^b^cin;
     cout=(a&b)|(a&cin)|(b&cin);
   end
 endmodule

module DFF (q, d, clk, rst);
  input d, clk, rst;
  output reg q;
  
  always@ (posedge clk or negedge rst) begin
    if (!rst)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule 

// creating the 8-bit FA

module dut_8bit_addr(
    Sum_result, Sum_carry, Data_ready, clk, reset_n, 
    Value_a, Value_b, Data_val, 
    Des_address, Des_value, Des_req_valid, Des_wr_rd, Des_rd_value);
  
  input [7:0] Value_a, Value_b;
  input clk, reset_n, Data_val;
  input [2:0] Des_address; 
  input [7:0] Des_value;   
  input Des_req_valid, Des_wr_rd;
  output reg [7:0] Sum_result;
  output reg Sum_carry, Data_ready;
  output reg [7:0] Des_rd_value;  

  wire [7:0] Sum_result_calculation;
  wire Sum_carry_calculation;

  // Registers
  reg [7:0] control_reg;     
  reg [7:0] offset_value;    
  reg [7:0] general_purpose; 
  
  // FA wires
  wire FA0_carry, FA0_sum, FA1_carry, FA1_sum, FA2_carry, FA2_sum, FA3_carry, FA3_sum, FA4_carry, FA4_sum, FA5_carry, FA5_sum, FA6_carry, FA6_sum, FA7_carry, FA7_sum;
  
  // DFF wires
  wire dff_a0, dff_b0, dff_a1, dff_b1, dff_a2, dff_b2, dff_a3, dff_b3, dff_a4, dff_b4, dff_a5, dff_b5, dff_a6, dff_b6, dff_a7, dff_b7, dff_data_val0;

 //Sum_result0 block
  DFF DFF_A0(dff_a0, Value_a[0], clk, reset_n);
  DFF DFF_B0(dff_b0, Value_b[0], clk, reset_n);
  bit1_full_adder FA0(FA0_sum, FA0_carry, dff_a0, dff_b0, 1'b0);
  DFF DFF_Sum0(Sum_result_calculation[0], FA0_sum, clk, reset_n);

  //Sum_result1 block
  DFF DFF_A1(dff_a1, Value_a[1], clk, reset_n);
  DFF DFF_B1(dff_b1, Value_b[1], clk, reset_n);
  bit1_full_adder FA1(FA1_sum, FA1_carry, dff_a1, dff_b1, FA0_carry);
  DFF DFF_Sum1(Sum_result_calculation[1], FA1_sum, clk, reset_n);
  
  //Sum_result2 block
  DFF DFF_A2(dff_a2, Value_a[2], clk, reset_n);
  DFF DFF_B2(dff_b2, Value_b[2], clk, reset_n);
  bit1_full_adder FA2(FA2_sum, FA2_carry, dff_a2, dff_b2, FA1_carry);
  DFF DFF_Sum2(Sum_result_calculation[2], FA2_sum, clk, reset_n);
  
  //Sum_result block
  DFF DFF_A3(dff_a3, Value_a[3], clk, reset_n);
  DFF DFF_B3(dff_b3, Value_b[3], clk, reset_n);
  bit1_full_adder FA3(FA3_sum, FA3_carry, dff_a3, dff_b3, FA2_carry);
  DFF DFF_Sum3(Sum_result_calculation[3], FA3_sum, clk, reset_n);

  //Sum_result4 block
  DFF DFF_A4(dff_a4, Value_a[4], clk, reset_n);
  DFF DFF_B4(dff_b4, Value_b[4], clk, reset_n);
  bit1_full_adder FA4(FA4_sum, FA4_carry, dff_a4, dff_b4, FA3_carry);
  DFF DFF_Sum4(Sum_result_calculation[4], FA4_sum, clk, reset_n);

  //Sum_result5 block
  DFF DFF_A5(dff_a5, Value_a[5], clk, reset_n);
  DFF DFF_B5(dff_b5, Value_b[5], clk, reset_n);
  bit1_full_adder FA5(FA5_sum, FA5_carry, dff_a5, dff_b5, FA4_carry);
  DFF DFF_Sum5(Sum_result_calculation[5], FA5_sum, clk, reset_n);

  //Sum_result6 block
  DFF DFF_A6(dff_a6, Value_a[6], clk, reset_n);
  DFF DFF_B6(dff_b6, Value_b[6], clk, reset_n);
  bit1_full_adder FA6(FA6_sum, FA6_carry, dff_a6, dff_b6, FA5_carry);
  DFF DFF_Sum6(Sum_result_calculation[6], FA6_sum, clk, reset_n);

  //Sum_result7 block
  DFF DFF_A7(dff_a7, Value_a[7], clk, reset_n);
  DFF DFF_B7(dff_b7, Value_b[7], clk, reset_n);
  bit1_full_adder FA7(FA7_sum, FA7_carry, dff_a7, dff_b7, FA6_carry);
  DFF DFF_Sum7(Sum_result_calculation[7], FA7_sum, clk, reset_n);
  DFF DFF_Sum_c(Sum_carry_calculation, FA7_carry, clk, reset_n);

  //Data_ready block
  DFF DFF_data_val0(dff_data_val0, Data_val, clk, reset_n );
  DFF DFF_data_val1(Data_ready, dff_data_val0, clk, reset_n);
  

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      control_reg <= 8'b0;      
      offset_value <= 8'b0;     
      general_purpose <= 8'b0;  
    end 
    else if (Des_req_valid && Des_wr_rd) begin  
      case (Des_address)
        3'b000: control_reg <= Des_value;      
        3'b001: offset_value <= Des_value;     
        3'b010: general_purpose <= Des_value;  
        default: ;
      endcase
    end
  end

  
  always @(*) begin
    if (Des_req_valid && !Des_wr_rd) begin  
      case (Des_address)
        3'b000: Des_rd_value = control_reg;      
        3'b001: Des_rd_value = offset_value;     
        3'b010: Des_rd_value = general_purpose; 
        default: Des_rd_value = 8'b0;            
      endcase
    end else begin
      Des_rd_value = 8'b0; 
    end
  end

  
  always @(posedge clk) begin
    if (reset_n) begin
      if (Data_ready) begin
        Sum_result <= Sum_result_calculation + (control_reg[0] ? offset_value : 8'b0); 
        Sum_carry  <= Sum_carry_calculation;
      end	
    end 
    else begin
      Sum_result <= 8'h00;
      Sum_carry <= 1'b0;
    end
  end

endmodule
