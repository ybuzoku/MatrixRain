# MatrixRain

A program that replicates the matrix rain effect.

Hardware Requirements:
- An IBM PC or better
- Minimum 64Kb of System RAM
- DOS 2.0 or greater

Recommended:
- IBM Monochrome Display Adapter and IBM 5151 compatible monitor

Features:
- To run the program, type scrnmat at the command prompt. When you want to exit, strike any key to exit.
- The source code contains a simple random number generation function.

Improvements for future versions:
- Dynamically allocate space to save the MDA regen buffer to restore it upon returning from the application to make a smaller executable.

Important Notice:
- This program *must* be run on a machine with speeds comparable to the 4.77MHz of the IBM PC. If you choose to run this program on an emulator, ensure you slow the emulator down.
- This program also uses the ghosting effect of the P39 Phosphor on the IBM 5151 monitor to produce the ghosting trails. Again, this effect is unlikely to be visible on an emulator.

Tested and written on an IBM PC/XT under IBM DOS 3.3 and assembled with MASM 4.0.
