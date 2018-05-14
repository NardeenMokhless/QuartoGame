% --------------------------------- %
% Name:            ID:      G:      %
% Mostafa Saber    20150253 G6      %
% Mina Yousry      20150272 G5      %
% Nardeen Mokhless 20150273 G5      %
% Mohamed Ashraf   20150316 G6      %
% --------------------------------- %

%board
%% %pieces
%% piece(black,round,tall).
%% piece(black,round,short).
%% piece(black,square,tall).
%% piece(black,square,short).
%% piece(white,round,tall).
%% piece(white,round,short).
%% piece(white,square,tall).
%% piece(white,square,short).



:- use_module(minimax).

:- use_module(tictactoe).

% bestMove(+Pos, -NextPos)

% Compute the best Next Position from Position Pos

% with minimax or alpha-beta algorithm.

bestMove(Pos, NextPos , AllPieces , FirstPlayer) :-
  minimax(Pos, NextPos, _ , AllPieces , FirstPlayer).

 

indexOf([Element|_], Element, 1):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.


% Start the game.
% play
play:-

  nl,
    write('===================='),
  nl,    write('= Quarto ='),
  nl,
    write('===================='),
  nl,
  nl,
    playFirst.


playFirst :-

    nl, write('who play first? (1 for computer or 0 for the player)'), nl,
    read(Player), nl,

    ( Player \= 1, Player \= 0, !,
      write('Error : not a valid choose!'), nl, playAskColor
      ;
      EmptyBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0],

      Pieces = [  [black,round,tall],
                  [black,round,short],
                  [black,square,tall],
                  [black,square,short],
                  [white,round,tall],
                  [white,round,short],
                  [white,square,tall],
                  [white,square,short]  ],

      show(EmptyBoard), nl,
  
% Start the game with color and emptyBoard
      play([Player, play, EmptyBoard , Pieces] , Player)
    ).



play([Player, play, Board , AllPieces], FirstPlayer) :-
  Player == 0,
  %playAskPiece(Board , AllPieces , Player, Result) ,nl,
  length(AllPieces , L),
  Length is L+1,
  random(1, Length , R),
  nth1(R,AllPieces,Result),nl,
  currentPieceShow(Result),nl,
  write('Next move ?'),nl,
  read(Pos), nl,
  (
    delete(AllPieces,Result,NewAllPieces),
    humanMove([Player, play, Board], [NextPlayer, State, NextBoard] ,Result, Pos), !,
    show(NextBoard),
    (
      State = win, !,
      nl, write('End of game : '),
      winMessage(Player), write(' win !'), nl, nl;
      State = draw, !,
      nl, write('End of game : '),
      write(' draw !'), nl, nl
      ;
      play([NextPlayer, play, NextBoard , NewAllPieces] , FirstPlayer)
    );
    write('-> Bad Move !'), nl,
    play([Player, play, Board , NewAllPieces] , FirstPlayer)
  ).




% play(+Position, +HumanPlayer)

% If it is not human who must play -> Computer must play

% Compute the best move for computer with minimax or alpha-beta.

play([Player, play, Board , AllPieces] , FirstPlayer):-
  !, Player == 1,
  nl, write('Computer play : '), nl, nl,
  length(AllPieces , L),
  Length is L+1,
  random(1, Length , R),
  nth1(R,AllPieces,Result),nl,
  currentPieceShow(Result),nl,
  delete(AllPieces,Result,NewAllPieces),
  bestMove([Player, play, Board, NewAllPieces], [NextPlayer, State, BestSuccBoard , _] , Result , FirstPlayer),
  show(BestSuccBoard),
  (
    State = win, !,
    nl, write('End of game : '),
    winMessage(Player), write(' win !'), nl, nl
    ;
    State = draw, !,
    nl, write('End of game : '), write(' draw !'), nl, nl;

    play([NextPlayer, play, BestSuccBoard , NewAllPieces] , FirstPlayer)
  ).



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




% show(+Board)

% Show the board to current output.

show([X1, X2, X3, X4, X5, X6, X7, X8, X9]) :-

  write('   '), show2(X1),
  write(' | '), show2(X2),
  write(' | '), show2(X3), nl,
  write('  ---------------------------------'), nl,
  write('   '), show2(X4),
  write(' | '), show2(X5),
  write(' | '), show2(X6), nl,
  write('  ---------------------------------'), nl,
  write('   '), show2(X7), 
  write(' | '), show2(X8),
  write(' | '), show2(X9), nl.

showPieces([X|Y], N):-
  M is N+1,
  write(N),
  write(' - '),
  write(X) , nl ,
  showPieces(Y, M).

showPieces([] , _):- !.




