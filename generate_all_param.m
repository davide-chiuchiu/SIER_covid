function all_parameters = generate_all_param(initial_infected_estimates, gamma_estimates, sigma_estimates, n_curves, okinawa_population, equation_type)
    if strcmp(equation_type, 'crude_estimates')    
        % estimated parameters from Ferretti et al
        R0_estimates = pearsrnd(2, 0.1, 4.5, 200, 1, n_curves); % distribution is made by hand to fit 90% CI with values from Feretti et al.
        beta_estimates = R0_estimates .* gamma_estimates;
        
        selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_estimates > 0);
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        initial_infected_estimates = initial_infected_estimates(selector);
        beta_estimates = beta_estimates(selector);

        all_parameters = struct('sigma_estimates', sigma_estimates, 'gamma_estimates', gamma_estimates, ...
                                'beta_estimates', beta_estimates, 'okinawa_population', okinawa_population, ...
                                'initial_infected_estimates', initial_infected_estimates);
                            
    elseif strcmp(equation_type, 'suppressed_crude_estimates')
        % estimated parameters from Ferretti et al and from Wu et al
        R0_estimates = pearsrnd(2, 0.1, 4.5, 200, 1, n_curves) .* (0.5 + 0.2 * rand(1, n_curves)); % distribution is made by hand to fit 90% CI with values from Feretti et al.
            % suppression is estimated to be 0.5 to 0.7 of R0 from Wu,
            % using data of 1918 spanish flu.
        beta_estimates = R0_estimates .* gamma_estimates;
        
        selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_estimates > 0);
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        initial_infected_estimates = initial_infected_estimates(selector);
        beta_estimates = beta_estimates(selector);

        all_parameters = struct('sigma_estimates', sigma_estimates, 'gamma_estimates', gamma_estimates, ...
                                'beta_estimates', beta_estimates, 'okinawa_population', okinawa_population, ...
                                'initial_infected_estimates', initial_infected_estimates);
                            
                            
    elseif strcmp(equation_type, 'multiple_channels')
        R0_estimates = pearsrnd(2, 0.1, 4.5, 200, 1, n_curves); % distribution is made by hand to fit 90% CI with values from Feretti et al.
        R0_presymptomatic = 0.9 + 0.2 * randn(1, n_curves);
        R0_symptomatic = 0.8 + 0.2 * randn(1, n_curves);
        R0_asymptomatic = R0_estimates - R0_presymptomatic - R0_symptomatic;
        beta_presymptomatic = R0_presymptomatic .* gamma_estimates;
        beta_symptomatic = R0_symptomatic .* gamma_estimates;
        beta_asymptomatic = R0_asymptomatic .* gamma_estimates;
        
        selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_presymptomatic > 0) & (beta_symptomatic > 0) & (beta_asymptomatic > 0);
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        initial_infected_estimates = initial_infected_estimates(selector);
        beta_presymptomatic = beta_presymptomatic(selector);
        beta_symptomatic = beta_symptomatic(selector);
        beta_asymptomatic = beta_asymptomatic(selector);
        
        
        all_parameters = struct('sigma_estimates', sigma_estimates, 'gamma_estimates', gamma_estimates, ...
                                'beta_presymptomatic', beta_presymptomatic, 'beta_symptomatic', beta_symptomatic, ...
                                'beta_asymptomatic', beta_asymptomatic, 'okinawa_population', okinawa_population, ...
                                'initial_infected_estimates', initial_infected_estimates);
    else
        error('unknown equations')
    end
end