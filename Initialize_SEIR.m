function [t, quantiles_infected] = Initialize_SEIR(equation_type, tspan, n_curves, central_incubation_period, std_incubation_period, average_serial_interval, okinawa_population, initial_infected)
    initial_infected_estimates = initial_infected -1 + randi(10, 1, n_curves);

    % estimates parameters from Ferretti et al (equation independent)
    incubation_time_estimates = lognrnd(central_incubation_period, std_incubation_period, 1, n_curves) ;
    sigma_estimates = 1 ./ incubation_time_estimates;
    gamma_estimates = 1 ./ (average_serial_interval - incubation_time_estimates);

    % estimates parameters from Ferretti et al (equation dependent)
    all_parameters = generate_all_param(initial_infected_estimates, gamma_estimates, sigma_estimates, n_curves, okinawa_population, equation_type);

    % empty vectors for simulation
    effective_n_curves = length(all_parameters.sigma_estimates);
    infected_curves = zeros(effective_n_curves, length(tspan));
    
    
    tic
    for i = 1 : effective_n_curves
        parameters_single_simulation = generate_parameters_single_simulation(all_parameters, i, equation_type);
        [t,compartments] = SEIR(tspan, parameters_single_simulation, equation_type);
        infected_curves(i, :) = compartments(:, 3);

    end
    toc

    quantiles_infected = quantile(infected_curves, [0.1, 0.5, 0.9]);

end