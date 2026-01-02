function [lefts, rights, iter] = golden_section(f, a, b, l, maxiter)
    assert(b > a)

    iter = 0;
    gamma = (sqrt(5) - 1)/2; 

    left = a; 
    right = b; 
    lefts = [left]; 
    rights = [right];
    d = b - a;

    for i = 1:maxiter
        if right - left <= l 
            break 
        end

        iter = iter + 1;
        % x1 = left + (1 - gamma)*(right - left);
        % x2 = left + gamma*(right - left);
        d = gamma*d;
        x1 = right - d;
        x2 = left + d;  

        if f(x1) > f(x2)
            left = x1; 
        else
            right = x2; 
        end
        lefts = [lefts left]; 
        rights = [rights right]; 
    end
