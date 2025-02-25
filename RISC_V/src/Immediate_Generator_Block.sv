module immediate_generator_block (
    input logic [31:0] instr,
    output logic [31:0] imm
);

    logic [6:0] opcode;
    assign opcode = instr[6:0]; // Corrected missing semicolon

    always @(*) begin
        imm = 32'b0; // Default assignment at the start

        unique case (opcode)
           // I-Type Immediate Instructions (ADDI, LW, JALR, CSRR, CSRW)
            7'h03, 7'h13, 7'h67, 7'h73: begin
                imm = { {20{instr[31]}}, instr[31:20] };
            end

            // S-Type Immediate Instructions (SW)
            7'h23: begin
                imm = { {20{instr[31]}}, instr[31:25], instr[11:7] };
            end

            // B-Type Immediate Instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'h63: begin
                imm = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
            end

            // U-Type Immediate Instructions (LUI, AUIPC)
            7'h37, 7'h17: begin
                imm = { instr[31:12], 12'b0 };
            end

            // J-Type Immediate Instructions (JAL)
            7'h6F: begin
                imm = { {11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 };
            end

            default: imm = 32'b0;
        endcase

        $display("DEBUG: instr = %h", instr);
        $display("DEBUG: opcode = %b | func3 = %b | func7 = %b", instr[6:0], instr[14:12], instr[31:25]);
        $display("DEBUG: instr[31:20] = %b (Immediate)", instr[31:20]);
        $display("DEBUG: Extracted Immediate = %h", imm);
    end
endmodule