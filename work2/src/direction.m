function d = direction(dir_method, grad, hes, mu)
    switch dir_method
        case 'SD'
            d = -grad;
        case 'NT'
            d = -hes \ grad; 
        case 'LM'
            J = hes + mu*eye(size(hes));
            d = -J \ grad; 
    end
end