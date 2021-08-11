`timescale 1ns/1ps

module pwm_basico
	#(parameter R = 6)(
	input clk,
	output pwm_out,
	input [3:0]posT
	);
	
	
	
	
	
	//Contador de flanco positivo
	reg [12:0] N=0;
	reg [R - 1:0] Q_reg=0;
	reg [R - 1:0] duty=0;
	reg [5:0]caso =0;
	reg [12:0] n=0;
	
	assign Nsalida=N;
	
	
	assign pwm_out = (Q_reg <duty);
	
	always@(*)begin
		case(posT)		
		4'b0000: N=8000;
		4'b0001: N=6400;
		4'b0010: N=4800;
		4'b0011: N=3200;
		4'b0100: N=7600;
		4'b0101: N=6000;
		4'b0110: N=4400;
		4'b0111: N=2800;
		4'b1000: N=7200;
		4'b1001: N=5600;
		4'b1010: N=4000;
		4'b1011: N=2400;
		4'b1100: N=6800;
		4'b1101: N=5200;
		4'b1110: N=3600;
		4'b1111: N=2000;
		default N=0;
		endcase
	end
		
	
	always @(posedge clk)
	begin
		Q_reg <= Q_reg+1;
		if(Q_reg==2**R-1) n=n+1;
	
	if(n==N)begin
		if(caso>=35) caso=0;
		else caso=caso+1;	
		n=0;end
	end
		
always @(*) begin
	case(caso)
			0: duty=32; 
			1: duty=38;  
			2: duty=43;  
			3: duty=48; 
			4: duty=53; 
			5: duty=57; 
			6: duty=60; 
			7: duty=62; 
			8: duty=63;
			9: duty=63;
			10: duty=63;
			11: duty=61;
			12: duty=59;
			13: duty=55;
			14: duty=51;
			15: duty=46;
			16: duty=41;
			17: duty=35;
			18: duty=29;
			19: duty=23;
			20: duty=18;
			21: duty=13;
			22: duty=9;
			23: duty=5;
			24: duty=3;
			25: duty=1;
			26: duty=0;
			27: duty=0;
			28: duty=2;
			29: duty=4;
			30: duty=7;
			31: duty=11;
			32: duty=16;
			33: duty=21;
			34: duty=26;
			35: duty=32;
			default:duty=0; 
		endcase
	end
	
endmodule	






