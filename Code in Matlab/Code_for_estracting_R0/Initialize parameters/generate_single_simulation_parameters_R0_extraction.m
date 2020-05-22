function SEIR_parameters = generate_single_simulation_parameters_R0_extraction(R0_variables, SEIR_metaparameters)

    R0 = R0_variables(1);
    incubation_time = 3; %mean(SEIR_metaparameters.incubation_time_distribution);
    infectious_time = 5; %mean(SEIR_metaparameters.generation_time_distribution);
                      % also known as generation time;
    time_of_suppression = R0_variables(2);
    R0_supp_containment = R0_variables(3);
    
    SEIR_parameters = struct('R0', R0, 'incubation_time', incubation_time, ...
                             'infectious_time', infectious_time, ...
                             'time_of_suppression', time_of_suppression, ...
                             'R0_supp_containment',    R0_supp_containment);
    
end