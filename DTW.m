function [Path_y,Path_x,Distance] = DTW(LocalDistance)
    % [Path_y,Path_x] = DTW(LocalDistance) 
    %    Use dynamic programming to find a min-cost path through matrix LocalDistance.
    %    Return state sequence in Path_y,Path_x
    % Modified version of dp !
    %
    % veisi@mehr.sharif.edu
       
    [Row,Col] = size(LocalDistance);
    
    % costs
    Distance = zeros(Row+1, Col+1);
    Distance(Row+1,:) = NaN;
    Distance(:,1) = NaN;
    Distance(Row+1,1) = 0;
    Distance(1:(Row), 2:(Col+1)) = LocalDistance;
    
    AllPath = zeros(Row,Col);
    
    for i = Row+1:-1:2; 
      for j = 1:Col;
        [SelPath, tb] = min([Distance(i, j), Distance(i, j+1), Distance(i-1, j)]);
        Distance(i-1,j+1) = Distance(i-1,j+1)+SelPath;
        AllPath(i-1,j) = tb;
      end
    end
    
    % Traceback from top left for finding Path
    i = 1; 
    j = Col;
    Path_y = i;
    Path_x = j;
    while i < Row & j > 1
      tb = AllPath(i,j);
      if (tb == 1)
        i = i+1;
        j = j-1;
      elseif (tb == 2)
        i = i+1;    
      elseif (tb == 3)
        j = j-1;
      else    
        error;
      end
      Path_y = [i,Path_y];
      Path_x = [j,Path_x];
    end
    
    Distance = Distance(1:(Row),2:(Col+1));
