
 % Test Feature_Extraction function
 
 clear all;
 close all;
% clf;
 clc;
 
 InWave='sm1_cln.wav';
 Fs=8000;
 Duration=2; % in seconds
 %InWave=Record(Fs,Duration); % record a wave file in Fs Hz, with Duration seconds duration
 MFCC_Featurs= Feature_Extruction(InWave,Fs);
% CMS_MFCC=CMS_Normalization(MFCC_Featurs); 
 
 clear InWave Fs  Duration;
