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

logic [6:0]  opcode  = instr[6:0];
logic [4:0]  rd      = instr[11:7];
logic [2:0]  funct3  = instr[14:12];
logic [4:0]  rs1     = instr[19:15];
logic [4:0]  rs2     = instr[24:20];
logic [6:0]  funct7  = instr[31:25];

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
            pcadder_in1_sel_d = 1'bx;
            pcadder_in2_sel_d = 1'bx;
            pcadder_out_sel_d = 1'bx;
            pcadder_out_merge_sel_d = 1'bx;
            alu_en_d = 1;

            if (funct3 == 3'b000) begin
                if (funct7 == 7'b0000000) alu_op_d = 1; // ADD
                else if (funct7 == 7'b0100000) alu_op_d = 2; // SUB
                else if (funct7 == 7'b0000001) 
            end
            else if (funct3 == 3'b111 && funct7 == 7'b0000000) alu_op_d = 3; // AND
            else if (funct3 == 3'b110 && funct7 == 7'b0000000) alu_op_d = 4; // OR
            else if (funct3 == 3'b100 && funct7 == 7'b0000000) alu_op_d = 5; // XOR
            else if (funct3 == 3'b010 && funct7 == 7'b0000000) alu_op_d = 6; // SLT
            else if (funct3 == 3'b011 && funct7 == 7'b0000000) alu_op_d = 7; // SLTU
            else if (funct3 == 3'b101) begin
                if (funct7 == 7'b0000000) alu_op_d = 8; // SRL
                else if (funct7 == 7'b0100000) alu_op_d = 9; // SRA
            end
            else if (funct3 == 3'b001 && funct7 == 7'b0000000) alu_op_d = 10; // SLL
            else alu_op_d = 0;

            alu_mul_data2_sel_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 1'bx;
            dmem_write_en_d = 1'bx;
            // Writeback stage
            reg_writedata_sel_d = 1;
        end

        7'h13: begin // I-Type Arithmetic Instructions
            // Decode stage
            immgen_en_d = 1;
            reg_read_addr1_d = rs1;
            reg_read_addr2_d = 5'dx;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 1;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;

            if (funct3 == 3'b000) alu_op_d = 11; // ADDI
            else if (funct3 == 3'b111) alu_op_d = 12; // ANDI
            else if (funct3 == 3'b110) alu_op_d = 13; // ORI
            else if (funct3 == 3'b100) alu_op_d = 14; // XORI
            else if (funct3 == 3'b010) alu_op_d = 15; // SLTI
            else if (funct3 == 3'b011) alu_op_d = 16; // SLTIU
            else if (funct3 == 3'b101) begin
                if (funct7 == 7'b0000000) alu_op_d = 17; // SRLI
                else if (funct7 == 7'b0100000) alu_op_d = 18; // SRAI
            end
            else if (funct3 == 3'b001 && funct7 == 7'b0000000) alu_op_d = 19; // SLLI
            else alu_op_d = 0;

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
            reg_read_addr2_d = 5'dx;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 1'bx;
            pcadder_in2_sel_d = 1'bx;
            pcadder_out_sel_d = 1'bx;
            pcadder_out_merge_sel_d = 1'bx;
            alu_en_d = 1;
            alu_op_d = 21;
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
            reg_write_addr_d = 5'dx;
            reg_read_en_d = 2'b11;
            reg_write_en_d = 0;
            // Execute stage
            pcadder_in1_sel_d = 1'bx;
            pcadder_in2_sel_d = 1'bx;
            pcadder_out_sel_d = 1'bx;
            pcadder_out_merge_sel_d = 1'bx;
            alu_en_d = 1;
            alu_op_d = 22;
            alu_mul_data2_sel_d = 1;
            mul_en_d = 0;
            execute_out_sel_d = 2'b01;
            // Memory stage
            dmem_read_en_d = 0;
            dmem_write_en_d = 1;
            // Writeback stage
            reg_writedata_sel_d = 1'bx;
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

            if (funct3 == 3'b000) then  // BEQ
                alu_op_d = 23;
            else if (funct3 == 3'b001) then  // BNE
                alu_op_d = 24;
            else if (funct3 == 3'b100) then  // BLT (signed)
                alu_op_d = 25;
            else if (funct3 == 3'b101) then  // BGE (signed)
                alu_op_d = 26; 
            else if (funct3 == 3'b110) then  // BLTU (unsigned)
                alu_op_d = 27;
            else if (funct3 == 3'b111) then  // BGEU (unsigned)
                alu_op_d = 28; 
            else  
                alu_op_d = 0;

            alu_mul_data2_sel_d = 0;
            mul_en_d = 0;
            execute_out_sel_d = 2'bxx;
            // Memory stage
            dmem_read_en_d = 1'bx;
            dmem_write_en_d = 1'bx;
            // Writeback stage
            reg_writedata_sel_d = 1'bx;
        end

        7'h6F: begin // JAL
            // Decode stage
            immgen_en_d = 1'bx;
            reg_read_addr1_d = 5'dx;
            reg_read_addr2_d = 5'dx;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'bxx;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;;
            alu_op_d = 30;
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
            reg_read_addr2_d = 5'dx;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'b01;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 1;
            pcadder_out_merge_sel_d = 0;
            alu_en_d = 1;
            alu_op_d = 31;
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
            pcadder_in1_sel_d = 1'bx;
            pcadder_in2_sel_d = 1'bx;
            pcadder_out_sel_d = 1'bx;
            pcadder_out_merge_sel_d = 1'bx;
            alu_en_d = 1;
            alu_op_d = 20;
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
            reg_read_addr1_d = 5'dx;
            reg_read_addr2_d = 5'dx;
            reg_write_addr_d = rd;
            reg_read_en_d = 2'bxx;
            reg_write_en_d = 1;
            // Execute stage
            pcadder_in1_sel_d = 0;
            pcadder_in2_sel_d = 0;
            pcadder_out_sel_d = 0;
            pcadder_out_merge_sel_d = 1;
            alu_en_d = 1'bx;
            alu_op_d = 5'bxxxxx;
            alu_mul_data2_sel_d = 1'bx;
            mul_en_d = 1'bx;
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