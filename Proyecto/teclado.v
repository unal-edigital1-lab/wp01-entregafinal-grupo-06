module Teclado(clk,fila,col,posicion,opr);
	input clk;
	input [3:0]fila;
	output reg [3:0]col;
	output reg[3:0]posicion;
	output wire opr;
	
	reg[7:0] caso;
	reg opr1=0; 
	reg opr2=0; 
	reg opr3=0; 
	reg opr4=0; 
	reg [1:0] count=0;


	assign opr=opr1|opr2|opr3|opr4;

	/*
	Dependiendo de la combinación de caso, el valor de posicion varia entre 0 y 15. Por defecto se configura en 0.
	*/
	always@(*)
		case(caso)
			8'b00010001: posicion=4'b0000; // F1C1
			8'b00010010: posicion=4'b0001; // F1C2
			8'b00010100: posicion=4'b0010; // F1C3
			8'b00011000: posicion=4'b0011; // F1C4
			8'b00100001: posicion=4'b0100; // F2C1
			8'b00100010: posicion=4'b0101; // F2C2
			8'b00100100: posicion=4'b0110; // F2C3
			8'b00101000: posicion=4'b0111; // F2C4
			8'b01000001: posicion=4'b1000; // F3C1
			8'b01000010: posicion=4'b1001; // F3C2
			8'b01000100: posicion=4'b1010; // F3C3
			8'b01001000: posicion=4'b1011; // F3C4
			8'b10000001: posicion=4'b1100; // F4C1
			8'b10000010: posicion=4'b1101; // F4C2
			8'b10000100: posicion=4'b1110; // F4C3
			8'b10001000: posicion=4'b1111; // F4C4
			default:     posicion=4'b0000; // F1C1
		endcase
	
	initial begin
		caso=8'b00000000;
		posicion=4'b0000;
	end
	
// Divisor de frecuecia utilizado para los cambios de valores en las columnas. 
wire enable;
reg [26:0] cfreq=0;
assign enable = cfreq[16];
always @(posedge clk) begin
		cfreq<=cfreq+1;
end	
 
always@(posedge enable)begin
		count<= count+1;

		case (count) 
			2'h0: begin col<=4'b0001; if(~(fila==0))begin  caso={col,fila};opr1=1; end else begin opr1=0; end end
			 
			2'h1: begin col<=4'b0010; if(~(fila==0))begin  caso={col,fila};opr2=1; end else begin opr2=0; end end
			 
			2'h2: begin col<=4'b0100; if(~(fila==0))begin  caso={col,fila};opr3=1; end else begin opr3=0; end end
			 
			2'h3: begin col<=4'b1000; if(~(fila==0))begin  caso={col,fila};opr4=1; end else begin opr4=0; end end
		endcase
end

endmodule 