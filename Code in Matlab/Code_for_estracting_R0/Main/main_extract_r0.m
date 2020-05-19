% import Okinawa measures
okinawa_data = import_okinawa_data();
% cut data before the 2nd of april (remove 24 rows)
okinawa_data = okinawa_data(24 : end, :);
initial_confirmed_infected = NaN; 


% SEIR parameters from Ferretti
SEIR_metaparameters = initialize_SEIR_metaparameters(initial_confirmed_infected);

% define simulation time and total confirmed cases based on imported data
time = okinawa_data.date;% - round(mean(SEIR_metaparameters.incubation_time_distribution));
tspan = 1 : length(time);
SEIR_metaparameters.tspan = tspan;
moving_window = 4;
SEIR_metaparameters.cumulative_confirmed_cases = movmean(okinawa_data.testedPositive, moving_window);

% override of 


% initialize one SEIR simulation batch and compute the mean square
% deviation from the observed values.
R0_value = 2;
time_of_suppression = 1; % note, that you have to add the incubation time to get the real time
R0_suppression = 0.95;
estimated_initial_infected = 1;
estimated_initial_exposed = 1;
mean_detection_percentage = 0.1;
R0_variables = [R0_value, time_of_suppression, R0_suppression, estimated_initial_infected, estimated_initial_exposed, mean_detection_percentage];

lower_bound = [1.5, 1, 0, 1, 0, 0.07];
upper_bound = [5, length(time), 1, 500, 500, 0.2];
grid_initial_conditions = ndspace(lower_bound, upper_bound, 3);
random_points = 1000;
random_initial_conditions = repmat(lower_bound, random_points, 1) + rand(random_points, 6) .* (repmat(upper_bound, random_points, 1) - repmat(lower_bound, random_points, 1));
initial_conditions = [grid_initial_conditions; random_initial_conditions];

Aineq = [0 0 0 -20 +1, 0];
bineq = 0;

tic
% optimization
problem = createOptimProblem('fmincon', 'x0',R0_variables, 'objective', @(y) compute_deviations_from_real_cases(y, SEIR_metaparameters), 'lb', lower_bound, 'ub', upper_bound, 'Aineq', Aineq, 'bineq', bineq);
initial_points = CustomStartPointSet(initial_conditions);
R0_variables = run(MultiStart, problem, initial_points);
toc

[t_optimal, cumulative_detected_cases_optimal] = wrapper_to_compute_SEIR(R0_variables, SEIR_metaparameters);
optimal_deviation = compute_deviations_from_real_cases(R0_variables, SEIR_metaparameters);

% plot of results
figure(15)
plot(time, SEIR_metaparameters.cumulative_confirmed_cases, 'r', 'DisplayName', 'Okinawa data')
hold all
plot(time, cumulative_detected_cases_optimal, 'DisplayName', 'predictions')
hold off
legend('show')

save('optimization_results.mat')