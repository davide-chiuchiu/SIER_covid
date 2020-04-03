% hyperparameters
n_curves = 500;

% parameters to make simulations [from Corona tracker]
beta = 2.2;
sigma = 1 / 5.2;
gamma = 1 / 2.3;

% estimates for Okinawa
okinawa_population = 1468301;
initial_infected = 9;

initial_infected_estimates = initial_infected -1 + randi(10, 1, n_curves);
beta_estimates = abs(beta + randn(1, n_curves));
sigma_estimates = abs(sigma + randn(1, n_curves));
gamma_estimates = abs(gamma + randn(1, n_curves));

tspan = 0 : 200;
infected_curves = zeros(n_curves, length(tspan));

for i = 1 : n_curves
    parameters = struct('beta', beta_estimates(i), 'sigma', sigma_estimates(i), 'gamma', gamma_estimates(i),'okinawa_population', okinawa_population, 'initial_infected', initial_infected_estimates(i));
    [t,compartments] = SEIR(tspan, parameters);
    
    infected_curves(i, :) = compartments(:, 3);
    
end

quantiles = quantile(infected_curves, [0.1, 0.5, 0.9]);

figure(1)
area(t, [quantiles(1, :)' quantiles(3, :)']);
hold on
plot(t, quantiles(2, :));
hold off

ylabel('Infected')
xlabel('Time [days]')

