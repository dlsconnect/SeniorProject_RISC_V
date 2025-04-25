module tb_RISC_V;

    // Clock and Reset
    logic clk;
    logic reset;

    // Instruction Memory Read Enable
    logic imem_read_en;

    // Instantiate the RISC-V module
    RISC_V_02 risc_v_core (
        .clk(clk),
        .reset(reset),
        .imem_read_en(imem_read_en)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Reset generation
    initial begin
        reset = 1; imem_read_en = 1;
        #10; reset = 0; 


        #500;
        $finish;
    end
endmodule