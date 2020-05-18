function [infected_cases, severe_cases, death_cases] = severe_critical_dead(compartments, jsonfilename)
    [age_distribution, severe_percentage, ~, fatality_percentage] = read_china_japan_json_data(jsonfilename);
    
    infected_cases = round(compartments(:, 3));
    severe_cases = get_cases(compartments(:, 3), age_distribution, severe_percentage);
    death_cases = get_cases(compartments(:, 4), age_distribution, fatality_percentage);
 
end


function cases_of_case = get_cases(quantiles, age_distribution, case_percentage)
    mean_case_percentage = sum(age_distribution .* case_percentage);
    cases_of_case = (quantiles * mean_case_percentage);
end