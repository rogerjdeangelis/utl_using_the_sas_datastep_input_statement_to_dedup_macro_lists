# utl_using_the_sas_datastep_input_statement_to_dedup_macro_lists
Using the SAS datastep input statement to dedup macro lists.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.

    Using the SAS datastep input statement to dedup macro lists

    github
    https://tinyurl.com/yd2qzahl
    https://github.com/rogerjdeangelis/utl_using_the_sas_datastep_input_statement_to_dedup_macro_lists

    It seems to me that the datastep input is a very powerfull text parser.
    I think this has many applications;
    The macro %input is very limited?
    
    see additonal responses on end
    Nice pure solution by data_null_.
    Thanks, data_null_, for providing a pure macro code solution.


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

    LOG


    1126      proc sql;
    1127          select
    1128               distinct *
    1129          into :
    1130               macList separated by " "
    1131          from
    1132              %mac2table(&macList)
    MLOGIC(MAC2TABLE):  Beginning execution.
    SYMBOLGEN:  Macro variable MACLIST resolves to A MARY ROGER SAM
    SYMBOLGEN:  Macro variable VARS resolves to A MARY ROGER SAM
    NOTE: The file _TEMP_ is:
          (no system-specific pathname available),
          (no system-specific file attributes available)

    NOTE: 1 record was written to the file _TEMP_.
          The minimum record length was 16.
          The maximum record length was 16.
    NOTE: DATA statement used (Total process time):
          real time           0.00 seconds


    NOTE: The infile _TEMP_ is:
          (no system-specific pathname available),
          (no system-specific file attributes available)

    NOTE: 1 record was read from the infile _TEMP_.
          The minimum record length was 16.
          The maximum record length was 16.
    NOTE: SAS went to a new line when INPUT statement reached past the end of a line.
    NOTE: The data set WORK.DSN has 4 observations and 1 variables.
    NOTE: DATA statement used (Total process time):
          real time           0.01 seconds


    MLOGIC(MAC2TABLE):  Parameter VARS has value A MARY ROGER SAM
    MLOGIC(MAC2TABLE):  %LET (variable name is RC)
    MPRINT(MAC2TABLE):   dsn
    MLOGIC(MAC2TABLE):  Ending execution.
    1133        ;
    1133!        quit;
    NOTE: PROCEDURE SQL used (Total process time):
          real time           0.42 seconds


    SYMBOLGEN:  Macro variable MACLIST resolves to A MARY ROGER SAM
    1134        %put &=macList;
    MACLIST=A MARY ROGER SAM
    
    
    
        *
     _ __ ___  ___ _ __   ___  _ __  ___  ___  ___
    | '__/ _ \/ __| '_ \ / _ \| '_ \/ __|/ _ \/ __|
    | | |  __/\__ \ |_) | (_) | | | \__ \  __/\__ \
    |_|  \___||___/ .__/ \___/|_| |_|___/\___||___/
                  |_|
    ;

    see additonal responses anon end
    Nice pure solution by data_null_.
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

    
    


