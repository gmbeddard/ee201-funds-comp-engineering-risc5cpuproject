module immextend(
    input logic [31:0] instr,
    output logic [31:0] imm32
);

    // Define constants for instruction opcodes for clarity
    localparam logic [6:0] OPCODE_I_TYPE_ALU = 7'b0010011, // ALU with immediates (e.g., addi)
                           OPCODE_L_TYPE = 7'b0000011,     // Loads
                           OPCODE_S_TYPE = 7'b0100011,     // Stores
                           OPCODE_B_TYPE = 7'b1100011,     // Branches
                           OPCODE_JALR = 7'b1100111,       // JALR
                           OPCODE_JAL = 7'b1101111;        // JAL

    // Immediate extraction and sign-extension
    assign imm32 = (instr[6:0] == OPCODE_I_TYPE_ALU) ? {{20{instr[31]}}, instr[31:20]} :  // I-Type ALU
                   (instr[6:0] == OPCODE_L_TYPE) ? {{20{instr[31]}}, instr[31:20]} :     // L-Type Load
                   (instr[6:0] == OPCODE_S_TYPE) ? {{20{instr[31]}}, instr[31:25], instr[11:7]} : // S-Type Store
                   (instr[6:0] == OPCODE_B_TYPE) ? {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} : // B-Type Branch
                   (instr[6:0] == OPCODE_JALR) ? {{20{instr[31]}}, instr[31:20]} :   // JALR
                   (instr[6:0] == OPCODE_JAL) ? {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0} :  // JAL
                   32'b0;  // Zero for unsupported types

endmodule
