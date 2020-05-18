function suppression_distributions = get_Flaxman_R0_suppression_distributions()
    supp_case_isol_min = 0.00232;
    supp_publ_ban_min  = 0.00232;
    supp_schools_min   = 0.00232;
    supp_distanc_min   = 0.00232;
    supp_lockdown_min  = 0.0139;

    supp_case_isol_med = 0.0835;
    supp_publ_ban_med  = 0.0719;
    supp_schools_med   = 0.155;
    supp_distanc_med   = 0.0650;
    supp_lockdown_med  = 0.459;

    supp_case_isol_max = 0.232;
    supp_publ_ban_max  = 0.258;
    supp_schools_max   = 0.445;
    supp_distanc_max   = 0.241;
    supp_lockdown_max  = 0.877;
    
    supp_case_isol_dist = makedist('Triangular', 'a', supp_case_isol_min, 'b', supp_case_isol_med, 'c', supp_case_isol_max);
    supp_publ_ban_dist  = makedist('Triangular', 'a', supp_publ_ban_min,  'b', supp_publ_ban_med,  'c', supp_publ_ban_max);
    supp_schools_dist   = makedist('Triangular', 'a', supp_schools_min,   'b', supp_schools_med,   'c', supp_schools_max);
    supp_distanc_dist   = makedist('Triangular', 'a', supp_distanc_min,   'b', supp_distanc_med,   'c', supp_distanc_max);
    supp_lockdown_dist  = makedist('Triangular', 'a', supp_lockdown_min,  'b', supp_lockdown_med,  'c', supp_lockdown_max);

    
    suppression_distributions = struct('supp_case_isol_dist', supp_case_isol_dist, ...
                                       'supp_publ_ban_dist',  supp_publ_ban_dist, ...
                                       'supp_schools_dist',   supp_schools_dist, ...
                                       'supp_distanc_dist',   supp_distanc_dist, ...
                                       'supp_lockdown_dist',  supp_lockdown_dist);

end 