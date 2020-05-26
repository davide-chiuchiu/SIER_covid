num_initial_points = 2000;

% list of files 
files_to_load = struct2table(dir('Data/Infection_data_all_japanese_prefectures/J*'));

% load file containing the population data 
population_data = readtable('Data/Infection_data_all_japanese_prefectures/populationData.csv');
population_data.name = strcat(population_data.name, '.csv');

% combine the information about files to load and population
combined_information = join(population_data, files_to_load);

% create table with outputs
outputs_table = table('Size', [length(combined_information.name), 5], 'VariableTypes', {'double','double','datetime', 'datetime', 'double'}, 'VariableNames', {'R0', 'R0_suppression', 'start_date', 'suppression_date', 'min_deviation'});
combined_information = horzcat(combined_information, outputs_table);


for i = 1 : length(combined_information.name)
    disp(i)
    total_population = combined_information.populationServed(i);
    file_to_load = [char(combined_information.folder(i)) '/' char(combined_information.name(i))];
    [combined_information.R0(i), combined_information.R0_suppression(i), combined_information.start_date(i), combined_information.suppression_date(i), combined_information.min_deviation(i)] = SEIR_MWE(num_initial_points, file_to_load, total_population);      
end

figure(12)
subplot(2,2,1)
histogram(combined_information.R0, 10)
xlabel('R0')
subplot(2,2,2)
histogram(combined_information.R0_suppression, 10)
xlabel('R0_suppression')
subplot(2,2,3)
histogram(combined_information.suppression_date, 15)
xlabel('start of containment date')

writetable(combined_information, ['all_japan_prefectures_n_points = ' num2str(num_initial_points) '.csv'] )


