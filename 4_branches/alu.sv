// Updated ALU with flags
module alu(input logic[31:0] operand1,
           input logic[31:0] operand2,
           input logic[3:0] operation, // This is {imm7[5], imm3}, other bits of imm7 are always 0 for RV32I
           output logic[31:0] result,
           output logic[3:0] flags); // Ordered NZCV

  // Complete this module to compute the correct result for the specified operations
  // Note that not all operations are specified; you can leave the output 0 or undefined in this case

endmodule

