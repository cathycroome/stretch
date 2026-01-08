function points = generate_pumpkin(n_points)
% 3D point cloud of a pumpkin shape
%   n_points: number of surface points (e.g. 5000)

if nargin < 1, n_points = 5000; end

% spherical coordinates
theta = 2*pi*rand(n_points,1);     
phi   = acos(2*rand(n_points,1)-1);

% squashed sphere
a = 1; b = 1; c = 0.7;
r = 1 + 0.1*sin(8*theta);  % ridges

x = a * r .* sin(phi).*cos(theta);
y = b * r .* sin(phi).*sin(theta);
z = c * r .* cos(phi);

% add a small stem
n_stem = round(0.05*n_points);
theta_s = 2*pi*rand(n_stem,1);
r_s = 0.15*sqrt(rand(n_stem,1));
z_s = 0.7 + 0.2*rand(n_stem,1);
x_s = r_s.*cos(theta_s);
y_s = r_s.*sin(theta_s);

body = [x y z];
stem = [x_s y_s z_s];

% plot
scatter3(body(:,1), body(:,2), body(:,3), 8, body(:,3), 'filled'); 
hold on
scatter3(stem(:,1), stem(:,2), stem(:,3), 10, [0, 0.6, 0], 'filled'); % green
hold off
axis equal off
colormap(autumn)

% combine 
points = [body; stem];

end
