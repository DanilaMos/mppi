% ============================================================
% MATLAB plotting script for MPPI backward compensation results
% Window 1: p_add true value vs estimate for one selected alpha
% Window 2: 3x2 grid with trajectory error for alpha = 0, 0.6...1.0
% ============================================================

clear; clc; close all;

resultsDir = "mppi_results_by_alpha";

% -------- Window 1: compensation parameter comparison --------
selectedAlpha = 0.90;  % change this value if needed
selectedFile = fullfile(resultsDir, sprintf("mppi_results_alpha_%s.mat", alphaTag(selectedAlpha)));

if isfile(selectedFile)
    data = load(selectedFile);

    figure('Name', 'Compensation parameter comparison', 'Color', 'w');

    plot(data.time(:), data.p_add_need(:), 'g', 'LineWidth', 2); hold on;
    plot(data.time(:), data.p_add(:), 'b', 'LineWidth', 2);

    grid on;
    xlabel('Время, с');
    ylabel('Компенсационный параметр, рад');
    title(sprintf('Сравнение истинного значения компенсационного параметра и его оценки, \\alpha = %.1f', selectedAlpha));
    legend('Истинное значение', 'Оценка', 'Location', 'best');
    set(gca, 'FontSize', 12);

    exportgraphics(gcf, sprintf('p_add_comparison_alpha_%s.png', alphaTag(selectedAlpha)), 'Resolution', 300);
else
    warning("File not found for Window 1: %s", selectedFile);
end


% -------- Window 2: path error comparison, 3 by 2 grid --------
alphas = [0.0, 0.6, 0.7, 0.8, 0.9, 1.0];

figure('Name', 'Path tracking error for different forgetting factors', 'Color', 'w');

for i = 1:numel(alphas)
    alpha = alphas(i);
    fileName = fullfile(resultsDir, sprintf("mppi_results_alpha_%s.mat", alphaTag(alpha)));

    subplot(3, 2, i);

    if isfile(fileName)
        data = load(fileName);

        plot(data.time(:), data.path_error(:), 'b', 'LineWidth', 1.6);
        grid on;

        xlabel('Время, с');
        ylabel('Ошибка, м');

        if alpha == 0
            title(sprintf('Чистый MPPI, RMSE = %.3f м', data.path_rmse));
        else
            title(sprintf('\\alpha = %.1f, RMSE = %.3f м', alpha, data.path_rmse));
        end

        set(gca, 'FontSize', 10);
    else
        text(0.5, 0.5, sprintf('Файл не найден\n%s', fileName), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle');
        axis off;
    end
end

sgtitle('Ошибка следования траектории при различных факторах забывания', 'FontSize', 14);

exportgraphics(gcf, 'path_error_alpha_grid.png', 'Resolution', 300);


% -------- Local function: alpha value -> filename tag --------
function tag = alphaTag(alpha)
    tag = strrep(sprintf('%.2f', alpha), '.', 'p');
end
