module RISC_V_01(
    input logic clk,
    input logic reset,
    input logic imem_read_en,
    output logic reg_writeback_en
);

logic [31:0] pc_branch_wire;
logic        pc_branch_en_sel_wire;
logic [31:0] pc_f_wire;
logic [31:0] instr_f_wire;
logic pipe_flush;


// Fetch Stage
Fetch_Stage fetch_stage (
    .clk(clk),
    .reset(reset),
    .pc_branch(pc_branch_wire),
    .pc_branch_en_sel(pc_branch_en_sel_wire),
    .imem_read_en(imem_read_en),
    .pc_f(pc_f_wire),
    .instr_f(instr_f_wire)
);

logic [31:0] pc_d_1_wire;
logic [31:0] instr_d_wire;

// FE/DE Pipline
FE_DE fe_de (
    .clk(clk),
    .reset(reset),
    .pipe_flush(pc_branch_en_sel_wire),
    .pc_f(pc_f_wire),
    .instr_f(instr_f_wire),
    .pc_d(pc_d_1_wire),
    .instr_d(instr_d_wire)
);


logic [4:0]  reg_write_addr_w_wire;
logic [31:0] reg_writedata_w_wire;
logic        reg_write_en_w_wire;


logic [4:0]  reg_write_addr_d_wire;
logic        reg_write_en_d_wire;
logic        pcadder_in1_sel_d_wire;
logic        pcadder_in2_sel_d_wire;
logic        pcadder_out_sel_d_wire;
logic        pcadder_out_merge_sel_d_wire;
logic        alu_en_d_wire;
logic [4:0]  alu_op_d_wire;
logic        alu_mul_data2_sel_d_wire;
logic        mul_en_d_wire;
logic [1:0]  execute_out_sel_d_wire;
logic        dmem_read_en_d_wire;
logic        dmem_write_en_d_wire;
logic        reg_writedata_sel_d_wire;
logic [4:0]  reg_read_addr1_d_wire;
logic [4:0]  reg_read_addr2_d_wire;
logic [31:0] reg_readdata1_d_wire;
logic [31:0] reg_readdata2_d_wire;
logic [31:0] imm_data_d_wire;
logic [31:0] pc_d_2_wire; 


// Decode Stage
Decode_Stage decode_stage(
    .instr(instr_d_wire),
    .pc_d_in(pc_d_1_wire),
    .reg_write_addr_w(reg_write_addr_w_wire),
    .reg_write_en_w(reg_write_en_w_wire),
    .reg_writedata_w(reg_writedata_w_wire),
    .reg_write_en_d(reg_write_en_d_wire),
    .reg_write_addr_d(reg_write_addr_d_wire),
    .pcadder_in1_sel_d(pcadder_in1_sel_d_wire),
    .pcadder_in2_sel_d(pcadder_in2_sel_d_wire),
    .pcadder_out_sel_d(pcadder_out_sel_d_wire),
    .pcadder_out_merge_sel_d(pcadder_out_merge_sel_d_wire),
    .alu_en_d(alu_en_d_wire),
    .alu_op_d(alu_op_d_wire),
    .alu_mul_data2_sel_d(alu_mul_data2_sel_d_wire),
    .mul_en_d(mul_en_d_wire),
    .execute_out_sel_d(execute_out_sel_d_wire),
    .dmem_read_en_d(dmem_read_en_d_wire),
    .dmem_write_en_d(dmem_write_en_d_wire),
    .reg_writedata_sel_d(reg_writedata_sel_d_wire),
    .reg_read_addr1_d(reg_read_addr1_d_wire),
    .reg_read_addr2_d(reg_read_addr2_d_wire),
    .reg_readdata1_d(reg_readdata1_d_wire),
    .reg_readdata2_d(reg_readdata2_d_wire),
    .imm_data_d(imm_data_d_wire),
    .pc_d_out(pc_d_2_wire)
);


logic [31:0] pc_e_wire;
logic [4:0]  reg_write_addr_e_wire_1;
logic        reg_write_en_e_wire_1;
logic        pcadder_in1_sel_e_wire;
logic        pcadder_in2_sel_e_wire;
logic        pcadder_out_sel_e_wire;
logic        pcadder_out_merge_sel_e_wire;
logic        alu_en_e_wire;
logic [4:0]  alu_op_e_wire;
logic        alu_mul_data2_sel_e_wire;
logic        mul_en_e_wire;
logic [1:0]  execute_out_sel_e_wire;
logic        dmem_read_en_e_wire_1;
logic        dmem_write_en_e_wire_1;
logic        reg_writedata_sel_e_wire_1;
logic [4:0]  reg_read_addr1_e_wire;
logic [4:0]  reg_read_addr2_e_wire;
logic [31:0] reg_readdata1_e_wire;
logic [31:0] reg_readdata2_e_wire;
logic [31:0] imm_data_e_wire;

