# schedule-display
Displays our department class schedule in easy to read tables

## Code

- QBasic version: COURSE8.BAS
  
- Perl version: [forthcoming]
  
- Perl/CGI version for websites: [forthcoming]

## Required input files

- SP24WORK.TXT: a schedule file. Name it whatever you like. (This example was my "working" file for Spring 2024 semester.) File format: comma delimited, with these six fields: CourseCode, Instructor, Days, StartTime, EndTime, Room
  
- FACULTY.TXT: the list of faculty for whom individual schedules will be printed and also checked for day/time conflicts.
  
- ROOMS.TXT: the list of classrooms you're most interested in. The program will print a weekly calendar for each of these rooms, and also check it for day/time conflicts in the classes you've scheduled.

## Output

Usually to the screen, but can of course be directed to a file.  Prints these sections, in order:

- Individual faculty schedules
  
- Room usage report by day
  
- Room conflict check
  
- Overall daily schedule
  
- Room assignments, unsorted (still not sure if this section is useful)
  
- Weekly calendar view for each room in your rooms file

