function [x_seq, f_seq] = solver(dir_method, step_method, x0, const_step)
    max_iter = 1000; 
    epsilon = 1e-4; 

    x_curr = x0(:); 
    [f_curr, grad_curr, hes_curr] = objective(x_curr); 

    x_seq = [x_curr]; 
    f_seq = [f_curr]; 

    % LM only
    mu = 0.1; 
    mu_factor = 0.5; 

    for i = 0:max_iter
        if norm(grad_curr) < epsilon
            break;
        end

        % LM 
        hessian_max = max(hes_curr, [], "all");
        if mu < hessian_max
            mu = hessian_max + epsilon;
        end

        d_i = direction(dir_method, grad_curr, hes_curr, mu);
        gamma_i = step_size(step_method, x_curr, d_i, f_curr, grad_curr, const_step); 
        x_next = x_curr + gamma_i * d_i;
        [f_next, grad_next, hes_next] = objective(x_next);

        if strcmp(dir_method, 'LM')
            if f_next < f_curr
                mu = mu * mu_factor;
            else
                mu = mu / mu_factor;
            end
        end

        x_curr = x_next;
        f_curr = f_next;
        grad_curr = grad_next;
        hes_curr = hes_next;
        
        x_seq = [x_seq, x_curr]; 
        f_seq = [f_seq, f_curr];
    end
end