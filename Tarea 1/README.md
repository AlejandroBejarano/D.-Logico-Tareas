# Circuito decodificador
## 1 Resumen 
Este circuito implementa un decodificardor de Gray en la FPGA el cual se 
## 2 Introducción 
## 3 Objetivos 
## 4 Diseño
## 4.1 Descripción general del funcionamiento del circuito completo y cada subsistema 
## 4.2 Diagramas de bloques de cada subsistema y su funcionamiento fundamental
## 4.3 Un ejemplo de la simplificación de las ecuaciones booleanas 
## 4.4 Ejemplo y análisis de una simulación funcional del sistema completo, desde el estímulo de entrada hasta el manejo de los 7 segmentos.
## 4.5 Análisis de consumo de recursos en la FPGA (LUTs, FFs, etc.) y del consumo de potencia que reporta las herramientas.
## 4.6 Análisis de principales problemas hallados durante el trabajo y de las soluciones aplicadas.





























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
