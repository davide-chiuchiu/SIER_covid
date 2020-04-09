function [t, quantiles_infected] = Initialize_SEIR(equation_type, SEIR_metaparameters)
    initial_infected_estimates = estimate_initial_cases(SEIR_metaparameters.json_name, SEIR_metaparameters.initial_confirmed_infected) * ones(1, SEIR_metaparameters.n_curves);

    % estimates parameters from Ferretti et al (equation independent)
    incubation_time_estimates = lognrnd(SEIR_metaparameters.central_incubation_period, SEIR_metaparameters.std_incubation_period, 1, SEIR_metaparameters.n_curves) ;
    sigma_estimates = 1 ./ incubation_time_estimates;
    gamma_estimates = 1 ./ (SEIR_metaparameters.average_serial_interval - incubation_time_estimates);

    % estimates parameters from Ferretti et al (equation dependent)
    all_parameters = generate_all_param(initial_infected_estimates, gamma_estimates, sigma_estimates, SEIR_metaparameters.n_curves, SEIR_metaparameters.okinawa_population, equation_type);

    % empty vectors for simulation
    effective_SEIR_metaparameters.n_curves = length(all_parameters.sigma_estimates);
    infected_curves = zeros(effective_SEIR_metaparameters.n_curves, length(SEIR_metaparameters.tspan));
    
    
    tic
    for i = 1 : effective_SEIR_metaparameters.n_curves
        parameters_single_simulation = generate_parameters_single_simulation(all_parameters, i, equation_type);
        [t,compartments] = SEIR(SEIR_metaparameters.tspan, parameters_single_simulation, equation_type);
        infected_curves(i, :) = compartments(:, 3);

    end
    toc

    quantiles_infected = quantile(infected_curves, [0.1, 0.5, 0.9]);

end