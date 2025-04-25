module Fetch_Stage_bp(
//inputs
input clk,
input rst,
input [31:0] pc_branch,
input pc_branch_en_sel,
input pc_d,
//outputs
output logic flush_fd,
output logic flush_de,
output logic pc_f,
output logic instr_f
);

//internal wires
logic [31:0] pc_out;

//instantiate the branch predictor
Branch_Predictor_Block int_bp(
    .clk(clk),
    .pc_branch_en_sel(pc_branch_en_sel),
    .rst(rst),
    .pc_f(pc_f),
    .pc_d(pc_d),
    .instr_f(instr_f),
    .pc_branch(pc_branch),
    .flush_fd(flush_fd),
    .flush_de(flush_de),
    .pc_out(pc_out)
);

//instantiate the imem
Instruction_Memory_Block #(
    .IMEM_DEPTH(256),          // Depth of instruction memory
    .INIT_FILE("/home/dlsconnect/Documents/SFSU_2020_2025/SeniorProject_RISC_V/RISC_V/src/Instructions_Folder/simple_SW_LW_instr.hex")     // Initialization file for instruction memory
) int_imem(
    .PC_f(pc_f),
    .Instruction_f(instr_f)
);

//internal wires
always @(posedge clk) begin
    pc_f <= pc_out;
end
endmodule