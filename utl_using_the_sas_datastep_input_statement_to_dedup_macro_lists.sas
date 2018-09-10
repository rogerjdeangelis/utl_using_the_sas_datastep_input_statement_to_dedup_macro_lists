Using the SAS datastep input statement to dedup macro lists

see additonal responses and a
nice pure macro solution by data_null_ on end

It seems to me that the datastep input is a very powerfull text parser.
I think this has many applications;
The macro %input is very limited?


INPUT (macro list to dedup)
---------------------------

  %let macList=A ROGER MARY A SAM MARY A;

WANT (debuped)
--------------

  %let macList=A MARY ROGER SAM;

PROCESS
=======

  proc sql;
    select
         distinct *
    into :
         macList separated by " "
    from
        %mac2table(&macList)
  ;quit;

  %put &=macList;

  MACLIST=A MARY ROGER SAM

MACRO
=====

%macro mac2table(vars);
  %let rc=%sysfunc(dosubl('
      filename _temp_ clipbrd;
      data _null_;
         file _temp_;
         put "&vars";
      run;quit;
      data dsn;
        infile _temp_;
        input vs$ @@;
      run;quit;
  '));
   dsn
%mend mac2table;

*
 _ __ ___  ___ _ __   ___  _ __  ___  ___  ___
| '__/ _ \/ __| '_ \ / _ \| '_ \/ __|/ _ \/ __|
| | |  __/\__ \ |_) | (_) | | | \__ \  __/\__ \
|_|  \___||___/ .__/ \___/|_| |_|___/\___||___/
              |_|
;

see additonal responses and a

nice pure solution by data_null_.
Thanks, data_null_, for providing a pure macro code solution.

I expect this is the SAS Forum preferred solution and
given the state of DOSUBL is important.


The older I get the harder it is for me to use macro quoting functions.

Here are three other examples

   1. Datastep execution time
   2. DOSUBL Macro execution time
   3. More interesting input parser
   4. Pure macro solution by data_null_  datanull@gmail.com


1. Datastep execution time
--------------------------

%let macList=A ROGER MARY A SAM MARY A;
%let cnt=%sysfunc(countw(&macList));

data _null_;

 array wrds[&cnt] $ a1-a&cnt  ("%sysfunc(tranwrd(&macList,%str( ),%str(",")))");

 call sortc(of wrds[*]);
 do i=2 to &cnt;
    if wrds[i-1]=wrds[i] then wrds[i-1]="";
 end;
 res=catx(' ',of wrds[*]);
 call symputx('wrds',res);

run;quit;

%put res=;


2. DOSUBL Macro execution time
------------------------------

%let macList=A ROGER MARY A SAM MARY A;

%symdel wrds / nowarn;

%macro macUnq(macList);

  %let cnt=%sysfunc(countw(&macList));

  %let rc=%sysfunc(dosubl('
     data _null_;

      array wrds[&cnt] $ a1-a&cnt  ("%sysfunc(tranwrd(&macList,%str( ),%str(",")))");

      call sortc(of wrds[*]);
      do i=2 to &cnt;
         if wrds[i-1]=wrds[i] then wrds[i-1]="";
      end;
      res=catx(" ",of wrds[*]);
      call symputx("wrds",res);

     run;quit;
  '));
   &wrds
%mend macUnq;

%let maclist=%macUnq(&macList);

%put &=wrds;


3. More interesting input parser
---------------------------------

* The method becomes a little more interestng with this example.
* The method normalizes macro strings

%let macList=33 18675 44 17786 55 18455 66 19010;

%macro mac2table(vars);
  %let rc=%sysfunc(dosubl('
      filename _temp_ clipbrd;
      data _null_;
         file _temp_;
         put "&vars";
      run;quit;
      data dsn;
        infile _temp_;
        input age date @@;
      run;quit;
  '));
   dsn
%mend mac2table;

proc print data=%mac2table(&macList);
format date date9.;
run;quit;

Obs    AGE         DATE

 1      33    17FEB2011
 2      44    11SEP2008
 3      55    12JUL2010
 4      66    18JAN2012


4. Pure macro solution by data_null_  datanull@gmail.com
----------------------------------------------------------

I don't see where the INPUT statement is doing any significant
work with regards to this problem.  Wouldn't something like this be good enough.
I used the I ignore case parameter but you could adjust that as needed.

%macro dedup(arg);
   %local ret;
   %local i w;
   %let i = %eval(&i+1);
   %let w = %scan(%superq(arg),&i);
   %do %while(%superq(w) ne);
      %if %sysfunc(findw(%superq(ret),%superq(w),,si,1)) eq 0 %then %let ret=&ret &w;
      %let i = %eval(&i+1);
      %let w = %scan(%superq(arg),&i);
      %end;
%superq(ret)
   %mend dedup;

%let macList=A ROGER MARY a SAM MARY A;
227  %put NOTE: %dedup(&maclist);
NOTE: A ROGER MARY SAM




