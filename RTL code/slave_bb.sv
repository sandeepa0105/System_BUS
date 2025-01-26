module slave_bb( 
	input logic clk,
	input logic rstn,	
    input logic  sl,
	//input from the master
	input logic [15:0]address,
	input logic [7:0]wdata,
	input logic mode_in,
	input logic valid,
    
    //output to the other group
	output logic [5:0]address_out,
	output logic [7:0]data_out,
	output logic valid_out,
	output logic mode_out,


	//input from the other group
	input logic sl_valid,
	input logic [7:0]sl_rdata,
	
	//output to the master
	output logic [7:0]data_in,
	output logic valid_in
	
);
	
	reg sl_valid_reg;
	reg [7:0] sl_rdata_reg;
	reg [5:0]address_reg;
	reg [7:0]wdata_reg;
	reg mode_in_reg;
	reg valid_reg;
	
    assign address_out = address_reg;
    assign data_out = wdata_reg;
	assign valid_out = valid_reg;
	assign mode_out = mode_in_reg;
    assign data_in = sl_rdata_reg;
    assign valid_in = sl_valid_reg;

	reg [1:0] stateReg;

	localparam IDLE = 2'b00;
    localparam TAKE = 2'b01;
    localparam SEND = 2'b10;

	always@(posedge clk) begin
		if(!rstn) begin
			sl_valid_reg <= 0;
			sl_rdata_reg <= 8'b0;
			address_reg <= 16'b0;
			wdata_reg <= 8'b0;
			mode_in_reg <= 1'b0;
			valid_reg <= 1'b0;
			stateReg <= IDLE;
		end else begin
			case(stateReg)
				IDLE: begin
					if(valid && sl) begin
						address_reg <= {address[14:13],address[2:0]};
						wdata_reg <= wdata;
						valid_reg <= valid;
						mode_in_reg <= mode_in;
						stateReg <= TAKE;
					end else begin
						stateReg <= IDLE;
					end
				end
				TAKE: begin
					if(sl_valid) begin
						stateReg <= SEND;
						sl_valid_reg <= 1;
						sl_rdata_reg <= sl_rdata;
					end else begin
						stateReg <= TAKE;
					end
				end
				SEND: begin
					// stateReg <= IDLE;
					if(!sl) begin
						stateReg <= IDLE;
					end else begin
						stateReg <= SEND;
					end
				end

			endcase
		end
	end

endmodule


				
