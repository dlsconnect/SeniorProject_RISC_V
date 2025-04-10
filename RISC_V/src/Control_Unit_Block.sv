module Control_Unit_Block(

    input logic [31:0] instr,

    // Decode Stage Signals
    output logic immgen_en_d,
    output logic [4:0] reg_read_addr1_d,
    output logic [4:0] reg_read_addr2_d,
    output logic [1:0] reg_read_en_d,
    output logic reg_write_en_d,
    output logic [4:0] reg_write_addr_d,

    // Execute Stage Signals
    output logic pcadder_in1_sel_d,
    output logic pcadder_in2_sel_d,
    output logic pcadder_out_sel_d,
    output logic pcadder_out_merge_sel_d,
    output logic alu_en_d,
    output logic [4:0] alu_op_d,
    output logic alu_mul_data2_sel_d,
    output logic mul_en_d,
    output logic [1:0] execute_out_sel_d,

    // Memory Stage Signals
    output logic dmem_read_en_d,
    output logic dmem_write_en_d,

    // Write Back Stage Signals
    output logic reg_writedata_sel_d
);

logic [6:0]  opcode;
logic [4:0]  rd;
logic [2:0]  funct3;
logic [4:0]  rs1;
logic [4:0]  rs2;
logic [6:0]  funct7;

assign opcode  = instr[6:0];
assign rd      = instr[11:7];
assign funct3  = instr[14:12];
assign rs1     = instr[19:15];
assign rs2     = instr[24:20];
assign funct7  = instr[31:25];

