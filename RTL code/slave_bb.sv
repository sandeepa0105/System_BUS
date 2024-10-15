module slave_bb( //split transactions are not supported
	input logic clk,
	input logic rstn,	
	input logic bgrant,	
	output logic breq,
	//input from other group
	input logic [15:0]address_in,
	input logic [7:0]data_in,
	input logic valid_in,
	input logic mode,
	
	//output to the slave
	output logic [15:0]sl_address,
	output logic [7:0]sl_wdata,
	output logic sl_mode,
	output logic m_valid,

	//input from the slave
	input logic sl_valid,
	input logic sl_ready,
	input logic sl_rdata,
	
	//output to other group
	output logic [15:0]address_out,
	output logic [7:0]data_out,
	output logic valid_out
	
);
	logic counter[2:0]; 
	reg data_out_reg[7:0];
	enum logic[2:0] {IDLE,TAKE_IN,SEND_OUT} state,next_state;
	
	always_comb begin
		case(state)
			IDLE: next_state = valid_in? TAKE_IN:IDLE;
			TAKE_IN : begin next_state = bgrant? SEND_OUT; counter<= 1'd0;end
			SEND_OUT : next_state = ready? IDLE;
			default:next_state = IDLE;
		endcase

	end
	
	always_ff (@posedge clk)
		if(!rstn)  
			next_state = IDLE;
			counter <= 1'd0;
		state = next_state;// consider the previous state also
		case(state)
			IDLE: begin
				
				breq <= 0;
				valid_out<=0;
			end
			TAKE_IN: begin 
				if (valid_in) begin
				address_out = address;
				address_out[15]<=0; // to map addresses
				
				breq <=1;
				m_valid<=1;
				end 
				
				
			SEND_OUT:begin
				if (!bgrant) 
					next_state = IDLE;
				
				//wait several clk cycles
				if(sl_valid)begin
					data_out_reg <= sl_rdata;
					valid_out <=1;
					counter <= counter + 1;
				end
				if (counter == 3'd2) begin
					counter <= 1'd0;
					next_state = IDLE;
				end
				
					
			end
				
			end
		endcase

	assign sl_rdata = data_in;
	assign sl_wdata = data_out;
	assign sl_mode = mode;
	assign m_valid = valid_in;
	assign data_out = data_out_reg;
end module 

