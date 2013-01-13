%         ***********************************************
%         ******     Feature extruction           *******
%         ***********************************************
function Featurs= Feature_Extruction(InputWave,Fs)

    % Featurs= Feature_Extruction(InputWave);
    %     Return 26 MFCC feature vectors of InputWave

    % veisi@sharif.edu  June2004



    if nargin<1
        disp('Error: in Feature_Extruction, no wave file.');
    end
    if isstr(InputWave),
        [InputWave,Fs,NBits] = wavread(InputWave);
    elseif nargin==1
        Fs=8000;
    end
    
    % ====== Set Parameters.
    %             Frame size: N(ms),Overlapping region is M(ms)
    %             Generally , M = (1/2)*N , which N = 24.
    FrameSize_ms = 24;		  % Ex. N=32 = (256/8000)*1000 , each frame has 256 points.
    Overlap_ms = (1/2)*FrameSize_ms;	
    FrameSize = round(FrameSize_ms*Fs/1000); % 256
    Overlap  = round(Overlap_ms*Fs/1000);  % 86
    %No_of_Frames= floor((size(InputWave,1)/(FrameSize-Overlap)) - 1)+2;
    % Triangular BandFilter parameters : StartFreq,CenterFreq,StopFreq. (20 Bank filters)
     StartFreq=[1	3	5	7	9	11	13	15	17	19	23	27	31	35	40	46	55	61	70	81];    %Start
     CenterFreq=[3	5	7	9	11	13	15	17	19	21	27	31	35	40	46	55	61	70	81	93];    %Center
     StopFreq=[5	7	9	11	13	15	17	19	21	23	31	35	40	46	55	61	70	81	93	108];   %End
