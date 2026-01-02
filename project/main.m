N_TRAIN = 500; 
POPULATION_SIZE = 200; 
MAX_GENERATIONS = 12000; 
TARGET_ERROR = 0.1; 
GAUSSIAN_NUM = 15; 
MUTATION_RATE = 0.05; 
MUTATION_STRENGTH = 0.1; 
RELATIVE_WEIGHT_BOUNDS = [-4 4]; 
RELATIVE_STDV_BOUNDS = [0.03 0.3]; 

u1_bounds = [-1 2]; 
u1_len = u1_bounds(2) - u1_bounds(1); 

u2_bounds = [-2 1]; 
u2_len = u2_bounds(2) - u2_bounds(1); 

u1_train = u1_bounds(1) + (u1_bounds(2) - u1_bounds(1)) .* rand(N_TRAIN, 1);
u2_train = u2_bounds(1) + (u2_bounds(2) - u2_bounds(1)) .* rand(N_TRAIN, 1);

y_train = func(u1_train, u2_train);
y_mean = mean(y_train); 
y_amp = max(abs(y_train - y_mean)); 

% add a normalization step or make bounds parametric 

weight_bounds = y_amp * RELATIVE_WEIGHT_BOUNDS; 
stdv1_bounds = u1_len * RELATIVE_STDV_BOUNDS;
stdv2_bounds = u2_len * RELATIVE_STDV_BOUNDS; 

weights = weight_bounds(1) + (weight_bounds(2) - weight_bounds(1)) .* rand(GAUSSIAN_NUM, POPULATION_SIZE);
center1 = u1_bounds(1) + (u1_bounds(2) - u1_bounds(1)) .* rand(GAUSSIAN_NUM, POPULATION_SIZE);
center2 = u2_bounds(1) + (u2_bounds(2) - u2_bounds(1)) .* rand(GAUSSIAN_NUM, POPULATION_SIZE);
stdv1 = stdv1_bounds(1) + (stdv1_bounds(2) - stdv1_bounds(1)) .* rand(GAUSSIAN_NUM, POPULATION_SIZE);
stdv2 = stdv2_bounds(1) + (stdv2_bounds(2) - stdv2_bounds(1)) .* rand(GAUSSIAN_NUM, POPULATION_SIZE);

% encode all population parameters in one matrix 
population = zeros(POPULATION_SIZE, 5 * GAUSSIAN_NUM); 

for i = 1:GAUSSIAN_NUM
    curr_col = (i - 1) * 5 + 1; 

    population(:, curr_col) = weights(i, :)';
    population(:, curr_col + 1) = center1(i, :)';
    population(:, curr_col + 2) = center2(i, :)';
    population(:, curr_col + 3) = stdv1(i, :)';
    population(:, curr_col + 4) = stdv2(i, :)';
end

best_error = inf; 
best_individual = []; 
best_generation = MAX_GENERATIONS; 

errors = zeros(POPULATION_SIZE, 1); 
for i = 1:POPULATION_SIZE
    errors(i) = evaluator(population(i, :), u1_train, u2_train, y_train, GAUSSIAN_NUM);
end

