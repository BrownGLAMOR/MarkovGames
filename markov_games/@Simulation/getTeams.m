%-----------------------------------------------------------------------
% Funciton: getTeams
%
% Description:
%       create team structures based on input
%
%-----------------------------------------------------------------------
function simul = getTeams(simul)

switch simul.teamType
    case 'Fict'
        for i = 1:simul.numTeams
            simul.teams{i} = MFict(i, simul.game, simul.paramSet, 'standard');
        end
    case 'CFict'
        for i = 1:simul.numTeams
            simul.teams{i} = MFict(i, simul.game, simul.paramSet, 'conditional');
        end
    case 'UFict'
        for i = 1:simul.numTeams
            simul.teams{i} = MFict(i, simul.game, simul.paramSet, 'allPlayer');
        end
    case 'QQNB'
        for i = 1:simul.numTeams
            simul.teams{i} = QLearner(i, simul.game, 'nobiasdeterministic', simul.paramSet, simul.normGamma);
        end
    case 'QQD'
        for i = 1:simul.numTeams
            simul.teams{i} = QLearner(i, simul.game, 'deterministic', simul.paramSet, simul.normGamma);
        end
    case 'QQND'
        for i = 1:simul.numTeams
            simul.teams{i} = QLearner(i, simul.game, 'nondeterministic', simul.paramSet, simul.normGamma);
        end
    case 'CC'
        for i = 1:simul.numTeams
            simul.teams{i} = CorrEQ(i, simul.game, simul.paramSet, ...
                                    'utilitarian', simul.normGamma);
        end
    case 'CClax'
        for i = 1:simul.numTeams
            simul.teams{i} = CorrEQ(i, simul.game, simul.paramSet, ...
                                    'lax', simul.normGamma);
        end
    case 'CCe'
        for i = 1:simul.numTeams
            simul.teams{i} = CorrEQ(i, simul.game, simul.paramSet, ...
                                    'egalitarian', simul.normGamma);
        end
    case 'CCr'
        for i = 1:simul.numTeams
            simul.teams{i} = CorrEQ(i, simul.game, simul.paramSet, ...
                                    'republican', simul.normGamma);
        end
    case 'CCl'
        for i = 1:simul.numTeams
            simul.teams{i} = CorrEQ(i, simul.game, simul.paramSet, ...
                                    'libertarian', simul.normGamma);
        end
    case 'MM'
        for i = 1:simul.numTeams
            simul.teams{i} = MinimaxQ(i, simul.game, simul.paramSet, simul.normGamma);
        end
    case 'FF'
        for i = 1:simul.numTeams
            simul.teams{i} = Friend(i, simul.game, simul.paramSet, simul.normGamma);
        end
    case 'FirstNash'
        for i = 1:simul.numTeams
            simul.teams{i} = NashQ(i, simul.game, simul.paramSet, ...
                                    'first', simul.normGamma);
        end
    case 'SecondNash'
        for i = 1:simul.numTeams
            simul.teams{i} = NashQ(i, simul.game, simul.paramSet, ...
                                    'second', simul.normGamma);
        end
    case 'BestNash'
        for i = 1:simul.numTeams
            simul.teams{i} = NashQ(i, simul.game, simul.paramSet, ...
                                    'best', simul.normGamma);
        end
    case 'CoordNash'
        for i = 1:simul.numTeams
            simul.teams{i} = NashQ(i, simul.game, simul.paramSet, ...
                                    'coord', simul.normGamma);
        end
    case 'QRND'
        simul.teams{1} = QLearner(1, simul.game, 'nondeterministic', simul.paramSet, simul.normGamma);
        simul.teams{2} = Random(2, simul.game, simul.paramSet);
    case 'CR'
        simul.teams{1} = CorrEQ(1, simul.game, simul.paramSet);
        simul.teams{2} = Random(2, simul.game, simul.paramSet);
    case 'MR'
        simul.teams{1} = MinimaxQ(1, simul.game, simul.paramSet, simul.normGamma);
        simul.teams{2} = Random(2, simul.game, simul.paramSet);
    case 'FR'
        simul.teams{1} = Friend(1, simul.game, simul.paramSet, simul.normGamma);
        simul.teams{2} = Random(2, simul.game, simul.paramSet);
    case {'HH', 'HEDGE'}
        simul.teams{1} = HedgeQ(1, simul.game, simul.paramSet, .05);
        simul.teams{2} = HedgeQ(2, simul.game, simul.paramSet, .05);
        simul.isAdaptiveAlg = 1;
    case {'DELHH10', 'DELHEDGE10'}
        simul.teams{1} = HedgeQ(1, simul.game, simul.paramSet, .05, .1);
        simul.teams{2} = HedgeQ(2, simul.game, simul.paramSet, .05, .1);
        simul.isAdaptiveAlg = 1;
    case {'DELHH100', 'DELHEDGE100'}
        simul.teams{1} = HedgeQ(1, simul.game, simul.paramSet, .05, .01);
        simul.teams{2} = HedgeQ(2, simul.game, simul.paramSet, .05, .01);
        simul.isAdaptiveAlg = 1;
  
    case 'NHNH'
        simul.teams{1} = NaiveHedgeQ(1, simul.game, simul.paramSet);
        simul.teams{2} = NaiveHedgeQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'OHOH'
        simul.teams{1} = OffHedgeQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OffHedgeQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'HMC'
        simul.teams{1} = HartMCQ(1, simul.game, simul.paramSet);
        simul.teams{2} = HartMCQ(2, simul.game, simul.paramSet);
        simul.isAdaptiveAlg = 1;
    case 'DELHMC100'
        simul.teams{1} = HartMCQ(1, simul.game, simul.paramSet, .01);
        simul.teams{2} = HartMCQ(2, simul.game, simul.paramSet, .01);
        simul.isAdaptiveAlg = 1;
    case 'DELHMC200'
        simul.teams{1} = HartMCQ(1, simul.game, simul.paramSet, .005);
        simul.teams{2} = HartMCQ(2, simul.game, simul.paramSet, .005);
        simul.isAdaptiveAlg = 1;
    case 'WW'
        simul.teams{1} = WarQ(1, simul.game, simul.paramSet);
        simul.teams{2} = WarQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;

    case 'PEACE'
        simul.teams{1} = PeaceQ(1, simul.game, simul.paramSet);
        simul.teams{2} = PeaceQ(2, simul.game, simul.paramSet);
        simul.isAdaptiveAlg = 1;	    
 
    case 'DELPEACE10'
        simul.teams{1} = PeaceQ(1, simul.game, simul.paramSet, .1);
        simul.teams{2} = PeaceQ(2, simul.game, simul.paramSet, .1);
        simul.isAdaptiveAlg = 1;	    
    case 'DELPEACE100'
        simul.teams{1} = PeaceQ(1, simul.game, simul.paramSet, .01);
        simul.teams{2} = PeaceQ(2, simul.game, simul.paramSet, .01);
        simul.isAdaptiveAlg = 1;	    
    case 'DELPEACE200'
        simul.teams{1} = PeaceQ(1, simul.game, simul.paramSet, .005);
        simul.teams{2} = PeaceQ(2, simul.game, simul.paramSet, .005);
        simul.isAdaptiveAlg = 1;	    

    case 'NPEACE'
        simul.teams{1} = NaivePeaceQ(1, simul.game, simul.paramSet);
        simul.teams{2} = NaivePeaceQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;

    case 'OPEACE'
        simul.teams{1} = OffPeaceQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OffPeaceQ(2, simul.game, simul.paramSet);
        simul.isAdaptiveAlg = 1;	    	    
   case  'OWAR'
        simul.teams{1} = OffWarQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OffWarQ(2, simul.game, simul.paramSet);
        simul.isAdaptiveAlg = 1;	    	    
    case 'WW'
        simul.teams{1} = WarQ(1, simul.game, simul.paramSet);
        simul.teams{2} = WarQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'NWAR'
        simul.teams{1} = NaiveWarQ(1, simul.game, simul.paramSet);
        simul.teams{2} = NaiveWarQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'ONIH'
        simul.teams{1} = OnInformHedgeQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OnInformHedgeQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'ONIWAR'
        simul.teams{1} = OnInformWarQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OnInformWarQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'ONIPEACE'
        simul.teams{1} = OnInformPeaceQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OnInformPeaceQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'ONIHMC'
        simul.teams{1} = OnInformHartMCQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OnInformHartMCQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'OFFNHMC'
        simul.teams{1} = OffNaiveHartMCQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OffNaiveHartMCQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
    case 'OFFNPEACE'
        simul.teams{1} = OffNaivePeaceQ(1, simul.game, simul.paramSet);
        simul.teams{2} = OffNaivePeaceQ(2, simul.game, simul.paramSet);	    
        simul.isAdaptiveAlg = 1;
 

    otherwise
        error(['Unknown player type: ', simul.teamType]);
end

