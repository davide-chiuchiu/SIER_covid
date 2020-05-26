% list of files 
files_to_load = dir('Data/Infection_data_all_japanese_prefectures/J*');


% to create the file location
[files_to_load(1).folder '/' files_to_load(1).name];


% load file containing the population data
population_data = readtable('Data/Infection_data_all_japanese_prefectures/populationData.csv');



for i = 1 : length(files_to_load)
    disp(files_to_load(i).name)
    
    temp = population_data.name(i);
    disp(temp)
    
    
end