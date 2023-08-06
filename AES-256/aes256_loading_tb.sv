`timescale 1ns/1ps
`define CLK_PERIOD 10

module aes256_loading_tb ();

// bench variables
reg clk = 0;

// key in
reg key_expand_start;
reg [255:0] master_key; 

// key out
wire key_ready;

// data in
reg next_val_req;
reg [127:0] data_in;

// data out
wire next_val_ready;
wire [7:0] data_out;

aes256_loading DUT_aes256_loading_i(
    .clk(clk),
    .pi_key_expand_start(key_expand_start),
    .pi_master_key(master_key),
    .po_key_ready(key_ready),
    .pi_next_val_req(next_val_req),
    .pi_data(data_in),
    .po_next_val_ready(next_val_ready),
    .po_data(data_out)
);

always #(`CLK_PERIOD/2) clk = ~clk;

initial begin  
	#(`CLK_PERIOD/2 * 5);
	#(`CLK_PERIOD * 10);
	
	key_expand_start = 1'b0;
	#(`CLK_PERIOD * 5);
	
	master_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
	key_expand_start = 1'b1;
	#(`CLK_PERIOD * 5);
	
	key_expand_start = 1'b0;
	#(`CLK_PERIOD * 100);
	
	data_in = 128'h00112233445566778899aabbccddeeff;
	next_val_req = 1'b1;
	
	#(`CLK_PERIOD * 65);
	#(`CLK_PERIOD * 5);
	key_expand_start = 1'b0;
	#(`CLK_PERIOD * 30);
	#(`CLK_PERIOD * 5);
	#(`CLK_PERIOD * 60);
	key_expand_start = 1'b1;
	#(`CLK_PERIOD * 5);
	key_expand_start = 1'b0;
	#(`CLK_PERIOD * 50);
	#(`CLK_PERIOD * 60);
	#(`CLK_PERIOD * 60);
	#(`CLK_PERIOD * 5);
	$finish;
end

endmodule
