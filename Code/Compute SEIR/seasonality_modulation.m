function [R0_seasonality_prefactor] = seasonality_modulation(SEIR_metaparameters, t, with_seasonality)
    
    if strcmp(with_seasonality, 'with_seasonality')
    
        % humidity ranges from http://www.naha.climatemps.com/humidity.php and
        % https://www.worlddata.info/asia/japan/climate-okinawa.php
        % Temperature data are from Deepak, and is consistent with a june peak.
        june_peak = days(datetime(2020,06,15,0,0,0) - SEIR_metaparameters.startdate);
        seasonal_trend = cos(2 * pi * (t - june_peak) / 365);
        humidity_range    = (85 - 69)/2 * seasonal_trend;
        temperature_range = (29 - 17)/2 * seasonal_trend;

        humidity_R0_percent_change    = 0.0158;
        temperature_R0_percent_change = 0.0225;

        R0_seasonality_prefactor = 1 - humidity_R0_percent_change * humidity_range - temperature_R0_percent_change * temperature_range;

    elseif strcmp(with_seasonality, 'without_seasonality')
        R0_seasonality_prefactor = 1;
    end
        
end