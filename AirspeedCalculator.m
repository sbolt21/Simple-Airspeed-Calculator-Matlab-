clc;
clear;

%% runs the code and displays gui
AirspeedCalculatorApp();

function AirspeedCalculatorApp()
% Creates UIFigure
% Creates UIFigure
fig = uifigure('Name', ' Aircraft Airspeed Calculator (Pitot tube)', 'Position', [100, 100, 540, 500]);

%Display image
planeImage = uiimage(fig, 'Position', [310, 70, 210, 190]);
planeImage.ImageSource = 'plane.jpg';

%Inputs
uilabel(fig, 'Text', 'Altitude:', 'Position', [50, 440, 150, 30]);
altitudeField = uieditfield(fig, 'numeric', 'Position', [150, 440, 150, 30]);
uilabel(fig, 'Text', 'Unit:', 'Position', [310, 440, 50, 30]);
altitudeUnitDropdown = uidropdown(fig, 'Items', {'meters', 'feet'}, 'Value', 'meters', 'Position', [360, 440, 100, 30]);
uilabel(fig, 'Text', 'Δ Pressure:', 'Position', [50, 400, 150, 30]);
pressureField = uieditfield(fig, 'numeric', 'Position', [150, 400, 150, 30]);
uilabel(fig, 'Text', 'Unit:', 'Position', [310, 400, 50, 30]);
pressureUnitDropdown = uidropdown(fig, 'Items', {'kPa', 'psi'}, 'Value', 'kPa', 'Position', [360, 400, 100, 30]);
uilabel(fig, 'Text', 'Angle of Attack (degrees):', 'Position', [50, 360, 150, 30]);
aoaField = uieditfield(fig, 'numeric', 'Position', [200, 360, 100, 30]);

%Airspeed Units
uilabel(fig, 'Text', 'Airspeed Output Units:', 'Position', [50, 320, 150, 30]);
airspeedUnitDropdown = uidropdown(fig, 'Items', {'mph', 'knots', 'm/s'}, 'Value', 'mph', 'Position', [200, 320, 100, 30]);

% Calculate Button
uibutton(fig, 'Text', 'Calculate', 'Position', [330, 280, 160, 60], 'FontSize', 24, 'FontWeight', 'bold', 'ButtonPushedFcn', @(btn, event) calculateValues());

% Clear button
uibutton(fig, 'Text', 'Clear Inputs', 'Position', [360, 350, 100, 40], 'FontSize', 14, 'FontWeight', 'bold', 'ButtonPushedFcn', @(btn, event) clearFields());

% Results Output
uilabel(fig, 'Text', 'Results:', 'Position', [50, 290, 150, 30]);
resultsArea = uitextarea(fig, 'Position', [50, 50, 250, 240]);

