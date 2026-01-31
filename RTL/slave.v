module SPI_Slave (clk, rst_n, SS_n, MOSI, MISO, rx_data, rx_valid, tx_data, tx_valid);
input clk, rst_n, SS_n, MOSI;    //clk: SPI serial clock from master (async)
input tx_valid;   
input [7:0] tx_data;
output reg MISO, rx_valid;
output reg [9:0] rx_data;

parameter IDLE      = 3'b000;
parameter CHK_CMD   = 3'b001;
parameter WRITE     = 3'b010;
parameter READ_ADD  = 3'b011;
parameter READ_DATA = 3'b100;

reg [2:0] cs, ns;
reg [3:0] count;
reg [9:0] shift_reg;  //hold data in slave 
reg control_read;   //high for READ_DATA only

// state memory
always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
      cs <= IDLE;
   else
      cs <= ns;
end

// next state logic
always @ (*) begin
  ns = IDLE;
  case (cs)
   IDLE:      if (SS_n)
                ns = IDLE;
              else
                ns = CHK_CMD;
   CHK_CMD:   if (SS_n)
                ns = IDLE;
              else if (MOSI) begin
                if (control_read)
                  ns = READ_DATA;
                else 
                  ns = READ_ADD;  
              end    
              else 
                ns = WRITE;
   WRITE:     if (SS_n)
                ns = IDLE;
              else
                ns = WRITE;
   READ_ADD:  if (SS_n) 
                ns = IDLE;
              else 
                ns = READ_ADD;
   READ_DATA: if (SS_n)
                ns = IDLE;
              else 
                ns = READ_DATA;      
   default:     ns = IDLE;
  endcase
end

// output logic
always @(posedge clk) begin
  if (!rst_n) begin
    rx_data <= 10'b0;
    rx_valid <= 1'b0;
    MISO <= 1'b0;
    count <= 4'b0;
    control_read <= 1'b0;
    shift_reg <= 10'b0;
  end
  else begin  
    case (cs)
    IDLE: begin
      rx_valid <= 1'b0;
      shift_reg <= 10'b0;
      count <= 4'b0;
    end 
    CHK_CMD: begin 
      count <= 4'b0;      
      rx_valid <= 1'b0;
    end
    WRITE: begin
      if (count < 10) begin
        shift_reg <= {shift_reg[8:0] , MOSI};
        rx_valid <= 1'b0;
        count <= count + 1;
      end
      else begin
        count <= 4'b0;
        rx_valid <= 1'b1;
        rx_data <= shift_reg;
      end
    end
    READ_ADD: begin
      if (count < 10) begin
        shift_reg <= {shift_reg[8:0] , MOSI};
        rx_valid <= 1'b0;
        count <= count + 1;
      end
      else begin
        control_read <= 1'b1;
        count <= 4'b0;
        rx_valid <= 1'b1;
        rx_data <= shift_reg;
      end
    end
    READ_DATA: begin
      if (tx_valid) begin
        rx_valid <= 0;
        // read data 
        if (count < 8) begin
          MISO <= tx_data[7 - count];
          count <= count + 1;
        end
        else begin
          control_read <= 0;
          count <= 4'b0;
        end
      end
      else begin
        if (count < 10) begin
          shift_reg <= {shift_reg[8:0] , MOSI};
          rx_valid <= 1'b0;
          count <= count + 1;
        end 
        else begin
          count <= 1;
          rx_valid <= 1'b1;
          rx_data <= shift_reg;
        end
      end 
    end
    endcase
  end
end
endmodule

     /* if (control_read) begin
        if (count < 10) begin
          shift_reg <= {shift_reg[8:0] , MOSI};
          rx_valid <= 1'b0;
          count <= count+1;
        end 
        else begin
          count <= 1'b0;
          rx_valid <= 1'b1;
          rx_data <= shift_reg;
        end
      end  
      else if (tx_valid) begin
        shift_reg <= {2'b00, tx_data};
        rx_valid <= 1'b0;
      end  
      else begin
        rx_valid <= 1'b0;
        if (count < 8) begin
          MISO <= tx_data[7 - count];
          count <= count+1;
        end
        else begin
          count <= 4'b0;
        end
      end*/