function [cc, maxflag] = inclist(player, cc, statedim)      
% INCLIST:  for a cellarray of indices, cc, increment      

    % this is all just messy increment code for incrementing cc.  It's
    %
    %  incflag:   indicates whether we've fully incremented the counter 
    %                     (as opposed to being in the midst of carries)
    %  maxflag:   indicates the counter's reached its max
    
    
      maxflag = 0;
      incflag = 0;
      
      j = length(cc);
 
      while not(incflag)
	if cc{j} < statedim(j)
	  cc{j} = cc{j} + 1;
	  incflag = 1;
	else				% carry
	  cc{j} = 1;
	  if j > 1
	    j = j-1;
	  else
	    maxflag = 1;
	    incflag = 1;
	  end
	end
      end
      
