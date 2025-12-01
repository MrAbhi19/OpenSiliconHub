# *Synchronous FIFO*  
### *(Source: [Synchronous_FIFO.v](../RTL/Synchronous_FIFO.v))*

## *About*
- The **Synchronous FIFO** is a sequential circuit that provides buffered storage for data with configurable width and depth.<br>
- It supports safe **read/write operations**, with flags to indicate when the FIFO is **full** or **empty**.<br>
- Internally, it uses pointer‑based memory management to track read and write positions.

### *Parameters*
- **WIDTH** – Bit width of each data word stored in the FIFO.  
- **DEPTH** – Number of entries in the FIFO (must be a power of 2).

## *Instantiation*
To use the `Synchronous_FIFO` module in your design:

```verilog
Synchronous_FIFO #(
  .WIDTH(8),   // Data width
  .DEPTH(16)   // FIFO depth
) u_fifo (
  .clk(clk),       // Clock input
  .rst_n(rst_n),   // Active-low reset
  .data_in(din),   // Input data
  .wr_en(wr_en),   // Write enable
  .rd_en(rd_en),   // Read enable
  .data_out(dout), // Output data
  .full(full),     // FIFO full flag
  .empty(empty)    // FIFO empty flag
);
```
Override parameters `WIDTH` and `DEPTH` at instantiation.

## *Ports*
| Name   | Direction | Width     | Description              |
|--------|-----------|-----------|--------------------------|
| clk     | input     | 1 bit| Clock signal    |
| rst_n    | input     |1 bit| Active-low reset        |
| data_in    | input     |WIDTH bits |Data input      |
| wr_en   | input    |1 bit |Write enable|
| rd_en  | input | 1 bit | Read enable|
| data_out | output | WIDTH bits | Data output|
| full | output |1 bit| High when FIFO is full|
| empty | output |1 bit| High when FIFO is empty|

## *Edge Cases & Behavior*

- Empty condition: Asserted when read and write pointers are equal.
- Full condition: Asserted when the write pointer wraps and catches up to the read pointer.
- Reset behavior: On reset, pointers are cleared and output data is reset to zero.
- Sequential nature: Operates on the rising edge of clk with synchronous read/write.
- Depth requirement: DEPTH must be a power of 2 for pointer logic to function correctly.
