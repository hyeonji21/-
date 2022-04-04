
data ex2_1;
 input MAF SOC WAGE;
 
 /* 차분된 값을 보기 위해 확인한다 */
 MAF_D = DIF(MAF);  /* MAF_1 : MAF의 이전 값이 나오게 됨. */
 SOC_D = DIF(SOC); 
 WAGE_D = DIF(WAGE);
 
 year=1979+_n_;   /*_n_ : 자동 변수 */
 time=_n_;
 
 if year < 1989 then ref=1;
  else if 1989 <= year < 1998 then ref=2;
  else ref=3;  
  
 cards;
2955 	5951 	131770 
2859 	6239 	156926 
3033 	6624 	179736 
3266 	6816 	200263 
3348 	7024 	216333 
3504 	7578 	236831 
3826 	7830 	257124 
4416 	8172 	281537 
4667 	8579 	327768 
4882 	9150 	396051 
4911 	9858 	472718 
5156 	10704 	552814 
4980 	11301 	632306 
4720 	11871 	700684 
4758 	12560 	773133 
4818 	13168 	868843 
4725 	13782 	983186 
4537 	14365 	1064134 
3917 	13603 	1060951 
4027 	13943 	1128112 
4293 	14603 	1227832 
4267 	15139 	1296891 
4241 	15841 	1458006 
4205 	15967 	1563866 
4290 	16427 	1679297 
4234 	16789 	1825079 
4167 	17181 	1934598 
4119 	17569 	2048577 
4079 	17784 	2168286 
;
run;

/* 프로그램 2.4 */
data EX2_2; set EX2_1;
  if YEAR<1989 then T=0; 
  else if 1989 <= Year < 1998 then  T=1;   
  else T=2;
TYEAR=T*YEAR;
run;

proc autoreg data=EX2_2;
  where T <= 1;
  model SOC=T YEAR TYEAR;
  TEST YEAR-TYEAR=0;
run;


proc gplot data=ex2_1;
 plot SOC*time;
run;
quit;



/* 프로그램 2.6 */
data EX2_3; set EX2_1;
 if YEAR<1989 then T=0; 
  else if 1989 <= Year < 1998 then  T=1;  
else T=2;
run;


data EX2_3; set EX2_1;
  if YEAR<1989 				   then do; D1=0; D2=0; end;  /* 더미변수를 2개로 놓음. */
  else if 1989 <= year <1998  then  do; D1=1; D2=0; end ;
  else do;                              D1=0; D2=1; end;  
  
  D1YEAR=D1*YEAR; D2YEAR=D2*YEAR; /* 모형까지 바뀌게 됨 */
run;


/* 기간에 따라 회귀 계수가 차이가 나는 것을 확인하였으므로 이제는 회귀 모형을 만들 것임. */

/* 일단 2개의 구간으로 나눴을 경우 확인 */
proc autoreg data=EX2_3;
  model soc = year;
  model SOC=D1 YEAR D1YEAR;
  where year < 1998;
run;

/* 구간 3개로 나눴을 때 확인 */
proc autoreg data=EX2_3;
 model soc = year;
 model SOC = D1 D2 YEAR D1YEAR D2YEAR;
run;



/* 3개의 회귀식 확인하기 */

/* D1=0, D2=0일때  : 32만명*/
/*
y = bo + b1year + e
: y = -637103 + 324.7500year + e


/* D1=1, D2=0일때 : 64만명 정도*/
/* 
y = b0 + d1 + d1year + b1year + e
: y = -637103 + -640473year + 322.2333 + 323.7500year + e
: y = -636,780.7667 -640,149.25year + e

/* D1=0, D2=1일때 : 426000만명 정도 */
/*
y = bo + d2 + d2year + b1year + e
: y = -637103 + -203358 + 102.7864 + 324.7500year + e
: y = -840,358.2136 + 324.7500year + e
*/


/* 프로그램 2.8 */
proc autoreg data=EX2_1;
 where 1992 <= year <= 2008;
 MAF : model maf = year wage;
 SOC : model soc = year wage;
run;

proc autoreg data=EX2_1;
 where 1992 <= year <= 2008;
 MAF : model maf = year wage/chow=(6 7 8 9 10 11 12 13);
 SOC : model soc = year wage/chow=(6 7 8 9 10 11 12 13);
run;


/*프로그램 2.9 */
data EX2_3; set EX2_1;
  where 1992 <= year <= 2008;
  if YEAR< 1998 then D=0;  else D=1;
  DYEAR=D*YEAR; DWAGE=D*WAGE;
run;

proc autoreg data=EX2_3;
  model MAF=D YEAR DYEAR WAGE DWAGE  ;
run;

/* model */
/*
D=0일때
MAF = 375606 + -186.5299*year + 0.001415*wage + e

D=1일때
y = 375606 -1172585 -186.5299year + 589.2252year + 0.001415wage -0.004864*wage
: y = -796979 + 402.72*year - 0.003449*wage
*/

/* 98년 이전에는 시간에 따라서 maf는 감소하는데, 98년 이후에는 wage에 의한 효과가 아니라 산업의 변화에 따라 402만큼 증가하고 있음. */
/* 기간에 따라 변곡점이 생겼을때, 회귀계수를 더미로 나눠 진행한다. */


/* 프로그램 2.12 */
data tres;
 do i= 1 to 80;
   AGE = rand('Table', 0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1)+29;
   LEVEL = rand('Table', 0.25, 0.25, 0.25, 0.25);
   if LEVEL = 1 then  do; D1=0; D2=0; D3=0; end;
     else if LEVEL = 2 then  do; D1=1; D2=0; D3=0; end;
	   else if LEVEL = 3 then  do; D1=1; D2=1; D3=0; end;
	     else if LEVEL = 4 then  do; D1=1; D2=1; D3=1; end;
    INCOME = 20+0.9*AGE+5*D1+4*D2+3*D3+2*rannor(0);
	output;
  end;
run;

proc sort data=tres;
by d1 d2 d3;
run;

proc print data=tres;
run;


proc autoreg data=tres;
 model INCOME=AGE D1 D2 D3;
run;

/*
고졸일때
INCOME = 19.2857 + 0.9060*AGE 

대졸
INCOME = 19.2857 + 0.9060*AGE  + 5.8318

석사일때
INCOME = 19.2857 + 0.9060*AGE + 3.7155

박사일때
INCOME = 19.2857 + 0.9060*AGE + 3.0752

: 절편만 바뀌는 것을 확인할 수 있음.
: 대졸이 절편이 가장 큼, 기본적인 수익이 많다는 것. / 지금은 절편만 더미변수로 바꿔준 것. 
*/

/* 자료를 탐색하면서 (그래프) -> 분계점 모형, 등등을 찾아가면서 해봐야함.















