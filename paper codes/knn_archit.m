% K-NN (k-Nearest Neighbour algorithm) 
% Based on K-NN search implemented in MATLAB

% SEE ALSO: KNNsearch

%Written and Modified by Archit Harsh



load data;
x = data(1:300,:); % all rows 
gscatter(x(:,1),x(:,2))
legend('Location','best');
newpoint=[-0.47 0.3];
line(newpoint(1),newpoint(2),'marker','x','color','k',...
   'markersize',10,'linewidth',2)
[n,d] = knnsearch(x,newpoint,'k',5);
line(x(n,1),x(n,2),'color',[.5 .5 .5],'marker','o',...
    'linestyle','none','markersize',10)
xlim([4.5 5.5]);
ylim([1 2]);
axis square
ctr = newpoint - d(end);
diameter = 2*d(end);
% Draw a circle around the 10 nearest neighbors.
h = rectangle('position',[ctr,diameter,diameter],'curvature',[1 1]);
h.LineStyle = ':';
newpoint2 = [5 1.45;6 2;2 1];
gscatter(x(:,1),x(:,2),species)

[n2,d2] = knnsearch(x,newpoint2,'k',10);
line(x(n2,1),x(n2,2),'color',[.5 .5 .5],'marker','o',...
   'linestyle','none','markersize',10)
line(newpoint2(:,1),newpoint2(:,2),'marker','x','color','k',...
   'markersize',10,'linewidth',2,'linestyle','none')