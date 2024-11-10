## Abstract
This project presents the design and implementation of a binary calculator on an FPGA using VHDL. The calculator performs basic arithmetic operations—addition, subtraction, multiplication, and division—on binary numbers. It is developed to process real-time binary input and display results on a 7-segment display, providing an efficient way to handle integer binary calculations at the hardware level. The design leverages a state machine to control the sequence of operations, managing inputs, computations, and display outputs. Each operation is represented in its own state, allowing the calculator to transition seamlessly between functions. The use of VHDL for this implementation enables modular, scalable design, while the FPGA platform facilitates fast processing and real-time responses. This binary calculator is intended for educational purposes, as well as for applications requiring high-speed, low-power arithmetic processing, showcasing the potential of FPGA-based digital systems in handling fundamental arithmetic in binary form.

<br>

## Functions
This binary calculator performs basic arithmetic operations including addition, subtraction, multiplication, and division (with remainder) on signed binary inputs. Key features and functions include:
1. Full Adder
2. Subtractor
3. Multiplier
4. Divider (with remainder)
5. Reset

<br>

## Operation Procedure
The calculator operates through a series of 7 states, each controlling a specific part of the calculation process: <br>
State S1: Displays a start indicator on the 7-segment display, signaling the calculator is ready for input. <br>
State S2: Accepts the first signed binary input, 𝐴 <br>
State S3: Stores 𝐴 in memory. <br>
State S4: Accepts the second signed binary input, 𝐵 <br>
State S5: Stores 𝐵 in memory. <br>
State S6: Prompts the user to select an operator for the calculation (+, -, *, /). <br>
State S7: Displays the calculation result on the 7-segment display in decimal form. <br>
Each state progresses sequentially, with the calculator using a state machine to manage inputs, operations, and display outputs on the 7-segment display. This structure enables clear and controlled transitions, allowing for precise calculation and result presentation.

***

<h5 align="center">COMPUTER ENGINEERING<br>KING MONGKUT'S UNIVERSITY OF TECHNOLOGY NORTH BANGKOK, A.Y. 2023/26</h5>
<p align="center">
  <img width="100" height="100" src="https://www.eng.kmutnb.ac.th/wp-content/uploads/2019/08/LOGO-KMUTNB--300x300.png">
</p>
