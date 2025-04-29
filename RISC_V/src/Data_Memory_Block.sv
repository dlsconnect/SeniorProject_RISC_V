module Data_Memory_Block (
    input mem_write,         // Control signal: 1 = Write, 0 = Read
    input mem_read,          // Control signal: 1 = Read, 0 = No Read
    input [31:0] address,    // Memory address (byte addressable)
    input [31:0] write_data, // Data to write into memory
    output reg [31:0] read_data // Data read from memory
);

    // Define 1000 words (32-bit each) = 4000 bytes of memory
    reg [31:0] data_memory [0:999];

    initial begin
    foreach (data_memory[i])
        data_memory[i] = $urandom();   // 1000 iterations: i = 0 … 999
    end


    // Read and write operations (combinational logic)
    always @(*) begin
        // Default read_data to zero
        read_data = 32'h00000000;

        // Handle read operation only if mem_read is asserted
        if (mem_read) begin
            if (address[7:2] < 1000) begin
                read_data = data_memory[address[7:2]]; // Word-aligned access
            end else begin
                read_data = 32'hDEADBEEF; // Return a known invalid value for out-of-bounds access
            end
        end

        // Handle write operation only if mem_write is asserted
        if (mem_write && address[7:2] < 1000) begin
            data_memory[address[7:2]] = write_data; // Word-aligned write
        end
    end

endmodule
