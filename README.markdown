progress.sh
===========

Dependencies
------------
bash, bc

Installation
------------
Make it executable, put it somewhere :)

Summary
-------
progress.sh is a very simple script that was born from my need to count the number of times an entry occurs in a logfile and estimate how much longer a long-running process is going to take.  Example:

    $ ./progress.sh "grep -c 'this is a record' ./log.log" 241831
    Current=21.10/sec	TotalAvg=21.14/sec	Total=182424/241831 75.00%	46.83 mins left

Usage
-----
progress.sh takes two arguments, only the first is required.

The first is the command that progress.sh will run once every 30 seconds.  What this command actually is, is completely up to you.  The only requirement is that it returns an integer.

The second argument is optional, and it's an integer representing what the maximum count returned by the command is.  Without the second argument, the script cannot estimage time remaining.

Output
------
Given:
    $ ./progress.sh "grep -c 'this is a record' ./log.log" 241831
    Current=21.10/sec	TotalAvg=21.14/sec	Total=182424/241831 75.00%	46.83 mins left

21.10 is the average of how many units per second were processed in the most recent interval.
21.14 is the average of how many units per second have been processed since the script started.
182424 is the total number of units processed.
241831 is the total number of units to process (the second argument to the script)

