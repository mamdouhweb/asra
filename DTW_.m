function [Path_y,Path_x,Distance] = DTW(L_Distance)
% Modified version of dp !!
	
    [Row,Col] = size(L_Distance);
    % costs
    Distance = zeros(Row+1, Col+1);
    Distance(1,:) = NaN;
    Distance(:,1) = NaN;
    Distance(1,1) = 0;
    Distance(2:(Row+1), 2:(Col+1)) = L_Distance;

    phi = zeros(Row,Col);
   
    for i = 1:Row; 
      for j = 1:Col;
        [dmax, tb] = min([Distance(i, j), Distance(i, j+1), Distance(i+1, j),Distance(i, j+2)]);
        Distance(i+1,j+1) = Distance(i+1,j+1)+dmax;
        phi(i,j) = tb;
      end
    end
    
    % Traceback from top left to find path
    i = Row; 
    j = Col;
    Path_y = i;
    Path_x = j;
    while i > 1 & j > 1
      tb = phi(i,j);
      if (tb == 1)
        i = i-1;
        j = j-1;
      elseif (tb == 2)
        i = i-1;
      elseif (tb == 3)
        j = j-1;
      elseif (tb == 3)
        i = i-2;
      else    
        error;
      end
      Path_y = [i,Path_y];
      Path_x = [j,Path_x];
    end
    
    % Strip off the edges of the Distance matrix before returning
    Distance = Distance(2:(Row+1),2:(Col+1));
    