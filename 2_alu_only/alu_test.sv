`timescale 1ns / 1ps

module tb_alu;

    // Testbench signals
    logic [31:0] operand1, operand2, result, expected_result;
    logic [3:0] operation;

    // Instantiate the ALU
    alu dut (
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .result(result)
    );


    // Main testing sequence
    initial begin
		// Dump all of the signals in the design to the VCD file which we can view with GTKwave
		$dumpfile("pc.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT
		
        // Initialize signals
        operand1 = 0;
        operand2 = 0;
        operation = 0;
        expected_result = 0;
		#10;
		
        // Test case 1: Addition
        operand1 = 32'h10;
        operand2 = 32'h20;
        expected_result = 32'h30;
        operation = 4'b0000; // ADD operation
        #10;
        check_result("Addition", expected_result);

        // Test case 2: Subtraction
        operand1 = 32'h30;
        operand2 = 32'h10;
        expected_result = 32'h20;
        operation = 4'b1000; // SUB operation
        #10;
        check_result("Subtraction", expected_result);

        // Test case 3: AND
        operand1 = 32'hFF00;
        operand2 = 32'h0F0F;
        expected_result = 32'h0F00;
        operation = 4'b0111; // AND operation
        #10;
        check_result("AND", expected_result);

        // Test case 4: OR
        operand1 = 32'hFF00;
        operand2 = 32'h00FF;
        expected_result = 32'hFFFF;
        operation = 4'b0110; // OR operation
        #10;
        check_result("OR", expected_result);

        // Test case 5: XOR
        operand1 = 32'hFFFF;
        operand2 = 32'h00FF;
        expected_result = 32'hFF00;
        operation = 4'b0100; // XOR operation
        #10;
        check_result("XOR", expected_result);

        // Test case 6: Shift Left Logical (SLL)
        operand1 = 32'h1;
        operand2 = 32'h4; // shift by 4 bits
        expected_result = 32'h10;
        operation = 4'b0001; // SLL operation
        #10;
        check_result("Shift Left Logical", expected_result);

        // Test case 7: Shift Right Logical (SRL)
        operand1 = 32'h10;
        operand2 = 32'h1; // shift by 1 bit
        expected_result = 32'h8;
        operation = 4'b0101; // SRL operation
        #10;
        check_result("Shift Right Logical", expected_result);

        // Test case 8: Shift Right Arithmetic (SRA)
        operand1 = 32'hF0000000;
        operand2 = 32'h4; // shift by 4 bits
        expected_result = 32'hFF000000;
        operation = 4'b1101; // SRA operation
        #10;
        check_result("Shift Right Arithmetic", expected_result);

        // Finish the simulation
        $finish;
    end

    // Task to check results against expected values
    task check_result(string operation_name, logic [31:0] expected_value);
        begin
            if (result !== expected_value) begin
                $error("%s Test Failed: %h expected, got %h", operation_name, expected_value, result);
            end else begin
                $display("%s Test Passed: %h expected, got %h", operation_name, expected_value, result);
            end
        end
    endtask

endmodule
