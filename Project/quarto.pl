% --------------------------------- %
% Name:            ID:      G:      %
% Mostafa Saber    20150253 G6      %
% Mina Yousry      20150272 G5      %
% Nardeen Mokhless 20150273 G5      %
% Mohamed Ashraf   20150316 G6      %
% --------------------------------- %

:- use_module(minimax).

:- use_module(tictactoe).

% bestMove(+Pos, -NextPos)

% Compute the best Next Position from Position Pos

% with minimax or alpha-beta algorithm.

bestMove(Pos, NextPos , AllPieces) :-

	minimax(Pos, NextPos, _ , AllPieces).


indexOf([Element|_], Element, 1).
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),!,
  Index is Index1+1.



playFirst(Player,RandPiece):-
    ( Player \= 1, Player \= 0, !,
      write('Error : not a valid choose!'), nl, playAskColor;
      EmptyBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0],
      Pieces = [[black,round,tall],[black,round,short],[black,square,tall],[black,square,short],[white,round,tall],[white,round,short],[white,square,tall],[white,square,short] ],
      play([Player, play, EmptyBoard], Pieces,RandomPiece)
      RandPiece is RandomPiece
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%
play([Player, play, Board], AllPieces,RandomPiece)   :-
  Player == 0,
  length(AllPieces , L),
  Length is L+1,
  random(1, Length , R),
  nth1(R,AllPieces,Result),
  RandomPiece is  Result.

continuePlay( [Player, play, Board] , AllPieces, RandomPiece, Pos,CompPiece,ComputerPosition):-
  (
    delete(AllPieces,RandomPiece,NewAllPieces),
    humanMove([Player, play, Board], [NextPlayer, State, NextBoard] ,RandomPiece, Pos), !,
    (
      play([NextPlayer, play, NextBoard],NewAllPieces,Rp,Position),
      CompPiece is Rp,
      ComputerPosition is Position
    )
  ).


play([Player, play, Board],AllPieces,Rp,Position):-
   Player == 1,
  length(AllPieces , L),
  Length is L+1,
  random(1, Length , R),
  nth1(R,AllPieces,Result),
  Rp is R,
  delete(AllPieces,Result,NewAllPieces),
  bestMove([Player, play, Board], [NextPlayer, State, BestSuccBoard] , Result),  %%%%%%%%%%%
  indexOf(BestSuccBoard,Result,Index),
  Position is Index.




% nextPlayer(X1, X2)

% True if X2 is the next player to play after X1.

nextPlayer(1, 0).

nextPlayer(0, 1).



% When human play
humanMove([X1, play, Board], [X2, State, NextBoard], Result ,Pos) :-
    nextPlayer(X1, X2),
    set1(Pos, Result, Board, NextBoard),
    (
      winPos(NextBoard), !, State = win ;
      drawPos(Board,NextBoard), !, State = draw ;
      State = play
    ).




% set1(+Elem, +Pos, +List, -ResList).

% Set Elem at Position Pos in List => Result in ResList.

% Rem : counting starts at 1.

set1(1, E, [X|Ls], [E|Ls]) :-
  !, X = 0.


set1(P, E, [X|Ls], [X|L2s]) :-

  number(P),

  P1 is P - 1,

  set1(P1, E, Ls, L2s).

 

:- module(minimax, [minimax/3]).

% minimax(Pos, BestNextPos, Val)
% Pos is a position, Val is its minimax value.
% Best move from Pos leads to position BestNextPos.
minimax(Pos, BestNextPos, Val , CurrentPiece) :-                     % Pos has successors
    bagof(NextPos, move(Pos, NextPos , CurrentPiece), NextPosList),
    best(NextPosList, BestNextPos, Val , CurrentPiece),!.

minimax(Pos, _, Val , _) :-                     % Pos has no successors
    utility(Pos, Val).  


best([Pos], Pos, Val , AllCurrentPieces) :-
    minimax(Pos, _, Val , AllCurrentPieces), !.

best([Pos1 | PosList], BestPos, BestVal , AllPieces) :-
    minimax(Pos1, _, Val1 , AllPieces),
    best(PosList, Pos2, Val2 , AllPieces),
    betterOf(Pos1, Val1, Pos2, Val2, BestPos, BestVal).



betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
    max_to_move(Pos0),                         % MIN to move in Pos0
    Val1 > Val0, !                             % MAX prefers the greater value
    ;
    min_to_move(Pos0),                         % MAX to move in Pos0
    Val0 > Val1, !.                            % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0



% ------------------------------------------------------------------------------------------
:- module(tictactoe, [move/2,min_to_move/1,max_to_move/1,utility/2,winPos/2,drawPos/2]).


% move(+Pos, -NextPos)

% True if there is a legal (according to rules) move from Pos to NextPos.

move([X1, play, Board],[X2, win, NextBoard] , CurrentPiece) :-

 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard),

 winPos(NextBoard), !.

nextPlayer(1,0).
nextPlayer(0,1).


move([X1, play, Board],[X2, draw, NextBoard] , CurrentPiece) :-

 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard),

 drawPos(X1,NextBoard),!.



move([X1, play, Board], [X2, play, NextBoard], CurrentPiece) :-
 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard).



% move_aux(+Player, +Board, -NextBoard)

% True if NextBoard is Board whith an empty case replaced by Player mark.


move_aux(P, [0|Bs], [P|Bs]).


move_aux(P, [B|Bs], [B|B2s]) :-
  move_aux(P, Bs, B2s).


% min_to_move(+Pos)

% True if the next player to play is the MIN player.

min_to_move([0, _, _]).


% max_to_move(+Pos)

% True if the next player to play is the MAX player.

max_to_move([1, _, _]).


% utility(+Pos, -Val) :-

% True if Val the the result of the evaluation function at Pos.

% We will only evaluate for final position.

% So we will only have MAX win, MIN win or draw.

% We will use  1 when MAX win

%             -1 when MIN win

%              0 otherwise.

utility([1, win, _], 1).
% Previous player (MAX) has win.

utility([0, win, _], -1).
% Previous player (MIN) has win.

utility([_, draw, _], 0).


% winPos(+Player, +Board)

% True if Player win in Board.


winPos([X1, X2, X3, X4, X5, X6, X7, X8, X9]) :-
  equal(X1, X2, X3) ;
  % 1st line

  equal(X4, X5, X6) ;
  % 2nd line

  equal(X7, X8, X9) ;
  % 3rd line

  equal(X1, X4, X7) ;
  % 1st col

  equal(X2, X5, X8) ;
  % 2nd col

  equal(X3, X6, X9) ;
  % 3rd col

  equal(X1, X5, X9) ;
  % 1st diag

  equal(X3, X5, X7).
% 2nd diag

% drawPos(+Player, +Board)

% True if the game is a draw.

drawPos(_,Board) :-
  count(Board,0,C),
  C < 2.

% equal(+W, +X, +Y, +Z).

% True if W = X = Y = Z.
% True if they have any common atrribute
equal([A1|_], [A1|_], [A1|_]).
equal([_,A2,_], [_,A2,_], [_,A2,_]).
equal([_,_,A3], [_,_,A3], [_,_,A3]).

%Count number of zeros to check if we have a draw
count([],X,0):- !.
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).