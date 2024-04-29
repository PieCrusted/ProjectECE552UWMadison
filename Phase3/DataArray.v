//Data Array of 128 cache blocks
//Each block will have 8 words
//BlockEnable and WordEnable are one-hot
//WriteEnable is one on writes and zero on reads

module DataArray(input clk, input rst, input [15:0] DataIn, input WriteEN0, input WriteEN1, 
	input [63:0] BlockEnable, input [7:0] WordEnable, output [15:0] DataOut0, output [15:0] DataOut1);
	// Block blk[127:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write), .Enable(BlockEnable), .WordEnable(WordEnable), .Dout(DataOut));
	// Modification: We will split the 128 blocks into 64 and 64 pairs for a 2 way set associative
	// TODO: If we want to a 4 way set associative for extra credit, then mabe split into 4 sets of 32
		// Note to also change the module inputs if we do change to 4 way
	Block blk[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(WriteEN0), 
		.Enable(BlockEnable), .WordEnable(WordEnable), .Dout(DataOut0));
	Block blk[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(WriteEN1), 
		.Enable(BlockEnable), .WordEnable(WordEnable), .Dout(DataOut1));
endmodule

//64 byte (8 word) cache block
module Block( input clk,  input rst, input [15:0] Din, input WriteEnable, input Enable, input [7:0] WordEnable, output [15:0] Dout);
	wire [7:0] WordEnable_real;
	assign WordEnable_real = {8{Enable}} & WordEnable; //Only for the enabled cache block, you enable the specific word
	DWord dw[7:0]( .clk(clk), .rst(rst), .Din(Din), .WriteEnable(WriteEnable), .Enable(WordEnable_real), .Dout(Dout));
endmodule


//Each word has 16 bits
module DWord( input clk,  input rst, input [15:0] Din, input WriteEnable, input Enable, output [15:0] Dout);
	DCell dc[15:0]( .clk(clk), .rst(rst), .Din(Din[15:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[15:0]));
endmodule


module DCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	dff dffd(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule

