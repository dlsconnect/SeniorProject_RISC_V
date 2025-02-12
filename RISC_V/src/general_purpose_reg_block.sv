module riscv_regfile (
    input  logic         clk,       // Clock signal
    input  logic         rst,       // Reset signal
    input  logic         we,        // Write enable
    input  logic [4:0]   rd_addr1,  // Read register address 1
    input  logic [4:0]   rd_addr2,  // Read register address 2
    input  logic [4:0]   wr_addr,   // Write register address
    input  logic [31:0]  wr_data,   // Write data
    output logic [31:0]  rd_data1,  // Read data 1
    output logic [31:0]  rd_data2   // Read data 2
);

    logic [31:0] regs [31:0]; // Register array (32 registers, each 32-bit wide)

    // Read operation (combinational)
    assign rd_data1 = (rd_addr1 == 5'd0) ? 32'd0 : regs[rd_addr1];
    assign rd_data2 = (rd_addr2 == 5'd0) ? 32'd0 : regs[rd_addr2];

    // Write operation (synchronous)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 32'd0;
            end
        end else if (we && (wr_addr != 5'd0)) begin
            regs[wr_addr] <= wr_data; // Writing only if address is not x0
        end
    end

endmodule