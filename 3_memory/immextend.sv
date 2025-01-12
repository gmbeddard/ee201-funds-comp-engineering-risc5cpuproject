module immextend(input logic[31:0] instr,
                 output logic[31:0] imm32);

  // Complete this module to extend the 12-bit immediate for an ALU operation
  // (such as addi) to 32 bits.  Make sure to use sign-extension so that
  // negative numbers stay negative when extended to 32 bits!
    // Define constants for instruction opcodes for clarity
    localparam [6:0] OPCODE_I_TYPE = 7'b0000011,  // Loads, ALU with immediates
                     OPCODE_S_TYPE = 7'b0100011;  // Stores

    // Detect instruction type based on opcode
    logic is_I_type, is_S_type;

    always_comb begin
        case (instr[6:0])  // Check opcode
            OPCODE_I_TYPE: begin
                is_I_type = 1;
                is_S_type = 0;
            end
            OPCODE_S_TYPE: begin
                is_I_type = 0;
                is_S_type = 1;
            end
            default: begin
                is_I_type = 0;
                is_S_type = 0;
            end
        endcase
    end

    // I-Type immediate (12 bits directly from the instruction)
    wire [31:0] imm_I_type = {{20{instr[31]}}, instr[31:20]};

    // S-Type immediate (constructed from parts of the instruction)
    wire [31:0] imm_S_type = {{20{instr[31]}}, instr[31:25], instr[11:7]};

    // Select the correct immediate based on the instruction type
    always_comb begin
        if (is_I_type) imm32 = imm_I_type;
        else if (is_S_type) imm32 = imm_S_type;
        else imm32 = 32'b0;  // Zero or undefined for unsupported types
    end

endmodule