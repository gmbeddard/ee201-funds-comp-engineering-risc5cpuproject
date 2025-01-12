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
    logic write_enable, mem_to_reg;

    // Data memory
    logic [31:0] mem_data;
    logic mem_write_enable;

    // Immediate extension output
    logic [31:0] extended_imm;

    // ALU outputs and operation selection
    logic [31:0] alu_result;
    logic [3:0] alu_op;

    // Decode unit for instruction decoding and control signals
    decode_unit decode(
        .instruction(instruction),
        .write_enable(write_enable),
        .mem_write_enable(mem_write_enable),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .alu_src(ALUSrc)
    );

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
        .operand2(ALUSrc ? extended_imm : read_data2),
        .operation(alu_op),
        .result(alu_result)
    );

    // Instantiation of Data Memory
    datamem data_memory (
        .clk(clk),
        .addr(alu_result), // Assuming address calculation is done within ALU for simplicity
        .write_enable(mem_write_enable),
        .data_in(read_data2), // Writing data from rs2
        .data(mem_data)
    );

    // Control Logic for determining data to write back to the register file
    always_comb begin
        // Select between ALU result and memory data for write-back to the register file
        write_data = mem_to_reg ? mem_data : alu_result; // mem_to_reg is set when instruction is a load
    end

endmodule
