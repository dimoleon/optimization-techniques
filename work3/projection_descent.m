function [x_hist, f_hist] = projection_descent(f, grad_f, lb, ub, x0, params, tol)
    s = params.s;
    gamma = params.gamma;
    max_iter = 1000;
    
    x = x0;
    
    x = min(max(x, lb), ub);
    
    x_hist = x;
    f_hist = f(x);
    
    for k = 1:max_iter
        g = grad_f(x);
        
        x_bar = x - s * g;
        x_bar_proj = min(max(x_bar, lb), ub);
        d_k = x_bar_proj - x;
        
        if norm(d_k) < tol
            break;
        end
        
        x = x + gamma * d_k;
        
        x_hist = [x_hist, x]; 
        f_hist = [f_hist, f(x)]; 
    end
end