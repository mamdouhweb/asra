 % Dynamic Time Warping (DTW)
 
 
function Main_DTW(Option)
 
%  clear all;
%  close all;
% % clf;
%  clc;
 
%  load Templates.mat;
%  No_Templates=length(Template_List);
 No_Templates=10; % from 0 to 9
 
 %TestWave='Data\Numbers_noisy\one.wav';
 switch Option
     case {'Record_mode'}
         Fs=16000;
         Duration=2; % in seconds
         TestWave=Record(Fs,Duration); % record a wave file in Fs Hz, with Duration seconds duration         
     case {'Open_mode'}
          [TestWave,Fs]=OpenWave; %  Open a wanted wave file          
      otherwise
           disp('        + Default: one.wav');        
           TestWaveName='one.wav';
           [TestWave,Fs,NBits] = wavread(TestWaveName);
           wavplay(TestWave, Fs, 'sync');      
           % ===== Plot recorded waveform
           %hold on
           plot(TestWave,'b--');
           title('Recorded wave file');
           %axis([0 Duration min(Out) max(Out)]);
           grid on
           %hold off
           % ==== Save recorded file
           FileName = 'Test.wav';
           wavwrite(TestWave, Fs, 8, FileName);
           fprintf('    >> The file is saved to "%s"\n', FileName);
  end
  
disp( '=========================================================');
disp('  Start recognizing by DTW (39 CMS-MFCC features)... ');
  
Test_MFCC_Features= CMS_Normalization(Feature_Extruction(TestWave,Fs));
% CMS_MFCC=CMS_Normalization(MFCC_Features); 
 for i=1:No_Templates       
       [Template_MFCC_Features,Template_Name]=SelectNextTemplate(i);
      % Construct the 'local match' scores matrix as the cosine distance between the featurs
       Local_Distance = LocalDistance(abs(Template_MFCC_Features),abs(Test_MFCC_Features));
       
       % Find the lowest-cost path across Local_Distance matrix
       [Path_y,Path_x,Distance] = DTW(Local_Distance);
    
       % Least cost (final cost) is value in top right corner of Distance matrix
       Distance_from_Template(i)=Distance(1,size(Distance,2));
       if i>1
           if Distance_from_Template(i)<Answer_DistanceFrom
               Answer_Name=Template_Name;
               Answer_Distance=Distance;
               Answer_Path_x=Path_x;
               Answer_Path_y=Path_y;
               Answer_DistanceFrom=Distance_from_Template(i);
           end
       else
           Answer_Name=Template_Name;
           Answer_Distance=Distance;
           Answer_Path_x=Path_x;
           Answer_Path_y=Path_y;
           Answer_DistanceFrom=Distance_from_Template(i);
       end
       
       % Plot the min cost path though Distance matrix for all Templates
       colormap(1-gray);
       subplot(2,5,i);
       imagesc(Distance)
       hold on; plot(Path_x,Path_y,'r'); hold off
       str=['DTW for ',Template_Name,' ,Distance= ',num2str(Distance_from_Template(i))];
       title(Template_Name);
      
   end
   
   % Plot the min cost path though Distance matrix for Answer (Template with MIN final cost)   
   figure(2);
   colormap('jet');   
   imagesc(Answer_Distance)
   hold on; plot(Answer_Path_x,Answer_Path_y,'r'); hold off
   str=['Answer is: ',Answer_Name,' ,Distance= ',num2str(Answer_DistanceFrom)];
   title(str);
   disp(['  It seems that answer is: <<',Answer_Name,'>>, isn''t it :=# ?']);

   % clear dummy variables
    clear TestWave Fs  Duration Template_List No_Templates i str Path_y Path_x Template_MFCC_Features Template_Name Local_Distance Distance Test_MFCC_Features %Distance_from_Template
    clear Template_MFCC_Features_zero Template_MFCC_Features_one Template_MFCC_Features_two Template_MFCC_Features_three Template_MFCC_Features_four 
    clear Template_MFCC_Features_five Template_MFCC_Features_six Template_MFCC_Features_seven Template_MFCC_Features_eight Template_MFCC_Features_nine %Template_MFCC_Features_ten
