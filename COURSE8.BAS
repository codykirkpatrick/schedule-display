DEFINT V
DECLARE SUB CHECKDAY (P1$, P2$, P3!)
DECLARE SUB MINS (P1!, P2!)
DECLARE SUB ISINUSE (P1!, P2!, P3!, P4!)
DECLARE SUB Comline (VNUM, A$(), VMAX)
DECLARE SUB COURSEVAL (P1$, P2!, P3!)

REM WHAT: CLASS SCHEDULE DISPLAY, STEP 8
REM WHO: CODY KIRKPATRICK
REM WHERE: IU DEPT OF EARTH & ATMOSPHERIC SCIENCES
REM WHEN: 8 FEBRUARY 2024
REM HOW: QUICKBASIC 4.5
REM WHY: WHY NOT? A SCHEDULE IS A SCHEDULE.

10 DIM CNAME$(60), INAME$(60), DAYS$(60), STIME(60), ETIME(60), CROOM$(60)
20 DIM MYCNAME$(25), MYINAME$(25), MYDAYS$(25)
21 DIM MYSTIME(25), MYETIME(25), MYCROOM$(25), MYCC(25), MYSORTTIME(25)
22 DIM MYCCVAL(25), MYID(25)
30 DIM FACNAME$(30), FDAYS(5)
35 DIM A$(1 TO 2)

CALL Comline(VNUM, A$(), 10)
CFILE$ = A$(1)
REM CFILE$ = "FA24WORK.TXT"
IF (LEN(CFILE$) < 8) THEN
  SOUND 1050, 1
  PRINT "* * * * * * * * * * *"
  PRINT "NO FILE NAME ENTERED!"
  PRINT "* * * * * * * * * * *"
  GOTO 1999
END IF
PRINSEM$ = UCASE$(LEFT$(CFILE$, 2))
IF (PRINSEM$ = "FA") THEN
  PRINSEM$ = "FALL " + MID$(CFILE$, 3, 2)
END IF
IF (PRINSEM$ = "SP") THEN
  PRINSEM$ = "SPR " + MID$(CFILE$, 3, 2)
END IF

40 DATA "M", "T", "W", "R", "F"
41 FOR I = 1 TO 5
42 READ WEEKDAY$(I)
43 NEXT I

45 DATA "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"
46 FOR I = 1 TO 5
47 READ DAYNAME$(I)
48 NEXT I

REM 40 DATA "M", "MONDAY", "T", "TUESDAY", "W", "WEDNESDAY"
REM 41 DATA "R", "THURSDAY", "F", "FRIDAY"
REM 43 FOR I = 1 TO 5
REM 45 READ WEEKDAY$(I)
REM 47 READ DAYNAME$(I)
REM 49 NEXT I


IF (LEFT$(PRINSEM$, 1) = "F") THEN
  LA$ = "          " + PRINSEM$
  LB$ = "             " + PRINSEM$
  LC$ = "                " + PRINSEM$
END IF
IF (LEFT$(PRINSEM$, 1) = "S") THEN
  LC$ = "          " + PRINSEM$
  LB$ = "             " + PRINSEM$
  LA$ = "                " + PRINSEM$
END IF


PRINT "==========================================="; LA$
PRINT "=         WELCOME TO THE SCHEDULE         ="; LB$
PRINT "==========================================="; LC$
PRINT

50 NROOMS = 0
51 OPEN "ROOMS.TXT" FOR INPUT AS #1
53 IF EOF(1) GOTO 58
54 NROOMS = NROOMS + 1
55 INPUT #1, ROOM$(NROOMS)
56 REM PRINT "READ IN", NROOMS, ROOM$(NROOMS)
57 GOTO 53
58 CLOSE #1
59 PRINT USING "READ IN ## ROOMS FROM ROOMS.TXT"; NROOMS

