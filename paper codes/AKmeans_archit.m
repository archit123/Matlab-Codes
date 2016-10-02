% AUTOMATIC K-MEANS ALGORITHM BASED ON THE LITE-KMEANS IMPLEMENTATION
% This algorithm calculates the optimum number of clusters based on the internal cluster validity metrics 

% Written and Modified by Archit Harsh (archit.harsh89 AT gmail.com)


clear all; 
[file,filePath] = uigetfile('*.txt');
if isequal(file, 0)
return;
end
dname = [filePath file];
%  tic;
try
a = load(dname);
catch
set(handles.Outext1, 'String', 'Running state: incorrect data file !');
return
end;
tic;
%a=data;
%  a(:,3)=[]; 
  %a(:,11)=[];
 
 co = 'brgmcyk';
pt = {'bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+','ms','c^','cd','mo','m+','g+','gs','b^','rd','bo','g+','ms','c^','cd','mo','m+','g+'};
lc = length(co);
[n,p]= size(a);

k=sqrt(n);
%optional steps
%for i=1:10
%    [~,~,sumD]=litekmeans(a,i,'emptyaction','singleton');
%    totsum(i)=sum(sumD);
%end
%plot(totsum);
%fig2plotly();

% figure;
m=init(a,k);
%opts=statset('Display','iter');
[idx,m] = litekmeans(a,k,'start',m,'emptyaction','singleton');
ko=k;
CHo= vCH(a,idx);
idxo=idx;
while k>2
[mD,id] =min(arrayfun(@(j) length(find(idx==j)),1:k));
m(id(1),:)=[];
k=k-1;
[idx,m] = litekmeans(a,k,'start',m,'emptyaction','singleton');
CH= vCH(a,idx);
if CHo<CH
CHo=CH;
ko=k;
idxo=idx;
end;
end
k=ko;
idx=idxo;
[s,h] = silhouette(a,idx);
figure;
totsum=zeros(k);

for j=1:k
plot(a(idx==j,1),a(idx==j,2),pt{j},'MarkerSize',5);
hold on
end
%fig2plotly();
si0= mean(s);
disp(si0)
disp(k)
%fig2plotly();
toc;