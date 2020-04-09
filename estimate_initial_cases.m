function estimated_initial_cases = estimate_initial_cases(jsonfilename, initial_cases)
    age_distribution = read_china_japan_json_data(jsonfilename);
    
    detection_percentage = [5 5, 10, 15, 20, 25, 30, 40, 50]'/100;    
    mean_detection_percentage = sum(age_distribution .* detection_percentage);    
    estimated_initial_cases = initial_cases / mean_detection_percentage;
end