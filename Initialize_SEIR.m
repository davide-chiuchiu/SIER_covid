function Initialize_SEIR(equation_type)
    % hyperparameters
    n_curves = 10000;

    % parameters to make simulations [from Corona tracker]
    central_incubation_period = 1.644;
    std_incubation_period = (1.798 - 1.495)/2;
    average_serial_interval = 7.2;

    % estimates for Okinawa
    okinawa_population = 1468301;
    initial_infected = 9;
    initial_infected_estimates = initial_infected -1 + randi(10, 1, n_curves);

    % estimates parameters from Ferretti et al (equation independent)
    incubation_time_estimates = lognrnd(central_incubation_period, std_incubation_period, 1, n_curves) ;
    sigma_estimates = 1 ./ incubation_time_estimates;
    gamma_estimates = 1 ./ (average_serial_interval - incubation_time_estimates);

    % estimates parameters from Ferretti et al (equation dependent)
    all_parameters = generate_all_param(initial_infected_estimates, gamma_estimates, sigma_estimates, n_curves, okinawa_population, equation_type);

    % empty vectors for simulation
    tspan = 0 : 200;
    effective_n_curves = length(all_parameters.sigma_estimates);
    presymptomatic_curves = zeros(effective_n_curves, length(tspan));
    infected_curves = zeros(effective_n_curves, length(tspan));
    
    
    tic
    for i = 1 : effective_n_curves
        parameters_single_simulation = generate_parameters_single_simulation(all_parameters, i, equation_type);
        [t,compartments] = SEIR(tspan, parameters_single_simulation, equation_type);
        presymptomatic_curves(i, :) = compartments(:, 2);
        infected_curves(i, :) = compartments(:, 3);

    end
    toc

    quantiles_infected = quantile(infected_curves, [0.1, 0.5, 0.9]);
    quantiles_presymptomatic = quantile(presymptomatic_curves, [0.1, 0.5, 0.9]);
    
    figure(1)
    area(t, quantiles_infected(3, :)', 'LineStyle','none', 'DisplayName', '90% CI');
    hold on
    h = area(t, quantiles_infected(1, :)', 'LineStyle','none', 'DisplayName', 'none');
    h(1).FaceColor = [1 1 1];
    plot(t, quantiles_infected(2, :), 'DisplayName', 'median behavior');
    hold off
    
    figure(2)
    area(t, quantiles_presymptomatic(3, :)', 'LineStyle','none', 'DisplayName', '90% CI');
    hold on
    h = area(t, quantiles_presymptomatic(1, :)', 'LineStyle','none', 'DisplayName', 'none');
    h(1).FaceColor = [1 1 1];
    plot(t, quantiles_presymptomatic(2, :), 'DisplayName', 'median behavior');
    hold off



    ylabel('Infected')
    xlabel('Time [days]')
    legend('show')

end