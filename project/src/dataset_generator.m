function [u1_train, u2_train, y_train] = dataset_generator(funct, u1_bounds, u2_bounds, n_train)
    u1_train = u1_bounds(1) + (u1_bounds(2) - u1_bounds(1)) .* rand(n_train, 1);
    u2_train = u2_bounds(1) + (u2_bounds(2) - u2_bounds(1)) .* rand(n_train, 1);
    y_train = funct(u1_train, u2_train);
end