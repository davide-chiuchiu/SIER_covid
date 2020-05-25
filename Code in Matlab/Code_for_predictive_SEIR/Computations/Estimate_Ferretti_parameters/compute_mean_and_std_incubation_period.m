function [t_mean_mean, t_mean_std] = compute_mean_and_std_incubation_period(mu_min, mu_max, sigma_min, sigma_max, to_plot)
    n_estimations = 500000;
    mu = mu_min + (mu_max - mu_min) * rand(1, n_estimations);
    sigma = sigma_min + (sigma_max - sigma_min) * rand(1, n_estimations);

    t_mean = lognstat(mu, sigma);
    t_mean_mean = mean(t_mean);
    t_mean_std = std(t_mean); 


    if to_plot == 1
        figure(50)
        histogram(t_mean)
        hold all
        histogram(mean(t_mean_mean) + randn(1, n_estimations) * t_mean_std);
        hold off
    end
end

