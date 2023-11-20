`timescale 1ns/1ps

`define CLK_PERIOD 10
`define TIMEOUT_CLOCKS_KEY_EXP 100
`define TIMEOUT_CLOCKS_ENC 100
`define ENC_PACKETS 16
`define TEST_VALUES 1000

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

// clock gen
always #(`CLK_PERIOD/2) clk = ~clk;

// setup test vars and checkers
int done;
int enc_packet_count;
int enc_test_count;
int test_seed;

bit [7:0] expected = 0;
bit [127:0] expected_ciphertext = 0;
int fd_key;
int fd_seed;
int fd_plaintext;
int fd_ciphertext;

initial begin
    $display("\n");
    $display("--- Simulation started ---\n");
    
    // paths are relative from xsim directory, i.e. from aes-256.sim/sim_1/behav/xsim
    fd_key = $fopen(("../../../../verif/key_gen.txt"), "r");
    if (!fd_key) begin
        $display("key_gen.txt could not be opened: %0d", fd_key);
        $finish;
    end

    fd_seed = $fopen(("../../../../verif/seed.txt"), "r");
    if (!fd_seed) begin
        $display("seed.txt could not be opened: %0d", fd_seed);
        $finish;
    end

    fd_plaintext = $fopen(("../../../../verif/plaintext_gen.txt"), "r");
    if (!fd_plaintext) begin
        $display("plaintext_gen.txt could not be opened: %0d", fd_plaintext);
        $finish;
    end

    fd_ciphertext = $fopen(("../../../../verif/ciphertext_gen.txt"), "r");
    if (!fd_ciphertext) begin
        $display("ciphertext_gen.txt could not be opened: %0d", fd_ciphertext);
        $finish;
    end

    done = 0;
    enc_packet_count = 0;
    #(`CLK_PERIOD*2);

    next_val_req = 1'b0;
    key_expand_start = 1'b0;
    $fscanf(fd_key, "%h", master_key);
    #(`CLK_PERIOD*1);
    key_expand_start = 1'b1;
    #(`CLK_PERIOD*1);
    key_expand_start = 1'b0;
    
    fork
        begin
            $display("--- Key expansion started ---");
            while (key_ready !== 1'b1) @(posedge clk);
            done = 1;
        end
        begin
            repeat(`TIMEOUT_CLOCKS_KEY_EXP) begin
                if (!done) @(posedge clk);
            end
            if (!done) begin // timed-out
                $display("ERROR: Key expansion timed-out");
                $finish();
            end
        end
    join
    $display("--- Key expansion finished ---");
    
    enc_test_count = 0;
    repeat(`TEST_VALUES) begin
        enc_packet_count = 0;
        done = 0;
        $fscanf(fd_plaintext, "%h", data_in);
        $fscanf(fd_ciphertext, "%h", expected_ciphertext);
        next_val_req = 1'b1;
        fork
            begin
                @(posedge clk);
                next_val_req = 1'b0;
            end
            begin
                $display("\n--- Encryption %0d started ---", enc_test_count);
                while (enc_packet_count !== `ENC_PACKETS) begin
                    if (next_val_ready == 1'b1) begin
                        if (expected !== data_out) begin
                            $display("ERROR: value mismatch. Expected 'h%2h. Got 'h%2h. Exiting.", expected, data_out);
                            finish_simulation;
                        end
                        enc_packet_count += 1;
                    end
                    if (enc_packet_count < `ENC_PACKETS) expected = expected_ciphertext[127-enc_packet_count*8 -:8];
                    @(posedge clk);
                end
                repeat(5) @(posedge clk);
                done = 1;
            end
            begin
                repeat(`TIMEOUT_CLOCKS_ENC) begin
                    if (!done) @(posedge clk);
                end
                if (!done) begin // timed-out
                    $display("ERROR: Encryption timed-out");
                    finish_simulation;
                end
            end
        join
        $display("--- Encryption finished ---");
        enc_test_count += 1;
    end
    $display("\n--- PASS ---");
    $display("Tests executed: %0d", enc_test_count);
    $fscanf(fd_seed, "%d", test_seed);
    $display("Test seed: %0d \n", test_seed);
    finish_simulation;
end

function finish_simulation;
    $display("\n--- Simulation finished ---");
    $display("\n");
    $finish;
endfunction

endmodule
