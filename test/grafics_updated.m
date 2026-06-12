clear; clc; close all;

resultsDir = "mppi_results_by_alpha";

selectedAlpha = 0.90;
selectedFile = fullfile(resultsDir, sprintf("mppi_results_alpha_%s.mat", alphaTag(selectedAlpha)));

% -------- Figure 1 --------
if isfile(selectedFile)
    data = load(selectedFile);

    figure('Color', 'w', 'Units', 'centimeters', 'Position', [3 3 18 12]);

    plot(data.time(:), data.p_add_need(:), 'Color', '#00aa00', 'LineWidth', 1.8); hold on;
    plot(data.time(:), data.p_add(:), 'Color', '#0000ff', 'LineWidth', 1.8);

    grid on; box on;

    xlabel('Время, с', 'FontSize', 16);
    ylabel('Компенсационный параметр, рад', 'FontSize', 16);

    legend('Истинное значение', 'Оценка', ...
        'Location', 'northeast', ...
        'FontSize', 14);

    set(gca, ...
        'FontSize', 15, ...
        'LineWidth', 0.8, ...
        'GridAlpha', 0.25);

    exportgraphics(gcf, ...
        sprintf('p_add_comparison_alpha_%s.png', alphaTag(selectedAlpha)), ...
        'Resolution', 600);
else
    warning("File not found: %s", selectedFile);
end


% -------- Figure 2 --------
alphas = [0.0, 0.6, 0.7, 0.8, 0.9, 1.0];

figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 22 18]);

tiledlayout(3, 2, ...
    'TileSpacing', 'loose', ...
    'Padding', 'loose');

for i = 1:numel(alphas)
    alpha = alphas(i);
    fileName = fullfile(resultsDir, sprintf("mppi_results_alpha_%s.mat", alphaTag(alpha)));

    nexttile;

    if isfile(fileName)
        data = load(fileName);

        plot(data.time(:), data.path_error(:), ...
            'Color', '#0000ff', ...
            'LineWidth', 1.6);

        grid on; box on;

        xlabel('Время, с', 'FontSize', 16);
        ylabel('Ошибка, м', 'FontSize', 16);

        if alpha == 0
            title(sprintf('Чистый MPPI, MSE = %.3f м', data.path_mse), ...
                'FontSize', 16, ...
                'FontWeight', 'normal');
        else
            title(sprintf('\\alpha = %.1f, MSE = %.3f м', alpha, data.path_mse), ...
                'FontSize', 16, ...
                'FontWeight', 'normal');
        end

        set(gca, ...
            'FontSize', 14, ...
            'LineWidth', 0.8, ...
            'GridAlpha', 0.25);
    else
        text(0.5, 0.5, sprintf('Файл не найден\n%s', fileName), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 10);
        axis off;
    end
end

exportgraphics(gcf, 'path_error_alpha_grid.png', 'Resolution', 600);


function tag = alphaTag(alpha)
    tag = strrep(sprintf('%.2f', alpha), '.', 'p');
end