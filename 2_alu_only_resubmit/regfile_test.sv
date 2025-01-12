`timescale 1ns / 1ps

module tb_regfile();

    // Inputs to the regfile
    logic clk;
    logic reset;
    logic [4:0] rs1, rs2, rd;
    logic write_enable;
    logic [31:0] rd_data;

    // Outputs from the regfile
    logic [31:0] data1, data2;

    // Instantiate the regfile
    regfile rf(
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_enable(write_enable),
        .data1(data1),
        .data2(data2),
        .rd_data(rd_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate a 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;  // Assert reset
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_enable = 0;
        rd_data = 0;
        
        #10;
        reset = 0;  // Deassert reset
        #10;

        // Test 1: Verify x0 always outputs 0 regardless of write
        rd = 0;  // Attempt to write to x0
        rd_data = 123;  // Some non-zero data
        write_enable = 1;
        #10;
        write_enable = 0;
        rs1 = 0;
        rs2 = 0;
        #10;
        if (data1 != 0 || data2 != 0) begin
            $display("Test Failed: x0 did not output 0 as expected. data1=%d, data2=%d", data1, data2);
        end else begin
            $display("Test Passed: x0 outputs 0 as expected.");
        end

        // Test 2: Write and read from a general-purpose register
        rd = 1;  // Choose register x1 to write
        rd_data = 456;  // Data to write
        write_enable = 1;
        #10;
        write_enable = 0;
        rs1 = 1;
        rs2 = 1;
        #10;
        if (data1 != 456 || data2 != 456) begin
            $display("Test Failed: Incorrect data in x1. data1=%d, data2=%d", data1, data2);
        end else begin
            $display("Test Passed: Correct data in x1.");
        end

        // Reset and check that registers are cleared except x0
        reset = 1;
        #10;
        reset = 0;
        #10;
        rs1 = 1;  // Check x1 after reset
        #10;
        if (data1 != 0) begin
            $display("Test Failed: x1 not cleared after reset. data1=%d", data1);
        end else begin
            $display("Test Passed: x1 cleared after reset.");
        end

        // Conclude the test
        $finish;
    end

    // Monitor activities
    initial begin
        $monitor("At time %t, rs1=%d, data1=%d, rs2=%d, data2=%d", $time, rs1, data1, rs2, data2);
    end

endmodule