module ALU(reg_readdata1_e,alumul_data2,alu_op_e,alu_en_e,alu_out,pc_branch_en_sel);

    //io
    input [31:0] reg_readdata1_e,alumul_data2;
    input [4:0] alu_op_e;
    input alu_en_e;
    output logic [31:0] alu_out;
    output logic pc_branch_en_sel;

    //initialize outputs
    initial begin
        alu_out = 32'h0000_0000;
        pc_branch_en_sel = 1'b0;
    end
    //alu logic
    always @(*) begin
        case (alu_op_e)
        5'b00001: alu_out = reg_readdata1_e + alumul_data2; //ADD    1
        5'b00010: alu_out = reg_readdata1_e - alumul_data2; //SUB    2
        5'b00011: alu_out = reg_readdata1_e & alumul_data2; //AND    3
        5'b00100: alu_out = reg_readdata1_e | alumul_data2; //OR     4
        5'b00101: alu_out = reg_readdata1_e ^ alumul_data2; //XOR    5
        5'b00110: alu_out = ($signed(reg_readdata1_e) < $signed(alumul_data2)) ? 32'h0000_0001 : 32'h0000_0000; //SLT  6
        5'b00111: alu_out = (reg_readdata1_e < alumul_data2) ? 32'h0000_0001 : 32'h0000_0000; //SLTU 7
        5'b01000: alu_out = reg_readdata1_e >>> alumul_data2[4:0]; //SRA   8
        5'b01001: alu_out = reg_readdata1_e >> alumul_data2[4:0]; //SRL   9
        5'b01010: alu_out = reg_readdata1_e << alumul_data2[4:0]; //SLL   10
        5'b01011: alu_out = reg_readdata1_e + alumul_data2; //ADDI  11
        5'b01100: alu_out = reg_readdata1_e & alumul_data2; //ANDI  12
        5'b01101: alu_out = reg_readdata1_e | alumul_data2; //ORI   13
        5'b01110: alu_out = reg_readdata1_e ^ alumul_data2; //XORI  14
        5'b01111: alu_out = ($signed(reg_readdata1_e) < $signed(alumul_data2)) ? 32'h0000_0001 : 32'h0000_0000; //SLTI  15
        5'b10000: alu_out = (reg_readdata1_e < alumul_data2) ? 32'h0000_0001 : 32'h0000_0000; //SLTIU 16
        5'b10001: alu_out = reg_readdata1_e >>> alumul_data2[4:0]; //SRAI  17
        5'b10010: alu_out = reg_readdata1_e >> alumul_data2[4:0]; //SRLI  18
        5'b10011: alu_out = reg_readdata1_e << alumul_data2[4:0]; //SLLI  19
        5'b10100: alu_out = alumul_data2 << 12; //LUI 20
        5'b10101: begin
            alu_out = reg_readdata1_e + alumul_data2; //LW 21
            alu_out[1:0] = 2'b0; //set the last two bits to 0
        end
        5'b10110: begin
            alu_out = reg_readdata1_e + alumul_data2; //SW 22
            alu_out[1:0] = 2'b0; //set the last two bits to 0
        end
        5'b10111: pc_branch_en_sel = (reg_readdata1_e == alumul_data2) ? 1'b1 : 1'b0; //BEQ 23
        5'b11000: pc_branch_en_sel = (reg_readdata1_e != alumul_data2) ? 1'b1 : 1'b0; //BNE 24
        5'b11001: pc_branch_en_sel = ($signed(reg_readdata1_e) < $signed(alumul_data2)) ? 1'b1 : 1'b0; //BLT 25
        5'b11010: pc_branch_en_sel = ($signed(reg_readdata1_e) > $signed(alumul_data2)) ? 1'b1 : 1'b0; //BGT 26
        5'b11011: pc_branch_en_sel = (reg_readdata1_e < alumul_data2) ? 1'b1: 1'b0; //BLTU 27
        5'b11100: pc_branch_en_sel = (reg_readdata1_e >= alumul_data2 ) ? 1'b1 : 1'b0; //BGEU 28
        5'b11101: pc_branch_en_sel = 1'b1; //AUIPC 29
        5'b11110: pc_brnach_en_sel = 1'b1; //JAL 30
        5'b11111: pc_branch_en_sel = 1'b1; //JALR 31
        default : begin
            alu_out = 32'h0000_0000;
            pc_branch_en_sel = 1'b0;
        end
        endcase
    end
endmodule