// DE/EX Pipeline
DE_EX de_ex (
    .clk(clk),
    .reset(reset),
    .pipe_flush(pc_branch_en_sel_wire),
    .pc_d(pc_d_2_wire),
    .reg_write_en_d(reg_write_en_d_wire),
    .reg_write_addr_d(reg_write_addr_d_wire),
    .pcadder_in1_sel_d(pcadder_in1_sel_d_wire),
    .pcadder_in2_sel_d(pcadder_in2_sel_d_wire),
    .pcadder_out_sel_d(pcadder_out_sel_d_wire),
    .pcadder_out_merge_sel_d(pcadder_out_merge_sel_d_wire),
    .alu_en_d(alu_en_d_wire),
    .alu_op_d(alu_op_d_wire),
    .alu_mul_data2_sel_d(alu_mul_data2_sel_d_wire),
    .mul_en_d(mul_en_d_wire),
    .execute_out_sel_d(execute_out_sel_d_wire),
    .dmem_read_en_d(dmem_read_en_d_wire),
    .dmem_write_en_d(dmem_write_en_d_wire),
    .reg_writedata_sel_d(reg_writedata_sel_d_wire),
    .reg_read_addr1_d(reg_read_addr1_d_wire),
    .reg_read_addr2_d(reg_read_addr2_d_wire),
    .reg_readdata1_d(reg_readdata1_d_wire),
    .reg_readdata2_d(reg_readdata2_d_wire),
    .imm_data_d(imm_data_d_wire),

    .pc_e(pc_e_wire),
    .reg_write_en_e(reg_write_en_e_wire_1),
    .reg_write_addr_e(reg_write_addr_e_wire_1),
    .pcadder_in1_sel_e(pcadder_in1_sel_e_wire),
    .pcadder_in2_sel_e(pcadder_in2_sel_e_wire),
    .pcadder_out_sel_e(pcadder_out_sel_e_wire),
    .pcadder_out_merge_sel_e(pcadder_out_merge_sel_e_wire),
    .alu_en_e(alu_en_e_wire),
    .alu_op_e(alu_op_e_wire),
    .alu_mul_data2_sel_e(alu_mul_data2_sel_e_wire),
    .mul_en_e(mul_en_e_wire),
    .execute_out_sel_e(execute_out_sel_e_wire),
    .dmem_read_en_e(dmem_read_en_e_wire_1),
    .dmem_write_en_e(dmem_write_en_e_wire_1),
    .reg_writedata_sel_e(reg_writedata_sel_e_wire_1),
    .reg_read_addr1_e(reg_read_addr1_e_wire),
    .reg_read_addr2_e(reg_read_addr2_e_wire),
    .reg_readdata1_e(reg_readdata1_e_wire),
    .reg_readdata2_e(reg_readdata2_e_wire),
    .imm_data_e(imm_data_e_wire)
);


logic [31:0] execute_out_e_wire;
logic [4:0]  reg_write_addr_e_wire_2;
logic        reg_write_en_e_wire_2;
logic        dmem_read_en_e_wire_2;
logic        dmem_write_en_e_wire_2;
logic        reg_writedata_sel_e_wire_2;
logic [31:0] reg_readdata2_e_wire_2;

// Execute Stage
Execute_Stage execute_stage(
    .pc_e(pc_e_wire), 
    .immediate_e(imm_data_e_wire), 
    .reg_readdata1_e(reg_readdata1_e_wire), 
    .reg_readdata2_e(reg_readdata2_e_wire), 
    .pcadder_out_sel_e(pcadder_out_sel_w_wire), 
    .alu_op_e(alu_op_e_wire), 
    .alu_en_e(alu_en_e_wire), 
    .mul_en_e(mul_en_e_wire), 
    .pcadder_in1_sel_e(pcadder_in1_sel_e_wire), 
    .pcadder_in2_sel_e(pcadder_in2_sel_e_wire), 
    .alu_mul_data2_sel_e(alu_mul_data2_sel_e_wire), 
    .execute_out_sel_e(execute_out_sel_e_wire), 
    .pcadder_out_merge_sel_e(pcadder_out_merge_sel_e_wire),
    .reg_write_addr_e_in(reg_write_addr_e_wire_1),
    .reg_write_en_e_in(reg_write_en_e_wire_1),
    .dmem_read_en_e_in(dmem_read_en_e_wire_1),
    .dmem_write_en_e_in(dmem_write_en_e_wire_1),
    .reg_writedata_sel_e_in(reg_writedata_sel_e_wire_1),
    
    // Outputs
    .execute_out_e(execute_out_e_wire), 
    .pc_branch(pc_branch_wire), 
    .pc_branch_en_sel(pc_branch_en_sel_wire),
    .reg_write_addr_e_out(reg_write_addr_e_wire_2),
    .reg_write_en_e_out(reg_write_en_e_wire_2),
    .dmem_read_en_e_out(dmem_read_en_e_wire_2),
    .dmem_write_en_e_out(dmem_write_en_e_wire_2),
    .reg_writedata_sel_e_out(reg_writedata_sel_e_wire_2),
    .reg_readdata2_e_out(reg_readdata2_e_wire_2)
);