%      StartFreq =[1	100	200	300	400	500	600	700	800	 900  989  1136 1305 1499 1722 1977 2279 2609 2998 3444 3956 4544 5220 6001];    %Start     
%      CenterFreq=[100	200	300	400	500	600	700	800	900	 1000 1149 1320 1516 1741 2000 2297 2639 3031 3482 4000 4595 5278 6063 6964];    %Center    
%      StopFreq  =[200	300	400	500	600	700	800	900	1000 1124 1309 1504 1727 1983 2278 2617 2999 3453 3966 4556 5234 6012 6906 7927];   %End
     Threshold = 0.0001;  % for energy test ==> remove fromes with energy bellow this amount.

    % ====== Step 1: Pre-emphasis.
    InputWave = filter([1, -0.95], 1, InputWave);
    
    % ====== Step 2: Windowng & overlapping.
    Frame = buffer(InputWave, FrameSize, Overlap);
    
    normalize_coff = 10;
    energy = sum(Frame.^2)/FrameSize;
    index = find(energy < Threshold);
    energy(index) = [];
    logEnergy = 10*log10(energy)/normalize_coff;
    Frame(:, index) = [];   % Remove empty frames
    Featurs = [];
    for i = 1:size(Frame, 2);   % size(Frame, 2)=No_of_Frames
        
          % ====== Step 3: Hamming window.
          WindowedFrame  = hamming(FrameSize).*Frame(:,i);
          
          % ====== Step 4: FFT: fast fourier transform.
          %            Using FFT function to calculate. 
          %            Compute square of real part and imaginary part.
          FFT_Frame = abs(fft(WindowedFrame));
          
          % ====== Step 5: Triangular bandpass filter.
          %            Using user defined function triBandFilter(fftFrame{i}).
          No_of_FilterBanks = 20;      %No_of_FilterBanks means counts of log spectral magnitude.
          tbfCoef = TriBandFilter(FFT_Frame,No_of_FilterBanks,StartFreq,CenterFreq,StopFreq);
          
          % ====== Step 6: Logearithm.
          tbfCoef = log(tbfCoef.^2);
          
          % ====== Step 7: DCT: Discrete Cosine Transform.
          %            Using DCT to get L order mel-scale-cepstrum parameters.
          No_of_Featurs = 12;      % generally No_of_Featurs is 12.
          Cepstrums = Mel_Cepstrum2(No_of_Featurs,No_of_FilterBanks,tbfCoef);
          Featurs = [Featurs Cepstrums'];
    end;
    Featurs = [Featurs; logEnergy];
    
    %=========compute delta energy and delta cepstrum============
    %Calculate delta cepstrum and delta log energy
    % get 13 order Featurs.
    Delta_window = 2;
    D_Featurs = DeltaFeature(Delta_window, Featurs);
    
    %=========compute delta-delta energy and delta cepstrum============
    %Calculate delta-delta cepstrum and delta log energy
    %Combine them with previouse features, get 39 order Featurs.
    
    %Delta_window = 2;
    %D_d_Featurs = Delta_DeltaFeature(Delta_window, Featurs);
    % or
    D_d_Featurs = DeltaFeature(Delta_window, D_Featurs);
    
    %===== Combine cepstrum,delta and delta-delta
     Featurs = [Featurs ; D_Featurs ; D_d_Featurs];  % 39 features
     %Featurs = [Featurs ; D_Featurs];  % 26 features
    
%============================= Sub function ==============================
%==========================================================================

%         ***********************************************
%         ******    Triangular Band Filter        *******
%         ***********************************************

function tbfCoef = TriBandFilter(fftFrame,P,StartFreq,CenterFreq,StopFreq)
    %The function is triangular bandpass filter.
    for i = 1 : P,
        % Compute the slope of left side of triangular bandpass filter
       for j = StartFreq(i) : CenterFreq(i),
          filtmag(j) = (j-StartFreq(i))/(CenterFreq(i)-StartFreq(i));
       end;
        % Compute the slope of right side of triangular bandpass filter
       for j = CenterFreq(i)+1: StopFreq(i),
          filtmag(j) = 1-(j-CenterFreq(i))/(StopFreq(i)-CenterFreq(i));
       end;
       tbfCoef(i) = sum(fftFrame(StartFreq(i):StopFreq(i)).*filtmag(StartFreq(i):StopFreq(i))');
    end;
    
%         ***********************************************
%         ******     Mel-scale cepstrums          *******
%         ***********************************************

function Cepstrum = Mel_Cepstrum2(L,P,tbfCoef)
    %compute mel-scale cepstrum , L should be 12 at most part.
    for i=1:L,
    	coef = cos((pi/P)*i*(linspace(1,P,P)-0.5))';
    	Cepstrum(i) = sum(coef.*tbfCoef');
    end;

%         ***********************************************
%         ******        Delta cepstrums           *******
%         ***********************************************
   
function D_Featurs = DeltaFeature(delta_window,Featurs)
    % Compute delta cepstrum and delta log energy.
    rows  = size(Featurs,1);
    cols  = size(Featurs,2);
    temp  = [zeros(rows,delta_window) Featurs zeros(rows,delta_window)];
    D_Featurs = zeros(rows,cols);
    denominator = sum([1:delta_window].^2)*2;
    for i = 1+delta_window : cols+delta_window,
       subtrahend = 0;
       minuend    = 0;
       for j = 1 : delta_window,
          subtrahend = subtrahend + temp(:,i+j)*j;
          minuend    = minuend + temp(:,i-j)*(-j);
       end;
       D_Featurs(:,i-delta_window) = (subtrahend - minuend)/denominator;
    end;
    %Featurs = [Featurs ; temp2];

    
%         ***********************************************
%         ******      Delta-Delta cepstrums       *******
%         ***********************************************
   
function D_d_Featurs = Delta_DeltaFeature(delta_window,Featurs)
    % Compute delta delta cepstrum and delta log energy.
    
    % another way!
    % Featurs1 = DeltaFeature(delta_window,Featurs);
    % Featurs2 = DeltaFeature(delta_window,Featurs1);
    % Featurs = [Featurs ; Featurs2];
    
    rows  = size(Featurs,1);
    cols  = size(Featurs,2);
    temp1  = [zeros(rows,delta_window) Featurs zeros(rows,delta_window)];
    temp2  = [zeros(rows,delta_window) Featurs zeros(rows,delta_window)];
    D_d_Featurs  = zeros(rows,cols);
    
    % Rabiner method
    denominator = sum([1:delta_window].^2)*2;
    denominator2 = delta_window*(delta_window+1)*(2*delta_window+1)*(3*delta_window^2+3*delta_window-1)/15;
    for i = 1+delta_window : cols+delta_window,
       subtrahend = 0;
       minuend    = 0;
       subtrahend2 = 0;
       minuend2    = 0;
       for j = 1 : delta_window,
          subtrahend = subtrahend + temp1(:,i+j);
          minuend = minuend + temp1(:,i-j);
          subtrahend2  =  subtrahend2+ j*j*temp2(:,i+j);
          minuend2    = minuend2 + (-j)*(-j)*temp2(:,i-j);
       end;
       temp1(:,i) = subtrahend + minuend + temp1(:,i);
       temp2(:,i) = subtrahend2 + minuend2;
       D_d_Featurs(:,i-delta_window) = 2*(denominator.*temp1(:,i)-(2*delta_window+1).*temp2(:,i))/(denominator*denominator-(2*delta_window+1)*denominator2);
    end;
    % Featurs = [Featurs ; temp3];
