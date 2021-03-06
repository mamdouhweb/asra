function [Temp_F,Temp_N]=SelectNextTemplate(No)

    % Select the next template and return it's name (Temp_N) and feature vectors (Temp_F)

    load Templates_noisy.mat;
    %load Templates.mat;

    switch(No)
        case {1}
            Temp_F=Template_MFCC_Features_zero;
            Temp_N='3rd';
        case {2}
            Temp_F=Template_MFCC_Features_one;
            Temp_N='mashroo3';
        case {3}
            Temp_F=Template_MFCC_Features_two;
            Temp_N='mamdouh';
        case {4}
            Temp_F=Template_MFCC_Features_three;
            Temp_N='quraan';
        case {5}
            Temp_F=Template_MFCC_Features_four;
            Temp_N='suar';
        case {6}
            Temp_F=Template_MFCC_Features_five;
            Temp_N='hadaf';
        case {7}
            Temp_F=Template_MFCC_Features_six;
            Temp_N='ta5aroj';
        case {8}
            Temp_F=Template_MFCC_Features_seven;
            Temp_N='2rd';
        case {9}
            Temp_F=Template_MFCC_Features_eight;
            Temp_N='aya';
        case {10}
            Temp_F=Template_MFCC_Features_nine;
            Temp_N='2yam';
%         case {11}
%             Temp_F=Template_MFCC_Features_ten;
%             Temp_N='Ten';
        otherwise
            error;
    end
