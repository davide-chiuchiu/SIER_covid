function [optimized_variables, optimized_detected_infected, Okinawa_data] = SEIR_MWE(num_initial_points)


    % import data from Okinawa
    case_treshold = 7;
    Okinawa_file = "Data/Okinawa_infection_data/Okinawa_cases_tests.csv";
    Okinawa_data = readtable(Okinawa_file);
    time = Okinawa_data.date(Okinawa_data.testedPositive > case_treshold);
    tspan = 1 : length(time);
    
    % Initialize fixed parameters for simulation
    parameters = struct('Okinawa_population', 1433566, ...
              'incubation_time', 3, ...
              'infectious_time', 5, ...
              'detection_percentage', 0.1, ...
              'tspan', tspan, ...
              'true_detected_infected', Okinawa_data.testedPositive(Okinawa_data.testedPositive > case_treshold)); 
            
    % Initialize upper and lower bounds and initial points for the
    % simulation
    [upper_bounds, lower_bounds, initial_points] = generate_bounds_and_initial_point(num_initial_points);
    
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
    optimized_variables = run(MultiStart('UseParallel', true), optimization_problem, initial_points);
    toc
    optimized_detected_infected = parameters.detection_percentage * compute_cumulative_infected(optimized_variables, parameters);
    
    % visual_inspection
    disp(optimized_variables)
    figure(15)
    plot(time, parameters.true_detected_infected / parameters.Okinawa_population)
    hold all
    plot(time, optimized_detected_infected / parameters.Okinawa_population, 'r')
    hold off    
end

function noised_cumulative_infected = add_noise(true_cumulative_infected)
    starting_value = true_cumulative_infected(1);
    infected = diff(true_cumulative_infected);
    noised_infected = infected + randn(size(infected)) * 0.25 .* infected ; 
    
    noised_cumulative_infected = starting_value + [0; cumsum(noised_infected)];    
end