module branchcheck(input logic[31:0] instr,
                   input logic[3:0] aluflags, // Ordered NZCV
                   output logic taken);

    // Complete this module to determine whether the branch should be taken,
    // based on the current instruction and the ALU result.
    
    // Note that `taken` should also be 1 for jump instructions, and
    // always 0 instructions that are not branches or jumps.

endmodule

