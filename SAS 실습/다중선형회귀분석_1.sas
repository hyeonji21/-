/* [가설 검증]의 절차를 시뮬레이션(잘 알아야함) */
/* rannor, ranuni */

/* 정규분포 : 위치모수, 스케일모수 (평균, 표준편차) -> 수많은 정규분포 존재. */
/* N~(0,1) : 가운데의 밀도가 가장 높음 / 밀도를 나타낸 막대분포 : 히스토그램 */

/* 표준정규분포 -> 임의의 x값을 뽑아라 (랜덤 샘플링) */
/* 모든 정규분포를 표준정규분포로 만들 수 있다. (표준화) */

/* uniform 분포 -> 0부터 1사이의 밀도가 균일하게 나타나는 함수 */

data tmp;
	x = rannor(0);
run;

proc print data=tmp;
run;


/* n번 추출 */
data tmp;
 do i=1 to 10000;
 	x1 = rannor(0);
 	x2 = ranuni(0);
 	output;
 end;
run;
/*
proc print data=tmp;
run;
*/
/* 히스토그램으로 보기 */
proc univariate data=tmp;
	var x1 x2;
	histogram x1 x2 / normal;
run;



/* 한번에 3개 뽑기  (하나씩 x) */
/* x1 + x2 + x3 / 3 => 표본평균(sample mean)*/

/* 표본 평균의 분포는 어떤지 알아보고 싶은 것 (중요)*/
data tmp;
	do i=1 to 10000;
	x1 = rannor(0);
	x2 = rannor(0);
	x3 = rannor(0);
	antlr = (x1 + x2 + x3)/3;
	emfantlr = mean(x1, x2, x3);
	dksantlr = mean(of x1-x3);
	output;
	end;
run;

/* 표본 평균의 히스토그램 */
proc univariate data=tmp;
	var antlr emfantlr dksantlr;
	histogram antlr emfantlr dksantlr / normal;
run;
/* => 평균 : 0, 분산 : 1이 아니다. (0.5) -> 표본평균의 분포는 표준정규분포보다는 작아질 것임 (시그마/루트n) */
/* n이 작을수록 분산이 커짐 (중요) */
/* n이 클수록 분산이 작아짐 */




/* n의 개수 다르게 표본 평균 구해보기 */
data tmp;
	do i=1 to 10000;
	x1 = rannor(0);
	x2 = rannor(0);
	x3 = rannor(0);
	x4 = rannor(0);
	x5 = rannor(0);
	x6 = rannor(0);
	x7 = rannor(0);
	x8 = rannor(0);
	x9 = rannor(0);
	x10 = rannor(0);
	
	
	m1 = mean(of x1-x3);
	m2 = mean(of x1-x10);
	
	output;
	end;
run;

/* 표본 평균의 히스토그램 */
proc univariate data=tmp;
	var m1 m2;
	histogram m1 m2/ normal;
run;


/* n=20 일때 표준편차 : 0.22 */
data tmp;
	do i=1 to 10000;
	x1 = rannor(0);
	x2 = rannor(0);
	x3 = rannor(0);
	x4 = rannor(0);
	x5 = rannor(0);
	x6 = rannor(0);
	x7 = rannor(0);
	x8 = rannor(0);
	x9 = rannor(0);
	x10 = rannor(0);
	x11 = rannor(0);
	x12 = rannor(0);
	x13 = rannor(0);
	x14 = rannor(0);
	x15 = rannor(0);
	x16 = rannor(0);
	x17 = rannor(0);
	x18 = rannor(0);
	x19 = rannor(0);
	x20 = rannor(0);
	
	m1 = mean(of x1-x3);
	m2 = mean(of x1-x10);
	m3 = mean(of x1-x20);
	
	output;
	end;
run;

/* 표본 평균의 히스토그램 */
proc univariate data=tmp;
	var m1 m2 m3;
	histogram m1 m2 m3/ normal;
run;


/* 추정 : 분산이 작을수록 추정량이 좋다고 할 수 있기 때문에 (n이 클수록 --) -> 통계학 관점*/
/* 정보의 관점에서는 분산이 클떄가 좋을 수 있다. */

