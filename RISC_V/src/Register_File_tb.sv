module general_purpose_reg_tb;

  // General Purpose Registers Test
  reg clk;
  reg rst;
  reg we;
  reg [4:0] rd_addr1;
  reg [4:0] rd_addr2;
  reg [4:0] wr_addr;
  reg [31:0] wr_data;
  
  wire [31:0] rd_data1;
  wire [31:0] rd_data2;

  general_purpose_reg_block gpr (
    .clk(clk),
    .rst(rst),
    .we(we),
    .rd_addr1(rd_addr1),
    .rd_addr2(rd_addr2),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .rd_data1(rd_data1),
    .rd_data2(rd_data2)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin

    rst = 1'b1;         // Assert reset
    #10 rst = 1'b0;     // Deassert reset after 10 time units

    // Test writing to register x1, x2, and x3
    we = 1'b1; wr_data = 32'hFFFFFFFF; wr_addr = 5'b00001;
    #10;

    we = 1'b1; wr_data = 32'h12345678; wr_addr = 5'b00010;
    #10;

    we = 1'b1; wr_data = 32'h00000001; wr_addr = 5'b00011;
    #10;

    // Attempt writing to x0 (should not change)
    we = 1'b1; wr_data = 32'h0000FFFF; wr_addr = 5'b00000;
    #10;


    // Test reading x1 and x2
    we = 1'b0; rd_addr1 = 5'b00001; rd_addr2 = 5'b00010;
    #10;
    
    // Display Results
    $display("Read x1: %h (Expected: FFFFFFFF)", rd_data1);
    $display("Read x2: %h (Expected: 12345678)", rd_data2);
    
    // Check correctness
    if (rd_data1 !== 32'hFFFFFFFF) $display("Error: x1 Read Mismatch!");
    if (rd_data2 !== 32'h12345678) $display("Error: x2 Read Mismatch!");

    // Test reading x3 and x0
    we = 1'b0; rd_addr1 = 5'b00011; rd_addr2 = 5'b00000;
    #10;

    // Display Results
    $display("Read x3: %h (Expected: 00000001)", rd_data1);
    $display("Read x0: %h (Expected: 00000000)", rd_data2);
    
    // Check correctness
    if (rd_data1 !== 32'h00000001) $display("Error: x3 Read Mismatch!");
    if (rd_data2 !== 32'h00000000) $display("Error: x0 should always be 0!");

    rst = 1'b1;  // Assert reset
    #10;
    // Test reading x1 and x2
    we = 1'b0; rd_addr1 = 5'b00001; rd_addr2 = 5'b00010;
    #10;
    
    // Display Results
    $display("Read x1: %h (Expected: 00000000)", rd_data1);
    $display("Read x2: %h (Expected: 00000000)", rd_data2);
    
    // Check correctness
    if (rd_data1 !== 32'h00000000) $display("Error: x1 Read Mismatch!");
    if (rd_data2 !== 32'h00000000) $display("Error: x0 should always be 0!");

  end

endmodule