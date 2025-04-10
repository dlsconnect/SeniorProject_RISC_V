module Instruction_Memory_Block (
	input logic          clk,              // Clock signal
	input logic          rst,              // Reset signal
	input logic  [31:0]  PC_f,             // Current instruction address
	input logic  [31:0]  Instruction_f,    // Instruction coming from instruction memory
	input logic          PC_branch_en_sel, // Control signal for branching; selects between PC_branch and PC_plus4
	input logic  [31:0]  PC_branch,        // Address to branch (if branching)
	input logic          imem_read_en,     // Enables a read from instruction memory
	output logic [31:0]  PC_next           // Next PC address: either branch target or PC + 4
);
	logic [31:0]  PC_plus4;         
	assign PC_plus4 = PC_f + 4;
    	
	//PC update logic
	always_ff @(posedge clk) begin
        //if reset flag is up, then we just set the next cycle to be at 00000000
        if (rst) begin
            PC_next <= 32'b0;
        end else begin
            //if the control sig wants us to branch, then we set the next cycle's pc to be where we are branching to
            if (PC_branch_en_sel) begin
                PC_next <= PC_branch;
            //if we are not branching, then our default option is to go to the next 4 bits
            end else begin
                PC_next <= PC_plus4;
            end
        end
    end

	
endmodule
