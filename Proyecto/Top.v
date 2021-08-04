`timescale 1ns/1ps


module Top(clk,rst,col,fila,VGA_Hsync_n,VGA_Vsync_n,VGA_R,VGA_G,VGA_B,bell,sseg,an);
	input clk;
	input rst;	
	output [3:0]col;
	input [3:0]fila;
	output wire VGA_Hsync_n;  
	output wire VGA_Vsync_n;  
	output wire VGA_R;	
	output wire VGA_G;  
	output wire VGA_B;
	output bell;

	//input [3:0]prueba;
	//input pruebaOPR;
	//input [3:0] posT;
	//output oprN;
	output [0:6] sseg;
	output [3:0] an;
	
wire [3:0] filaAntirrebote;
wire [3:0] posT;
reg [3:0] RegPrueba;
wire [3:0] posVGA;
wire opr;
wire oprAR;
wire [3:0] datOutR;
wire [3:0] posDispay;	
reg [11:0] Nfreq;
wire pruebaOPRAntiR;
wire [3:0] pruebaAntiR;
wire salidaPWM;

assign bell=salidaPWM;
//assign oprN=~opr;
/*
always@(*)begin
	RegPrueba=prueba;
end

antirrebote bloqueOPR(.clk(clk),.ButtonIn(pruebaOPR),.ButtonOut(pruebaOPRAntiR));
antirrebote fila3(.clk(clk),.ButtonIn(prueba[3]),.ButtonOut(pruebaAntiR[3]));
antirrebote fila2(.clk(clk),.ButtonIn(prueba[2]),.ButtonOut(pruebaAntiR[2]));
antirrebote fila1(.clk(clk),.ButtonIn(prueba[1]),.ButtonOut(pruebaAntiR[1]));
antirrebote fila0(.clk(clk),.ButtonIn(prueba[0]),.ButtonOut(pruebaAntiR[0]));

antirrebote fila3(.clk(clk),.ButtonIn(fila[3]),.ButtonOut(filaAntirrebote[3]));
antirrebote fila2(.clk(clk),.ButtonIn(fila[2]),.ButtonOut(filaAntirrebote[2]));
antirrebote fila1(.clk(clk),.ButtonIn(fila[1]),.ButtonOut(filaAntirrebote[1]));
antirrebote fila0(.clk(clk),.ButtonIn(fila[0]),.ButtonOut(filaAntirrebote[0]));

//antirrebote bloqueOPR(.clk(clk),.ButtonIn(opr),.ButtonOut(oprAR));	
*/
Teclado teclado(
.clk(clk),
.fila(fila),
.col(col),
.posicion(posT),
.opr(opr)
);
	
BancoRegistro #( 4,3,"C:/Users/equip/Documents/GitHub/wp01-testvga-grupo-6/Proyecto/memDir.men")banco(
.addrR(posVGA),
.addrW(posT),
.RegWrite(opr),
.clk(clk),
.rst(~rst),
.datOutR(datOutR)
);

test_VGA VGA(
	.clk(clk),           
	.rst(~rst),
	.posicion(posVGA),
	.dirColor(datOutR),
	.VGA_Hsync_n(VGA_Hsync_n), 
	.VGA_Vsync_n(VGA_Vsync_n), 
	.VGA_R(VGA_R),	
	.VGA_G(VGA_G),  
	.VGA_B(VGA_B),   	
);

reg [9:0] mil=750;
	always @(*) begin
		RegPrueba=posT;
		Nfreq=mil+50*RegPrueba;
		/*
			if(opr) begin
			RegPrueba=4'b1111;
			//bell=salidaPWM;
		end	
		else begin
			RegPrueba=4'b0000;
			//bell=0;
		end
		*/
	end
	
pwm_basico#(6)pwm(.clk(clk),.Nentrada(Nfreq),.pwm_out(salidaPWM));

Display display(.sseg(sseg),.an(an),.numA(posT), .clk(clk));


endmodule 