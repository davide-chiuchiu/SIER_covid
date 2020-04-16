function main(start_containment_date, equation_type, plot_results)
    n_runs = 200%20000;

    % json filename with age distribution for japan
    json_name = 'covid.params_oka_.json';

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
    
    % from Okinawa data
    mean_doubling_time = 5;
    std_doubling_time = 1;
    doubling_time_distribution = makedist('Uniform', 'lower', mean_doubling_time - std_doubling_time, 'upper', mean_doubling_time + std_doubling_time);
    
    test_distribution_doubling_times(incubation_time_distribution, generation_time_distribution, R0_distribution, doubling_time_distribution);
    
    % R0 suppression from Flaxman
    suppression_distributions = get_Flaxman_R0_suppression_distributions();

    % estimates for Okinawa
    okinawa_population = 1433566; % estimate from 2015 census
    initial_confirmed_infected = 9;
    estimated_initial_infected = estimate_initial_cases(json_name, initial_confirmed_infected);
    estimated_initial_exposed = estimated_initial_infected; 
                              % conservative assumption that there are as many
                              % exposed as infected at the beginning.
    inbound_from_Naha_airport = round(18336030 / 365);
    outbound_from_Naha_airport = inbound_from_Naha_airport;
    ICU_beds = 100;
    max_ventilators = 409;

    % Other parameters
    time = datetime(2020,03,15,0,0,0) : datetime(2020,12,31,0,0,0);
    tspan = 1 : length(time);
    start_containment_date_dummified = tspan(time == start_containment_date);
    CI_interval = 0.9;


    % collecting parameters into struct
    SEIR_metaparameters = struct('tspan', tspan, ...
                                 'R0_distribution', R0_distribution, ...
                                 'incubation_time_distribution', incubation_time_distribution, ...
                                 'generation_time_distribution', generation_time_distribution, ...
                                 'suppression_distributions', suppression_distributions, ...
                                 'okinawa_population', okinawa_population, ...
                                 'estimated_initial_exposed', estimated_initial_exposed, ...
                                 'estimated_initial_infected', estimated_initial_infected, ...
                                 'inbound_from_Naha_airport', inbound_from_Naha_airport, ...
                                 'outbound_from_Naha_airport', outbound_from_Naha_airport, ...
                                 'CI_interval', CI_interval, ...
                                 'start_containment_date', start_containment_date_dummified);

    % Run bathc of seir simulation and extract quantile information                         
    [quantile_infections, quantile_severe_cases, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time] = initialize_SEIR_batch(n_runs, time, tspan, json_name, SEIR_metaparameters, equation_type);

    summary(time, quantile_infections, quantile_severe_cases, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time, max_ventilators,[equation_type ' containment started on ' datestr(start_containment_date)])
    
    if plot_results == 1

        figure(1)
        plot_stuff(time, quantile_infections, 'infected people', SEIR_metaparameters)


        figure(2)
        plot_stuff(time, quantile_severe_cases, 'severe cases', SEIR_metaparameters)
        hold all
        plot([time(1), time(end)], [1, 1] * ICU_beds, 'DisplayName', 'ICU beds')
        plot([time(1), time(end)], [1, 1] * max_ventilators, 'DisplayName','max ventilators')
        hold off

        figure(3)
        plot_stuff(time, quantile_deaths, 'death cases', SEIR_metaparameters)
    end
    
end