function [best_individual, best_error] = genetic_approximator(u1_train, u2_train, y_train, gaussian_num) 
    POPULATION_SIZE = 200; 
    MAX_GENERATIONS = 12000; 
    MUTATION_RATE = 0.05; 
    MUTATION_STRENGTH = 0.1; 
    RELATIVE_WEIGHT_BOUNDS = [-4 4]; 
    RELATIVE_STDV_BOUNDS = [0.03 0.3]; 
    CENTER_TOL = 0.05;
    TARGET_ERROR = 0.1; 

    u1_bounds = [min(u1_train) - CENTER_TOL, max(u1_train) + CENTER_TOL]; 
    u2_bounds = [min(u2_train) - CENTER_TOL, max(u2_train + CENTER_TOL)]; 

    u1_len = u1_bounds(2) - u1_bounds(1); 
    u2_len = u2_bounds(2) - u2_bounds(1); 
    y_mean = mean(y_train); 
    y_amp = max(abs(y_train - y_mean)); 

    % n_train = size(y_train, 1);

    weight_bounds = y_amp * RELATIVE_WEIGHT_BOUNDS; 
    stdv1_bounds = u1_len * RELATIVE_STDV_BOUNDS;
    stdv2_bounds = u2_len * RELATIVE_STDV_BOUNDS; 

    weights = weight_bounds(1) + (weight_bounds(2) - weight_bounds(1)) .* rand(gaussian_num, POPULATION_SIZE);
    center1 = u1_bounds(1) + u1_len * rand(gaussian_num, POPULATION_SIZE);
    center2 = u2_bounds(1) + u2_len * rand(gaussian_num, POPULATION_SIZE);
    stdv1 = stdv1_bounds(1) + (stdv1_bounds(2) - stdv1_bounds(1)) .* rand(gaussian_num, POPULATION_SIZE);
    stdv2 = stdv2_bounds(1) + (stdv2_bounds(2) - stdv2_bounds(1)) .* rand(gaussian_num, POPULATION_SIZE);

    % encode all population parameters in one matrix 
    population = zeros(POPULATION_SIZE, 5 * gaussian_num); 

    for i = 1:gaussian_num
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
        errors(i) = evaluator(population(i, :), u1_train, u2_train, y_train, gaussian_num);
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
            cut_idx = randi(gaussian_num - 1); 
            cut_idx = cut_idx * 5; 

            descendant1 = [ascendant1(1:cut_idx), ascendant2(cut_idx+1:end)];
            descendant2 = [ascendant2(1:cut_idx), ascendant1(cut_idx+1:end)];
            descendants(i, :) = descendant1; 

            if i + 1 <= POPULATION_SIZE
                descendants(i+1, :) = descendant2; 
            end
        end

        % mutation 
        % progress = generation / MAX_GENERATIONS;
        % current_strength = MUTATION_STRENGTH * (1 - progress^2);

        bitmask = rand(size(descendants)) < MUTATION_RATE; 
        % mutation = current_strength * randn(size(descendants)); 
        mutation = MUTATION_STRENGTH * randn(size(descendants)); 
        descendants = descendants + (bitmask .* mutation); 

        % elitism part 2; remove weekest new individual in favor of best past individual 
        for j = 1:POPULATION_SIZE
            errors(j) = evaluator(descendants(j, :), u1_train, u2_train, y_train, gaussian_num); 
        end

        [~, worst_idx] = max(errors); 
        descendants(worst_idx, :) = elite_individual; 
        
        population = descendants; 
    end

    fprintf('Final Result: Gen %d, Error = %.2f\n', best_generation, best_error); 
end