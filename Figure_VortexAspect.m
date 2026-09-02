function Figure_Vortex_VortexAspect(varargin)
% Figure 3: Vortex count compared to aspect ratio across vertical profiles
% (rectangle, trapezoid, triangle)
%
% Relies on bestPolyOrder.m and /BE_figTools
% For Vortex Counts and Identification steps see Methods section and
% Supplemental figures (marking individual vortices)

close all

%% 
%  PATHS & ARGUMENTS
%% 
addpath(genpath([pwd '/BE_figTools/']));   % adjust if needed

P = parsePairs(varargin);
checkField(P,'FIG',1);
checkField(P,'Save',0);
checkField(P,'View',0);

outpath = [pwd];
if ~exist(outpath,'dir'); mkdir(outpath); end
figname = 'Figure_VortexAspect';

% Make the figure a bit wide so a right-hand legend strip fits
setPlotOpt('custom','path',outpath,'width',20,'height',7);
outpath = [pwd ];
figure(P.FIG); clf; set(P.FIG,FigOpt{:});
HF_matchAspectRatio;

%% 
%  DATA 
%% 
% Rectangles
labels_rect = {'Rect: 2 x 16','Rect: 2\sqrt{2} x 8\sqrt{2}', ...
               'Rect: 4 x 8', 'Rect: 4\sqrt{2} x 4 \sqrt{2}','Rect: 8 x 4', ...
               'Rect: 8\sqrt{2} x 2\sqrt{2}', 'Rect: 16 x 2'};
%labels_gen  = {'2 \times 16','2\sqrt{2} \times 8\sqrt{2}', ...
%               '4 \times 8', '4\sqrt{2} \times 4\sqrt{2}','8 \times 4', ...
%               '8\sqrt{2} \times 2\sqrt{2}', '16 \times 2'};
labels_gen  = {'2','2\sqrt{2}', ...
              '4', '4\sqrt{2}','8', ...
              '8\sqrt{2}', '16'};

labels_gen2 = {'\frac{1}{8}', '\frac{1}{4}', '\frac{1}{2}',...
    '1', '2', '4', '8'};

L  = [2; 2*sqrt(2); 4; 4*sqrt(2); 8; 8*sqrt(2); 16];
HRect = [16; 8*sqrt(2); 8; 4*sqrt(2); 4; 2*sqrt(2); 2];
hrect = HRect;
vortexcntRect = [4; 4; 4; 4; 4; 4; 6];   % recorded from final frame

% Trapezoids
labels_trap = {'Trap: 2 x 24','Trap: 2\sqrt{2} x 12\sqrt{2}', ...
               'Trap: 4 x 12','Trap: 4\sqrt{2} x 6\sqrt{2}','Trap: 8 x 6', ...
               'Trap: 8\sqrt{2} x 3\sqrt{2}', 'Trap: 16 x 3'};
HTrap = [24; 12*sqrt(2); 12; 6*sqrt(2); 6; 3*sqrt(2); 3];
htrap = [8; 4*sqrt(2); 4; 2*sqrt(2); 2; sqrt(2); 1];
vortexcntTrap = [4; 5; 5; 5; 3; 5; 7];   % recorded from final frame

% Triangles
labels_tri = {'Tri: 2 x 32','Tri: 2\sqrt{2} x 16\sqrt{2}', ...
              'Tri: 4 x 16','Tri: 4\sqrt{2} x 8\sqrt{2}','Tri: 8 x 8', ...
              'Tri: 8\sqrt{2} x 4\sqrt{2}', 'Tri: 16 x 4'};
HTri = [32; 16*sqrt(2); 16; 8*sqrt(2); 8; 4*sqrt(2); 4];
htri= [0; 0; 0; 0; 0; 0; 0];
vortexcntTri = [4; 4; 5; 5; 4; 4; 6];    % recorded from final frame


% Colors and scaling (used for discrete aspect ratios)
basecolor = [0,1,1]; % cyan-ish
rect_basecolor = basecolor;
trap_basecolor = basecolor;
tri_basecolor = basecolor;

scale = linspace(1, 0.35, length(L))'; % adjust brightness with aspect

% Aspect ratios and log2
xRect = L./((HRect+hrect)/2);
xTrap = L./((HTrap+htrap)/2);
xTri = L./((HTri+htri)/2);

lxRect = log2(xRect);
lxTrap = log2(xTrap);
lxTri = log2(xTri);

tick_powers = -3:3;  % -3:3 on log2 scale
XLim = [-3 3];
YLim = [0 9];

