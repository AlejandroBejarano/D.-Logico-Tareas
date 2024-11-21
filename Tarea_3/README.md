# Diseño digital sincrónico de una multiplicación con algoritmo de Booth
<h2 align="center">Alejandro Bejarano 2018265149, Jimena Vargas </h2>


## 1. Resumen
Este informe presenta los detalles de un programa digital sincrónico, el cual está programado en un lenguaje de hardware (HDL), captura los datos de un teclado hexadecimal y los almacena en un módulo para después implementar una multiplicación con el algoritmo de Booth, y, por último, desplegar el resultado en un display de 4 dígitos, todo esto controlado por un módulo llamado control.

##### Introducción
Se aborda el diseño de un sistema digital que puede capturar números desde un teclado y realizar una multiplicación con el algoritmo de Booth, mostrando el resultado en una pantalla de 7 segmentos. La idea principal es utilizar un HDL, específicamente SystemVerilog, para crear un sistema sincronizado, donde todos los componentes funcionan al mismo "reloj" interno de 27 MHz. Con ello se pretende que, al ingresar números con el teclado hexadecimal, estos se almacenen y luego se multipliquen correctamente, mostrando el resultado en tiempo real en un display de 4 dígitos, además todo el sistema se implementa en una FPGA.



## 2. Problema, objetivos y especificaciones 
##### Problema 
Diseñar un sistema digital sincrónico en un HDL, para ser cargado en una FPGA, implementando varios métodos que procesen diferentes datos y señales con el mismo reloj, este a 27 MHz, para evitar errores de sincronización, este debe ingresar dos números de dos dígitos cada uno, que pasen por subsistemas de almacenamiento, multiplicación y despliegue de datos.


##### Objetivos
- Estudiar y desarrollar un testbench para el código del multiplicador de Booth.
- Elaborar un sistema tipo calculadora que realice una multiplicación por medio del algoritmo de Booth.
- Elaborar una correcta implementación de un diseño digital sincrónico en una FPGA.
- Construir un testbench básico para cada módulo desarrollado, con el fin de verificar el correcto funcionamiento de cada subsistema.


##### Especificaciones 
- Subsistema de lectura del teclado hexadecimal con captura de datos, eliminación de rebote y sincronización de los datos a partir de un teclado mecánico.
- Subsistema de almacenamiento de datos ingresados por el subsistema de lectura.
- Subsistema de multiplicación con algoritmo de Booth.
- Subsistema de despliegue de los números ingresados y del resultado de la multiplicación en cuatro dispositivos de 7 segmentos.


## 4. Diseño
Para realizar lo pedido, se realizó una partición de este mismo sistema a desarrollar, en varios subsistemas.


### 4.1 Descripción general de cada subsistema

#### Control (maquina de estado)

La creación de este módulo se diseñó basado el siguiente diagrama de una FSM:

![Display_diag](Imagenes/Diagrama_estados_control.png)

De este se puede observar que se definieron varios estados de la FSM de control del sistema general, E0, E1, E2, E3, E4 y E5, sucesivamente estos corresponden a el estado de espera, el estado de decimales, estado de unidades, estado de operación, estado de multiplicación y estado de suma.

##### Entradas y salidas
- `input logic clk`: Señal de clock a 27 MHz, pin de la FPGA.
- `input logic rst`: Señal de reset utilizada para reiniciar el sistema, se le asignó a un botón de la FPGA.
- `input logic col_0`: Señal de entrada de 1 bit, además hay otros tres entradas de col_1, col_2 y col_3, que corresponden a pines físicos de la FPGA.
- `output logic [6:0] seg`: Señales de salidas físicas en la FPGA, esto para los 7-segmentos, en representación de los segmentos a, b, c, d, e, f y g.
- `output logic [3:0] an`: Señales de salidas físicas en la FPGA, esto para activar 4 transistores, que funcionan como interruptores.
- `output logic [3:0]fila`: Señal de salida de 4 bits, que representa la fila encendida, además de encender y apagar pines físicos de la FPGA.

