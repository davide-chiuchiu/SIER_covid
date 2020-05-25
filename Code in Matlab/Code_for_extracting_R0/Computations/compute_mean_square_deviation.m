% This function computes the mean square deviation between the log of the
% measured cumulative infected and the log of the cumulative infected cases
% computed from the SEIR equations where the simulatio parameters are
% specified by "variables" and "parameters"

function mean_square_deviation = compute_mean_square_deviation(variables, parameters)
    true_cumulative_infected = parameters.true_cumulative_infected; 
    random_cumulative_infected = compute_cumulative_infected(variables, parameters);
    log_normalized_true_cumulative = log(true_cumulative_infected);
    log_normalized_random_cumulative = log(random_cumulative_infected);
    mean_square_deviation = sqrt(mean((log_normalized_random_cumulative - log_normalized_true_cumulative).^2));
end