clear; 
clc; 
close all; 

common; 

iterations_1 = []; 
iterations_2 = []; 
iterations_3 = []; 

for l = len
    [golden_section_left_1, golden_section_right_1, iter_1] = golden_section(f1, a, b, l, maxiter);
    iterations_1 = [iterations_1 iter_1];
    % x_star_1 = [x_star_1 (golden_section_left_1(end) + golden_section_right_1(end))/2];

    [golden_section_left_2, golden_section_right_2, iter_2] = golden_section(f2, a, b, l, maxiter);
    iterations_2 = [iterations_2 iter_2];
    % x_star_2 = [x_star_2 (golden_section_left_2(end) + golden_section_right_2(end))/2];

    [golden_section_left_3, golden_section_right_3, iter_3] = golden_section(f3, a, b, l, maxiter);
    iterations_3 = [iterations_3 iter_3];
    % x_star_3 = [x_star_3 (golden_section_left_3(end) + golden_section_right_3(end))/2];
end

figure
plot(len, iterations_1);
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
title('golden section: f1')
figure
plot(len, iterations_2);
title('golden section: f2')
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');
figure
plot(len, iterations_3);
title('golden section: f3')
xlabel('$\ell$', 'interpreter', 'latex');
ylabel('Number of iterations');

figure
title('golden_section: f1, l selection:', l)
xlabel('k')
for l = l_selection
    [golden_section_left, golden_section_right, iter] = golden_section(f1, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, golden_section_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, golden_section_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off

figure
title('golden_section: f2, l selection:', l)
xlabel('k')
for l = l_selection
    [golden_section_left, golden_section_right, iter] = golden_section(f2, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, golden_section_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, golden_section_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off

figure
title('golden_section: f3, l selection:', l)
xlabel('k')
for l = l_selection
    [golden_section_left, golden_section_right, iter] = golden_section(f3, a, b, l, maxiter);
    legend_label_left = sprintf('a_k for l=%3f', l);
    plot(0:iter, golden_section_left, "DisplayName", legend_label_left) 
    
    hold on
    legend_label_right = sprintf('b_k for l=%3f', l);
    plot(0:iter, golden_section_right, "DisplayName", legend_label_right); 
    hold on
end
legend('show')
hold off