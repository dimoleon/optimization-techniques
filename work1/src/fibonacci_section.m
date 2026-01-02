function [lefts, rights, iter] = fibonacci_section(f, a, b, l, maxiter)
    assert(b > a);

    iter = 0;
    while fibonacci(iter) < (b - a)/l
        iter = iter + 1;
    end
    iter = min(iter, maxiter);

    left = a;
    right = b;
    lefts = [left]; 
    rights = [right];
    d = b - a;

    for i = 1:iter
        d = d*fibonacci(iter - i)/fibonacci(iter - i + 1); 
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