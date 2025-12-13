class tinyalu_sequence extends uvm_sequence #(tinyalu_seq_item);

// registeration
`uvm_object_utils(tinyalu_sequence)

// construction
function new (string name="tinyalu_sequence");
   super.new(name);
endfunction

// generation of a sequence os tinyalu_seq_item
virtual task body ();
   tinyalu_seq_item transaction;
   repeat (5000) begin

   // `uvm_info("SEQ", "I am starting a sequence", UVM_LOW)

   transaction = tinyalu_seq_item::type_id::create("transaction");
   start_item (transaction); // wait until get_next_item from driver

   if (! transaction.randomize() )
      `uvm_fatal("FATAL",$sformatf(" RANDOMIZATION FAILED !! "))

   finish_item (transaction); // wait until item_done from driver

   // `uvm_info("SEQ", "I am starting a sequence", UVM_LOW)
end

endtask: body


endclass: tinyalu_sequence
