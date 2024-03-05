module FLAG_reg(clk, rst_n, en, flags, N_flag, Z_flag, V_flag);

input clk, rst_n, en;
input [2:0] flags;
output N_flag, Z_flag, V_flag;
////////////////////////////////////////////////////////////

wire [2:0] flagOuputs;
// dff (q, d, wen, clk, rst)
// TODO: Check if it should preserve old value across other non ALU instruction
// or check if it should stay 0 while other non ALU instructions
dff dff0 [2:0](.q(flagOuputs), .d(flags), .wen(en), .clk(clk), .rst(rst_n));

// NVZ
assign N_flag = flagOuputs[2];
assign V_flag = flagOuputs[1];
assign Z_flag = flagOuputs[0];

endmodule