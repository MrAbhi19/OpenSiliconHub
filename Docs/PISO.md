# *Parallel-In Serial-Out (PISO) Register*
### *(Source: [PISO.v](../RTL/PISO.v))*
## *About*
- PISO (Parallel-In Serial-Out) register is a sequential circuit that loads parallel input data and shifts it out serially, one bit per clock cycle.<br>
- It supports both left and right shifting, controlled by the `SHIFT_DIR` parameter.<br>
- Commonly used in serial communication systems, data serialization, and interfacing parallel data with serial channels.<br>

### *Parameters*
- `WIDTH` – Bit width of input `in` and total number of bits shifted out.
- `SHIFT_DIR` – Shift direction (0 = Left, 1 = Right).

## *Instantiation*
To use the `PISO` module in your design:

```verilog
PISO #(
  .WIDTH(8),        // Width of input data
  .SHIFT_DIR(0)    // Shift direction: 0=Left, 1=Right
) u_piso (
  .in(data_in),    // Parallel input data
  .clk(clk),       // Clock input
  .reset(rst),     // Reset input (active high)
  .enable(en),     // Enable shifting
  .out(serial_out),// Serial output bit
  .done(done),     // Indicates completion of shifting
  .busy(busy)      // Indicates active shifting
);
```
Override parameters `WIDTH` and `SHIFT_DIR` at instantiation.

### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| in    | input     | WIDTH bits | Parallel input data    |
| clk   | input     | 1 bit      | Clock input  |
| reset | input     | 1 bit      | 	Reset input (active high)   |
| enable| input     | 1 bit      | Load enable; captures input on clock |
| out   | output    | 1 bit      | Serial output bit |
| done  | output    | 1 bit      | Signals completion of shifting |
| busy  | output    | 1 bit      | Signals active shifting operation |

## *Edge Cases & Behavior*
- Reset:<br> When reset=1, output and internal counters are cleared.
- Enable:<br> Shifting occurs only when enable=1. If enable=0, outputs remain idle (busy=0, done=0).
- Shift direction:<br>

SHIFT_DIR=0 → Left shift (LSB first).

SHIFT_DIR=1 → Right shift (MSB first).
- Completion:<br> When all bits are shifted out, done=1 and busy=0. Counter resets to 0 for next operation.
- Sequential nature:<br> Updates occur on rising edge of clk or reset. Synthesizable as flip-flops with control logic.
- Parameterization:<br> Output sequence length is determined by WIDTH. Direction is controlled by SHIFT_DIR.
