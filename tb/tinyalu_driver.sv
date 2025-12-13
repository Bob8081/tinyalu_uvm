class tinyalu_driver extends uvm_driver #(tinyalu_seq_item);

    //declearations
    tinyalu_seq_item req;
    virtual tinyalu_if vif;

    //registeration
    `uvm_component_utils(tinyalu_driver)


    //construction
    function new(string name = "tinyalu_driver", uvm_component parent = null);
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

        // Initialize signals

        vif.cb_drv.A     <= 0;
        vif.cb_drv.B     <= 0;
        vif.cb_drv.op    <= 3'b000;
        vif.cb_drv.start <= 1'b0;


        // `uvm_info("DRV", "I am driving", UVM_LOW)
        wait(vif.driver_mp.reset_n === 1'b1);
        // `uvm_info("DRV", "Reset done", UVM_LOW)   

        forever begin
            
            seq_item_port.get_next_item(req);
            // `uvm_info("DRV", "I am driving2", UVM_LOW)

            @(vif.cb_drv)
            vif.cb_drv.A     <= req.A;
            vif.cb_drv.B     <= req.B;
            vif.cb_drv.op    <= req.op;
            vif.cb_drv.start <= 1'b1;

            // `uvm_info("DRV", $sformatf("Driving A: 0x%0h, B: 0x%0h, OP: %0d", vif.cb_drv.A, vif.cb_drv.B, vif.cb_drv.op), UVM_LOW)

            if (req.op == no_op) begin
                // Special Handling for NOP
                @(vif.cb_drv);
                vif.cb_drv.start <= 1'b0;
            end else begin
                // Standard Handling (Add, Mul, etc):
                wait(vif.cb_drv.done === 1'b1);
                // De-assert start 
                vif.cb_drv.start <= 1'b0;
            end

            
            seq_item_port.item_done();
        end
    endtask
endclass