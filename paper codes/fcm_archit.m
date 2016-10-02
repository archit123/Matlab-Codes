% FCM CLUSTERING ALGORITHM
% INPUTS: DATA: data matrix
%         nc: Number of clusters
%Based on the FCM implementation in MATLAB
% See Also: FCM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Written and Modified by Archit Harsh (archit.harsh89 AT gmail.com)


[centers, U]=fcm(data,nc);

maxu=max(U);
clf
hold on
colors={'bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+'};
       
for i=1:nc
    index=find(U(i,:)==maxu);
    if ~isempty(index)  
            dat=data(index,:);
            plot(dat(:,1),dat(:,2),colors{i})
    end
end    
       plot(centers(:,1),centers(:,2),'+k')
       hold on

       %tri=delaunay(v(:,1),v(:,2));
       %triplot(tri,v(:,1),v(:,2))
       hold off