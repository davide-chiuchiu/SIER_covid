% This function takes the set "parameters" of fixed parameters, and the set
% "variables" of parameters that are to be optimized and then solves the
% SEIR equations. As outputs it returns the cumulative number of infected
% over time.

function cumulative_infected = compute_cumulative_infected(variables, parameters)
    initial_infected = variables(4);
    initial_exposed = variables(5);
    initial_susceptible = parameters.Okinawa_population - initial_infected - initial_exposed;    
    initial_point = [initial_susceptible, initial_exposed, initial_infected, initial_infected];
    [~, compartments] = ode45(@(t, compartments) SEIR_equations(t, compartments, variables, parameters), parameters.tspan, initial_point);
    cumulative_infected = compartments(:, 4);
end