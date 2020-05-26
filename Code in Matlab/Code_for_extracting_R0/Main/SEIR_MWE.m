function [R0_value, R0_suppression, start_time, suppression_time, min_deviation] = SEIR_MWE(num_initial_points, file_to_load, total_population)


    % import data from Okinawa
    loaded_data = readtable(file_to_load);
    
    % define treshold to cut data
    case_treshold_percentage = 0.05;
    case_treshold = case_treshold_percentage * loaded_data.cases(end);
    
    if loaded_data.cases(end) == 0
        R0_value = 0;
        R0_suppression = NaN;
        start_time = NaT;
        suppression_time = NaT;
        min_deviation = NaN;
        return
    end
    
    time = loaded_data.time(loaded_data.cases > case_treshold);
    tspan = 1 : length(time);
    
 
 
    
    % Initialize fixed parameters for simulation
    parameters = struct('total_population', total_population, ...
              'incubation_time', 3.5868, ...
              'infectious_time', 7.2042, ...
              'detection_percentage', 0.2045, ...
              'tspan', tspan, ...
              'true_detected_infected', loaded_data.cases(loaded_data.cases > case_treshold)); 
            
    % Initialize upper and lower bounds and initial points for the
    % simulation
    [upper_bounds, lower_bounds, initial_points] = generate_bounds_and_initial_point(num_initial_points, parameters);
    
    % Initialize linear constraint on problem variables
    Aineq = [0, 0, 0, 1, -1];
    bineq = 0;
    
    % start parpool jobs if not already initialized 
    if isempty(gcp('nocreate')) == 1 
        parpool;
    end
    
    % initialize optimization problem
    optimization_problem = createOptimProblem('fmincon', 'objective', @(variables) compute_mean_square_deviation(variables, parameters), ...
                                              'x0', upper_bounds, 'lb', lower_bounds, 'ub', upper_bounds, 'Aineq', Aineq, 'bineq', bineq);

    % run optimization
    tic
    [optimized_variables, min_deviation] = run(MultiStart('UseParallel', true), optimization_problem, initial_points);
    toc
    optimized_detected_infected = parameters.detection_percentage * compute_cumulative_infected(optimized_variables, parameters);
    
    % visual_inspection
    figure(15)
    plot(time, parameters.true_detected_infected)
    hold all
    plot(time, optimized_detected_infected, 'r')
    hold off
    pause(3)
    
    R0_value = optimized_variables(1);
    R0_suppression = optimized_variables(2);
    start_time = time(1);
    suppression_time = time(round(optimized_variables(3)));
        
end

function noised_cumulative_infected = add_noise(true_cumulative_infected)
    starting_value = true_cumulative_infected(1);
    infected = diff(true_cumulative_infected);
    noised_infected = infected + randn(size(infected)) * 0.25 .* infected ; 
    
    noised_cumulative_infected = starting_value + [0; cumsum(noised_infected)];    
end