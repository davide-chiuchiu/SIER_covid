function [t,compartments] = SEIR(tspan, SEIR_parameters, SEIR_metaparameters, equation_type, with_seasonality)
    % Initial SEIR population.
    starting_compartments = [SEIR_metaparameters.okinawa_population - (SEIR_metaparameters.estimated_initial_exposed + SEIR_metaparameters.estimated_initial_infected), ...
                             SEIR_metaparameters.estimated_initial_exposed, ...
                             SEIR_metaparameters.estimated_initial_infected, ...
                             0];
    % numerical solver                     
    [t,compartments] = ode45(@(t, compartments) equations(t, compartments, SEIR_parameters, SEIR_metaparameters, equation_type, with_seasonality), tspan, starting_compartments);
    compartments = floor(compartments);   
    
end

function d_compartments = equations(t, compartments, param, metaparam, equation_type, with_seasonality)
        infection_strenght = param.R0 / (param.infectious_time * metaparam.okinawa_population) * suppression_policy(t, param, metaparam, equation_type) * seasonality_modulation(metaparam, t, with_seasonality); 

        S = compartments(1);
        E = compartments(2);
        I = compartments(3);
        R = compartments(4);
        
        d_compartments = zeros(4,1);
        d_compartments(1) = - infection_strenght * S * I;
        d_compartments(2) =   infection_strenght * S * I - E / param.incubation_time;
        d_compartments(3) = E / param.incubation_time - I / param.infectious_time;
        d_compartments(4) = I / param.infectious_time;
end