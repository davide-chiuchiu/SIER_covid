% this function generates the upper and lower bounds for the variables of
% the optimization (R0, R0 suppression, suppression time, initial infected
% and initial exposed), and then it generates an initial population of
% values for the optimization variables. Such inital potins are ~num_points
% half of wich are randomly generated, and half of which are taken unifomly
% spaced between the lower and upper bounds of the variables

function [upper_bounds, lower_bounds, initial_points] = generate_bounds_and_initial_point(num_points, parameters)    
    R0_value_upper_bound = 7;
    R0_suppression_upper_bound = 1;
    suppression_time_upper_bound = parameters.tspan(end);
    initial_infected_upper_bound = 1000;
    initial_exposed_upper_bound = 1000;    
    upper_bounds = [R0_value_upper_bound, R0_suppression_upper_bound, suppression_time_upper_bound, initial_infected_upper_bound, initial_exposed_upper_bound];
    
    R0_value_lower_bound = 1;
    R0_suppression_lower_bound = 0;
    suppression_time_lower_bound = 0;
    initial_infected_lower_bound = 1;
    initial_exposed_lower_bound = 1;    
    lower_bounds = [R0_value_lower_bound, R0_suppression_lower_bound, suppression_time_lower_bound, initial_infected_lower_bound, initial_exposed_lower_bound];
    
    half_points = round(num_points/2);
    initial_points_rand = repmat(lower_bounds, half_points, 1) + rand(half_points, length(lower_bounds)) .* repmat(upper_bounds - lower_bounds, half_points, 1); 
    
    grid_points_number = round(nthroot(half_points, length(upper_bounds)));
    initial_points_grid = ndspace(lower_bounds, upper_bounds, grid_points_number);
    initial_points_mixed = [initial_points_rand; initial_points_grid];
    
    initial_points = CustomStartPointSet(initial_points_mixed);
end