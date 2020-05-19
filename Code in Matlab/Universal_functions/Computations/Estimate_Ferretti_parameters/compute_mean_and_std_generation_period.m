function [t_mean_mean, t_mean_std] = compute_mean_and_std_generation_period(shape_min, shape_max, scale_min, scale_max, to_plot)
    n_estimations = 500000;
    shape = shape_min + (shape_max - shape_min) * rand(1, n_estimations);
    scale = scale_min + (scale_max - scale_min) * rand(1, n_estimations);

    t_mean = wblstat(scale, shape);
    t_mean_mean = mean(t_mean);
    t_mean_std = std(t_mean); 


    if to_plot == 1
        figure(51)
        histogram(t_mean)
        hold all
        histogram(t_mean_mean + 4 * (rand(1, n_estimations) - 0.5) * t_mean_std);
        hold off
    end