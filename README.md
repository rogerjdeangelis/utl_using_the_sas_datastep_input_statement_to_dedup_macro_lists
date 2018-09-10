# utl_using_the_sas_datastep_input_statement_to_dedup_macro_lists
Using the SAS datastep input statement to dedup macro lists.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.

    Using the SAS datastep input statement to dedup macro lists

    github
    https://tinyurl.com/yd2qzahl
    https://github.com/rogerjdeangelis/utl_using_the_sas_datastep_input_statement_to_dedup_macro_lists

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


