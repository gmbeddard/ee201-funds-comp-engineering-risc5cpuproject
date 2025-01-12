// Updated Program Counter to handle branching and jumping
module pc(
    input logic clk,
    input logic reset,
    input logic load,             // Signal to load a new address
    input logic[31:0] load_value, // The new address to load
    output logic[31:0] addr
);

logic[31:0] counter;

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0
    end else if (load) begin
        counter <= load_value; // Load the branch/jump address
    end else begin
        counter <= counter + 4; // Default: increment by 4
    end
end

assign addr = counter; // Output the current counter value

endmodule


/*// Program counter
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

endmodule*/

