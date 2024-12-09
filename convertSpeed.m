%% Function to Convert Speed to Proper Units
function convertedSpeed = convertSpeed(speed, outputUnit)
    % Conversion factors
    ms_to_mph = 2.23694;    % 1 m/s = 2.23694 mph
    ms_to_knots = 1.94384;  % 1 m/s = 1.94384 knots

    % Perform conversion based on desired unit
    switch outputUnit
        case 'm/s'
            convertedSpeed = speed; % No conversion needed
        case 'mph'
            convertedSpeed = speed * ms_to_mph;
        case 'knots'
            convertedSpeed = speed * ms_to_knots;
        otherwise
            error('Unsupported speed unit: %s. Use "m/s", "mph", or "knots".', outputUnit);
    end
end