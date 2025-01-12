module regfile(
    input logic clk,
    input logic reset,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic write_enable,
    output logic [31:0] data1,
    output logic [31:0] data2,
    input logic [31:0] rd_data,
    output logic [31:0] registers_out[31:0]  // Exposing register array for testing
);

    logic [31:0] registers[31:0];

    always_comb begin
        data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
        data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];
        for (int i = 0; i < 32; i++) begin
            registers_out[i] = registers[i]; // Copy internal registers to output
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 1; i < 32; i++) begin
                registers[i] <= 32'd0;
            end
        end else if (write_enable && rd != 5'd0) begin
            registers[rd] <= rd_data;
        end
    end
    
endmodule

/*module regfile(
    input logic clk,
    input logic reset,
    input logic[4:0] rs1,
    input logic[4:0] rs2,
    input logic[4:0] rd,
    input logic write_enable,
    output logic[31:0] data1,
    output logic[31:0] data2,
    input logic[31:0] rd_data
);

    // Declare an array of 31 32-bit registers (x1 to x31)
    logic[31:0] registers[31:0];

    // Logic to output the values of selected registers
    // x0 is hardwired to 0, handled automatically by reading from index 0
    always_comb begin
        data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];  // Output zero if rs1 is 0, else data from registers
        data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];  // Output zero if rs2 is 0, else data from registers
    end
    
    // Logic to write data into a register and reset functionality
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to zero except x0 which is always zero
            for (int i = 1; i < 32; i++) begin
                registers[i] <= 32'd0;
            end
        end else if (write_enable && rd != 5'd0) begin  // Check if write_enable is asserted and rd is not x0
            registers[rd] <= rd_data;
        end
    end
    
endmodule
*/