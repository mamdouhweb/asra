
 
 clear all;
 close all;
% clf;
 clc;
 

disp(' ');
disp('                       ASRA Project               ');
disp('           by Mamdoouh Al Ramadan, 21-June-2011');
disp( '---------------------------------------------------------');
Select=input('    >> Record or Open wave [Default=Enter=Open]? (R/O)','s');
switch Select
    case {'R','r'}
        Option='Record_mode';
    case {'O', 'o'}
        Option='Open_mode';
    otherwise
        Option='Default_mode';
end
Main_DTW(Option);

clear Select Option
        