%% Author - Manohar Paluri %%
%% Date      - 01/03/2012 %%
%% This file contains code to generate synthetic data from gaussians and
%% uses silhouette to find the best K for k-means and k-medoids clustering
%% and performs the clustering process.

%% Main function
function []  = main()

	% Set parameters
	n = 100;
	k = 3;
	minK  = 1;
	maxK = 5;
	global numIterations;
	numIterations = 1000;
	outputVideo = 'output.avi';
	
	groundtruth(1).mean = [0 0];
	groundtruth(1).variance = [0.5 0.4;0.4 0.5];
	groundtruth(2).mean = [6 6];
	groundtruth(2).variance = [0.8 0.1;0.1 0.8];
	groundtruth(3).mean = [3 3];
	groundtruth(3).variance = [0.5 0.4;0.4 0.5];

	% Generate that many random colors
	global colors;
	colors = rand(maxK,3);

	% Generate data
	data = generateData(groundtruth, n);
	
	% Vectorize the data
	[points groundLabels] = vectorizeData(data);

	% Create a video of the figure
	global aviobj;
	global handle;
	aviobj = avifile('output.avi', 'fps', 1);
	
	% Open a figure
	handle = figure('Position',[0 0 640 480]);
	% Plot input in the first subplot
	subplot(2,4,1), plotPoints(points, groundLabels);
	title('Generated data', 'FontSize', 20);
	addFrame();

	% Find the right K using silhouette
	bestK = findK(points,[minK:maxK]);
	addFrame();
	
	% Cluster data using k-means
	subplot(2,4,5);
	tic;
	[newLabels] = kmeans(points, bestK);
	duration = toc;
	title({'K-means'; [int2str(duration), 'seconds']},'FontSize', 20);
	% Plot k-means similarity
	subplot(2,4,6);
	[s h] = silhouette(points,newLabels);
	title('K-means Silhouette','FontSize', 20);
	addFrame();
	
	% Cluster data using k-medoids
	subplot(2,4,7);
	tic;
	[newLabels] = kmedoids(points, bestK);
	duration = toc;
	title({'K-medoids' ; [int2str(duration), ' seconds' ]},'FontSize', 20);
	% Plot k-medoids similarity
	subplot(2,4,8);
	[s h] = silhouette(points,newLabels);
	title('K-medoids Silhouette','FontSize', 20);
	addFrame();
	
	aviobj = close(aviobj);
	pause;
end

%% Helper functions

% Vectorize the data
function [points, labels] = vectorizeData(data)
	points = [];
	labels = [];
	for i = 1:length(data);
		points = [points;data(i).points];
		labels = [labels;repmat(i,length(data(i).points),1)];
	end
end
	
% Add a frame to the video
function addFrame()
	global handle;
	global aviobj;
	frame = getframe(handle);
	aviobj = addframe(aviobj, frame);
	% In case the output video is flipped comment the above line and
	% uncomment this line
	%aviobj = addframe(aviobj, flipdim(frame.cdata,1));
end
%% Data generation functions

% Generates data with as many clusters and n points in each of them.
% cluster is a cell array with each cell defining a 2 dimensional mean and
% respective covariance matrix
function [data] = generateData(clusters, n)
	for i = 1:length(clusters)
		data(i).points = generateGaussian(n, clusters(i).mean, clusters(i).variance);
		data(i).mean = clusters(i).mean;
		data(i).variance = clusters(i).variance;
	end
end

% Generates n points with mean and variance.
function [data] = generateGaussian(n, mean, variance)
	data = mvnrnd(mean, variance, n);
end

%% Clustering

