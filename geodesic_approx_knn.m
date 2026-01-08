function geodesic_distances = geodesic_approx_knn(points, k, check)
%   takes input of 3D surface
%   calculates geodesic distance approximation using shortest path (Dijkstra)
%   outputs the geodesic distance matrix and visualisations

% 1. Calculate k-nearest neighbours
%   idx(i, :) contains the indices of the k+1 closest neighbors to point i
%   dist(i, :) contains the corresponding Euclidean distances

[idx, dist] = knnsearch(points, points, 'K', k+1);  % find k+1 nearest neighbours (including point itself)
dist(:, 1) = 0;                                     % remove self-connections

% 2. Calculate edges and weights 
%   edges stores pairs of connected points (each node to kNN)
%   weights stores the Euclidean distance between connected points

num_points = size(points, 1);
edges = zeros(num_points * k, 2); 
weights = zeros(num_points * k, 1);

row_idx = 1;
for i = 1:num_points
    for j = 2:k+1  % skip the first neighbour (the point itself)
        edges(row_idx, :) = [i, idx(i, j)];
        p1 = points(i, :);
        p2 = points(idx(i, j), :);
        weights(row_idx) = norm(p1 - p2);  % 3D Euclidean distance
        row_idx = row_idx + 1;
    end
end

% 3. Geodesic distance approximation
G = graph(edges(:,1), edges(:,2), weights); % create graph with edge weights
geodesic_distances = distances(G); 


%------ Visual sense check geodesic distances being calc'ed right -------

if check == 'Y'

    % from one node
    start_node = 677;  % starting point in the graph
    geo_distances_one_node = distances(G, start_node);  % compute shortest path from start_node to every node
    
    figure('Units','normalized','Position',[0.2 0.2 0.9 0.75]); 

    hold on;
    scatter3(points(:,1), points(:,2), points(:,3), 50, geo_distances_one_node(:), 'filled'); 
    scatter3(points(start_node,1), points(start_node,2), points(start_node,3), 150, 'r', 'filled', 'MarkerEdgeColor', 'k'); % Highlight start node
    colormap jet; colorbar; 
    title('Geodesic distances from highighted node');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view(3); axis equal; grid on;
    hold off;

end
end
