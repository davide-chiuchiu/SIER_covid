function [t,compartments] = SEIR(tspan, parameters, equation_types)
    starting_compartments = [parameters.okinawa_population - parameters.initial_infected, parameters.initial_infected, parameters.initial_infected, 0]; % in order S E I R
    [t,compartments] = ode45(@(t, compartments) equations(t, compartments, parameters, equation_types), tspan, starting_compartments);

end


function d_compartments = equations(~, compartments, parameters, equation_types)
    if strcmp(equation_types, 'crude_estimates') || strcmp(equation_types, 'suppressed_crude_estimates')
        d_compartments = zeros(size(compartments));
        d_compartments(1) = -parameters.beta * compartments(1) * compartments(3) / parameters.okinawa_population;
        d_compartments(2) = parameters.beta * compartments(1) * compartments(3) / parameters.okinawa_population - parameters.sigma * compartments(2);
        d_compartments(3) = parameters.sigma * compartments(2) - parameters.gamma * compartments(3);
        d_compartments(4) = parameters.gamma * compartments(3);
    elseif strcmp(equation_types, 'multiple_channels')
        d_compartments = zeros(size(compartments));
        d_compartments(1) = -(parameters.beta_symptomatic + parameters.beta_asymptomatic) * compartments(1) * compartments(3) / parameters.okinawa_population + ...
                            - parameters.beta_asymptomatic * compartments(1) * compartments(2) / parameters.okinawa_population;
        d_compartments(2) = (parameters.beta_symptomatic + parameters.beta_asymptomatic) * compartments(1) * compartments(3) / parameters.okinawa_population +...
                            parameters.beta_asymptomatic * compartments(1) * compartments(2) / parameters.okinawa_population - parameters.sigma * compartments(2);
        d_compartments(3) = parameters.sigma * compartments(2) - parameters.gamma * compartments(3);
        d_compartments(4) = parameters.gamma * compartments(3);
    else
        error('unknown equations')
    end
end