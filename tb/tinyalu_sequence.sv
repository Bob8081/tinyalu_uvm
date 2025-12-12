class tinyalu_sequence extends uvm_sequence #(sequence_item);

// registeration
`uvm_object_utils(tinyalu_sequence)

// construction
function new (string name="tinyalu_sequence");
   super.new(name);
endfunction

// generation of a sequence os sequence_item
virtual task body (sequence_item transaction);
transaction= sequence_item::type_id::create("transaction");

repeat (100) begin
strat_item (transaction); // wait until get_next_item from driver

if (! transaction.randomize() )
   `uvm_fatal("FATAL",$sformatf(" RANDOMIZATION IS FAILED !! "))

finish_item (transaction); // wait until item_done from driver
end

endtask: body


endclass: tinyalu_sequence
