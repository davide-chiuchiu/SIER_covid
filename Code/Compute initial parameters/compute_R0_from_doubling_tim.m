function R0 = compute_R0_from_doubling_tim(doubling_time, infectious_time, incubation_time)
    sigma = 1 ./ incubation_time;
    gamma = 1./ infectious_time;
    lambda = log(2) ./ doubling_time;
    R0 = (lambda + sigma) .* (lambda + gamma) ./ (sigma .* gamma);
end
