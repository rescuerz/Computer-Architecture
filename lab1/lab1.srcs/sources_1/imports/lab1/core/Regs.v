`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:44 03/12/2012 
// Design Name: 
// Module Name:    Regs 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module     Regs(input clk,
				input rst,
				input [4:0] R_addr_A, 
				input [4:0] R_addr_B, 
				input [4:0] Wt_addr, 
				input [31:0]Wt_data, 
				input L_S, 
				output [31:0] rdata_A, 
				output [31:0] rdata_B,
				input [4:0] Debug_addr,         // debug address
				output[31:0] Debug_regs        // debug data
			  );

	reg [31:0] register [1:31]; 				// r1 - r31
	wire [31:0] register_next [1:31];           // The value of r1 - r31 in the next cycle 

	genvar j;
	generate
		for (j = 1; j <= 31; j = j + 1) begin
			assign register_next[j] = ((~|(Wt_addr ^ j[4:0])) & L_S)? Wt_data: register[j];
		end
	endgenerate

	assign rdata_A = (R_addr_A == 0)? 0 : register_next[R_addr_A]; 	 // read
	assign rdata_B = (R_addr_B == 0)? 0 : register_next[R_addr_B];    // read
	
	integer i;
	always @(negedge clk or posedge rst) 
      begin
		if (rst) 	 begin 			// reset
		    for (i=1; i<32; i=i+1) begin
		    	register[i] <= 0;	//i;
			end
		end 
		else begin
			for (i = 1; i <= 31; i = i + 1) begin
				register[i] <= register_next[i];
			end
		end
	end
    	
    assign Debug_regs = (Debug_addr == 0) ? 0 : register[Debug_addr];               //TEST

endmodule