A continuación se muestra la FSM planteada para el módulo de control:

``` SystemVerilog
    typedef enum logic [2:0] { 
        E0, E1 , E2, E3, E4, E5
    } estado;

    estado estado_act, estado_sig;

        //Para el estado actual
    always_ff @(posedge clk or posedge rst)begin
        if (rst)begin
            estado_act <= E0; //estado de espera
        end 
        else begin
            estado_act <= estado_sig;
        end
    end


    //Logica de cada estado
    always_ff @(posedge clk) begin
        estado_sig = estado_act;
        case(estado_act)

            E0: begin
                if(fila == 4'b0001) begin
                    if (col0 != 4'b0) tecla_pre = 4'b0001; //1
                    else if (col1 != 4'b0) tecla_pre = 4'b0010; //2
                    else if (col2 != 4'b0) tecla_pre = 4'b0011; //3
                    else if (col3 != 4'b0) tecla_pre = 4'b1010; //A
                    else estado_sig = E0;
                end
                else if(fila == 4'b0010) begin
                    if (col0 != 4'b0) tecla_pre = 4'b0100; //4
                    else if (col1 != 4'b0) tecla_pre = 4'b0101; //5
                    else if (col2 != 4'b0) tecla_pre = 4'b0110; //6
                    else if (col3 != 4'b0) tecla_pre = 4'b1011; //B
                    else estado_sig = E0;
                end
                else if(fila == 4'b0100) begin
                    if (col0 != 4'b0) tecla_pre = 4'b0111; //7
                    else if (col1 != 4'b0) tecla_pre = 4'b1000; //8
                    else if (col2 != 4'b0) tecla_pre = 4'b1001; //9
                    else if (col3 != 4'b0) tecla_pre = 4'b1100; //C
                    else estado_sig = E0;
                end
                else if(fila == 4'b1000) begin
                    if (col0 != 4'b0) tecla_pre = 4'b1110; //E
                    else if (col1 != 4'b0) tecla_pre = 4'b0000; //0
                    else if (col2 != 4'b0) tecla_pre = 4'b1111; //F //***
                    else if (col3 != 4'b0) tecla_pre = 4'b1101; //D
                    else estado_sig = E0;
                end
                else if (tecla_cont == 3'b001 || tecla_cont == 3'b100) estado_sig = E1; //Pasa al estado de decimal.
                else if (tecla_cont == 3'b010 || tecla_cont == 3'b101) estado_sig = E2; //Pasa al estado de unidades.
                else if (tecla_cont == 3'b011 || tecla_cont == 3'b110) estado_sig = E3; //Pasa al estado de operacion.
                else begin
                    estado_sig = E0; //Estado de espera.
                end
            end

            //Decenas
            E1: begin
                if (tecla_cont == 3'b001) begin
                    tecla <= tecla_pre;
                    if (almac == 1) begin 
                        num1_dec1 <= tecla;
                        result <= num1_dec1;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end
                    almac <= 1'b1;
                end 
                else if (tecla_cont == 3'b100) begin 
                    tecla <= tecla_pre;
                    if (almac == 1) begin
                        num2_dec1 <= tecla;
                        result <= num2_dec1;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end
                    almac <= 1'b1;
                end
                    else begin 
                    estado_sig = E0;
                end
            end

        // Unidades
            E2: begin
                if (tecla_cont == 3'b010) begin
                    tecla <= tecla_pre;
                    almac <= 1'b1;

                    if (almac == 1) begin 
                        num1_dec2 <= tecla;
                        result <= num1_dec2;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end   
                end 
                else if (tecla_cont == 3'b100) begin 
                    tecla <= tecla_pre;
                    almac <= 1'b1;

                    if (almac ==1) begin
                        num2_dec2 <= tecla_pre;
                        result <= num2_dec2;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end 
                end 
                else begin 
                    estado_sig = E0;
                end 
            end

            E3: begin
                if (tecla_cont == 3'b011) begin
                    if (tecla_pre == 4'b1011) begin //Multiplicacion
                        tecla_opera = tecla_pre;
                        if (tecla_opera == tecla_pre) estado_sig = E0;
                        else begin
                            estado_sig = E0;
                        end
                    end
                    else if (tecla_pre == 4'b1010) begin //suma
                        tecla_opera = tecla_pre;
                        if (tecla_opera == tecla_pre) estado_sig = E0;
                        else begin
                            estado_sig = E0;
                        end
                    end
                    else begin
                        estado_sig = E0;
                    end
                end
                else if (tecla_cont == 3'b110) begin
                    if (tecla_pre == 4'b1100) begin
                        if (tecla_opera == 4'b1011) estado_sig = E4;
                        else if (tecla_opera == 4'b1010) estado_sig = E5;
                        else begin
                            estado_sig = E0;
                        end
                    end
                end
                else begin
                    estado_sig = E0;
                end
            end

            E4: begin
                if (tecla_cont == 3'b110 && tecla_opera == 4'b1011 ) begin 
                    start = 1'b1;
                    if (start == 1) begin
                        num1 <= num_result1;
                        num2 <= num_result2;
                        start = 1'b1;
                    end
                    if (start == 1) begin
                        num1 <= num_result1;
                        num2 <= num_result2;
                    end
                    else if (done == 1) begin
                        binary_in <= resultado;
                        result <= bcd_out;
                        binary_in <= resultado;
                        result <= bcd_out;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end 
                else begin
                    estado_sig = E0;
                end
                end
            end 
            E5: begin
                if (tecla_opera == 4'b1010) begin
                    if (num1 != 4'b0 && num2 != 4'b0) begin
                        result = sum;
                        seg[0] = Seg[0];
                        seg[1] = Seg[1];
                        seg[2] = Seg[2];
                        seg[3] = Seg[3];
                        seg[4] = Seg[4];
                        seg[5] = Seg[5];
                        seg[6] = Seg[6];
                        an[0] = An[0];
                        an[1] = An[1];
                        an[2] = An[2];
                        an[3] = An[3]; 
                    end
                end
                else if (tecla_opera != 4'b1010) estado_sig = E0;
                else begin
                    estado_sig = E0;
                end
            end
            default: estado_sig = E0;
        endcase
    end
endmodule
```

