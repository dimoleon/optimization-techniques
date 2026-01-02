clear; 
clc; 
close all; 

common; 

iterations_1 = []; 
iterations_2 = []; 
iterations_3 = []; 

for l = len
    [bisection_derivative_left_1, bisection_derivative_right_1, iter_1] = bisection_derivative(df1, a, b, l, maxiter);
    iterations_1 = [iterations_1 iter_1];
    % x_star_1 = [x_star_1 (bisection_derivative_left_1(end) + bisection_derivative_right_1(end))/2];

    [bisection_derivative_left_2, bisection_derivative_right_2, iter_2] = bisection_derivative(df2, a, b, l, maxiter);
    iterations_2 = [iterations_2 iter_2];
    % x_star_2 = [x_star_2 (bisection_derivative_left_2(end) + bisection_derivative_right_2(end))/2];

    [bisection_derivative_left_3, bisection_derivative_right_3, iter_3] = bisection_derivative(df3, a, b, l, maxiter);
    iterations_3 = [iterations_3 iter_3];
    % x_star_3 = [x_star_3 (bisection_derivative_left_3(end) + bisection_derivative_right_3(end))/2];
end

figure
plot(len, iterations_1);
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
title('bisection with derivative : f1');
figure
plot(len, iterations_2);
title('bisection with derivative : f2');
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(len, iterations_3);
title('bisection with derivative : f3');
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');

figure
title('bisection_derivative: f1, l selection:', l)
xlabel('k')
for l = l_selection
    [bisection_derivative_left, bisection_derivative_right, iter] = bisection_derivative(df1, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_derivative_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_derivative_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off

figure
title('bisection_derivative: f2, l selection:', l)
xlabel('k')
for l = l_selection
    [bisection_derivative_left, bisection_derivative_right, iter] = bisection_derivative(df2, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_derivative_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_derivative_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off

figure
title('bisection_derivative: f3, l selection:', l)
xlabel('k')
for l = l_selection
    [bisection_derivative_left, bisection_derivative_right, iter] = bisection_derivative(df3, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_derivative_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_derivative_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off
