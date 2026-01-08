clc; clear; close all;

%% 1. Use generated (1a) or loaded (1b) data and choose shape

% 1a. Choose 3D surface to generate (bump/tube/tube_stretch/valley)
resolution = 40;
shape_type = 'tube_stretch';
points = generate_3D_surface(shape_type,resolution);

% 1b. Choose 3D surface to load (puff/pout/smile/open, unstretched/stretched)
% face_type = 'open_unstretched';
% points = load_data(face_type);

%% 2. Choose geodesic approximation and output distance matrix

k = 10;      % choose number of nearest neighbours for shortest path & geodesic approximation
check = 'Y'; % 'Y' for visual check
geodesic_distances = geodesic_approx_knn(points, k, check); 

%% 3. Reconstruct surface - choose method

% 3a. Classic MDS 
[embedding,stress] = mdscale(geodesic_distances, 3, 'Criterion', 'strain'); 

% 3b. Metric MDS 
% [embedding,stress] = mdscale(geodesic_distances, 3, 'Criterion', 'metricstress', Start='random'); 

% 3c. Non-metric MDS 
% [embedding,stress] = mdscale(geodesic_distances, 3, 'Criterion', 'stress'); 

% 3d. Metric MDS with Sammon mapping
% geodesic_distances(~eye(size(geodesic_distances)) & geodesic_distances==0) = eps;   % replace off-diagonal zeros with tiny positive number
% [embedding,stress] = mdscale(geodesic_distances, 3, 'Criterion', 'sammon'); 

%% 4. Visualise the reconstructed 3D surface

figure;
scatter3(embedding(:,1), embedding(:,2), embedding(:,3), 50, 'filled');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
title('Reconstructed 3D Surface');

%% 5. Procrustes

[d, Z, transform] = procrustes (points, embedding);

% compute per-point Euclidean error
errors = sqrt(sum((Z - points).^2, 2));

% visualise error
figure;
scatter3(Z(:,1), Z(:,2), Z(:,3), 50, errors, 'filled');
axis equal
colorbar
title('Procrustes alignment error');

% heatmap
figure;
scatter(Z(:,1), Z(:,2), 50, errors, 'filled');
axis equal
view(2)
colorbar
title('Alignment error heatmap');
xlabel('X'); ylabel('Y');


