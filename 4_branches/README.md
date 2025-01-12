Milestone 4: implementing branch and jump

# Upgrading the ALU

Update your ALU to produce the four flags needed to evaluate branches: zero, negative, carry, and overflow.
Each flag is a single bit, indicating whether something was true for the ALU computation just performed.

* The **zero** flag is the simplest: set the flag if the result of the ALU operation is zero.
* The **negative** flag should be set if the ALU result is negative (i.e., the sign bit indicates a negative number).
* The **carry** flag should be set if there was a carry out of the addition or subtraction operation.

  The ALU does not know or care about signed versus unsigned numbers, so `-1 + -1` should result in a carry.

  Subtraction should be handled as the addition of a negative number.  Taking `6 - 3` as an example, and using 8 bit numbers for simplicity:

     6    | 0 0 0 0 0 1 1 0
    -3    | 1 1 1 1 1 1 0 1
    ------------------------
     3  1 | 0 0 0 0 0 0 1 1

  The result is 3, with a carry out.  If we do the same thing with `2 - 3`:

     2    | 0 0 0 0 0 0 1 0
    -3    | 1 1 1 1 1 1 0 1
    ------------------------
    -1  0 | 1 1 1 1 1 1 1 1

  The result is -1 (or 255 unsigned), with no carry out.

  When performing addition, a carry occurs when there is unsigned overflow (i.e., you add two numbers and get a result that wraps around.)  When performing subtraction, a carry occurs when there is *not* unsigned overflow.  (Work a few examples to see why this is the case!)

* The **overflow** flag indicates signed overflow.

  For addition, the overflow flag should be set when the operands have the same sign and the output has the opposite sign (i.e., adding two positive numbers gives a negative result, or two negative numbers gives a positive result).

  Again we can think of subtraction as the addition of a negative number: `A - B` as `A + -B`.  In this case, signed overflow will occur when A and B have *opposite* signs, and the result has a sign opposite to A (the same as B).  In other words, overflow of `A - B` occurs when either:

    - A is positive and B is negative, and the result is negative
    - A is negative and B is positive, and the result is positive

  You should be able to demonstrate to yourself that `A - B` cannot overflow if both numbers have the same sign.

Note that in RISC-V these flags are only used for branch operations, where the ALU computes A - B and the flags are used to determine whether the branch is taken or not.  As a result, the flags are a "don't-care" for any function other than subtraction, so do whatever makes your logic simplest. 


# Branch checker
Complete the branch check module, which determines whether to take a branch or jump (i.e., modify the PC).

It should take the ALU flags and the current instruction, and determine whether to modify the PC.

To compare A and B, the ALU will compute `A - B` and examine the flags:
* BEQ (`A == B`) is taken if the ALU result is 0
* BNE (`A != B`) is taken if the result is not 0 (i.e., the inverse of BEQ)
* BLT (`A < B`) is taken if the result is negative XOR there was overflow
* BGE (`A >= B`) is the inverse of BLT
* BLTU (`A < B`) is taken if there was not a carry
* BGEU (`A >= B`) is taken if there was a carry (i.e., the inverse of BLTU)

Also, the branch checker should output a 1 if the instruction is a jump (JAL or JALR), and 0 for any other instruction.

# Immediate extension module
Update your immediate extension module to support the branch and jump immediate formats.

# Decoder / processor
Modify your top-level processor design to implement branch and jump functionality.  You'll want to refer to the lecture 18 slides where we worked through implemnting branches in class.

Below are some of the things you will want to consider:
* The ALU should always compute `A - B` for a branch instruction
* You'll need a single-purpose adder which computes the current PC plus the immediate from the jump or branch.
* JAL and JALR instructions will set the result register to the next instruction to execute (i.e., the current PC + 4).

You may find it helpful to bundle all of the control-signal operations together into a decoder module, if you haven't already!  If you do, please name it `decoder` so the autograder can find it and compile it with your other modules.

# Testing
Update your testbenches for the ALU and immediate extension modules to test the additional functionality.

For the processor-level test, write another assembly program that tests all of the operations the processor is capable of, and run it!

# Submission
As with previous milestones, upload *all* of your SystemVerilog files to Gradescope, not just new or modified code.
Please also include your testbenches, test files and any Makefiles you used.

