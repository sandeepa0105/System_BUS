`timescale 1ns / 1ps

module master_bb_tb;

  // Clock and reset signals
  logic clk;
  logic rst_n;

  // Inputs to DUT
  logic bgrant;
  logic [15:0] address_in;
  logic [7:0] data_in;
  logic valid_in;
  logic mode;
  logic ready;
  logic [7:0] rdata;

  // Outputs from DUT
  logic breq;
  logic [15:0] sl_address;
  logic [7:0] sl_wdata;
  logic sl_mode;
  logic m_valid;
  logic [7:0] data_out;
  logic valid_out;

  // Instantiate the DUT
  master_bb dut (
    .clk(clk),
    .rst_n(rst_n),
    .bgrant(bgrant),
    .breq(breq),
    .address_in(address_in),
    .data_in(data_in),
    .valid_in(valid_in),
    .mode(mode),
    .sl_address(sl_address),
    .sl_wdata(sl_wdata),
    .sl_mode(sl_mode),
    .m_valid(m_valid),
    .ready(ready),
    .rdata(rdata),
    .data_out(data_out),
    .valid_out(valid_out)
  );

  // Clock generation
	initial begin
        clk = 0;
        repeat(250) #5 clk = ~clk; // 100MHz clock
    end

  // Stimulus generation
  initial begin
    // Initialize inputs
    rst_n = 0;
    bgrant = 0;
    address_in = 16'h0000;
    data_in = 8'h00;
    valid_in = 0;
    mode = 0;
    ready = 0;
    rdata = 8'h00;

    // Apply reset
    #10 rst_n = 1;

    // Test Case 1: Valid transaction
    #10 valid_in = 1; address_in = 16'h1234; data_in = 8'hAB; mode = 1;
    #10 bgrant = 1; // Grant access
    #10 ready = 1; rdata = 8'hCD; // Ready signal from slave
    #10 bgrant = 0; ready = 0; // Complete the transaction

    // Test Case 2: Idle to Request
    #20 valid_in = 1; address_in = 16'h5678; data_in = 8'hEF; mode = 0;
    #10 bgrant = 1;
    #10 ready = 1; rdata = 8'h89;
    #10 bgrant = 0; ready = 0;

    // Test Case 3: No grant
    #20 valid_in = 1; address_in = 16'h9ABC; data_in = 8'h12; mode = 1;
    #10 bgrant = 0; // No grant provided
    #20 valid_in = 0;

    // Test Case 4: Reset during operation
    #20 valid_in = 1; address_in = 16'hDEAD; data_in = 8'hBE; mode = 0;
    #10 rst_n = 0; // Apply reset
    #10 rst_n = 1; // Release reset

    // Finish simulation
    #50 $stop;
  end

  

endmodule