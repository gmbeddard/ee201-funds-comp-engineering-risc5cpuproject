## EE201 Fundamentals of Computer Engineering Final Project: RISC-V CPU Design and Simulation

This repository contains milestones for designing and simulating a RISC-V CPU using SystemVerilog. It provides a structured approach to building a RISC-V processor from the ground up, with simulation and testing. I eventually plan to implement this on an FPGA when I get the time.

---

### Features
- **Modular Design**:
  - Incremental construction of a RISC-V CPU, starting from basic ALU functionality and progressing to memory, branches, and jumps.
- **Testing and Debugging**:
  - Starter code and templates for testbenches.
  - Practical guidance on using assemblers and compilers for generating and testing instruction sets.

---

### Milestones

#### **Milestone 2: ALU-Only Processor**
Build the foundation of the RISC-V processor with a focus on basic arithmetic and logical operations:
- Implement key modules: 
  - **Program Counter**: Manages instruction sequencing.
  - **Program Memory**: Stores machine code instructions.
  - **Register File**: Handles general-purpose register operations.
  - **Immediate Extension**: Extends immediate values.
  - **ALU**: Executes core arithmetic and logical operations.
- Incrementally test and integrate the modules.
- Write individual testbenches for each module to verify functionality and debug any issues.

#### **Milestone 3: Implementing Memory Instructions**
Add support for memory load and store operations to enhance the processor's functionality:
- **Assembler Integration**: 
  - Use the GNU toolchain to assemble assembly programs into hexadecimal format for use in the processor.
  - Write simple programs in C and convert them to machine code using `riscv64-unknown-elf-gcc`.
- **Data Memory Module**:
  - Create a module for memory operations, similar to the register file but with a larger address space.
- **Immediate Extension**:
  - Update the module to handle memory-offset immediates.
- **Processor Updates**:
  - Modify control logic to handle new operations like load (`LW`) and store (`SW`).
  - Ensure the processor routes data correctly between the ALU, data memory, and registers.
- **Testing**:
  - Develop testbenches for the data memory module and updated processor.
  - Write assembly programs to verify memory operations.

#### **Milestone 4: Implementing Branches and Jumps**
Enable branching and jumping functionality to handle conditional and control-flow operations:
- **ALU Enhancements**:
  - Add support for flags: zero, negative, carry, and overflow.
  - Use these flags to determine branching conditions (e.g., `BEQ`, `BNE`, `BLT`).
- **Branch Checker Module**:
  - Implement logic to decide whether a branch or jump should be taken based on ALU flags and instructions.
- **Immediate Extension**:
  - Add support for branch and jump immediate formats.
- **Processor Updates**:
  - Modify the processor's top-level design to compute the next program counter for branches and jumps.
  - Handle `JAL` and `JALR` instructions, ensuring the correct return address is stored in the appropriate register.
- **Testing**:
  - Update testbenches for the ALU and immediate extension modules.
  - Write comprehensive assembly programs to test branch and jump instructions.
