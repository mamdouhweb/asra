function Out2 = LocalDistance(A,B)
    % Out = LocalDistance(A,B)
    %    calculate the local distance between feature matrices A and B.
    %    Using inner product i.e. cos(angle between vectors) between vectors.
    %    A and B have same #rows.
    %
    % veisi@mehr.sharif.edu
    
    Mag_A = sqrt(sum(A.^2));
    Mag_B = sqrt(sum(B.^2));
    
    Cols_A = size(A,2);
    Cols_B = size(B,2);
    Out = zeros(Cols_A, Cols_B);
    for i = 1:Cols_A
     for j = 1:Cols_B
       % normalized inner product i.e. cos(angle between vectors)
       Out(i,j) = (A(:,i)'*B(:,j))/(Mag_A(i)*Mag_B(j));
     end
    end
    
    %Out = (A'*B)./(Mag_A'*Mag_B);
    
    Row=size(Out,1);
    for i=1:fix(Row/2)
        %tmp=M(Row-i+1,:);
        Out2(Row-i+1,:)=Out(i,:);
        Out2(i,:)=Out(Row-i+1,:);%tmp;
    end
    if mod(Row,2)~=0
        Out2(fix(Row/2+1),:)=Out(fix(Row/2+1),:);
    end
    
   % Use 1-Out2 because DTW will find the *lowest* total cost
    Out2=1-Out2;