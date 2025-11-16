# *Barrel Shifter*
### *(Source: [Barrel_shifter.v](../RTL/Barrel_shifter.v))*
## *About*
- Barrel Shifter is a combinational circuit that shifts the input data by a specified amount in one clock cycle.<br>
- It has one input of size `WIDTH`, a shift amount input of size `log2(WIDTH)`, and a direction control.<br>

### *Parameter*
- WIDTH – Bit width of input `data_in` and output `data_out`.

  ## *Instantiation*
To use the `Barrel_shifter` module in your design:

```verilog
Barrel_shifter #(
  .WIDTH(8)   // Width of input and output
) u_shifter (
  .data_in(data),     // Input data
  .shift_amt(amount), // Shift amount
  .dir(direction),    // Direction: 1=Right, 0=Left
  .data_out(result)   // Shifted output
);
```
Override parameters `WIDTH` at instantiation.

### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| data_in  | input     | WIDTH bits      | Input data to be shifted     |
| shift_amt| input     | log2(WIDTH) bits| Number of positions to shift |
| dir      | input     | 1 bit           | Direction: 1=Right, 0=Left   |
| data_out | output    | WIDTH bits      | Shifted output               |

## *Edge Cases & Behavior*

- Zero shift:<br> If shift_amt = 0, output equals input (data_out = data_in).
- Maximum shift:<br> If shift_amt = WIDTH-1, output is shifted fully left or right, filling with zeros.
- Direction control:<br> dir=1 → right shift, dir=0 → left shift.
- Combinational nature:<br> Purely combinational block. Synthesis may map it to multiplexers or optimized barrel shifter logic. No clock or pipeline stages are included.
- Unsigned operation:<br> Shifts are logical (zeros filled). For arithmetic right shifts, modification is required.