60 NFACULTY = 0
61 OPEN "FACULTY.TXT" FOR INPUT AS #1
62 IF EOF(1) GOTO 68
63 NFACULTY = NFACULTY + 1
64 INPUT #1, FACNAME$(NFACULTY)
65 GOTO 62
68 CLOSE #1
69 PRINT USING "READ IN ## NAMES FROM FACULTY.TXT"; NFACULTY

100 I = 0
110 REM EAS-E 144, KIRKPATRICK, MW, 1500, 1645, RB 110
120 REM OPEN "COURSES.TXT" FOR INPUT AS #1
121 OPEN CFILE$ FOR INPUT AS #1
130 IF EOF(1) GOTO 160
141 I = I + 1
142 INPUT #1, CNAME$(I), INAME$(I), DAYS$(I), STIME(I), ETIME(I), CROOM$(I)
143 IF ETIME(I) < STIME(I) THEN
144 SOUND 1050, .5
145 PRINT "START TIME IS AFTER END TIME!"
146 PRINT CNAME$(I), INAME$(I), DAYS$(I), STIME(I), ETIME(I), CROOM$(I)
147 REM STOP
148 END IF
150 GOTO 130
160 CLOSE #1
165 NCOURSES = I
170 PRINT USING "READ IN ## SECTIONS FROM \           \"; NCOURSES; CFILE$

180 PRINT USING "PRINTED ON \        \ AT \   \"; DATE$; LEFT$(TIME$, 5)
190 PRINT

REM ##################### END OPENING INFO ########################


REM ##################### BEGIN FACULTY MODULE #########################

PRINT "------------------------------"
PRINT "INDIVIDUAL FACULTY LISTINGS..."
PRINT "------------------------------"

1630 FOR FF = 1 TO NFACULTY
1635 PRINT
1640 PRINT USING " - COURSES FOR &..."; FACNAME$(FF)

REM SET UP SUBARRAYS FOR THIS FACULTY MEMBER ONLY
ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$
CC = 0

REM FIND ONLY CLASSES THAT THIS FACULTY MEMBER TEACHES

FOR I = 1 TO NCOURSES
  IF INAME$(I) = FACNAME$(FF) THEN
    CC = CC + 1
    MYCNAME$(CC) = CNAME$(I)
    MYINAME$(CC) = INAME$(I)
    MYDAYS$(CC) = DAYS$(I)
    MYSTIME(CC) = STIME(I)
    MYETIME(CC) = ETIME(I)
    MYCROOM$(CC) = CROOM$(I)
    REM PRINT
    PRINT USING "   ## - \            \ - \   \ - "; CC; CNAME$(I); DAYS$(I);
    PRINT USING "#### - #### - \         \"; STIME(I); ETIME(I); CROOM$(I)
  END IF
NEXT I

IF CC = 0 THEN
  PRINT "   DID NOT FIND ANY COURSES."
ELSEIF CC = 1 THEN
  PRINT "   FOUND 1 COURSE."
ELSEIF CC > 1 THEN
  PRINT USING "   FOUND # COURSES. "; CC
END IF

IF CC > 1 THEN

   ERASE FDAYS
   FOR I = 1 TO CC
      IF (INSTR(1, MYDAYS$(I), "M") > 0) THEN FDAYS(1) = FDAYS(1) + 1
      IF (INSTR(1, MYDAYS$(I), "T") > 0) THEN FDAYS(2) = FDAYS(2) + 1
      IF (INSTR(1, MYDAYS$(I), "W") > 0) THEN FDAYS(3) = FDAYS(3) + 1
      IF (INSTR(1, MYDAYS$(I), "R") > 0) THEN FDAYS(4) = FDAYS(4) + 1
      IF (INSTR(1, MYDAYS$(I), "F") > 0) THEN FDAYS(5) = FDAYS(5) + 1
      IF (INSTR(1, MYDAYS$(I), "D") > 0) THEN
        FOR J = 1 TO 5
          FDAYS(J) = FDAYS(J) + 1
        NEXT J
      END IF
   NEXT I
   REM PRINT USING "   M # | T # | W # | R # | F #"; FDAYS(1); FDAYS(2); FDAYS(3); FDAYS(4); FDAYS(5)

