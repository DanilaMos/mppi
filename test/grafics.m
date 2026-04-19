data = load('mppi_results.mat');

time = data.time;
p_add = data.p_add;
p_add_need = data.p_add_need;

figure;

plot(time, p_add_need, 'g', 'LineWidth', 2); hold on;
plot(time, p_add, 'b', 'LineWidth', 2);

grid on;

xlabel('Время, с');
ylabel('Компенсационный параметр, рад');

title('Сравнение истинного значения компенсационного параметра и его оценки');

legend('Истинное значение', 'Оценка', 'Location', 'best');
%set(gca, 'FontSize', 12);
%set(gcf, 'Color', 'w');