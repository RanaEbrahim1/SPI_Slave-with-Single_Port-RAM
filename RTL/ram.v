module RAM (clk, rst_n, din, rx_valid, tx_valid, dout);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input [9:0] din;
input rx_valid, clk, rst_n;
output reg [7:0] dout;
output reg tx_valid;

reg [ADDR_SIZE-1:0] addr_rd, addr_wr;
reg [7:0] mem [MEM_DEPTH-1:0];

always @(posedge clk) begin
    if (!rst_n) begin
        addr_rd <= 0;
        addr_wr <= 0;
        tx_valid <= 0;
        dout <= 0;
    end
    else begin
        if (rx_valid) begin
            case (din[9:8])
            // din[9]= 0 -> write 
            2'b00: begin
                addr_wr <= din[7:0];
                tx_valid <= 1'b0;
            end
            2'b01: begin
                mem[addr_wr] <= din[7:0];
                tx_valid <= 1'b0;
            end
            // din[9]= 1 -> read
            2'b10: begin
                addr_rd <= din[7:0];
                tx_valid <= 1'b0;
            end
            2'b11: begin
                dout <= mem[addr_rd];
                tx_valid <= 1'b1;
            end
            endcase
        end
    end
end
endmodule