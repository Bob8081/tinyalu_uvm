class my_sequence extends uvm_sequence #(sequence_item);

// registeration
`uvm_object_utils(my_sequence)

// construction
function new (string name="my_sequence");
super.new(name);
endfunction

// generation of a sequence os sequence_item
virtual task body ();
sequence_item transaction

repeat (100) begin
transaction= sequence_item::type_id::create("transaction");

strat_item (transaction); // wait until get_next_item from driver

if (! transaction.randomize() )
   `uvm_fatal("FATAL",$sformatf(" RANDOMIZATION FAILED !! "))

finish_item (transaction); // wait until item_done from driver
end

endtask: body


endclass: my_sequence
