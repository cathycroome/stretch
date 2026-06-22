function [Epc1, Epc2] = load_epc(face_type)

    base_dir = '/Users/cathycroome/data/stretch/face';

    switch face_type
        case 'puff_unstretched'
            subdir = 'puff';
            idx = 1;

        case 'puff_stretched'
            subdir = 'puff';
            idx = 5;

        case 'pout_unstretched'
            subdir = 'pout';
            idx = 1;

        case 'pout_stretched'
            subdir = 'pout';
            idx = 5;

        case 'smile_unstretched'
            subdir = 'smile';
            idx = 1;

        case 'smile_stretched'
            subdir = 'smile';
            idx = 5;

        case 'open_unstretched'
            subdir = 'open';
            idx = 1;

        case 'open_stretched'
            subdir = 'open';
            idx = 5;

        otherwise
            error('Unknown shape type');
    end

    % full path
    data_file = fullfile(base_dir, subdir, 'pp04', 'DIC3DPPresults.mat');

    load(data_file, 'DIC3DPPresults');
    Epc1 = DIC3DPPresults.Deform.Epc1{5};
    Epc2 = DIC3DPPresults.Deform.Epc2{idx};

    size(DIC3DPPresults.Deform.Epc1)
    class(DIC3DPPresults.Deform.Epc1)

 %   Epc1(any(isnan(Epc1), 2), :) = [];
 %   Epc2(any(isnan(Epc2), 2), :) = [];

end
