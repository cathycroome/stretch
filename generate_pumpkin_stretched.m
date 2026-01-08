function points = generate_pumpkin_stretched(n_points, stretch_factor)
% 3D point cloud of a vertically stretched pumpkin
%   n_points: number of surface points (e.g. 5000)
%   stretch_factor: multiplier for vertical stretch (e.g. 1.5 for taller pumpkin)

if nargin < 1, n_points = 5000; end
if nargin < 2, stretch_factor = 1.5; end  % default 1.5x taller

% spherical coordinates
theta = 2*pi*rand(n_points,1);     % azimuth
phi   = acos(2*rand(n_points,1)-1);% polar angle

% squashed sphere
a = 1; b = 1; c = 0.7;
r = 1 + 0.1*sin(8*theta);  % ridges

x = a * r .* sin(phi).*cos(theta);
y = b * r .* sin(phi).*sin(theta);
z = c * r .* cos(phi);

% apply vertical stretch
z = z * stretch_factor;

% add a small stem (shifted upward)
n_stem = round(0.05*n_points);
theta_s = 2*pi*rand(n_stem,1);
r_s = 0.15*sqrt(rand(n_stem,1));
z_s = (c * stretch_factor) + 0.2*rand(n_stem,1);
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
title(sprintf('Stretched pumpkin (%.1fx vertical)', stretch_factor))

% combine
points = [body; stem];

end
