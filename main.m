% json filename with age distribution for japan
json_name = 'covid.params.json';

% hyperparameters
n_curves = 5000;

% parameters to make simulations [from Corona tracker]
central_incubation_period = 1.644;
std_incubation_period = (1.798 - 1.495)/2;
average_serial_interval = 7.2;

% estimates for Okinawa
okinawa_population = 1468301;
initial_confirmed_infected = 9;

time = datetime(2020,04,03,0,0,0) : datetime(2020,08,30,0,0,0);
tspan = 1 : length(time);

% collecting parameters into struct
SEIR_metaparameters = struct('tspan', tspan, 'n_curves', n_curves, ...
                             'central_incubation_period', central_incubation_period, ...
                             'std_incubation_period', std_incubation_period, ...
                             'average_serial_interval', average_serial_interval, ...
                             'okinawa_population', okinawa_population, ...
                             'initial_confirmed_infected', initial_confirmed_infected, ...
                             'json_name', json_name);

[t_no_cont, quantiles_infected_no_cont] = Initialize_SEIR('crude_estimates', SEIR_metaparameters);
[t_cont, quantiles_infected_cont] = Initialize_SEIR('suppressed_crude_estimates', SEIR_metaparameters);

[severe_cases_no_cont, critical_cases_no_cont, death_cases_no_cont] = severe_critical_dead_quantiles(quantiles_infected_no_cont, json_name);
[severe_cases_cont, critical_cases_cont, death_cases_cont] = severe_critical_dead_quantiles(quantiles_infected_cont, json_name);

figure(1)
subplot(1,2,1)
plot_stuff(time, quantiles_infected_no_cont, 'Infected no containment')
subplot(1,2,2)
plot_stuff(time, quantiles_infected_cont, 'Infected containment')

figure(2)
subplot(1,2,1)
plot_stuff(time, severe_cases_no_cont, 'Severe cases no containment')
subplot(1,2,2)
plot_stuff(time, severe_cases_cont, 'Severe cases containment')

figure(3)
subplot(1,2,1)
plot_stuff(time, critical_cases_no_cont, 'Critical cases no containment')
subplot(1,2,2)
plot_stuff(time, critical_cases_cont, 'Critical cases containment')

total_deaths_no_cont = compute_total_deaths(death_cases_no_cont, 'without containment');
total_deaths_cont = compute_total_deaths(death_cases_cont, 'with containment');


% 9 infected at Friday 3rd of April
% 18 infected at Monday 6th of April
% 34 infected at Tuesday 7th of April
% 39 infected at Wednesday 8th of Aprildisp([' best case scenario: ' num2str(total_deaths_no_containments(1))])
