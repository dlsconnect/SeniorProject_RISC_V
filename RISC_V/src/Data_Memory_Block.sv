module Data_Memory_Block (
    input mem_write,         // Control signal: 1 = Write, 0 = Read
    input mem_read,          // Control signal: 1 = Read, 0 = No Read
    input [31:0] address,    // Memory address (byte addressable)
    input [31:0] write_data, // Data to write into memory
    output reg [31:0] read_data // Data read from memory
);

    // Define 1000 words (32-bit each) = 4000 bytes of memory
    reg [31:0] data_memory [0:3999];

    // 10-bit word index from byte address (bits 2-11)
    logic [9:0] widx;

    initial begin
        for (int i = 0; i < 4000; i = i + 1)
            if (i % 4 == 0) // Initialize every 4th word to zero
                 data_memory[i] = $urandom();
            else // Random initialization for other words
            data_memory[i] = 32'b0;
    end

    // Read operations (combinational logic)
    always @(*) begin
        read_data = 32'h0000_0000;   // default

        widx = address[11:2];

        if (mem_read) begin
            if (widx < 3999)  // Check bounds for 4000 words (0-3999)
                read_data = data_memory[widx];
            else
                read_data = 32'hDEAD_BEEF; // out-of-bounds signature
        end

        if (mem_write && (widx < 3999)) begin
            data_memory[widx] <= write_data;
        end
    end

endmodule
