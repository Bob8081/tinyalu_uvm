// coverage class 

class tinyalu_coverage extends uvm_subscriber #(tinyalu_seq_item);
	//regestration
	`uvm_component_utils(tinyalu_coverage)
	
	//variables
	bit [7 : 0] A ;
	bit [7 : 0] B ;		
	op_t op ;
	
	//operations-only cover group
	covergroup op_cov;
		op_set : coverpoint op {
			//m stands for multiple cycle and s stands for single cycle
			bins s[] = {[3'b000 : 3'b011]};
			bins m = {3'b100};
			
			bins m_to_s = ([3'b000:3'b011] => 3'b100);
			bins s_to_m = (3'b100 => [3'b000:3'b011]);
			bins m_to_m = (3'b100 => 3'b100) ;
			
			ignore_bins others={[3'b101 : $]};
			}
	endgroup
	
	//cross covergroup
	covergroup in_on_all_op_cov;
		all_op : coverpoint op {
			bins Add = {3'b001};
			bins  And = {3'b010};
			bins Xor = {3'b011};
			bins Mul = {3'b100};
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
			//add_bins
			bins add_all_zeros = binsof (all_op.Add) && (binsof (in_a.all_zeros) && binsof (in_b.all_zeros));	
			bins add_all_ones = binsof (all_op.Add) && (binsof (in_a.all_ones) && binsof (in_b.all_ones));
			//and_bins
			bins and_all_zeros = binsof (all_op.And) && (binsof (in_a.all_zeros) && binsof (in_b.all_zeros));
			bins and_all_ones = binsof (all_op.And) && (binsof (in_a.all_ones) && binsof (in_b.all_ones));
			//xor_bins
			bins xor_all_zeros = binsof (all_op.Xor) && (binsof (in_a.all_zeros) && binsof (in_b.all_zeros));
			bins xor_all_ones = binsof (all_op.Xor) && (binsof (in_a.all_ones) && binsof (in_b.all_ones));
			//mul_bins
			bins mul_all_zeros = binsof (all_op.Mul) && (binsof (in_a.all_zeros) && binsof (in_b.all_zeros));
			bins mul_all_ones= binsof (all_op) && (binsof (in_a.all_ones) && binsof (in_b.all_ones));
			//min on one input max on the other
			bins min_max_case = (binsof (in_a.all_ones) && binsof(in_b.all_zeros))
							  ||(binsof (in_a.all_zeros) && binsof(in_b.all_ones));
			//random case
			bins random_values = binsof(in_a.random) || binsof(in_b.random) ;
			
			option.weight =1; //only the cross is included in the coverage percentage
			}
	endgroup


	//constructor for class creates instances of covergroups
	function new (string name, uvm_component parent);
		super.new(name, parent);
		op_cov=new();
		in_on_all_op_cov=new();
	endfunction 


	//the implementation function of the analysis imp 
	function void write(tinyalu_seq_item t);
		A=t.A;
		B=t.B;
		op=t.op;
		op_cov.sample();
		in_on_all_op_cov.sample();
	endfunction 


endclass 
