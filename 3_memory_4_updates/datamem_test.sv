`timescale 1ns / 1ps

module tb_datamem();

    // Testbench signals
    logic clk;
    logic [31:0] addr;
    logic write_enable;
    logic [31:0] data_in;
    logic [31:0] data_out;

    // Instantiate the data memory module
    datamem dut(
        .clk(clk),
        .addr(addr),
        .write_enable(write_enable),
        .data(data_out),
        .data_in(data_in)
    );

    // Generate the clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a clock with 100 MHz frequency (10 ns period)
    end

    // Test sequence
    initial begin
		// Save all of the simulation signals to a file
        $dumpfile("datamem.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT
		
        // Initialize signals
        write_enable = 0;
        addr = 0;
        data_in = 0;

        // Allow some time for initial setup
        #20;

        // Example test case 1: Write and then read from address 0
        addr = 4 * 0;  // Address is word-aligned
        data_in = 32'hDEADBEEF; // Example data to write
        write_enable = 1; // Enable write operation
        #10; // Wait one clock cycle for write to occur
        write_enable = 0; // Disable write
        #10; // Wait one clock cycle before reading

        // Verify the data written is the data read
        if (data_out !== data_in) begin
            $display("Test Failed: Data mismatch at address %h, expected %h, got %h", addr, data_in, data_out);
        end else begin
            $display("Test Passed: Correct data %h read from address %h", data_out, addr);
        end

        // Example test case 2: Write and read at another address
        addr = 4 * 1;  // Next word-aligned address
        data_in = 32'hCDFEBAAE; // New data to write
        write_enable = 1;
        #10; // Write new data
        write_enable = 0;
        #10; // Wait before reading

        // Read the new data
        #10; // Read data

        // Check the result
        if (data_out !== data_in) begin
            $display("Test Failed: Data mismatch at address %h, expected %h, got %h", addr, data_in, data_out);
        end else begin
            $display("Test Passed: Correct data %h read from address %h", data_out, addr);
        end

        // Conclude test
        #100;
        $finish;
    end
endmodule
