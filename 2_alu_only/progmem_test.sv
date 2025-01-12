`timescale 1ns / 1ps

module tb_progmem;

    // Testbench signals
    logic [31:0] addr;
    logic [31:0] instr;

    // Instantiate the program memory module
    progmem dut (
        .addr(addr),
        .instr(instr)
    );

    // Test sequence
    initial begin
		// Save all of the simulation signals to a file
        $dumpfile("progmem.vcd");
		$dumpvars(0, dut); // Dump all of the signals in the DUT

	
        // Initialize the address
        addr = 32'h0;
        #10; // Wait for combinational logic to settle
        check_instruction(addr, 32'h00000013);

        addr = 32'h4;
        #10;
        check_instruction(addr, 32'h001000b3);

        addr = 32'h8;
        #10;
        check_instruction(addr, 32'h00408093);

        addr = 32'hc;
        #10;
        check_instruction(addr, 32'h00208133);
		
		addr = 32'h10;
        #10;
        check_instruction(addr, 32'h00108093);
		
		addr = 32'h14;
        #10;
        check_instruction(addr, 32'hfff08093);
		
		addr = 32'h18;
        #10;
        check_instruction(addr, 32'h001170b3);
		
		addr = 32'h1c;
        #10;
        check_instruction(addr, 32'h001160b3);
		
		addr = 32'h20;
        #10;
        check_instruction(addr, 32'h001140b3);
		
		addr = 32'h24;
        #10;
        check_instruction(addr, 32'h001120b3);
		
		addr = 32'h28;
        #10;
        check_instruction(addr, 32'h001130b3);
		
		addr = 32'h2c;
        #10;
        check_instruction(addr, 32'h001110b3);
		
		addr = 32'h30;
        #10;
        check_instruction(addr, 32'h001150b3);
		
		addr = 32'h34;
        #10;
        check_instruction(addr, 32'h001100b3);

        addr = 32'h38;
        #10;
        check_instruction(addr, 32'h401150b3);

        // Check an address that should default to 0
        addr = 32'h3C;
        #10;
        check_instruction(addr, 32'h00000000);

        // Finish the simulation
        $finish;
    end

    // Task to check if the instruction matches the expected value
    task check_instruction(input logic [31:0] address, input logic [31:0] expected_instr);
        begin
            if (instr !== expected_instr) begin
                $error("Mismatch at address %h: expected %h, got %h", address, expected_instr, instr);
            end else begin
                $display("Match at address %h: expected %h, got %h", address, expected_instr, instr);
            end
        end
    endtask

endmodule
