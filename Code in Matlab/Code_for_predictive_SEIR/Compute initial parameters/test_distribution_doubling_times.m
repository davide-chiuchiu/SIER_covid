function R0_distribution_override = test_distribution_doubling_times(SEIR_metaparameters)
    n_points = 20000;
    R0 = random(SEIR_metaparameters.R0_distribution, 1, n_points) ;
    incubation_time = random(SEIR_metaparameters.incubation_time_distribution, 1, n_points);
    infectious_time = random(SEIR_metaparameters.generation_time_distribution, 1, n_points);
    doubling_time = random(SEIR_metaparameters.doubling_time_distribution, 1, n_points);
    
    doub_time = estimate_doubling_time(R0, infectious_time, incubation_time);
    doub_time_simone = estimate_doubling_time(2.2, 3, 3);
    R0_from_doubling_time = compute_R0_from_doubling_tim(doubling_time, infectious_time, incubation_time);
    R0_from_doubling_time_mean = mean(R0_from_doubling_time);
    R0_from_doubling_time_std = std(R0_from_doubling_time);
    R0_distribution_override = makedist('Normal', 'mu', R0_from_doubling_time_mean, 'sigma', R0_from_doubling_time_std);
    
    figure(121)
    histogram(doub_time, 'DisplayName', 'Estimated from Ferretti R_0')
    hold all
    plot([1 1] * doub_time_simone, [0 n_points/3], 'DisplayName', 'Simone')
    plot([1 1] * 5, [0 n_points/3], 'DisplayName', 'Okinawa')
    hold off
    xlabel('doubling time')
    ylabel('counts')
    legend('show')
    
    figure(122)
    histogram(R0, 'DisplayName', 'From Ferretti')
    hold all
    histogram(R0_from_doubling_time, 'DisplayName', 'Estimated from Doubling time')
    histogram(R0_from_doubling_time_mean + R0_from_doubling_time_std * randn(1, n_points), 'DisplayName', 'Gaussian approximation from Doubling time')
    hold off
    xlabel('R_0 estimates')
    ylabel('counts')
    legend('show')
    
    
end

function doub_time = estimate_doubling_time(R0, infectious_time, incubation_time)
    beta = R0 ./ infectious_time;
    sigma = 1 ./ incubation_time;
    gamma = 1 ./ infectious_time;
    exponential_rate = (-(sigma + gamma) + sqrt((sigma - gamma).^2 + 4 * sigma .* beta))/2;
    doub_time = log(2) ./ exponential_rate;
end