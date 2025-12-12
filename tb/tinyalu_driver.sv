class my_driver extends uvm_driver #(my_transaction);

    //declearations
    my_transaction req;
    virtual tinyalu_if vif;

    //registeration
    `uvm_component_utils(my_driver)


    //construction
    function new(string name = "my_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //build
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(virtual tinyalu_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Cannot get interface");
    endfunction

    //connection
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    //run
    task run_phase(uvm_phase phase);
        forever begin
            wait(vif.driver_mp.reset_n)
            seq_item_port.get_next_item(req);
            @(vif.cb_drv)

            vif.cb_drv.A     <= req.A;
            vif.cb_drv.B     <= req.B;
            vif.cb_drv.op    <= req.op;
            vif.cb_drv.start <= 1'b1;

            wait(vif.cb_drv.done == 1'b1);
            vif.cb_drv.start <= 1'b0;

            
            seq_item_port.item_done();
        end
    endtask
endclass