clear; 
clc; 
close all; 

common; 

iterations_1e = [];
iterations_2e = [];
iterations_3e = [];
iterations_1l = []; 
iterations_2l = []; 
iterations_3l = []; 

for e = epsilon
    [bisection_left_1, bisection_right_1, iter_1] = bisection(f1, a, b, lnth, e, maxiter);
    iterations_1e = [iterations_1e iter_1];
    % x_star_1 = [x_star_1 (bisection_left_1(end) + bisection_right_1(end))/2];

    [bisection_left_2, bisection_right_2, iter_2] = bisection(f2, a, b, lnth, e, maxiter);
    iterations_2e = [iterations_2e iter_2];
    % x_star_2 = [x_star_2 (bisection_left_2(end) + bisection_right_2(end))/2];

    [bisection_left_3, bisection_right_3, iter_3] = bisection(f3, a, b, lnth, e, maxiter);
    iterations_3e = [iterations_3e iter_3];
    % x_star_3 = [x_star_3 (bisection_left_3(end) + bisection_right_3(end))/2];
end

figure
plot(epsilon, iterations_1e);
title('bisection: f1, l =', lnth)
xlabel('$\varepsilon$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(epsilon, iterations_2e);
title('bisection: f2, l =', lnth)
xlabel('$\varepsilon$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(epsilon, iterations_3e);
title('bisection: f3, l =', lnth)
xlabel('$\varepsilon$', 'interpreter', 'latex');
ylabel('Number of iterations');

for l = len
    [bisection_left_1, bisection_right_1, iter_1] = bisection(f1, a, b, l, epsl, maxiter);
    iterations_1l = [iterations_1l iter_1];
    % x_star_1 = [x_star_1 (bisection_left_1(end) + bisection_right_1(end))/2];

    [bisection_left_2, bisection_right_2, iter_2] = bisection(f2, a, b, l, epsl, maxiter);
    iterations_2l = [iterations_2l iter_2];
    % x_star_2 = [x_star_2 (bisection_left_2(end) + bisection_right_2(end))/2];

    [bisection_left_3, bisection_right_3, iter_3] = bisection(f3, a, b, l, epsl, maxiter);
    iterations_3l = [iterations_3l iter_3];
    % x_star_3 = [x_star_3 (bisection_left_3(end) + bisection_right_3(end))/2];
end

figure
plot(len, iterations_1l);
title('bisection: f1, e =', epsl)
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(len, iterations_2l);
title('bisection: f2, e =', epsl)
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(len, iterations_3l);
title('bisection: f3, e =', epsl)
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');

figure
title('bisection: f1, l selection:', l)
for l = l_selection
    [bisection_left, bisection_right, iter] = bisection(f1, a, b, l, epsl, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_left, "DisplayName", legend_label_left) 
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_right, "DisplayName", legend_label_right) 
    hold on
end
legend('show')
hold off

figure
title('bisection: f2, l selection:', l)
for l = l_selection
    [bisection_left, bisection_right, iter] = bisection(f2, a, b, l, epsl, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_left, "DisplayName", legend_label_left) 
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_right, "DisplayName", legend_label_right) 
    hold on
end
legend('show')
hold off

figure
title('bisection: f3, l selection:', l)
for l = l_selection
    [bisection_left, bisection_right, iter] = bisection(f3, a, b, l, epsl, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, bisection_left, "DisplayName", legend_label_left) 
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, bisection_right, "DisplayName", legend_label_right) 
    hold on
end
legend('show')
hold off