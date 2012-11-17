function j = findMinRatio(Q,M,r)
	% // minumum ratio test

dimM = size(M,1);
PostZero = 20000000;
R = zeros(1,dimM);
j = -1;

for i = 1:dimM
    if M(i,r) < -0.00001
        R(i) = -Q(i)/M(i,r);
    else
        R(i) = PostZero;
    end
end
min = PostZero;
for i = 1:dimM
    if R(i) ~= PostZero & R(i) < min
        min = R(i);
        j = i;
    end
end
