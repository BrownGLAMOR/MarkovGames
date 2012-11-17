%-----------------------------------------------------------------------
%
%-----------------------------------------------------------------------
function paramSet = paramEFrac(numIter, startVal, fixedAlpha)

if nargin < 3
    paramSet = Params('Exponential', [1, .01], 'Fractional', ...
                  startVal, .9, numIter);
else
    paramSet = Params('Fixed', fixedAlpha, 'Fractional', ...
                  startVal, .9, numIter);
end
