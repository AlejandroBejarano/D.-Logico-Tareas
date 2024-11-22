module multiplicador_tb();

    // Definir las señales para la prueba
    logic [7:0] A, B;
    logic clk, start;
    logic [15:0] resultado;
    logic done;

    // Instanciar el módulo multiplicador
    multiplicador uut (
        .A(A),
        .B(B),
        .clk(clk),
        .start(start),
        .resultado(resultado),
        .done(done)
    );

    // Generar la señal de reloj
    always #5 clk = ~clk;  // Reloj con un periodo de 10 unidades de tiempo

    // Proceso inicial para la simulación
    initial begin
        // Inicializar las señales
        clk = 0;
        start = 0;
        A = 0;
        B = 0;

        // Esperar unos ciclos para empezar
        #10;

        // Caso de prueba 1: Multiplicar 65 por 87
        A = 8'd65;
        B = 8'd87;
        start = 1;
        #10;
        start = 0; // Desactivar la señal de inicio
        
        // Esperar hasta que done esté en alto
        wait(done == 1);
        #10;
        $display("Resultado de 65 * 87 = %0d", resultado);
        
        // Caso de prueba 2: Multiplicar 34 por 75
        A = 8'd34;
        B = 8'd75;
        start = 1;
        #10;
        start = 0; // Desactivar la señal de inicio

        // Esperar hasta que done esté en alto
        wait(done == 1);
        #10;
        $display("Resultado de 34 * 75 = %0d", resultado);

        // Fin de la simulación
        $finish;
    end
    
    // Para la generación del archivo de resultados de la simulación
    initial begin
        $dumpfile("multiplicador_tb.vcd");
        $dumpvars(0, multiplicador_tb);
    end
endmodule

