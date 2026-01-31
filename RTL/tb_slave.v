module slave_tb ();

parameter IDLE      = 3'b000;
parameter CHK_CMD   = 3'b001;
parameter WRITE     = 3'b010;
parameter READ_ADD  = 3'b011;
parameter READ_DATA = 3'b100;

reg clk, rst_n, SS_n, MOSI;
wire MISO;

Top_Module DUT (
  .clk(clk),
  .rst_n(rst_n),
  .SS_n(SS_n),
  .MOSI(MOSI),
  .MISO(MISO)
);
initial begin
    clk= 1'b0;
    forever begin
        #1 clk= ~clk;
    end
end   
initial begin
    $readmemh("mem.dat", DUT.u_ram.mem);
end 
initial begin
    rst_n = 0;
    SS_n = 1;
    MOSI = 0;
    repeat(5) @(negedge clk);
    rst_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // write command
    MOSI = 0; @(negedge clk);
     // write address 0011111111
    MOSI = 0; @(negedge clk);
    MOSI = 0; @(negedge clk);
    repeat(8) begin 
        MOSI = 1; @(negedge clk);
    end
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // write command
    MOSI = 0; @(negedge clk);
    // write data 0111111111
    MOSI = 0; @(negedge clk);
    MOSI = 1; @(negedge clk);
    repeat(8) begin 
        MOSI = 1; @(negedge clk);
    end  
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // read command
    MOSI = 1; @(negedge clk);
    // read address 1011111111
    MOSI = 1; @(negedge clk);
    MOSI = 0; @(negedge clk);
    repeat(8) begin 
        MOSI = 1; @(negedge clk);
    end 
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // read command
    MOSI = 1; @(negedge clk);
    // read data 1111111111
    MOSI = 1; @(negedge clk);
    MOSI = 1; @(negedge clk);
    repeat(8) begin 
        MOSI = 1; @(negedge clk);
    end
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // write command
    MOSI = 0; @(negedge clk);
     // write address 0000000000
    MOSI = 0; @(negedge clk);
    MOSI = 0; @(negedge clk);
    repeat(8) begin 
        MOSI = 0; @(negedge clk);
    end
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // write command
    MOSI = 0; @(negedge clk);
    // write data 0100000000
    MOSI = 0; @(negedge clk);
    MOSI = 1; @(negedge clk);
    repeat(8) begin 
        MOSI = 0; @(negedge clk);
    end  
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // read command
    MOSI = 1; @(negedge clk);
    // read address 1000000000
    MOSI = 1; @(negedge clk);
    MOSI = 0; @(negedge clk);
    repeat(8) begin 
        MOSI = 0; @(negedge clk);
    end 
    SS_n = 1; 
    repeat(2) @(negedge clk);

    SS_n = 0; @(negedge clk);
    // read command
    MOSI = 1; @(negedge clk);
    // read data 1100000000
    MOSI = 1; @(negedge clk);
    MOSI = 1; @(negedge clk);
    repeat(8) begin 
        MOSI = 0; @(negedge clk);
    end
    SS_n = 1; 
    repeat(2) @(negedge clk);
    $stop;
end  
initial begin
    $monitor("rst_n=%b, SS_n=%b, MOSI=%b, MISO=%b, rx_data=%b, rx_valid=%b, tx_data=%b, tx_valid=%b", 
              rst_n, SS_n, MOSI, MISO, DUT.u_spi_slave.rx_data, DUT.u_spi_slave.rx_valid, DUT.u_spi_slave.tx_data, DUT.u_spi_slave.tx_valid);
end
endmodule