En el código se observa la definición de los estados de la FSM, E0, E1, E2, E3, E4 y E5, además se utilizó una lógica secuencial con el always_ff, para los cambios de estados, mediante el clk.

Para el primer estado E0, se desarrolló la lógica sobre los arreglos de entrada y salida, que corresponden a las columnas y filas del teclado respectivamente, por lo tanto, si se enciende una fila, por medio del contador de anillo, el subsistema seguidamente detectaba si alguna señal de entrada llegaba a las columnas(pines físicos de la FPGA), por lo cual si se detectaba una fila y columna especifica, a la variable tecla_pre se le asigna el valor binario de 4 bits de la tecla que se presiona, un ejemplo en el caso del número 1 sería el 0001, las entradas de las columnas pasan por un módulo de rebote, por lo que se elimina el rebote mecánico del teclado.

![Control_rebote](Imagenes/Control_COL_Reb_WV.png)

En la Figura anterior se observa como cada pulso detectado por el módulo de rebote a las entradas de las columnas, se le asigna un único pulso a la salida para eliminar el rebote.


Para el análisis de consumo de recursos en la FPGA y del consumo de potencia que reportan las herramientas, los siguientes valores generados con el make synth y make pnr.
![Consumo_r](Imagenes/Control_recur.png)

![Consumo_pot](Imagenes/Control_rec.png)

De esto, se destacan el consumo de recursos lógicos en la FPGA, como lo son los look-up-tables (LUTs), estos corresponde a el tamaño de tablas de búsqueda utilizadas, donde se implementa el sistema de capturar las teclas, además se tienen los Wires, que se utilizan 447, que corresponden a conexiones internas que ocupan 1585 bits, y 205 ALU que corresponden a unidades aritméticas lógicas para realizar operaciones lógicas o matemáticas, además se utilizaron flip-flops D, para almacenar estados, como también la utilización de varios multiplexores.


