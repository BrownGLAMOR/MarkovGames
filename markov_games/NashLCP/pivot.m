function [Q,M] = pivot(Q,M,r1,c1, dimM)

pPoint = M(r1,c1);
if abs(pPoint) > 0.000000001
    for i = 1:dimM
        if i == r1
            % ??? this would normally be 0
            QLocal(i) = -Q(r1)/pPoint;
        else
            QLocal(i) = Q(i) - (Q(r1)/pPoint)*M(i,c1);
        end
        for j = 1:dimM
            if i == r1
                if j == c1
                    MLocal(i,j) = 1.0/pPoint;
                else
                    MLocal(i,j) = -M(r1,j)/pPoint;
                end
            else
                if j == c1 
                    MLocal(i,j) = M(i,c1)/pPoint;
                else 
                    MLocal(i,j) = M(i,j) -(M(i,c1)/pPoint)*M(r1,j);
                end
            end
        end
    end
    Q = QLocal;
    M = MLocal;
end
