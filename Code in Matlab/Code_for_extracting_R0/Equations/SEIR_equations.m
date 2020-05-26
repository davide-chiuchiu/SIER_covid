% This function defines the ODE system containing the equations for the
% SEIR model. "parameters" pass fixed parameters such as  the okinawa 
% population, the infectious time and the incubation time. "variables"
% parameters over which optimization is performed, i.e. R0, R0 suppression
% and the suppression time.

function dSEIR = SEIR_equations(t, compartments, variables, parameters)
    R0 = variables(1);
    N  = parameters.total_population;
    Di = parameters.infectious_time;
    De = parameters.incubation_time;
    
    S = compartments(1);
    E = compartments(2);
    I = compartments(3);
    
    infectious_strength = R0 / (N * Di) .* compute_R0_suppression(t, variables);
    
    dSEIR = zeros(size(compartments));
    dSEIR(1) = - S * I * infectious_strength;
    dSEIR(2) =   S * I * infectious_strength - E / De;
    dSEIR(3) =   E / De - I / Di;
    dSEIR(4) =   E / De;
end