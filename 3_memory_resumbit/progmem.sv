// Program memory implemented as combinational logic
// On the iCE40, this will be implemented in the logic fabric

// This is only used for the single-cycle machine; once we move to the
// multi-cycle design we will have a unified (and clocked) memory.

module progmem(input logic[31:0] addr,
               output logic[31:0] instr);

    parameter int MEM_WORDS = 256;
    logic[31:0] memory[MEM_WORDS];

    int hexfile;
    int readok = 1;
    logic[31:0] word_read;
    int mem_idx = 0;

    initial begin
        // The normal packed fread() uses big-endian encoding,
        // so load the words one by one and swizzle bytes
        hexfile = $fopen("program.hex", "rb");
        while (readok != 0 && mem_idx < MEM_WORDS) begin
            readok = $fread(word_read, hexfile);
            memory[mem_idx] = {word_read[7:0], word_read[15:8], word_read[23:16], word_read[31:24]};
            mem_idx += 1;
        end
        $fclose(hexfile);
    end

    // Force address alignment by ignoring bottom two bits
    // Use integer casts to avoid having to resize the widths if the memory depth changes
    assign instr = (int'(addr[31:2]) <= MEM_WORDS) ? memory[int'(addr[31:2])] : 0;

endmodule

