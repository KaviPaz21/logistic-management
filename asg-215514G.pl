%@@@@@@@@@@@@@@@@-------------FACTS------------@@@@@@@@@@@@@@@

:-dynamic(start/2).
:-dynamic(w_house_con/2).
:-dynamic(destination/2).

%Startings choose beginig path from sri lanka.
start(sri_lanka, dubai).
start(sri_lanka , africa).

%path - 01.
w_house_con(sri_lanka , dubai).
w_house_con(dubai , rumania).
w_house_con(rumania,france).
%path - 02.
w_house_con(sri_lanka , africa).
w_house_con(africa,france).

%destinations for primary locations around ware house
w_house_con(france,X):-destination(france , X).
w_house_con(rumania,X):-destination(rumania , X).

%destinations
destination(france , england).

%details of costs and timings for each method
%format ->  (start , end  , cost , time,mode)

method(sri_lanka,dubai,186, 620,ship ).
method(sri_lanka,dubai, 900,30,flight ).

method(dubai,rumania,150,500,ship).
method(dubai,rumania,315,126,train).
method(dubai,rumania,600,20,flight).

method(rumania,france, 420, 14,flight ).
method(rumania,france, 225,90,train ).

method(sri_lanka,africa,372 ,1240 ,ship ).
method(sri_lanka,africa, 1650,55 ,flight ).

method(africa,france, 1140,38,flight ).
method(africa,france,600,240 ,train ).
method(africa,france, 252,840 ,ship ).


method(france,england, 80,100 ,ship ).
method(france,england, 50,42 ,train ).
method(france,england, 120,4 ,flight ).


%@@@@@@@@@@@@-------------RULES-------------@@@@@@@@@@@@@@@@@@@


%---------------------------------------------------------------------
%rule - path finding
%=====================================================================
roadmap(X,Y,Z):-w_house_con(X,Z1),destination(_,Y),route(Z1),roadmap(Z1,Y,K).
roadmap(X,Y,_):-destination(X,Y).


% ----------------------------------------------------------------------
% printing procedures
% ======================================================================
route(X):-write(X),write(' -> ').
droute(X,Y):-writeln(''),route(X),route(Y).
pmethod(C,M):-write(' || Costing - '),write(C),write( ' USD By - '),write(M).
ptotal(K):-writeln(''),write(' TOTAL COST IS  - '),write(K),write(' USD').

tmethod(C,M):-write(' || Taking - '),write(C),write( ' Hrs By - '),write(M).
ttotal(K):-writeln(''),write(' TOTAL TIME IS  - '),write(K),write(' HRS'),
    writeln(''),write(' APPROXIMATELY - '),D is round(K/24), write(D),write(' DAYS').


%-----------------------------------------------------------------------
% finding method for send something with minimum cost (not considerabout time)
% =======================================================================
mcostwh(S,D,T):-writeln(''),destination(S,D),droute(S,D),costing(S,Z,K),
    J is K+T,ptotal(J),!.
mcostwh(S,D,T):-
    writeln(''),
    w_house_con(S,Z),destination(_,D),droute(S,Z),costing(S,Z,K),
    J is K+T,
    mcostwh(Z,D,J).

mcost(S , D):-
    writeln(''),
    start(S,Z),destination(_,D),droute(S,Z),costing(S,Z,T),
    mcostwh(Z,D,T).

costing(S,E,T):-findall((Cost,Method), method(S,E,Cost,_,Method),MC),
    minpair(MC,Lcost,Lmethod),pmethod(Lcost,Lmethod)
    ,T is Lcost.

minpair(List , Lcost,Lmethod):- min_member((Lcost , Lmethod),List).



%----------------------------------------------------------------------
% finding method for send something with minimum time (not consider about cost)
% ========================================================================
mtime(S,D):-
    writeln(''), start(S,Z),destination(_,D),droute(S,Z),
    timing(S,Z,T),
    mtimewh(Z,D,T).
mtimewh(S,D,T):-writeln(''),destination(S,D),droute(S,D),timing(S,Z,K),
    J is K+T , ttotal(J),!.
mtimewh(S,D,T):-
    writeln(''),w_house_con(S,Z),destination(_,D),droute(S,Z),timing(S,Z,K),
    J is K+T, mtimewh(Z,D,J).

timing(S,E,T):-
    findall((Time,Method), method(S,E,_,Time,Method), TM),
    minpair(TM,MinTime,Mode),tmethod(MinTime,Mode),
    T is MinTime.


%##########output Quries********************
%query for derived paths

roadmapfind(X,Y):-start(X,Z),droute(X,Z),roadmap(Z,Y,K).
methodcost(Start,End):-mcost(Start,End).
methodtime(Start,End):-mtime(Start,End).
newstart(Start,Wh):-assert(start(Start,Wh)),assert(w_house_con(Start,Wh)).
newdes(WH,DES):-assert(destination(WH,DES)).












