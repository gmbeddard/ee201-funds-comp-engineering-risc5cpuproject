`timescale 1ns / 1ps

module tb_immextend;

    // Testbench signals
    logic [31:0] instr;
    logic [31:0] imm32;

    // Instantiate the immextend module
    immextend dut (
        .instr(instr),
        .imm32(imm32)
    );

    // Test sequence
    initial begin
		// Dump all of the signals in the design to the VCD file which we can view with GTKwave
		$dumpfile("pc.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT
	
		// Initialize the instruction signal
        instr = 0;

        // Test Case 1: I-Type Immediate
        // Opcode for I-type (assuming Load), immediate value = 0xABC (12-bit)
        instr = {5'b0, 7'b1010111, 5'b0, 5'b0, 3'b0, 7'b0000011}; // Constructing an I-type instruction
        #10;  // Delay to simulate time for propagation
        $display("I-Type Immediate Test: Instruction=%h, Extended Immediate=%h", instr, imm32);

        // Test Case 2: S-Type Immediate
        // Opcode for S-type (assuming Store), immediate value = 0x5A (split between bits)
        instr = {5'b10101, 7'b1010111, 5'b0, 5'b0, 3'b0, 7'b0100011}; // Constructing an S-type instruction
        #10;  // Delay to simulate time for propagation
        $display("S-Type Immediate Test: Instruction=%h, Extended Immediate=%h", instr, imm32);

        $finish;
    end

endmodule
