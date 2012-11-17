function l = findComp(j,W,Z,dimM)

l = -1;
		
temp1 = W(j,1);
temp1 = 3-temp1;   % (w,a)-> (z,a)  (z,a) ->(w,a) 
temp2 = W(j,2);
		
for i= 1:dimM
    if Z(i,1) == temp1 & Z(i,2) == temp2
        l = i;
        break;
    end
end
