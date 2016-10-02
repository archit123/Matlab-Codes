%CH index calculation

% Written and Modified by Archit Harsh (archit.harsh89 AT gmail.com)


function [CH] = vCH(data,labels)
[nrow,nc] = size(data);
labels = double(labels);
k=max(labels);
[sw,sb] = v_sumsqures(data,labels,k);

ssw = trace(sw);
ssb = trace(sb);
if k > 1
CH = ssb/(k-1);
else
CH =ssb;
end
CH = (nrow-k)*CH/ssw;