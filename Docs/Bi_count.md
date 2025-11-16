# *Bi-directional counter*
### *(Source: [Bi_count.v](../RTL/Bi_count.v))*
## *About*
- Bi-directional Counter is a sequential circuit that counts up or down based on the direction control.<br>
- It has one clock input, a reset input, an enable signal, and a direction control.<br>
- The counter output ranges from `0` to `SIZE-1` and wraps around when limits are reached.<br>

### *Parameter*
- `SIZE` – Maximum count value. Determines the range of the counter (0 to SIZE-1).

## *Instantiation*
To use the `Bi_count` module in your design:

```verilog
Bi_count #(
  .SIZE(16)   // Counter size (range: 0 to SIZE-1)
) u_counter (
  .clk(clk),       // Clock input
  .reset(rst),     // Reset input (active high)
  .dir(direction), // Direction: 0=Up, 1=Down
  .en(enable),     // Enable counting
  .out(count)      // Counter output
);
```
Override parameters `SIZE` at instantiation.

### *Ports*
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| clk   | input     | 1-bit           | 	Clock input             |
| reset | input     | 1-bit           | Reset input (active high) |
| dir   | input     | 1 bit           | 	Direction: 0=Up, 1=Down |
| en    | input     | 1-bit           | Enable signal             |
| out   | output    | log2(SIZE) bits | Counter output value      |

## *Edge Cases & Behavior*
- Reset:<br> When reset=1, counter output is set to 0 regardless of other inputs.
- Enable:<br> Counter increments/decrements only when en=1. If en=0, output holds its value.
- Up-count:<br> If dir=0, counter increments. When it reaches SIZE-1, it wraps back to 0.
- Down-count:<br> If dir=1, counter decrements. When it reaches 0, it wraps back to SIZE-1.
- Sequential nature:<br> Counter updates on the rising edge of clk or reset. Synthesizable as flip-flops with control logic.
- Parameterization:<br> Output width is automatically adjusted using $clog2(SIZE) to fit the counter range.

