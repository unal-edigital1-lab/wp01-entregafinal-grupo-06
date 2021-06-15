`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 8)(
	input clk,
	input reset,
	input [R - 1:0] ciclo,
	output pwm_out
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg, Q_next;
	
			// Divisor de frecuecia
	wire enable;
	reg [26:0] cfreq=0;
	assign enable = cfreq[20];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
	
	always @(posedge enable, negedge reset)
	begin
		if (~reset)
			Q_reg <= 'b0;
		else
			Q_reg <= Q_next;
	end
	
	always @(*)
	begin
		Q_next = Q_reg+1;
	end
	
	assign pwm_out = (Q_reg < ciclo);
	
endmodule	
	
