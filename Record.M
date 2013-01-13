function Out=Record(Fs,Duration)

    % Record a Fs Hz, mono wave file from microphone with Duration second(s)
    %
    % veisi@mehr.sharif.edu
    
    fprintf('    Recording %g-second wave (Press a key to start)...\n', Duration);
    pause;
    fprintf('    >> Start recording ...\n');
    Out = wavrecord(Duration*Fs,Fs, 'uint8');
    fprintf('    >> Finish %g-second of recording.\n', Duration);
    
    % ==== Play recirded file
    Out = (double(Out)-128)/128;
    wavplay(Out, Fs, 'sync');

    % ===== Plot recorded waveform
    %hold on
    plot((1:Duration*Fs)/Fs, Out,'b--');
    title('Recorded wave file');
    %axis([0 Duration min(Out) max(Out)]);
    grid on
    %hold off
    
    % ==== Save recorded file
    FileName = 'suar.wav';
    wavwrite(Out, Fs, 8, FileName);
    fprintf('    >> The file is save to "%s"\n', FileName);
    