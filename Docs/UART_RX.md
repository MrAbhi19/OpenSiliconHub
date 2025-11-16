# *UART Receiver (UART_RX)*
### *(Source: [UART_RX.v](../RTL/UART_RX.v))*
## *About*
- The UART Receiver module implements the receive side of a Universal Asynchronous Receiver/Transmitter (UART).<br>
- It samples incoming serial data (`rx_line`) at a specified baud rate and reconstructs an 8-bit parallel data word.<br>
- Operates as a finite state machine (FSM) with states: `IDLE`, `START`, `DATA`, and `STOP`.<br>
- Provides status signals to indicate busy, completion, and error conditions.<br>

### *Parameters*
- `clk_freq` – System clock frequency (default: 50 MHz).
- `baud_rate` – UART baud rate (default: 9600).
- Internal timing is derived from `clks_per_bit = clk_freq / baud_rate`.

## *Instantiation*
To use the `UART_RX` module in your design:

```verilog
UART_RX #(
  .clk_freq(50000000), // System clock frequency
  .baud_rate(9600)     // Baud rate
) u_uart_rx (
  .clk(clk),           // System clock
  .reset(rst),         // Reset input (active high)
  .rx_line(rx),        // Serial data input
  .data(rx_data),      // Received parallel data
  .rx_busy(rx_busy),   // Indicates reception in progress
  .rx_done(rx_done),   // Signals completion of reception
  .rx_error(rx_error)  // Signals framing error
);
```
Override parameters `clk_freq` and `baud_rate` at instantiation.

### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| clk   | input     | 1 bit      | 	System clock  |
| reset | input     | 1 bit      | 	Reset input (active high)  |
|rx_line|input      |1 bit       | Serial data input line |
| data| output    |8 bits     | Received parallel data |
| rx_busy  | output    | 1 bit | Indicates reception in progress  |
| rx_done| output | 1 bit | Signals completion of reception|
|rx_error| output | 1 bit | Signals framing error (invalid stop bit)| 

## *Edge Cases & Behavior*
- Reset:<br>  When reset=1, FSM resets to IDLE, counters are cleared, and outputs are reset.
- Start bit detection:<br> Reception begins when a falling edge is detected on rx_line. The module verifies the start bit at mid-bit sampling.
- Data reception:<br>

Samples 8 data bits sequentially at the baud rate.

Bits are stored in s_reg[1:8].

bit_index tracks the current bit position.

- Stop bit check:<br>

After 8 data bits, the stop bit (s_reg[9]) is sampled.

If stop bit is not 1, rx_error=1 is asserted.

If valid, data is updated and rx_done=1.

- Status signals:<br>

rx_busy=1 during reception.

rx_done=1 for one cycle when a byte is successfully received.

rx_error=1 if framing error occurs (invalid stop bit or false start).

-FSM states:<br>

IDLE → Wait for start bit.

START → Validate start bit.

DATA → Sample 8 data bits.

STOP → Sample stop bit, update outputs, return to IDLE.

- Timing: Sampling is based on clks_per_bit, ensuring correct baud rate operation.
