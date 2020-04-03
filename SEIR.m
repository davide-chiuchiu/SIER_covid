function [t,compartments] = SEIR(tspan, parameters, equation_type)

if strcmp(equation_type, 'crude_estimate')
    starting_compartments = [parameters.okinawa_population - parameters.initial_infected, 0, parameters.initial_infected, 0]; % in order S E I R
    [t,compartments] = ode45(@(t, compartments) equations(t, compartments, parameters), tspan, starting_compartments);
else
    error('unknown equations')
end


end


function d_compartments = equations(~, compartments, parameters)
    d_compartments = zeros(size(compartments));
    d_compartments(1) = -parameters.beta * compartments(1) * compartments(3) / parameters.okinawa_population;
    d_compartments(2) = parameters.beta * compartments(1) * compartments(3) / parameters.okinawa_population - parameters.sigma * compartments(2);
    d_compartments(3) = parameters.sigma * compartments(2) - parameters.gamma * compartments(3);
    d_compartments(4) = parameters.gamma * compartments(3);
end