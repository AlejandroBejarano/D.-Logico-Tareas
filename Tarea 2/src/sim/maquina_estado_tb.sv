`timescale 1ns/1ps

module maquina_estado_tb;
// entrada
    logic clk;
    logic rst;
    logic a;
    logic b;
    logic c;
    logic [3:0] tecla_pre;
//salida
    logic cargar_numero1;
    logic cargar_numero2;
    logic rst_datos;
    logic igual;
    logic clk_out;

    maquina_estado maquina_estado_tb(
        .clk(clk),
        .rst(rst),
        .a(a)
        .b(b),
        .c(c),
        .tecla_pre(tecla_pre),
        .cargar_numero1(cargar_numero1),
        .cargar_numero2(cargar_numero2),
        .rst_datos(reset_datos),
        .igua(igual),
        .clk_out(clk_out),
    );
 
    initial begin 
        clk = 0;
        forever #10 clk = ~clk;
    end 
    initial begin 
        rst = 1;
        a = 0;
        b = 0;
        c = 0;
        tecla_pre = 4'b0000;
        
        #30 rst = 0;

        //Prueba de teclas

        //tecla "a" para caragr el numero1
        #20 a = 1;
        #20 a = 0; 
        //tecla "a" para cargar el numero2
        #40 a = 1;
        #20 a = 0; 
        //tecla "b" (igualar)
        #40 b = 1;
        #20 b = 0;       
        //tecla "c" para resetear los datos
        #40 c = 1;
        #20 c = 0;


        #100 
        $finish
    end 
    initial begin
        $monitor("Time=%0t | a=%b b=%b c=%b | cargar_numero1=%b cargar_numero2=%b igual=%b rst_datos=%b",
            $time, a, b, c, cargar_numero1, cargar_numero2, igual, rst_datos);
    end
    initial begin 
        $dumpfile("maquina_estado_tb.vcd");
        $dumpvars(0,maquina_estado_tb);
    end 

endmodule