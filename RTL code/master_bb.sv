module master_bb( //split transactions are not supported
	input logic clk,
	input logic rst_n,	
	input logic bgrant,	
	output logic breq,
	//input from other group
	input logic [5:0]address_in,
	input logic [7:0]data_in,
	input logic valid_in,
	input logic mode,
	
	//output to the slave
	output logic [15:0]sl_address,
	output logic [7:0]sl_wdata,
	output logic sl_mode,
	output logic m_valid,

	//input from the slave
	input logic ready,
	input logic [7:0]rdata,
	
	//output to other group
	output logic [7:0]data_out,
	output logic valid_out
	
);

	//registers
    reg [15:0] addr_reg;
    reg [7:0] wdata_reg;
    reg [7:0] rdata_reg;
    reg valid_reg;
    reg mode_reg;
    reg breq_reg;

	reg [1:0] stateReg;

    localparam IDLE = 2'b00;
    localparam REQ = 2'b01;
    localparam RES = 2'b10;

	always@(posedge clk) begin
        if (!rst_n) begin
            stateReg <= IDLE;
            breq_reg <= 1'b0;
            addr_reg <= 16'b0;
            wdata_reg <= 8'b0;
            rdata_reg <= 8'b0;
            valid_reg <= 1'b0;
            mode_reg <= 1'b0;

        end else begin
            case(stateReg)
                IDLE: begin
//                    state_show <= 3'b000;
                    if (valid_in) begin
                        stateReg <= REQ;
                        breq_reg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                    end
                end
                REQ: begin
//                    state_show <= 3'b001;
                    if (bgrant) begin
                        stateReg <= RES;
                        addr_reg <= {2'b0,address_in[5:4],8'b0,address_in[3:0]};
                        wdata_reg <= data_in + 8'b1;//consider:why
                        valid_reg <= 1'b1;
                        mode_reg <= mode;
                    end else begin
                        stateReg <= REQ;
                    end
                end
                RES: begin
//                    state_show <= 3'b010;
                    if (ready && bgrant) begin
//                        state_show <= 3'b110;
                        stateReg <= IDLE;
                        valid_reg <= 1'b0;
                        rdata_reg <= rdata;//consider:shouldn't mode be considered
                        breq_reg <= 1'b0;

                    end else begin
                        stateReg <= RES;
                    end
                end

            endcase
        end
    end

    assign breq = breq_reg;
    assign sl_address = addr_reg;
    assign sl_wdata = wdata_reg;
    assign m_valid = valid_reg;
    assign sl_mode = mode_reg;
    assign data_out = rdata_reg;
	assign valid_out = ready;


endmodule

