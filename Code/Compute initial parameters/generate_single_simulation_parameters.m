function SEIR_parameters = generate_single_simulation_parameters(SEIR_metaparameters)
    % ditribution shapes are confirmed by inspection from the original
    % distributions
    R0 = random(SEIR_metaparameters.R0_distribution, 1, 1) ;
    incubation_time = SEIR_metaparameters.incubation_time_mean + randn(1) * SEIR_metaparameters.incubation_time_std;
    infectious_time = SEIR_metaparameters.generation_time_mean + 4 * (rand(1) - 0.5) * SEIR_metaparameters.generation_time_std;
                      % also known as generation time;
    
    % suppression parameters from Flaxman et al 
    % Distribution do not reflect the real one, at the moment.
    R0_supp_case_isolation    = random(SEIR_metaparameters.suppression_distributions.supp_case_isol_dist, 1, 1);
    R0_supp_public_event_ban  = random(SEIR_metaparameters.suppression_distributions.supp_publ_ban_dist, 1, 1);
    R0_supp_school_closure    = random(SEIR_metaparameters.suppression_distributions.supp_schools_dist, 1, 1);
    R0_supp_social_distancing = random(SEIR_metaparameters.suppression_distributions.supp_distanc_dist, 1, 1);
    R0_supp_lockdown          = random(SEIR_metaparameters.suppression_distributions.supp_lockdown_dist, 1, 1);
              
    SEIR_parameters = struct('R0', R0, 'incubation_time', incubation_time, ...
                             'infectious_time', infectious_time, ...
                             'R0_supp_case_isolation',    R0_supp_case_isolation, ...
                             'R0_supp_public_event_ban',  R0_supp_public_event_ban, ...
                             'R0_supp_school_closure',    R0_supp_school_closure, ...
                             'R0_supp_social_distancing', R0_supp_social_distancing, ...
                             'R0_supp_lockdown',          R0_supp_lockdown);
    
end