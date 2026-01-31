module Top_Module (clk, rst_n, SS_n, MOSI, MISO);
input clk, rst_n, SS_n, MOSI;
output MISO;
wire  [9:0] rx_data;
wire rx_valid, tx_valid;
wire [7:0] tx_data;
RAM u_ram ( 
  .clk(clk),
  .rst_n(rst_n),
  .din(rx_data),
  .rx_valid(rx_valid),
  .tx_valid(tx_valid),
  .dout(tx_data)
);
SPI_Slave u_spi_slave (
  .clk(clk),
  .rst_n(rst_n),
  .SS_n(SS_n),
  .MOSI(MOSI),
  .MISO(MISO),
  .rx_data(rx_data),
  .rx_valid(rx_valid),
  .tx_data(tx_data),
  .tx_valid(tx_valid)
);
endmodule
