function [W,Z] = exchange_elm(W,Z,r,c)

temp = W(r,:);
W(r,:) = Z(c,:);
Z(c,:) = temp;
