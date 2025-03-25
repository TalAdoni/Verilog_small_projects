module dut_test_bench;
  reg [7:0] Value_a, Value_b;
  reg Data_val, clk, reset_n;
  reg [2:0] Des_address; 
  reg [7:0] Des_value;     
  reg Des_req_valid, Des_wr_rd;
  reg [7:0] Sum_result;
  reg Sum_carry, Data_ready;
  wire [8:0] final_result;
  wire [7:0] Des_rd_value; 
  
  assign final_result = {Sum_carry, Sum_result};
  
  dut_8bit_addr FA_dut(Sum_result, Sum_carry, Data_ready, clk, reset_n, Value_a, Value_b, Data_val,Des_address, Des_value, Des_req_valid, Des_wr_rd, Des_rd_value);

  initial begin 
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1, dut_test_bench);
    
    // First part 
    Value_a = 8'h00;
    Value_b = 8'h00;
    Data_val = 1;
    reset_n = 1;
    Des_address = 3'b0;
    Des_value = 8'b0;
    Des_req_valid = 1'b0;
    Des_wr_rd = 1'b0;
    
    
    
    
    #10 Value_a = 8'hA1; Value_b = 8'hC2;
    #10 Value_a = 8'hD1; Value_b = 8'h35;
    #10 Value_a = 8'h05; Value_b = 8'h38; 
    #10 Value_a = 8'h55; Value_b = 8'h38;
    #10 Value_a = 8'hAA; Value_b = 8'hAA;
    #10 Value_a = 8'h25; Value_b = 8'h28; 
    #30 Data_val = 0;
    #10 Value_a = 8'h55; Value_b = 8'h11;
    #10 Data_val = 1;
    #30 Value_a = 8'hA1; Value_b = 8'hC2;
    #30 reset_n = 0;
     
    
    #80 $finish;
  end

endmodule