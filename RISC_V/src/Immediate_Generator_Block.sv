module Immediate_Generator_Block (
    input logic [31:0] instr,
    output logic [31:0] imm
);

    logic [6:0] opcode;
    assign opcode = instr[6:0]; // Corrected missing semicolon

    always @(*) begin
        imm = 32'b0; // Default assignment at the start
        $display("DEBUG: instr = %h (%b)", instr, instr);
        unique case (opcode)
           // I-Type Immediate Instructions (ADDI, LW, JALR, CSRR, CSRW)
            7'h03, 7'h13, 7'h67, 7'h73: begin
                imm = { {20{instr[31]}}, instr[31:20] };
                $display("DEBUG: opcode = %b (%h) (I-Type) instr[31] = %b instr[31:20] = %b", opcode, opcode, instr[31], instr[31:20]);
            end

            // S-Type Immediate Instructions (SW)
            7'h23: begin
                imm = { {20{instr[31]}}, instr[31:25], instr[11:7] };
                $display("DEBUG: opcode = %b (%h) (S-Type) instr[31] = %b instr[31:25] = %b instr[11:7] = %b", opcode, opcode, instr[31], instr[31:25], instr[11:7]);
            end

            // B-Type Immediate Instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'h63: begin
                imm = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
                $display("DEBUG: opcode = %b (%h) (B-Type) instr[31] = %d instr[7] = %b instr[30:25] = %b instr[11:8] = %b imm[0] = 0", opcode, opcode, instr[31], instr[7], instr[30:25], instr[11:8]);
            end

            // U-Type Immediate Instructions (LUI, AUIPC)
            7'h37, 7'h17: begin
                imm = { instr[31:12], 12'b0 };
                $display("DEBUG: opcode = %b (%b) (U-Type) instr[31:12] = %d imm[11:0] = %b", opcode, opcode, instr[31:12], 12'b0);

            end

            // J-Type Immediate Instructions (JAL)
            7'h6F: begin
                imm = { {11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 };
                $display("DEBUG: opcode = %b (%h) (J-Type) instr[31] = %d instr[19:12] = %b instr[20] = %b instr[30:21] = %b imm[0] = 0 ", opcode, opcode, instr[31], instr[19:12], instr[20], instr[30:21]);
            end

            default: imm = 32'b0;
        endcase
        $display("DEBUG: Extracted Immediate = %h (%b)", imm, imm);
    end
endmodule