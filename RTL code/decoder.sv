/*address mapping 
slave1 000x 0xxx xxxx xxxx 2k 
slave2 001x xxxx xxxx xxxx 4k
slave3 010x xxxx xxxx xxxx 4k split
busbridge 1xxx xxx xxxx xxxx 10k
*/
module decoder (
    input logic clk,
    input logic rst_n,
    input logic [15:0] addr,     // 16-bit input address
    output logic slave1_sel,     // Slave 1 select signal (2K)
    output logic slave2_sel,     // Slave 2 select signal (4K)
    output logic slave3_sel,     // Slave 3 select signal (4K)
    output logic bb_sel,
    output logic [2:0] SELR      // 2-bit output to select among slaves
);

    always@(posedge clk) begin
        if(addr[15] == 1'b1) begin
            SELR <= 3'b100;
            slave1_sel <= 0;
            slave2_sel <= 0;
            slave3_sel <= 0;
            bb_sel <= 1;  
             
            case(addr[14:13])
            
                2'b00: begin
                    SELR <= 3'b001;
                    slave1_sel <=1;
                    slave2_sel <=0;
                    slave3_sel <=0;
                    bb_sel <=0;
                end
                2'b01: begin
                    SELR <= 3'b010;
                    slave1_sel <=0;
                    slave2_sel <=1;
                    slave3_sel <=0;
                    bb_sel <=0;
                end
                2'b10: begin
                    SELR <= 3'b011;
                    slave1_sel <=0;
                    slave2_sel <=0;
                    slave3_sel <=1;
                    bb_sel <=0;
                end
                
                default: begin
                    SELR <= 3'b000;
                    slave1_sel <=0;
                    slave2_sel <=0;
                    slave3_sel <=0;
                    bb_sel <=0;
                end
            endcase
            
        end

           

endmodule