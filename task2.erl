-module (task2).
-export ([loadListFromFile/1]).
-export ([uniqueListFromUser/1]).

% ========================================================== %
%  Load the file, split it into a list and finds the unique. %
% ========================================================== %

loadListFromFile(FileName)->
{ok, Bin} = file:read_file(FileName),
   List=binary_to_list(Bin),
   LowString=string:to_lower(List),
   % I have replaced all characters that are not numbers or letters with spaces
   ReplacedString = re:replace(LowString, "[^0-9A-Za-z]", " ", [global, {return, list}]),
   SplitList=string:tokens(ReplacedString, " \t\r\n"),
   Result = go(SplitList,[]),
   io:fwrite("The list of unique items:~p~n",[lists:sort(Result)]),
   io:fwrite("The number of unique items: ~.B~n",[length(Result)]).
   
% ======================================================= %
%  Finds the unique words in a list inputted by the user. %
% ======================================================= %

uniqueListFromUser(InputList)->
Result = go(InputList,[]),
   io:fwrite("The list of unique items:~p~n",[lists:sort(Result)]),
   io:fwrite("The number of unique items: ~.B~n",[length(Result)]).


% ========================================== %
%  Check if the item is already in the list. %
% ========================================== %

evaluateItem([],_,Results,_)-> 
Results;
evaluateItem(Word, [],[],_)->
	 [{Word,1}];
evaluateItem(Word, [],Results,_)->
	 Results++[{Word,1}];
evaluateItem(Word, [H|T],Results,Index) ->
	Index1=Index+1,
   case element(1,H)==Word of
   true -> lists:sublist(Results,Index1-1) ++ [{element(1,lists:nth(Index1,Results)),element(2,lists:nth(Index1,Results))+1}] ++ lists:nthtail(Index1,Results);
   false -> evaluateItem(Word,T,Results,Index1)
end.

% ================================== %
%  Go through the items in the list. %
% ================================== %

go([H|T],Result)->
Result2 = evaluateItem(string:to_lower(H),Result,Result,0),
go(T,Result2);
go([],Result)->Result.