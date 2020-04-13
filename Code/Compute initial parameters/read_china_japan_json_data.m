function [age_distribution, severe_percentage, critical_percentage, fatality_percentage, detection_percentage] = read_china_japan_json_data(jsonfilename)
    imported_data = jsondecode(fileread(jsonfilename));
    age_distribution = cell2mat(struct2cell(imported_data.ageDistribution));
    severe_percentage = imported_data.frac.severe;
    critical_percentage = imported_data.frac.critical;
    fatality_percentage = imported_data.frac.fatal;
    detection_percentage = [5 5, 10, 15, 20, 25, 30, 40, 50]'/100;    
    
end