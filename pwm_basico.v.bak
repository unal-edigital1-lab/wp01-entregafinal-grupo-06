`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 8)(
	input clk,
	input reset,
	output reg [R - 1:0] ciclo,
	output pwm_out
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg, Q_next;
	
	reg true =1;
			// Divisor de frecuecia
	wire enable;
	reg [26:0] cfreq=0;
	assign enable = cfreq[10];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
	
	
	always @(posedge enable, negedge reset)
	begin
		if (~reset)
			Q_reg <= 'b0;
		else
		
		begin
		
		Q_reg <= Q_reg+1;
		true<=~true;	
		
		if(true==1)
		ciclo<=8'b11111111;
		else
		ciclo<=8'b0;
		end
			
	end
	
	
	assign pwm_out = (Q_reg < ciclo);
	
endmodule	
	
