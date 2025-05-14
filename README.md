# Fobot

# FSM-Based FPGA Autonomous Line Following Robot with Intelligent Path Navigation

This repository contains the source code and documentation for an autonomous line-following robot developed using an FSM (Finite State Machine) on an FPGA. The project was developed as part of the EE396 Design Lab course at the Indian Institute of Technology Guwahati.

## 📌 Project Overview

The robot is designed to:
- Follow a black line on a white surface using IR sensors.
- Use FSM implemented in Verilog on an FPGA for intelligent navigation.
- Make real-time decisions for turns, intersections, and path deviations.
- Drive motors smoothly and accurately based on FSM state transitions.

## 🛠 Materials Used

### Hardware
- **FPGA Board:** Nexys A7-100T  
- **IR Sensors:** CNY70 (3 units)  
- **Motor Driver:** L298N  
- **Motors:** 2 DC motors with wheels  
- **Logic Gate:** NOT Gate (SN74LS04N)  
- **Others:** Jumper wires, power supply  

### Software
- **HDL:** Verilog  
- **Logic Design:** Finite State Machine  
- **Algorithm:** Left-Hand Rule for intelligent path decision  
- **Configuration:** `.xdc` files for I/O pin mapping  

## 🧠 Working Principle

The CNY70 IR sensors detect the reflectivity of the surface:
- **White surface:** High IR reflection → High voltage output
- **Black line:** Low IR reflection → Low voltage output

These outputs are fed into the FPGA, which processes them through an FSM to determine appropriate motor actions (move forward, turn left/right, stop, etc.).

## 🔩 Modules & Implementation

- **IR Sensors:** Sense the surface reflectivity
- **NOT Gates:** Condition sensor signals
- **FPGA Logic:** FSM implemented in Verilog
- **Motor Driver (L298N):** Controls motor based on FPGA output

## 🧪 Testing & Challenges

- Tuning sensor thresholds was critical for accurate detection.
- Ensuring smooth corner handling using state transitions in the FSM.
- Real-time motor control without delays was achieved via FSM design.

## 🚀 Future Work

- Implement obstacle detection using ultrasonic sensors.
- Enable remote control override via Bluetooth or Wi-Fi.
- Extend FSM for multi-path navigation and dynamic rerouting.

## 📚 References

- FPGA Board Documentation – Digilent Nexys A7-100T
- IR Sensor Datasheet – CNY70
- Motor Driver Datasheet – L298N
- Verilog FSM Design Patterns

## 👥 Authors

- **Anany Sihare** (220108006)  
- **Ashmit Verma** (220108012)  

**Guide:** Prof. Gaurav Trivedi  
Department of Electronics and Electrical Engineering, IIT Guwahati