1650 FOR DD = 1 TO 5
1651 REM PRINT "   HAS THIS MANY COURSES ON THIS DAY", DD, FDAYS(DD)
1652 IF FDAYS(DD) > 1 THEN
1655 FOR TT = 800 TO 1800 STEP 5
1656 CALL MINS(MINUTES, TT)
1660 IF MINUTES > 55 THEN GOTO 1694

ISTEACHING = 0
FOR I = 1 TO CC
  CALL CHECKDAY(WEEKDAY$(DD), MYDAYS$(I), HASDAY)
  IF HASDAY = 1 THEN
    REM SUB ISINUSE (CURTIME, THESTART, THEEND, ISUSED)
    CALL ISINUSE(TT, MYSTIME(I), MYETIME(I), ISTEACHING)
    REM THISSTART = MYSTIME(I)
    REM THISEND = MYETIME(I)
    REM IF (TT >= THISSTART AND TT <= THISEND) THEN ISTEACHING = ISTEACHING + 1
  END IF
NEXT I

IF ISTEACHING > 1 THEN
  SOUND 1050, .1
  PRINT USING "   _*_*_* & HAS A CONFLICT ON & AT #### : # COURSES"; FACNAME$(FF); WEEKDAY$(DD); TT; ISTEACHING
END IF

REM PRINT FACNAME$(FF), WEEKDAY$(DD), TT, ISTEACHING
REM WAIT &H3DA, 8

1694 NEXT TT
END IF

1696 NEXT DD

REM ELSE
REM   PRINT "ONLY HAS ", CC, " COURSES SO DON'T NEED TO CHECK."
END IF

1697 NEXT FF

1698 PRINT
1699 PRINT "FACULTY LISTING DONE."

REM ##################### END OF FACULTY MODULE #########################


REM ##################### BEGIN DAILY MODULE ########################

PRINT CHR$(12)
PRINT "----------------------"
PRINT "OVERALL DAILY SCHEDULE"
PRINT "----------------------"
PRINT

700 FOR J = 1 TO 5
705 PRINT USING "COURSES THAT MEET ON &"; DAYNAME$(J)

706 CC = 0
707 ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$

710 FOR I = 1 TO NCOURSES
        CALL CHECKDAY(WEEKDAY$(J), DAYS$(I), HASDAY)
        IF (HASDAY > 0) THEN
          CC = CC + 1
          MYCNAME$(CC) = CNAME$(I)
          MYINAME$(CC) = INAME$(I)
          MYDAYS$(CC) = DAYS$(I)
          MYSTIME(CC) = STIME(I)
          MYETIME(CC) = ETIME(I)
          MYCROOM$(CC) = CROOM$(I)
          MYCC(CC) = CC
          MYSORTTIME(CC) = STIME(I) + .001 * ETIME(I)
          REM MYSORTTIME(CC) = STIME(I) + .5 * LEN(CNAME$(I)) + .001 * ETIME(I)
          REM PRINT CC, MYCC(CC), MYSORTTIME(CC)
        END IF
NEXT I

IF CC > 1 THEN

  II = 1
  JJ = II + 1

  WHILE II <= CC
  WHILE JJ <= CC
    IF MYSORTTIME(II) > MYSORTTIME(JJ) THEN
      REM TEMP = MYSORTTIME(II)
      REM TMCC = MYCC(II)
      REM MYSORTTIME(II) = MYSORTTIME(JJ)
      REM MYCC(II) = MYCC(JJ)
      REM MYSORTTIME(JJ) = TEMP
      REM MYCC(JJ) = TMCC
      SWAP MYSORTTIME(II), MYSORTTIME(JJ)
      SWAP MYCC(II), MYCC(JJ)
    END IF
    JJ = JJ + 1
  WEND
  II = II + 1
  JJ = II + 1
  WEND

