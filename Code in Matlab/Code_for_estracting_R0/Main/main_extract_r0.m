% set confirmed number of initial infected people and compute all the
% SEIR parameters from Ferretti
initial_confirmed_infected = 5; % this number is to have that there are 25 infected people on the 15th of March.
SEIR_metaparameters = initialize_SEIR_metaparameters(initial_confirmed_infected);

% import Okinawa measures
okinawa_data = import_okinawa_data();

% define simulation time and total confirmed cases based on imported data
time = okinawa_data.date;
tspan = 1 : length(time);    
SEIR_metaparameters.tspan = tspan;
total_confirmed = okinawa_data.testedPositive;

% plot of results
figure(15)
plot(time, total_confirmed)