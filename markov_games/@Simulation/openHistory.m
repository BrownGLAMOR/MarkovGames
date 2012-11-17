%-----------------------------------------------------------------------
% File: openHistory
%
% Description:
%   open history files depending on game type etc.
%
%-----------------------------------------------------------------------
function [histFID, history, qErrFID] = openHistory(simul, stateLen, numActions)

histFID = 0;
qErrFID = 0;
history = [];
display(['Simulation history file: ', simul.histFile])
switch simul.runMode
    case 'OLDtest'
        histFID = fopen([simul.histFile, 'state.txt'], 'w+');
        history = zeros(1, stateLen + 6);
    case {'train','test'}
        if simul.numTeams > 2
            %histFID = fopen([simul.histFile, 'qhist.txt'], 'w+');
            histFID = zeros(1, 7);
        else
            histFID(1) = fopen([simul.histFile, 'qhist1.txt'], 'w+');
            histFID(2) = fopen([simul.histFile, 'qhist2.txt'], 'w+');
        end
        if simul.isAdaptiveAlg == 1
            disp(['Adaptive Algorithm']);
            % does this really need to be preallocated?
            % (I'm nervous about assuming numActions)			
            history = zeros(2, stateLen + 5 + numActions + (numActions^2));
        else
            switch simul.policyHist
            case {'short','long'}
                history = zeros(2, stateLen + 5 + (numActions^2)); 
            case 'none'
                history = zeros(2, stateLen + 5);
            otherwise
                error(['Unknown policyHist type']);
            end
        end

        if isa(simul.game, 'Chicken')
            qErrFID = fopen([simul.histFile,'qError.txt'], 'w+');
        end
end
