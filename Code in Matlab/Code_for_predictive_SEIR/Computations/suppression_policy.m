function R0_suppression_coefficient = suppression_policy(t, SEIR_parameters, SEIR_metaparameters, equation_type)
    
    if strcmp(equation_type, 'no_containment')
        R0_suppression_coefficient = 1 * ones(size(t));
    elseif strcmp(equation_type, 'Flakman_containment')
        intervention_times = [0, SEIR_metaparameters.start_containment_date_flaxman + [0, 2, 4, 6]];
        t1_suppression_case_isol_and_public_event_ban = (1 - (SEIR_parameters.R0_supp_case_isolation + SEIR_parameters.R0_supp_public_event_ban));
        t2_suppression_school_closure    = t1_suppression_case_isol_and_public_event_ban * (1 - SEIR_parameters.R0_supp_school_closure);
        t3_suppression_social_distancing = t2_suppression_school_closure * (1 - SEIR_parameters.R0_supp_social_distancing);
        t4_suppression_lockdown          = t3_suppression_social_distancing * (1 - SEIR_parameters.R0_supp_lockdown);
        intervention_efficacy = [1, t1_suppression_case_isol_and_public_event_ban, t2_suppression_school_closure, t3_suppression_social_distancing, t4_suppression_lockdown];
  
        % estimate R_0 suppression factor with the Flakman data.
        R0_suppression_coefficient =  interp1(intervention_times, intervention_efficacy, t, 'previous', 'extrap');       
    elseif strcmp(equation_type, 'R0_step_change')
        R0_suppression_coefficient = 1 - SEIR_parameters.R0_supp_containment * heaviside(t - SEIR_parameters.time_of_suppression);
    else
        error('unknown equation type ') 
    end
end