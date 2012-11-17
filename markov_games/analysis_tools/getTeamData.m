function [qt1, qt2, p1, p2] = getTeamData(teams);

qt1 = get(teams{1}, 'QTable');
qt2 = get(teams{2}, 'QTable');
p1 = get(teams{1}, 'Policy');
p2 = get(teams{2}, 'Policy');
