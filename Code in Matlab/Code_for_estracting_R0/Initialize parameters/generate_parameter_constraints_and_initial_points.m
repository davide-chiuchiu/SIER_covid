function [lower_bounds, upper_bounds, initial_points] = generate_parameter_constraints_and_initial_points(SEIR_metaparameters)
    % initialize lower bounds for parameters
    R0_lower_bound                         = 1;
    time_of_suppression_lower_bound        = 1;
    R0_suppression_lower_bound             = 0;
    estimated_initial_infected_lower_bound = 1;
    estimated_initial_exposed_lower_bound  = 0;
    lower_bounds = [R0_lower_bound, time_of_suppression_lower_bound, ...
                    R0_suppression_lower_bound, estimated_initial_infected_lower_bound, ...
                    estimated_initial_exposed_lower_bound];
    
    % initialize upper bounds for parameters
    R0_upper_bound                         = 5;
    time_of_suppression_upper_bound        = length(SEIR_metaparameters.tspan);
    R0_suppression_upper_bound             = 1;
    estimated_initial_infected_upper_bound = 100;
    estimated_initial_exposed_upper_bound  = 100;
    upper_bounds = [R0_upper_bound, time_of_suppression_upper_bound, ...
                    R0_suppression_upper_bound, estimated_initial_infected_upper_bound, ...
                    estimated_initial_exposed_upper_bound];    
                
    % initialize grid of initial points between lower and upper bounds
    grid_initial_conditions = ndspace(lower_bounds, upper_bounds, SEIR_metaparameters.single_variable_grid_size);
    
    % initialize initial points by random generation within the bounds
    random_initial_conditions = repmat(lower_bounds, SEIR_metaparameters.random_points, 1) + rand(SEIR_metaparameters.random_points, length(upper_bounds)) .* (repmat(upper_bounds, SEIR_metaparameters.random_points, 1) - repmat(lower_bounds, SEIR_metaparameters.random_points, 1));

    % initialize vector of initial conditions
    initial_points = CustomStartPointSet([grid_initial_conditions; random_initial_conditions]);

    
end

