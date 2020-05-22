% import Okinawa measures
okinawa_data = import_okinawa_data();
% cut data
okinawa_data = okinawa_data(10 : end, :);

% Initialize SEIR parameters from Ferretti without an estimate for the
% initial number of infected people
SEIR_metaparameters = initialize_SEIR_metaparameters(NaN);

% define simulation time and total confirmed cases based on imported data
time = okinawa_data.date;
tspan = 1 : length(time);
SEIR_metaparameters.tspan = tspan;

% Add a smoothened curve of the cumulative confirmed cases to SEIR
% metaparameters struct
moving_window = 4;
SEIR_metaparameters.cumulative_confirmed_cases = okinawa_data.testedPositive/okinawa_data.testedPositive(end);

% initialize parameter bounds and initial points for the optimization
SEIR_metaparameters.single_variable_grid_size = 6;
SEIR_metaparameters.random_points = 20000;
total_points = 6^SEIR_metaparameters.single_variable_grid_size + SEIR_metaparameters.random_points;
[lower_bounds, upper_bounds, initial_points] = generate_parameter_constraints_and_initial_points(SEIR_metaparameters);

% initialize linear constraints.
% First line it to have that the initial exposed are not more than 20 times
% the initial infected
Aineq = [0 0 0 -20 +1];
bineq = 0;

% perform the optimization
tic
problem = createOptimProblem('fmincon', 'x0', lower_bounds, 'objective', @(y) compute_deviations_from_real_cases(y, SEIR_metaparameters), 'lb', lower_bounds, 'ub', upper_bounds, 'Aineq', Aineq, 'bineq', bineq);
R0_variables = run(MultiStart, problem, initial_points);
toc

% compute SEIR with optimal parameters
[t_optimal, cumulative_detected_cases_optimal] = wrapper_to_compute_SEIR(R0_variables, SEIR_metaparameters);
optimal_deviation = compute_deviations_from_real_cases(R0_variables, SEIR_metaparameters);

% plot of the Okinawa data and the optimal SEIR simulation
Okinawa_state_of_emergency = datetime(2020, 04, 22);
observation_delay = mean(SEIR_metaparameters.incubation_time_distribution);

figure(15)
plot(time + observation_delay, SEIR_metaparameters.cumulative_confirmed_cases, 'r', 'DisplayName', 'Okinawa data')
hold all
plot(time + observation_delay, cumulative_detected_cases_optimal, 'DisplayName', 'predictions')
plot([Okinawa_state_of_emergency, Okinawa_state_of_emergency], [min(cumulative_detected_cases_optimal), max(cumulative_detected_cases_optimal)])
hold off
legend('show')

save('optimization_results.mat')