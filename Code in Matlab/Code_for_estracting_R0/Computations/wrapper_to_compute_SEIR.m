function [t, cumulative_detected_cases] = wrapper_to_compute_SEIR(R0_variables, SEIR_metaparameters)
    SEIR_metaparameters.estimated_initial_infected = R0_variables(4);
    SEIR_metaparameters.estimated_initial_exposed = R0_variables(5);
    SEIR_metaparameters.mean_detection_percentage = R0_variables(6);
    SEIR_parameters = generate_single_simulation_parameters_R0_extraction(R0_variables, SEIR_metaparameters);
    [t, compartments] = SEIR(SEIR_parameters, SEIR_metaparameters, 'R0_step_change', 'without_seasonality');
    infected = compartments(:, 3);
    
    % compute detected cases
    cumulative_cases = cumsum(infected);
    cumulative_detected_cases = SEIR_metaparameters.mean_detection_percentage * cumulative_cases;
    
end