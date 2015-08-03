function Out=CMS_Normalization(Featurs)
    % Cepstral Mean Subtraction (CMS) of Features
    
    [N,M]=size(Featurs);
    
    for i=1:N
        Mean(i)=sum(Featurs(i,:))/M;
        Out(i,:)=Featurs(i,:)-Mean(i);
    end
