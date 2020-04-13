n_runs = 10000;

% json filename with age distribution for japan
json_name = 'covid.params_oka_.json';

% parameters to make simulations [from Ferretti]
mu_min = 1.495;
mu_max = 1.798;
sigma_min = 0.201;
sigma_max = 0.521;
[incubation_time_mean, incubation_time_std] = compute_mean_and_std_incubation_period(mu_min, mu_max, sigma_min, sigma_max, 1);

shape_min = 1.75;
shape_max = 4.7;
scale_min = 4.7;
scale_max = 6.9;
[generation_time_mean, generation_time_std] = compute_mean_and_std_generation_period(shape_min, shape_max, scale_min, scale_max, 1);

R0_min = 1.7;
R0_max= 2.5;

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

time = datetime(2020,04,03,0,0,0) : datetime(2020,12,31,0,0,0);
tspan = 1 : length(time);

% collecting parameters into struct
SEIR_metaparameters = struct('tspan', tspan, ...
                             'R0_min', R0_min, ...
                             'R0_max', R0_max, ...
                             'incubation_time_mean', incubation_time_mean, ...
                             'incubation_time_std', incubation_time_std, ...
                             'generation_time_mean', generation_time_mean, ...
                             'generation_time_std', generation_time_std, ...
                             'okinawa_population', okinawa_population, ...
                             'estimated_initial_exposed', estimated_initial_exposed, ...
                             'estimated_initial_infected', estimated_initial_infected, ...
                             'inbound_from_Naha_airport', inbound_from_Naha_airport, ...
                             'outbound_from_Naha_airport', outbound_from_Naha_airport);
                         
infected_cases_multiple = zeros(n_runs, length(time));
severe_cases_multiple = zeros(size(infected_cases_multiple));
death_cases_multiple = zeros(size(infected_cases_multiple));
                         
for i = 1 : n_runs
    SEIR_parameters = generate_single_simulation_parameters(SEIR_metaparameters);
    [t,compartments] = SEIR(tspan, SEIR_parameters, SEIR_metaparameters);
    [infected_cases_multiple(i, :) , severe_cases_multiple(i, :), death_cases_multiple(i, :)] = severe_critical_dead(compartments, json_name);
end
                         
quantile_ranges = [0.05, 0.5, 0.95];
quantile_infections = quantile(infected_cases_multiple, quantile_ranges);
quantile_severe_cases = quantile(severe_cases_multiple, quantile_ranges);
quantile_deaths = quantile(death_cases_multiple, quantile_ranges);

figure(1)
plot_stuff(time, quantile_infections, 'infected people')

figure(2)
plot_stuff(time, quantile_severe_cases, 'severe cases')
hold all
plot([time(1), time(end)], [1, 1] * ICU_beds, 'DisplayName', 'ICU beds')
plot([time(1), time(end)], [1, 1] * max_ventilators, 'DisplayName','max ventilators')
hold off

figure(3)
plot_stuff(time, quantile_deaths, 'death cases')