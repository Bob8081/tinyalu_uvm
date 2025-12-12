class tinyalu_sequencer extends uvm_sequencer #(sequence_item);

// registeration
`uvm_component_utils(tinyalu_sequencer)

// construction
function new (string name= "tinyalu_sequencer", uvm_component parent= null);
super.new(name,parent);
endfunction

endclass: tinyalu_sequencer
