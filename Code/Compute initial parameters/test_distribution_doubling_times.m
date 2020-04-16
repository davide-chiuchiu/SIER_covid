function test_distribution_doubling_times(incubation_time_mean, incubation_time_std, generation_time_mean, generation_time_std, R0_distribution, doubling_time_distribution)
    n_points = 20000;
    R0 = random(R0_distribution, 1, n_points) ;
    incubation_time = incubation_time_mean + randn(1, n_points) * incubation_time_std;
    infectious_time = generation_time_mean + 4 * (rand(1, n_points) - 0.5) * generation_time_std;
    doubling_time = random(doubling_time_distribution, 1, n_points);
    
    doub_time = estimate_doubling_time(R0, infectious_time, incubation_time);
    doub_time_simone = estimate_doubling_time(2.2, 3, 3);
    R0_from_doubling_time = R0_from_doubling_tim(doubling_time, infectious_time, incubation_time);
    
    
    
    figure(121)
    histogram(doub_time)
    hold all
    plot([1 1] * doub_time_simone, [0 n_points/3], 'DisplayName', 'Simone')
    plot([1 1] * 5, [0 n_points/3], 'DisplayName', 'Okinawa')
    hold off
    legend('show')
    
    figure(122)
    histogram(R0)
    hold all
    histogram(R0_from_doubling_time)
    hold off
    
end

function doub_time = estimate_doubling_time(R0, infectious_time, incubation_time)
    beta = R0 ./ infectious_time;
    sigma = 1 ./ incubation_time;
    gamma = 1 ./ infectious_time;
    exponential_rate = (-(sigma + gamma) + sqrt((sigma - gamma).^2 + 4 * sigma .* beta))/2;
    doub_time = log(2) ./ exponential_rate;
end

function R0 = R0_from_doubling_tim(doubling_time, infectious_time, incubation_time)
    sigma = 1 ./ incubation_time;
    gamma = 1./ infectious_time;
    lambda = log(2) ./ doubling_time;
    
    R0 = (lambda + sigma) .* (lambda + gamma) ./ (sigma .* gamma);
end
