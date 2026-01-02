function [x_hist, f_hist] = steepest_descent(f, grad_f, x0, gamma, tol)
    max_iter = 1000; 
    x = x0;
    
    x_hist = x;
    f_hist = f(x);
    
    for k = 1:max_iter
        g = grad_f(x);
        
        if norm(g) < tol
            break;
        end
        
        x = x - gamma * g;
        
        x_hist = [x_hist, x]; 
        f_hist = [f_hist, f(x)];
        
        if f(x) > 1e10
            warning('Algorithm diverging. Stopping.');
            break;
        end
    end
end