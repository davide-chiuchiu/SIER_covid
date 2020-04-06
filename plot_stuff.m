function plot_stuff(t, quantiles, label_y)
    area(t, quantiles(3, :)', 'LineStyle','none', 'DisplayName', '90% CI');
    hold on
    h = area(t, quantiles(1, :)', 'LineStyle','none', 'DisplayName', 'none');
    h(1).FaceColor = [1 1 1];
    plot(t, quantiles(2, :), 'DisplayName', 'median behavior');
    hold off
    ylabel(label_y)
    xlabel('Time [days]')
    legend('show')    
end
