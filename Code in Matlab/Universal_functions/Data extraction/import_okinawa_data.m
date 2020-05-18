function okinawa_data = import_okinawa_data()
    % select file containing data
    file_path = 'Data/Okinawa_infection_data/';
    data_file = 'Okinawa_cases_tests.csv';
    okinawa_data = readtable([file_path data_file]);
    
end


