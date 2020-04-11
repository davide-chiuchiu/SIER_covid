function [severe_cases, critical_cases, death_cases] = severe_critical_dead_quantiles(quantiles, jsonfilename)
    [age_distribution, severe_percentage, critical_percentage, fatality_percentage] = read_china_japan_json_data(jsonfilename);
    
    severe_cases = get_cases(quantiles, age_distribution, severe_percentage);
    critical_cases = get_cases(quantiles, age_distribution, critical_percentage);
    death_cases = get_cases(quantiles, age_distribution, fatality_percentage);
 
end


function cases_of_case = get_cases(quantiles, age_distribution, case_percentage)
    mean_case_percentage = sum(age_distribution .* case_percentage);
    cases_of_case = round(quantiles * mean_case_percentage);
end