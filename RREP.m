C1 = 25; 
C2 = 15;
dC2 = 10;
beta = 3;
C2_prime = 15;
dC2_prime = 20;


ratio_values = [2, 1, 0.5, 4, 8];

E2_diff_fixed = 10; 


hex_codes = {
    '#BABB37',  % Green
    '#FB968B',  % Red
    '#46CEA0',  % Cyan
    '#3DC8F3',  % Blue
    '#E698E9'   % Purple
};

num_cases = length(ratio_values);
custom_colors = zeros(num_cases, 3);
for i = 1:num_cases
    hex = hex_codes{i}(2:end);
    custom_colors(i,:) = sscanf(hex, '%2x', [1 3]) / 255;
end


figure('Position', [100, 100, 1200, 750]);
tlo = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

[start_x, start_y] = meshgrid(0:0.1:1, 0:0.1:1);

x_star_fixed = (-E2_diff_fixed - (C2_prime - C2 - beta * dC2)) / (dC2 * beta - dC2 + dC2_prime);

for i = 1:num_cases
    ax = nexttile;
    hold(ax, 'on'); 
    
    current_ratio = ratio_values(i);
    dE1_current = C1 * current_ratio;
    

    [x, y] = meshgrid(0:0.02:1, 0:0.02:1);
    dx = x .* (1 - x) .* (y * dE1_current - C1);
    dy = y .* (1 - y) .* (x .* (dC2 * beta - dC2 + dC2_prime) + E2_diff_fixed + (C2_prime - C2 - beta * dC2));
    
    h = streamline(x, y, dx, dy, start_x, start_y);
    set(h, 'Color', custom_colors(i,:), 'LineWidth', 1.2);
    
    plot(ax, [0, 1], [0, 1], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    plot(ax, [1, 0], [0, 1], 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
    
    y_star_current = C1 / dE1_current; % 等价于 1 / current_ratio

    if x_star_fixed > 0 && x_star_fixed < 1 && y_star_current > 0 && y_star_current < 1
        plot(ax, x_star_fixed, y_star_current, 'kd', 'MarkerFaceColor', 'w', 'MarkerSize', 10);
    end
    

    axis(ax, [0 1 0 1]);
    box(ax, 'on');
    grid(ax, 'on');
    axis(ax, 'square');
    set(ax, 'FontSize', 10, 'FontWeight', 'bold');
    
    title(ax, sprintf('dE_{1} / C_{1} = %.1f', current_ratio), 'FontSize', 14);
end


title(tlo, 'System Evolution under Different dE_{1}/C_{1} Ratios', 'FontSize', 20, 'FontWeight', 'bold');
xlabel(tlo, 'Probability of HEIs Expand (x)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel(tlo, 'Probability of Graduates Enroll (y)', 'FontSize', 14, 'FontWeight', 'bold');


ax_legend = axes('Position', [0.72 0.22 0.2 0.2]);
axis(ax_legend, 'off'); 
hold(ax_legend, 'on');
plot(NaN,NaN, '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'DisplayName', 'Evolutionary Trajectory');
plot(NaN,NaN, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8, 'DisplayName', 'Stable  Equilibrium (ESS)');
plot(NaN,NaN, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'DisplayName', 'Unstable Point');
plot(NaN,NaN, 'kd', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'DisplayName', 'Saddle Point');
hold(ax_legend, 'off');
legend(ax_legend, 'show', 'Location', 'northwest', 'FontSize', 14, 'FontWeight', 'bold');


output_filename = 'RREP.png';
print(gcf, output_filename, '-dpng', '-r600');
fprintf('Successed: %s\n', output_filename);