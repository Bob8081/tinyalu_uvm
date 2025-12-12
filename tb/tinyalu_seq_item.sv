class tinyalu_seq_item extends uvm_sequence_item;

// Signal Fields decleration 
rand bit [7:0]  A;
rand bit [7:0]  B;
rand bit [2:0]  op;
// bit        clk;
// bit        reset_n;
// bit        start;
// bit        done;
bit [15:0] result;


// registration
`uvm_object_utils_begin (tinyalu_seq_item)
`uvm_field_int (A,UVM_ALL_ON)
`uvm_field_int (B,UVM_ALL_ON)
`uvm_field_int (op,UVM_ALL_ON)
// `uvm_field_int (clk,UVM_ALL_ON)
// `uvm_field_int (reset_n,UVM_ALL_ON)
// `uvm_field_int (start,UVM_ALL_ON)
// `uvm_field_int (done,UVM_ALL_ON)
`uvm_field_int (result,UVM_ALL_ON)
`uvm_object_utils_end


// construction
function new (string name="tinyalu_seq_item");
    super.new(name);
endfunction

// constraints
constraint constr_a { A dist {0:=1 , [1:254]:/8 , 255:=1};}
constraint constr_b { B dist {0:=1 , [1:254]:/8 , 255:=1};}
constraint constr_op { op dist {0:=1, [1:3]:/6, 4:=3};}

endclass: tinyalu_seq_item
