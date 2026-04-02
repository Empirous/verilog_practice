/* https://chipdev.io/question/24
Prompt
A Ripple Carry Adder (RCA) is a multi-bit addition circuit composed of a number of cascaded full adders (FAs). 
In an RCA, the carry-out bit of stage i is propagated to the carry-in port, cin, of stage i+1 so that the carry 
bit ripples through the entire chain of FAs, from the least significant bit (LSB) to the most significant bit (MSB).

Use the solution to question 22 (Full Adder) and implement a flexible data width RCA.  The RCA module takes two 
integers a and b, and produces two output words sum and cout_fa1.  Output cout_fa1 corresponds to the carry-out nets
of each FA stage.

Important
This question must be solved using a multimodule approach.  That is, there must be a module for a single-bit FA that is 
instantiated DATA_WIDTH times in order to build a multi-bit RCA.  You will be able to use the solution to question 22 
(Full Adder) as the single-bit FA module.

Input and Output Signals
a - First operand input word
b - Second operand input word
sum - Output word corresponding to a plus b operation (note that sum has DATA_WIDTH+1 bits to account for the carry-out/overflow bit)
cout_int - Internal carry-out nets, ouputs of the full adder instances
*/

`include "full_adder.sv"
module model #(parameter
    DATA_WIDTH=8
) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    output logic [DATA_WIDTH-0:0] sum,
    output logic [DATA_WIDTH-1:0] cout_int
);

    generate
        for (genvar i = 0; i <= DATA_WIDTH-1; i++) begin : gen_loop
            if (i == 0) begin
                full_adder inst (
                  .a(a[i]),
                  .b(b[i]),
                  .cin(1'b0),
                  .sum(sum[i]),
                  .cout(cout_int[i])
                );
            end else begin
                full_adder inst (
                  .a(a[i]),
                  .b(b[i]),
                  .cin(cout_int[i-1]),
                  .sum(sum[i]),
                  .cout(cout_int[i])
                );
            end
        end
    endgenerate

    assign sum[DATA_WIDTH] = cout_int[DATA_WIDTH-1];

endmodule

/* Full Adder Module from `include "full_adder.sv"
module full_adder (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);

    assign {cout, sum} = a + b + cin;

endmodule
*/
