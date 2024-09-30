module general (
    input logic clk;
    input logic rst;
    input logic [0:2] numero1,
    input logic [0:2] numero2,
);
endmodule 

//4.1
module segunda_parte (
    // Segunda parte FSM (Sincronización y Máquina de estado)
    // Sincronizacion a 27 MHz
    input logic clk,
    output logic clk_out,
    input logic rst
);

    parameter int frecuencia = 27000000;
    parameter int freq_out = 10000;
    parameter int max_count = frecuencia / (2 * freq_out);

    logic [8:0] count;

    // Inicialización de variables
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            if (count == max_count) begin
                clk_out <= ~clk_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule

/*
module lectura(
    input logic clk,
    input logic rst,
    input logic [3:0] a, // Entrada de 4 bits (el número en binario)
    output logic b,
    output logic [3:0] numeros[1:0] // Vector de 2 elementos para almacenar los números
);

    typedef enum logic[1:0] {S0, S1, S2} statetype;
    statetype state, nextstate;

    logic [3:0] contador; // Para contar cuántos números se han almacenado

    // stateregister
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            contador <= 0; // Reinicia el contador
        end else begin
            state <= nextstate;
        end
    end

    // next state logic
    always_comb begin
        case (state)
            S0: if (a != 4'b0) nextstate = S1;
                else nextstate = S0;
            S1: if (a != 4'b0) nextstate = S2;
                else nextstate = S1;
            S2: if (a == 4'b0) nextstate = S0;
                else nextstate = S2;
            default: nextstate = S0;
        endcase
    end

    // Output logic and storage of numbers
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            numeros[0] <= 4'b0000;
            numeros[1] <= 4'b0000;
        end else if (state == S2 && contador < 2) begin
            numeros[contador] <= a; // Almacenar el número en el vector
            contador <= contador + 1; // Incrementar contador para el próximo número
        end
    end

    // La salida b será 1 cuando estemos en S2
    assign b = (state == S2);

endmodule

*/

/*Ocupamos:
Modulo #1
1. El escaneo de filas
2. Detección de columna, ya con esto se saca que tecla se preciosa
3. Eliminar el rebote mecánico 
Modulo #2
4. Luego sincronizarlo a 27MHz
5. La maquina de estado
Modulo #3
6. Conversión del número a binario para la suma y los 7-segmentos
*/
