interface tinyalu_if (input logic clk, input logic reset_n);

    // DUT Signals
    logic [7:0]  A;
    logic [7:0]  B;
    logic [2:0]  op;
    logic        start;
    logic        done;
    logic [15:0] result;

    // Driver Clocking Block
    clocking cb_drv @(posedge clk);
        default input #1step output #1ns;
        output A, B, op, start;
        input  done, result; // Driver needs 'done' to know when to finish item
    endclocking

    // Monitor Clocking Block
    clocking cb_mon @(posedge clk);
        default input #1step output #1ns;
        input A, B, op, start, done, result;
    endclocking

    // 4. Modports
    modport driver_mp (clocking cb_drv, input reset_n);

    modport monitor_mp (clocking cb_mon, input reset_n);

endinterface