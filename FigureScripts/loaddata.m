%%%% The following reads in the text file to plot energy estimates and nondimenstionalized measurements
%%%% from bioconvection



function [time_rect, KE_rect, PE_rect, labels_rect,...
    time_trap, KE_trap, PE_trap, labels_trap, ...
    time_tri, KE_tri, PE_tri, labels_tri] = loaddata(pathtodata)


%%% rectangles
folders = {'n40_dt5e2_L2H16/','n40_dt5e2_L2rt2H8rt2/','n40_dt5e2_L4H8/',...
    'n40_dt5e2_L4rt2H4rt2/',...
    'n40_dt5e2_L8H4/','n40_dt5e2_L8rt2H2rt2/', 'n40_dt5e2_L16H2/'};
labels_rect = {'Rect: 2 x 16','Rect: 2rt2 x 8rt2', 'Rect: 4 x 8', ...
    'Rect: 4rt2 x 4rt2',...
    'Rect: 8 x 4', 'Rect: 8rt2 x 2rt2', 'Rect: 16 x 2'};

for ii = 1:size(folders,2)
    directoryrect = [pathtodata '/rectangle/' folders{ii}];

    % read data
    energy_rect = dlmread([directoryrect 'energy.txt'], '', 1, 0);
   % nondim_rect = dlmread([directoryrect 'nondim.txt'], '', 1, 0);

    % extract data
    time_rect(:,ii) = energy_rect(:,1);
   % Urms_rect(:,ii) = nondim_rect(:,2);
   % Re_rect(:,ii) = nondim_rect(:,3);
    %Pe_flow = nondimrect(:,5);
  %  Ra_rect(:,ii) = nondim_rect(:,8);
  %  Nueff_rect(:,ii) = nondim_rect(:,9);
  %  deltaC_rect(:,ii) = nondim_rect(:,10);

    KE_rect(:,ii) = energy_rect(:,3);
    PE_rect(:,ii) = energy_rect(:,4);

    clear energy_rect
    clear nondim_rect
end


%%% trapezoids
folders = {'n40_dt5e2_L2H24/','n40_dt5e2_L2rt2H12rt2/','n40_dt5e2_L4H12/',...
    'n40_dt5e2_L4rt2H6rt2/',...
    'n40_dt5e2_L8H6/', 'n40_dt5e2_L8rt2H3rt2/', 'n40_dt5e2_L16H3/'};
labels_trap =  {'Trap: 2 x 24','Trap: 2rt2 x 12rt2', 'Trap: 4 x 12', ...
    'Trap: 4rt2 x 6rt2',...
    'Trap: 8 x 6', 'Trap: 8rt2 x 3rt2', 'Trap: 16 x 3'};

for ii = 1:size(folders,2)
    directorytrap = [pathtodata '/trapezoid/' folders{ii}];

    % read data
    energy_trap = dlmread([directorytrap 'energy.txt'], '', 1, 0);
  %  nondim_trap = dlmread([directorytrap 'nondim.txt'], '', 1, 0);

    % extract data
    time_trap(:,ii) = energy_trap(:,1);
  %  Urms_trap(:,ii) = nondim_trap(:,2);
  %  Re_trap(:,ii) = nondim_trap(:,3);
    %Pe_flow = nondimrect(:,5);
  %  Ra_trap(:,ii) = nondim_trap(:,8);
  %  Nueff_trap(:,ii) = nondim_trap(:,9);
  %  deltaC_trap(:,ii) = nondim_trap(:,10);

    KE_trap(:,ii) = energy_trap(:,3);
    PE_trap(:,ii) = energy_trap(:,4);

    clear energy_trap
    clear nondim_trap
end


%%% triangles
folders =  {'n40_dt5e2_L2H32/','n40_dt5e2_L2rt2H16rt2/', 'n40_dt5e2_L4H16/',...
    'n40_dt5e2_L4rt2H8rt2/',...
    'n40_dt5e2_L8H8/', 'n40_dt5e2_L8rt2H4rt2/', 'n40_dt5e2_L16H4/'};
labels_tri = {'Tri: 2 x 32','Tri: 2rt2 x 16rt2', 'Tri: 4 x 16', ...
    'Tri: 4rt2 x 8rt2',...
    'Tri: 8 x 8', 'Tri: 8rt2 x 4rt2', 'Tri: 16 x 4'};

for ii = 1:size(folders,2)%%% rectangles
    directorytri = [pathtodata '/triangle/'  folders{ii}];

    % read data
    energy_tri = dlmread([directorytri 'energy.txt'], '', 1, 0);
 %   nondim_tri = dlmread([directorytri 'nondim.txt'], '', 1, 0);

    % extract data
    time_tri(:,ii) = energy_tri(:,1);
 %   Urms_tri(:,ii) = nondim_tri(:,2);
 %   Re_tri(:,ii) = nondim_tri(:,3);
    %Pe_flow = nondimrect(:,5);
 %   Ra_tri(:,ii) = nondim_tri(:,8);
 %   Nueff_tri(:,ii) = nondim_tri(:,9);
 %   deltaC_tri(:,ii) = nondim_tri(:,10);

    KE_tri(:,ii) = energy_tri(:,3);
    PE_tri(:,ii) = energy_tri(:,4);

    clear energy_tri
    clear nondim_tri
end







