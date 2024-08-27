`timescale 1ns/1ps

 module module_decoder_tb (
    input logic g3, g2, g1, g0,

    output logic led3, led2, led1, led0
 );

    principal principal_tb (
        .g3(g3),
        .g2(g2),
        .g1(g1),
        .g0(g0),
        .led3(led3),
        .led2(led2),
        .led1(led1),
        .led0(led0)
    );

    initial begin
        
        g3 = 1`b0;
        g2 = 1`b0;
        g1 = 1`b0;
        g0 = 1`b0;

        #10;

        g3 = 1`b1;
        g2 = 1`b0;
        g1 = 1`b0;
        g0 = 1`b1;
        
        #10;
        
        g3 = 1`b1;
        g2 = 1`b1;
        g1 = 1`b1;
        g0 = 1`b1;
        
        #10;

    end


    initial begin
        $dumpfile("module_decoder_tb.vcd");
        $dumpfile(0, module_decoder_tb);
    end
    
 endmodule