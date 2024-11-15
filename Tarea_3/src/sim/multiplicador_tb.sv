`timescale 1ns/1ps

// Definición de la estructura de control directamente en el testbench
typedef struct packed {
    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;
} mult_control_t;

// Testbench para el módulo multiplicador
module multiplicador_tb;

    // Parámetros
    parameter N = 8;

    // Entradas
    logic clk;
    logic rst;
    logic [N-1:0] A;
    logic [N-1:0] B;
    mult_control_t mult_control; // Esto ahora debe estar definido en el testbench

    // Salidas
    logic [1:0] Q_LSB;
    logic [2*N-1:0] Y;

    // Instancia del módulo multiplicador
    multiplicador #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .mult_control(mult_control),
        .Q_LSB(Q_LSB),
        .Y(Y)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Cambia el estado cada 5 unidades de tiempo
    end

    // Estímulos iniciales
    initial begin
        // Inicialización
        rst = 1;
        A = 0;
        B = 0;

        // Inicializar mult_control
        mult_control.load_A = 0;
        mult_control.load_B = 0;
        mult_control.load_add = 0;
        mult_control.shift_HQ_LQ_Q_1 = 0;
        mult_control.add_sub = 0;


        // Reset
        #10 rst = 0;

        // Pruebas
        // Cargar valores de A y B
        #10 mult_control.load_A = 1;
        A = 8'hF0;  // Ejemplo de valor
        #10 mult_control.load_A = 0;

        #10 mult_control.load_B = 1;
        B = 8'h0F;  // Ejemplo de valor
        #10 mult_control.load_B = 0;

        // Operación de suma y desplazamiento
        #10 mult_control.add_sub = 1;  // Realiza suma
        mult_control.load_add = 1;
        #10 mult_control.load_add = 0; // Desactivar load_add

        #10 mult_control.shift_HQ_LQ_Q_1 = 1; // Realizar desplazamiento
        #10 mult_control.shift_HQ_LQ_Q_1 = 0; // Desactivar shift

        // Fin de la simulación
        #50 $finish;
    end

    // Monitor de señales
    initial begin
        $monitor("Time=%0t | A=%h B=%h | Q_LSB=%b Y=%h", $time, A, B, Q_LSB, Y);
    end
    
    // Generación de archivo de ondas
    initial begin
        $dumpfile("multiplicador_tb.vcd");
        $dumpvars(0, multiplicador_tb);
    end

endmodule
