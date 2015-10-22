# NSS-ComboTool
# Sam Scheiner 2015, EMSolutions Inc.
combo tool file script


NSS Config Editor, 7:24 AM 7/14/2015

The purpose of this tool is to manipulate command line arguments contained within configuration files for NSS simulations.In the specific instance that the script was written for, our goal is to replace the "arguments" command in .sim.sub files across multiple directories to contain what we want. The program can readily be adapted to perform multiple substitutions or deletions. 

Before editing this program, you should be familiar with perl file operations and regular expressions.

If you were only able to understand one thing about the program, it should be this line of code: 

    if (s/^arguments.*?([0-9]{1,10}).*/arguments               = "$entry"/)

This searches for a line starting with "arguments", then matches and stores a number between 1 and 10 digits long, then replaces the line with a similarly formatted line, with the users entry instead of the original commands. Then if that replacement occurs, the statement evaluates true.

The key here is the parentheses in the code: ([0-9]{1,10}). Perl uses the variables $1, $2, $3 .... $n to store the first n regex matches in an accessible variable. The parentheses allow you to match a large string, and only store a small portion of that substring. 

The rest of the code is fairly simple and self-explanatory. User input is asked for and validated, then backups are copied over and files are repeatedly opened and modified until the end of execution. The file operations are naive, so this function will only work for the highly ordered NSS file structure, or similar sequentially numbered directories. 
