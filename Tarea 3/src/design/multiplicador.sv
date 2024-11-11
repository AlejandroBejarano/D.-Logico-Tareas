typedef struct packed {
    logic load_A; 
    logic load_B; 
    logic load_add; 
    logic shift_HQ_LQ_Q_1; 
    logic add_sub; 
}   mult_control_t ;

module multiplicador#( parameter N = 8 )( 

    input logic clk,
    input logic rst,
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    input mult_control_t mult_control,
    output logic [1:0] Q_LSB, 
    output logic [2*N-1:0] Y 

); 
  
    logic [N-1:0] M; 
    logic [N-1:0] adder_sub_out; 
    logic [2*N:0] shift; 
    logic [N-1:0] HQ; 
    logic [N-1:0] LQ; 
    logic Q_1; 
        
    // reg_M    
    always_ff@(posedge clk) begin 
        if (rst) 
            M <= 'b0; 
        else if (mult_control.load_A)
            M <= A;
    end 
    
    // adder/sub
    always_comb begin 
        if (mult_control.add_sub) 
            adder_sub_out = M + HQ;
        else 
            adder_sub_out = M - HQ;
    end 
    
    // Asignaciones continuas para evitar el uso de selectores constantes en bloques always_*
    assign HQ = shift[2*N:N+1];
    assign LQ = shift[N:1];
    assign Q_1 = shift[0];
    assign Q_LSB = {LQ[0], Q_1};
    assign Y = {HQ, LQ};

    // Shift registers
    always_ff@(posedge clk) begin 
        if (rst) 
            shift <= 'b0; 
        else if (mult_control.shift_HQ_LQ_Q_1) 
            // arithmetic shift 
            shift <= $signed(shift) >>> 1; 
        else begin 
            if (mult_control.load_B) 
                shift[N:1] <= B; 
            if (mult_control.load_add) 
                shift[2*N:N+1] <= adder_sub_out; 
        end 
    end 

endmodule