% K-means clustering
function [labels] = kmeans(points, k)

	global numIterations;
	
	% Initialization
	% Chose k random means & set labels to zeros
	means = rand(k,2);
	labels = zeros(size(length(points),1));
	
	for iteration = 1:numIterations
		
		% Store labels from previous iteration
		prevlabels = labels;
		
		% Assignment step
		for i = 1:length(points)
			point = points(i,:);
			labels(i) = findNearestPointIndex(point,means);
		end

		% Plot iteration
		plotPoints(points, labels);

		% Break from the loop if there labels dont change
		if isequal(labels, prevlabels)
			break;
		end
		
		% Update step
		means = zeros(k,2);
		counts = zeros(k,1);
		for i = 1:length(points)
			%*************** ERROR: Potential overflow ***************%
			means(labels(i),:) = means(labels(i),:) + points(i,:);
			counts(labels(i)) = counts(labels(i)) + 1;
		end
		means = means./repmat(counts,1,2);
	end
end

% K-medoids clustering
function [labels] = kmedoids(points, k)

	global numIterations;

	% Initialize the k medoids from the data
	medoidIndices = floor(rand(1,k)*length(points)+1);
	medoids = points(medoidIndices,:);
	labels = zeros(length(points),1);
	for iteration = 1:numIterations
		
		prevmedoids = medoids;
		% Assignment step
		for i = 1:length(points)
			point = points(i,:);
			labels(i) = findNearestPointIndex(point,medoids);
		end
		
		% Swap medoid step
		% Iterate over medoids
		for i = 1:k
			% Get all points that this medoid is closest to
			temppoints = points(find(labels==i),:);
			% Compute cost with the present medoid
			mincost = sum(sum(power((temppoints - repmat(medoids(i,:),size(temppoints,1),1)),2)));
			% For each non-medoid point
			for j = 1:length(temppoints)
				% Swap medoid and the point and compute the cost
				cost = sum(sum(power((temppoints - repmat(temppoints(j,:),size(temppoints,1),1)),2)));
				% If cost is less than miconst swap the medoid with the
				% current point
				if cost < mincost
					mincost = cost;
					medoids(i,:) = temppoints(j,:);
				end
			end
		end
		
		% Plot iteration
		plotPoints(points, labels);

		% If the medoids dont change break from the loop
		if isequal(medoids, prevmedoids)
			break;
		end	
		
	end
end

% Find the index of the nearest point in the data to the given point
function [label] = findNearestPointIndex(point, data)
	[minvalue minindex] = min(sum(power((data - repmat(point,size(data,1),1)),2),2));
	label = minindex;
end

%% Silhouette(clustering) functions

% Find the right K
function bestK = findK(points, range)

	% Set the least possible value to maxCost
	maxSimilarity = -Inf;
	bestK = 0;
	
	% Iterate over possible K values
	for k = 1:length(range)
		subplot(2,4,2);
		title(['Trying K=', int2str(k)], 'FontSize', 20);
		labels = kmedoids(points, k);
		s = silhouette(points, labels, 'sqeuclid');
		storedlabels(k).labels = labels;
		similarity = sum(s);
		if similarity > maxSimilarity
			maxSimilarity = similarity;
			bestK = k;
		end
	end
	
	% Plot three figures, for k values bestK-1, bestK, bestK+1
	subplot(2,4,2);
	[s h] = silhouette(points, storedlabels(bestK-1).labels);
	title(['Silhouette for K=', int2str(bestK-1)], 'FontSize', 20);
	subplot(2,4,3);
	[s h] = silhouette(points, storedlabels(bestK).labels);
	title(['Silhouette for K=', int2str(bestK)], 'FontSize', 20);
	subplot(2,4,4);
	[s h] = silhouette(points, storedlabels(bestK+1).labels);
	title(['Silhouette for K=', int2str(bestK+1)], 'FontSize', 20);
	
end


%% Plot functions

% Plots data in different colors according to the given labels
function plotPoints(points, labels)

	% Using a global variable for colors
	global colors;

	% Get the number of unique labels
	uniqueLabels = unique(labels);

	% Figure1 for showing the input data
	hold on;
	for i = 1:length(points)
		plot(points(i,1), points(i,2), 'Color',colors(labels(i),:),  ...
			'Marker','.', 'LineStyle','none', 'MarkerSize', 15);
	end
	hold off
	drawnow;
	addFrame();
	pause(0.01);
end