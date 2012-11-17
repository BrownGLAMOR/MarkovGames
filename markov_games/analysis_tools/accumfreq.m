function fl = accumfreq(inl, m)
% accumfreq(inl, m) for action list inl where there are m possible
% actions [1..m]
%
% accumfreq([1 3 1],4) would give [ 1    0   0   0
%                                   .5   0  .5   0
%                                   .67  0  .33  0 ]
				  

  fl = zeros(length(inl),m);		% preallocate output
  freqs = zeros(1,m);			% cumulative counter for each action
  
  for i = 1:length(inl)
    freqs(inl(i)) = freqs(inl(i)) + 1;
    fl(i,:) = freqs ./ sum(freqs);
  end
  

