/* TEM : 월평균 기온, TN : 탄산음료출하량, B : 맥주출하량 */
/* 1. 데이터 불러오기 */
proc print data=practice_2;
run;


data prac_2; set practice_2;
 DIF_TEM = DIF(TEM);
 DIF_TN = DIF(TN); 
 DIF_B = DIF(B);
run;

proc print data=prac_2;
run;


/* 2. 그래프 그리기 */
/* 추세(trend), 변동성(분산), 특이점(outliter) 확인 */
proc gplot data=prac_2;
	where time contains '1996';
	plot TEM * time;  /* 세로 * 가로 */
run; quit;

proc gplot data=prac_2;
	plot TEM * count;  /* 세로 * 가로 */
run; quit;

proc gplot data=prac_2;
 plot(TEM DIF_TEM) * time / overlay;
run; quit;

proc gplot data=prac_2;
	plot DIF_TEM * time;
run; quit;



/* 3. 진단 */
proc autoreg data=prac_2 plots;
 TN : model TN = TEM;
run;

proc autoreg data=prac_2 plots;
 B : model B = TEM;
run;


/* F검정과 t검정 */
/* 회귀계수 = 0 인지 아닌지 판단 (위와 다른 방법)*/
proc autoreg data=prac_2;
 model TN = TEM;
 test TEM=0;
run;

proc autoreg data=prac_2;
 model B = TEM;
 test TEM=0;
run;

/*
proc autoreg data=prac_2;
 model TN = TEM;
 test TEM=1174;
run;

proc autoreg data=prac_2;
 model B = TEM;
 test TEM=1174;
run;
*/


/* 사례분석3 - 회귀계수 안정성 */
/* 회귀계수의 안정성_변곡점 (모를 때) 찾아내기_CHOW test */


proc autoreg data=prac_2;
 where 1 <= count <= 10;
 TN : model TN = count TEM/chow=(1 2 3 4 5 6 7 8 9 10);
 B : model B = count TEM/chow=(1 2 3 4 5 6 7 8 9 10);
run;

proc autoreg data=prac_2;
 TN : model TN = TEM/chow=(1 2 3 4 5 6 7 8 9 10 11 12);
 B : model B = TEM/chow=(1 2 3 4 5 6 7 8 9 10 11 12);
run;


/* 양분점 원인 검정을 위한 프로그램 */
data prac_3; set prac_2;
  where 1 <= count <= 10;
  if count < 6 then D=0;  else D=1;
  DTEM=D*TEM;
run;
proc autoreg data=prac_3;
  model TN =D TEM DTEM;
run;

data prac_3; set prac_2;
  where 1 <= count <= 10;
  if count < 8 then D=0;  else D=1;
  DB=D*B;
run;
proc autoreg data=prac_3;
  model TN =D B DB;
run;














