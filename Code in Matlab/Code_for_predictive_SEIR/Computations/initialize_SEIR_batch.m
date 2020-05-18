function [quantile_infections, quantile_severe_cases, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time] = initialize_SEIR_batch(n_runs, time, tspan, json_name, SEIR_metaparameters, equation_type, with_seasonality)
    infected_cases_multiple = zeros(n_runs, length(time));
    severe_cases_multiple = zeros(size(infected_cases_multiple));
    death_cases_multiple = zeros(size(infected_cases_multiple));

    for i = 1 : n_runs
        SEIR_parameters = generate_single_simulation_parameters_SEIR_predictions(SEIR_metaparameters);
        [~ ,compartments] = SEIR(tspan, SEIR_parameters, SEIR_metaparameters, equation_type, with_seasonality);
        [infected_cases_multiple(i, :) , severe_cases_multiple(i, :), death_cases_multiple(i, :)] = severe_critical_dead(compartments, json_name);
    end
    
    size(infected_cases_multiple)
    [peak_infected, peak_infected_position] = max(infected_cases_multiple, [], 2);
    [peak_severe, peak_severe_position] = max(severe_cases_multiple, [], 2);
    
    quantile_ranges = [0.5 - SEIR_metaparameters.CI_interval/2, 0.5, 0.5 + SEIR_metaparameters.CI_interval/2];
    quantile_infections = quantile(infected_cases_multiple, quantile_ranges);
    quantile_severe_cases = quantile(severe_cases_multiple, quantile_ranges);
    quantile_deaths = quantile(death_cases_multiple, quantile_ranges);
    
    figure(33)
    subplot(1,2,1)
    histogram(peak_infected)
    subplot(1,2,2)
    histogram(peak_severe_position)
    
    [peak_infected_scenarios, peak_infected_scenarios_time] = summarize_peak_information(peak_infected, peak_infected_position, time, n_runs, 33, equation_type);
    [peak_severe_scenarios, peak_severe_scenarios_time] = summarize_peak_information(peak_severe, peak_severe_position, time, n_runs, 34, equation_type);
    

    

end

function [peak_scenarios, peak_scenarios_time] = summarize_peak_information(peak, peak_position, time, n_runs, fignum, equation_type)
    figure(fignum)
    subplot(1,2,1)
    histogram(peak)
    hold all
    subplot(1,2,2)
    histogram(peak_position)
    hold all

    if strcmp(equation_type, 'no_containment')
        mean_peak = round(mean(peak));
        std_peak = round(std(peak));
        mean_peak_position = round(mean(peak_position));
        std_peak_position = round(std(peak_position));

        peak_scenarios = [mean_peak - std_peak, mean_peak, mean_peak + std_peak];
        peak_scenarios_time = time([mean_peak_position - std_peak_position, mean_peak_position, mean_peak_position + std_peak_position]);
        
        subplot(1,2,1)
        histogram(mean_peak + std_peak * randn(1, n_runs))
        hold off
        subplot(1,2,2)
        histogram(mean_peak_position + std_peak_position * randn(1, n_runs))
        hold off
        
    elseif strcmp(equation_type, 'Flakman_containment')
        mean_peak = round(quantile(peak, 0.5));
        CI_peak = round(quantile(peak, [0.1, 0.9]));
        mean_peak_position = round(quantile(peak_position, 0.5));
        CI_peak_position = round(quantile(peak_position, [0.1, 0.9]));
        
        peak_scenarios = [CI_peak(1), mean_peak, CI_peak(2)];
        peak_scenarios_time = time([CI_peak_position(1), mean_peak_position, CI_peak_position(2)]);
        
        subplot(1,2,1)
        plot(mean_peak * [1, 1], [0, 5000])
        plot(CI_peak(1) * [1, 1], [0, 5000])
        plot(CI_peak(2) * [1, 1], [0, 5000])
        hold off
        subplot(1,2,2)
        plot(mean_peak_position * [1, 1], [0, 5000])
        plot(CI_peak_position(1) * [1, 1], [0, 5000])
        plot(CI_peak_position(2) * [1, 1], [0, 5000])
        hold off
    end
end