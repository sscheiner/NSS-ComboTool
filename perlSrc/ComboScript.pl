#Source code by Samuel Scheiner, 2015. Version RC2.2 6-10-2015.
#2.2: Creates backup folder in script directory and leaves NSS directory untouched besides in-file text edits
use 5.14.2;
use strict;
use warnings;
use File::Copy;
########### input
######## vars 
my $dirname = " ";
my $maxfolder = 0;
my $foldercount = 0;
my $entry = " ";
my $select = ' ';
my $execute = 0;
my $backup = 0; 
(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isDST) = localtime();
my $time = "$mon$mday$year$hour$min$sec";
while($execute == 0)
{
	print "\nInput File Path to Parent Folder:\n";
	$dirname = <stdin>;			#read in filename entry
	chomp $dirname;	
	my $x = 0;
	while($x == 0) #this loop validates correct input for number of folders
	{
		print "Enter number of folders in this directory to run through:\n";
		$maxfolder = <stdin>;
		chomp $maxfolder;
		if($maxfolder =~ /[a-zA-Z]+/) #if input has letters in it, deny input
		{
			print "Invalid entry, you must enter a valid number.\n";
		}
		else
		{
			$x = 1;
		}
	}
	print "Type what you would like the arguments line to contain, without\n quotations, use \$seed as a placeholder for the seed:\n"; 	#entering replacement line
	$entry = <stdin>;
	chomp $entry;
	print "You are editing $maxfolder folder(s) in $dirname. The predefined line will be replaced with $entry.\nDo you wish to proceed <Y/N>? or Q to quit\n";
	$select = <stdin>;
	chomp $select;
	if($select eq 'Q' || $select eq 'q')
		{
		exit 0; 
		}
	elsif($select eq 'Y' || $select eq 'y') #if yes, break the loop and proceed
		{
		$execute = 1;
		}
	elsif($select eq 'N' || $select eq 'n') #do nothing if user enters no
		{}
	else{
	print "Invalid entry\n";
	}
	my $y = 0;
	while($y == 0)
	{
		print "Create Backups? <Y/N>";
		$backup = <stdin>;
		chomp $backup;
		if($backup eq 'Y' || $backup eq 'y') #if yes, create backup directory
			{
				mkdir "$time-backup"; #for some reason perl has weird month issues, keep an eye on $mon
				$y = 1;
				######### copying original files to backup
				while($foldercount < $maxfolder && ($foldercount < 10 && $maxfolder > 9))	
					{
						copy("$dirname\\0$foldercount\\0$foldercount\.sim.sub","$time-backup\\0$foldercount.sim.sub") or die "$!";
						print "$dirname\\$foldercount\\$foldercount\.sim.sub\n";
						$foldercount++;
					}
				while($foldercount < $maxfolder)
					{
						copy("$dirname\\$foldercount\\$foldercount\.sim.sub","$time-backup\\$foldercount.sim.sub") or die "$!";
						print "$dirname\\$foldercount\\$foldercount\.sim.sub\n";
						$foldercount++;
					}
				$foldercount = 0;
			}
		elsif($backup eq 'N' || $backup eq 'n') #do nothing if user enters no
			{
				$y = 1;
			}
		else{
		print "Invalid entry\n";
		}
	}
}
############# logic/file I/O
while($foldercount < $maxfolder && ($foldercount < 10 && $maxfolder > 9))	
	{
	print "$dirname\\$foldercount\\$foldercount\.sim.sub\n";  #enable to print directory for each file during read
	open(my $read, '<', "$dirname\\0$foldercount\\0$foldercount\.sim\.sub") or die "$!";		#opens the file to read from
	open(my $write, '>', "$dirname\\0$foldercount\\0$foldercount\.sim\.sub.tmp") or die "$!";	#creates file to write to
	#print $write "write success\n";  #debugging, prints line of text at top of write file

	while (<$read>) 					
		{	#this is where the magic happens:
		if (s/^arguments.*?([0-9]{1,10}).*/arguments               = "$entry"/) 	#matches number between 1 and 10 digits long on line starting with "arguments", replaces line with suer entry
			{
				my $seed = $1; 				#sets the value of $seed to the number that was matched
				s/\$seed/$seed/;			#replaces user entry token with actual value of $seed
			}
		print $write $_; #prints line to write file
		}
		

	
	$foldercount++;						  #increments folder to move to next file
	}
#the following block executes if less than 10 total, or if folder 10 has already been reached
while($foldercount < $maxfolder)
{
	print "$dirname\\$foldercount\\$foldercount\.sim.sub\n";	#enable to print directory for each file during read
	open(my $read, '<', "$dirname\\$foldercount\\$foldercount\.sim\.sub") or die "$!";
	open(my $write, '>', "$dirname\\$foldercount\\$foldercount\.sim\.sub.tmp") or die "$!";
	
	while (<$read>) 					
		{
		if (s/^arguments.*?([0-9]{1,10}).*/arguments               = "$entry"/)
			{	  
				my $seed = $1;
				s/\$seed/$seed/;
			}
		print $write $_;
		}
		

		
	$foldercount++;
}
###### finally, go through and rename
$foldercount = 0;
while($foldercount < $maxfolder && ($foldercount < 10 && $maxfolder > 9))	
	{
		rename("$dirname\\0$foldercount\\0$foldercount.sim.sub.tmp","$dirname\\0$foldercount\\0$foldercount.sim.sub");
		$foldercount++;
	}
while($foldercount < $maxfolder)	
	{
		rename("$dirname\\$foldercount\\$foldercount.sim.sub.tmp","$dirname\\$foldercount\\$foldercount.sim.sub");
		$foldercount++;
	}
print "Finished\n";
