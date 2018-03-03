-module (task1).
-export ([pi/0]).

% ============================ %
%  Calls the main pi function. %
% ============================ %

pi() -> pi(1,3,-1).

% =================================================== %
% A - current value in brackets (1 - 1/3 + 1/5 - ...)
% B - denominator
% C - sign(+/-)
%
% Recursive function that calculates pi.
% =================================================== %
pi(A,B,C) ->
	if 1/B > 0.000001 -> pi(A+(1/B)*C,B+2,-C);
	true-> io:fwrite("Pi is ~.5f.~n",[4*A])
end.