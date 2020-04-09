function total_deaths = compute_total_deaths(death_cases, label)
    total_deaths = sum(death_cases, 2);
    disp('\n')
    disp(['Total deaths estimates ' label ':'])
    disp([' best case scenario:   ' num2str(total_deaths(1))])
    disp([' median case scenario: ' num2str(total_deaths(2))])
    disp([' worst case scenario:  ' num2str(total_deaths(3))])
    disp('\n')
    
end