END IF

FOR I = 1 TO CC
        II = MYCC(I)
        PRINT USING "### \            \ - \              \ - \   \ - #### - #### - &"; I; MYCNAME$(II); MYINAME$(II); MYDAYS$(II); MYSTIME(II); MYETIME(II); MYCROOM$(II)
NEXT I

PRINT
799 NEXT J

REM ##################### END DAILY MODULE ########################



REM ################## ROOM USAGE BY DAY MODULE #####################

PRINT
PRINT "-----------------"
PRINT "ROOM USAGE BY DAY"
PRINT "-----------------"
PRINT

1000 FOR J = 1 TO NROOMS

REM SET UP SUBARRAYS FOR THIS ROOM ONLY

ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$
REM PRINT "ROOM:", ROOM$(J)
PRINT ROOM$(J)
CC = 0

REM FIND ONLY CLASSES THAT MEET IN THIS ROOM

FOR I = 1 TO NCOURSES
  IF CROOM$(I) = ROOM$(J) THEN
    REM PRINT "COURSE ", CNAME$(I), "MEETS IN ", ROOM$(J)
    CC = CC + 1
    MYCNAME$(CC) = CNAME$(I)
    MYINAME$(CC) = INAME$(I)
    MYDAYS$(CC) = DAYS$(I)
    MYSTIME(CC) = STIME(I)
    MYETIME(CC) = ETIME(I)
    MYCROOM$(CC) = CROOM$(I)
  END IF
NEXT I
REM PRINT "FOUND ", CC, " COURSES THAT MEET IN ", ROOM$(J)

REM NOW PRINT THE COURSES FROM EACH DAY ONLY

FOR DD = 1 TO 5
EE = 0
FOR I = 1 TO CC
    CALL CHECKDAY(WEEKDAY$(DD), MYDAYS$(I), HASDAY)
    IF HASDAY > 0 THEN
      REM PRINT USING " & - #### - #### - &"; MYCNAME$(I); MYSTIME(I); MYETIME(I); MYINAME$(I)
      EE = EE + 1
      EN$(EE) = MYCNAME$(I)
      EST(EE) = MYSTIME(I)
      EET(EE) = MYETIME(I)
      EI$(EE) = MYINAME$(I)
      ED$(EE) = MYDAYS$(I)
    END IF
NEXT I
REM PRINT "FOUND ", EE, "COURSES."

IF EE > 1 THEN
  II = 1
  JJ = II + 1
  WHILE II <= EE
  WHILE JJ <= EE
    IF EST(II) > EST(JJ) THEN
      REM TEMP = EST(II)
      REM ETMP = EET(II)
      REM TN$ = EN$(II)
      REM TI$ = EI$(II)
      REM EST(II) = EST(JJ)
      REM EET(II) = EET(JJ)
      REM EN$(II) = EN$(JJ)
      REM EI$(II) = EI$(JJ)
      REM EST(JJ) = TEMP
      REM EET(JJ) = ETMP
      REM EN$(JJ) = TN$
      REM EI$(JJ) = TI$
      SWAP EST(II), EST(JJ)
      SWAP EET(II), EET(JJ)
      SWAP EN$(II), EN$(JJ)
      SWAP EI$(II), EI$(JJ)
      SWAP ED$(II), ED$(JJ)
    END IF
  JJ = JJ + 1
  WEND
  II = II + 1
  JJ = II + 1
  WEND

REM ELSE
REM   PRINT "EE IS ONLY ", EE, " SO WE SKIP SORTING HERE."
END IF

IF EE > 0 THEN
  PRINT USING "  DAY: &"; WEEKDAY$(DD)
  FOR I = 1 TO EE
    PRINT USING "  # \             \ - \              \ - \   \ - #### - ####"; I; EN$(I); EI$(I); ED$(I); EST(I); EET(I)
  NEXT I
END IF

NEXT DD
PRINT
NEXT J

