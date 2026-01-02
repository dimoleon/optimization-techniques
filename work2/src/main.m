clear; 
clc; 
close all; 

x0s = [0, 0; -1, -1; 1, 1]; 
dir_methods = {'SD', 'NT', 'LM'}; 
step_methods = {'CNST', 'MNMZ', 'ARMJ'}; 
const_step = 0.1; 

colors = {'r', 'g', 'b'}; 

fprintf('--- Theme 1: Plotting f(x,y) ---\n');
[X, Y] = meshgrid(-3:0.1:3, -3:0.1:3);
Z = (X.^3) .* exp(-X.^2 - Y.^4);
figure('Name', 'Theme 1: Surface Plot');
surf(X, Y, Z); 
xlabel('x'); ylabel('y'); zlabel('f'); 
title('Objective Function'); shading interp;

for m = 1:length(dir_methods)
    curr_dir_method = dir_methods{m};
    fprintf('\n=== Method: %s ===\n', curr_dir_method);
    
    figure('Name', ['Convergence: ' curr_dir_method]);
    t = tiledlayout(1, 3);
    title(t, ['Convergence of ' curr_dir_method]);
    
    for p = 1:size(x0s, 1)
        x0 = x0s(p, :);
        nexttile; hold on; grid on;
        title(sprintf('Start (%.0f, %.0f)', x0(1), x0(2)));
        xlabel('Iter'); ylabel('f(x)');
        
        for s = 1:length(step_methods)
            curr_step_method = step_methods{s};
            
            [x_seq, f_seq] = solver(curr_dir_method, curr_step_method, x0, const_step);
            
            plot(0:length(f_seq)-1, f_seq, 'Color', colors{s}, ...
                 'LineWidth', 1.5, 'DisplayName', curr_step_method);
             
            fprintf('  Start: (%2d,%2d) | Step: %-9s | Iters: %5d | Final f: %.5f\t | Final (x,y): (%.2f, %.2f)\n' , ...
                x0(1), x0(2), curr_step_method, length(f_seq)-1, f_seq(end), x_seq(end-1), x_seq(end));
        end
        if p == 1, legend show; end
        hold off;
    end
end