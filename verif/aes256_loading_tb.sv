`timescale 1ns/1ps

`define CLK_PERIOD 10
`define TIMEOUT_CLOCKS_KEY_EXP 100
`define TIMEOUT_CLOCKS_ENC 100
`define ENC_PACKETS 16
`define TEST_VALUES 1000
`define TESTS 100

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
int i;
int done;
int enc_packet_count;
int enc_test_count;
int test_seed;

bit [7:0] expected = 0;
bit [127:0] expected_ciphertext = 0;
string fn_key;
string fn_seed;
string fn_plaintext;
string fn_ciphertext;
int fd_key;
int fd_seed;
int fd_plaintext;
int fd_ciphertext;

initial begin
    $timeformat(-9, 2, " ns", 20);
end

initial begin
    $display("\n");
    $display("--- Simulation started ---\n");
    
    for(i=0; i<`TESTS; i++) begin
        // paths are relative from xsim directory, i.e. from aes-256.sim/sim_1/behav/xsim
        fn_key = $sformatf("../../../../verif/t_%03d_key_gen.txt", i);
        fd_key = $fopen(fn_key, "r");
        if (!fd_key) begin
            $display("%0s could not be opened: %0d", fn_key, fd_key);
            $finish;
        end

        fn_seed = $sformatf("../../../../verif/t_%03d_seed.txt", i);
        fd_seed = $fopen(fn_seed, "r");
        if (!fd_seed) begin
            $display("%0s could not be opened: %0d", fn_seed, fd_seed);
            $finish;
        end

        fn_plaintext = $sformatf("../../../../verif/t_%03d_plaintext_gen.txt", i);
        fd_plaintext = $fopen(fn_plaintext, "r");
        if (!fd_plaintext) begin
            $display("%0s could not be opened: %0d", fn_plaintext, fd_plaintext);
            $finish;
        end

        fn_ciphertext = $sformatf("../../../../verif/t_%03d_ciphertext_gen.txt", i);
        fd_ciphertext = $fopen(fn_ciphertext, "r");
        if (!fd_ciphertext) begin
            $display("%0s could not be opened: %0d", fn_ciphertext, fd_ciphertext);
            $finish;
        end

        $display("--- Test %03d started ---", i);

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
                $display("%0t: Key expansion started", $time);
                while (key_ready !== 1'b1) @(posedge clk);
                done = 1;
            end
            begin
                repeat(`TIMEOUT_CLOCKS_KEY_EXP) begin
                    if (!done) @(posedge clk);
                end
                if (!done) begin // timed-out
                    $display("%0t: ERROR: Key expansion timed-out", $time);
                    $finish();
                end
            end
        join
        $display("%0t: Key expansion finished", $time);
        
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
                    $display("%0t: Encryption %0d started", $time, enc_test_count);
                    while (enc_packet_count !== `ENC_PACKETS) begin
                        if (next_val_ready == 1'b1) begin
                            if (expected !== data_out) begin
                                $display("%0t: ERROR: value mismatch. Expected 'h%2h. Got 'h%2h. Exiting.", $time, expected, data_out);
                                finish_simulation;
                            end
                            enc_packet_count += 1;
                        end
                        if (enc_packet_count < `ENC_PACKETS) expected = expected_ciphertext[127-enc_packet_count*8 -:8];
                        @(posedge clk);
                    end
                    repeat(5) @(posedge clk);
                    done = 1;
                    #1;
                end
                begin
                    repeat(`TIMEOUT_CLOCKS_ENC) begin
                        if (!done) @(posedge clk);
                    end
                    if (!done) begin // timed-out
                        $display("%0t: ERROR: Encryption timed-out", $time);
                        finish_simulation;
                    end
                end
            join
            $display("%0t: Encryption %0d finished", $time, enc_test_count);
            enc_test_count += 1;
        end
        $display("%0t: --- PASS ---", $time);
        $fscanf(fd_seed, "%d", test_seed);
        $display("%0t: Ciphertexts generated: %0d; Test seed: %0d; Test ID: %03d\n", $time, enc_test_count, test_seed, i);
    end
    $display("%0t: Tests executed: %0d", $time, `TESTS);
    $display("%0t: --- ALL TESTS PASSED ---", $time);
    finish_simulation;
end

function finish_simulation;
    $display("%0t: --- Simulation finished ---", $time);
    $display("\n");
    $finish;
endfunction

endmodule