% tooltips to make more user friendly =
altitudeField.Tooltip = 'Enter the altitude at which measurements are taken.'; 
pressureField.Tooltip = 'Enter the dynamic pressure measured by the Pitot tube.'; 
aoaField.Tooltip = 'Enter the angle of attack in degrees.';

    %Clear button function
    function clearFields()
        altitudeField.Value = 0;
        pressureField.Value = 0;
        aoaField.Value = 0;
        resultsArea.Value = '';
    end

    % Nested function to calculate values needed
    function calculateValues()
        try
        % Assign inputs to variables
        altitude = altitudeField.Value;
        deltaPressure = pressureField.Value;
        aoaInput = aoaField.Value;
       

        % Get units selected
        altitudeUnit = altitudeUnitDropdown.Value;
        pressureUnit = pressureUnitDropdown.Value;
        airspeedUnit = airspeedUnitDropdown.Value;
        

        % Validate inputs
        if altitude < 0
            resultsArea.Value = {'Error: Altitude must be non-negative.'};
            return;
        end
        if ~isempty(deltaPressure) && deltaPressure <= 0
            resultsArea.Value = {'Error: Delta pressure must be positive.'};
            return;
        end

        if strcmp(altitudeUnit, 'feet')
            altitude = altitude * 0.3048; % Convert feet to meters
        end

        if strcmp(pressureUnit, 'psi')
            deltaPressure = deltaPressure * 6894.76; % Convert psi to Pa
        else
            deltaPressure = deltaPressure * 1000; % Convert kPa to Pa
        end


       
        
        % Calculate conditions
        [airDensity, temperature, pressure] = calculateAtmosphereConditions(altitude);
       

        % Calculate airspeeds
        if ~isempty(pressure)
            rho0 = 1.23; % density at sea level
            gamma = 1.4; % heat constant of air
           
            % Indicated Airspeed (IAS)
            indicatedAirspeed = sqrt((2 * deltaPressure) / rho0);

            % Equivalent Airspeed (EAS)
            equivalentAirspeed = indicatedAirspeed * sqrt(rho0 / airDensity);

            % True Airspeed (TAS)
            trueAirspeed = equivalentAirspeed * sqrt(rho0 / airDensity);
      
            % Mach Number
            speedOfSound = sqrt(gamma * 287 * temperature); % Speed of sound at altitude input
            machNumber = trueAirspeed / speedOfSound;
            
           

            % Compressibility Warning (Mach > 3)
            if machNumber > 3
                resultsArea.Value = {'Error: Airspeed exceeds Mach 3. Calculation canceled due to compressability.'};
                return;
            end

            % Rate of climb calc
            [climbrate_True, climbrate_Equivalent, climbrate_Indicated] = calculateClimb(aoaInput, trueAirspeed,equivalentAirspeed, indicatedAirspeed);

            % Convert airspeed to selected unit
            trueAirspeed = convertSpeed(trueAirspeed, airspeedUnit);
            equivalentAirspeed = convertSpeed(equivalentAirspeed, airspeedUnit);
            indicatedAirspeed = convertSpeed(indicatedAirspeed, airspeedUnit);
            climbrate_True = convertSpeed(climbrate_True, airspeedUnit);
            climbrate_Equivalent = convertSpeed(climbrate_Equivalent, airspeedUnit);
            climbrate_Indicated = convertSpeed(climbrate_Indicated,airspeedUnit);

            % convert Altitude back to feet if needed
            if strcmp(altitudeUnit, 'feet')
                altitude = altitude / 0.3048; % Convert meters to feet
            end

            % Convert pressure for display
            if strcmp(pressureUnit, 'psi')
                pressureDisplay = pressure / 6894.76; % Convert Pascals to psi
                deltapressureDisplay = deltaPressure / 6894.76;
            else
                pressureDisplay = pressure / 1000; % Convert Pascals to kPa
                deltapressureDisplay = deltaPressure / 1000;
            end
            
            % Simplified drag estimate
            dragCoefficient = 0.02 + 0.1 * abs(aoaInput / 15);

            % Save data to text file
            textFile = fopen('AirspeedResult.txt', 'w');
            fprintf(textFile, 'Altitude Inputted: %.3f %s\n', altitude, altitudeUnit);
            fprintf(textFile, 'Δ Pressure Inputted: %.3f %s\n', deltapressureDisplay, pressureUnit);
            fprintf(textFile, 'AOA Inputted: %.2f degrees\n',aoaInput);
            fprintf(textFile, 'Air Density: %.4f kg/m^3\n', airDensity);
            fprintf(textFile, 'Air Pressure: %.3f %s\n', pressureDisplay, pressureUnit);
            fprintf(textFile, 'True Airspeed: %.3f %s\n', trueAirspeed, airspeedUnit);
            fprintf(textFile, 'Indicated Airspeed: %.2f %s\n', indicatedAirspeed, airspeedUnit);
            fprintf(textFile, 'Equivalent Airspeed: %.3f %s\n', equivalentAirspeed, airspeedUnit);
            fprintf(textFile, 'Mach Number: %.3f\n', machNumber);
            fprintf(textFile, 'Rate of Climb/Descent (TAS): %.3f %s\n', climbrate_True, airspeedUnit);
            fprintf(textFile, 'Rate of Climb/Descent (IAS): %.3f %s\n', climbrate_Indicated, airspeedUnit);
            fprintf(textFile, 'Rate of Climb/Descent (EAS): %.3f %s\n', climbrate_Equivalent, airspeedUnit);
            fclose(textFile);

            % Display results in the GUI
            resultsArea.Value = {
                sprintf('Atmosphere:')
                sprintf('Altitude: %.3f %s', altitude, altitudeUnit);
                sprintf('Air Density: %.4f kg/m^3', airDensity);
                sprintf('Temperature: %.3f K', temperature);
                sprintf('Air Pressure: %.3f %s\n\n', pressureDisplay, pressureUnit);
                sprintf('Airspeed:')
                sprintf('True Airspeed: %.3f %s', trueAirspeed, airspeedUnit);
                sprintf('Indicated Airspeed: %.3f %s', indicatedAirspeed, airspeedUnit);
                sprintf('Equivalent Airspeed: %.3f %s', equivalentAirspeed, airspeedUnit);
                sprintf('Mach Number: %.3f\n\n', machNumber);
                sprintf('Rate of Climb/Descent:')
                sprintf('Rate of Climb/Descent (TAS): %.3f %s', climbrate_True, airspeedUnit);
                sprintf('Rate of Climb/Descent (IAS): %.3f %s', climbrate_Indicated, airspeedUnit);
                sprintf('Rate of Climb/Descent (EAS): %.3f %s', climbrate_Equivalent, airspeedUnit);
                sprintf('Drag Coefficient (rough estimate): %.3f\n\n', dragCoefficient);
                'Results saved to AirspeedResult.txt'};
        else
            resultsArea.Value = {'Airspeed calculation skipped due to no air pressure.'};
        end
         catch ME
             resultsArea.Value = {sprintf('Error: %s', ME.message)};
        end
    end
end