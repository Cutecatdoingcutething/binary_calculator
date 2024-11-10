# Abstract
This project presents the design and implementation of a binary calculator on an FPGA using VHDL. The calculator performs basic arithmetic operations—addition, subtraction, multiplication, and division—on binary numbers. It is developed to process real-time binary input and display results on a 7-segment display, providing an efficient way to handle integer binary calculations at the hardware level. The design leverages a state machine to control the sequence of operations, managing inputs, computations, and display outputs. Each operation is represented in its own state, allowing the calculator to transition seamlessly between functions. The use of VHDL for this implementation enables modular, scalable design, while the FPGA platform facilitates fast processing and real-time responses. This binary calculator is intended for educational purposes, as well as for applications requiring high-speed, low-power arithmetic processing, showcasing the potential of FPGA-based digital systems in handling fundamental arithmetic in binary form.

# What it can do?
It has basic functions about calculation
1. Full Adder
2. Subtractor
3. Multiplication
4. Divider (With Remainder)
5. Reset

# Procedure
This Binary Calculator works by state with 7 states
1. State S1 : FPGA display 7-segment as start state that let you know it's begin state
2. State S2 : Input A (Signed Binary)
3. State S3 : Store A in memory
4. State S4 : Input B (Signed Binary)
5. State S5 : Store B in memory
6. State S6 : Select Operator to calculate (+ - * /)
7. State S7 : Display result on 7-segments with decimal

<h5 align="center">COMPUTER ENGINEERING<br>KING MONGKUT'S UNIVERSITY OF TECHNOLOGY NORTH BANGKOK, Y. 2024</h5>
<p align="center">
  <img width="100" height="100" src="https://github.com/Cutecatdoingcutething/binary_calculator/blob/main/nothing/LOGO-KMUTNB.png">
</p>
