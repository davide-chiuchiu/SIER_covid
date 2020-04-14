function estimated_initial_cases = estimate_initial_cases(jsonfilename, initial_cases)
    [age_distribution, ~, ~, ~, detection_percentage] = read_china_japan_json_data(jsonfilename);
    mean_detection_percentage = sum(age_distribution .* detection_percentage);   

 
    estimated_initial_cases = 150;%round (initial_cases / mean_detection_percentage);
    
end