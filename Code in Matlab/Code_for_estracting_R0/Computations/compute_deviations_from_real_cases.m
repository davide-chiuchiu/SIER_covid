function mean_squared_deviation = compute_deviations_from_real_cases(R0_variables, SEIR_metaparameters)

    [t, cumulative_detected_cases] = wrapper_to_compute_SEIR(R0_variables, SEIR_metaparameters);
    
    weights =1 + 50 * heaviside(t - 3);
    weights = weights / sum(weights);

    mean_squared_deviation = sqrt(sum( weights .* (cumulative_detected_cases - SEIR_metaparameters.cumulative_confirmed_cases).^2));

end