function plotRegs(reg_hist, reg_type, goodMoves, moves, legendOn, lineMarker, maxPoints)
% plotRegs(reg_hist, reg_type=internal, moves={{1:A} {1:A}...}, legendOn=1) 
%
%    reg_hist: a cell array where reg_hist{p} is the vectorized regret history for player{p}
% 
%    reg_type: (optional) 'internal' for internal regrets.  'external' for external?
%
%    moves:  (optional) cell array of moves where moves{p}{m} is the label
%            for move m for player p, e.g.
%                 { {'Top' 'Bottom'}  {'Left' 'Right'}}
%
%    legendOn: (optional)  flag for whether to include the legend. defaults to 1.
%
% Internal Regret: truncate, then sum columns
% External Regret: sum, then truncate columns

if nargin < 4
  moves = [];
end


if nargin < 2
  reg_type = 'internal';
end

if nargin < 5
  legendOn = 1;
end
if nargin < 6
  lineMarker = {'r-','r--','b-.','b:','ro-','rd-','b*-'};
end

fntsize = 14;

numplayers = length(reg_hist);

fill_in_moves = 0;
if isempty(moves)
  fill_in_moves = 1;
  moves = cell(1,numplayers);
end

nummoves = zeros(1,numplayers);

for p = 1:numplayers 
   nummoves(p) = sqrt(size(reg_hist{p},2));
   if fill_in_moves
     moves{p} = cell(1, nummoves(p));
     for m = 1:nummoves(p)
      moves{p}{m} = num2str(m);
     end
   end
end


iters = size(reg_hist{1},1);
if nargin < 7 | maxPoints == 0
    itinc = 1;
else
    itinc = max(1, floor(iters/maxPoints));
end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotsetup
   set(gca, 'FontSize', fntsize);

%nplayer 
% truncate, then sum columns

  reg_hist_plot = zeros(iters, sum(nummoves));

  for i = 1:itinc:iters		% each iteration
    R_plot_vec = [];			% vector for iteration i
    for p = 1:numplayers		% each player
      R = reg_hist{p}(i,:) ./ i;           % AVERAGE
      R = reshape(R, nummoves(p),nummoves(p));		% convert vector to AxA dim matrix

      if strcmp(reg_type, 'internal') == 1
         Rpos = max(R, 0);
         R_plot_vec = [R_plot_vec sum(Rpos')];	% take rowsum to get internal regret
      else
         R_plot_vec = [R_plot_vec max(sum(R'),0)];
      end
    end
    reg_hist_plot(i,:) = R_plot_vec;
  end


  % it's all good becuase there must be 2 players (above nummoves is computed using sqrt)
  first = 1;
  curCol = 1;
  for i = 1:numplayers
      for moveIx = 1:length(goodMoves{i})
          plot(1:itinc:iters, reg_hist_plot(1:itinc:end, goodMoves{i}(moveIx)), lineMarker{curCol});
          curCol = curCol + 1;
          if moveIx == 1 & first == 1
              hold;
              first = 0;
          end
      end
  end

  if strcmp(reg_type, 'internal') == 1
     ylabel ('Internal Regret', 'Fontsize', fntsize)
  else
     ylabel ('External Regret', 'Fontsize', fntsize)
  end  
  xlabel ('Time', 'Fontsize', fntsize)

  if legendOn > 0
    legend(moves{:}, legendOn);
  end
