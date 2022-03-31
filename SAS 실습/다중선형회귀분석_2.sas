/* 회귀모형을 아는 것이 우리의 목표 (지금은 알고 있으나) */

/* 선형 회귀식 확인 : y=3+1.5*x  (모수 추정) */
data tmp;
do i=1 to 10;
	x=i;
	y=3+1.5*x;
	output;
end;
run;

proc print data=tmp;
run;


/* 선형 회귀식 확인 : y=3+1.5*x+e ~ N(0,1) */
/* 시뮬레이션 실행 */
data tmp;
do i=1 to 10;
	x=i;
	e=rannor(0);
	y=3+1.5*x+e;
	output;
end;
run;

proc print data=tmp;
run;


/* 모델 확인 */
proc reg data=tmp;
	model y=x;
run; quit;

/* 결과 확인 */
/* intercept : 2.34077 */
/* R Square : 0.95 => 변동성이 크다고 할 수 있음. */
/* Parameter Estimates -> H0:B1=0, H1:B1!=0 */
/* 확률 모형임. */
/* 오차항 : 등분산성, 독립성 (iid) */
/* 그래프 => 잔차 플롯 확인 : 패턴화 확인(1행) & 정규성 확인 : 선에 가까운지 확인(2행) */

/* 잔차(residual) : y-y^ / 오차(error) : 잔차를 이용해 오차를 추정 => sample에 기반하기에 생길 수 밖에 없음. */
/* fit : 적합 */


/* =================================================================== */

/*
  사례분석1 = 다중선형회귀분석 (p.25)
  
   MAF : 제조업 취업자수(명)
   SOC : 사회간접자본 및 기타서비스업 취업자수(명)
   WAGE : 제조업 월급여(정액급여+초과급여)
   
   알고 싶은 것) MAF = f(time,wage), SOC = f(time,wage) 
   
*/
/* 소문자 -> 대문자 하는 방법 : 드래그 후 shift + ctrl + u */
/* 대문자 -> 소문자 하는 방법 : 드래그 후 shift + l */

/* 데이터 & 탐색 */

data ex2_1;
 input MAF SOC WAGE;
 
 MAF_1 = lag(MAF);  /* MAF_1 : MAF의 이전 값이 나오게 됨. */
 DIF_MAF = MAF - MAF_1;   /* 시차 변수 */

 DIF_SOC = DIF(SOC); /* lag 함수를 안쓰고 현시점과 과거시점 차이를 구할 수 있는 함수 : dif */
 
 DIF_WAGE = DIF(WAGE);
 
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

proc print data=ex2_1;
run;


/* 그래프 그리기 */
/* 시간이 지남에 따라 취업자 수는 어떻게 나타나는지 ? (시계열 자료) */
/*  1) 추세 (trend),  2) 변동성 (분산),  3) 특이점 / outlier */


/* MAF */
proc gplot data=ex2_1;
	plot MAF * time;  
run;

proc gplot data=ex2_1;
 plot(MAF DIF_MAF) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_MAF * time;
run;


/* SOC */
proc gplot data=ex2_1;  
	plot SOC * time;
run;
/* 시간에 따라 증가 (monotomic 단조적 증가) */
/* 변동성은 작아보인다. */

proc gplot data=ex2_1;
	plot(SOC DIF_SOC) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_SOC * time;
run;
/* 변동성이 조금 있어보이나 축(단위)를 확인해봐야할 것. => 축을 바꿔보았을 때 변동성 x */
/* outlier 존재 */


/* WAGE */
proc gplot data=ex2_1;
	plot WAGE * time;
run;

proc gplot data=ex2_1;
	plot (WAGE DIF_WAGE) * time / overlay;
run; quit;

proc gplot data=ex2_1;
	plot DIF_WAGE * time;
run;


/* 프로그램 2.1 */
proc autoreg data=ex2_1;
 SOC: model SOC= year WAGE;   /* target variable : SOC -> 영향 주는 것 : year, WAGE */
run;

proc autoreg data=ex2_1;
 MAF: model MAF= year WAGE;   /* target variable : MAF -> 영향 주는 것 : year, WAGE */
run;











