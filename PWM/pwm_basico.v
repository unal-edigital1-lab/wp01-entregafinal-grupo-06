`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 6, parameter N=2000)(
	input clk,
	//output reg [R - 1:0] ciclo,
	output pwm_out
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg=0;
	reg [R - 1:0] ciclo=0;
	reg [5:0]caso =0;
	reg [15:0] n=0;
	assign pwm_out = (Q_reg <ciclo);
	always @(posedge clk)
	begin
		Q_reg <= Q_reg+1;
		
	
	if(Q_reg==2**R-1) begin 
	n=n+1;
	end
	
	if(n==N)begin
		if(caso>=35) caso=0;
		else caso=caso+1;	
		n=0;end
	end
	
	always @(*) begin
	case(caso)
			0: ciclo=2**R*0.5; // 
			1: ciclo=2**R*0.5893; // 
			2: ciclo=2**R*0.6757; // 
			3: ciclo=2**R*0.7564; // 
			4: ciclo=2**R*0.829; // 
			5: ciclo=2**R*0.8909; // 
			6: ciclo=2**R*0.9403; // 
			7: ciclo=2**R*0.9755; // 
			8: ciclo=2**R-1;
			9: ciclo=2**R-1;
			10: ciclo=2**R-1;
			11: ciclo=2**R*0.9598;
			12: ciclo=2**R*0.9173;
			13: ciclo=2**R*0.8614;
			14: ciclo=2**R*0.7939;
			15: ciclo=2**R*0.7169;
			16: ciclo=2**R*0.633;
			17: ciclo=2**R*0.5448;
			18: ciclo=2**R*0.4552;
			19: ciclo=2**R*0.367;
			20: ciclo=2**R*0.2831;
			21: ciclo=2**R*0.2061;
			22: ciclo=2**R*0.1386;
			23: ciclo=2**R*0.0827;
			24: ciclo=2**R*0.0402;
			25: ciclo=2**R*0.0125;
			26: ciclo=2**R*0.0005;
			27: ciclo=2**R*0.0045;
			28: ciclo=2**R*0.0245;
			29: ciclo=2**R*0.0597;
			30: ciclo=2**R*0.1091;
			31: ciclo=2**R*0.171;
			32: ciclo=2**R*0.2436;
			33: ciclo=2**R*0.3243;
			34: ciclo=2**R*0.4107;
			35: ciclo=2**R*0.5;
			default:     ciclo=2**R-1; // 
		endcase
		
	end
	

	
endmodule