module regfile(
    input logic clk,
    input logic reset,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic write_enable,
    output logic [31:0] data1,
    output logic [31:0] data2,
    input logic [31:0] rd_data
);

    logic [31:0] registers[31:0];

    always_comb begin
        data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
        data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];
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
