# VHDL Electronic Clock Design on Vivado

This repository contains a VHDL project developed on Vivado for an electronic clock design. The clock includes comprehensive functionality, including real-time updates from seconds to years and leap year differentiation. The design is modular, with each module handling a distinct aspect of the clock's operation.

## Modules

### 1. Time and Date Module
This module manages the continual progression of time from seconds up to years, including leap year calculation. It ensures accurate timekeeping and date progression, accounting for the complexity of variable month lengths and leap years.

### 2. Synchronization and State Transition Module
This module controls the clock's behavior across different operational states. It includes a synchronization feature that resets the time and date to predefined values under certain conditions and then continues to track time from that point. This ensures the clock can be easily reset or synchronized as needed.

### 3. Display Module
The final module is responsible for the visualization of time and date on an FPGA's display. It is designed considering the unique display characteristics of the FPGA and the specific requirements for representing different values in each display segment.

## Features

- Real-time time and date tracking
- Leap year differentiation
- Multiple state handling for clock operation
- Time and date synchronization capability
- FPGA-based display design for time and date visualization

## Getting Started

To run this project on Vivado, follow these steps:

1. Clone the repository to your local machine.
2. Open the Vivado Design Suite and select `Open Project`.
3. Navigate to the cloned repository folder and select the project file.
4. Generate the bitstream by following the standard Vivado workflow.

## Prerequisites

- Xilinx Vivado Design Suite
- FPGA development board compatible with the provided design files

## Usage

The clock functionality can be tested on an FPGA board. Detailed instructions on loading the design onto an FPGA and operating the clock are included in the `docs` folder.

## Contributing

Contributions to this project are welcome. Please fork the repository and submit a pull request with your enhancements.


## Acknowledgments

- Xilinx for providing the Vivado Design Suite.
- The FPGA community for valuable insights and feedback.

## Contact

For any queries regarding this project, please open an issue in the repository, and we will get back to you.

