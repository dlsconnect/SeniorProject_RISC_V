module Execute_Stage(

    // Inputs
    input logic [31:0] pc_e, 
    input logic [31:0] immediate_e, 
    input logic [31:0] reg_readdata1_e, 
    input logic [31:0] reg_readdata2_e, 
    input logic pcadder_out_sel_e, 
    input logic [4:0]alu_op_e, 
    input logic alu_en_e, 
    input logic mul_en_e, 
    input logic pcadder_in1_sel_e, 
    input logic pcadder_in2_sel_e, 
    input logic alu_mul_data2_sel_e, 
    input logic [1:0] execute_out_sel_e, 
    input logic pcadder_out_merge_sel_e,

    // Forwarding signals
    input logic [4:0] reg_write_addr_e_in,
    input logic reg_write_en_e_in,
    input logic dmem_read_en_e_in,
    input logic dmem_write_en_e_in,
    input logic reg_writedata_sel_e_in,
    

    // Outputs
    output logic [31:0] execute_out_e, 
    output logic [31:0] pc_branch, 
    output logic pc_branch_en_sel,

    // Output Forwarding signals
    output logic [4:0] reg_write_addr_e_out,
    output logic reg_write_en_e_out,
    output logic dmem_read_en_e_out,
    output logic dmem_write_en_e_out,
    output logic reg_writedata_sel_e_out,
    output logic [31:0] reg_readdata2_e_out
);

// Internal wires for ALU, PC Adder, and Multiplication logic
logic [31:0] immediate_e_shifted;  // Shifted immediate value for PC Adder
logic [31:0] pcadder_in1;          // First input to PC Adder
logic [31:0] pcadder_in2;          // Second input to PC Adder
logic [31:0] pcadder_out;          // Output of PC Adder
logic [31:0] pc_plusimm;           // PC + Immediate value
logic [31:0] pc_e_plus4;           // PC + 4
logic [31:0] pcadder_out_merge;    // Merged PC Adder output
logic [31:0] pcadder_out_rounded;  // Rounded PC Adder output
logic [31:0] alu_mul_data2;         // Second operand for ALU or MUL
logic [31:0] alu_out;              // Output of ALU
logic [31:0] mul_out;              // Output of Multiplication

// Instantiate ALU
ALU_Block alu (
    .reg_readdata1_e(reg_readdata1_e),
    .alumul_data2(alu_mul_data2),
    .alu_op_e(alu_op_e),
    .alu_en_e(alu_en_e),
    .alu_out(alu_out),
    .pc_branch_en_sel(pc_branch_en_sel)
);

always_comb begin
    // Passing signals
    reg_readdata2_e_out     = reg_readdata2_e;
    reg_write_addr_e_out    = reg_write_addr_e_in; 
    reg_write_en_e_out      = reg_write_en_e_in; 
    dmem_read_en_e_out      = dmem_read_en_e_in; 
    dmem_write_en_e_out     = dmem_write_en_e_in; 
    reg_writedata_sel_e_out = reg_writedata_sel_e_in; 

    // ALU/MUL
    alu_mul_data2 = (alu_mul_data2_sel_e) ? immediate_e : reg_readdata2_e;
    mul_out = (mul_en_e) ? $signed(reg_readdata1_e) * $signed(alu_mul_data2) : 32'h0000_0000;

    // PC Adder
    immediate_e_shifted = immediate_e << 12;
    pcadder_in1 = (pcadder_in1_sel_e) ? reg_readdata1_e : pc_e;
    pcadder_in2 = (pcadder_in2_sel_e) ? immediate_e_shifted : immediate_e;
    pcadder_out = (pc_branch_en_sel) ? pcadder_in1 + pcadder_in2 : 32'h0000_0000;
    pcadder_out_rounded = pcadder_out;
    pcadder_out_rounded[0] = 1'b0;
    pcadder_out_merge = (pcadder_out_sel_e) ? pcadder_out_rounded : pcadder_out;
    pc_branch = (pcadder_out_merge_sel_e) ? 32'h0000_0000 : pcadder_out_merge;
    pc_plusimm = (pcadder_out_merge_sel_e) ? pcadder_out : 32'h0000_0000;
    pc_e_plus4 = pc_e + 4;

    // Execute Out MUX
    case (execute_out_sel_e)
        2'b00: execute_out_e = pc_plusimm;
        2'b01: execute_out_e = alu_out;
        2'b10: execute_out_e = mul_out;
        2'b11: execute_out_e = pc_e_plus4;
        default: execute_out_e = 32'h0000_0000;
    endcase
end

endmodule