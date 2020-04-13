function [quantile_infections, quantile_severe_cases, quantile_deaths] = initialize_SEIR_batch(n_runs, time, tspan, json_name, SEIR_metaparameters, equation_type)
    infected_cases_multiple = zeros(n_runs, length(time));
    severe_cases_multiple = zeros(size(infected_cases_multiple));
    death_cases_multiple = zeros(size(infected_cases_multiple));

    for i = 1 : n_runs
        SEIR_parameters = generate_single_simulation_parameters(SEIR_metaparameters);
        [~ ,compartments] = SEIR(tspan, SEIR_parameters, SEIR_metaparameters, equation_type);
        [infected_cases_multiple(i, :) , severe_cases_multiple(i, :), death_cases_multiple(i, :)] = severe_critical_dead(compartments, json_name);
    end

    quantile_ranges = [0.5 - SEIR_metaparameters.CI_interval/2, 0.5, 0.5 + SEIR_metaparameters.CI_interval/2];
    quantile_infections = quantile(infected_cases_multiple, quantile_ranges);
    quantile_severe_cases = quantile(severe_cases_multiple, quantile_ranges);
    quantile_deaths = quantile(death_cases_multiple, quantile_ranges);


end