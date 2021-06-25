`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 11,parameter F = 2)(
	
	/*
	El divisor de frecuencia total en F=0 y R=8 es de 10^12, es decir, de 50M, queda en 12.2k, 
	Aumentar en 1 a R o F divide la frecuencia en 2.
	
	*/
	
	
	input clk,
	input reset,
	//output reg [R - 1:0] ciclo,
	output pwm_out,
	output enable
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg;
	reg [R - 1:0] ciclo;
	reg [2:0]caso =0;
			// Divisor de frecuecia
	//wire enable;
	reg [26:0] cfreq=0;
	assign enable = cfreq[F];
	
	//Divide la frecuencia en 2**(n+2)
	
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end
	
	
	always @(posedge enable, negedge reset)
	begin
		if (~reset)
			Q_reg <= 'b0;
		else
		
		Q_reg <= Q_reg+1;
		
	end
	
	
	always @(*) begin
	if(Q_reg==2**R-1) caso=caso+1;	
	case(caso)
			0: ciclo=2**R*0.75; // 
			1: ciclo=2**R-1; // 
			2: ciclo=2**R*0.6; // 
			3: ciclo=2**R*0.55; // 
			4: ciclo=2**R*0.4; // 
			5: ciclo=2**R*0.2; // 
			6: ciclo=0; // 
			7: ciclo=2**R*0.6; // 
			default:     ciclo=2**R-1; // 
		endcase
	end
	
	
	assign pwm_out = (Q_reg <ciclo);
	
endmodule	
	
