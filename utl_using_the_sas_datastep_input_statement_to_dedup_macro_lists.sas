Using the SAS datastep input statement to dedup macro lists

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

