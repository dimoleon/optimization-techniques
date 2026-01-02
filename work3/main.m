clc; clear; close all;

f = @(x) (1/3)*x(1)^2 + 3*x(2)^2;

grad_f = @(x) [(2/3)*x(1); 6*x(2)];

lb = [-10; -8];
ub = [ 5; 12];

fprintf('--- THEME 1: Steepest Descent ---\n');
gammas = [0.1, 0.3, 3, 5];
x0_t1 = [4; 4];
eps_t1 = 0.001;

figure('Name', 'Theme 1: Convergence'); hold on;
legends = {};

for i = 1:length(gammas)
    gamma = gammas(i);
    
    [x_hist, f_hist] = steepest_descent(f, grad_f, x0_t1, gamma, eps_t1);
    
    plot(0:length(f_hist)-1, f_hist, 'LineWidth', 1.5);
    legends{end+1} = sprintf('gamma = %.1f', gamma);
    
    fprintf('Gamma: %.1f | Iterations: %d | Final f(x): %.4f\n', ...
            gamma, length(f_hist)-1, f_hist(end));
end

title('Theme 1: Objective Value vs Iterations');
xlabel('Iterations (k)'); ylabel('f(x_k)');
legend(legends); grid on; hold off;

fprintf('\n--- THEME 2: Projection Descent ---\n');
params_t2.s = 5;
params_t2.gamma = 0.5;
x0_t2 = [5; -5];
eps_t2 = 0.01;

[x_hist2, f_hist2] = projection_descent(f, grad_f, lb, ub, x0_t2, params_t2, eps_t2);

plot_results(f_hist2, x_hist2, 'Theme 2');
fprintf('Theme 2 Final Point: [%.4f, %.4f]\n', x_hist2(1,end), x_hist2(2,end));

fprintf('\n--- THEME 3: Projected Descent ---\n');
params_t3.s = 15;
params_t3.gamma = 0.1;
x0_t3 = [-5; 10];
eps_t3 = 0.01;

[x_hist3, f_hist3] = projection_descent(f, grad_f, lb, ub, x0_t3, params_t3, eps_t3);

plot_results(f_hist3, x_hist3, 'Theme 3');
fprintf('Theme 3 Final Point: [%.4f, %.4f]\n', x_hist3(1,end), x_hist3(2,end));

fprintf('\n--- THEME 4: Projected Descent ---\n');
params_t4.s = 0.1;
params_t4.gamma = 0.2;
x0_t4 = [8; -10];
eps_t4 = 0.01;

[x_hist4, f_hist4] = projection_descent(f, grad_f, lb, ub, x0_t4, params_t4, eps_t4);

plot_results(f_hist4, x_hist4, 'Theme 4');
fprintf('Theme 4 Final Point: [%.4f, %.4f]\n', x_hist4(1,end), x_hist4(2,end));

function plot_results(f_hist, x_hist, title_str)
    figure('Name', title_str);
    
    subplot(2,1,1);
    plot(0:length(f_hist)-1, f_hist, '-o', 'MarkerSize', 4);
    title([title_str, ': Objective Value']);
    xlabel('Iter'); ylabel('f(x)'); grid on;
    
    subplot(2,1,2);
    plot(x_hist(1,:), x_hist(2,:), '-x');
    title([title_str, ': Trajectory']);
    xlabel('x_1'); ylabel('x_2'); grid on;
    
    % Draw constraints box
    rectangle('Position',[-10, -8, 15, 20], 'EdgeColor','r', 'LineStyle','--');
end