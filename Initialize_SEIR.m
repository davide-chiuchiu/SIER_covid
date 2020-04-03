function Initialize_SEIR(equation_type)

    % hyperparameters
    n_curves = 1000;

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
    incubation_time_estimates = lognrnd(central_incubation_period, std_incubation_period, 1, n_curves);
    sigma_estimates = 1 ./ incubation_time_estimates;
    gamma_estimates = 1 ./ (average_serial_interval - incubation_time_estimates);

    % model dependent parameter_choices
    meta_parameters = compute_meta_patameter_estimates(n_curves, gamma_estimates, sigma_estimates, equation_type);
    

    

    effective_n_curves = length(meta_parameters.sigma_estimates);
    tspan = 0 : 200;
    infected_curves = zeros(effective_n_curves, length(tspan));

    tic
    for i = 1 : effective_n_curves
        parameters = struct('beta', meta_parameters.beta_estimates(i), 'sigma', meta_parameters.sigma_estimates(i), 'gamma', meta_parameters.gamma_estimates(i),'okinawa_population', okinawa_population, 'initial_infected', initial_infected_estimates(i));
        [t,compartments] = SEIR(tspan, parameters, equation_type);

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

end