PRINT
PRINT "------------------------------"
PRINT "CHECKING FOR ROOM CONFLICTS..."
PRINT "------------------------------"

1530 FOR RR = 1 TO NROOMS
PRINT USING " - CHECKING & ..."; ROOM$(RR)

1532 FOR DD = 1 TO 5
REM PRINT USING "     &..."; WEEKDAY$(DD)

REM SET UP SUBARRAYS FOR THIS ROOM ON THIS DAY ONLY
ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$

CC = 0
REM FIND ONLY CLASSES THAT MEET IN THIS ROOM ON THIS DAY

FOR I = 1 TO NCOURSES
  IF CROOM$(I) = ROOM$(RR) THEN
   CALL CHECKDAY(WEEKDAY$(DD), DAYS$(I), HASDAY)
   IF (HASDAY > 0) THEN
    REM PRINT "COURSE ", CNAME$(I), "MEETS IN ", ROOM$(RR)
    CC = CC + 1
    MYCNAME$(CC) = CNAME$(I)
    MYINAME$(CC) = INAME$(I)
    MYDAYS$(CC) = DAYS$(I)
    MYSTIME(CC) = STIME(I)
    MYETIME(CC) = ETIME(I)
    MYCROOM$(CC) = CROOM$(I)
   END IF
  END IF
NEXT I
REM PRINT USING "  FOUND ## COURSES."; CC

IF CC > 1 THEN
    FOR TT = 800 TO 1800 STEP 5

        CALL MINS(MINUTES, TT)
        IF MINUTES > 55 THEN GOTO 1570

        UTILIZED = 0

        FOR I = 1 TO CC
          REM SUB ISINUSE (CURTIME, THESTART, THEEND, ISUSED)
          CALL ISINUSE(TT, MYSTIME(I), MYETIME(I), UTILIZED)
          REM THISSTART = MYSTIME(I)
          REM THISEND = MYETIME(I)
          REM IF (TT >= THISSTART AND TT <= THISEND) THEN UTILIZED = UTILIZED + 1
        NEXT I

        IF UTILIZED > 1 THEN
          SOUND 1050, .1
          PRINT USING "   _*_*_* CONFLICT IN ROOM & - "; ROOM$(RR);
          PRINT USING "& #### - USED # TIMES"; WEEKDAY$(DD); TT; UTILIZED
        END IF
1570 NEXT TT
END IF

1596 NEXT DD
1598 NEXT RR
1599 PRINT "CONFLICT CHECK DONE."

PRINT

REM ################## END ROOM USAGE BY DAY MODULE #####################



REM #################### COURSES PER ROOM MODULE #######################

PRINT
PRINT "-----------------------"
PRINT "COURSE ROOM ASSIGNMENTS"
PRINT "-----------------------"
PRINT

REM HOW SHOULD THIS BE SORTED? IF AT ALL??

900 FOR J = 1 TO NROOMS
905 PRINT "ROOM: "; ROOM$(J)

906 REM SET UP SUBARRAYS FOR THIS ROOM ONLY
907 ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$, MYCCVAL, MYID
908 CC = 0

910 FOR I = 1 TO NCOURSES
920   IF ROOM$(J) = CROOM$(I) THEN
925     CC = CC + 1
926     MYCNAME$(CC) = CNAME$(I)
927     MYINAME$(CC) = INAME$(I)
928     MYDAYS$(CC) = DAYS$(I)
929     MYSTIME(CC) = STIME(I)
930     MYETIME(CC) = ETIME(I)
931     MYCROOM$(CC) = CROOM$(I)
932     CALL COURSEVAL(DAYS$(I), STIME(I), MYCCVAL(CC))
933     MYID(CC) = CC
938   END IF
940 NEXT I

REM PRINT "FOUND ", CC, " COURSES THAT MEET IN ", ROOM$(J)

