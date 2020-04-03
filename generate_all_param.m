function all_parameters = generate_all_param(initial_infected_estimates, gamma_estimates, sigma_estimates, n_curves, okinawa_population, equation_type)
    if strcmp(equation_type, 'crude_estimates')    
        % estimated parameters from Ferretti et al
        R0_estimates = 1.7 + rand(1, n_curves) * (2.5 - 1.7);
        beta_estimates = R0_estimates .* gamma_estimates;
        selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_estimates > 0);
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        beta_estimates = beta_estimates(selector);
        initial_infected_estimates = initial_infected_estimates(selector);

        all_parameters = struct('sigma_estimates', sigma_estimates, 'gamma_estimates', gamma_estimates, ...
                                'beta_estimates', beta_estimates, 'okinawa_population', okinawa_population, ...
                                'initial_infected_estimates', initial_infected_estimates);
    else
        error('unknown equations')
    end
end