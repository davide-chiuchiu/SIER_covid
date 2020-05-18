function summary(time, quantile_infections, quantile_severe, quantile_deaths, peak_infected_scenarios, peak_infected_scenarios_time, peak_severe_scenarios, peak_severe_scenarios_time, max_ventilators, label)
   [death_max, t_max_death] = max(quantile_deaths, [], 2);
    
   [~, zero_infection_iter] = max(quantile_infections == 0, [], 2);
   zero_infected_time = time(zero_infection_iter);
   
   [~, ICU_overflow_iter] = max(quantile_severe > max_ventilators, [], 2);
   ICU_overflow_time = time(ICU_overflow_iter);   
    
    disp('-----------------------------------------')
    disp('-----------------------------------------')
    disp(['Case ' label])
    disp('  ')
    disp('  ')
    disp('Infection peak')
    disp('  ')
    %scenarios(round(infection_peak), t_max_infection_peak, time)
    peak_scenarios(peak_infected_scenarios, peak_infected_scenarios_time)
    disp('  ')
    disp('  ')
    disp('Severe peak')
    disp('  ')
    %scenarios(round(severe_peak), t_max_severe_peak, time)
    peak_scenarios(peak_severe_scenarios, peak_severe_scenarios_time)
    disp('  ')
    disp('  ')
    disp('Total deaths')
    disp('  ')
    scenarios(round(death_max), t_max_death, time)
    disp('  ')
    disp('  ')
    disp('First time of zero infected')
    disp('  ')
    time_analysis(zero_infected_time, time(1), 'Zero infected')
    disp('  ')
    disp('  ')
    disp('First time of ICU overflow')
    disp('  ')
    time_analysis(ICU_overflow_time, time(1), 'ICU overflow')
    disp('-----------------------------------------')
    disp('-----------------------------------------')

end

function peak_scenarios(data, time)
    disp('BEST CASE SCENARIO')
    disp([num2str(data(1)) ' cases on ' datestr(time(1))] )
    disp('MEAN CASE SCENARIO')
    disp([num2str(data(2)) ' cases on ' datestr(time(2))] )
    disp('WORST CASE SCENARIO')
    disp([num2str(data(3)) ' cases on ' datestr(time(3))] )
end

function scenarios(data, index_data, time)
    disp('BEST CASE SCENARIO')
    disp([num2str(data(1)) ' cases on ' datestr(time(index_data(1)))] )
    disp('MEDIAN CASE SCENARIO')
    disp([num2str(data(2)) ' cases on ' datestr(time(index_data(2)))] )
    disp('WORST CASE SCENARIO')
    disp([num2str(data(3)) ' cases on ' datestr(time(index_data(3)))] )
end

function time_analysis(time, start_time, label)
    disp('BEST CASE SCENARIO')
    if time(1) == start_time
        disp(['No expected time with ' label])
    else
        disp([label ' at ' datestr(time(1))] )
    end
    disp('MEDIAN CASE SCENARIO')
    if time(2) == start_time
        disp(['No expected time with ' label])
    else
        disp([label ' at ' datestr(time(2))] )
    end
        disp('WORST CASE SCENARIO')
    if time(3) == start_time
        disp(['No expected time with ' label])
    else
        disp([label ' at ' datestr(time(3))] )
    end


end
