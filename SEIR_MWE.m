function SEIR_MWE()
    tspan = 1:365;
    
   parameters = struct('Okinawa_population', 1433566, ...
              'R0', 2.7, ...
              'infectious_time', 3, ...
              'incubation_time', 5); 
                   
    initial_infected = 130;
    initial_exposed = 296;
    initial_susceptible = parameters.Okinawa_population - initial_infected - initial_exposed;
               
    
    initial_point = [initial_susceptible, initial_exposed, initial_infected, initial_infected];
    
    
    [t, compartments] = ode45(@(t, compartments) SEIR_equations(t, compartments, parameters), tspan, initial_point);
    
    figure(15)
    subplot(1, 2, 1)
    plot(t, compartments(:,3) / parameters.Okinawa_population)
    subplot(1, 2, 2)
    plot(t, compartments(:, 4) / parameters.Okinawa_population)

end


function dSEIR = SEIR_equations(t, compartments, parameters)



    N  = parameters.Okinawa_population;
    R0 = parameters.R0;
    Di = parameters.infectious_time;
    De = parameters.incubation_time;
    
    S = compartments(1);
    E = compartments(2);
    I = compartments(3);
    cum_I = compartments(4);
    dSEIR = zeros(size(compartments));
    
    dSEIR(1) = - S * I * R0 / (N * Di);
    dSEIR(2) =   S * I * R0 / (N * Di) - E / De;
    dSEIR(3) =   E / De - I / Di;
    dSEIR(4) =   E / De;

    
    

end