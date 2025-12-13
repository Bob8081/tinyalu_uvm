package tinyalu_pkg;

    // UVM Imports
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Global Typedefs
    typedef enum bit [2:0] {
        no_op  = 3'b000,
        add_op = 3'b001,
        and_op = 3'b010,
        xor_op = 3'b011,
        mul_op = 3'b100,
        rst_op = 3'b111  // Internal Reset Command
    } op_t;




    // Class Includes
    
    // Objects
    `include "tinyalu_seq_item.sv"
    `include "tinyalu_sequence.sv"
    // `include "tinyalu_config.sv"

    // Component: Agent Level
    `include "tinyalu_driver.sv"
    `include "tinyalu_monitor.sv"
    `include "tinyalu_sequencer.sv"
    `include "tinyalu_agent.sv"

    // Component: Environment Level
    `include "tinyalu_scoreboard.sv"
    `include "tinyalu_coverage.sv"
    `include "tinyalu_env.sv"
    `include "tinyalu_test.sv"

endpackage