IF (CC > 1) THEN
  II = 1
  JJ = II + 1
  WHILE II <= CC
  WHILE JJ <= CC
    IF (MYCCVAL(II) < MYCCVAL(JJ)) THEN
      SWAP MYCCVAL(II), MYCCVAL(JJ)
      SWAP MYID(II), MYID(JJ)
    END IF
    JJ = JJ + 1
  WEND
  II = II + 1
  JJ = II + 1
  WEND
END IF

IF (CC > 0) THEN
  FOR I = 1 TO CC
      TT = MYID(I)
      PRINT USING " \            \ - "; MYCNAME$(TT);
      PRINT USING "\            \"; MYINAME$(TT);
      PRINT USING " - \    \- #### - ####"; MYDAYS$(TT); MYSTIME(TT); MYETIME(TT)
  NEXT I
END IF
PRINT

NEXT J

REM ################## END COURSES PER ROOM MODULE #####################


REM ################## BEGIN INDIVIDUAL ROOMS MODULE #####################

FOR RR = 1 TO NROOMS

PRINT CHR$(12)
REM PRINT "-----------------------------------------------------------------"
PRINT USING "               \     \ - \     \ WEEKLY USAGE - \     \"; PRINSEM$; ROOM$(RR); PRINSEM$
PRINT "   DOES NOT SHOW EXACT START/END TIMES, ONLY USAGE IN 15-MIN BLOCKS"
REM PRINT "-----------------------------------------------------------------"

REM SET UP SUBARRAYS FOR THIS ROOM'S USAGE ONLY
ERASE MYCNAME$, MYINAME$, MYDAYS$, MYSTIME, MYETIME, MYCROOM$
CC = 0

REM FIND ONLY CLASSES THAT THIS FACULTY MEMBER TEACHES

FOR I = 1 TO NCOURSES
  IF CROOM$(I) = ROOM$(RR) THEN
    CC = CC + 1
    MYCNAME$(CC) = CNAME$(I)
    MYINAME$(CC) = INAME$(I)
    MYDAYS$(CC) = DAYS$(I)
    MYSTIME(CC) = STIME(I)
    MYETIME(CC) = ETIME(I)
    MYCROOM$(CC) = CROOM$(I)
    REM PRINT
    REM PRINT USING "   ## - \            \ - \           \"; CC; CNAME$(I); INAME$(I);
    REM PRINT USING " - \     \ ####  ####"; DAYS$(I); STIME(I); ETIME(I)
  END IF
NEXT I

PRINT
PRINT "     |   MONDAY   |  TUESDAY   | WEDNESDAY  |  THURSDAY  |   FRIDAY"
PRINT "----- ------------ ------------ ------------ ------------ ------------"

IF CC > 1 THEN
STEPSIZE = 15
FOR TT = 830 TO 1815 STEP STEPSIZE
  CALL MINS(MINUTES, TT)
  IF (MINUTES < 60) THEN
    PRINT USING "#### |"; TT;
    FOR DD = 1 TO 5
      THISWD$ = WEEKDAY$(DD)
      THISBOX$ = ""
      UTILIZED = 0
      FOR I = 1 TO CC
        CALL CHECKDAY(THISWD$, MYDAYS$(I), HASDAY)
        IF (HASDAY > 0) THEN
          THISSTART = MYSTIME(I)
          THISEND = MYETIME(I)
          IF (TT >= THISSTART AND TT <= THISEND) THEN
            THISNUM$ = RIGHT$(MYCNAME$(I), 3)
            THISPROF$ = LEFT$(MYINAME$(I), 6)
            THISBOX$ = THISNUM$ + " " + THISPROF$
            UTILIZED = UTILIZED + 1
          END IF
        END IF
      NEXT I
      IF (UTILIZED > 1) THEN
        PRINT " *CONFLICT* |";
      ELSE
        PRINT USING " \         \|"; THISBOX$;
      END IF
    NEXT DD
    PRINT
  END IF
  IF (MINUTES = 60) THEN
    TT = TT + STEPSIZE + 10
    REM SHOULD BE 10 MORE THAN THE STEP ABOVE
    PRINT "----- ------------ ------------ ------------ ------------ ------------"
  END IF

