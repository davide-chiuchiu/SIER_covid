% hyperparameters
n_curves = 10000;

% parameters to make simulations [from Corona tracker]
beta = 2.2; % spread of infection
central_incubation_period = 1.644;
std_incubation_period = (1.798 - 1.495)/2;
average_serial_interval = 7.2;

% estimates for Okinawa
okinawa_population = 1468301;
initial_infected = 9;
initial_infected_estimates = initial_infected -1 + randi(10, 1, n_curves);

% estimated parameters from Ferretti et al
R0_estimates = 1.7 + rand(1, n_curves) * (2.5 - 1.7);
incubation_time_estimates = lognrnd(central_incubation_period, std_incubation_period, 1, n_curves) ;
sigma_estimates = 1 ./ incubation_time_estimates;
gamma_estimates = 1 ./ (average_serial_interval - incubation_time_estimates);
beta_estimates = R0_estimates .* gamma_estimates;

selector = (sigma_estimates > 0) & (gamma_estimates > 0) & (beta_estimates > 0);
sigma_estimates = sigma_estimates(selector);
gamma_estimates = gamma_estimates(selector);
beta_estimates = beta_estimates(selector);

effective_n_curves = length(sigma_estimates);

tspan = 0 : 200;
infected_curves = zeros(effective_n_curves, length(tspan));

tic
for i = 1 : effective_n_curves
    parameters = struct('beta', beta_estimates(i), 'sigma', sigma_estimates(i), 'gamma', gamma_estimates(i),'okinawa_population', okinawa_population, 'initial_infected', initial_infected_estimates(i));
    [t,compartments] = SEIR(tspan, parameters);
    
    infected_curves(i, :) = compartments(:, 3);
    
end
toc

quantiles = quantile(infected_curves, [0.1, 0.5, 0.9]);

figure(1)
area(t, quantiles(3, :)', 'LineStyle','none', 'DisplayName', '90% CI');
hold on
h = area(t, quantiles(1, :)', 'LineStyle','none', 'DisplayName', 'none');
h(1).FaceColor = [1 1 1];
plot(t, quantiles(2, :), 'DisplayName', 'median behavior');
hold off



ylabel('Infected')
xlabel('Time [days]')
legend('show')

