module alu(
    input logic[31:0] operand1,
    input logic[31:0] operand2,
    input logic[3:0] operation, // {imm7[5], imm3}, other bits of imm7 are always 0 for RV32I
    output logic[31:0] result,
    output logic zero,          // Result is zero
    output logic negative,      // Result is negative (MSB is 1)
    output logic carry,         // Carry out from the last bit in addition/subtraction
    output logic overflow       // Overflow occurred during addition/subtraction
);

    // Temporary variables for carry and overflow calculation
    logic[32:0] temp_result;
    
    always_comb begin
        carry = 0; // Default to 0 to simplify logic where carry is not used
        overflow = 0; // Default to 0 to simplify logic where overflow is not used

        case (operation)
            4'b0000: begin // ADD
                temp_result = {1'b0, operand1} + {1'b0, operand2};
                result = temp_result[31:0];
                carry = temp_result[32];
                overflow = (operand1[31] == operand2[31]) && (result[31] != operand1[31]);
            end
            4'b1000: begin // SUB
                temp_result = {1'b0, operand1} + {1'b0, ~operand2} + 1;
                result = temp_result[31:0];
                carry = temp_result[32]; // Carry is inverted in subtraction when considering unsigned overflow
                overflow = (operand1[31] != operand2[31]) && (result[31] != operand1[31]);
            end
            4'b0001: begin // SLL
                result = operand1 << operand2[4:0];
            end
            4'b0010: begin // SLT
                result = ($signed(operand1) < $signed(operand2)) ? 32'b1 : 32'b0;
            end
            4'b0011: begin // SLTU
                result = (operand1 < operand2) ? 32'b1 : 32'b0;
            end
            4'b0100: begin // XOR
                result = operand1 ^ operand2;
            end
            4'b0101: begin // SRL
                result = operand1 >> operand2[4:0];
            end
            4'b1101: begin // SRA
                result = $signed(operand1) >>> operand2[4:0];
            end
            4'b0110: begin // OR
                result = operand1 | operand2;
            end
            4'b0111: begin // AND
                result = operand1 & operand2;
            end
            default: result = 32'b0; // Undefined operations result in zero
        endcase

        // Set flags
        zero = (result == 32'b0);
        negative = result[31];
    end

endmodule
