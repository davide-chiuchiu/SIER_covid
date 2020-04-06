function meta_parameters = compute_meta_patameter_estimates(n_curves, gamma_estimates, sigma_estimates, equation_type)
    
    if strcmp(equation_type, 'crude_estimate')
        R0_estimates = 1.7 + rand(1, n_curves) * (2.5 - 1.7);
        beta_estimates = R0_estimates .* gamma_estimates;
        selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_estimates > 0);
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        beta_estimates = beta_estimates(selector);

        meta_parameters = struct('sigma_estimates', sigma_estimates, 'gamma_estimates', gamma_estimates, 'beta_estimates', beta_estimates);
    elseif strcmp(equation_type, 'different_transmissions')
        R0_presymptomatic = 0.2 + 0.9 * rand(1, n_curves); % inaccurate distribution for now
        R0_symptomatic = 0.2 + 0.9 * rand(1, n_curves); % inaccurate distribution for now
        R0_environmental = 1.3 * rand(1, n_curves); % inaccurate distribution for now
        R0_asymptomatic = 1.2 * rand(1, n_curves); % inaccurate distribution for now
        
        beta_presymptomatic = R0_presymptomatic .* gamma_estimates;
        beta_symptomatic = R0_symptomatic .* gamma_estimates;        
        beta_environmental = R0_environmental .* gamma_estimates;
        beta_asymptomatic = R0_asymptomatic .* gamma_estimates;
        
        sigma_estimates = sigma_estimates(selector);
        gamma_estimates = gamma_estimates(selector);
        beta_presymptomatic = beta_presymptomatic(selector);
        beta_symptomatic = beta_symptomatic(selector);
        beta_environmental = beta_environmental(selector);
        beta_asymptomatic = beta_asymptomatic(selector);
        
    else
        error('unknow equations')
    end
    
end