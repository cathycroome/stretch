function points = load_data(face_type)

    base_dir = '/Users/cathycroome/data/stretch/face';

    switch face_type
        case 'puff_unstretched'
            subdir = 'puff';
            idx = {1,1};

        case 'puff_stretched'
            subdir = 'puff';
            idx = {1,5};

        case 'pout_unstretched'
            subdir = 'pout';
            idx = {1,1};

        case 'pout_stretched'
            subdir = 'pout';
            idx = {1,5};

        case 'smile_unstretched'
            subdir = 'smile';
            idx = {1,1};

        case 'smile_stretched'
            subdir = 'smile';
            idx = {1,5};

        case 'open_unstretched'
            subdir = 'open';
            idx = {1,1};

        case 'open_stretched'
            subdir = 'open';
            idx = {1,5};

        otherwise
            error('Unknown shape type');
    end

    % full path
    data_file = fullfile(base_dir, subdir, 'pp04', 'DIC3DPPresults.mat');

    load(data_file, 'DIC3DPPresults');
    points = DIC3DPPresults.Points3D{idx{:}};

    points(any(isnan(points), 2), :) = [];

end