always @(*) begin

    unique case (opcode)

        7'h33: begin // R-Type Instructions
            // Decode stage
            immgen_en_d = 0;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = rs2;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b11;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 1'b0;
            pcadder_in2_sel_d = 1'b0;
            pcadder_out_sel_d = 1'b0;
            pcadder_out_merge_sel_d = 1'b0;
            alu_en_d = 1;

            if (funct3 == 3'b000) begin
                if (funct7 == 7'b0000000) alu_op_d = 5'b00001; // ADD
                else if (funct7 == 7'b0100000) alu_op_d = 5'b00010; // SUB
                else if (funct7 == 7'b0000001) begin // MUL
                    alu_en_d = 0;
                    mul_en_d = 1;
                end 
            end
            else if (funct3 == 3'b111 && funct7 == 7'b0000000) alu_op_d = 5'b00011; // AND
            else if (funct3 == 3'b110 && funct7 == 7'b0000000) alu_op_d = 5'b00100; // OR
            else if (funct3 == 3'b100 && funct7 == 7'b0000000) alu_op_d = 5'b00101; // XOR
            else if (funct3 == 3'b010 && funct7 == 7'b0000000) alu_op_d = 5'b00110; // SLT
            else if (funct3 == 3'b011 && funct7 == 7'b0000000) alu_op_d = 5'b00111; // SLTU
            else if (funct3 == 3'b101) begin
                if (funct7 == 7'b0000000) alu_op_d = 5'b01001; // SRL
                else if (funct7 == 7'b0100000) alu_op_d = 5'b01000; // SRA
            end
            else if (funct3 == 3'b001 && funct7 == 7'b0000000) alu_op_d = 5'b01010; // SLL
            else alu_op_d = 5'b00000;

            alu_mul_data2_sel_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 1'b0;
            dmem_write_en_d = 1'b0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h13: begin // I-Type Arithmetic Instructions
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 1;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;

            if (funct3 == 3'b000) alu_op_d = 5'b01011; // ADDI
            else if (funct3 == 3'b111) alu_op_d = 5'b01100; // ANDI
            else if (funct3 == 3'b110) alu_op_d = 5'b01101; // ORI
            else if (funct3 == 3'b100) alu_op_d = 5'b01110; // XORI
            else if (funct3 == 3'b010) alu_op_d = 5'b01111; // SLTI
            else if (funct3 == 3'b011) alu_op_d = 5'b10000; // SLTIU
            else if (funct3 == 3'b101) begin
                if (funct7 == 7'b0000000) alu_op_d = 5'b10010; // SRLI
                else if (funct7 == 7'b0100000) alu_op_d = 5'b10001; // SRAI
            end
            else if (funct3 == 3'b001 && funct7 == 7'b0000000) alu_op_d = 5'b10011; // SLLI
            else alu_op_d = 5'b00000;

            alu_mul_data2_sel_d = 1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h03: begin // Load (LW)
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 1'b0;
            pcadder_in2_sel_d = 1'b0;
            pcadder_out_sel_d = 1'b0;
            pcadder_out_merge_sel_d = 1'b0;
            alu_en_d = 1;
            alu_op_d = 5'b10101;
            alu_mul_data2_sel_d = 1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 1;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 0;
        end

        7'h23: begin // Store (SW)
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = rs2;
            reg_write_addr_d = 5'd0;
            reg_read_en_d = 2'b11;
            reg_write_en_d = 0;
            // Execute stage
            pcadder_in1_sel_d = 1'b0;
            pcadder_in2_sel_d = 1'b0;
            pcadder_out_sel_d = 1'b0;
            pcadder_out_merge_sel_d = 1'b0;
            alu_en_d = 1;
            alu_op_d = 5'b10110;
            alu_mul_data2_sel_d = 1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 1;
            // Writeback stage
            reg_writedata_sel_d = 1'b0;
        end

        7'h63: begin // Branch
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = rs2;
            reg_write_addr_d = 5'd0;
            reg_read_en_d = 2'b11;
            reg_write_en_d = 0;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;

            if (funct3 == 3'b000) alu_op_d = 5'b10111; // BEQ
            else if (funct3 == 3'b001) alu_op_d = 5'b11000; // BNE
            else if (funct3 == 3'b100) alu_op_d = 5'b11001; // BLT (signed)
            else if (funct3 == 3'b101) alu_op_d = 5'b11010; // BGE (signed)
            else if (funct3 == 3'b110) alu_op_d = 5'b11011; // BLTU (unsigned)
            else if (funct3 == 3'b111) alu_op_d = 5'b11100; // BGEU (unsigned)
            else alu_op_d = 5'b00000;

            alu_mul_data2_sel_d = 0;
            mul_en_d = 0;
            execute_out_sel_d = 2'b00;
            // Memory stage
            dmem_read_en_d = 1'b0;
            dmem_write_en_d = 1'b0;
            // Writeback stage
            reg_writedata_sel_d = 1'b0;
        end

        7'h6F: begin // JAL
            // Decode stage
            immgen_en_d = 1'b1;
            reg_read_addr1_d = 5'd0;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b00;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;;
            alu_op_d = 5'b11110;
            alu_mul_data2_sel_d = 1'b1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b11;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h67: begin // JALR
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 1;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;
            alu_op_d = 5'b11111;
            alu_mul_data2_sel_d = 1'b1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b11;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h37: begin // LUI
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = 5'd0;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b00;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 1'b0;
            pcadder_in2_sel_d = 1'b0;
            pcadder_out_sel_d = 1'b0;
            pcadder_out_merge_sel_d = 1'b0;
            alu_en_d = 1;
            alu_op_d = 5'b10100;
            alu_mul_data2_sel_d = 1'b1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h17: begin // AUIPC
            // Decode stage 
            immgen_en_d = 1;
            reg_read_addr1_d = 5'd0;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b00;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 1;
            alu_en_d = 1'b0;
            alu_op_d = 5'b11101;
            alu_mul_data2_sel_d = 1'b0;
            mul_en_d = 1'b0;
            execute_out_sel_d = 2'b00;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        default: begin
            immgen_en_d = 0;
            reg_read_addr1_d = 5'd0;
            reg_read_addr2_d = 5'd0;
            reg_write_addr_d = 5'd0;
            reg_read_en_d = 2'b00;
            reg_write_en_d = 0;
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 0;
            alu_op_d = 0;
            alu_mul_data2_sel_d = 0;
            mul_en_d = 0;
            execute_out_sel_d = 2'b00;
            dmem_read_en_d = 0;
            dmem_write_en_d = 0;
            reg_writedata_sel_d = 0;
        end
    endcase
end

endmodule