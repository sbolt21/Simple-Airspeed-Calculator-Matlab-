# Aircraft Airspeed Calculator (Pitot Tube) 1.3.1

### Editor: Sam Spicka
### Last Edited: 2024-12.03



## Overview
The **Aircraft Airspeed Calculator** is a MATLAB-based graphical user interface (GUI) application designed to compute various airspeed metrics using Pitot tube measurements. The application is tailored for aviation enthusiasts, engineers, and students to determine true airspeed, equivalent airspeed, Mach number, rate of climb/descent, and atmospheric conditions based on user inputs.

---

## Features
- **Altitude Input**: Accepts altitude in meters or feet.
- **Dynamic Pressure Input**: Accepts Δ pressure in kPa or psi.
- **Angle of Attack (AOA)**: Calculates rates of climb or descent using the AOA in degrees.
- **Customizable Output Units**: Outputs airspeed in mph, knots, or m/s.
- **Error Handling**: Validates input values and provides descriptive error messages.
- **Results Export**: Saves detailed results to `AirspeedResult.txt`.

---

## User Interface Elements
1. **Inputs**:
   - Altitude and Unit (meters or feet).
   - Dynamic pressure (Δ Pressure) and Unit (kPa or psi).
   - Angle of attack (AOA in degrees).
   - Desired airspeed output unit (mph, knots, m/s).

2. **Outputs**:
   - Atmospheric data (density, temperature, pressure).
   - Airspeed(TAS, EAS, IAS).
   - Mach number.
   - Rate of climb/descent (TAS, EAS, IAS).
   - Approximate drag coefficient.

3. **Tooltips**: Provides hints for inputs for enhanced user experience.

---

## How to Use
1. **Launch the Application**:
   Run the script by executing `AirspeedCalculatorApp()` in MATLAB.
   
2. **Input Parameters**:
   - Enter the altitude, Δ pressure, and AOA.
   - Select the desired units for altitude, pressure, and airspeed.

3. **Calculate**:
   Click the **Calculate** button to compute airspeed and atmospheric conditions.

4. **View Results**:
   Results are displayed in the GUI and saved in `AirspeedResult.txt`.

---

## Dependencies
- **MATLAB**: Tested on MATLAB R2023b or later.
- **Code**: Include `plane.jpg` and all other .m files in the folder

---

## File Descriptions
- **`AirspeedCalculatorApp.m`**: Main script for the GUI and calculations.
- **`plane.jpg`**: Background image for the GUI.
- **`calculateAtmosphereConditions.m`**: Function to calculate the athmosphere conditions based off the altitude.
- **`calculateClimb.m`**: Function to calculate Climb or Descent with angle of attack.
- **`convertSpeed.m`**: Function to convert airspeed to the required unit inputted.
---

## Key Functions
1. **`calculateAtmosphereConditions(altitude)`**:
   - Computes air density, temperature, and pressure based on altitude.

2. **`calculateClimb(aoa, TAS, EAS)`**:
   - Computes the rate of climb or descent using the angle of attack.

3. **`convertSpeed(speed, unit)`**:
   - Converts speed into the selected unit (mph, knots, m/s).

---
## Bugs and Updates
### [1.0] - 2024-11- 27
#### Added 
- Two outputs displayed in command window.

### [1.0.1] - 2024-11-30
####  Added 
- equivalent airspeed
- angle of attack input
- rate of climb output

### [1.2] - 2024-12-01
#### Added
- GUI used to input and out put data 
- Output printed to text file
#### Fixed
- Output being inaccurate numbers at higher altitudes
- Negative inputs breaking code

### [1.3] - 2024-12-02
#### Added
- different input and output metrics
- drop-down menu for metrics
- clear inputs button
- mach number output
- new GUI format
#### Fixed
- Angle of Attack numbers can only be realistic numbers
### [1.3.1] -2024-12.03
#### Added
- Error messages printed to 'Results' page
- More outputs in the '.txt' file
- Picture displayed in GUI
#### Fixed 
- speed conversion not being correct when converting m/s

## Error Handling
- Checks for non-negative altitude and positive pressure values.
- Ensures Δ pressure does not exceed static pressure.
- Avoids calculations if conditions are invalid (e.g., Mach > 3).

---

## Output Example
Results are saved to `AirspeedResult.txt` in the format shown here:
```text
Altitude Inputted: 1110.00 meters
Δ Pressure Inputted: 10.00 kPa
AOA Inputted: 10.00 degrees
Air Density: 1.0998 kg/m^3
Air Pressure: 88.68 kPa
True Airspeed: 319.01 mph
Indicated Airspeed: 285.24 mph
Equivalent Airspeed: 301.66 mph
Mach Number: 0.42
Rate of Climb/Descent (TAS): 55.40 mph
Rate of Climb/Descent (IAS): 49.53 mph
Rate of Climb/Descent (EAS): 52.38 mph
```

---

## License
This project is free and open-source software licensed under the **MIT License**.


