function plot_stuff(t, quantiles, label_y, SEIR_metaparameters)
    area(t, quantiles(3, :)', 'LineStyle','none', 'DisplayName', [num2str(100 * SEIR_metaparameters.CI_interval) ' quantile']);
    hold on
    h = area(t, quantiles(1, :)', 'LineStyle','none', 'DisplayName', 'none');
    h(1).FaceColor = [1 1 1];
    plot(t, quantiles(2, :), 'DisplayName', 'median behavior');
    hold off
    ylabel(label_y)
    xlabel('Time [days]')
    set(gca, 'yScale', 'log')
    legend('show')    
end
