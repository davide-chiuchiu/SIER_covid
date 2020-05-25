function SEIR_metaparameters = initialize_SEIR_metaparameters(initial_confirmed_infected)

    % json filename with age distribution for japan
    json_name = 'covid.params_oka_.json';
    
    % fixed parameters for Okinawa
    okinawa_population = 1433566; % estimate from 2015 census
    estimated_initial_infected = estimate_initial_cases(json_name, initial_confirmed_infected);
    estimated_initial_exposed = estimated_initial_infected; 
                              % conservative assumption that there are as many
                              % exposed as infected at the beginning.
    inbound_from_Naha_airport = round(18336030 / 365);
    outbound_from_Naha_airport = inbound_from_Naha_airport;
    ICU_beds = 100;
    max_ventilators = 409;
    
    
    % parameters to make simulations [from Ferretti]
    mu_min = 1.495;
    mu_max = 1.798;
    sigma_min = 0.201;
    sigma_max = 0.521;
    [incubation_time_mean, incubation_time_std] = compute_mean_and_std_incubation_period(mu_min, mu_max, sigma_min, sigma_max, 1);
    incubation_time_distribution = makedist('Normal', 'mu', incubation_time_mean, 'sigma', incubation_time_std);
    
    shape_min = 1.75;
    shape_max = 4.7;
    scale_min = 4.7;
    scale_max = 6.9;
    [generation_time_mean, generation_time_std] = compute_mean_and_std_generation_period(shape_min, shape_max, scale_min, scale_max, 1);
    generation_time_distribution = makedist('Uniform', 'lower', generation_time_mean - 2 * generation_time_std, 'upper', generation_time_mean + 2 * generation_time_std);
    
    R0_min = 1.7;
    R0_median = 2.0;
    R0_max= 2.5;
    R0_distribution = makedist('Triangular', 'a', R0_min, 'b', R0_median, 'c', R0_max);
    
    % doubling time from Okinawa data
    mean_doubling_time = 5;
    std_doubling_time = 1;
    doubling_time_distribution = makedist('Uniform', 'lower', mean_doubling_time - std_doubling_time, 'upper', mean_doubling_time + std_doubling_time);

    % Other parameters    
    CI_interval = 0.9;
    [age_distribution, ~, ~, ~, detection_percentage] = read_china_japan_json_data(json_name);
    mean_detection_percentage = sum(age_distribution .* detection_percentage);
    

    % collecting parameters into struct
    SEIR_metaparameters = struct('R0_distribution', R0_distribution, ...
                                 'incubation_time_distribution', incubation_time_distribution, ...
                                 'generation_time_distribution', generation_time_distribution, ...
                                 'doubling_time_distribution', doubling_time_distribution, ...
                                 'okinawa_population', okinawa_population, ...
                                 'estimated_initial_exposed', estimated_initial_exposed, ...
                                 'estimated_initial_infected', estimated_initial_infected, ...
                                 'inbound_from_Naha_airport', inbound_from_Naha_airport, ...
                                 'outbound_from_Naha_airport', outbound_from_Naha_airport, ...
                                 'CI_interval', CI_interval, ...
                                 'json_name', json_name, ...
                                 'ICU_beds', ICU_beds, 'max_ventilators', max_ventilators, ...
                                 'mean_detection_percentage', mean_detection_percentage);

end