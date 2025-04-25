module Branch_Predictor_Block(
    //inputs
    input logic clk, 
    input logic pc_branch_en_sel, 
    input logic rst,
    input logic [31:0] pc_f, 
    input logic [31:0] pc_d, 
    input logic [31:0] instr_f, 
    input logic [31:0] pc_branch,

    //outputs
    output logic flush_fd, 
    output logic flush_de,
    output logic [31:0] pc_out
);

    //internal wires
    logic [31:0] pc_old1, pc_old2;
    logic [1:0] state, nextstate;

    //state memory
    always_ff @(posedge clk) begin
    state <= (rst) ? 2'b00 : nextstate;
    pc_old1 <= (rst) ? 32'h0000_0000 : pc_f;
    pc_old2 <= (rst) ? 32'h0000_0000 : pc_old1;

    end

    //nextstate comb logic
    always_comb begin
        //3 different types of instructions
        case(instr_f[6:0])
            //JAL
            7'b1101111: begin
                pc_out = instr_f[31:12] + pc_f;
                nextstate = state;
            end
            //JALR
            7'b1100111: begin
                pc_out = (instr_f[19:15] + instr_f[31:20]) & 32'hFFFF_FFFE;
                nextstate = state;
            end
            //Branch
            7'b1100011: begin
                case(state)
                    2'b00: begin
                        //predict failure
                        pc_out = pc_f + 4;
                        //if we have a fail condition
                        if (((pc_d != pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d == pc_branch) & (pc_branch_en_sel == 0))) begin
                            //flush and load old pc, do not change state
                            flush_de = 1;
                            flush_fd = 1;
                            pc_out = pc_old2;
                        end
                        //if we have a success condition
                        if (((pc_d == pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d != pc_branch) & (pc_branch_en_sel == 0))) begin
                            //increment nextstate by 1
                            nextstate = 2'b01;
                            flush_de = 0;
                            flush_fd = 0;
                        end
                    end
                    2'b01: begin
                        //predict failure
                        pc_out = pc_f + 4;
                        //if we have a fail condition
                        if (((pc_d != pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d == pc_branch) & (pc_branch_en_sel == 0))) begin
                            //flush and load old pc, decrement nextstate
                            flush_de = 1;
                            flush_fd = 1;
                            pc_out = pc_old2;
                            nextstate = 2'b00;
                        end
                        //if we have a success condition
                        if (((pc_d == pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d != pc_branch) & (pc_branch_en_sel == 0))) begin
                            //increment nextstate by 1
                            nextstate = 2'b10;
                            flush_de = 0;
                            flush_fd = 0;
                        end
                    end
                    2'b10: begin
                        //predict success
                        pc_out = pc_f + instr_f[31:25];
                        //if we have a fail condition
                        if (((pc_d != pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d == pc_branch) & (pc_branch_en_sel == 0))) begin
                            //flush and load old pc, decrement nextstate
                            flush_de = 1;
                            flush_fd = 1;
                            pc_out = pc_old2;
                            nextstate = 2'b01;
                        end
                        //if we have a success condition
                        if (((pc_d == pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d != pc_branch) & (pc_branch_en_sel == 0))) begin
                            //increment nextstate by 1
                            nextstate = 2'b11;
                            flush_de = 0;
                            flush_fd = 0;
                        end
                    end
                    2'b11: begin
                        //predict success
                        pc_out = pc_f + instr_f[31:25];
                        //if we have a fail condition
                        if (((pc_d != pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d == pc_branch) & (pc_branch_en_sel == 0))) begin
                            //flush and load old pc, decrement nextstate
                            flush_de = 1;
                            flush_fd = 1;
                            pc_out = pc_old2;
                            nextstate = 2'b10;
                        end
                        //if we have a success condition
                        if (((pc_d == pc_branch) & (pc_branch_en_sel == 1)) | ((pc_d != pc_branch) & (pc_branch_en_sel == 0))) begin
                            //increment nextstate by 1
                            nextstate = 2'b11;
                            flush_de = 0;
                            flush_fd = 0;
                        end
                    end
                endcase
            end
            //Default
            default: begin
            pc_out = pc_f + 4;
            nextstate = state;
            flush_de = 0;
            flush_fd = 0;
            end
        endcase
    end
endmodule