%% 
%  Polynomial order selection:
%  Each shape only has 7 data points, so order is capped low (maxOrder=4
%  passed in, internally capped further to n-2=5) to avoid the trivial
%  "fit every point exactly" outcome. See bestPolyOrder.m for details.
%% 
maxOrderToConsider = 4;

[orderRect, pRect, diagRect] = bestPolyOrder(lxRect, vortexcntRect, maxOrderToConsider);
[orderTrap, pTrap, diagTrap] = bestPolyOrder(lxTrap, vortexcntTrap, maxOrderToConsider);
[orderTri,  pTri,  diagTri]  = bestPolyOrder(lxTri,  vortexcntTri,  maxOrderToConsider);

fprintf('Selected polynomial orders (via LOOCV): Rect=%d, Trap=%d, Tri=%d\n', ...
    orderRect, orderTrap, orderTri);

% residuals 
poly_pRect = @(x) polyval(pRect, x);
resid_pRect = sum((vortexcntRect - poly_pRect(lxRect)).^2)

poly_pTrap = @(x) polyval(pTrap, x);
resid_pTrap = sum((vortexcntTrap - poly_pTrap(lxTrap)).^2)

poly_pTri = @(x) polyval(pTri, x);
resid_pTri = sum((vortexcntTri - poly_pTri(lxTri)).^2)


%% 
%  LAYOUT (3 panels + right legend strip)
%%
DC = axesDivide(3, [1], ...
    [0.08  0.25  0.65  1.0], ...   % bottom = 0.10, height = 0.88
    0.25, ...
    [0.07 0.30 0.20 0.30])';

AH = gobjects(1,3);
for i = 1:3
    AH(i) = axes('Pos',DC{i}); 
    hold(AH(i),'on');
end

% Panel labels (a), (b), (c)
panelLabels = {'(a)','(b)','(c)'};
for i = 1:3
    axes(AH(i));
    text(-0.18, 1.02, panelLabels{i}, 'Units','normalized', ...
        'FontWeight','bold','FontSize',10);
end

%%
%  PANEL 1: Rectangles
%%
axes(AH(1)); hold on;

for ii = 1:numel(labels_rect)
    plot(lxRect(ii), vortexcntRect(ii), 's', ...
        'MarkerFaceColor', rect_basecolor .* scale(ii), ...
        'MarkerEdgeColor', rect_basecolor .* scale(ii), ...
        'MarkerSize', 7);
end

xx = linspace(min(lxRect), max(lxRect), 200);
yy = polyval(pRect, xx);
hRectFit = plot(xx, yy, '-', 'Color', rect_basecolor, 'LineWidth', 1.5);

set(gca,'XLim',XLim,'YLim',YLim, ...
    'XTick',tick_powers,'XTickLabel',tick_powers);
xlabel('$\log_2\!\left(\frac{L}{H_{\mathrm{avg}}}\right)$','Interpreter','latex');
ylabel('Vortex count');
title('Rectangles','Interpreter','none','FontSize',10);
box off

%% 
%  PANEL 2: Trapezoids
%%
axes(AH(2)); hold on;

for ii = 1:numel(labels_trap)
    plot(lxTrap(ii), vortexcntTrap(ii), 'd', ...
        'MarkerFaceColor', trap_basecolor .* scale(ii), ...
        'MarkerEdgeColor', trap_basecolor .* scale(ii), ...
        'MarkerSize', 7);
end

xx = linspace(min(lxTrap), max(lxTrap), 200);
yy = polyval(pTrap, xx);
hTrapFit = plot(xx, yy, '-', 'Color', trap_basecolor, 'LineWidth', 1.5);

set(gca,'XLim',XLim,'YLim',YLim, ...
    'XTick',tick_powers,'XTickLabel',tick_powers);
xlabel('$\log_2\!\left(\frac{L}{H_{\mathrm{avg}}}\right)$','Interpreter','latex');
title('Trapezoids','Interpreter','none','FontSize',10);
box off

%% 
%  PANEL 3: Triangles
%% 
axes(AH(3)); hold on;

for ii = 1:numel(labels_tri)
    plot(lxTri(ii), vortexcntTri(ii), '^', ...
        'MarkerFaceColor', tri_basecolor .* scale(ii), ...
        'MarkerEdgeColor', tri_basecolor .* scale(ii), ...
        'MarkerSize', 7);
end

