%% function to calculate Climb/Descent with angle of attack
function [rateofClimb_T,rateofClimb_E,rateofClimb_I] = calculateClimb(aoa,trueAirspeed,equivalentAirspeed,indicatedAirspeed)
%determine if aoa is applicable
if aoa < -90 || aoa > 90
        disp('Angle of attack exceeds limit needed to calculate');
        rateofClimb_T = NaN;
        rateofClimb_E = NaN;
        rateofClimb_I = NaN;
    else
        % Convert aoa to radians if it is in degrees
        aoaRadians = deg2rad(aoa); 
        
        % Calculate rates of climb
        rateofClimb_T = trueAirspeed * sin(aoaRadians);
        rateofClimb_E = equivalentAirspeed * sin(aoaRadians);
        rateofClimb_I = indicatedAirspeed * sin(aoaRadians);
    end
end
