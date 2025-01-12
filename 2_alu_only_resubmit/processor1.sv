module processor(input logic clk,
                 input logic reset);

  // Instantiate your submodules here and connect them together to build a
  // processor that can execute ALU operations!
	
	// Program counter output
    logic [31:0] pc_addr;

    // Instruction memory output
    logic [31:0] instruction;

    // Register file outputs and inputs
    logic [31:0] read_data1, read_data2, write_data;
    logic [4:0] rs1, rs2, rd;
    logic write_enable;

    // Immediate extension output
    logic [31:0] extended_imm;

    // ALU outputs and operation selection
    logic [31:0] alu_result;
    logic [3:0] alu_op;

    // Instantiation of PC (Program Counter)
    pc pc_module (
        .clk(clk),
        .reset(reset),
        .addr(pc_addr)
    );

    // Instantiation of Program Memory
    progmem progmem_module (
        .addr(pc_addr),
        .instr(instruction)
    );

    // Instantiation of Register File
    regfile regfile_module (
        .clk(clk),
        .reset(reset),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_enable(write_enable),
        .data1(read_data1),
        .data2(read_data2),
        .rd_data(write_data)
    );

    // Instantiation of Immediate Extension
    immextend immextend_module (
        .instr(instruction),
        .imm32(extended_imm)
    );

    // Instantiation of ALU
    alu alu_module (
        .operand1(read_data1),
        .operand2(instruction[5] ? extended_imm : read_data2), // Determine source operand based on instruction type
        .operation({instruction[30], instruction[14:12]}), // Simplistic operation decoding
        .result(alu_result)
    );


	// You'll need to write a little bit of logic for the "controller" (e.g.,
	// determining whether to use an immediate or register for the second
	// operand).  In future assignments it will get more complicated, and we'll
	// wrap it up into its own module.
  
    // Control Logic for Processor
    always_comb begin
        // Decode instruction to set control signals
        write_enable = (instruction[6:0] == 7'b0110011 || instruction[6:0] == 7'b0010011); // example for R-type and I-type
        write_data = alu_result;

    end

endmodule

