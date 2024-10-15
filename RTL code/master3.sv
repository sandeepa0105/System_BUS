module master3(
    input logic clk,
    input logic rst_n,
    output logic breq,
    input logic bgrant,
    output logic mode,

    output logic [15:0] addr,
    output logic [7:0] wdata,
    input logic [7:0] rdata,

    output logic m_valid,
    output logic m_ready,
    input logic sl_valid,

    //user inputs
    input logic [15:0] U_addr,
    input logic [7:0] U_wdata,
    output logic [7:0] U_rdata,
    input logic U_mode,
    input logic U_start,
    output logic [2:0] state_show
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

    always_comb begin
        if(sl_ready)
            breq_reg = 1'b1;
    end

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
                    state_show <= 3'b000;
                    if (U_start) begin
                        stateReg <= REQ;
                        addr_reg <= U_addr;
                        wdata_reg <= U_wdata 
                        valid_reg <= 1'b1;
                        mode_reg <= U_mode;
                        breq_reg <= 1'b1;
                    end 
                end
                REQ: begin
                    state_show <= 3'b001;
                    if (bgrant) begin
                        stateReg <= RES;

//consider:here no acknowledgement is taken from the slave whether it has successfully received
                    end 
                end
                RES: begin
                    state_show <= 3'b010;
                    if (sl_valid && bgrant) begin //sl_valid is asserting slave got the data
                       
                        stateReg <= IDLE;
                        valid_reg <= 1'b0;
                        rdata_reg <= rdata;//consider:shouldn't mode be considered
                        breq_reg <= 1'b0;

                    end 
                end

            endcase
        end
    end

    assign breq = breq_reg;
    assign addr = addr_reg;
    assign wdata = wdata_reg;
    assign m_valid = valid_reg;
    assign mode = mode_reg;
    assign U_rdata = rdata_reg;


endmodule
