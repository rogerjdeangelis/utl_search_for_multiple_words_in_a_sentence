# utl_search_for_multiple_words_in_a_sentence
Find the words 'band' or 'ochestra' in the title or description of an musical event..  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.
    Find the words 'band' or 'ochestra' in the title or description of an musical event.

    github
    https://github.com/rogerjdeangelis/utl_search_for_multiple_words_in_a_sentence

    see
    https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;93483d6b.1803b

    INPUT
    =====

    data have ;
      input ID @3 title $14. @18 description $40.;
    cards4 ;
    1 editor           worked at student newspaper
    1 Orchestra        first violin
    1 Concert master   student orchestra
    2 Soccer           captain
    2 Founder          Model UN
    3 bass             jazz band
    3 Band             played bass in rock band with friends
    3 debate           participated in speech-debate events
    ;;;;
    run;quit;


    PROCESS
    =======

    data want;
      retain music 0;
      set have;
      music = prxmatch('/BAND|ORCHESTRA/',upcase(catx(' ',title,description)))>0;
    run;quit;


    OUTPUT
    ======

    WORK.WANT total obs=8

     MUSIC    ID    TITLE             DESCRIPTION

       0       1    editor            worked at student newspaper
       1       1    Orchestra         first violin
       1       1    Concert master    student orchestra
       0       2    Soccer            captain
       0       2    Founder           Model UN
       1       3    bass              jazz band
       1       3    Band              played bass in rock band with friends
       0       3    debate            participated in speech-debate events


