%-----------------------------------------------------------------------
%
% function runsave(matlabexp, fileName)
%
%-----------------------------------------------------------------------
function runsave(matlabexp, fileName)

evalin('caller', matlabexp);
saveStr = ['save ', fileName];
evalin('caller', saveStr);
