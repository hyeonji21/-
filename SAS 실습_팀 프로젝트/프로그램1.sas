proc print data=data.df;
run;

data data.dff; set data.df;
time = _n_;
run;

data dfff;
set data.dff;
if _n_= 25 then delete;
run;

proc autoreg data=dfff; 
 model mobile_sales=time month_coronic app_user box_sales;  
run;



/* 변수 : mobile_sales, month_coronic, app_user, box_sales */

/* 데이터 탐색 */
/* 추세 확인 */
proc gplot data=data.df;
	plot mobile_sales * time;  /* 세로 * 가로 */
run; quit;

proc gplot data=data.df;
	plot month_coronic * time; 
run; quit;

proc gplot data=data.df;
	plot app_user * time; 
run; quit;

proc gplot data=data.df;
	plot box_sales * time; 
run; quit;


/* 변동성 확인 및 결측치, 이상치 확인 */
data data.df_new;
 DIF_month_coronic = DIF(month_coronic);
 DIF_app_user = DIF(app_user);
 DIF_mobile_sales = DIF(mobile_sales);
 DIF_box_sales = DIF(box_sales);
 set data.df;
run;

proc gplot data=data.df_new;
	plot DIF_month_coronic * time; 
run; quit;

proc gplot data=data.df_new;
	plot DIF_app_user * time; 
run; quit;


proc gplot data=data.df_new;
	plot DIF_mobile_sales * time; 
run; quit;

proc gplot data=data.df_new;
	plot DIF_box_sales * time;  
run; quit;


/* CHOW TEST */
proc autoreg data=df;
   model  app_user = time/Chow=(14 15 16 17 18 19 20 21); /*21년 3월 부터 21년 10월*/
run;


/* 양분점(t=18) 원인 검정 */
data df_7; set data.df;
	if time < 2021.4999994 then D=0; else D=1;
	Dtime = D*time; Dapp_user = D*app_user; 
run;
proc autoreg data=df_7;
 model mobile_sales = D time Dtime app_user Dapp_user;
run;

proc reg data=data.df; 
 model mobile_sales=time month_coronic app_user box_sales / vif;  
run;

/* OLS 확인 */
proc autoreg data=data.df; 
 model mobile_sales=time month_coronic app_user box_sales;  
run;


data data.df; set data.df;
time = _n_;
run;
proc print data=data.df;
run;



/* 그룹별 회귀분석 */
DATA DF_TIME_DIVIDE; SET DATA.DF;
 IF  TIME < 18  		  THEN T=0;
 ELSE                          T=1;
RUN;

PROC AUTOREG DATA=DF_TIME_DIVIDE; 
 MODEL MOBILE_SALES = MONTH_CORONIC APP_USER BOX_SALES;  
 BY T;
RUN;



/* 두 시차 간 차이 검정 */
data df_1; set data.df;
 if time < 18  then T=0;
 else 						   T=1;
 Ttime = T*time;
run;
proc autoreg data=df_1;
 model mobile_sales=T time Ttime;
 TEST time-Ttime=0;
run;


/* 가변수 - 계절성 확인 */

DATA DF_DUMMY; SET DATA.DF;
	IF 	 TIME < 18 THEN   D=0; 
	ELSE 			  	  D=1;
	DTIME = D*TIME; DAPP_USER = D*APP_USER;
RUN;

PROC AUTOREG DATA=DF_DUMMY;
 MODEL MOBILE_SALES = D TIME DTIME APP_USER DAPP_USER;
RUN;	


proc reg data=df; 
 model mobile_sales=time month_coronic app_user box_sales;  
run;

proc print data=data.df;
run;

proc print data=data;
run;

DATA DF_TIME_DIVIDE; SET DFFF;
 IF  TIME < 18  		  THEN T=0;
 ELSE                          T=1;
RUN;


PROC AUTOREG DATA=DF_TIME_DIVIDE; 
 MODEL MOBILE_SALES = MONTH_CORONIC APP_USER BOX_SALES;  
 BY T;
RUN;


proc gplot data=dfff;
	plot month_coronic * time;  /* 세로 * 가로 */
run; quit;


/* 추가 */
/* 상관계수 확인 */

PROC CORR DATA=DATA.DF;
	VAR TIME APP_USER BOX_SALES MONTH_CORONIC;
RUN;

proc print data=dfff;
run;


data df_outlier_no_log;
set data.data_log;
if _n_= 25 then delete;
run;

proc autoreg data=df_outlier_no_log;
   model mobile_sales = time box_sales month_coronic_log;
run;


/*perform Shapiro-Wilk test*/
proc univariate data=asd normal; 
run;


DATA DF_NO_OUTLIER;
SET DATA.DF;
IF _N_= 25 THEN DELETE;
RUN;

PROC REG DATA=DATA.DF;
   MODEL MOBILE_SALES = MONTH_CORONIC;
RUN;


