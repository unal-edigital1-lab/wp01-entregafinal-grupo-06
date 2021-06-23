`timescale 1ns / 1ps



module pwm_mejorado
    #(parameter R = 8, TIMER_BITS = 15)(
    input clk,
    input reset,
    input [R:0] ciclo, 
    //input [TIMER_BITS - 1:0] FINAL_VALUE, 
    output pwm_out
    );
    
    wire resetn;
	 assign resetn=~reset;
	 
    reg [TIMER_BITS - 1:0] FINAL_VALUE=15'd10000;
    reg [R - 1:0] Q_reg, Q_next;
    reg d_reg, d_next;
    wire tick;
    
    
    always @(posedge clk, negedge reset)
    begin
        if (~reset)
        begin
            Q_reg <= 'b0;
            d_reg <= 1'b0;
        end
        else if (tick)
        begin
            Q_reg <= Q_next;
            d_reg <= d_next;
        end
        else
        begin
            Q_reg <= Q_reg;
            d_reg <= d_reg;
        end                  
    end
    
    
    always @(Q_reg, ciclo)
    begin
        Q_next = Q_reg + 1;
        d_next = (Q_reg < ciclo);
    end
    
    assign pwm_out = d_reg;
    
    

    
    timer #(.BITS(TIMER_BITS)) timer0 (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .FINAL_VALUE(FINAL_VALUE),
        .done(tick)
    );
    
        
endmodule