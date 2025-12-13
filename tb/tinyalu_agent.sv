class tinyalu_agent extends uvm_agent;
    `uvm_component_utils(tinyalu_agent)

    // Components
    tinyalu_driver    driver;
    tinyalu_sequencer sequencer;
    tinyalu_monitor   monitor;

    // Interface
    virtual tinyalu_if vif;

    // Analysis Port (Passthrough for the Monitor)
    uvm_analysis_port #(tinyalu_seq_item) item_collected_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Initialize the Analysis Port
        item_collected_port = new("item_collected_port", this);

        // Get Interface
        if(!uvm_config_db#(virtual tinyalu_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("AGENT", "Could not get tinyalu_config from DB")
        end

        // Build Monitor 
        monitor = tinyalu_monitor::type_id::create("monitor", this);

        // Build Driver/Sequencer
        driver    = tinyalu_driver::type_id::create("driver", this);
        sequencer = tinyalu_sequencer::type_id::create("sequencer", this);

    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //  Distribute Interface from Config to components
        monitor.vif = vif;
        driver.vif = vif;

        // Connect Driver's request port to Sequencer's export
         driver.seq_item_port.connect(sequencer.seq_item_export);

        // Connect Monitor Port to Agent Port
        monitor.item_collected_port.connect(this.item_collected_port);
    endfunction

endclass