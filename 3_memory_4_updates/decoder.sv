module decode(
    input logic [31:0] instruction,
    output logic write_enable,
    output logic mem_write_enable,
    output logic mem_to_reg,
    output logic alu_src,
    output logic [3:0] alu_op,
    output logic branch,
    output logic jump,
    output logic jalr,
    output logic invalid_opcode  // Signal to indicate unsupported opcode
);

    // Decode fields from the instruction
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    // Define constants for opcodes
    localparam [6:0] OPCODE_R_TYPE = 7'b0110011, // Standard R-type (add, sub, etc.)
                     OPCODE_I_TYPE = 7'b0010011, // Immediate operations (addi, slli, etc.)
                     OPCODE_LOAD   = 7'b0000011, // Load operations (lw, lh, etc.)
                     OPCODE_STORE  = 7'b0100011, // Store operations (sw, sh, etc.)
                     OPCODE_BRANCH = 7'b1100011, // Branches (beq, bne, etc.)
                     OPCODE_JAL    = 7'b1101111, // Jump and link
                     OPCODE_JALR   = 7'b1100111; // Jump and link register

    // Control signal logic based on opcode
    always_comb begin
        // Reset all signals
        write_enable = 0;
        mem_write_enable = 0;
        mem_to_reg = 0;
        alu_src = 0;
        alu_op = 4'b0000;  // Default ALU operation
        branch = 0;
        jump = 0;
        jalr = 0;
        invalid_opcode = 0;  // Default to valid opcode

        // Set control signals based on opcode
        case (opcode)
            OPCODE_R_TYPE: begin
                write_enable = 1;
                alu_src = 0;
                alu_op = 4'b0010; // Example ALU op
            end
            OPCODE_I_TYPE: begin
                write_enable = 1;
                alu_src = 1;
                alu_op = 4'b0011; // Example ALU op for immediate type
            end
            OPCODE_LOAD: begin
                write_enable = 1;
                mem_to_reg = 1;
                alu_src = 1; // Use immediate for memory address calculation
            end
            OPCODE_STORE: begin
                mem_write_enable = 1;
                alu_src = 1; // Use immediate for memory address calculation
            end
            OPCODE_BRANCH: begin
                branch = 1;
                alu_op = 4'b0110; // Assume subtract for branch comparison
            end
            OPCODE_JAL: begin
                write_enable = 1;
                jump = 1;
            end
            OPCODE_JALR: begin
                write_enable = 1;
                jalr = 1;
            end
            default: begin
                // Handle unsupported opcode
                invalid_opcode = 1;  // Set this flag when an unsupported opcode is detected
                write_enable = 0;
                mem_write_enable = 0;
                mem_to_reg = 0;
                alu_src = 0;
                alu_op = 4'b0000;
                branch = 0;
                jump = 0;
                jalr = 0;
            end
        endcase
    end
endmodule
