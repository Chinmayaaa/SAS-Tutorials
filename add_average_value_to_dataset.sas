
******************************************************;
*Add average value to a dataset;
*Solution 1 - PROC MEANS + Data step;
******************************************************;

proc means data=sashelp.class noprint;
    output out=avg_values mean(height)=avg_height;
run;

data class_data;
    set sashelp.class;

    if _n_=1 then
        set avg_values;
run;

proc print data=class;
run;

*Solution 2 - PROC SQL - note the warning in the log;
PROC SQL;
Create table class_sql as
select *, mean(height) as avg_height
from sashelp.class;
quit;

******************************************************;
*Add average value to a dataset - with grouping variables;
*Solution 1 - PROC MEANS + Data step;
******************************************************;
proc means data=sashelp.class noprint nway;
class sex;
    output out=avg_values mean(height)=avg_height;
run;

*sort data before merge;
proc sort data=sashelp.class out=class;
by sex;
run;

data class_data;
 merge class avg_values;
 by sex;


run;

proc print data=class_data;
run;

*Solution 2 - PROC SQL - note the warning in the log;
PROC SQL;
Create table class_sql as
select *, mean(height) as avg_height
from sashelp.class
group by sex;
quit;