% show2(+Term)

% Write the term to current outupt
% Replace 0 by ' '.

show2(X) :-
  X = 0, !,
  write('        ').


show2([A , B , C]) :-
  write(' '),
  showChar(A),
  showChar(B),
  showChar(C),
  write(' ').



:- module(minimax, [minimax/3]).

% minimax(Pos, BestNextPos, Val)
% Pos is a position, Val is its minimax value.
% Best move from Pos leads to position BestNextPos.
minimax(Pos, BestNextPos, Val , CurrentPiece , FirstPlayer) :-                     % Pos has successors
    bagof(NextPos, move(Pos, NextPos , CurrentPiece), NextPosList),
    best(NextPosList, BestNextPos, Val , FirstPlayer),!.

minimax(Pos, _, Val , _ , FirstPlayer) :-                     % Pos has no successors
    utility(Pos, Val , FirstPlayer).  


best([Pos], Pos, Val , FirstPlayer) :-
    minimax(Pos, _, Val , _ , FirstPlayer), !.

best([ [Player, State , Board , [NextPiece | Rest]] | PosList], BestPos, BestVal , FirstPlayer) :-
    minimax([Player, State , Board , Rest], _, Val1 , NextPiece , FirstPlayer),
    best(PosList, Pos2, Val2 , FirstPlayer),
    betterOf([Player, State , Board , [NextPiece | Rest]], Val1, Pos2, Val2, BestPos, BestVal , FirstPlayer).



betterOf(Pos0, Val0, _, Val1, Pos0, Val0 , FirstPlayer) :-   % Pos0 better than Pos1
    max_to_move(Pos0 , FirstPlayer),                         % MIN to move in Pos0
    Val1 > Val0, !                             % MAX prefers the greater value
    ;
    min_to_move(Pos0 , FirstPlayer),                         % MAX to move in Pos0
    Val0 > Val1, !.                            % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1 , FirstPlayer).        % Otherwise Pos1 better than Pos0



% ------------------------------------------------------------------------------------------
:- module(tictactoe, [move/2,min_to_move/1,max_to_move/1,utility/2,winPos/2,drawPos/2]).


% move(+Pos, -NextPos)

% True if there is a legal (according to rules) move from Pos to NextPos.

move([X1, play, Board , Pieces],[X2, win, NextBoard , Pieces] , CurrentPiece) :-

 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard),

 winPos(NextBoard), !.

nextPlayer(1,0).
nextPlayer(0,1).


move([X1, play, Board , Pieces],[X2, draw, NextBoard , Pieces] , CurrentPiece) :-

 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard),

 drawPos(X1,NextBoard),!.



move([X1, play, Board , Pieces], [X2, play, NextBoard , Pieces], CurrentPiece) :-
 nextPlayer(X1, X2),

 move_aux(CurrentPiece, Board, NextBoard).



% move_aux(+Player, +Board, -NextBoard)

% True if NextBoard is Board whith an empty case replaced by Player mark.


move_aux(P, [0|Bs], [P|Bs]).


move_aux(P, [B|Bs], [B|B2s]) :-
  move_aux(P, Bs, B2s).


% min_to_move(+Pos)

% True if the next player to play is the MIN player.

min_to_move([0, _, _ , _] , 1).


% max_to_move(+Pos)

% True if the next player to play is the MAX player.

max_to_move([1, _, _ , _] , 1).

min_to_move([1, _, _ , _] , 0).

max_to_move([0, _, _ , _] , 0).

% utility(+Pos, -Val) :-

% True if Val the the result of the evaluation function at Pos.

% We will only evaluate for final position.

% So we will only have MAX win, MIN win or draw.

% We will use  1 when MAX win

%             -1 when MIN win

%              0 otherwise.

utility([1, win, _ , _], 1 , 1).
% Previous player (MAX) has win.

utility([0, win, _ , _], -1 , 1).

utility([0, win, _ , _], 1 , 0).

utility([1, win, _ , _], -1 , 0).
% Previous player (MIN) has win.

utility([_, draw, _ , _], 0 , _).


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


winMessage(X) :-
  X = 0, !,
  write('Player').

winMessage(X) :-
  X = 1, !,
  write('Computer').

currentPieceShow(Piece):-
  write('Your current piece: '),
  show2(Piece) , nl.

showChar(X) :-
  X = black, !,
  write(' b').

showChar(X) :-
  X = white, !,
  write(' w').

showChar(X) :-
  X = round, !,
  write(' r').

showChar(X) :-
  X = square, !,
  write(' s').

showChar(X) :-
  X = short, !,
  write('sh').

showChar(X) :-
  X = tall, !,
  write(' t').