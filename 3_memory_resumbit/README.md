Milestone 3: implementing memory instructions

# Using an assembler to generate the ROM
Pasting hexadecimal instructions into a memory file by hand is a pain, so it's time to generate this with the assembler!
You will need the GNU compiler toolchain to do this; you can either install it on your system or use the EE 201 virtual machine.

To assemble the file:

    riscv64-unknown-elf-as example.s -o example

Convert to a hex file for easy inclusion in Verilog code:

    riscv64-unknown-elf-objcopy -O binary example example.hex


# Using a C compiler

To compile the file `hello.c`, you can use the command:

    riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib hello.c

Despite the name, `riscv64-unknown-elf-gcc` is the compiler for both 64-bit and 32-bit versions of RISC-V.  The `-march=rv32i` and `-mabi=ilp32` arguments tell the compiler to generate code for RV32I (32-bit with the base integer instructions only).  Finally, the `-nostdlib` argument tells the compiler not to use the C standard library to keep the output as minimal as possible.

Once you've got a compiled object file, you'll need to convert it to a hex file using the same command as above.
You can also disassemble the binary to see what assembly code the C compiler generated:

	  riscv64-unknown-elf-objdump -dr a.out

Note that at this stage, you'll need to be very careful what C code you write, because the compiler may generate instructions your processor doesn't support yet!

# Updated program memory
The starter code includes a new program memory module which loads its data from a hex file generated using either of the methods above.  Try putting it in place of your program memory from milestone 2, and see if you can run code from the assembler instead of hard-coding!


# Upgrading the processor
You'll need to make the following updates to your processor to support load and store instructions:

## Data memory
Create a data memory module following the starter code.

This module will behave very similarly to the register file, except that it has a larger address space and only one read/write port.

Note that the memories embedded in the FPGA do not work like this (they also take 1 clock cycle to read) so if you build this on the FPGA it will be implemented with flip-flops in the regular logic fabric.

## Immediate extension module
Update your immediate extension module to support the memory-offset immediates.

## Decoder / processor
Modify your top-level processor design.  Below are some of the things you will want to consider:
* The register file write-enable will now depend on what type of operation is being performed. (i.e., a SW instruction does not write to any registers!)
* The input to the register file (Data3 on the slides) will depend on the type of operation being performed (i.e., it could now come from either the ALU or the data memory)
* The ALU will use the immediate for both ALU-immediate operations and for load/store operations.
* The data memory write-enable will have to be set for memory write (SW) operations.

You may find it helpful to bundle all of the control-signal operations together into a decoder module, but you are not required to.

## Testing
Update your testbench for the immediate extension module, and write a testbench for the data memory.

For the processor-level test, write an assembly program that tests all of the operations the processor is capable of, and run it!