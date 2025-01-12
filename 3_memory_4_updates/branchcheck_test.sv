`timescale 1ns / 1ps

module tb_branchcheck();

    // Inputs to the branchcheck
    logic [31:0] instr;
    logic [3:0] aluflags; // Ordered as NZCV
    wire taken;

    // Instantiate the branchcheck module
    branchcheck dut(
        .instr(instr),
        .aluflags(aluflags),
        .taken(taken)
    );

    // Define the opcode and funct3 fields
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;

    // Test sequences
    initial begin
        // Dump all of the signals in the design to the VCD file which we can view with GTKwave
        $dumpfile("branchcheck.vcd");
        $dumpvars(0, dut); // Dump all of the signals in the DUT

        // Initialize inputs
        instr = 0;
        aluflags = 4'b0000; // All flags cleared

        // Branch instruction tests with each funct3 condition
        $display("Branch Condition Tests:");

        // Test BEQ, Zero = 1 (taken)
        instr = {19'b0, 3'b000, 5'b0, OPCODE_BRANCH}; // funct3 = 000
        aluflags = 4'b0100; // NZCV (zero_flag set)
        #10;
        $display("Test BEQ - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Test BNE, Zero = 0 (taken)
        instr = {19'b0, 3'b001, 5'b0, OPCODE_BRANCH}; // funct3 = 001
        aluflags = 4'b0000; // NZCV
        #10;
        $display("Test BNE - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Test BLT, Negative XOR Overflow = 1 (taken)
        instr = {19'b0, 3'b100, 5'b0, OPCODE_BRANCH}; // funct3 = 100
        aluflags = 4'b1000; // NZCV (negative set, overflow clear)
        #10;
        $display("Test BLT - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Test BGE, Negative XOR Overflow = 1 (taken)
        instr = {19'b0, 3'b101, 5'b0, OPCODE_BRANCH}; // funct3 = 101
        aluflags = 4'b1001; // NZCV (negative and overflow set)
        #10;
        $display("Test BGE - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Test BLTU, Carry = 0 (not taken)
        instr = {19'b0, 3'b110, 5'b0, OPCODE_BRANCH}; // funct3 = 110
        aluflags = 4'b0010; // NZCV (carry clear)
        #10;
        $display("Test BLTU - Flags: %b, Expected: 0, Result: %b", aluflags, taken);

        // Test BGEU, Carry = 1 (taken)
        instr = {19'b0, 3'b111, 5'b0, OPCODE_BRANCH}; // funct3 = 111
        aluflags = 4'b1010; // NZCV (carry set)
        #10;
        $display("Test BGEU - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Jump instructions tests
        $display("Jump Instructions Tests:");

        // Test JAL should always be taken
        instr = {25'b0, OPCODE_JAL};
        #10;
        $display("Jump Test JAL - Result: %b (Expected: 1)", taken);

        // Test JALR should always be taken
        instr = {25'b0, OPCODE_JALR};
        #10;
        $display("Jump Test JALR - Result: %b (Expected: 1)", taken);

        $finish;
    end

endmodule


/*`timescale 1ns / 1ps

