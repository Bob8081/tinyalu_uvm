class my_sequencer extends uvm_sequencer #(sequence_item);

// registeration
`uvm_component_utils(my_sequencer)

// construction
function new (string name= "my_sequencer", uvm_component parent= null);
super.new(name,parent);
endfunction

endclass: my_sequencer
