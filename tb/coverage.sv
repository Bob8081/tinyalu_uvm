// coverage class 

class coverage extends uvm_subscriber #(sequence_item);
	`uvm_component_utils(coverage)
	bit [7 : 0] A ;
	bit [7 : 0] B ;		
	bit [2 : 0] op ;
	

	covergroup op_cov;
		op_set : coverpoint op {
			bins s_c[] = {[3'b000 : 3'b011]};
			bins m_c = {3'b100};
			
			bins m_to_s = ([3'b000:3'b011] => 3'b100);
			bins s_to_m = (3'b100 => [3'b000:3'b011]);
			
			ignore_bins others={[3'b101 : $]};
			}
	endgroup
	

	covergroup in_on_all_op_cov;
		all_op : coverpoint op {
			ignore_bins not_used = {3'b000, [3'b101 : $]};
			option.weight = 0;
		}
		in_a : coverpoint A {
			bins all_zeros = {'h00};
			bins all_ones = {'hFF};
			bins random = {['h01 : 'hFE]};
			option.weight=0;
		}
		in_b : coverpoint B {
			bins all_zeros = {'h00};
			bins all_ones = {'hFF};
			bins random = {['h01 : 'hFE]};
			option.weight =0;
		}
		max_min_on_all_op : cross all_op, in_a, in_b{
			bins all_op_in_zeros = binsof (all_op) && (binsof(in_a.all_zeros) || binsof (in_b.all_zeros));
			bins all_op_in_ones = binsof (all_op) && (binsof(in_a.all_ones) || binsof (in_b.all_ones)); 
			bins random_vlaues  = binsof (all_op) && (binsof(in_a.random) || binsof (in_b.random));
			bins max_mul = binsof(all_op) intersect {3'b100} && (binsof(in_a.all_ones) && binsof(in_b.all_ones));
			
			option.weight =1;
			}
	endgroup



	function new (string name, uvm_component parent);
		super.new(name, parent);
		op_cov=new();
		in_on_all_op_cov=new();
	endfunction 



	function void write(sequence_item t);
		A=t.A;
		B=t.B;
		op=t.op;
		op_cov.sample();
		in_on_all_op_cov.sample();
	endfunction 


endclass 
