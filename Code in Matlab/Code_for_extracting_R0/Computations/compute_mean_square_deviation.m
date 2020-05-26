% This function computes the mean square deviation between the log of the
% measured cumulative infected and the log of the cumulative infected cases
% computed from the SEIR equations where the simulatio parameters are
% specified by "variables" and "parameters"

function mean_square_deviation = compute_mean_square_deviation(variables, parameters)
    true_detected_infected = parameters.true_detected_infected; 
    computed_cumulative_infected =  parameters.detection_percentage * compute_cumulative_infected(variables, parameters);
    log_true_detected_cumulative = log(true_detected_infected);
    log_computed_detected_cumulative = log(computed_cumulative_infected);
    mean_square_deviation = sqrt(mean((log_computed_detected_cumulative - log_true_detected_cumulative).^2));
end