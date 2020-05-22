function mean_squared_deviation = compute_deviations_from_real_cases(R0_variables, SEIR_metaparameters)

    [~, cumulative_detected_cases] = wrapper_to_compute_SEIR(R0_variables, SEIR_metaparameters);
    mean_squared_deviation = sqrt(mean((cumulative_detected_cases - SEIR_metaparameters.cumulative_confirmed_cases).^2));

end