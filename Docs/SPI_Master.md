# *SPI Master*
### *(Source: [SPI_Master.v](../RTL/SPI_Master.v))*
## *About*
- The SPI Master module implements a simple Serial Peripheral Interface (SPI) master controller.<br>
- It transmits and receives 8-bit data over the SPI bus using `MOSI` and `MISO` lines.<br>
- The module controls `SCLK` (serial clock) and `CS` (chip select) signals to manage communication with a slave device.<br>
- Operates as a finite state machine (FSM) with three states: `IDLE`, `SHIFT`, and `DONE`.<br>

### *Parameters*
- Fixed data width of 8 bits (`data_in` and `data_out`).
- FSM states are defined internally (`IDLE`, `SHIFT`, `DONE`).

## *Instantiation*
To use the `SPI_Master` module in your design:

```verilog
SPI_Master u_spi_master (
  .clk(clk),         // System clock
  .reset_n(rst_n),   // Active-low reset
  .start(start_tx),  // Start transmission
  .data_in(tx_data), // Data to transmit
  .miso(miso),       // Master-In Slave-Out
  .mosi(mosi),       // Master-Out Slave-In
  .sclk(sclk),       // Serial clock
  .data_out(rx_data),// Received data
  .done(done),       // Transmission complete
  .cs(cs)            // Chip select
);
```
### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| clk   | input     | 1 bit | 	System clock  |
| reset_n  | input     | 1 bit      | Active-low reset |
| start | input     | 1 bit      | 	Start transmission   |
|data_in | input     | 8 bits      | Data to be transmitted |
| miso   | output    | 1 bit |  Master-In Slave-Out (data from slave)  |
| mosi | output |  1 bit | 	Master-Out Slave-In (data to slave)| 
| sclk | output |1 bit| Serial clock | Received data from slave| 
| data_out | output |  8 bits |  Transmission complete flag| 
| done | output| 1 bit | Chip select (active low)|

## *Edge Cases & Behavior*
- Reset:<br> When reset_n=0, FSM resets to IDLE, outputs are cleared, and CS=1.
- Start:<br> When start=1 in IDLE, transmission begins. Input data is loaded into shift_reg.
- Shift operation:<br>

On each clock toggle, MOSI transmits bits (MSB first).

Simultaneously, MISO data is sampled into shift_reg.
- Completion:<br> When all 8 bits are shifted, FSM transitions to DONE. data_out is updated, done=1, and CS=1.
- FSM states:<br>

IDLE → Wait for start.

SHIFT → Perform bit-wise transmission/reception.

DONE → Signal completion and return to IDLE.
- Sequential nature:<br> Updates occur on rising edge of clk or reset. Synthesizable as flip-flops with FSM logic.
