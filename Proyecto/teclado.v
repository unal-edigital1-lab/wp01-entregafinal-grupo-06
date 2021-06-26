module Teclado(clk,fila,col,posicion,opr);
	input clk;
	input [3:0]fila;
	output reg [3:0]col;
	output reg[15:0]posicion;
	output reg opr;
	
	reg[7:0] caso;
	reg [1:0] count=0;

	
	always@(*)
		case(caso)
			8'b00010001: posicion=16'b0000000000000001; // F1C1
			8'b00010010: posicion=16'b0000000000000010; // F1C2
			8'b00010100: posicion=16'b0000000000000100; // F1C3
			8'b00011000: posicion=16'b0000000000001000; // F1C4
			8'b00100001: posicion=16'b0000000000010000; // F2C1
			8'b00100010: posicion=16'b0000000000100000; // F2C2
			8'b00100100: posicion=16'b0000000001000000; // F2C3
			8'b00101000: posicion=16'b0000000010000000; // F2C4
			8'b01000001: posicion=16'b0000000100000000; // F3C1
			8'b01000010: posicion=16'b0000001000000000; // F3C2
			8'b01000100: posicion=16'b0000010000000000; // F3C3
			8'b01001000: posicion=16'b0000100000000000; // F3C4
			8'b10000001: posicion=16'b0001000000000000; // F4C1
			8'b10000010: posicion=16'b0010000000000000; // F4C2
			8'b10000100: posicion=16'b0100000000000000; // F4C3
			8'b10001000: posicion=16'b1000000000000000; // F4C4
			default:     posicion=16'b0000000000000000; // F1C1
		endcase
	
	initial begin
		caso=8'b00000000;
		posicion=16'b0000000000000000;
	end
	
	

always@(posedge clk)begin
		count<= count+1;
		if(fila==4'b1000 || fila==4'b0100 || fila==4'b0010 || fila==4'b0001) begin
			opr=1'b0;
		end else begin
			opr=1'b1;
		end

		case (count) 
			2'h0: begin col<=4'b0001; if(~(fila==0)) caso={col,fila}; end
			 
			2'h1: begin col<=4'b0010; if(~(fila==0)) caso={col,fila}; end
			 
			2'h2: begin col<=4'b0100; if(~(fila==0)) caso={col,fila}; end
			 
			2'h3: begin col<=4'b1000; if(~(fila==0)) caso={col,fila}; end

		endcase
end

endmodule 