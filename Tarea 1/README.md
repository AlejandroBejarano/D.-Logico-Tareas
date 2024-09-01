# Circuito decodificador
## 1 Resumen 
En este infrome se descirbe la implementacion de un decodificardor de Gray en la FPGA por medio de un codigo en HDL basiso, el cual se subdivide en sistemas donde el primero consisten en la lectora del codigo Gray, el despliegue y traducción al formato binario para presentarlo en luces LED y por ultimo el despliegue de codigo ingresado y decodificado al display de 7 segmentos en codigo decimal.
## 2 Introducción 
En la actualida se trabaja con diseños digitales altamnete complejos que nesesitan ayuda asistida por la computadora por lo que es vital aprender lenguajes de descripción de hadware como el HDL que es utilizado en la sintesi de deseños digitales  para ser fabricados en silicio o en
FPGA.Las FPGAs, son circuitos integrados reconfigurables que de acuerdo su programación implementan
una especificación funcional a partir de un código HDL.
Un codigo binario en la representacion de 0 y 1 usado para la representacion de texto o procesadores de intrucción de las computadoras ya que se 0 reprerante apagado (sin carga electrica) y 1 ecendido (con craga electrica), sin embargo deacuerdo con los dispositivos que se trabajo pueden estar invertido. Estos numeros tambien tiene su representacion en numeros decimales que deacuerdo a las posicion y cantidad de ceros y unos representan un numero decimal.
Asi mismo el codigo Gray en es un sistema de numeracion binario en los que dos numeros consecutivos solo difieren de un digito y fue diseñado para prevenir señales falsas, pero actualmente es usado para facilitar la corrección de errores en los sistemas de comunicaciones.
## 3 Objetivos 

## 4 Diseño
### 4.1 Descripción general del funcionamiento del circuito completo y cada subsistema 
### 4.2 Diagramas de bloques de cada subsistema y su funcionamiento fundamental
### 4.3 Un ejemplo de la simplificación de las ecuaciones booleanas 
### 4.4 Ejemplo y análisis de una simulación funcional del sistema completo, desde el estímulo de entrada hasta el manejo de los 7 segmentos.

Para comprobar el funcionamiento correcto del sistema desarrollado, se realizó la creación de un Testbench, el cual tiene como finalidad, crear una simulación del sistema, para verificar su correcto funcionamiento, esto antes de implementarlo a la FPGA. Para ello se desarrolló el módulo principal_tb con las siguientes variables declaradas como logic.

```SystemVerilog
module principal_tb;
    logic [3:0] gray;
    logic [3:0] bit_4;
    logic [3:0] leds;
    logic a, b, c, d, e, f, g;
    logic btn_in;
    logic bd, cd;
    .
    .
    .
endmodule
```

De ello se utilizaron todas las variables en los módulos instanciados en el módulo principal_tb, dado que se crearon varios módulos para realizar diferentes tareas, estos se instancian para poder utilizarlos e interconectarlos y realizar la simulación como un sistema conjunto.

```SystemVerilog
module principal_tb;
    .
    .
    .
    gray_to_binary g_t_inst (
        .Gray(gray),
        .bin(bit_4)
    );

    binary_leds b_l_inst (
        .bin(bit_4),
        .Led(leds)
    );

    decodificador_siete d_s_inst(
        .bin(bit_4),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g)
    );

    decodificador_decenas d_d_inst(
        .btn_in(btn_in),
        .bd(bd), .cd(cd)
    );
    .
    .
    .
endmodule
```
Seguido de ello, para la realización de la simulación se les dio un valor a las variables gray, el correspondía a un código de binario, que simulaba si llegaba un voltaje a los pines de la FPGA, además se realizó la creación de un archivo llamado module_principal_tb.vcd, esto para observar las señales internas durante la simulación del sistema.

