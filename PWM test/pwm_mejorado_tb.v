`timescale 1ns / 1ps



module pwm_mejorado_tb(

    );
    localparam R = 8;
    localparam TIMER_BITS = 8;
	 localparam T = 10;
    
    reg clk, reset;
    reg [R:0] ciclo;
    reg [TIMER_BITS - 1:0] FINAL_VALUE;
    wire pwm_out;

    // Instantiate module under test    
    pwm_mejorado #(.R(R), .TIMER_BITS(TIMER_BITS)) uut (
        .clk(clk),
        .reset(reset),
        .ciclo(ciclo),
        .FINAL_VALUE(FINAL_VALUE),
        .pwm_out(pwm_out)
    );
    
    // timer
    initial
        #(7 * 2**R * T * 200) $stop;
    
    // Generate stimuli
    
    // Generating a clk signal

    always
    begin
        clk = 1'b0;
        #(T / 2);
        clk = 1'b1;
        #(T / 2);
    end
    
    initial
    begin
        // issue a quick reset for 2 ns
        reset = 1'b0;
        #2  
        reset = 1'b1;
        ciclo = 0.25 * (2**R);
        FINAL_VALUE = 8'd194;
        
        repeat(2 * 2**R * FINAL_VALUE) @(negedge clk);
        ciclo = 0.50 * (2**R);

        repeat(2 * 2**R * FINAL_VALUE) @(negedge clk);
        ciclo = 0.75 * (2**R);
            
    end    
    
    
endmodule
