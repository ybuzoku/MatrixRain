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
- If you experience a bug or find a spelling mistake in this program or the screensaver, feel free to raise an issue in the respective repository. I will address them in due course! :)

Contact Info:
- If you wish to contact me directly about any issues with my programs or about queries about assembly programming, feel free to contact me via reddit at u/ylli122 or directly by email at ybuzoku@hotmail.co.uk
  
This application was written and tested on an IBM PC/XT under IBM DOS 3.3 and assembled with MASM 4.0.
