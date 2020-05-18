function main_SEIR_predictions(n_runs, start_containment_date, equation_type, plot_results, with_seasonality)
    
    % set confirmed number of initial infected people and compute all the
    % SEIR parameters from Ferretti
    initial_confirmed_infected = 5; % this number is to have that there are 25 infected people on the 15th of March.
    SEIR_metaparameters = initialize_SEIR_metaparameters(initial_confirmed_infected);

    % define simulation time 
    startdate = datetime(2020,03,15,0,0,0);
    enddate = datetime(2020,12,31,0,0,0);
    time = startdate : enddate;
    tspan = 1 : length(time);    
    SEIR_metaparameters.tspan = tspan;
    
    % Add date of containment start to SEIR metaparameters
    start_containment_date_dummified = tspan(time == start_containment_date);
    SEIR_metaparameters.start_containment_date_flaxman = start_containment_date_dummified;
    
    % testing R0 sitribution from Ferretti with doubling times observed in
    % okinawa and overriding it because it does not reproduce the correct
    % doubling time
    SEIR_metaparameters.R0_distribution = test_distribution_doubling_times(SEIR_metaparameters);

    % add distribution of R0 suppression from Flaxman to
    % SEIR_metaparemeters
    SEIR_metaparameters.suppression_distributions = get_Flaxman_R0_suppression_distributions();
    
    % Run batch of seir simulation and extract quantile information                         
    [quantile_infections, quantile_severe_cases, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time] = initialize_SEIR_batch(n_runs, time, tspan, SEIR_metaparameters.json_name, SEIR_metaparameters, equation_type, with_seasonality);
    summary(time, quantile_infections, quantile_severe_cases, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time, SEIR_metaparameters.max_ventilators,[equation_type ' containment started on ' datestr(start_containment_date)])
    
    if plot_results == 1
        figure(1)
        plot_stuff(time, quantile_infections, 'infected people', SEIR_metaparameters)

        figure(2)
        plot_stuff(time, quantile_severe_cases, 'severe cases', SEIR_metaparameters)
        hold all
        plot([time(1), time(end)], [1, 1] * SEIR_metaparameters.ICU_beds, 'DisplayName', 'ICU beds')
        plot([time(1), time(end)], [1, 1] * SEIR_metaparameters.max_ventilators, 'DisplayName','max ventilators')
        hold off

        figure(3)
        plot_stuff(time, quantile_deaths, 'death cases', SEIR_metaparameters)
    end
    
end