function points = bent_tube(r, L, bend_angle, resolution)
% 3D point cloud of two joined truncated cylinders to simulate bent arm

    half_ang = bend_angle/2;   
    
    % base cylinder
    [z, theta] = meshgrid(linspace(-L/2, L/2, resolution), linspace(0, 2*pi, resolution));
    x = r*cos(theta);
    y = r*sin(theta);
    
    % cylinder 1
    n1 = [sind(half_ang), 0, cosd(half_ang)];
    d1 = 0; % passes through origin
    mask1 = n1(1)*x + n1(2)*y + n1(3)*z <= d1;
    P1 = [x(mask1), y(mask1), z(mask1)];
    
    % cylinder 2
    n2 = [-sind(half_ang), 0, cosd(half_ang)];
    d2 = 0;
    mask2 = n2(1)*x + n2(2)*y + n2(3)*z <= d2;
    P2 = [x(mask2), y(mask2), z(mask2)];
    
    % rotate second cylinder about Y-axis
    R = [cosd(bend_angle+180) 0 sind(bend_angle+180);
         0                  1 0;
        -sind(bend_angle+180) 0 cosd(bend_angle+180)];
    P2 = P2 * R.';
    
    % join
    points = [P1; P2];
    scatter3(points(:,1), points(:,2), points(:,3)); axis equal;

end