#### Capturador de teclas

Para la creación del módulo capturador de teclas se diseñó el siguiente diagrama:

![a](Imagenes/a.png)

Este corresponde al mismo método desarrollado para el sistema capturador de teclas de la Tarea 2, ya que se partió de ahí para desarrollar y mejorar un nuevo módulo para este sistema.

Dado que se implementó la deteccion de teclas en el módulo de control, y su devida explicación de funcionamiento, en esta sección se comentará un poco sobre el contador de anillo, divisor de reloj y el rebote mecanico del teclado.


##### Entradas y salidas
- `input logic clk`: Señal de clock a 27 MHz, pin de la FPGA.
- `input logic rst`: Señal de reset utilizada para reiniciar el subsistema.
- `output logic [3:0] fila`: Salida física de la FPGA, para poner en alto los pines de la FPGA mediante un shifter.
- `output logic boton_sal`: Salida de un pulso al pasar por el módulo del rebote.
- `output reg clk_div`: Salida de un clk a menor frecuencia que el clk de entrada.

``` SystemVerilog
module anillo_ctdr
(
    input logic clk,
    input logic rst,
    output logic [3:0] fila
);
always_ff @(posedge clk or negedge rst) begin
    if (!rst) 
        fila <= 4'b0001; 
    else 
        fila <= {fila[2:0], fila[3]};
end
endmodule
```
En el código anterior del contador de anillo se observa que se utilizó una lógica secuencial, para hacer un shifter, con el cual se inicia encendiendo el primer bit 0001, y con cada cambio creciente en el clk, se realiza un shift para el bit en alto.

![Contador_anillo](Imagenes/Anillo_cont_WV.png)

``` SystemVerilog
module rebote(
    input logic clk,
    input logic boton,
    output logic boton_sal
); 
    logic clk_hab;
    logic q1, q2, q2_com, q0;

    divisor clk_ha( clk, clk_hab);

    FF_D_habilitador ff1(clk, clk_hab, boton, q0);
    FF_D_habilitador ff2(clk, clk_hab, q0, q1);
    FF_D_habilitador ff3(clk, clk_hab, q1, q2);

    assign q2_com = ~q2;
    assign boton_sal = q1 & q2_com;
endmodule
module FF_D_habilitador(
    input logic clk, 
    input logic clk_hab,
    input logic D, 
    output reg Q=0
);
    always_ff @ (posedge clk) begin
        if(clk_hab == 1) 
            Q <= D;
    end
endmodule 
```
Para el módulo de rebote se utilizan tres flip flops D, para la generación de un unico pulso en la salida de boton_sal, esto cumpliendo que boton_sal = q1 & q2_com, utilizando una compuerta AND [6].

Para el módulo FF_D_habilitador, realiza la acción de que el flip-flop D, se actualiza cuando el clk_hab esta en alto, este código se basó en [6].

``` SystemVerilog
module divisor (
    input logic clk,
    output reg clk_div
);
    parameter frecuencia = 27000000; //27 Mhz
    parameter fre = 1000000; //10hz
    parameter max_cuenta = frecuencia / (2*fre); //13.5 ciclos aprox 
    reg [4:0]cuenta;
    initial begin 
        cuenta = 0;
        clk_div = 0;
    end
    always_ff @(posedge clk) begin 
        if (cuenta == max_cuenta) begin //la cantidad de ciclos en alto o bajo
            clk_div <= ~clk_div;
            cuenta <= 0;
        end
        else begin
            cuenta <= cuenta+1;
        end
    end
endmodule
```
En el módulo del divisor del clk, se observa que tiene una entrada, que corresponde a el clock de 27 MHz y una salida de un divisor de frecuencia a 1 MHz, donde primeramente se definen los parámetros con los valores deseados para obtener un parámetro max_cuenta que son 13 ciclos del clock a 27 MHz, se define un reg [4:0] para contar los flancos del clock, se inicia cuenta y clk_div a 0, y con la lógica secuencial, cuando cuenta llega a los 13 ciclos contados se cambia a alto o bajo, logrando un clk_div a 1 MHz [5].