```SystemVerilog
module principal_tb;
    .
    .
    .
    initial begin

        gray = 4'b0000; #10;
        gray = 4'b0001; #10;
        .
        .
        gray = 4'b1110; #10;
        gray = 4'b1111; #10;
        $finish;
    end
    initial begin
        $dumpfile("module_principal_tb.vcd");
        $dumpvars(0, principal_tb);
    end

endmodule
```
De ello, al darle un valor a la variable gray, el módulo principal_tb toma el valor y utiliza la instancia de gray_to_binary, y convierte el código de gray a binario que toma la variable bit_4, a partir de esto, se utilizan las demás instancias, ya que dependen del valor de bit_4, donde las instancias de binary_leds y decodificador_siete, toman la variable bit_4 y en binary_leds, los leds toman el valor del código binario, esto para encender o apagar los leds y la instancia decodificador_siete, toma la variable bit_4 y lo codifica en un numero decimal, esto utilizando mapas de Karnaugh y el numero resultante se muestre en el siete-segmentos; por último la instancia de decodificador decenas, depende de la variable de btn_in, para que se muestre el número 1 en decimales, ya que se trabaja con 4 bits de entrada y el mayor número a alcanzar en decimal es 15, por lo que si se presiona el botón el segundo siete-segmentos mostrara el numero en la decenas que corresponde a un 1.

![GTKwave](Imagenes/GTKwave.png)

Con la herramienta de GTKwave, se logra visualizar el comportamiento de las ondas digitales, esto durante la simulación.

### 4.5 Análisis de consumo de recursos en la FPGA (LUTs, FFs, etc.) y del consumo de potencia que reporta las herramientas.

Para realizar el análisis de consumo de recursos, fue necesario realizar la simulación del sistema, el cual muestra cuantos recursos de la FPGA se van a utilizar, al realizar la simulación se obtuvieron los siguientes datos.

```SystemVerilog
2.28. Printing statistics.

=== principal ===

   Number of wires:                 37
   Number of wire bits:             67
   Number of public wires:          37
   Number of public wire bits:      67
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 35
     IBUF                            9
     LUT1                            1
     LUT2                            2
     LUT3                            1
     LUT4                            7
     OBUF                           15
```
De ello, se destacan en el consumo de recursos lógicos en la FPGA como lo son los Look-up-Tables (LUTs), donde estos hacen referencia a el tamaño de tablas de búsqueda utilizadas, esto para implementar el sistema desarrollado con lógica combinacional, en nuestro diseño se utilizan 1 LUT1, que utiliza una entrada y funciones simples, dos LUT2 con 2 entradas y realiza funciones lógicas como AND, OR, XOR, un LUT3 con tres entradas y siete LUT4 que utiliza 4 entradas para realizar funciones lógicas más complejas.


Además al ejecutar el comando de "make pnr", se genera un reporte de utilización de recursos de la FPGA
```SystemVerilog
Info: Device utilisation:
Info: 	                 VCC:     1/    1   100%
Info: 	               SLICE:    11/ 8640     0%
Info: 	                 IOB:    24/  274     8%
Info: 	                ODDR:     0/  274     0%
Info: 	           MUX2_LUT5:     0/ 4320     0%
Info: 	           MUX2_LUT6:     0/ 2160     0%
Info: 	           MUX2_LUT7:     0/ 1080     0%
Info: 	           MUX2_LUT8:     0/ 1056     0%
Info: 	                 GND:     1/    1   100%
Info: 	                RAMW:     0/  270     0%
Info: 	                 GSR:     1/    1   100%
Info: 	                 OSC:     0/    1     0%
Info: 	                rPLL:     0/    2     0%
```
De esto se observa los pocos recursos utilizados en la FPGA, como el nodo de alimentación VCC, bloques de lógica SLICE, bloques de entrada y salida IOB, el nodo a tierra GND y GSR, para el reinicio de la FPGA.





### 4.6 Análisis de principales problemas hallados durante el trabajo y de las soluciones aplicadas.





























## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema

### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
