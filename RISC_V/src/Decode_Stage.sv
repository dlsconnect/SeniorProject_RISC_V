module Decode_Stage(
    input logic [31:0] instr,             // Instruction from the fetch stage

    // Testbench-only write interface 
    //input logic [4:0]  test_write_addr,   // Write address (e.g., x1, x2)
    //input logic        test_write_en,     // Write enable
    //input logic [31:0] test_write_data,   // Data to write to register file

    input logic [4:0] reg_write_addr_w,
    input logic reg_write_en_w,
    input logic [31:0] reg_writedata_w,


    // Outputs to the next stage
    output logic immgen_en_d,
    output logic [4:0] reg_read_addr1_d,
    output logic [4:0] reg_read_addr2_d,
    output logic [1:0] reg_read_en_d,
    output logic reg_write_en_d,
    output logic [4:0] reg_write_addr_d,
    output logic pcadder_in1_sel_d,
    output logic pcadder_in2_sel_d,
    output logic pcadder_out_sel_d,
    output logic pcadder_out_merge_sel_d,
    output logic alu_en_d,
    output logic [4:0] alu_op_d,
    output logic alu_mul_data2_sel_d,
    output logic mul_en_d,
    output logic [1:0] execute_out_sel_d,
    output logic dmem_read_en_d,
    output logic dmem_write_en_d,
    output logic reg_writedata_sel_d,
    output logic [31:0] rd1,              // Read data 1 from Register File
    output logic [31:0] rd2,              // Read data 2 from Register File
    output logic [31:0] imm_out           // Immediate value from Immediate Generator
);

    // Internal wires from Control Unit
    wire immgen_en_d_wire;
    wire [4:0] reg_read_addr1_d_wire;
    wire [4:0] reg_read_addr2_d_wire;
    wire [1:0] reg_read_en_d_wire;
    wire reg_write_en_d_wire;
    wire [4:0] reg_write_addr_d_wire;
    wire pcadder_in1_sel_d_wire;
    wire pcadder_in2_sel_d_wire;
    wire pcadder_out_sel_d_wire;
    wire pcadder_out_merge_sel_d_wire;
    wire alu_en_d_wire;
    wire [4:0] alu_op_d_wire;
    wire alu_mul_data2_sel_d_wire;
    wire mul_en_d_wire;
    wire [1:0] execute_out_sel_d_wire;
    wire dmem_read_en_d_wire;
    wire dmem_write_en_d_wire;
    wire reg_writedata_sel_d_wire;

    // Instantiate Control Unit Block
    Control_Unit_Block control_unit_inst (
        .instr(instr),
        .immgen_en_d(immgen_en_d_wire),
        .reg_read_addr1_d(reg_read_addr1_d_wire),
        .reg_read_addr2_d(reg_read_addr2_d_wire),
        .reg_read_en_d(reg_read_en_d_wire),
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
        .reg_writedata_sel_d(reg_writedata_sel_d_wire)
    );

    // Register File Block — using testbench write inputs directly
    Register_File_Block register_file_inst (
        .reg_read_addr1_d(reg_read_addr1_d_wire),
        .reg_read_addr2_d(reg_read_addr2_d_wire),
        .reg_read_en_d(reg_read_en_d_wire),
        .reg_write_addr_d(reg_write_addr_w),
        .reg_write_en_d(reg_write_en_w),
        .writeData(reg_writedata_w),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Immediate Generator Block
    Immediate_Generator_Block imm_gen_inst (
        .instruction(instr),
        .immgen_en_d(immgen_en_d_wire),
        .imm_out(imm_out)
    );

    // Forward control unit signals to output ports
    assign immgen_en_d             = immgen_en_d_wire;
    assign reg_read_addr1_d        = reg_read_addr1_d_wire;
    assign reg_read_addr2_d        = reg_read_addr2_d_wire;
    assign reg_read_en_d           = reg_read_en_d_wire;
    assign reg_write_en_d          = reg_write_en_d_wire;
    assign reg_write_addr_d        = reg_write_addr_d_wire;
    assign pcadder_in1_sel_d       = pcadder_in1_sel_d_wire;
    assign pcadder_in2_sel_d       = pcadder_in2_sel_d_wire;
    assign pcadder_out_sel_d       = pcadder_out_sel_d_wire;
    assign pcadder_out_merge_sel_d = pcadder_out_merge_sel_d_wire;
    assign alu_en_d                = alu_en_d_wire;
    assign alu_op_d                = alu_op_d_wire;
    assign alu_mul_data2_sel_d     = alu_mul_data2_sel_d_wire;
    assign mul_en_d                = mul_en_d_wire;
    assign execute_out_sel_d       = execute_out_sel_d_wire;
    assign dmem_read_en_d          = dmem_read_en_d_wire;
    assign dmem_write_en_d         = dmem_write_en_d_wire;
    assign reg_writedata_sel_d     = reg_writedata_sel_d_wire;

endmodule
