clear; clc; close all; 

N_TRAIN = 500; 
GAUSSIAN_NUM = 15;
u1_bounds = [-1 2]; 
u2_bounds = [-2 1];

% generatre input dataset
[u1_train, u2_train, y_train] = dataset_generator(@func, u1_bounds, u2_bounds, N_TRAIN);

% run genetic algorithm to approximate the values of the dataset
[best_individual, best_error] = genetic_approximator(u1_train, u2_train, y_train, GAUSSIAN_NUM); 

% generate evaluation dataset
[u1_eval, u2_eval, y_eval] = dataset_generator(@func, u1_bounds, u2_bounds, N_TRAIN);

% evaluation error
error_eval = evaluator(best_individual, u1_eval, u2_eval, y_eval, GAUSSIAN_NUM);
fprintf("Independent dataset Evalution Error = %.2f", error_eval);

% plotters - plot in grid both original and approximation function - plot error in grid
grid_density = 50; 
u1_plot = linspace(u1_bounds(1), u1_bounds(2), grid_density);
u2_plot = linspace(u2_bounds(1), u2_bounds(2), grid_density);
[U1, U2] = meshgrid(u1_plot, u2_plot);

Y_True = func(U1, U2);

Y_Approx = reconstructor(best_individual, U1, U2, GAUSSIAN_NUM);

figure('Name', 'GA Optimization Results', 'Color', 'w');

% Plot 1: The Target Function
subplot(1, 2, 1);
surf(U1, U2, Y_True, 'EdgeColor', 'none');
title('Original Function');
xlabel('u_1'); ylabel('u_2'); zlabel('y');
axis tight; view(3); camlight; lighting phong;

% Plot 2: The GA Approximation
subplot(1, 2, 2);
surf(U1, U2, Y_Approx, 'EdgeColor', 'none');
title(['GA Approximation (Error: ' num2str(best_error, '%.4f') ')']);
xlabel('u_1'); ylabel('u_2'); zlabel('y');
axis tight; view(3); camlight; lighting phong;

% Error Surface (Difference)
figure('Name', 'Error Landscape', 'Color', 'w');
surf(U1, U2, abs(Y_True - Y_Approx), 'EdgeColor', 'none');
title('Absolute Error |y_{true} - y_{approx}|');
xlabel('u_1'); ylabel('u_2'); zlabel('Error');
colormap jet; colorbar;
view(3);