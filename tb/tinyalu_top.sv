`timescale 1ns/1ps

`include "uvm_macros.svh"

module tinyalu_top;

    // Import UVM and Project Packages
    import uvm_pkg::*;
    import tinyalu_pkg::*;

    // Clock and Reset Generation
    bit clk;
    bit reset_n;

    // Clock generation: 100MHz (Period = 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset Generation: Active low reset for 25ns
    initial begin
        reset_n = 0;
        #25;
        reset_n = 1;
    end

    // Interface Instantiation
    tinyalu_if intf (
        .clk(clk),
        .reset_n(reset_n)
    );

    // DUT Connection
    tinyalu DUT (
        .A       (intf.A),
        .B       (intf.B),
        .op      (intf.op),
        .clk     (clk),
        .reset_n (reset_n),
        .start   (intf.start),
        .done    (intf.done),
        .result  (intf.result)
    );

    // UVM Start Up
    initial begin
        // Register the Interface in the Configuration Database
        uvm_config_db#(virtual tinyalu_if)::set(null, "*", "vif", intf);

        // Run the Test
        run_test("tinyalu_base_test"); 
    end

    // initial begin
    //     $monitor("Time: %0t | reset_n: %b | A: %h | B: %h | op: %b | start: %b | done: %b | result: %h",
    //              $time, reset_n, intf.A, intf.B, intf.op, intf.start, intf.done, intf.result);
    // end

endmodule