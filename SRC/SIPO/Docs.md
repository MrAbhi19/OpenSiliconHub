# *Serial-In Parallel-Out (SIPO) Register*
### *(Source: [SIPO.v](../RTL/SIPO.v))*
## *About*
- SIPO (Serial-In Parallel-Out) register is a sequential circuit that converts serial input data into parallel output.<br>
- It loads one bit per clock cycle and stores it in the output register until all bits are received.<br>
- Supports both left and right shifting, controlled by the `SHIFT_DIR` parameter.<br>
- Commonly used in serial communication systems, data deserialization, and interfacing serial data with parallel buses.<br>

### *Parameters*
- `WIDTH` – Bit width of parallel output (`out`).
- `SHIFT_DIR` – Shift direction (0 = Left, 1 = Right).

## *Instantiation*
To use the `SIPO` module in your design:

```verilog
SIPO #(
  .WIDTH(8),        // Width of parallel output
  .SHIFT_DIR(0)    // Shift direction: 0=Left, 1=Right
) u_sipo (
  .in(serial_in),  // Serial input bit
  .clk(clk),       // Clock input
  .reset(rst),     // Reset input (active high)
  .enable(en),     // Enable loading
  .out(parallel_out), // Parallel output data
  .done(done),     // Signals completion of loading
  .busy(busy)      // Indicates active loading
);
```
Override parameters `WIDTH` at instantiation.

### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| in    | input     | 1 bit      | 	Serial input bit   |
| clk   | input     | 1 bit      |  Clock input  |
| reset | input     | 1 bit      | 	Reset input (active high)   |
| enable| input     | 1 bit      | 	Enable signal |
| out   | output    | WIDTH bits |  Parallel output data  |
| done  | output    | 1 bit      | Signals completion of loading |
| busy  | output    | 1 bit      | Indicates active loading operation |

## *Edge Cases & Behavior*
- Reset:<br> When reset=1, output and internal counters are cleared.
- Enable:<br> Loading occurs only when enable=1. If enable=0, outputs remain idle (busy=0, done=0).
- Shift direction:<br>

SHIFT_DIR=0 → Left shift (LSB first).

SHIFT_DIR=1 → Right shift (MSB first).
- Completion:<br> When all bits are loaded, done=1 and busy=0. Counter resets to 0 for next operation.
- Sequential nature:<br> Updates occur on rising edge of clk or reset. Synthesizable as flip-flops with control logic.
- Parameterization:<br> Output width is determined by WIDTH. Direction is controlled by SHIFT_DIR.
