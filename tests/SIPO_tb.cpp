#include "Vsipo.h"
#include "verilated.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vsipo* top = new Vsipo;

    // Reset
    top->clk = 0;
    top->rst = 1;   // adjust to your reset signal name
    top->eval();
    top->rst = 0;

    // Shift in 8 bits
    for (int i = 0; i < 8; i++) {
        top->din = (i % 2);   // alternate 1/0
        top->clk = 1; top->eval();
        top->clk = 0; top->eval();
    }

    // Print output (adjust to your module’s port name)
    // printf("Output: %d\n", top->dout);

    delete top;
    return 0;
}