xx = linspace(min(lxTri), max(lxTri), 200);
yy = polyval(pTri, xx);
hTriFit = plot(xx, yy, '-', 'Color', tri_basecolor, 'LineWidth', 1.5);

set(gca,'XLim',XLim,'YLim',YLim, ...
    'XTick',tick_powers,'XTickLabel',tick_powers);
xlabel('$\log_2\!\left(\frac{L}{H_{\mathrm{avg}}}\right)$','Interpreter','latex');
title('Triangles','Interpreter','none','FontSize',10);
box off

%% 
%  LEGEND 1: shapes + polynomial fit (order noted per-shape, since each
%  shape's fit may now use a different automatically-selected order)
%% 
axes(AH(1));  % attach legend to first axes

% Dummy handles for shape markers (outline only)
hRectShape = plot(nan, nan, 's', ...
    'MarkerFaceColor','none', ...
    'MarkerEdgeColor', [0,0,0], ...
    'MarkerSize',8);

hTrapShape = plot(nan, nan, 'd', ...
    'MarkerFaceColor','none', ...
    'MarkerEdgeColor', [0,0,0], ...
    'MarkerSize',8);

hTriShape = plot(nan, nan, '^', ...
    'MarkerFaceColor','none', ...
    'MarkerEdgeColor', [0,0,0], ...
    'MarkerSize',8);

% Dummy colored line for polynomial fit (order varies per shape; reported
% in the legend label rather than assumed to be 2nd-order for all three)
hPolyFit = plot(nan, nan, '-', ...
    'Color',tri_basecolor, 'LineWidth',1.5);

leg1 = legend([hRectShape, hTrapShape, hTriShape], ...
    {'Rectangles','Trapezoids','Triangles'}, ...
    'Location','northwest');
leg1.Box = 'off';
leg1.FontSize = 10;
leg1.ItemTokenSize = [18, 10];   

% Fine-tune legend 2 position inside the right strip
pos1 = leg1.Position; % [x y w h]
pos1(1) = 0.8; % horizontal
pos1(2) = 0.6; % vertical
pos1(3) = 0.15; % width
leg1.Position = pos1;

%% 
%  LEGEND 2 (legend_gen): aspect-ratio colors with LaTeX labels
%% 
axes(AH(3));  % anchor to rightmost axes

% Dummy colored squares (use same brightness steps as data)
hColors = gobjects(numel(labels_gen),1);
for k = 1:numel(labels_gen)
    hColors(k) = plot(nan, nan, 'o', ...
        'MarkerFaceColor', basecolor .* scale(k), ...
        'MarkerEdgeColor', basecolor .* scale(k), ...
        'MarkerSize', 7);
end

% Wrap labels_gen in LaTeX math mode
aspectLabels = cell(size(labels_gen));
for k = 1:numel(labels_gen)
    aspectLabels{k} = ['$', labels_gen{k}, '$'];%,';$', labels_gen2{k}, '$'];
end

leg2 = legend(hColors, aspectLabels, ...
    'Location','eastoutside', ...
    'Interpreter','latex');
leg2.Box = 'off';
leg2.FontSize = 10;

% Fine-tune legend 2 position inside the right strip
pos2 = leg2.Position;  % [x y w h]
pos2(1) = 0.75;  % horizontal
pos2(2) = 0.13;  % vertical
pos2(3) = 0.15;  % width
leg2.Position = pos2;


% Add "Aspect Ratio" label above legend
annotation('textbox', ...
    [pos2(1) pos2(2) + pos2(4) + 0.05  pos2(3) 0.03], ...
    'String', 'Length', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom', ...
    'FontSize', 10, ...
    'FontWeight','bold', ...
    'Interpreter','none', ...
    'LineStyle','none');

HF_setFigProps;
set(gcf,'Renderer','painters');

for i = 1:numel(AH)
    ax = AH(i);
    if ~isempty(ax.Title) && isgraphics(ax.Title)
        ax.Title.FontSize = 10;   % title
        ax.Title.FontWeight='normal'; 
        ax.XLabel.FontSize = 10; % x-axis label
        ax.YLabel.FontSize = 10; % y-axis label
        ax.XAxis.FontSize = 10; % tick labels
        ax.YAxis.FontSize = 10; % tick labels
    end
end
HF_viewsave('path',outpath, ...
            'name',figname, ...
            'view',P.View, ...
            'save',P.Save, ...
            'format','pdf', ...
            'res',600);


saveas(gcf, fullfile(outpath, [figname '.pdf']));
close all;
end
