module decoder(
    input logic [31:0] instruction,
    output logic write_enable,
    output logic mem_write_enable,
    output logic mem_to_reg,
    output logic [3:0] alu_op,
    output logic alu_src
);

    // Define local parameters for opcodes
    localparam [6:0] OPCODE_RTYPE = 7'b0110011,
                     OPCODE_ITYPE = 7'b0010011,
                     OPCODE_LOAD  = 7'b0000011,
                     OPCODE_STORE = 7'b0100011;

    // Define local parameters for ALU operations
    localparam [3:0] ALU_ADD = 4'd0,
                     ALU_NOP = 4'd15; // Define a NOP operation code if applicable

    // Decode logic
    always_comb begin
        // Default values for undefined instructions
        write_enable = 0;
        mem_write_enable = 0;
        mem_to_reg = 0;
        alu_op = ALU_NOP; // Set to NOP operation, assume ALU handles NOP safely
        alu_src = 0;     // Default to using register to avoid errors

        case (instruction[6:0])  // Check the opcode field
            OPCODE_RTYPE: begin
                write_enable = 1;
                alu_src = 0;  // ALU uses registers
                alu_op = ALU_ADD; // Assume add for R-type for simplicity
            end
            OPCODE_ITYPE: begin
                write_enable = 1;
                alu_src = 1;  // ALU uses immediate
                alu_op = ALU_ADD; // Assume add immediate for I-type
            end
            OPCODE_LOAD: begin
                write_enable = 1;
                mem_to_reg = 1; // Load from memory
                alu_src = 1;    // Address calculation uses immediate
                alu_op = ALU_ADD; // Address computation
            end
            OPCODE_STORE: begin
                mem_write_enable = 1;
                alu_src = 1;  // Address calculation uses immediate
                alu_op = ALU_ADD; // Address computation
            end
            default: begin
                // Handle undefined or unsupported instructions
                write_enable = 0;
                mem_write_enable = 0;
                mem_to_reg = 0;
                alu_op = ALU_NOP;  // No operation on undefined instruction
                alu_src = 0;       // Default to safe state
                // Optionally trigger an exception or similar mechanism here
            end
        endcase
    end

endmodule
