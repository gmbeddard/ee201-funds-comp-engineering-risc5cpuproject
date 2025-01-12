`timescale 1ns / 1ps

module tb_processor();

    logic clk;
    logic reset;

    // Instantiate the processor
    processor dut(
        .clk(clk),
        .reset(reset)
    );

    // Define expected values for tests
    logic [31:0] expected_values[0:31]; // Storage for expected register values
    logic [31:0] expected_alu_result;   // Expected ALU output after specific operations

    // Generate the clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with a period of 10ns (100MHz)
    end

    // Test sequence
    initial begin
        // Initial setup
        reset = 1; // Assert reset
        #20;       // Hold reset for 20ns
        reset = 0; // Deassert reset

        // Initialize registers with known values for addition
        dut.regfile_module.registers[1] = 32'd10;
        dut.regfile_module.registers[2] = 32'd20;
        expected_values[3] = 32'd30; // Expected result of addition in Register 3

        // Allow some cycles for the processor to initialize and start operation
        #40;

        // Start monitoring
        $monitor("Time: %t, PC: %h, Instruction: %h, ALU Result: %h, Reg3: %h",
                 $time, dut.pc_module.pc_addr, dut.progmem_module.instr, dut.alu_module.result, dut.regfile_module.registers[3]);

        // Simulate ADD operation and check results
        #10; // Allow time for execution
        if (dut.regfile_module.registers[3] !== expected_values[3]) begin
            $display("Error at %0t: Register 3 contains %h, expected %h", 
                     $time, dut.regfile_module.registers[3], expected_values[3]);
        end 
		else begin
            $display("Success: ADD operation passed, Register 3 contains expected value %h", expected_values[3]);
        end

        // Finish the simulation after some time
        #100;
        $finish;
    end

    // Optionally, you can add initialization logic here to ensure that the ADD operation
    // is set correctly in the instruction memory or instruction register as part of setup.
endmodule
