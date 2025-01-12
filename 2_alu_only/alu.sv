
module alu(input logic[31:0] operand1,
           input logic[31:0] operand2,
           input logic[3:0] operation, // This is {imm7[5], imm3}, other bits of imm7 are always 0 for RV32I
           output logic[31:0] result);

  // Complete this module to compute the correct result for the specified operations
  // Note that not all operations are specified; you can leave the output 0 or undefined in this case
	always_comb begin
        case (operation)
            4'b0000: result = operand1 + operand2;                          // ADD
			4'b1000: result = operand1 - operand2;                          // SUB
            4'b0001: result = operand1 << operand2[4:0];                    // SLL
			4'b0010: result = ($signed(operand1) < $signed(operand2)) ? 32'b1 : 32'b0; // SLT
			4'b0011: result = (operand1 < operand2) ? 32'b1 : 32'b0;        // SLTU
			4'b0100: result = operand1 ^ operand2;                          // XOR
			4'b0101: result = operand1 >> operand2[4:0];                    // SRL
            4'b1101: result = $signed(operand1) >>> operand2[4:0];          // SRA
            4'b0110: result = operand1 | operand2;                          // OR
			4'b0111: result = operand1 & operand2;                          // AND
            default: result = 32'b0;                                         // Undefined operations
        endcase
    end

endmodule

