module general (
    input clk;
    input rst;
    input logic [0:2] numero1,
    input logic [0:2] numero2,
);
endmodule 

//4.1
module lectura(
    input logic clk,
    input logic rst,
    input logic a,
    output logic b,

    typedef enum logic[9:0] {S0, S1, S2} statetype;
    statetype state, nextstate;

    //stateregister
    always_ff @(posedge clk, posedge rst)
    if (rst) state <=S0;
    else     state <= nextstate;

    //next state logic
    always_comb 
    casev(state)
        S0: if (a) nextstate = S0;
            else nextstate = S1;
        S1: if(a)nextstate = S2;
            else nextstate = S1;
        S2  if (a) nextstate = S0;
            else nextstate = S;
    default: nextstate = S0;
    endcase

    //outputlogic
    assign b = (state == S2);
    endmodule


