This is a simple test project to make sure you have the tools and environment set up correctly.

1. Make sure you've installed the `oss-cad-suite` tools on your computer
2. Open a terminal and go into the directory where these files are stored
3. Type `make`; this will do the following:
  - Run Verilator to syntax-check the code
  - Run Icarus Verlog to "compile" your code
  - Run the Icarus Verilog runtime to execute the simulation

4. If everything was successful, you should see the message:

    VCD info: dumpfile counter.vcd opened for output.
    Beginning of counter test...
    (reset asserted)
    (reset released)
    Test complete!

5. You can view the signals using GTKWave.  At the terminal, type `gtkwave counter.vcd` to open it up.  You should be able to explore the design hierarchy on the left, and double-click on signals to add them to the view.

If everything works, you're ready to move on to CPU version 1: the basic ALU-only processor!

