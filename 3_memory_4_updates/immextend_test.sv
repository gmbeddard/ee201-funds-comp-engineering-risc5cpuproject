`timescale 1ns / 1ps

module tb_immextend;

    // Testbench signals
    logic [31:0] instr;
    logic [31:0] imm32;
    logic [31:0] expected_imm;


    // Instantiate the immextend module
    immextend dut (
        .instr(instr),
        .imm32(imm32)
    );

	// Function to check if the results match
    function void check_result(string description, logic [31:0] actual, logic [31:0] expected);
        if (actual != expected) begin
            $display("%s FAILED: Expected %h, Got %h", description, expected, actual);
        end else begin
            $display("%s PASSED", description);
        end
    endfunction
	
    // Test sequence
    initial begin
        // Dump all of the signals in the design to the VCD file for visualization
        $dumpfile("immextend.vcd");
        $dumpvars(0, tb_immextend); // Dump all signals in the testbench

		// Initialize the instruction signal
        instr = 0;

        // Test Case 1: I-Type ALU (addi)
        instr = 32'h40000293;  // addi x5, x0, 1024 (0x400 is 1024 in decimal)
        #10;
        check_result("I-Type ALU Immediate Test", imm32, 32'h00000400);

        // Test Case 2: L-Type Load (lw)
        instr = 32'h00012303;  // lw x6, 0(x2)
        #10;
        check_result("L-Type Load Immediate Test", imm32, 32'h00000000);

        // Test Case 3: S-Type Store (sw)
        instr = 32'h02112023;  // sw x1, 32(x2) (0x020 offset)
        #10;
        check_result("S-Type Store Immediate Test", imm32, 32'h00000020);  // -32 in decimal, sign-extended

        // Test Case 4: B-Type Branch (beq)
        instr = 32'h00000463;  // beq x0, x0, 8 (branch forward 8 bytes)
        #10;
        check_result("B-Type Branch Immediate Test", imm32, 32'h00000008);

        // Test Case 5: JALR
        instr = 32'h00008067;  // jalr x1, x0, 0
        #10;
        check_result("JALR Immediate Test", imm32, 32'h00000000);

        // Test Case 6: JAL
        instr = 32'h0f0000ef;  // jal x1, 240 (forward jump 240 bytes)
        #10;
        check_result("JAL Immediate Test", imm32, 32'h000000F0);

        // Test Case 7: R-Type (add)
        instr = 32'h003302B3;  // add x5, x6, x3
        #10;
        check_result("R-Type Immediate Test", imm32, 32'h00000000);  // Should be zero since R-Types have no immediates

        $finish;
    end

endmodule