`timescale 1ns / 1ps

module sistema_calcu_tb;

    // Parameters
    logic clk;
    logic rst;
    logic col_0, col_1, col_2, col_3;
    logic [3:0] an;       // Display anodes
    logic [6:0] seg;      // Display segments
    logic [13:0] resultado; // Result of the addition

    // Instantiate the design under test (DUT)
    sistema_calculadora dut (
        .clk(clk),
        .rst(rst),
        .col_0(col_0),
        .col_1(col_1),
        .col_2(col_2),
        .col_3(col_3),
        .an(an),
        .seg(seg),
        .resultado(resultado)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        rst = 1;
        col_0 = 0;
        col_1 = 0;
        col_2 = 0;
        col_3 = 0;

        // Wait for the reset to propagate
        #10;
        rst = 0;

        // Test scenario 1: Input number 1
        // Press key '1' (col_0 when row 0 is active)
        #10 col_0 = 1; #10 col_0 = 0; // Input '1'
        // Press key '2' (col_1 when row 0 is active)
        #10 col_1 = 1; #10 col_1 = 0; // Input '2'
        // Press key '3' (col_2 when row 0 is active)
        #10 col_2 = 1; #10 col_2 = 0; // Input '3'
        
        // Test scenario 2: Input number 2
        // Press key '4' (col_0 when row 1 is active)
        #10 col_0 = 1; #10 col_0 = 0; // Input '4'
        // Press key '5' (col_1 when row 1 is active)
        #10 col_1 = 1; #10 col_1 = 0; // Input '5'
        // Press key '6' (col_2 when row 1 is active)
        #10 col_2 = 1; #10 col_2 = 0; // Input '6'

        // Test scenario 3: Perform addition
        // Press the '+' key (col_3 when row 0 is active)
        #10 col_3 = 1; #10 col_3 = 0; // Input '+'

        // Test scenario 4: Press the '=' key (col_3 when row 1 is active)
        #10 col_3 = 1; #10 col_3 = 0; // Input '='

        // Allow time to observe results
        #50;

        // End of simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %t | resultado: %d | an: %b | seg: %b", 
                 $time, resultado, an, seg);
    end

    initial begin // Para el diagrama de tiempos
        $dumpfile("module_sistema_calcu_tb.vcd");
        $dumpvars(0, sistema_calcu_tb); // Nombre correcto del testbench
    end

endmodule
