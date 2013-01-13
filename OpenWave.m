function [TestWave,Fs]=OpenWave

          file=input('    >> Wave file name [Default: ''one.wav'']:','s');
          if strcmp(file,'\n')==0
              file='one.wav';
              disp('        + Default: one.wav');
          elseif findstr(file,'.')==''
              file=strcat(file,'.wav');
          end
          [TestWave,Fs,NBits] = wavread(file);
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
           fprintf('    >> The file is save to "%s"\n', FileName);