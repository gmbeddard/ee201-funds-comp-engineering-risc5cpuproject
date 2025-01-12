module processor(
    input logic clk,
    input logic reset
);

    // Define internal signals
    logic [31:0] pc_current, pc_next, instruction, read_data1, read_data2, write_data, extended_imm, alu_result, mem_data;
    logic [3:0] alu_op;
    logic [4:0] rs1, rs2, rd;
    logic write_enable, mem_write_enable, mem_to_reg, alu_src, branch_taken;
    logic branch, jump, jalr;

    // Instantiate the Program Counter
    pc pc_module (
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .current_pc(pc_current)
    );

    // Instantiate the Program Memory
    progmem progmem_module (
        .addr(pc_current),
        .instr(instruction)
    );

    // Instantiate the Decode Unit
    decode_unit decode(
        .instruction(instruction),
        .write_enable(write_enable),
        .mem_write_enable(mem_write_enable),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .jalr(jalr)
    );

    // Instantiate the Immediate Extension Module
    immextend immextend_module (
        .instr(instruction),
        .imm32(extended_imm)
    );

    // Instantiate the Register File
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

    // Instantiate the ALU
    alu alu_module (
        .operand1(read_data1),
        .operand2(alu_src ? extended_imm : read_data2),
        .operation(alu_op),
        .result(alu_result)
    );

    // Instantiate the Data Memory
    datamem data_memory (
        .clk(clk),
        .addr(alu_result), // Assuming address calculation is done within ALU
        .write_enable(mem_write_enable),
        .data_in(read_data2),
        .data(mem_data)
    );

    // Instantiate the Branch Check Module
    branchcheck branch_checker(
        .instr(instruction),
        .aluflags(alu_result), // Assuming the ALU module sets necessary flags directly in the result
        .taken(branch_taken)
    );

    // Control logic for next PC calculation
    always_comb begin
        if (branch && branch_taken) begin
            pc_next = pc_current + extended_imm; // Branch target calculation
        end else if (jalr) begin
            pc_next = (read_data1 + extended_imm) & ~32'b1; // JALR target calculation
        end else if (jump) begin
            pc_next = pc_current + extended_imm; // JAL target calculation
        end else begin
            pc_next = pc_current + 4; // Default next instruction
        end
    end

    // Logic to select data for the write-back stage
    always_comb begin
        if (jalr || jump) begin // JAL and JALR set the link register to the next instruction
            write_data = pc_current + 4;
        end else begin
            write_data = mem_to_reg ? mem_data : alu_result; // Select between memory data and ALU result
        end
    end

endmodule
