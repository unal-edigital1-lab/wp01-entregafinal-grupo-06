`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 8, parameter N=5)(
	

	input clk,
	input reset,
	//output reg [R - 1:0] ciclo,
	output pwm_out,
	output reg [5:0]caso
	//output reg [R-1:0] Q_reg
	);
	
	
	//Contador de flanco positivo
	reg [R - 1:0] Q_reg;
	reg [R - 1:0] ciclo;
	//reg [5:0]caso =0;
	initial begin caso =0;
	end
	
	/* Divisor de frecuecia
	wire enable;
	reg [26:0] cfreq=0;
	assign enable = cfreq[18];
	always @(posedge clk) begin
			cfreq<=cfreq+1;
	end*/

	always @(posedge clk)
	begin
		Q_reg <= Q_reg+1;
		
	end
	
	always @(posedge clk)
	begin
		if(Q_reg==2**(R*N-1)) begin
			if(caso>=35) caso=0;
			else if(caso<35)caso=caso+1;
		end
	end

	always @(*) begin
	/* case(caso) 
			0: ciclo=128; 
			1: ciclo=150;
			2: ciclo=172;
			3: ciclo=193; 
			4: ciclo=211;
			5: ciclo=227;
			6: ciclo=240;
			7: ciclo=249;
			8: ciclo=254;
			9: ciclo=255;
			10: ciclo=252;
			11: ciclo=245;
			12: ciclo=234;
			13: ciclo=220;
			14: ciclo=202;
			15: ciclo=183;
			16: ciclo=161;
			17: ciclo=139;
			18: ciclo=116;
			19: ciclo=94;
			20: ciclo=72;
			21: ciclo=53;
			22: ciclo=35;
			23: ciclo=21;
			24: ciclo=10;
			25: ciclo=3;
			26: ciclo=0;
			27: ciclo=1;
			28: ciclo=6;
			29: ciclo=15;
			30: ciclo=28;
			31: ciclo=44;
			32: ciclo=62;
			33: ciclo=83;
			34: ciclo=105;
			35: ciclo=128;
			default: ciclo=0;
			
		endcase*/
	case(caso)
			0: ciclo=2**R*0.5; 
			1: ciclo=2**R*0.5893;  
			2: ciclo=2**R*0.6757;  
			3: ciclo=2**R*0.7564;  
			4: ciclo=2**R*0.829;  
			5: ciclo=2**R*0.8909;  
			6: ciclo=2**R*0.9403;  
			7: ciclo=2**R*0.9755; 
			8: ciclo=2**R*0.9955;
			9: ciclo=2**R*0.9995;
			10: ciclo=2**R*0.9875;
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
			default:     ciclo=0; 
		endcase
	end
	
	assign pwm_out = (Q_reg <ciclo);
	
	
endmodule	
	
