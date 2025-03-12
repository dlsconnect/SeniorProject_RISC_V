module ALU_BLock(in1,in2,op,out,zero);

    //io
    input [31:0] in1,in2;
    input [4:0] op;
    output logic [31:0] out;
    output logic zero;

    //alu logic
    always @(*) begin
        case (op)
        5'b00001: out = in1 + in2; //ADD    1
        5'b00010: out = in1 - in2; //SUB    2
        5'b00011: out = in1 & in2; //AND    3
        5'b00100: out = in1 | in2; //OR     4
        5'b00101: out = in1 ^ in2; //XOR    5
        5'b00110: out = ($signed(in1) < $signed(in2)) ? 32'h0000_0001 : 32'h0000_0000; //SLT  6
        5'b00111: out = (in1 < in2) ? 32'h0000_0001 : 32'h0000_0000; //SLTU 7
        5'b01000: out = in1 >>> in2[4:0];   //SRA   8
        5'b01001: out = in1 >> in2[4:0];    //SRL   9
        5'b01010: out = in1 << in2[4:0];    //SLL   10
        5'b01011: out = in1 + in2;          //ADDI  11
        5'b01100: out = in1 & in2;          //ANDI  12
        5'b01101: out = in1 | in2;          //ORI   13
        5'b01110: out = in1 ^ in2;          //XORI  14
        5'b01111: out = ($signed(in1) < $signed(in2)) ? 32'h0000_0001 : 32'h0000_0000; //SLTI  15
        5'b10000: out = (in1 < in2) ? 32'h0000_0001 : 32'h0000_0000; //SLTIU 16
        5'b10001: out = in1 >>> in2[4:0];   //SRAI  17
        5'b10010: out = in1 >> in2[4:0];    //SRLI  18
        5'b10011: out = in1 << in2[4:0];    //SLLI  19
        default : out = 32'h0000_0000;
        endcase
    end

    assign zero = (out == 32'h0000_0000) ? 1'b1 : 1'b0; //zero flag

endmodule