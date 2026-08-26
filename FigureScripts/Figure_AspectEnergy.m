function Figure_EnergyAspect(varargin)
% Figure 4: KE versus PE grouped by aspect ratio (A) Figure_EnergyAspect
%
% Relies on loaddata and BE_figTools

close all;

%% 
%  Paths
%% 
addpath(genpath([pwd '/BE_figTools/']));   % adjust if needed

P = parsePairs(varargin);
checkField(P,'FIG',1);
checkField(P,'Save',0);
checkField(P,'View',0);

outpath = [pwd '/'];
if ~exist(outpath,'dir'); mkdir(outpath); end
figname = 'Figure_EnergyAspect';

% Make the figure wider to fit the extra tall panel on the right
setPlotOpt('custom','path',outpath,'width',26,'height',7);
outpath = [pwd '/'];

figure(P.FIG); clf;
set(P.FIG, FigOpt{:}, 'Visible','off', 'Renderer','painters');
HF_matchAspectRatio;


%% Load data
[time_rect, KE_rect, PE_rect, labels_rect, ...
    time_trap, KE_trap, PE_trap, labels_trap, ...
    time_tri,  KE_tri,  PE_tri,  labels_tri] ...
    = loaddata('../data');

%% set up markers for panels/aspect
gridCols = [1 2 3 5 6 7];  % columns used by the 2x3 grid (excludes A=1)
A1_col  = 4;  % column used by the dedicated A=1 panel

