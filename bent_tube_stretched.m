function points = bent_tube_stretched(r, L, bend_angle, resolution, stretch_strength)
% 3D point cloud of two joined truncated cylinders to simulate bent arm
% reduced point density around truncation join on the longer side (outer 
% elbow) to simulate skin stretch
% ! Used cGPT to reduce point density in certain areas, evaluated visually !

    half_ang = bend_angle/2;   
    
    % base cylinder
    [z, theta] = meshgrid(linspace(-L/2, L/2, resolution), linspace(0, 2*pi, resolution));
    x = r*cos(theta);
    y = r*sin(theta);

    % truncation planes
    n1 = [sind(half_ang), 0, cosd(half_ang)];
    n2 = [-sind(half_ang), 0, cosd(half_ang)];
    mask1 = n1(1)*x + n1(2)*y + n1(3)*z <= 0;
    mask2 = n2(1)*x + n2(2)*y + n2(3)*z <= 0;

    % separate cylinders
    x1 = x; y1 = y; z1 = z;
    x2 = x; y2 = y; z2 = z;
    x1(~mask1) = NaN; y1(~mask1) = NaN; z1(~mask1) = NaN;
    x2(~mask2) = NaN; y2(~mask2) = NaN; z2(~mask2) = NaN;

    % mean column height
    heights = zeros(1,resolution);
    for i = 1:resolution
        valid = ~isnan(z1(i,:));
        if any(valid)
            heights(i) = max(z1(i,valid)) - min(z1(i,valid));
        end
    end
    mean_height = mean(heights(heights>0));

    % parameters for variable sampling
    base_n = resolution;          % baseline number of z-samples for short/normal columns
    min_n  = 4;                   % minimum samples for very tall columns
    power  = stretch_strength;    % how strongly sample count falls with height

    % Build new point lists by re-sampling each column individually
    P_all = []; % accumulate points here

    for which_half = 1:2
        if which_half == 1
            xm = x1; ym = y1; zm = z1;
        else
            xm = x2; ym = y2; zm = z2;
        end

        for i = 1:resolution
            valid = ~isnan(zm(i,:));
            if ~any(valid)
                continue;
            end
            zcol = zm(i,valid);
            zmin = min(zcol); zmax = max(zcol);
            height = zmax - zmin;

            % Decide number of samples for this column:
            % - If column is shorter than or equal to mean, keep baseline density
            % - If taller, reduce samples proportional to (height/mean_height)^power
            if height <= mean_height || mean_height == 0
                n_samples = base_n;
            else
                % Reduce samples for taller columns
                scale = (height / mean_height) ^ power;      % >1 for tall columns
                n_samples = round(base_n / scale);
                n_samples = max(n_samples, min_n);           % never below min_n
            end

            % Create z positions with linear spacing across the column
            z_new = linspace(zmin, zmax, n_samples);

            % For this angular column, original theta positions are at the same angle
            % We use the same x,y for each z sample (i.e., along the column)
            x_base = xm(i,find(valid,1)); % column's x coordinate (all valid entries are same theta)
            y_base = ym(i,find(valid,1));

            % Append points for this column
            col_pts = [repmat(x_base, n_samples, 1), repmat(y_base, n_samples, 1), z_new(:)];
            P_all = [P_all; col_pts];
        end
    end

    % Rebuild P1 and P2 by selecting points according to mask1 and mask2    
    P1 = []; P2 = [];
    for idx = 1:size(P_all,1)
        pt = P_all(idx,:);
        % check which truncation plane kept this (evaluate against plane equations using point)
        if n1(1)*pt(1) + n1(2)*pt(2) + n1(3)*pt(3) <= 0
            P1 = [P1; pt];
        end
        if n2(1)*pt(1) + n2(2)*pt(2) + n2(3)*pt(3) <= 0
            P2 = [P2; pt];
        end
    end

    % Rotate second half by bend_angle like original
    R = [cosd(bend_angle+180) 0 sind(bend_angle+180);
         0 1 0;
        -sind(bend_angle+180) 0 cosd(bend_angle+180)];
    P2 = P2 * R.';

    points = [P1; P2];

    % Visualize
    % scatter3(points(:,1), points(:,2), points(:,3), 8, points(:,3), 'filled');
    % axis equal;
    % xlabel x; ylabel y; zlabel z;
    % title(sprintf('Bent tube with tall-columns downsampled (strength=%.2f)', stretch_strength));
end
