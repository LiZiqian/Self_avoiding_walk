function Pos = SAW2D(N)
%% Initialization
n = 0;              % initial total step
Pos = zeros(1,2);   % pre-allocation for saving all positions, The
%                   self-avoiding walk starts from the orignial point(0,0).
List = zeros(1,2);  % pre-allocation for saving all occupied positions
setupplot();        % set up plot

%% main codes
t_vedio = 1;
while n < N
    
    %---------------------------- Walk one step --------------------------%
    while true
        Pos = goSAW_random(Pos);   % walk one step
        n = size(Pos, 1);   % current total step number
        Nebr = NebrSAW(Pos(n,:));   % find all neighbors of the new step
        if ismember(Nebr, List, 'rows')
            % Nebr is a 4*2 array. ismember return a 4*1 logical array.
            % Only all elements in this returned array are 1. Step into the
            % IF condition.
            % All elements in this returned arrary being 1 means this new
            % step get into a dead end. Need to go back and find a new way.
            [Pos,List] = traceSAW(Pos, List); % recursion to find a new way
            continue;  % skip the following ELSE
        else
            % ELSE condition means this latest step can go further.
            if ~ismember(Pos(n,:), List, 'rows')
                % This IF condition checks the lastest step doesn't touch
                % any exsiting ouccupie position.
                List = cat(1, List, Pos(n,:)); % update the existing list
                break;
            else
                % Else condition means touch the self-avoiding path.
                Pos(n,:) = [];  % delete the new position. Step forwards
                % again in new loop.
            end
        end
    end
    %---------------------------------------------------------------------%
    
    
    % ------------------------ Draw all pathway --------------------------%
    plot(Pos(:,1), Pos(:,2), 'LineWidth', 1);
    lim = max(max(abs(List))); % find out the boundary.
    xlim([-lim-1, lim+1]);
    ylim([-lim-1, lim+1]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'ztick',[]);
    axis off;
    pause(0.001);
    %---------------------------------------------------------------------%
    
    
    %-------------- the following codes is for outputting video ----------%
    %     F(t_vedio) = getframe(gcf);
    %     % get present picture as present frame of the video
    %     clf;
    %---------------------------------------------------------------------%
    t_vedio = t_vedio + 1;
end

% ------------------------ Draw all pathway --------------------------%
plot(Pos(:,1), Pos(:,2), 'LineWidth', 1);
lim = max(max(abs(List))); % find out the boundary.
xlim([-lim-1, lim+1]);
ylim([-lim-1, lim+1]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ztick',[]);
axis off;
pause(0.001);
%---------------------------------------------------------------------%

%----------------------------- Output Video ------------------------------%
% set(gcf,'color','none');
% set(gca,'color','none');
% video = VideoWriter('Polymer Growth' , 'MPEG-4');
% video.FrameRate = 30;
% open(video)
% writeVideo(video,F);
% close(video);
%-------------------------------------------------------------------------%
end

%% Sub functions
%*************************************************************************%
function setupplot()
figure('Name','Graph of Self-avoidng walk',...
    'NumberTitle','off',...
    'color', [1 1 1],...
    'units','centimeters',...
    'position',[3 5 20 20]);
axis off;
set(gca, 'Position', [0,0,1,1]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ztick',[]);
end
%*************************************************************************%


%*************************************************************************%
function Nebr = NebrSAW(oneposition)
x = oneposition(1, 1);
y = oneposition(1, 2);
Nebr1 = [x-1, y];
Nebr2 = [x+1, y];
Nebr3 = [x, y-1];
Nebr4 = [x, y+1];
Nebr = [Nebr1; Nebr2; Nebr3; Nebr4];
end
%*************************************************************************%


%*************************************************************************%
function [Pos,List] = traceSAW(Pos, List)
n = size(Pos,1);
Nebr = NebrSAW(Pos(n,:));
if ismember(Nebr, List, 'rows')
    % IF condition satisfied only if ismember() returns all logical 1
    List = cat(1, List, Pos(n,:));
    List = unique(List, 'rows', 'stable');
    Pos(n, :) = [];
    [Pos,List] = traceSAW(Pos, List);
else
    return;
end
end
%*************************************************************************%


%*************************************************************************%
function Pos = goSAW_random(Pos)
n = size(Pos, 1);   % Number of steps
x = Pos(n, 1);      % x coordinate of the newest step
y = Pos(n, 2);      % y coordinate of the newest step
%-------- Random walk with equal probability in all four directions ------%
dice = unidrnd(4);  % Dicing in the range of 1 to 4
if dice == 1
    x = x + 1;  % Right
elseif dice == 2
    x = x - 1;  % Left
elseif dice == 3
    y = y + 1;  % Up
elseif dice == 4
    y = y - 1;  % Down
end
%-------------------------------------------------------------------------%
Pos = cat(1, Pos, [x, y]); % Concatenate new position along the old one.
end
%*************************************************************************%


%*************************************************************************%
function Pos = goSAW_100(Pos)
n = size(Pos, 1);   % Number of steps
x = Pos(n, 1);      % x coordinate of the newest step
y = Pos(n, 2);      % y coordinate of the newest step
%-------- Random walk with equal probability in all four directions ------%
dice = unidrnd(4);  % Dicing in the range of 1 to 4
if dice == 1
    x = x + 1;  % Right
elseif dice == 2
    x = x + 1;  % Right
elseif dice == 3
    x = x + 1;  % Right
elseif dice == 4
    x = x + 1;  % Right
end
%-------------------------------------------------------------------------%
Pos = cat(1, Pos, [x, y]); % Concatenate new position along the old one.
end
%*************************************************************************%


%*************************************************************************%
function Pos = goSAW_90(Pos)
n = size(Pos, 1);   % Number of steps
x = Pos(n, 1);      % x coordinate of the newest step
y = Pos(n, 2);      % y coordinate of the newest step
%-------- Random walk with equal probability in all four directions ------%
dice = rand;  % Dicing in the range of 0~1
if dice > 0.55
    x = x + 1;  % Right
elseif dice > 0.1 && dice <= 0.55
    x = x - 1;  % Left
elseif dice > 0.05 && dice <= 0.1
    y = y + 1;  % Up
elseif dice <= 0.05
    y = y - 1;  % Down
end
%-------------------------------------------------------------------------%
Pos = cat(1, Pos, [x, y]); % Concatenate new position along the old one.
end
%*************************************************************************%
