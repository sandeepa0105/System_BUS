module ready(
    input logic clk,
    input logic rst_n,
    input logic s1_ready,   // Should be 8-bit
    input logic s2_ready,   // Should be 8-bit
    input logic s3_ready,   // Should be 8-bit
    input logic[2:0] select,

    output logic ready

);

always@(posedge clk) begin
    if(!rst_n) begin
        ready <= 1'bx;  // It's better to reset to known values
    end else begin
        case(select)
            3'b001: ready <= s1_ready;  // 8-bit wide assignment
            3'b010: ready <= s2_ready;  // 8-bit wide assignment
            3'b011: ready <= s3_ready;  // 8-bit wide assignment
            default: ready <= 1'bx; // Replace 'x' with known value
        endcase
    end

end


endmodule