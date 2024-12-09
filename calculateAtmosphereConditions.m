%% Function to calculate the athmosphere conditions based off the altitude
function [density, temperature, pressure] = calculateAtmosphereConditions(altitude)
seaLevelPressure = 101325; %Pa
seaLevelTemp = 288.15; %K
lapseRate = 0.0065;
gasConstant = 287;
gravity = 9.81;
guessAltitude = 11000;

if altitude <= guessAltitude
    %linear temp drop depending on altitude
    temperature = seaLevelTemp - lapseRate * altitude;
    pressure = seaLevelPressure * (temperature / seaLevelTemp)^(gravity / (lapseRate * gasConstant));
else
    temperature = seaLevelTemp - lapseRate * guessAltitude;
    pressure = seaLevelPressure * (temperature / seaLevelTemp)^(gravity / (lapseRate * gasConstant)) * exp(-gravity * (altitude - guessAltitude) / (gasConstant * temperature));
end

%Ideal gas law
density = pressure / (gasConstant * temperature);
end
