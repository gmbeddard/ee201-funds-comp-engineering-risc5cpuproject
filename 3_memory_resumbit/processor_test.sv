module processor_test;

    logic clk = 0;
    logic reset;

    // Instantiate the processor
    processor dut(.clk(clk), .reset(reset));

    // Create the clock signal
    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor1.vcd");
        $dumpvars; // Dump all signals in the DUT

        // Correct reference to the exposed registers array
        $dumpvars(0, dut.regfile_module.registers_out[15]); 

        $display("(reset asserted)");
        reset = 1;
        #20 
        @(negedge clk);
        reset = 0;

        #200 // Continue simulation

        $finish;
    end

endmodule
