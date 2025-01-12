module branchcheck(
    input logic[31:0] instr,
    input logic[3:0] aluflags, // Ordered NZCV (Negative, Zero, Carry, Overflow)
    output logic taken
);
	
    // Extract flags
	assign neg_flag = aluflags[3];      // Negative [N]
    assign zero_flag = aluflags[2];     // Zero [Z]
    assign carry_flag = aluflags[1];    // Carry [C]
    assign overflow_flag = aluflags[0]; // Overflow [V]
	
	// Decode the opcode and funct3 fields from the instruction
    logic [6:0] opcode;
    logic [3:0] funct3;
	
	assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
	
	// Identify branch and jump opcodes
    localparam OPCODE_BRANCH = 7'b1100011;		// from p. 130 RSIC-V
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;

    // Determine branch take conditions based on instruction type
    always_comb begin
        taken = 0;  // Default to not taken
        if (opcode == OPCODE_BRANCH) begin
            case (funct3)
                3'b000: taken = zero_flag;                    	// BEQ
                3'b001: taken = !zero_flag;                   	// BNE
                3'b100: taken = (neg_flag ^ overflow_flag);    	// BLT
                3'b101: taken = !(neg_flag ^ overflow_flag);    // BGE
                3'b110: taken = !carry_flag;                  	// BLTU
                3'b111: taken = carry_flag;                   	// BGEU
            endcase
        end else if (opcode == OPCODE_JAL || opcode == OPCODE_JALR) begin
            taken = 1;  // JAL and JALR always result in a jump
        end
    end
endmodule
