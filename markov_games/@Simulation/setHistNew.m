%-----------------------------------------------------------------------
% File: setHistNew
%
% Description:
%   set the history information given the prev and new q-values
%
%-----------------------------------------------------------------------
function [history] = setHistNew(simul, stateLen, numActions, curState, actions, ...
                                tNum, history, qPrev)

qNew = getQ(simul.teams{tNum},curState, actions);
if simul.numTeams > 2
    history(6) = qNew;
    history(7) = qNew - qPrev;
else
    history(tNum, stateLen + 4) = qNew;
    history(tNum, stateLen + 5) = qNew - qPrev;
end

if simul.isAdaptiveAlg == 1
    %%% add policy information at end-
    qHistPol = get(simul.teams{tNum}, 'Policy');
    polRef = [curState {':'}];
     
    polVec = squeeze(qHistPol(polRef{:}));
    polVec = reshape(polVec, 1, length(polVec));  
     
    history(tNum, stateLen + 6: stateLen + 6 + numActions - 1) = polVec;

    regret = getRegret(simul.teams{tNum}, curState);
    regVec = regret(:)';
    history(tNum, stateLen + 6 + numActions: end) = regVec;
    
else
    switch simul.policyHist
    case 'long'
        qHistPol = get(simul.teams{tNum}, 'Policy');
        if isa(simul.teams{tNum}, 'NashQ')
            polRef = [curState {':'} ];
            polVec1 = squeeze(qHistPol{1}(polRef{:}));
            polVec2 = squeeze(qHistPol{2}(polRef{:}));
            if size(polVec1,1) == 1
                %(row vectors from squeeze command)
                polVec = polVec2 * polVec1';
            else
                polVec = polVec2' * polVec1;
            end
        else
            polRef = [curState {':'} {':'}];
            polVec = squeeze(qHistPol(polRef{:}))';
        end
        if size(polVec,1) ~= 1
            history(tNum, stateLen + 6: end) = reshape(polVec, 1, numActions^2);
        else
            history(tNum, stateLen + 6: end) = polVec;
        end
    case 'short'
        oppTeam = [2 1];
        opp = oppTeam(tNum);
        qHistPol = get(simul.teams{tNum}, 'Policy');
        oppPol = get(simul.teams{opp}, 'Policy');
        polRef = [curState {':'}];
        myPol = squeeze(qHistPol(polRef{:}))';
        theirPol = squeeze(oppPol(polRef{:}))';
        history(tNum, stateLen + 6: end) = reshape((theirPol' * myPol), 1, numActions^2);
    end
end
