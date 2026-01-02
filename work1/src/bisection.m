function [lefts, rights, iter] = bisection(f, a, b, l, epsilon, maxiter)
    assert(epsilon > 0 & b > a);
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
        x1 = (left + right)/2 - epsilon;
        x2 = (left + right)/2 + epsilon;
        
        if f(x1) > f(x2) 
            left = x1;
        else
            right = x2;
        end
        lefts = [lefts left]; 
        rights = [rights right]; 
    end 