module tb_branchcheck();

    // Inputs to the branchcheck
    logic [31:0] instr;
    logic [3:0] aluflags; // Ordered as NZCV
    logic taken;

    // Instantiate the branchcheck module
    branchcheck dut(
        .instr(instr),
        .aluflags(aluflags),
        .taken(taken)
    );

    // Define the opcode and funct3 fields
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;

    // Test sequences
    initial begin
        // Dump all of the signals in the design to the VCD file which we can view with GTKwave
        $dumpfile("branchcheck.vcd");
        $dumpvars(0, dut); // Dump all of the signals in the DUT

        // Initialize inputs
        instr = 0;
        aluflags = 4'b0000; // All flags cleared

        // Branch instruction tests with each funct3 condition
        $display("Branch Condition Tests:");

        // BEQ, Zero = 1 (taken)
        instr = {25'b0, 3'b000, OPCODE_BRANCH};
        aluflags = 4'b0100;
        #10;
        $display("Test BEQ - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // BNE, Zero = 0 (taken)
        instr = {25'b0, 3'b001, OPCODE_BRANCH};
        aluflags = 4'b0000;
        #10;
        $display("Test BNE - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // BLT, Negative XOR Overflow = 1 (taken)
        instr = {25'b0, 3'b100, OPCODE_BRANCH};
        aluflags = 4'b1000;
        #10;
        $display("Test BLT - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // BGE, Negative XOR Overflow = 0 (not taken)
        instr = {25'b0, 3'b101, OPCODE_BRANCH};
        aluflags = 4'b1001;
        #10;
        $display("Test BGE - Flags: %b, Expected: 0, Result: %b", aluflags, taken);

        // BLTU, Carry = 0 (not taken)
        instr = {25'b0, 3'b110, OPCODE_BRANCH};
        aluflags = 4'b0010;
        #10;
        $display("Test BLTU - Flags: %b, Expected: 0, Result: %b", aluflags, taken);

        // BGEU, Carry = 1 (taken)
        instr = {25'b0, 3'b111, OPCODE_BRANCH};
        aluflags = 4'b1010;
        #10;
        $display("Test BGEU - Flags: %b, Expected: 1, Result: %b", aluflags, taken);

        // Jump instructions tests
        $display("Jump Instructions Tests:");

        // JAL should always be taken
        instr = {25'b0, OPCODE_JAL};
        #10;
        $display("Jump Test JAL - Result: %b (Expected: 1)", taken);

        // JALR should always be taken
        instr = {25'b0, OPCODE_JALR};
        #10;
        $display("Jump Test JALR - Result: %b (Expected: 1)", taken);

        $finish;
    end

endmodule
*/

/*`timescale 1ns / 1ps

module tb_branchcheck();

    // Inputs to the branchcheck
    logic [31:0] instr;
    logic [3:0] aluflags; // Ordered as NZCV
    logic taken;

    // Instantiate the branchcheck module
    branchcheck dut(
        .instr(instr),
        .aluflags(aluflags),
        .taken(taken)
    );

    // Define the opcode and funct3 fields
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;

    // Test sequences
    initial begin
		// Dump all of the signals in the design to the VCD file which we can view with GTKwave
		$dumpfile("branchcheck.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT
		
        // Initialize inputs
        instr = 0;
        aluflags = 4'b0000; // All flags cleared

        // Branch instruction tests with each funct3 condition
        $display("Branch Condition Tests:");
        test_branch_condition(3'b000, 4'b0100, 1);  // BEQ, Zero = 1 (taken)
        test_branch_condition(3'b001, 4'b0000, 1);  // BNE, Zero = 0 (taken)
        test_branch_condition(3'b100, 4'b1000, 1);  // BLT, Negative XOR Overflow = 1 (taken)
        test_branch_condition(3'b101, 4'b1000, 0);  // BGE, Negative XOR Overflow = 1 (not taken)
        test_branch_condition(3'b110, 4'b0010, 0);  // BLTU, Carry = 0 (not taken)
        test_branch_condition(3'b111, 4'b1010, 1);  // BGEU, Carry = 1 (taken)

        // Jump instructions tests
        $display("Jump Instructions Tests:");
        test_jump_instruction(OPCODE_JAL);    // JAL should always be taken
        test_jump_instruction(OPCODE_JALR);   // JALR should always be taken

        $finish;
    end

	// Helper task for testing branch conditions
	task test_branch_condition(input [2:0] funct3, input [3:0] flags, input expected_taken);
		begin
			instr = {19'b0, funct3, OPCODE_BRANCH}; // Set opcode and funct3
			aluflags = flags; // Set ALU flags
			#10; // Wait for the logic to evaluate
			$display("Test %b - Flags: %b, Expected: %b, Result: %b", funct3, flags, expected_taken, taken);
			$display("Detailed Check: Instr=%h, Funct3=%b, Opcode=%b, Flags=%b", instr, funct3, instr[6:0], aluflags);
		end
	endtask

    // Helper task for testing jump instructions
    task test_jump_instruction(input [6:0] opcode);
        begin
            instr = {25'b0, opcode}; // Set the opcode for jump instructions
            #10; // Allow time for the logic to evaluate
            $display("Jump Test - Opcode: %b, Result: %b (Expected: 1)", opcode, taken);
        end
    endtask

endmodule*/