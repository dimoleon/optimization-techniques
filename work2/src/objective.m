function [f, grd, hes] = objective(vect)
    x = vect(1); 
    y = vect(2); 

    exponential = exp(-x^2 - y^4); 
    f = x^3 * exponential; 

    if nargout >= 2
        dfdx = (3*x^2 - 2*x^4) * exponential; 
        dfdy = (-4*x^3*y^3) * exponential; 
        grd = [dfdx; dfdy]; 
    end

    if nargout >= 3
        d2fdxdy = (8*x^4*y^3 - 12*x^2*y^3) * exponential; 
        d2fdxdx = (6*x - 14*x^3 + 4*x^5) * exponential; 
        d2fdydy = (16*x^3*y^6 - 12*x^3*y^2) * exponential; 
        hes = [d2fdxdx d2fdxdy; d2fdxdy d2fdydy]; 
    end
end