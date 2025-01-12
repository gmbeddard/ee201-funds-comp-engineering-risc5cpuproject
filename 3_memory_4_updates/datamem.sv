module datamem(input logic clk,
               input logic[31:0] addr, // Note that not all of the address bits are valid, we don't have 4GB of memory!
               input logic write_enable,
               output logic[31:0] data,
               input logic[31:0] data_in);

    // Declare the memory array
    parameter int MEM_WORDS = 32;
    logic[31:0] memory[MEM_WORDS-1:0];

    // There's no reset for this module; the value will get updated as you write to them
	// Remember that the address is a *byte* address, but the memory array stores *words*.
	
	// Calculate word index from byte address by right-shifting by 2 bits (divide by 4)
    logic[4:0] word_addr;  // Only use as many bits as needed to address MEM_WORDS
	assign word_addr = addr[6:2];
	
    always_ff @(posedge clk) begin
        if (write_enable) begin
            // Write data to memory if write_enable is active
            memory[word_addr] <= data_in;
        end
    end

    // Read data from memory, combinational read
    assign data = memory[word_addr];
    
endmodule

