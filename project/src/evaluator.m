function error = evaluator(individual, u1_train, u2_train, y_train, gaussian_num)
    y_predicted = reconstructor(individual, u1_train, u2_train, gaussian_num);

    error_arr = (y_train - y_predicted).^2;
    error = sum(error_arr);
end

