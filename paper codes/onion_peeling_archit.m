% CONVEX ONION PEELING ALGORITHM
% Based on the onion-peeling algorithm given by Graham Scan (Ologn) method, used convhull Matlab implementation

% Written and modified by Archit Harsh
% Work published in IJCA 


function demoOnionPeeling(varargin)

x=load('data')


hull = convhull(x);
hull

plot(x(1,:),x(2,:),'b.');
hold on;
% display
plot(x(hull),'r-','linewidth',2);
hold on;





%% Onion peeling



% initialize array of hulls
layers = {};

nLayers = 0;
points1=points';


% remove convex hull of the current set of points, and iterates until there
% is no more point on the hull
while size(points1, 1) > 2

    % compute current layer
    [hull inds] = convhull(x');

    hull
    inds

    % add a layer
    nLayers = nLayers + 1;

    layers{nLayers} = hull; %#ok
    inds=logical(inds);

    % remove vertices of the convex hull
    points1(inds, :) = [];

end

nLayers

% draw resulting layers
for i = 1:length(nLayers)

    plot(x1(nLayers(i)),x2(nLayers(i)),'r-');

end
