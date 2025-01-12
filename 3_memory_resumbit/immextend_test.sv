`timescale 1ns / 1ps

module tb_immextend;

  // Inputs
  reg [31:0] instr;

  // Outputs
  wire [31:0] imm32;

  // Instantiate the Unit Under Test (UUT)
  immextend uut (
    .instr(instr),
    .imm32(imm32)
  );

  // Test vector procedure
  initial begin
    // Initialize Inputs
    instr = 0;

    // Wait for global reset
    #100;

    // Test cases
    $display("Testing ALU Immediates");

    // Immediate value 1
    instr = 32'h00100013;  // opcode 0010011 (I-type), imm = 1
    #10;  // wait for propagation
    check_imm(32'h00000001);

    // Immediate value 2
    instr = 32'h00200013;  // opcode 0010011 (I-type), imm = 2
    #10;
    check_imm(32'h00000002);

    // Immediate value 4
    instr = 32'h00400013;  // opcode 0010011 (I-type), imm = 4
    #10;
    check_imm(32'h00000004);

    // Immediate value 8
    instr = 32'h00800013;  // opcode 0010011 (I-type), imm = 8
    #10;
    check_imm(32'h00000008);

    // Immediate value 16
    instr = 32'h01000013;  // opcode 0010011 (I-type), imm = 16
    #10;
    check_imm(32'h00000010);

    // Immediate value 100
    instr = 32'h06400013;  // opcode 0010011 (I-type), imm = 100
    #10;
    check_imm(32'h00000064);

    // Immediate value 1445
    instr = 32'h5a500013;  // opcode 0010011 (I-type), imm = 1445
    #10;
    check_imm(32'h000005a5);

    // Immediate value 2047
    instr = 32'h7ff00013;  // opcode 0010011 (I-type), imm = 2047
    #10;
    check_imm(32'h000007ff);

    // Immediate value -2048 (0x800)
    instr = 32'h80000013;  // opcode 0010011 (I-type), imm = -2048
    #10;
    check_imm(32'hfffff800);

    // Immediate value -1 (0xfff)
    instr = 32'hfff00013;  // opcode 0010011 (I-type), imm = -1
    #10;
    check_imm(32'hffffffff);

    $display("Testing Complete");
  end

  // Check function
  task check_imm;
    input [31:0] expected_imm;
    begin
      if (imm32 !== expected_imm) begin
        $display("Error: For instr %h, expected imm = %h, got imm = %h", instr, expected_imm, imm32);
      end else begin
        $display("Pass: For instr %h, imm = %h", instr, imm32);
      end
    end
  endtask

endmodule
