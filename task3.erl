-module (task3).
-export ([loadConcurrent/1]).
-export ([loadOld/1]).
-export ([countsplit/2]).
-export ([joinerProcess/3]).


% ========================================================== %
%  Load the file, split it into list and count concurrently. %
% ========================================================== %

loadConcurrent(F)->
{ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   io:fwrite("LOaded and Split~n"),
   
   % Spawn a joiner who would join and also print
   Pid=spawn(?MODULE,joinerProcess,[[],1,erlang:timestamp()]),
   io:fwrite("~nJoiner created with pid:~p~n",[Pid]),
   
   % Start the spawning function 
   spawner(Sl,Pid).
 
% ============================================================ %
%  Spawns a countsplit processes with an item from the list.   %
% ============================================================ %

spawner([],_)->ok;
spawner([H|T],Pid)->
SpawnPID=spawn(?MODULE,countsplit,[H,Pid]),
io:fwrite("~nSpawn process with pid:~p~n",[SpawnPID]),
spawner(T,Pid).



% ================================================================== %
%  The function/process counts the characters for the specific       %
%  item and sends a message to the joiner process with the result.   %
% ================================================================== %

countsplit(Part,Pid)->
 Result=go(Part),
 Pid ! {Result}.


% ============================================================ %
%  The function/process waits for a result message,            %
%  joins it to the result list and calls itself                %
%  so that it waits for a response from the rest of the        %
%  countsplit processes. When the last part is reached it      %
%  would print the result.                                     %
% ============================================================ %
joinerProcess(Result,22,StartTime) ->  
io:fwrite("~nThe list with values is:~n~p~nTime Taken:~ps~n",[Result,timer:now_diff(erlang:timestamp(),StartTime)*0.000001]);
joinerProcess(Result,Part,StartTime) ->
receive 
{Msg}->
 Result2 = join(Result,Msg),
 joinerProcess(Result2,Part+1,StartTime);
_Other -> {error, unknown}
end.


% =============================================================== %
%  Old function for the loading of the file without concurrency   %
%  with some changes to track the time.                           %
% =============================================================== %
loadOld(F)->
{ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   io:fwrite("LOaded and Split~n"),
   StartTime = erlang:timestamp(),
   Result=countsplitOld(Sl,[]),
   io:fwrite("~nThe list with values is:~n~p~nTime Taken:~ps~n",[Result,timer:now_diff(erlang:timestamp(),StartTime)*0.000001]).
 
% ============================================================================ %
% === Everything underneath is the same code from the given ccharcount.erl === %
% ============================================================================ %

% ================================================================== %
%  The old function/process that counts the characters for           %
%  the specific item and joins the result without concurrency.       %
% ================================================================== %
countsplitOld([],R)->R;
countsplitOld([H|T],R)->
 %Ul=shake:sort(Sl),
 Result=go(H),
 R2=join(R,Result),
 countsplitOld(T,R2).


% ============================================================ %
%  Joins the two list of tuples of characters together.        %
% ============================================================ %

join([],[])->[];
join([],R)->R;
join([H1|T1],[H2|T2])->
{C,N}=H1,
{C1,N1}=H2,
[{C1,N+N1}]++join(T1,T2).


% =========================================== %
%  Split the entered input into a list.       %
% =========================================== %

split([],_)->[];
split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true->S2=string:substr(List,Length+1,length(List));
   false->S2=[]
end,
[S1]++split(S2,Length).


% ================================================ %
%  Increase the count of the specific character.   %
% ================================================ %

count(_, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.


% =================================== %
%  Go through the part of the input.  %
% =================================== %

go(L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
rgo(Alph,L,[]).


% ====================================================== %
%  Go through the character list to count them in the    %
%  specific part of the input.                           %
% ====================================================== %

rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2);
rgo([],_,Result)->Result.