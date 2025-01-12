module immextend(input logic[31:0] instr,
                 output logic[31:0] imm32);

  // Complete this module to extend the 12-bit immediate for an ALU operation
  // (such as addi) to 32 bits.  Make sure to use sign-extension so that
  // negative numbers stay negative when extended to 32 bits!
    assign imm32 = {{20{instr[31]}}, instr[31:20]};


/*
	always_comb begin
		imm32 = 0; 	// initialize output
		
		// We want to extend our input bits of [31:20] to [31:0]
		// 1. assign existing 12 bits from input to first 12 bits of output!
		imm32[11:0] = instr[31:20];
		
		// 2. Fill in the rest of the 20 bits depending on sign
		// 2a. If negative, fill upper 20 bits with 1's
		// 2b. If positive, fill ... with 0s
		if (instr[31]) begin
			imm32[31:12] = 20'hFFFFF; 
		end
		else begin
			imm32[31:12] = 20'h00000;
		end
	end
*/
endmodule
