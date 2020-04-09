function estimated_initial_cases = estimate_initial_cases(jsonfilename, initial_cases)
    imported_data = jsondecode(fileread(jsonfilename));
    age_distribution = cell2mat(struct2cell(imported_data.ageDistribution));
    
    detection_percentage = [5 5, 10, 15, 20, 25, 30, 40, 50]'/100;    
    mean_detection_percentage = sum(age_distribution .* detection_percentage);    
    estimated_initial_cases = initial_cases / mean_detection_percentage;
end