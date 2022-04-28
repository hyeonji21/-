/* 사례분석1 - 다중선형회귀분석 */

/* 프로그램 1.1  다중선형회귀분석 프로그램*/
/* 1. 데이터 생성 */
data ex2_1;
 input MAF SOC WAGE;

 /* 현시점과 과거시점 차이를 구할 수 있는 함수 : DIF */
 DIF_MAF = DIF(MAF);
 DIF_SOC = DIF(SOC); 
 DIF_WAGE = DIF(WAGE);
 
 year=1979+_n_;   
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
proc print data=ex2_1;
run;



/* 2. 그래프 그리기 */
/* 추세(trend), 변동성(분산), 특이점(outlier) 확인 */

/* MAF) */
proc gplot data=ex2_1;
	plot MAF * time;  /* 세로 * 가로 */
run; quit;

proc gplot data=ex2_1;
 plot(MAF DIF_MAF) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_MAF * time;
run; quit;


/* SOC) */
proc gplot data=ex2_1;
	plot SOC * time;  /* 세로 * 가로 */
run; quit;

proc gplot data=ex2_1;
 plot(SOC DIF_SOC) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_SOC * time;
run; quit;


/* WAGE) */
proc gplot data=ex2_1;
	plot WAGE * time;  /* 세로 * 가로 */
run; quit;

proc gplot data=ex2_1;
 plot(WAGE DIF_WAGE) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_WAGE * time;
run; quit;



/* 3. 진단 */
proc autoreg data=ex2_1 plots;
 MAF : model MAF= year WAGE;
run;

proc autoreg data=ex2_1 plots;
 SOC : model SOC= year WAGE;
run;


 
 
/* 사례분석2 - 회귀계수의 검정 및 제약 */

/* 프로그램 2.2  F검정과 t검정 */
/* 회귀계수 = 0 인지 아닌지 판단 (위와 다른 방법)*/
proc autoreg data=EX2_1;
 model MAF=YEAR WAGE;
 test YEAR=0, WAGE=0; 
 test YEAR=0;
run;



/* 프로그램 2.3  그룹별 회귀분석*/
/* 그래프 -> 변동성 확인 -> year별로 나눠서 검정 */
proc gplot data=ex2_1;
 plot SOC * time;  /* 세로 * 가로 */
run;
quit;

data ex2_2; set ex2_1;
 if      YEAR < 1989		  then T=0;
 else if 1989 <= Year < 1998  then T=1;
 else 						  T=2;
run;

proc autoreg data=ex2_2; 
 model SOC=YEAR;  /* WAGE는 앞서 유의하지 않았기에 제거 */
 by T;
run;



/* 프로그램 2.4  H0: B11* = B11 검정을 위한 프로그램 */
/* 위 모형에서 구한 회귀계수에 대한 검정 (2b1=b2인지 아닌지)*/
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



/* 프로그램 2.6  서비스업 취업자 수 증가율 검정을 위한 프로그램 */
/* dummy 모형 (dummy 2개, class 3개) */
data EX2_3; set EX2_1;
  if YEAR < 1989 				   then do; D1=0; D2=0; end;  
  else if 1989 <= YEAR <1998  then  do; D1=1; D2=0; end ;
  else do;                              D1=0; D2=1; end;  
  
  D1YEAR=D1*YEAR; D2YEAR=D2*YEAR; /* 모형까지 바뀌게 됨 */
run;

/* 구간 2개로 나눴을 때 확인 */
proc autoreg data=EX2_3;
  model SOC = YEAR;
  model SOC =D1 YEAR D1YEAR;
  where year < 1998;
run;

/* 구간 3개로 나눴을 때 확인 */
proc autoreg data=EX2_3;
 model SOC = YEAR;
 model SOC = D1 D2 YEAR D1YEAR D2YEAR;
run;




/* 사례분석3 - 회귀계수 안정성 */

/* 프로그램 2.8  회귀계수 안정성을 위한 프로그램 */
/* 회귀계수의 안정성_변곡점 (모를 때) 찾아내기_CHOW test */
proc autoreg data=EX2_1;
 where 1992 <= year <= 2008;  /*(1992=1 ~ 2008=13)*/
 MAF : model maf = year wage/chow=(6 7 8 9 10 11 12 13);
 SOC : model soc = year wage/chow=(6 7 8 9 10 11 12 13);
run;


/* 프로그램 2.9  양분점 원인 검정을 위한 프로그램 */
/* 위의 모형을 통해 구한 양분점(t=7)에 대한 검정 */
data EX2_3; set EX2_1;
  where 1992 <= year <= 2008;
  if YEAR< 1998 then D=0;  else D=1;
  DYEAR=D*YEAR; DWAGE=D*WAGE;
run;

proc autoreg data=EX2_3;
  model MAF=D YEAR DYEAR WAGE DWAGE  ;
run;





/* 사례분석 5 - 분계점 효과 */

/*프로그램 2.12  분계점 효과 추정을 위한 가상자료 생성 및 분석 프로그램 */
/* 분계점 효과 (범주형 변수를 dummy로 나누어 효과를 봄) */
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
















