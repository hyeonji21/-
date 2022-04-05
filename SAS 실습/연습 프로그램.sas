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


data EX2_2; set EX2_1;
	if YEAR < 1989 then T=0;
	else if 1989 <= Year < 1998 then T=1;
	else T=2;
TYEAR = T * YEAR;
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

data EX2_3;
	set EX2_1;
	if year < 1989 then T=0;
	else if 1989 <= year < 1998 then T=1;
	else T=2;
run;

data EX2_3; set EX2_1;
	if year < 1989  		    then do; D1=0; D2=0; end;
	else if 1989 <= year < 1998 then do; D1=1; D2=0; end;
	else 						     do; D1=0; D2=1; end;

	D1YEAR = D1*YEAR;
	D2YEAR = D2*YEAR;
run;

proc autoreg data=EX2_3;
 model SOC=year;
 model SOC=D1 YEAR D1YEAR;
 where year < 1998;
run;

proc autoreg data=ex2_3;
 model soc=year;
 model soc=d1 d2 year d1year d2year;
run;


proc autoreg data=EX2_1;
 where 1992 <= year <= 2008;
 MAF : model maf = year wage;
 SOC : model soc = year wage;
run;

proc autoreg data=EX2_1;
 where 1992 <= year <= 2008;
 MAF : model maf = year wage / chow=(6 7 8 9 10 11 12 13);
 SOC : model soc = year wage / chow=(6 7 8 9 10 11 12 13);
run;













































