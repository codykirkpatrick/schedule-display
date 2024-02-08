# schedule-display
Displays our department class schedule in easy to read tables

## Code

- QBasic version: COURSE8.BAS
  
- Perl version: [forthcoming]
  
- Perl/CGI version for websites: [forthcoming]

## Required input files

- SP24WORK.TXT: a schedule file. Name it whatever you like. (This example was my "working" file for Spring 2024 semester.) File format: comma delimited, with these six fields: CourseCode, Instructor, Days, StartTime, EndTime, Room

  ```
  EAS-E 144, KIRKPATRICK, TR, 1315, 1430, ED 1120
  EAS-A 537/437, KIRKPATRICK, MWF, 1130, 1220, GY 2033
  ```
  
- FACULTY.TXT: the list of faculty for whom individual schedules will be printed and also checked for day/time conflicts.

  ```
  SMITH
  JONES
  ```
  
- ROOMS.TXT: the list of classrooms you're most interested in. The program will print a weekly calendar for each of these rooms, and also check it for day/time conflicts in the classes you've scheduled.

  ```
  GY 2033
  GY 2036
  ```

## Example output file

See SP24WORK.OUT for the full file.  This version includes page break characters (ASCII code 12) for ready printing.

## Output details

The printed version is usually about 10 pages for us, so it's best directed to a file and not displayed on screen.  Prints these sections, in order:

- Individual faculty schedules

  ```
   - Courses for KIRKPATRICK ...
   1 - EAS-E 144      - TR    - 1315 - 1430 - ED 1120 
   2 - EAS-A 537/437  - MWF   - 1130 - 1220 - GY 2033 
   3 - EAS-E 490      - MW    - 1240 - 1330 - GY 2033 
   found 3 courses.
  ```
  
- Room usage report by day

  ```
  GY 2033
    DAY: M
    1 EAS-E 316       - RADER              - MW    -  945 - 1100 - GY 2033 
    2 EAS-A 537/437   - KIRKPATRICK        - MWF   - 1130 - 1220 - GY 2033 
    3 EAS-E 490       - KIRKPATRICK        - MW    - 1240 - 1330 - GY 2033 
  ```
  
- Room conflict check

  ```
   - Checking GY 2029 ...
   - Checking GY 2033 ...
  ```
  
- Overall daily schedule

  ```
  COURSES THAT MEET ON THURSDAY 
  1 COLL-C 105      - BRASSELL           - TR    -  910 - 1000 - CH 033  
  2 EAS-X 150       - KENDERES           - TR    -  945 - 1100 - GY 5051 
  3 EAS-A 700/347   - STATEN             - TR    -  945 - 1100 - GY 4069 
  ```
  
- Room assignments, unsorted (still not sure if this section is useful)
  
- Weekly calendar view for each room in your rooms file

  ```
                   SPR 24  - GY 2033 WEEKLY USAGE - SPR 24
     DOES NOT SHOW EXACT START/END TIMES, ONLY USAGE IN 15-MIN BLOCKS    

       |   MONDAY   |  TUESDAY   | WEDNESDAY  |  THURSDAY  |   FRIDAY
  ----- ------------ ------------ ------------ ------------ ------------ 
  1115 |            |            |            |            |            |
  1130 | 437 KIRKPA | 105 E105LA | 437 KIRKPA |            | 437 KIRKPA |
  1145 | 437 KIRKPA | 105 E105LA | 437 KIRKPA |            | 437 KIRKPA |
  ----- ------------ ------------ ------------ ------------ ------------
  1200 | 437 KIRKPA | 105 E105LA | 437 KIRKPA |            | 437 KIRKPA |
  ```


