%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function gridQstart(qt1, qt2)

disp(['             Side            Center']);
disp(['Side     ', num2str(qt1(3,1,1,1,3,3)), ', ', ...
                   num2str(qt2(3,1,1,1,3,3)), ...
      '     ', num2str(qt1(3,1,1,1,1,3)), ', ', ...
               num2str(qt2(3,1,1,1,3,1))]);
disp(['Center   ', num2str(qt1(3,1,1,1,3,2)), ', ', ...
                   num2str(qt2(3,1,1,1,2,3)), ...
      '     ', num2str(qt1(3,1,1,1,1,2)), ', ', ...
               num2str(qt2(3,1,1,1,2,1))]);
