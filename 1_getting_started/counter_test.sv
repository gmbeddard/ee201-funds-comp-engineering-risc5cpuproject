`timescale 1ns/1ns // 1 tick is 1ns; use 1ns resolution (since we're not simulating wire delays or anything)

module counter_enable_test;

  // Declare the signals that will connect to our device under test (DUT)
  logic clk = 0;
  logic reset;
  logic[7:0] count;
  
  // Instantiate and connect the DUT
  counter dut(.clk(clk),
              .reset(reset),
              .count(count));
  
  // Create the clock signal
  always #5 clk = ~clk;

  // Now run the test!
  initial begin
    // Dump all of the signals in the design to the VCD file which we can view with GTKwave
    $dumpfile("counter.vcd");
    $dumpvars(0, dut); // Dump all of the signals in the DUT


    $display("Beginning of counter test...");

    $display("(reset asserted)" );
    reset = 1;
    #27; // Wait for a few clock cycles

    // Check that the counter is reset correctly 
    assert(count == 0) else $error("Counter not reset: expected 0 but got %d !", count);

    $display("(reset released)" );
    reset = 0;

    @(posedge clk); // Wait for the next rising edge
    @(negedge clk); // and a little past so we have the values

    // Check that the counter has incremented
    assert(count == 1) else $error("Counter did not increment: expected 1 but got %d !", count);

    // We could keep checking other things here; instead we'll just wait for a microsecond
    // so that the waveform captures a good bit of time.
    #1000

    $display("Test complete!");
    $finish; // End the simulation (even though the clock is still going
  end

endmodule

