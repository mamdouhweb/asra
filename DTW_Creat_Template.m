 % Dynamic Time Warping (DTW)
 % Extructing features of Templates and save them. 
 %
 % veisi@mehr.sharif.edu
 
 clear all;
 close all;
% clf;
 clc;
 Path='Data\Numbers_noisy\';
 %Path='Data\Numbers\';
 Template_List=['3rd','mashroo3','mamdouh','quraan','suar','hadaf','ta5aroj','2rd','aya','2yam'];
 
 Template_MFCC_Features_zero= CMS_Normalization(Feature_Extruction([Path,'3rd.wav']));
 Template_MFCC_Features_one= CMS_Normalization(Feature_Extruction([Path,'mashroo3.wav']));
 Template_MFCC_Features_two= CMS_Normalization(Feature_Extruction([Path,'mamdouh.wav']));
 Template_MFCC_Features_three= CMS_Normalization(Feature_Extruction([Path,'quraan.wav']));
 Template_MFCC_Features_four= CMS_Normalization(Feature_Extruction([Path,'suar.wav']));
 Template_MFCC_Features_five= CMS_Normalization(Feature_Extruction([Path,'hadaf.wav']));
 Template_MFCC_Features_six= CMS_Normalization(Feature_Extruction([Path,'ta5aroj.wav']));
 Template_MFCC_Features_seven= CMS_Normalization(Feature_Extruction([Path,'2rd.wav']));
 Template_MFCC_Features_eight= CMS_Normalization(Feature_Extruction([Path,'aya.wav']));
 Template_MFCC_Features_nine= CMS_Normalization(Feature_Extruction([Path,'2yam.wav']));
 %Template_MFCC_Features_ten= Feature_Extruction('Data\Numbers\ten.wav');
 % CMS_MFCC=CMS_Normalization(MFCC_Features); 
 
 %save Templates.mat
 save Templates_noisy.mat

 clear path 

 

