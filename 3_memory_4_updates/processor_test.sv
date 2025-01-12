
module processor_test;

    logic clk = 0;
    logic reset;

    // Instantiate the processor (which in turn instantiates everything else)
    processor dut(.clk(clk),
                  .reset(reset));

    // Create the clock signal
    always #5 clk = ~clk;

    initial begin
        // Save all of the simulation signals to a file
        $dumpfile("processor1.vcd");
        $dumpvars; // Dump all of the signals in the DUT
        $dumpvars(0, dut.regfile_inst.registers[15]); // Save register 15 because arrays aren't saved by default

        // Now run the test: just toggle reset and run the clock for a while
        $display("(reset asserted)");
        reset = 1;
        #20 // at least once cycle
        @(negedge clk);
        reset = 0;

        #200 // Just wait a while, we have to examine the output manually

        // You can look at the output file (processor1.vcd) with gtkwave

        $finish;
    end

endmodule