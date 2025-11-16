# *Multiplier*
### *(Source: [Multiplier.v](../RTL/Multiplier.v))*
## *About*
- Multiplier is a combinational circuits that takes 2 binary numbers as inputs and gives their product as output<br>
- It has 2 Inputs of sizes 'm' and 'n' and 1 output of size 'm + n'<br>
- Arithmatic expression is Y=A*B

### *Parameter*
- WIDTH_A - Bits Width of Input 'in1'
- WIDTH_B - Bits Width of Input 'in2'

## *Instantiation*
To use the `Multiplier` module in your design:

```verilog
Multiplier #(
  .WIDTH_A(4),   // Width of input A
  .WIDTH_B(6)    // Width of input B
)  u_mult (
  .in1(dataA),   // Input A
  .in2(dataB),   // Input B
  .out(product)  // Output = A * B
);
```
Override parameters (WIDTH_A, WIDTH_B) at instantiation.

## *Ports*
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| in1    | input     | A bits    | First operand            |
| in2    | input     | B bits    | Second operand           |
| out    | output    | A+B bits  | Product of in1 and in2   |

## *Edge Cases & Behavior*

- Zero multiplication:<br>
If either input is zero, the output is zero. No special handling is required.
- Maximum values:<br>
When both inputs are all-ones, the product spans the full (A+B)-bit range.
Example: in1 = {A{1'b1}}, in2 = {B{1'b1}}.
- Overflow:<br>
No internal overflow occurs because the output width is (A+B). Any truncation only happens if later logic reduces the width.
- Unsigned operation:<br>
Inputs are treated as unsigned. Signed multiplication requires wrapping with $signed() or modifying the logic.
- Combinational nature:<br>
This is a purely combinational block. Synthesis may map it to DSPs or array multipliers. No clock or pipeline stages are included.
