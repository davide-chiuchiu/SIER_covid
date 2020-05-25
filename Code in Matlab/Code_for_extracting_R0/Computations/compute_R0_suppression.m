% This function takes R0 suppression and the suppression time to compute
% the suppression to apply to R0 at any time t.

function R0_suppression_factor = compute_R0_suppression(t, variables)
    R0_suppression = variables(2);
    suppression_time = variables(3);
    R0_suppression_factor = 1  - R0_suppression .* heaviside(t - suppression_time);
end