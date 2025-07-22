module stall_controller (
    input wire load_use_hazard,
    input wire branch_hazard,
    input wire memory_busy,
    
    output wire stall_pipeline,
    output wire flush_pipeline,
    output wire [4:0] stall_stages  // bit para cada estágio
);