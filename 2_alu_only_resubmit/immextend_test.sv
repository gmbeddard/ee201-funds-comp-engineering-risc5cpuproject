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
	
	
        // Initialize instruction
        instr = 32'b0;

        // Test with positive imm
        instr[31:20] = 12'h005; // imm = 0000_0000_0101 (5 in decimal)
        #10;
        $display("Test with positive imm: Instr = %b, Extended imm = %h", instr, imm32);
        assert(imm32 == 32'h00000005) else $error("Test failed for positive immediate");

        // Test with negative imm
        instr[31:20] = 12'h805; // imm = 1000_0000_0101 (-2043 in decimal, 2's complement)
        #10;
        $display("Test with negative imm: Instr = %b, Extended imm = %h", instr, imm32);
        assert(imm32 == 32'hFFFFF805) else $error("Test failed for negative immediate");

        // Additional tests can be added here
        // Finish the simulation
        $finish;
    end

endmodule
