% PLOTTING FUNCTION FOR GM
% % Written and Modified by Archit Harsh (archit.harsh89 AT gmail.com)

function Plot_GM(X,k,W,M,V)
[n,d] = size(X);
% if d>2,
%     disp('Can only plot 1 or 2 dimensional applications!/n');
%     return
% end
S = zeros(d,k);
R1 = zeros(d,k);
R2 = zeros(d,k);
[n,d] = size(X);
% [Ci,C] = kmeans(X,k,'Start','cluster', ...
%     'Maxiter',500, ...
%     'EmptyAction','drop');
%     % Ci(nx1) - cluster indeices; C(k,d) - cluster centroid (i.e. mean)
% while sum(isnan(C))>0,
%     [Ci,C] = kmeans(X,k,'Start','cluster', ...
%         'Maxiter',500, ...
%         'EmptyAction','drop');        
% end
for i=1:k,  % Determine plot range as 4 x standard deviations
    S(:,i) = sqrt(diag(V(:,:,i)));
    R1(:,i) = M(:,i)-4*S(:,i);
    R2(:,i) = M(:,i)+4*S(:,i);
end
Rmin = min(min(R1));
Rmax = max(max(R2));
R = [Rmin:0.001*(Rmax-Rmin):Rmax];
clf, hold on
if d==1,
    Q = zeros(size(R));
    for i=1:k,
        P = W(i)*normpdf(R,M(:,i),sqrt(V(:,:,i)));
        Q = Q + P;
        plot(R,P,'r-'); grid on,
    end
    plot(R,Q,'k-');
    xlabel('X');
    ylabel('Probability density');
else % d==2
    co = 'brgmcyk';
    pt = {'bs','r^','md','go','c+','rs','m^','gd','co','b+','gs','b^','rd','bo','g+','ms'};
    lc = length(co);
%     for j=1:k,
%     plot(X(Ci==j,1),X(Ci==j,2),pt{j});
%     end

plot(X(:,1),X(:,2),'r.');
    for i=1:k,
        Plot_Std_Ellipse(M(:,i),V(:,:,i));
    end
    xlabel('1^{st} dimension');
    ylabel('2^{nd} dimension');
    axis([Rmin Rmax Rmin Rmax])
end
title('Gaussian Mixture estimated by EM');
 %fig2plotly();