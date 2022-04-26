/* 1. 데이터 생성 */
data JTEST;
 input YEAR EXP LC;
 LEXP=log(EXP); LLC=log(LC); SLC=sqrt(LC);
 
 DIF_EXP = DIF(LEXP);
 DIF_LC = DIF(LLC);
 
 time=_n_;
 
 cards;
1979  15055.5 12731.7 
1980  17504.9 15836.4 
1981  21253.8 17896.1 
1982  21853.3 16096.1 
1983  24445.1 17581.7 
1984  29244.9 19383.9 
1985  30283.1 19558.2 
1986  34714.5 25358.9 
1987  47280.9 34784.7 
1988   60696.4  42786.9
1989   62377.2  45533.7
1990   65015.7  47519.7
1991   71870.1  50005.0
1992   76631.5  52352.2
1993   82235.9  55594.7
1994   96013.2  64314.1
1995  125058.0  72926.3
1996  129715.1  69732.7
1997  136164.2  67615.4
1998  132313.1  56915.0
1999  143685.5  58030.9
2000  172267.5  61868.5
2001  150439.1  53269.8
2002  162470.5  52264.9
2003  193817.5  60342.7
2004  253844.8  72426.2
2005  284418.7  74255.7
2006  325464.9  89189.9
2007  371489.0  91250.0
2008  422007.3 100526.1
2009  363533.4  76425.5
2010  466383.8  93214.1
;
run;
proc print data=JTEST;
run;


/* 2. 그래프 그리기 */
/* 추세(trend), 변동성(분산), 특이점(outliter) 확인 */

/* EXP */
proc gplot data=JTEST;
	plot EXP * time;
run; quit;

proc gplot data=JTEST;
 plot(EXP DIF_EXP) * time / overlay;
run; quit;

proc gplot data=JTEST;
	plot DIF_EXP * time;
run; quit;


/* LC */
proc gplot data=JTEST;
	plot LC * time;
run; quit;

proc gplot data=JTEST;
 plot(LC DIF_LC) * time / overlay;
run; quit;

proc gplot data=JTEST;
	plot DIF_LC * time;
run; quit;


/* 3. 진단 */
proc autoreg data=JTEST plots;
	EXP : model EXP = YEAR LC;
run;


proc autoreg data=JTEST;
 model EXP=YEAR LC;
 test YEAR=0, LC=0;
 test YEAR=0;
run;


/* 회귀계수 안정성_변곡점 찾기 */
/* 시도 

proc autoreg data=JTEST;
 where 1979 <= year <= 1995;
 EXP : model exp = year LC / chow=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17);
run;

proc autoreg data=JTEST;
 where 1996 <= year <= 2010;
 EXP : model exp = year LC / chow=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15);
run;
*/

proc autoreg data=JTEST;
 where 1994 <= year <= 2008;
 EXP : model exp = year LC / chow=(1 2 3 4 5 6 7 8 9);
 EXP : model exp = year LC / chow=(11 12 13 14);
run;



/* 그룹별 회귀분석 */
data JTEST_g; set JTEST;
 where 1994 <= year <= 2008;
 if year < 2004 then D=0;
 else D=1;
 DLC = D*LC; 
run;

proc autoreg data=JTEST_g;
 model EXP=YEAR LC DLC;
run;



/* dummy 모형 만들기 (dummy 3개, class 4개) */
/*
data JTEST_2; set JTEST;
 if YEAR < 1986 THEN DO; D1=0; D2=0; D3=0; END;
 else if 1986 <= YEAR < 1997 THEN DO; D1=1; D2=0; D3=0; END;
 else if 1997 <= YEAR < 2007 THEN DO; D1=1; D2=1; D3=0; END;
 else do; D1=1; D2=1; D3=1; END;
 
 D1YEAR=D1*YEAR; D2YEAR=D2*YEAR; D3YEAR=D3*YEAR;
 D1LC=D1*LC; D2LC=D2*LC; D3LC = D3*LC;
run;

proc autoreg data=JTEST_2;
 model EXP = D1 D2 YEAR D1YEAR D2YEAR D3YEAR LC D1LC D2LC D3LC;
run;
*/


/* (dummy 2개, class 3개) */
data JTEST_3; set JTEST;
 if YEAR < 1999 THEN DO; D1=0; D2=0; END;
 else if 1999 <= YEAR < 2004 THEN DO; D1=1; D2=0; END;
 else do; D1=0; D2=1; END;
 
 D1YEAR=D1*YEAR; D2YEAR=D2*YEAR;
 D1LC=D1*LC; D2LC=D2*LC;
run;

proc autoreg data=JTEST_3;
 model EXP = D1 D2 YEAR D1YEAR D2YEAR LC D1LC D2LC;
run;


/* 책 모형 
proc autoreg data=JTEST;
 model LEXP = SLC;  output out= H1 pm=y_hat; run;

proc autoreg data=H1;
 model LEXP = LLC y_hat; run;

proc autoreg data=JTEST;
 model LEXP = LLC;  output out= H0 pm=y_hat; run;

proc autoreg data=H0;
 model LEXP = y_hat SLC; run;
*/








