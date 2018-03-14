Find the words 'band' or 'ochestra' in the title or description of an musical event.

github
https://github.com/rogerjdeangelis/utl_search_for_multiple_words_in_a_sentence

Added a elightening response from Vincent Martin on the end

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

* for a word search
    music = prxmatch('/\bBAND\b|\bORCHESTRA\b/',upcase(catx(' ',title,description)))>0;
    Also you can compile the pattern for faster searches


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


Martin, Vincent (STATCAN)
12:54 PM (5 hours ago)

to me, SAS-L
Not to get too picky, I just remember reading a wonderful PRX book when I wanted
to learn the text language emphasizing the importance of carefully designing the
expression to avoid significant increases the execution time. Hopefully, this
will be useful to some people because the performance glut is irrelevant to the
specific example at stakes but can easily go out of hand with co
mplex PRX.

Anyway, one basic principle with PRX is that the alternation construct |, at
least when used for a long list of alternates, is extremely inefficient when
multiple alternates share common roots because anytime the root is matched,
the pointer will move all matched characters up the string for each
alternation construct that contains it before reaching failing point to skip to the ne
xt alternate and/or string character if all alternates were checked.
Thus for performance, joining common roots of alternates outside the
alternation construct cuts the number of operations
required to dismiss alternates of the same root.

i.e.

'/\b(BAND|ORCHESTRA)\b/'

Will outperform checking the boundary for each construct that
is in your solution. The more detailed explanation for what I
remember of it is below.

In your PRX example, say the string to try to match is “SOMETHING”,
the pointer will check and match boundary to the left of S and of B
then that the S does not match B and backtrack, then checks the match
of the boundary to the left of S and of O and that S does not match O
and move the pointer up one character in the string. However, when the
string pointer is at, say the O “SOME
THING” to try to find a new match, it will check that it does not match
the boundary to the left of each alternate (i.e. twice) before
backtracking in the regex and forwarding the pointer in the string to
the M, and again twice for every position that does not match the boundary.



The slight change above would cause the boundary to only be checked
once against each character in the string. So if you use the alternation
construct as a mini dictionary with a lot of words, isolating common
roots to generate an admittedly more convoluted regex will substantially
improve performance, especially if used against long strings.



To go back to the example of matching “SOMETHING”, Roger’s solution
would perform 26 characterwise equality checks whereas the ridiculously
small change that I did would take that down to 15 if I remember
the internal mechanics correctly. I can break down the details of
how the pointer would move from my best understanding of reading that book if it’s of interest.

Apologies for sidetracking the thread.

Vincent Martin

Methodologist – Social Survey Methods Division
Statistics Canada / Government of Canada
vincent.martin@canada.ca / Tel: 613-853-7135