![Divisor](Imagenes/Divisor_WV.png)



#### Almacenamiento de datos

##### Entradas y salidas
- ``:
- ``:
- ``:

``` SystemVerilog

```

#### Display


##### Entradas y salidas
- ``:
- ``:
- ``:

``` SystemVerilog

```

#### Multiplicador

##### Entradas y salidas
- ``:
- ``:
- ``:

``` SystemVerilog

```



## 5. Conclusiones
El desarrollo del sistema digital sincrónico para la realización de la multiplicación con el algoritmo de Booth, demostró un correcto funcionamiento de cada módulo por separado en SystemVerilog, en donde se manejaron los datos de manera eficiente y sincronizada, esto observado en los testbenches de cada módulo, pero al realizar el módulo del control, se pretendió que el módulo se encargara de realizar todas las tareas en una sola FSM, dado que se volvió estremadamente complejo la FSM, el sistema presentó problemas de lecturas, por lo que se recomendo utilizar varias FSM's con banderas, para no sobrecargar la FSM principal.



## 6. Análisis de principales problemas 
- Se tuvo un problema al analizar el módulo brindado para la multiplicación con el algoritmo de Booth, al momento de realizar un testbench y comprobar el resultado.
- Se presentaron problemas con el contador de anillo, ya que, en el módulo del control, al realizar el testbench no se logró apreciar el funcionamiento correcto al iniciar cada pulso de salida para cada fila.
- Se presentaron problemas en el módulo del rebote mecánico, ya que no detectaba todas las señales de entrada.
- En el módulo de control, no se logró cumplir con los objetivos planteados ya que no funcionó el código y método planteados.




## 7. Referencias
[1] R. Gorla and R. Gorla, “Finite state machines in Verilog,” VLSI WEB, Apr. 12, 2024. https://vlsiweb.com/finite-state-machines-in-verilog/

[2] “AMD Technical Information Portal.” https://docs.amd.com/r/en-US/ug901-vivado-synthesis/FSM-Example-Verilog

[3] Luis Vargas. “Ejemplos verilog.” https://www.todopic.com.ar/foros/index.php?topic=32327.msg272414#msg272414

[4] S. P. Lung, “Divisor de Reloj en Verilog.” https://idielectronica.blogspot.com/2014/06/verilog-divisor-de-reloj.html

[5] Oscar Martínez. Tutorías con Ingenio Universidad Nacional, “Divisor de frecuencia en Verilog,” YouTube. Oct. 29, 2016. [Online]. Available: https://www.youtube.com/watch?v=sLz8vAvoils

[6] “Verilog code for debouncing buttons on FPGA,” FPGA4student.com. https://www.fpga4student.com/2017/04/simple-debouncing-verilog-code-for.html

[7] V. T. L. E. De Miguel Alberto Davila Sacoto, “Multiplexación,” Curso De FPGAs, Feb. 26, 2018. https://cursofpga.wordpress.com/2018/02/25/multiplexacion-y-simulacion-de-circuitos-secuenciales/

[8] Curso FPGA, "Multiplexación y simulación de circuitos secuenciales," Curso FPGA Blog, Feb. 25, 2018. [Online]. Available: https://cursofpga.wordpress.com/2018/02/25/multiplexacion-y-simulacion-de-circuitos-secuenciales/. [Accessed: Oct. 8, 2024].

[9] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3





## 8. Anexos

### 8.1 Anexo: Testbench detector de columnas


### 8.2 Anexo: Testbench almacenamiento de datos


### 8.3 Anexo: Testbench display


### 8.4 Anexo Testbench multiplicador


### 8.5 Anexo: Testbench control FSM

