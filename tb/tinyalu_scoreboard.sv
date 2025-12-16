class tinyalu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tinyalu_scoreboard)

    // Analysis Port Implementation
    uvm_analysis_export #(tinyalu_seq_item) item_collected_export;

    // TLM FIFO
    uvm_tlm_analysis_fifo #(tinyalu_seq_item) item_fifo;

    int match;
    int mismatch;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        match = 0;
        mismatch = 0;
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate  the export and the FIFO
        item_collected_export = new("item_collected_export", this);
        item_fifo             = new("item_fifo", this);
    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the outer export to the FIFO's input
        item_collected_export.connect(item_fifo.analysis_export);
    endfunction



    task run_phase(uvm_phase phase);
        tinyalu_seq_item item;
        bit [15:0] expected_result;

        forever begin
            // Get the item (Blocking Call)
            // The simulation waits here until the Monitor puts something in the FIFO.
            item_fifo.get(item);

            // Prediction Logic
            expected_result = predict_result(item);

            // Check Logic
            if (item.result !== expected_result) begin
                `uvm_error("SCBD", $sformatf("MISMATCH! A: %0h B: %0h Op: %s | Exp: 0x%0h | Act: 0x%0h", item.B
                , item.A, item.op.name(), expected_result, item.result))
                mismatch++;
            end else begin
                `uvm_info("SCBD", $sformatf("MATCH! Op: %s | Result: 0x%0h", 
                    item.op.name(), item.result), UVM_HIGH)
                match++;
            end
        end
    endtask


    // The Prediction Model
    virtual function bit [15:0] predict_result(tinyalu_seq_item item);
        case (item.op)
            add_op: return item.A + item.B;
            and_op: return item.A & item.B;
            xor_op: return item.A ^ item.B;
            mul_op: return item.A * item.B;
            no_op:  return item.result; 
            default: begin
                `uvm_warning("SCBD", "Unknown Operation received in scoreboard")
                return 0;
            end
        endcase
    endfunction

    // Report Phase (Summary at end of test)
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCBD", $sformatf("Scoreboard Report: Matches=%0d, Mismatches=%0d", 
            match, mismatch), UVM_LOW)
    endfunction

endclass