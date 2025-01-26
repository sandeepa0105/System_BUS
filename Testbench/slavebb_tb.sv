`timescale 1ns / 1ps

module slavebb_tb;

  // Inputs
  reg clk;
  reg rstn;
  reg sl;
  reg [15:0] address;
  reg [7:0] wdata;
  reg mode_in;
  reg valid;
  reg sl_valid;
  reg [7:0] sl_rdata;

  // Outputs
  wire [15:0] address_out;
  wire [7:0] data_out;
  wire valid_out;
  wire mode_out;
  wire [7:0] data_in;
  wire valid_in;

  // Instantiate the module
  slave_bb uut (
    .clk(clk),
    .rstn(rstn),
    .sl(sl),
    .address(address),
    .wdata(wdata),
    .mode_in(mode_in),
    .valid(valid),
    .address_out(address_out),
    .data_out(data_out),
    .valid_out(valid_out),
    .mode_out(mode_out),
    .sl_valid(sl_valid),
    .sl_rdata(sl_rdata),
    .data_in(data_in),
    .valid_in(valid_in)
  );

  // Clock generation
    initial begin
        clk = 0;
        repeat(250) #5 clk = ~clk; // 100MHz clock
    end

  // Test procedure
  initial begin
    // Initialize inputs
    clk = 0;
    rstn = 0;
    sl = 0;
    address = 16'b0;
    wdata = 8'b0;
    mode_in = 0;
    valid = 0;
    sl_valid = 0;
    sl_rdata = 8'b0;

    // Reset the module
    #10 rstn = 1;

    // Test case 1: Write operation
    #10;
    sl = 1;
    address = 16'h1234;
    wdata = 8'hAB;
    mode_in = 1;
    valid = 1;

    #10;
    valid = 0;

    // Simulate response from the other group
    #20;
    sl_valid = 1;
    sl_rdata = 8'hCD;

    #10;
    sl_valid = 0;

    // Test case 2: Idle state when 'sl' deasserted
    #20;
    sl = 0;

    // Test case 3: Additional write operation
    #20;
    sl = 1;
    address = 16'h5678;
    wdata = 8'hEF;
    mode_in = 0;
    valid = 1;

    #10;
    valid = 0;

    // End simulation
    #50;
    $stop;
  end

  // Monitor outputs
//   initial begin
//     $monitor($time, 
//              " clk=%b rstn=%b sl=%b address=%h wdata=%h mode_in=%b valid=%b sl_valid=%b sl_rdata=%h | 
//              address_out=%h data_out=%h valid_out=%b mode_out=%b data_in=%h valid_in=%b",
//              clk, rstn, sl, address, wdata, mode_in, valid, sl_valid, sl_rdata,
//              address_out, data_out, valid_out, mode_out, data_in, valid_in);
//   end

endmodule
