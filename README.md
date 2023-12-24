# VHDL Passcode Management System

This is a simple VHDL project that implements a Password Management System. The system allows for user registration, password encryption, and login verification.

## Files

- **RandomKey.vhdl**: Generates a random key.
- **FileHandling.vhdl**: Handles file operations for storing encrypted passwords.
- **Main.vhdl**: The main module that controls the overall system.

## Running the Simulation

1. **Simulation Environment:**
   - Ensure you have a VHDL simulator installed (e.g., ModelSim, VCS).
   - Open the simulator and create a new project.

2. **Add Files:**
   - Add the following VHDL files to your project:
     - `RandomKey.vhd`
     - `FileHandling.vhd`
     - `Main.vhd`
     - `Passcode_tb.vhd` (Testbench)

3. **Compile:**
   - Compile the design files.

## Testbench

- The testbench (`Passcode_tb.vhd`) includes stimuli generation to simulate user interactions.
- Adjust the `CLK_PERIOD` in the testbench based on your design requirements.

## Usage

- Modify the project as needed for your specific requirements.
- Customize the password, key generation, and encryption logic.