KE_rect_A1 = KE_rect(:,A1_col);   PE_rect_A1 = PE_rect(:,A1_col);
KE_trap_A1 = KE_trap(:,A1_col);   PE_trap_A1 = PE_trap(:,A1_col);
KE_tri_A1  = KE_tri(:,A1_col);    PE_tri_A1  = PE_tri(:,A1_col);
time_A1 = time_rect(:,A1_col); % A=1 time vector (rectangles' column; same time base across geometries)

%% time marker
T_mark = 1000;
time_markers = find(time_rect(:,1) == T_mark, 1, 'first');
if isempty(time_markers)
    warning('No exact time == %g found; skipping markers.', T_mark);
end

time_A1_markers = find(time_A1 == T_mark, 1, 'first');
if isempty(time_A1_markers)
    warning('No exact time == %g found in A=1 data; skipping markers.', T_mark);
end

%% figure set up
AspectRatio = {'1/8','1/4','1/2','2','4','8'};   % grid panels only,A = 1 is be seperate

rect_basecolor = [0, 1, 1]; % this is the same for all panels
trap_basecolor = [1, 0, 1];
tri_basecolor = [0, 1, 0];

scale = linspace(1, 0.35, numel(AspectRatio))';
colorpick = scale(3);

%% 
step = 1;%% step = 1 is fully sampling all of the data
idx  = 1:step:size(KE_rect,1);

% 
leftMargin = 0.07;
rightMargin = 0.06;
topMargin = 0.08;
botMargin = 0.10;
midGapX = 0.075; % space between subplot columns (widened to fit delta-PE labels on the right of each panel)
midGapY = 0.09; % space between subplot rows
gapToAR1= 0.06; % space between the 2x3 grid and the A=1 panel
legendStripW = 0.13; % width reserved for the geometry legend, far right

nRows = 2;
nCols = 3;

% total width available for [2x3 grid]+[gap]+[A1 panel]+[legend strip]
totalW = 1 - leftMargin - rightMargin - legendStripW;

% split totalW between the 2x3 grid and the AR1 panel
A1_W_frac  = 0.30; % percent of width of AR1
gridW_total = totalW - gapToAR1 - totalW*A1_W_frac;
A1_W       = totalW * A1_W_frac;

colW = (gridW_total - (nCols-1)*midGapX) / nCols;
rowH = (1 - topMargin - botMargin - (nRows-1)*midGapY) / nRows;

AH = gobjects(1,6);
for r = 1:nRows
    for c = 1:nCols
        ii = (r-1)*nCols + c;
        x0 = leftMargin + (c-1)*(colW + midGapX);
        y0 = 1 - topMargin - r*rowH - (r-1)*midGapY;
        AH(ii) = axes('Position',[x0, y0, colW, rowH]);
        hold(AH(ii),'on');
    end
end

% aspect ratio = 1 panel
A1_x0 = leftMargin + gridW_total + gapToAR1;
A1_y0 = botMargin;
A1_h= 1 - topMargin - botMargin; % spans both rows, full height
AH_A1 = axes('Position',[A1_x0, A1_y0, A1_W, A1_h]);
hold(AH_A1,'on');

% Panel labels (a)–(f) for the grid, (g) for the A=1 panel
panelLabels = {'(a)','(b)','(c)','(d)','(e)','(f)'};
for i = 1:6
    axes(AH(i));
    text(-0.30, 1.02, panelLabels{i}, 'Units','normalized', ...
        'FontWeight','normal','FontSize',10);
end
axes(AH_A1);
text(-0.20, 1.02, '(g)', 'Units','normalized', ...
    'FontWeight','normal','FontSize',10);

%% KE vs PE PLOTS BY ASPECT RATIO (2x3 grid)

for ii = 1:numel(AspectRatio)
    axes(AH(ii)); hold on;
    col = gridCols(ii); % map panel index, skips A=1 

    % Rect
    plot(KE_rect(idx,col), PE_rect(idx,col), ...
        'LineWidth',1.5, ...
        'Color', rect_basecolor .* colorpick);

    if ~isempty(time_markers)
        scatter(KE_rect(time_markers,col), PE_rect(time_markers,col), ...
            25, 'o', 'filled', ...
            'MarkerFaceColor', rect_basecolor .* colorpick, ...
            'MarkerEdgeColor','k');
    end

    % Trap
    plot(KE_trap(idx,col), PE_trap(idx,col), ...
        'LineWidth',1.5, ...
        'Color', trap_basecolor .* colorpick);

    if ~isempty(time_markers)
        scatter(KE_trap(time_markers,col), PE_trap(time_markers,col), ...
            25, 'o', 'filled', ...
            'MarkerFaceColor', trap_basecolor .* colorpick, ...
            'MarkerEdgeColor','k');
    end

    % Tri
    plot(KE_tri(idx,col), PE_tri(idx,col), ...
        'LineWidth',1.5, ...
        'Color', tri_basecolor .* colorpick);

    if ~isempty(time_markers)
        scatter(KE_tri(time_markers,col), PE_tri(time_markers,col), ...
            25, 'o', 'filled', ...
            'MarkerFaceColor', tri_basecolor .* colorpick, ...
            'MarkerEdgeColor','k');
    end

    if ii== 1||ii==4
        ylabel('Potential Energy');
    end
    if ii>3
        xlabel('Kinetic Energy');
    end
    title(sprintf('Aspect Ratio = %s', AspectRatio{ii}));
    yl = ylim;
    ylim([0 yl(2)]);

    % Delta PE: peak PE while KE is still ~0 (near the y-axis), versus
    % the final PE value. KE_thresh defines "still on the axis." 
    % Mask is restricted to the initial contiguous run only (from the
    % start of the series up to the first time KE crosses KE_thresh), so
    % a later dip back near KE~0 doesn't get mistaken for the pre-takeoff
    % region.
    % choosing KE_thresh = 1e-4 helps for plots where it is more a curve
    % but still not the peak of PE
    KE_thresh = 1e-4;

    iCross_rect = find(KE_rect(idx,col) >= KE_thresh, 1, 'first');
    iCross_trap = find(KE_trap(idx,col) >= KE_thresh, 1, 'first');
    iCross_tri = find(KE_tri(idx,col) >= KE_thresh, 1, 'first');

    if isempty(iCross_rect) || iCross_rect < 2
        dPE_rect = NaN;
        warning('No valid pre-takeoff region found for rectangles, col %d; dPE set to NaN.', col);
    else
        peakPE_rect = max(PE_rect(idx(1:iCross_rect-1),col));
        dPE_rect = PE_rect(idx(end),col) - peakPE_rect;
    end

    if isempty(iCross_trap) || iCross_trap < 2
        dPE_trap = NaN;
        warning('No valid pre-takeoff region found for trapezoids, col %d; dPE set to NaN.', col);
    else
        peakPE_trap = max(PE_trap(idx(1:iCross_trap-1),col));
        dPE_trap = PE_trap(idx(end),col) - peakPE_trap;
    end

    if isempty(iCross_tri) || iCross_tri < 2
        dPE_tri = NaN;
        warning('No valid pre-takeoff region found for triangles, col %d; dPE set to NaN.', col);
    else
        peakPE_tri = max(PE_tri(idx(1:iCross_tri-1),col));
        dPE_tri = PE_tri(idx(end),col) - peakPE_tri;
    end

    text(1.03, 0.85, sprintf('%+0.3g', dPE_rect), 'Units','normalized', ...
        'Color', rect_basecolor .* colorpick, 'FontSize',8, ...
        'HorizontalAlignment','left','VerticalAlignment','middle');
    text(1.03, 0.70, sprintf('%+0.3g', dPE_trap), 'Units','normalized', ...
        'Color', trap_basecolor .* colorpick, 'FontSize',8, ...
        'HorizontalAlignment','left','VerticalAlignment','middle');
    text(1.03, 0.55, sprintf('%+0.3g', dPE_tri), 'Units','normalized', ...
        'Color', tri_basecolor .* colorpick, 'FontSize',8, ...
        'HorizontalAlignment','left','VerticalAlignment','middle');
end

%% A = 1 TALL PANEL (column 4 of loaddata())
axes(AH_A1); hold on;

plot(KE_rect_A1(idx), PE_rect_A1(idx), ...
    'LineWidth',1.5, 'Color', rect_basecolor .* colorpick);
plot(KE_trap_A1(idx), PE_trap_A1(idx), ...
    'LineWidth',1.5, 'Color', trap_basecolor .* colorpick);
plot(KE_tri_A1(idx),  PE_tri_A1(idx), ...
    'LineWidth',1.5, 'Color', tri_basecolor  .* colorpick);

if ~isempty(time_A1_markers)
    scatter(KE_rect_A1(time_A1_markers), PE_rect_A1(time_A1_markers), ...
        25, 'o', 'filled', 'MarkerFaceColor', rect_basecolor .* colorpick, ...
        'MarkerEdgeColor','k');
    scatter(KE_trap_A1(time_A1_markers), PE_trap_A1(time_A1_markers), ...
        25, 'o', 'filled', 'MarkerFaceColor', trap_basecolor .* colorpick, ...
        'MarkerEdgeColor','k');
    scatter(KE_tri_A1(time_A1_markers),  PE_tri_A1(time_A1_markers), ...
        25, 'o', 'filled', 'MarkerFaceColor', tri_basecolor  .* colorpick, ...
        'MarkerEdgeColor','k');
end
yl = ylim;
ylim([0 yl(2)]);

xlabel(AH_A1, 'Kinetic Energy');
ylabel(AH_A1, 'Potential Energy');
title(AH_A1, 'Aspect Ratio = 1');

%  Delta PE: peak PE while KE is still ~0 (near the y-axis), versus 
%  the final PE value.
KE_thresh = 1e-4;

iCross_rect_A1 = find(KE_rect_A1(idx) >= KE_thresh, 1, 'first');
iCross_trap_A1 = find(KE_trap_A1(idx) >= KE_thresh, 1, 'first');
iCross_tri_A1 = find(KE_tri_A1(idx) >= KE_thresh, 1, 'first');

if isempty(iCross_rect_A1) || iCross_rect_A1 < 2
    dPE_rect_AR1 = NaN;
    warning('No valid pre-takeoff region found for rectangles, A=1; dPE set to NaN.');
else
    peakPE_rect_AR1 = max(PE_rect_A1(idx(1:iCross_rect_A1-1)));
    dPE_rect_AR1 = PE_rect_A1(idx(end)) - peakPE_rect_AR1;
end

if isempty(iCross_trap_A1) || iCross_trap_A1 < 2
    dPE_trap_AR1 = NaN;
    warning('No valid pre-takeoff region found for trapezoids, A=1; dPE set to NaN.');
else
    peakPE_trap_AR1 = max(PE_trap_A1(idx(1:iCross_trap_A1-1)));
    dPE_trap_AR1 = PE_trap_A1(idx(end)) - peakPE_trap_AR1;
end

if isempty(iCross_tri_A1) || iCross_tri_A1 < 2
    dPE_tri_AR1 = NaN;
    warning('No valid pre-takeoff region found for triangles, AR=1; dPE set to NaN.');
else
    peakPE_tri_AR1 = max(PE_tri_A1(idx(1:iCross_tri_A1-1)));
    dPE_tri_AR1 = PE_tri_A1(idx(end)) - peakPE_tri_AR1;
end

text(1.03, 0.85, sprintf('%+0.3g', dPE_rect_AR1), 'Units','normalized', ...
    'Color', rect_basecolor .* colorpick, 'FontSize',8, ...
    'HorizontalAlignment','left','VerticalAlignment','middle', 'Parent',AH_A1);
text(1.03, 0.70, sprintf('%+0.3g', dPE_trap_AR1), 'Units','normalized', ...
    'Color', trap_basecolor .* colorpick, 'FontSize',8, ...
    'HorizontalAlignment','left','VerticalAlignment','middle', 'Parent',AH_A1);
text(1.03, 0.55, sprintf('%+0.3g', dPE_tri_AR1), 'Units','normalized', ...
    'Color', tri_basecolor .* colorpick, 'FontSize',8, ...
    'HorizontalAlignment','left','VerticalAlignment','middle', 'Parent',AH_A1);

%% legend for geometries 
axes(AH(1)); hold on;

hRect = plot(nan, nan, '-', ...
    'Color', rect_basecolor .* colorpick, 'LineWidth',1.5);
hTrap = plot(nan, nan, '-', ...
    'Color', trap_basecolor .* colorpick, 'LineWidth',1.5);
hTri  = plot(nan, nan, '-', ...
    'Color', tri_basecolor  .* colorpick, 'LineWidth',1.5);

leg1 = legend([hRect, hTrap, hTri], ...
    {'Rectangles','Trapezoids','Triangles'}, ...
    'Location','eastoutside');
leg1.Box = 'off';
leg1.FontSize = 10;
leg1.ItemTokenSize = [18, 10];

pos1 = leg1.Position; 
pos1(1) = 1 - legendStripW + 0.01;
pos1(2) = 0.45;
pos1(3) = legendStripW - 0.02;
leg1.Position = pos1;

%% saving 
HF_setFigProps;
set(gcf,'Renderer','painters');

allAxes = [AH, AH_A1];
for i = 1:numel(allAxes)
    ax = allAxes(i);
    if ~isempty(ax.Title) && isgraphics(ax.Title)
        ax.Title.FontSize=10;
        ax.Title.FontWeight='normal';
        ax.XLabel.FontSize=10;
        ax.YLabel.FontSize=10;
        ax.XAxis.FontSize=10;
        ax.YAxis.FontSize=10;
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
