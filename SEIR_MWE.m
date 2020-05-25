function SEIR_MWE()
    tspan = 1:365;
    
   parameters = struct('Okinawa_population', 1433566, ...
              'infectious_time', 3, ...
              'incubation_time', 5); 
                   
    [true_variables, random_variables, upper_bounds, lower_bounds] = generate_initial_point();
    true_cumulative_infected = wrapper_to_initialize_SEIR(true_variables, parameters, tspan);
    true_cumulative_infected = add_noise(true_cumulative_infected);
    
    add_noise(true_cumulative_infected);
    
    Aineq = [0, 0, 0, 1, -1];
    bineq = 0;
    
    optimization_problem = createOptimProblem('fmincon', 'objective', @(variables) compute_deviations(true_cumulative_infected, variables, parameters, tspan), ...
                                              'x0', random_variables, 'lb', lower_bounds, 'ub', upper_bounds, 'Aineq', Aineq, 'bineq', bineq);
    tic
    if isempty(gcp('nocreate')) == 1 
        parpool;
    end
    optimized_variables = run(MultiStart('UseParallel', true), optimization_problem, 200);
    toc
    optimized_cumulative_infected = wrapper_to_initialize_SEIR(optimized_variables, parameters, tspan);
    
    disp(true_variables)
    disp(optimized_variables)
    
    figure(15)
    plot(tspan, true_cumulative_infected / parameters.Okinawa_population)
    hold all
    plot(tspan, optimized_cumulative_infected / parameters.Okinawa_population, 'r')
    hold off
    
end

function dSEIR = SEIR_equations(t, compartments, variables, parameters)
    R0 = variables(1);
    N  = parameters.Okinawa_population;
    Di = parameters.infectious_time;
    De = parameters.incubation_time;
    
    S = compartments(1);
    E = compartments(2);
    I = compartments(3);
    
    infectious_strength = R0 / (N * Di) .* compute_R0_suppression(t, variables);
    
    dSEIR = zeros(size(compartments));
    dSEIR(1) = - S * I * infectious_strength;
    dSEIR(2) =   S * I * infectious_strength - E / De;
    dSEIR(3) =   E / De - I / Di;
    dSEIR(4) =   E / De;
end

function R0_suppression_factor = compute_R0_suppression(t, variables)
    R0_suppression = variables(2);
    suppression_time = variables(3);
    R0_suppression_factor = 1  - (1 - R0_suppression) .* heaviside(t - suppression_time);
end

function cumulative_infected = wrapper_to_initialize_SEIR(variables, parameters, tspan)
    initial_infected = variables(4);
    initial_exposed = variables(5);
    initial_susceptible = parameters.Okinawa_population - initial_infected - initial_exposed;    
    initial_point = [initial_susceptible, initial_exposed, initial_infected, initial_infected];
    [~, compartments] = ode45(@(t, compartments) SEIR_equations(t, compartments, variables, parameters), tspan, initial_point);
    
    cumulative_infected = compartments(:, 4);
end

function [true_variables, random_variables, upper_bounds, lower_bounds] = generate_initial_point()
    R0_value = 2.7;
    R0_suppression = 0.65;
    suppression_time = 20;
    initial_infected = 130;
    initial_exposed = 290;
    true_variables = [R0_value, R0_suppression, suppression_time, initial_infected, initial_exposed];
    
    random_R0_value = 2.1;
    random_R0_suppression = 0.3;
    random_suppression_time = 60;
    random_initial_infected = 50;
    random_initial_exposed = 99;
    random_variables = [random_R0_value, random_R0_suppression, random_suppression_time, random_initial_infected, random_initial_exposed];
    
    R0_value_upper_bound = 10;
    R0_suppression_upper_bound = 1;
    suppression_time_upper_bound = 365;
    initial_infected_upper_bound = 1000;
    initial_exposed_upper_bound = 1000;    
    upper_bounds = [R0_value_upper_bound, R0_suppression_upper_bound, suppression_time_upper_bound, initial_infected_upper_bound, initial_exposed_upper_bound];
    
    R0_value_lower_bound = 1;
    R0_suppression_lower_bound = 0;
    suppression_time_lower_bound = 0;
    initial_infected_lower_bound = 1;
    initial_exposed_lower_bound = 1;    
    lower_bounds = [R0_value_lower_bound, R0_suppression_lower_bound, suppression_time_lower_bound, initial_infected_lower_bound, initial_exposed_lower_bound];
    
end

function mean_square_deviation = compute_deviations(true_cumulative_infected, random_variables, parameters, tspan)
    random_cumulative_infected = wrapper_to_initialize_SEIR(random_variables, parameters, tspan);
    
    log_normalized_true_cumulative = log(true_cumulative_infected/true_cumulative_infected(1));
    log_normalized_random_cumulative = log(random_cumulative_infected/random_cumulative_infected(1));
    
    mean_square_deviation = sqrt(mean((log_normalized_random_cumulative - log_normalized_true_cumulative).^2));
end

function noised_cumulative_infected = add_noise(true_cumulative_infected)
    starting_value = true_cumulative_infected(1);
    infected = diff(true_cumulative_infected);
    noised_infected = infected + randn(size(infected)) * 0.25 .* infected ; 
    
    noised_cumulative_infected = starting_value + [0; cumsum(noised_infected)];    
end