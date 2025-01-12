`timescale 1ns / 1ps

module tb_alu();

    // Inputs
    logic [31:0] operand1;
    logic [31:0] operand2;
    logic [3:0] operation;

    // Outputs
    logic [31:0] result;
    logic zero, negative, carry, overflow;

    // Instantiate the ALU
    alu dut(
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .result(result),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );

    // Main testing sequence
    initial begin
		// Dump all of the signals in the design to the VCD file which we can view with GTKwave
		$dumpfile("alu.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT
		
        // Test case 1: Addition with no carry or overflow
        operand1 = 32'd15;
        operand2 = 32'd10;
        operation = 4'b0000; // ADD operation
        #10; // Delay for ALU operation
        $display("ADD Test: %d + %d = %d, Zero: %b, Neg: %b, Carry: %b, Overflow: %b",
                 operand1, operand2, result, zero, negative, carry, overflow);

        // Test case 2: Subtraction with borrow
        operand1 = 32'd5;
        operand2 = 32'd10;
        operation = 4'b1000; // SUB operation
        #10; // Delay for ALU operation
        $display("SUB Test: %d - %d = %d, Zero: %b, Neg: %b, Carry: %b, Overflow: %b",
                 operand1, operand2, result, zero, negative, carry, overflow);

        // Test case 3: Overflow and carry in addition
        operand1 = 32'h7FFFFFFF; // Max positive int for a 32-bit signed number
        operand2 = 32'd1;
        operation = 4'b0000; // ADD operation
        #10;
        $display("Overflow ADD Test: %d + %d = %d, Zero: %b, Neg: %b, Carry: %b, Overflow: %b",
                 operand1, operand2, result, zero, negative, carry, overflow);

        // Test case 4: Logical shift left
        operand1 = 32'h1;
        operand2 = 32'd4; // Shift by 4 positions
        operation = 4'b0001; // SLL operation
        #10;
        $display("SLL Test: %d << %d = %d, Zero: %b, Neg: %b", operand1, operand2, result, zero, negative);

		// Test 5: Set Less Than (SLT - signed comparison)
        operand1 = -10;
        operand2 = 10;
        operation = 4'b0010; // SLT operation
        #10;
        $display("SLT Test: %d < %d = %d (Expect 1)", operand1, operand2, result);

        // Test 6: Set Less Than Unsigned (SLTU - unsigned comparison)
        operand1 = 32'hFFFF0000; // Large unsigned value
        operand2 = 10;
        operation = 4'b0011; // SLTU operation
        #10;
        $display("SLTU Test: %d < %d = %d (Expect 0)", operand1, operand2, result);

        // Test 7: XOR
        operand1 = 32'hA5A5A5A5;
        operand2 = 32'h5A5A5A5A;
        operation = 4'b0100; // XOR operation
        #10;
        $display("XOR Test: %h XOR %h = %h", operand1, operand2, result);

        // Test 8: Shift Right Logical (SRL)
        operand1 = 32'hF0000000;
        operand2 = 4;
        operation = 4'b0101; // SRL operation
        #10;
        $display("SRL Test: %h >> %d = %h", operand1, operand2, result);

        // Test 9: Shift Right Arithmetic (SRA)
        operand1 = 32'hF0000000;
        operand2 = 4;
        operation = 4'b1101; // SRA operation
        #10;
        $display("SRA Test: %h >>> %d = %h", operand1, operand2, result);

        // Test 10: OR
        operand1 = 32'hA0A0A0A0;
        operand2 = 32'h5A5A5A5A;
        operation = 4'b0110; // OR operation
        #10;
        $display("OR Test: %h OR %h = %h", operand1, operand2, result);

        // Test 11: AND
        operand1 = 32'hFF00FF00;
        operand2 = 32'h00FF00FF;
        operation = 4'b0111; // AND operation
        #10;
        $display("AND Test: %h AND %h = %h", operand1, operand2, result);

        // Test 12: default case: should result in zero
        operand1 = 32'h12345678;
        operand2 = 32'h87654321;
        operation = 4'b1111; // Undefined operation
        #10;
        $display("Default Test: Operation %b, Result = %d", operation, result);

        // Test 13: -1 + 1 with expected carry
        operand1 = -1;
        operand2 = 1;
        operation = 4'b0000; // ADD operation
        #10; // Delay for ALU operation
        $display("Test -1 + 1: Result=%d, Carry: %b (Expect Carry)", result, carry);

        // Test 14: 6 - 3 should result in 3, with a carry
        operand1 = 6;
        operand2 = 3;
        operation = 4'b1000; // SUB operation
        #10; // Delay for ALU operation
        $display("Test 6 - 3: Result=%d, Carry: %b (Expect Carry)", result, carry);

        // Test 15: 2 - 3 should result in -1, with no carry
        operand1 = 2;
        operand2 = 3;
        operation = 4'b1000; // SUB operation
        #10; // Delay for ALU operation
        $display("Test 2 - 3: Result=%d, Carry: %b (Expect No Carry)", result, carry);

        // Test 16: Addition with overflow
        operand1 = 32'h7FFFFFFF;
        operand2 = 1;
        operation = 4'b0000; // ADD operation
        #10; // Delay for ALU operation
        $display("Overflow Test (+): Result=%d, Overflow: %b (Expect Overflow)", result, overflow);

        // Test 17: Addition without overflow
        operand1 = 32'h7FFFFFFE;
        operand2 = 1;
        operation = 4'b0000; // ADD operation
        #10; // Delay for ALU operation
        $display("Non-Overflow Test (+): Result=%d, Overflow: %b (Expect No Overflow)", result, overflow);
		
        // Test case 18: Overflow = 1 (Positive - Negative -> Negative Result)
        operand1 = 32'h7FFFFFFF; // Max positive integer
        operand2 = 32'h80000001; // Small negative integer
        operation = 4'b1000; // SUB operation code
        #10;
        $display("Test Case 18: Operand1 = %h, Operand2 = %h, Result = %h, Overflow = %b (Expect Overflow)", operand1, operand2, result, overflow);

        // Test case 19: Overflow = 1 (Negative - Positive -> Positive Result)
        operand1 = 32'h80000000; // Min negative integer
        operand2 = 32'h00000001; // Small positive integer
        operation = 4'b1000;
        #10;
        $display("Test Case 19: Operand1 = %h, Operand2 = %h, Result = %h, Overflow = %b (Expect Overflow)", operand1, operand2, result, overflow);

        // Test case 20: Overflow = 0 (Positive - Positive)
        operand1 = 32'h00000002; // Positive integer
        operand2 = 32'h00000001; // Smaller positive integer
        operation = 4'b1000;
        #10;
        $display("Test Case 20: Operand1 = %h, Operand2 = %h, Result = %h, Overflow = %b (Expect No Overflow)", operand1, operand2, result, overflow);

        // Test case 21: Overflow = 0 (Same sign, no overflow)
        operand1 = 32'h80000001; // Negative integer
        operand2 = 32'h80000002; // Larger negative integer (magnitude-wise)
        operation = 4'b1000;
        #10;
        $display("Test Case 21: Operand1 = %h, Operand2 = %h, Result = %h, Overflow = %b (Expect No Overflow)", operand1, operand2, result, overflow);

        // End the simulation
        $finish;
    end
endmodule
