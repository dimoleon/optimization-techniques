function [lefts, rights, iter] = bisection_derivative(df, a, b, l, maxiter)
    assert(b > a)

    iter = 0;

    left = a; 
    right = b; 
    lefts = [left];
    rights = [right];

    for i = 1:maxiter
        if right - left <= l 
            break
        end

        iter = iter + 1;
        m = (left + right)/2;

        if df(m) < 0
            left = m;
        else
            right = m; 
        end
        lefts = [lefts left];
        rights = [rights right];
    end
