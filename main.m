ì% hyperparameters
n_curves = 3000;

% parameters to make simulations [from Corona tracker]
central_incubation_period = 1.644;
std_incubation_period = (1.798 - 1.495)/2;
average_serial_interval = 7.2;

% estimates for Okinawa
okinawa_population = 1468301;
initial_infected = 9;

[t_no_cont, quantiles_infected_no_cont] = Initialize_SEIR('crude_estimates', n_curves, central_incubation_period, std_incubation_period, average_serial_interval, okinawa_population, initial_infected);
[t_cont, quantiles_infected_cont] = Initialize_SEIR('suppressed_crude_estimates', n_curves, central_incubation_period, std_incubation_period, average_serial_interval, okinawa_population, initial_infected);

quantiles_severe_cases_no_cont = 0.15 * quantiles_infected_no_cont;
quantiles_severe_cases_cont = 0.15 * quantiles_infected_cont;
quantiles_critical_cases_no_cont = 0.05 * quantiles_infected_no_cont;
quantiles_critical_cases_cont = 0.05 * quantiles_infected_cont;

figure(1)
subplot(2,3,1)
plot_stuff(t_no_cont, quantiles_infected_no_cont, 'Infected no containment')
subplot(2,3,2)
plot_stuff(t_no_cont, quantiles_severe_cases_no_cont, 'Severe no containment')
subplot(2,3,3)
plot_stuff(t_no_cont, quantiles_critical_cases_no_cont, 'critical no containment')

subplot(2,3,4)
plot_stuff(t_cont, quantiles_infected_cont, 'Infected containment')
subplot(2,3,5)
plot_stuff(t_cont, quantiles_severe_cases_cont, 'Severe containment')
subplot(2,3,6)
plot_stuff(t_cont, quantiles_critical_cases_cont, 'Critical containment')


% 9 infected at Friday 3rd of April
% 18 infected at Monday 6th of April