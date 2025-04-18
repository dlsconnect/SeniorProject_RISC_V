module Data_Memory_Block (
    input mem_write,         // Control signal: 1 = Write, 0 = Read
    input mem_read,          // Control signal: 1 = Read, 0 = No Read
    input [31:0] address,    // Memory address (byte addressable)
    input [31:0] write_data, // Data to write into memory
    output reg [31:0] read_data // Data read from memory
);

    // Define 256 words (32-bit each) = 1024 bytes of memory
    reg [31:0] Memory [255:0]; 

    // Read and write operations (combinational logic)
    always @(*) begin
        // Default read_data to zero
        read_data = 32'h00000000;

        // Handle read operation
        if (mem_read)
            read_data = Memory[address[7:2]]; // Word-aligned access

        // Handle write operation
        if (mem_write)
            Memory[address[7:2]] = write_data; // Word-aligned write
    end

endmodule
