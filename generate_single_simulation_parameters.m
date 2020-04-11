function SEIR_parameters = generate_single_simulation_parameters(SEIR_metaparameters)
    % ditribution shapes are confirmed by inspection from the original
    % distributions
    R0 = SEIR_metaparameters.R0_min + rand(1) * (SEIR_metaparameters.R0_max - SEIR_metaparameters.R0_min) ;
    incubation_time = SEIR_metaparameters.incubation_time_mean + randn(1) * SEIR_metaparameters.incubation_time_std;
    infectious_time = SEIR_metaparameters.generation_time_mean + 4 * (rand(1) - 0.5) * SEIR_metaparameters.generation_time_std;
                      % also known as generation time;
    
    SEIR_parameters = struct('R0', R0, 'incubation_time', incubation_time, ...
                             'infectious_time', infectious_time);
    
end