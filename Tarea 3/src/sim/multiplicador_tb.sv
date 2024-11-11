`timescale 1ns/1ps

module multiplicador_tb;
    parameter N = 8;

    // Señales de prueba
    logic clk;
    logic rst;
    logic [N-1:0] A;
    logic [N-1:0] B;
    logic [1:0] Q_LSB;
    logic [2*N-1:0] Y;

    // Definición de tipo para el control del multiplicador
    typedef struct packed {
        logic load_A;
        logic load_B;
        logic load_add;
        logic shift_HQ_LQ_Q_1;
        logic add_sub;
    } mult_control_t;

    mult_control_t mult_control;

    // Instancia del multiplicador
    multiplicador #(.N(N)) multiplicador_inst (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .mult_control(mult_control),
        .Q_LSB(Q_LSB),
        .Y(Y)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Ciclo de reloj de 20 ns
    end

    // Secuencia de prueba
    initial begin 
        // Inicialización
        rst = 1; 
        A = 0;
        B = 0;
        mult_control.load_A = 0;
        mult_control.load_B = 0;
        mult_control.load_add = 0;
        mult_control.shift_HQ_LQ_Q_1 = 0;
        mult_control.add_sub = 0;

        #20 rst = 0; // Desactivar el reset después de 20 ns

        // Caso 1: Multiplicación de A = 19 y B = 12
        #10 
        A = 8'd19;
        B = 8'd12;
        mult_control.load_A = 1; // Cargar A
        #10 mult_control.load_A = 0;

        mult_control.load_B = 1; // Cargar B
        #10 mult_control.load_B = 0;

        // Realizar una suma
        mult_control.load_add = 1;
        mult_control.add_sub = 1; // Suma
        #10 mult_control.load_add = 0;

        // Shift
        mult_control.shift_HQ_LQ_Q_1 = 1; // Realizar un shift
        #10 mult_control.shift_HQ_LQ_Q_1 = 0;

        // Mostrar resultados
        #10;
        $display("Caso 1: A=%d, B=%d, Q_LSB=%b, Y=%d", A, B, Q_LSB, Y);

        // Caso 2: Multiplicación de A = 25 y B = 31
        A = 8'd25; 
        B = 8'd31; 
        mult_control.load_A = 1; // Cargar A
        #10 mult_control.load_A = 0;

        mult_control.load_B = 1; // Cargar B
        #10 mult_control.load_B = 0;

        // Realizar una resta
        mult_control.load_add = 1;
        mult_control.add_sub = 0; // Resta
        #10 mult_control.load_add = 0;

        // Shift
        mult_control.shift_HQ_LQ_Q_1 = 1; // Realizar un shift
        #10 mult_control.shift_HQ_LQ_Q_1 = 0;

        // Mostrar resultados
        #10;
        $display("Caso 2: A=%d, B=%d, Q_LSB=%b, Y=%d", A, B, Q_LSB, Y);

        // Finalizar simulación
        #100 $finish; // Termina la simulación
    end 

    // Monitorear señales
    initial begin
        $monitor("Time=%0t | A=%d, B=%d | Y=%d, Q_LSB=%b", $time, A, B, Y, Q_LSB);
    end

    // Generar archivo VCD para visualización
    initial begin
        $dumpfile("multiplicador_tb.vcd");
        $dumpvars(0, multiplicador_tb);
    end

endmodule
