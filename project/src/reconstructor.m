function y_predicted = reconstructor(individual, u1, u2, gaussian_num)
    genes = reshape(individual, 5, gaussian_num);

    w = genes(1, :)';
    c1 = genes(2, :)';
    c2 = genes(3, :)';
    s1 = genes(4, :)';
    s2 = genes(5, :)';

    y_predicted = zeros(size(u1));
    for i = 1:gaussian_num
        exp1 = -((u1 - c1(i)) ./ (2 * s1(i))).^2;
        exp2 = -((u2 - c2(i)) ./ (2 * s2(i))).^2;

        curr_gaussian = exp(exp1 + exp2);
        y_predicted = y_predicted + w(i) * curr_gaussian;
    end
end

