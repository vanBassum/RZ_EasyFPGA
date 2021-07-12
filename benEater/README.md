This project is a VHDL implementation of the following youtube series: https://www.youtube.com/watch?v=HyznrdDSSGM&list=PLowKtXNTBypGqImE405J2565dvjafglHU

The program that is executed is stored in RAM. (ram.vhd)
This program by default contains a simple counter that starts at 5 and counts down to 0. 
After 0 has been reached, the output will be set to 8 and the program halts.

This program is easy to change by changing the contents of the ram.
Included is a simple compiler that will convert ASM code to the hex that can be inserted into the ram.vhd file.


Pushbuttons:
 - btn 1 -> Single clockpulse (one micro instruction)
 - btn 2 -> Reset
 - btn 3 -> Run (Clocks automatically while pushed.)
 - btn 4 -> Execute single instruction. (Seems to be a bit buggy.)

Hex display:
 - 2 left most, Displays the content of the output register.



# Modifications
I made some modifications in order to do a bit more with this cpu. For example, ben uses the upper 4 bits for the instruction and the lower 4 bits for data. This reduces the hardware nessesary but since we use a FPGA this isn't a problem. So I opted to use 2 ram spaces for a load instruction. First the instruction, second the value.

The address bus is 8 bits, so 256 bytes of ram can be accessed.


 -LDI, Sets reg A to value, with value in next byte
 -LDA, loads ram to regA,  with address in next byte
 -STA, Stores REGA to RAM, with address in next byte
 -OUT, Outputs REGA to output register
 -ADI, Adds reg A to value, with value in next byte
 -ADD, Adds reg A to whatever is in ram at address x, with x in next byte
 -JP,  Jump to address in next byte
 -JNZ, Jump when zeroflag is not set
 -SUI, Substracts value from REGA, with value in next byte
 -HLT, Stops code execution

# Compiler
