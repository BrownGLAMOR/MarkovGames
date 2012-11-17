function [Z] = getfinalZ(W,Q,Z,k,dimM)
%	// This function is modified, get the final solution
for i = 1:dimM
    if W(i,1) == 2
        j = W(i,2);
        Z(k,j) = Q(i);
    end
end
