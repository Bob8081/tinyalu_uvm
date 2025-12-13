
// Base Test
class tinyalu_base_test extends uvm_test;
`uvm_component_utils(tinyalu_base_test)

tinyalu_env env;

function new(string name = "tinyalu_base_test", uvm_component parent = null);
    super.new(name, parent);
endfunction

// Build Phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = tinyalu_env::type_id::create("env", this);
endfunction

// Print the Topology
function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
endfunction

// Run Phase
task run_phase(uvm_phase phase);
    tinyalu_sequence seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "Starting Random Sequence...", UVM_LOW)
    seq = tinyalu_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
endtask

endclass


// // Sanity Test (Extends Base)
// class tinyalu_sanity_test extends tinyalu_base_test;
// `uvm_component_utils(tinyalu_sanity_test)

// function new(string name = "tinyalu_sanity_test", uvm_component parent = null);
//     super.new(name, parent);
// endfunction

// // Override the Run Phase to run a different sequence
// task run_phase(uvm_phase phase);
//     sanity_seq seq;

//     phase.raise_objection(this);
    
//     `uvm_info("TEST", "Starting Sanity Sequence...", UVM_LOW)
//     seq = sanity_seq::type_id::create("seq");
//     seq.start(env.agent.sequencer);
    
//     phase.drop_objection(this);
// endtask

// endclass