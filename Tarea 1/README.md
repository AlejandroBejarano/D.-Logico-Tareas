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
### 4.5 Análisis de consumo de recursos en la FPGA (LUTs, FFs, etc.) y del consumo de potencia que reporta las herramientas.
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
