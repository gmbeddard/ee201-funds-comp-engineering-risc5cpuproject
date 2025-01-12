// Program counter
module pc(input logic clk,
          input logic reset,
          output logic[31:0] addr);
		
  logic[31:0] counter;
  
  always_ff @(posedge clk) begin
	if (reset) begin
		counter <= 0;
		end
	else begin
		counter <= counter + 4;
	end
  end
	
	assign addr = counter;

endmodule