for generation = 1:MAX_GENERATIONS
    % elite individual, to be copied in the next generation
    [elite_error, elite_idx] = min(errors); 
    elite_individual = population(elite_idx, :); 

    if elite_error < best_error
        best_error = elite_error; 
        best_individual = elite_individual;
        best_generation = generation; 

        if best_error < TARGET_ERROR
            break; 
        end
    end

    if mod(generation, 100) == 0
        fprintf("Generation %d: Best error = %.2f\n", generation, elite_error);
    end

    % roulette wheel selection 
    % split probabilities by fitness
    fitness = 1 ./ (1 + errors); 
    probabilities = fitness / sum(fitness);
    cumm_probabilies = cumsum(probabilities); 

    % birth 
    descendants = zeros(size(population));
    for i = 1:2:POPULATION_SIZE
        r1 = rand; 
        ascendant1_idx = find(cumm_probabilies > r1, 1, 'first'); 
        ascendant1 = population(ascendant1_idx, :); 

        r2 = rand; 
        ascendant2_idx = find(cumm_probabilies > r2, 1, 'first'); 
        ascendant2 = population(ascendant2_idx, :); 

        % crossover ascendant mixing, using block parameter cuts 
        cut_idx = randi(GAUSSIAN_NUM - 1); 
        cut_idx = cut_idx * 5; 

        descendant1 = [ascendant1(1:cut_idx), ascendant2(cut_idx+1:end)];
        descendant2 = [ascendant2(1:cut_idx), ascendant1(cut_idx+1:end)];
        descendants(i, :) = descendant1; 

        if i + 1 <= POPULATION_SIZE
            descendants(i+1, :) = descendant2; 
        end
    end

    % mutation 
    progress = generation / MAX_GENERATIONS;
    current_strength = MUTATION_STRENGTH * (1 - progress^2);

    bitmask = rand(size(descendants)) < MUTATION_RATE; 
    % mutation = current_strength * randn(size(descendants)); 
    mutation = MUTATION_STRENGTH * randn(size(descendants)); 
    descendants = descendants + (bitmask .* mutation); 

    % elitism part 2; remove weekest new individual in favor of best past individual 
    for j = 1:POPULATION_SIZE
        errors(j) = evaluator(descendants(j, :), u1_train, u2_train, y_train, GAUSSIAN_NUM); 
    end

    [~, worst_idx] = max(errors); 
    descendants(worst_idx, :) = elite_individual; 
    
    population = descendants; 
end

fprintf('Final Result: Gen %d, Error = %.2f\n', best_generation, best_error); 
y_predicted = reconstructor(best_individual, u1_train, u2_train, GAUSSIAN_NUM); 
% y_predicted - y_train

% ... [After running genetic_algorithm and getting final_params] ...

% --- PHASE 4: VISUALIZATION ---

% 1. Create a Dense Grid for Smooth Plotting
% We use more points (e.g., 50x50) than training to see the smooth shape
grid_density = 50; 
u1_plot = linspace(u1_bounds(1), u1_bounds(2), grid_density);
u2_plot = linspace(u2_bounds(1), u2_bounds(2), grid_density);
[U1, U2] = meshgrid(u1_plot, u2_plot);

% 2. Calculate TRUE Surface
% Y_True = sin(U1 + U2) .* sin(U2.^2);
Y_True = func(U1, U2);

% 3. Calculate APPROXIMATED Surface
% We need to "unpack" the final_params one last time to compute the grid
Y_Approx = reconstructor(best_individual, U1, U2, GAUSSIAN_NUM);

% 4. Plotting
figure('Name', 'GA Optimization Results', 'Color', 'w');

% Plot 1: The Target Function
subplot(1, 2, 1);
surf(U1, U2, Y_True, 'EdgeColor', 'none');
title('Original Function');
xlabel('u_1'); ylabel('u_2'); zlabel('y');
axis tight; view(3); camlight; lighting phong;
% colorbar;

% Plot 2: The GA Approximation
subplot(1, 2, 2);
surf(U1, U2, Y_Approx, 'EdgeColor', 'none');
title(['GA Approximation (Error: ' num2str(best_error, '%.4f') ')']);
xlabel('u_1'); ylabel('u_2'); zlabel('y');
axis tight; view(3); camlight; lighting phong;
% colorbar;

% Optional: Error Surface (Difference)
figure('Name', 'Error Landscape', 'Color', 'w');
surf(U1, U2, abs(Y_True - Y_Approx), 'EdgeColor', 'none');
title('Absolute Error |y_{true} - y_{approx}|');
xlabel('u_1'); ylabel('u_2'); zlabel('Error');
colormap jet; colorbar;
view(3);