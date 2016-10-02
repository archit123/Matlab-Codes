        % OUTLIER DETECTION and REMOVAL METHOD 
		%Based on the six sigma outlier detection approach (outliers three or more deviations away are deemed as potential outliers)
		% tested on KDDCUP dataset 
		% Steps:
		%       load Data
		%       Find Features
		%       Dimensionality Reduction
		%       Outlier Detection
		
		% Written and modified by Archit Harsh
		
		
		%load data
        % read the list of features
        fid = fopen('kddcup.names','rt');
        C = textscan(fid, '%s %s', 'Delimiter',':', 'HeaderLines',1);
        fclose(fid);

        %# determine type of features
        C{2} = regexprep(C{2}, '.$','');              %# remove "." at the end
        attribNom = [ismember(C{2},'symbolic');true]; %# nominal features

        %# build format string used to read/parse the actual data
        frmt = cell(1,numel(C{1}));
        frmt( ismember(C{2},'continuous') ) = {'%f'}; %# numeric features: read as number
        frmt( ismember(C{2},'symbolic') ) = {'%s'};   %# nominal features: read as string
        frmt = [frmt{:}];
        frmt = [frmt '%s'];                           %# add the class attribute

        %# read dataset
        fid = fopen('data','rt');
        C = textscan(fid, frmt, 'Delimiter',',');
        fclose(fid);

        %# convert nominal attributes to numeric
        ind = find(attribNom);
        G = cell(numel(ind),1);
        for i=1:numel(ind)
            [C{ind(i)},G{i}] = grp2idx( C{ind(i)} );
        end

        %# all numeric dataset
        fulldata = cell2mat(C);
        % dimensionality reduction 
%% dimensionality reduction 
columns = 6
[U,S,V]=svds(fulldata,columns);

%% randomly select dataset
rows = 1000;
columns = 6;

%# pick random rows
indX = randperm( size(fulldata,1) );
indX = indX(1:rows)';

%# pick random columns
indY = indY(1:columns);

%# filter data
data = U(indX,indY);

% apply normalization method to every cell
maxData = max(max(data));
minData = min(min(data));
data = ((data-minData)./(maxData));

% output matching data
dataSample = fulldata(indX, :)

%% When an outlier is considered to be more than three standard deviations away from the mean, use the following syntax to determine the number of outliers in each column of the count matrix:

mu = mean(data)
sigma = std(data)
[n,p] = size(data);
% Create a matrix of mean values by replicating the mu vector for n rows
MeanMat = repmat(mu,n,1);
% Create a matrix of standard deviation values by replicating the sigma vector for n rows
SigmaMat = repmat(sigma,n,1);
% Create a matrix of zeros and ones, where ones indicate the location of outliers
outliers = abs(data - MeanMat) > 2.5*SigmaMat;
% Calculate the number of outliers in each column
nout = sum(outliers) 
% To remove an entire row of data containing the outlier
data(any(outliers,2),:) = [];

%% generate sample data
K = 6;
numObservarations = size(data, 1);
dimensions = 3;




