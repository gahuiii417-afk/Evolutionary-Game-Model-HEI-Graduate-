E1 = 40;
dE1 = 50;
C1 = 25;
E2 = 30;
C2 = 15;
dC2 = 10;
beta = 3;
E2_prime = 20;
C2_prime = 15;
dC2_prime = 20;


f = @(t, xy) [
    xy(1) * (1 - xy(1)) * (xy(2) * dE1 - C1); ...
    xy(2) * (1 - xy(2)) * (xy(1) * (dC2 * beta - dC2 + dC2_prime) - (E2_prime - E2) + (C2_prime - C2 - beta * dC2))
];


[x, y] = meshgrid(0:0.05:1, 0:0.05:1); 
dx = x .* (1 - x) .* (y * dE1 - C1);
dy = y .* (1 - y) .* (x .* (dC2 * beta - dC2 + dC2_prime) - (E2_prime - E2) + (C2_prime - C2 - beta * dC2));


figure('Position', [100, 100, 800, 700]); 
hold on; 


L = sqrt(dx.^2 + dy.^2);
L(L==0) = 1; 
quiver(x, y, dx./L, dy./L, 0.4, 'Color', [0.7 0.7 0.7]); 



x_star = ((E2_prime - E2) - (C2_prime - C2 - beta * dC2)) / (dC2 * beta - dC2 + dC2_prime);
y_star = C1 / dE1;



p_stable = plot(0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
plot(1, 1, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10, 'HandleVisibility', 'off'); 


p_unstable = plot(0, 1, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10);
plot(1, 0, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'HandleVisibility', 'off');
plot(x_star, y_star, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'HandleVisibility', 'off');


axis([0 1 0 1]);
set(gca, 'FontSize', 13, 'FontWeight', 'bold'); 
xlabel('Probability of HEIs Expand (x)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel({'Probability of Graduates Enroll (y)'}, 'FontSize', 14, 'FontWeight', 'bold');
title('System Evolutionary Phase Diagram under Baseline Conditions', 'FontSize', 20, 'FontWeight', 'bold');
grid on;
box on;
axis square;
hold off;


all_lines = findobj(gca, 'Type', 'line'); 
legend_handle = legend( ...
    [p_stable, p_unstable], ... 
    'Stable Equilibrium (ESS)', ...
    'Unstable/Saddle Point', ...
    'Location', 'best' ...
);
set(legend_handle, 'FontSize', 13);


output_filename = 'Initial_Conditions.png';
print(gcf, output_filename, '-dpng', '-r600');

fprintf('Successed: %s\n', output_filename);