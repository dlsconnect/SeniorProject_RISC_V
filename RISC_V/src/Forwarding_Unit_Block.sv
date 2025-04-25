module Forwarding_Unit_Block(
    //inputs
    input [4:0] reg_writeaddress_m, reg_readaddress1_e, reg_readaddress2_e,

    //outputs
    output logic alumul_data1_sel_e, alumul_forward_sel_e
);
    //alumul input mux control
    always_comb begin
    alumul_data1_sel_e = (reg_writeaddress_m == reg_readaddress1_e) ? 1'b1 : 1'b0;
    alumul_forward_sel_e = (reg_writeaddress_m == reg_readaddress2_e) ? 1'b1 : 1'b0;
    end
endmodule