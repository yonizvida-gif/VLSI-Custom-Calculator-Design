// 4-bit Calculator with fully automatic address counter
module calculator (
    input wire clk,
    input wire reset,
    input wire signed [3:0] data_in,     // User data input
    input wire load_en,                  // Trigger: write user data & increment addr
    input wire [1:0] op_sel,             // 01=Add, 10=Sub, 00=Idle, 11=Idle
    input wire en_a,                     // Enable to capture first operand
    input wire en_b,                     // Enable to capture second operand
    output reg signed [3:0] data_out     // Current memory output or ALU result
);

    // Memory and Counter
    reg signed [3:0] sram [15:0];
    reg [3:0] addr_counter;              // Internal counter that increments on writes [2]
    
    // Internal Latches (to prevent "garbage" calculations [3])
    reg signed [3:0] latch_a, latch_b;
    wire signed [3:0] alu_result;
    
    integer i;

    // --- Combinational Logic ---

    // ALU Logic: Operates on the values currently held in latches
    assign alu_result = (op_sel == 2'b01) ? (latch_a + latch_b) :
                        (op_sel == 2'b10) ? (latch_a - latch_b) : 4'b0000;

    // --- Sequential Logic ---

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initial state: reset counter and clear memory
            addr_counter <= 4'b0000;
            data_out     <= 4'b0000;
            latch_a <= 4'b0000; latch_b <= 4'b0000;
            for (i = 0; i < 16; i = i + 1) sram[i] <= 4'b0000;
        end 
        else begin
            // 1. Loading User Data: Stores at current address and increments [2]
            if (load_en) begin
                sram[addr_counter] <= data_in;
                data_out           <= data_in;
                addr_counter       <= addr_counter + 1'b1; // Auto-increment [2]
            end

            // 2. Loading Operands for ALU: Captures from current memory output
            // This happens when User triggers EnA/EnB while addr_counter is at the right spot
            if (en_a) latch_a <= sram[addr_counter - 1'b1]; // Load the last written value
            if (en_b) latch_b <= sram[addr_counter - 1'b1]; // Load the last written value

            // 3. Executing ALU operation and Auto-Storing Result [2]
            if (op_sel == 2'b01 || op_sel == 2'b10) begin
                sram[addr_counter] <= alu_result; // Write result to NEXT available address
                data_out           <= alu_result;
                addr_counter       <= addr_counter + 1'b1; // Auto-increment after result [2]
            end
        end
    end
endmodule
