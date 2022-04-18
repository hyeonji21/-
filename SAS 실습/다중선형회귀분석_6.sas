/* 20개 */
data tmp;

	do i=1 to 20;
		x = rannor(0); output;  /* 정규분포에서 각각 뽑은 값들을 x에 넣음 */
	end;

run;

/* => 20개를 뽑아 평균을 구하면 0에 가까워짐 (sample이므로 정확히 0은 아니다) (normal에서 뽑았기 때문에) */
/*                (분산은 1)*/

proc means data=tmp;
	var x;
run;


/* 2000개 */
data tmp;
	do i=1 to 2000;
	 x1 = rannor(0); /* 분포 : N~(0, 1) */
	 x2 = x1 + 1;    /*         */
	 x3 = x1 - 2;    /* (-2, 0) */
	 x4 = x1 * 0.5;  /* 표준편차 0.5 차이 */
	 x5 = x1 * 2;  /* 표준편차 2배 */
	output;  
	end;
run;

/* => 2000개를 뽑아 평균을 구하면 0에 가까워짐 (sample이므로 정확히 0은 아니다) (normal에서 뽑았기 때문에) */
/*                (분산은 1)*/

proc means data=tmp;
	var x1 x2 x3 x4 x5;
run;

/* ex) 최솟값 -3.90가 나올 확률 ?  : 정규분포표 확인 */



/* 회귀분석 */
/* 시뮬레이션 */
/* 평균이 0, 분산이 1인 정규분포를 따른다. */
data tmp;
	do i=1 to 20;
	 x = i;
	 s = 2+1.5*x;
	 e = rannor(0); 
	 y = s + e;  /* 달라지는 값 : 오차항 */
	output;  
	end;
run;

proc gplot data=tmp;
 plot y * x;
run; quit;

proc autoreg data=tmp;
 model y=x;
run; quit;

/* R Square */
/* 오차가 동일한 분포인 N~(0,1)에서 나타난 오차항들 */
/* COOK'S Distance : 대부분 작게 나옴 */
/* Residual : 정규분포를 따르고 있음
/* 5, 6 그림 : 분포에 포함되면 correlation 없다는 것 */



/* 평균이 0, 분산이 계속 커지는 모형*/
data tmp;
	do i=1 to 20;
	 x = i;
	 s = 2+1.5*x;
	 e = 0.02*i*rannor(0);  /* -> i가 2일때) 분산 : 0.04 / i=3, i=4 -- */
	/* i가 커질수록 분산이 커짐 */
	 y = s + e;  /* 달라지는 값 : 오차항 */
	output;  
	end;
run;

proc gplot data=tmp;
 plot y * x;
run; quit;

proc autoreg data=tmp;
 model y=x;
run; quit;

/* ==> 분산만 문제가 되는 모형임 (OLS를 사용 X) */







