% PLOTSPHERE Plot one sphere on the current axis.
% This plot a volumetric sphere.
%
% plotSphere( centers, radius, color, alpha )
%
% Inputs:
%   centers - Center point of the sphere to plot.
%   radius - The radius of the arrow shaft cylinder.
%   color - Color of the sphere.
%   alpha - Matlab transparency factor for plotted object.
% 
% Outputs:
%   None - Plot the sphere on the current axis
%
% See also PLOTBONELANDMARKS, PLOTSPHERE.
%
%-------------------------------------------------------------------------%
%  Author:   Jean-Baptiste Renault
%  Copyright 2020 Jean-Baptiste Renault
%-------------------------------------------------------------------------%
function plotSphere( center, radius, color, alpha )
    
    if nargin <2
        color='c';
        r=10;
        alpha = 1;
    end

    if nargin <3
        color='c';
        alpha = 1;
    end

    if nargin <4
        alpha = 1;
    end

    % [LM] added check
    if size(center,1)>size(center,2) && size(center,1)==3
        center = center';
    end

    [x,y,z] = sphere(50);
    x0 = center(1); y0 = center(2); z0 = center(3);
    x = x*radius+ x0;
    y = y*radius+ y0;
    z = z*radius+ z0;

    hold on
    surface(x,y,z,'FaceColor', color ,'EdgeColor','none','FaceAlpha',alpha,'EdgeAlpha',min(1,alpha*2.5))
    hold on

end

