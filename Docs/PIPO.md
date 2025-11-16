# *Parallel-In Parallel-Out (PIPO) Register*
### *(Source: [PIPO.v](../RTL/PIPO.v))*
## *About*
- PIPO (Parallel-In Parallel-Out) register is a sequential circuit that stores input data and outputs it in parallel.<br>
- It captures the input on the rising edge of the clock when `enable=1`.<br>
- Commonly used for temporary data storage, buffering, and synchronization in digital systems.<br>

### *Parameter*
- `WIDTH` – Bit width of input `in` and output `out`.

## *Instantiation*
To use the `PIPO` module in your design:

```verilog
PIPO #(
  .WIDTH(8)   // Width of input and output
) u_pipo (
  .in(data_in),   // Parallel input data
  .clk(clk),      // Clock input
  .reset(rst),    // Reset input (active high)
  .enable(en),    // Enable signal
  .out(data_out)  // Parallel output data
);
```
Override parameters `WIDTH` at instantiation.

### Ports
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| in    | input     | WIDTH bits | Parallel input data    |
| clk   | input     | 1 bit      | Clock input  |
| reset | input     | 1 bit      | 	Reset input (active high)   |
| enable| input     | 1 bit      | Load enable; captures input on clock |
| out   | output    | WIDTH bits |  Parallel output data  |

## *Edge Cases & Behavior*
- Reset:<br> When reset=1, output is cleared to 0.
- Enable:<br> On rising edge of clk, if enable=1, output captures input. If enable=0, output holds its previous value.
- Sequential nature:<br> Updates occur on rising edge of clk or reset. Synthesizable as flip-flops with enable logic.
- Parameterization:<br> Input and output width can be adjusted using SIZE to fit system requirements.
