function points = generate_3D_surface(shape_type,resolution)

% make 2D grid with specified resolution
[x, y] = meshgrid(linspace(-5, 5, resolution), linspace(-5, 5, resolution));

    switch shape_type
        case 'bump' 
            r = sqrt(x.^2 + y.^2)/2;
            z = 3*exp(-r.^2); 
            points = [x(:), y(:), z(:)]; 
         
        case 'sinusoidal'
            z = sin(0.5 * x) .* cos(0.5 * y);  
            points = [x(:), y(:), z(:)];

        case 'tube'
            r = 1;            % radius
            L = 5;            % cylinder length before truncation
            bend_angle = 60;  % total bend (degrees)
            points = bent_tube(r, L, bend_angle, resolution);

        case 'tube_stretch'
            r = 1;            % radius
            L = 5;            % cylinder length before truncation
            bend_angle = 70;  % total bend (degrees)
            stretch_strength = 3;
            points = bent_tube_stretched(r, L, bend_angle, resolution, stretch_strength);

        case 'valley'
            a = 0.6;                        
            b = 10;                         
            z = a*x.^2 .* exp(-(y.^2)/b^2); 
            points = [x(:), y(:), z(:)];
        
        case 'pumpkin'
            n = resolution^2; 
            points = generate_pumpkin(n);

        case 'stretched_pumpkin'
            n = resolution^2; 
            points = generate_pumpkin_stretched(n, 3);  % 2x taller pumpkin

        otherwise
            error('Unknown shape type');
    end

end