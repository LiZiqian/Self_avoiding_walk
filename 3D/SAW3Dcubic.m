function varargout = SAW3Dcubic(varargin)
%
%  SAW3Dcubic(200, 'back')
%
%% Initialization
switch nargin
    case 1
        N = varargin{1};
        Type = 'None';
    case 2
        N = varargin{1};
        Type = varargin{2};
    otherwise
        error('Put in variables are wrong. /n');
end

n = 0;              % initial total step
Pos = zeros(1, 3);	% pre-allocation for saving all positions, The
%                   self-avoiding walk starts from the orignial point(0,0).
List = zeros(1, 3);	% pre-allocation for saving all occupied positions
Step = zeros(1, 3);
%% main codes
t_vedio = 1;
while n < N
    if  strcmp(Type,'back')
        % Use recursion to avoid dead end.
        %---------------------------- Walk one step ----------------------%
        while true
            [Pos, Step] = goSAW_random(Pos, Step);   % walk one step
            n = size(Pos, 1);   % current total step number
            Nebr = NebrSAW(Pos(n,:));	% find all neighbors
            if ismember(Nebr, List, 'rows')
                % Nebr is a 4*2 array. ismember return a 4*1 logical array.
                % Only all elements in this returned array are 1. Step into
                % the IF condition.
                % All elements in this returned arrary being 1 means this 
                % new step get into a dead end. Need to go back and find a 
                % new way. Use recursion to avoid dead-end.
                [Pos, List] = traceSAW(Pos, List); 
                continue;  % skip the following ELSE
            else
                % ELSE condition means this latest step can go further.
                if ~ismember(Pos(n,:), Pos(1:n-1,:), 'rows')
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
        
    elseif strcmp(Type,'none')
        % Do not use recursion to avoid dead end.
        while true
            [Pos, Step] = goSAW_random(Pos, Step);   % walk one step
            n = size(Pos, 1);   % current total step number
            if ~ismember(Pos(n,:), Pos(1:n-1,:), 'rows')
                % This IF condition checks the lastest step doesn't touch
                % any exsiting ouccupie position.
                break;
            else
                % Else condition means touch the self-avoiding path.
                Pos(n,:) = [];  % delete the new position. Step forwards
                Step(n,:) = [];
                % again in new loop.
            end
        end
    end
    %---------------------------------------------------------------------%
    
    % ------------------------ Draw and record frames --------------------%
        plotspace(Pos);
    %     F(t_vedio) = getframe(gcf);   % get present frame
    %     pause(0.001);
    %     clf;
    %---------------------------------------------------------------------%
    t_vedio = t_vedio + 1;
end
% setupplot()
% plotspace(double(Pos));

% % calculate chain length and end-to-end distance
L = sum(sqrt(sum(Step.^2, 2)));
r =  sqrt(sum(Pos(end,:).^2, 2));
nu = log10(r)/log10(L);

varargout{1} = Pos;
varargout{2}= Step;
varargout{3}= L;
varargout{4}= r;
varargout{5}= nu;

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
figure('Name','Graph of Self-avoidng walk in 3D space',...
    'NumberTitle','off',...
    'color', [1 1 1],...
    'units','pixels',...
    'position',[400 200 600 600]);

set(gca, 'Position', [0.04,0.01,0.92,0.92]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ztick',[]);
view([-30 20]);
box on;
set(gca, 'BoxStyle','full');
end
%*************************************************************************%
function plotspace(Pos)
plot3(Pos(:,1), Pos(:,2), Pos(:,3), 'LineWidth', 1);
set(gcf,'color', [1 1 1],...
    'units','pixels',...
    'position',[400 200 600 600]);
lim = max(max(abs(Pos))); % find out the boundary.
xlim([-lim-1, lim+1]);
ylim([-lim-1, lim+1]);
zlim([-lim-1, lim+1]);
set(gca, 'BoxStyle','full');
view([-30 20]);
grid on;
box on;
title('3D Self-avoiding Walk',...
    'fontsize',20',...
    'FontName','Times New Roman',...
    'FontWeight','bold');

end
%*************************************************************************%
function Nebr = NebrSAW(oneposition)
x = oneposition(1, 1);
y = oneposition(1, 2);
z = oneposition(1, 3);
step = 1;
% neighbors on cubic faces
neiborF1 = [x + step, y, z];
neiborF2 = [x - step, y, z];
neiborF3 = [x, y + step, z];
neiborF4 = [x, y - step, z];
neiborF5 = [x, y, z + step];
neiborF6 = [x, y, z - step];
% neighbors on cubic sides
neiborS1 = [x + step, y + step, z];
neiborS2 = [x + step, y - step, z];
neiborS3 = [x + step, y, z + step];
neiborS4 = [x + step, y, z - step];
neiborS5 = [x - step, y + step, z];
neiborS6 = [x - step, y - step, z];
neiborS7 = [x - step, y, z + step];
neiborS8 = [x - step, y, z - step];
neiborS9 = [x, y + step, z + step];
neiborS10 = [x, y + step, z - step];
neiborS11 = [x, y - step, z + step];
neiborS12 = [x, y - step, z - step];
% neighbors on cubic corners
neiborC1 = [x + step, y + step, z + step];
neiborC2 = [x + step, y + step, z - step];
neiborC3 = [x + step, y - step, z + step];
neiborC4 = [x + step, y - step, z - step];
neiborC5 = [x - step, y + step, z + step];
neiborC6 = [x - step, y + step, z - step];
neiborC7 = [x - step, y - step, z + step];
neiborC8 = [x - step, y - step, z - step];
Nebr = [neiborF1; neiborF2;neiborF3;neiborF4;neiborF5;neiborF6;...
    neiborS1; neiborS2; neiborS3; neiborS4; neiborS5; neiborS6;...
    neiborS7; neiborS8; neiborS9; neiborS10; neiborS11; neiborS12;...
    neiborC1; neiborC2; neiborC3; neiborC4;  neiborC5; neiborC6;...
    neiborC7; neiborC8];
end
%*************************************************************************%
function [Pos, List] = traceSAW(Pos, List)
n = size(Pos,1);
Nebr = NebrSAW(Pos(n,:));
if ismember(Nebr, List, 'rows')
    % IF condition satisfied only if ismember() returns all logical 1
    List = cat(1, List, Pos(n,:));
    Pos(n, :) = [];
    [Pos, List] = traceSAW(Pos, List);
else
    return;
end
end
%*************************************************************************%
function [Pos, Step] = goSAW_random(Pos, Step)
n = size(Pos, 1);   % Number of steps
x = Pos(n, 1);      % x coordinate of the newest step
y = Pos(n, 2);      % y coordinate of the newest step
z = Pos(n, 3);      % z coordinate of the newest step
%-------- Random walk with equal probability in all 26 directions --------%
dice = unidrnd(3);  % Dicing in the range of 1 to 3
if dice == 1
    x = x + 1;
elseif dice == 2
    x = x - 1;
end
dice = unidrnd(3);
if dice == 1
    y = y + 1;
elseif dice == 2
    y = y - 1;
end
dice = unidrnd(3);
if dice == 1
    z = z + 1;
elseif dice == 2
    z = z - 1;
end
%-------------------------------------------------------------------------%
step = [x, y, z] - [Pos(n, 1), Pos(n, 2), Pos(n, 3)];
Step = cat(1, Step, step);
Pos = cat(1, Pos, [x, y, z]); % Concatenate new position along the old one.

end
%*************************************************************************%