module immextend(input logic[31:0] instr,
                 output logic[31:0] imm32);

  // Define constants for instruction opcodes for clarity
  localparam [6:0] OPCODE_I_TYPE = 7'b0010011;  // ALU with immediates (e.g., addi)

  // Detect if it is an I-type instruction
  logic is_I_type;

  always_comb begin
    is_I_type = (instr[6:0] == OPCODE_I_TYPE);
  end

  // I-Type immediate (12 bits directly from the instruction)
  wire [31:0] imm_I_type = {{20{instr[31]}}, instr[31:20]};

  // Select the correct immediate based on the instruction type
  always_comb begin
    if (is_I_type) imm32 = imm_I_type;
    else imm32 = 32'b0;  // Zero or undefined for unsupported types
  end

endmodule