logic [31:0] execute_out_m_wire_1;
logic [4:0]  reg_write_addr_m_wire_1;
logic        reg_write_en_m_wire_1;
logic        dmem_read_en_m_wire;
logic        dmem_write_en_m_wire;
logic        reg_writedata_sel_m_wire_1;
logic [31:0] reg_readdata2_m_wire;

// EX/MEM Pipeline
EX_MEM ex_mem (
    .clk(clk),
    .reset(reset),
    .execute_out_e(execute_out_e_wire),
    .reg_write_addr_e(reg_write_addr_e_wire_2),
    .reg_write_en_e(reg_write_en_e_wire_2),
    .dmem_read_en_e(dmem_read_en_e_wire_2),
    .dmem_write_en_e(dmem_write_en_e_wire_2),
    .reg_writedata_sel_e(reg_writedata_sel_e_wire_2),
    .reg_readdata2_e(reg_readdata2_e_wire_2),

    // Outputs to Memory Stage
    .execute_out_m(execute_out_m_wire_1), 
    .reg_write_addr_m(reg_write_addr_m_wire_1),
    .reg_write_en_m(reg_write_en_m_wire_1),
    .dmem_read_en_m(dmem_read_en_m_wire),
    .dmem_write_en_m(dmem_write_en_m_wire),
    .reg_writedata_sel_m(reg_writedata_sel_m_wire_1),
    .reg_readdata2_m(reg_readdata2_m_wire)
);

logic [31:0] execute_out_m_wire_2;
logic [4:0]  reg_write_addr_m_wire_2;
logic        reg_write_en_m_wire_2;
logic [31:0] dmem_readdata_m_wire;
logic        reg_writedata_sel_m_wire_2;


// Memory Stage
Memory_Stage memory_stage(
    // Inputs
    .reg_readdata2_m(reg_readdata2_m_wire),
    .execute_out_m_in(execute_out_m_wire_1), 
    .reg_write_addr_m_in(reg_write_addr_m_wire_1),
    .dmem_read_en_m(dmem_read_en_m_wire),
    .dmem_write_en_m(dmem_write_en_m_wire),
    .reg_write_en_m_in(reg_write_en_m_wire_1),
    .reg_writedata_sel_m_in(reg_writedata_sel_m_wire_1),
    
    // Outputs
    .dmem_readdata_m(dmem_readdata_m_wire),
    .execute_out_m_out(execute_out_m_wire_2), 
    .reg_write_addr_m_out(reg_write_addr_m_wire_2),
    .reg_write_en_m_out(reg_write_en_m_wire_2),
    .reg_writedata_sel_m_out(reg_writedata_sel_m_wire_2)
);

logic [31:0] dmem_readdata_w_wire;
logic [31:0] execute_out_w_wire;
logic [4:0]  reg_write_addr_w_wire_1;
logic        reg_write_en_w_wire_1;
logic        reg_writedata_sel_w_wire;

// MEM/WB Pipeline
MEM_WB mem_wb (
    .clk(clk),
    .reset(reset),
    // Signals from Memory Stage
    .dmem_readdata_m(dmem_readdata_m_wire),
    .execute_out_m(execute_out_m_wire_2), 
    .reg_write_addr_m(reg_write_addr_m_wire_2),
    .reg_write_en_m(reg_write_en_m_wire_2),
    .reg_writedata_sel_m(reg_writedata_sel_m_wire_2),

    // Signals for Write Back Stage
    .dmem_readdata_w(dmem_readdata_w_wire),
    .execute_out_w(execute_out_w_wire), 
    .reg_write_addr_w(reg_write_addr_w_wire_1),
    .reg_write_en_w(reg_write_en_w_wire_1),
    .reg_writedata_sel_w(reg_writedata_sel_w_wire)
);

// Writeback Stage
Writeback_Stage writeback_stage(
    .dmem_readdata_w_in(dmem_readdata_w_wire),
    .execute_out_w_in(execute_out_w_wire), 
    .reg_write_addr_w_in(reg_write_addr_w_wire_1),
    .reg_write_en_w_in(reg_write_en_w_wire_1),
    .reg_writedata_sel_w(reg_writedata_sel_w_wire),

    // Outputs to Register File
    .reg_write_addr_w_out(reg_write_addr_w_wire),
    .reg_write_en_w_out(reg_write_en_w_wire),
    .reg_writedata_w(reg_writedata_w_wire)
);

// Assing outputs
always_comb begin 
    reg_writeback_en = reg_write_en_w_wire;
end

endmodule