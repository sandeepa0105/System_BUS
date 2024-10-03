module arbiter(
    input logic clk,
    input logic rst_n,
    input logic m1_req,
    input logic m2_req,
    output logic m1_grant,
    output logic m2_grant,
    output logic M_select

);

    //registers
    reg grant1_reg;
    reg grant2_reg;
    reg [1:0] master_select_reg;

    reg [1:0] stateReg;

    //states
    localparam IDLE = 2'b00;
    localparam GRANT1 = 2'b01;
    localparam GRANT2 = 2'b10;

    always @(posedge clk) begin
        if(!rst_n) begin
            stateReg <= IDLE;
            grant1_reg <= 1'b0;
            grant2_reg <= 1'b0;
            master_select_reg <= 1'b1;
        end
        else begin
            case(stateReg)
                IDLE: begin
                    if(m1_req) begin
                        stateReg <= GRANT1;
                        grant1_reg <= 1'b1;
                        grant2_reg <= 1'b0;
                        master_select_reg <= 1'b1;
                    end
                    else if(m2_req) begin
                        stateReg <= GRANT2;
                        grant1_reg <= 1'b0;
                        grant2_reg <= 1'b1;
                        master_select_reg <= 1'b0;
                    end else begin
                        stateReg <= IDLE;
                        grant1_reg <= 1'b0;
                        grant2_reg <= 1'b0;
                        master_select_reg <= 1'b1;
                    end
                end
                GRANT1: begin
                    if(m1_req) begin
                        stateReg <= GRANT1;
                    end
                    else if(m2_req) begin
                        stateReg <= GRANT2;
                        grant1_reg <= 1'b0;
                        grant2_reg <= 1'b1;
                        master_select_reg <= 1'b0;
                    end else begin
                        stateReg <= IDLE;
                        grant1_reg <= 1'b0;
                        grant2_reg <= 1'b0;
                        master_select_reg <= 1'b1;
                    end
                end
                GRANT2: begin
                    if(m2_req) begin
                        stateReg <= GRANT2;
                    end
                    else if(m1_req) begin
                        stateReg <= GRANT1;
                        grant1_reg <= 1'b1;
                        grant2_reg <= 1'b0;
                        master_select_reg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                        grant1_reg <= 1'b0;
                        grant2_reg <= 1'b0;
                        master_select_reg <= 1'b1;
                    end
                end
            endcase
        end
    end




    assign m1_grant = grant1_reg;
    assign m2_grant = grant2_reg;
    assign M_select = master_select_reg;


endmodule