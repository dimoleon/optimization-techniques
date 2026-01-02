function gamma = step_size(step_method, x, d, f, grad, const_step)
    switch step_method
        case 'CNST'
            gamma = const_step;
        case 'MNMZ'
            fun = @(gamm) objective(x + gamm*d);
            gamma = fminbnd(fun, 0, 2.5);
        case 'ARMJ'
            alpha = 1e-4;
            beta = 0.5; 
            gamma = 1.; 
            maxiter = 10000; 

            for i = 1:maxiter
                x_new = x + gamma*d; 
                f_new = objective(x_new); 

                if f_new <= f + alpha*gamma*(grad'*d)
                    break;
                end

                gamma = gamma*beta; 
            end
    end
end


