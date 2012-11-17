%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function soccerMixed(qt1, qt2, p1, p2)

mixState{1} = {2,3,2,2,1};
mixState{2} = {2,3,2,2,2};
mixState{3} = {1,3,1,2,1};
mixState{4} = {1,3,1,2,2};
for ms = 1:4
    disp(['State: ', int2str([mixState{ms}{:}])]);
    polState = mixState{ms};
    polState{6} = ':';
    polState{7} = ':';
    if nargin > 2
        pp1 = squeeze(p1(polState{:}))';
        disp('Policy1:');
        disp(num2str(pp1));
        if nargin > 3
            pp2 = squeeze(p2(polState{:}));
            disp('Policy2:');
            if size(pp2, 2) == 1
                disp(num2str(pp2'));
            else
                disp(num2str(pp2));
            end
        end
    end
    for row = 1:5
        polStr{row} = [];
        rowstr = [];
        for col = 1:5
            st1 = mixState{ms};
            st1{6} = col;
            st1{7} = row;
            st2 = mixState{ms};
            st2{6} = row;
            st2{7} = col;
            rowstr = [rowstr, num2str(qt1(st1{:}),'%3.2f'), ', ', ...
                      num2str(qt2(st2{:}),'%3.2f'), '	'];
        end
        disp(rowstr);
    end
    disp([' ']);
end

