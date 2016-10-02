% K-MEDOID CLUSTERING ALGORITHM
% INPUTS: DATA MATRIX
%         PARAMETERS: number of clusters

% This is the fastest implementation of K-MEDOIDS based on vectorization

% Based on the K-MEDOID implementation as per the literature (Ward's method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Written and Modified by Archit Harsh (archit.harsh89 AT gmail.com)

function result=kmedoid_rev(data,param);
tic;
c=param.c;
X=data.X;

[N,n]=size(X);

%initialization
if max(size(param.c))==1,
    c = param.c;
    index=randperm(N);
    v=X(index(1:c),:);v = v + 1e-10;
    v0=X(index(1:c)+1,:);v0 = v0 - 1e-10;
else
    v = param.c;    
    c = size(param.c,1);
    index=randperm(N);
    v0=X(index(1:c)+1,:);v0 = v0 + 1e-10;
end   
iter=0;  
while prod(max(abs(v - v0))),
      v0 = v;
     iter =iter+1;
      %mozgats
        %Calculating the distances
         for i = 1:c
            dist(:,i) = sum([(X - repmat(v(i,:),N,1)).^2],2);
         end
        %Assigning clusters
      [m,label] = min(dist');
      distout=sqrt(dist);
      
      %Calculating cluster centers
      for i = 1:c
         index=find(label == i);
         if ~isempty(index)  
             vtemp = mean(X(index,:));
             temp = sum([(X - repmat(vtemp,N,1)).^2],2);
             inx=find(temp==min(temp));
             inx=min(inx); %if there are many points with the minimum distance
             v(i,:)=X(inx,:);
         else 
           v(i,:)=X(round(rand*N-1),:);
         end   
         index=find(label == i);
         f0(index,i)=1;
     end
     J(iter) = sum(sum(f0.*dist));           %calculate objective function  

%            %mozgats
%         %Calculating the distances
%          for i = 1:c
%             dist(:,i) = sum([(X - repmat(v(i,:),N,1)).^2]')';
%          end
%         %Assigning clusters
%       [m,label] = min(dist');
    
%       if param.vis
%        clf
%        hold on
%        colors={'bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+'};
%        for i=1:c
%            index = find(label == i);
%            if ~isempty(index)  
%             dat=X(index,:);
%             plot(dat(:,1),dat(:,2),colors{i})
%            end
%        end    
%        plot(v(:,1),v(:,2),'+k')
%        hold on
% 
%        %tri=delaunay(v(:,1),v(:,2));
%        %triplot(tri,v(:,1),v(:,2))
%        hold off
%        pause(0.1)
%    end  
%     
 end


%results
result.cluster.v = v;
result.data.d = distout;
   %calculate the partition matrix      
f0=zeros(N,c);
   for i=1:c
     index=find(label == i);
     f0(index,i)=1;
   end       
result.data.f=f0;
result.iter = iter;
result.cost = J;
toc;