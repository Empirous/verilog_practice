/* https://chipdev.io/question/35
Prompt
In this question, design a Mealy Finite State Machine (FSM) that has five states, S0-S4.  
Upon resetn logic low, the FSM resets and current state becomes S0.  The inputs din and cen are 
registered inside the module, therefore, their registers also reset to zero.

When resetn = 1, the FSM starts its operation.  doutx must produce one whenever the current cycle din 
as well as the previous cycle din have the same values.  Similarly, douty must output one whenever the 
current cycle din is the same now as it was for the past two cycles.  Input cen (the registered version 
of it, inside the module) is used to gate the output.  That is, in a particular cycle, if cen = 0, then 
outputs doutx and douty are both zero.

Try to solve this question using a textbook Mealy FSM approach.  Sketch the state diagrams with 
the five possible state and the allowed transitions between them.

Input and Output Signals

    clk - Clock signal
    resetn - Synchronous, active low, reset signal
    cen - Chip enable
    din - 1-bit input a
    doutx - 1-bit output x
    douty - 1-bit output y
    Output signals during reset
    doutx - 0
    douty - 0
*/

module model (
    input logic clk,
    input logic resetn,
    input logic din,
    input logic cen,
    output logic doutx,
    output logic douty 
);

    // FSM States
    typedef enum logic [2:0] {
        INIT,
        S0,   
        S1,
        S00,
        S11
    } state_t;
    state_t state;
    
    // Signals
    logic data, enable;

    // Internal Data Registers
    always @(posedge clk) begin
        if (!resetn) begin
            data     <= 0;
            enable   <= 0;
        end else begin
            data   <= din;
            enable <= cen;
        end
    end

    // FSM
    always @(posedge clk) begin
        if (!resetn) begin
            state <= INIT;
        end else begin
            case (state)
                INIT : state <= data ? S1 : S0;
                S0   : state <= data ? S1 : S00;
                S00  : state <= data ? S1 : S00;
                S1   : state <= data ? S11 : S0;
                S11  : state <= data ? S11 : S0;
            endcase
        end
    end

    // Output
    assign doutx = enable ? ((state == S0  && data == 0) || (state == S1  && data == 1)) || douty : 0;
    assign douty = enable ? ((state == S00 && data == 0) || (state == S11 && data == 1)) : 0;

endmodule