NEXT TT
END IF

PRINT
PRINT
NEXT RR

REM ################## END INDIVIDUAL ROOMS MODULE #####################


PRINT "ALL DONE."

1999 END

DEFSNG V
2000 SUB CHECKDAY (P1$, P2$, P3)
2005 REM PRINT "YOU ARE IN THE SUB."
2006 REM PRINT P1$
2007 REM PRINT P2$
2010 THELENGTH = LEN(P2$)
2011 REM PRINT THELENGTH
2015 P3 = 0
2016 IF P2$ = "D" THEN P3 = 1
2020 FOR I = 1 TO THELENGTH
2030 IF MID$(P2$, I, 1) = P1$ THEN
2040   P3 = 1
2050 END IF
2060 NEXT I
2070 END SUB

DEFINT A-Z
SUB Comline (NumArgs, Args$(), MaxArgs) STATIC
CONST TRUE = -1, FALSE = 0

   NumArgs = 0: In = FALSE
' Get the command line using the COMMAND$ function.
   Cl$ = COMMAND$
   L = LEN(Cl$)
' Go through the command line a character at a time.
   FOR I = 1 TO L
      C$ = MID$(Cl$, I, 1)
    'Test for character being a blank or a tab.
      IF (C$ <> " " AND C$ <> CHR$(9)) THEN
    ' Neither blank nor tab.
    ' Test to see if you're already
    ' inside an argument.
         IF NOT In THEN
      ' You've found the start of a new argument.
      ' Test for too many arguments.
            IF NumArgs = MaxArgs THEN EXIT FOR
            NumArgs = NumArgs + 1
            In = TRUE
         END IF
     ' Add the character to the current argument.
         Args$(NumArgs) = Args$(NumArgs) + C$
      ELSE
   ' Found a blank or a tab.
   ' Set "Not in an argument" flag to FALSE.
         In = FALSE
      END IF
   NEXT I

END SUB

DEFSNG A-U, W-Z
SUB COURSEVAL (P1$, P2!, P3!)
REM P1$ --> DAYS THE COURSE IS TAUGHT
REM P2! --> START TIME
REM P3! --> VALUE

P3! = 0

REM FIND NUMBER OF DAYS THE COURSE IS TAUGHT
REM ..THIS GOES IN THE TENS COLUMN

IF (P1$ = "D") THEN
        P3 = 40
ELSE
        P3 = 10 * (LEN(P1$) - 1)
END IF

REM FIND FIRST DAY OF THE WEEK THE COURSE IS TAUGHT
REM ..THIS GOES IN THE ONES COLUMN

IF (INSTR(P1$, "M") > 0) THEN
        P3 = P3 + 4
ELSEIF (INSTR(P1$, "T") > 0) THEN
        P3 = P3 + 3
ELSEIF (INSTR(P1$, "W") > 0) THEN
        P3 = P3 + 2
ELSEIF (INSTR(P1$, "R") > 0) THEN
        P3 = P3 + 1
END IF

REM FIND A VALUE FOR THE START TIME OF THE COURSE
REM ..EARLIER EQUALS HIGHER.. DECIMAL PART

P3 = P3 + (2400! - P2!) / 10000!

END SUB

DEFSNG V
SUB ISINUSE (CURTIME, THESTART, THEEND, ISUSED)
  IF (CURTIME >= THESTART AND CURTIME <= THEEND) THEN ISUSED = ISUSED + 1

REM    THISSTART = MYSTIME(I)
REM    THISEND = MYETIME(I)
REM    IF (TT >= THISSTART AND TT <= THISEND) THEN ISTEACHING = ISTEACHING + 1

END SUB

SUB MINS (P4!, P5!)

TTS$ = STR$(P5)
TTR$ = RIGHT$(TTS$, 2)
P4 = VAL(TTR$)

END SUB

