class tinyalu_monitor extends uvm_monitor;
    `uvm_component_utils(tinyalu_monitor)

    virtual tinyalu_if vif;
    
    // Analysis Port to broadcast transactions
    uvm_analysis_port #(tinyalu_seq_item) item_collected_port;

    // Placeholder for the transaction being reconstructed
    tinyalu_seq_item trans_collected;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        trans_collected = new(); 
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_port = new("item_collected_port", this);
    endfunction

    task run_phase(uvm_phase phase);
        // Wait for reset to be released
        wait(vif.reset_n === 1);

        forever begin
            // Wait for Start signal
            // Ensures we only trigger when start goes high
            @(vif.cb_mon iff vif.cb_mon.start === 1);

            // Sample Inputs (A, B, Op)
            trans_collected.A   = vif.cb_mon.A;
            trans_collected.B   = vif.cb_mon.B;
            trans_collected.op  = op_t'(vif.cb_mon.op); // Cast to enum

            // Wait for Done signal

            if (trans_collected.op == no_op) begin
                // Special Handling for NOP
                @(vif.cb_mon);
            end else begin
                // Standard Handling (Add, Mul, etc):
                @(vif.cb_mon iff vif.cb_mon.done === 1);
            end

            // Sample Output (Result)
            trans_collected.result = vif.cb_mon.result;

            // Broadcast to Scoreboard/Coverage
            item_collected_port.write(trans_collected);
        end
    endtask

endclass