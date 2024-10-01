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
    // a tecla para sumar, b tlecla para igualar y c tecla para eliminar
    input logic clk,
    input logic rst,
    input logic [0:2] numero1
    input logic [0:2] numero2
    input logic a
    input logic b
    input logic c
    output logic igual
    output logic clk_out,
);
//Sincronizacion a 27 Mhz
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
// Maquina de estado para el control de datos del teclado 
 
typedef enum logic [2:0] {SO, S1, S2} statetype;
statetype state, nextstate;
//stateregister 
always_ff@(posedge clk or posedge rst) begin
    if (rst) begin 
        state <= S0;
        //almacena el numero capturado en el teclado en el vector [2:0] numero1
    end else begin 
        state <= nextstate;
    end 
end 
//next state logic 
S0: if (a) nextstate=SO;
    else   nextstate=S1;
S1: if (b) nextstate=S2;
    else   nextstate=S0;
S2: if (c) nextstate=S0;
default: nextstate=S0
endcase 
// Output Logic
assign igual = (S0 + S1 == S2);

endmodule


/*Ocupamos:
Modulo #1
1. El escaneo de filas
2. Detección de columna, ya con esto se saca que tecla se preciosa
3. Eliminar el rebote mecánico 
Modulo #2
4. Luego sincronizarlo a 27MHz
5.
6. La maquina de estado
Modulo #3
7. Conversión del número a binario para la suma y los 7-segmentos
*/
