/* FIX_TIME : 수리시간, PART_COUNT : 부품 수, D : 수리 담당 */
data COM_FIX;
 input FIX_TIME PART_COUNT D;
 
 DIF_FIX_TIME = DIF(FIX_TIME);
 DIF_PART_COUNT = DIF(PART_COUNT); 
 
 time=_n_;

 cards;
23 		1 	1 
29 		2 	2 
49 		3 	1 
64 		4 	2 
74 		4 	1 
87 		5 	2 
96 		6 	1 
97 		6 	2 
109 	7 	1 
119 	8 	2 
149 	9 	1 
145 	9 	2 
154 	10 	1 
166 	10 	2 
;
run;

proc print data=COM_FIX;
run;

proc autoreg data=COM_FIX;
 FIX_TIME : model FIX_TIME = PART_COUNT;
run;


proc gplot data=COM_FIX;
	plot FIX_TIME * time;  
run; quit;

proc gplot data=COM_FIX;
	plot (FIX_TIME DIF_FIX_TIME) * time / overlay;  
run; quit;

proc gplot data=COM_FIX;
	plot DIF_FIX_TIME * time;  
run; quit;



proc gplot data=COM_FIX;
	plot PART_COUNT * time; 
run; quit;

proc gplot data=COM_FIX;
	plot (PART_COUNT DIF_PART_COUNT) * time / overlay;  
run; quit;

proc gplot data=COM_FIX;
	plot DIF_PART_COUNT * time;  
run; quit;


/* 진단 */
proc autoreg data=COM_FIX;
 FIX_TIME : model FIX_TIME = PART_COUNT D;
run;

proc autoreg data=COM_FIX;
 model FIX_TIME = PART_COUNT D;
 test PART_COUNT=0, D=0;
 test PART_COUNT=0;
run;



/* 더미 */
data COM_FIX_2; set COM_FIX;
 if T = 1 then do; D1=0; end;
 else if D = 2 then do; D1=1; end;
 
 D1PART_COUNT = D1*PART_COUNT;
run;

proc autoreg data=COM_FIX_2;
 FIX_TIME : model FIX_TIME = D1 D1PART_COUNT PART_COUNT;
run;


/* 구간에 따라 나누기 */

data COM_FIX_n; set COM_FIX;
  if time < 8				  then do; T1=0; T2=0; end;
  else if 8 <= time < 11      then do; T1=1; T2=0; end;
  else do;							   T1=0; T2=1; end;  
  
  T1PART_COUNT=T1*PART_COUNT; T1D=T1*D; /* 모형까지 바뀌게 됨 */
  T2PART_COUNT=T2*PART_COUNT; T2D=T2*D; /* 모형까지 바뀌게 됨 */
run;
proc autoreg data=COM_FIX_n plots;
  model PART_COUNT=T1 T2 PART_COUNT T1PART_COUNT T2PART_COUNT T1D T2D;
  where 1 <=time<=14;
run;







data COM_FIX_4; set COM_FIX;
 if time < 8 then do; T=0; end;
 else do; T=1; end;
run;

proc autoreg data=COM_FIX_4; 
 model FIX_TIME=PART_COUNT D;  
 by T;
run;

data COM_FIX_4; set COM_FIX;
 if time < 11 then do; T=0; end;
 else do; T=1; end;
run;

proc autoreg data=COM_FIX_4; 
 model FIX_TIME=PART_COUNT D;  
 by T;
run;





/* 회귀계수의 안정성_변곡점 (모를 때) 찾아내기_CHOW test */
proc autoreg data=COM_FIX;
 where 1 <= time <= 14;  /*(1992=1 ~ 2008=13)*/
 FIX_TIME : model FIX_TIME = PART_COUNT D/chow=(1 2 3 4 5 6 7 8 9 10 11 12 13 14);
run;










