## Files: ##

- Task 1:
  - "myprocinfo.bash" - Accesses a bunch of information about the script itself and the command-line process running it.
- Task 2:
  - chromemajPF.bash - Gets the number of mayour page faults all processes of chrome generated.
- Task 3:
  - procmi.bash - Takes in arbitrary number of process-id's as arguments and generates a file for each, and fills them with a bunch of memory information. 

#### Shellcheck ####

* Is a static analysis tool for validating shell scripts.

Installation:
* Can be installed with: "sudo apt-get install shellcheck"
* OR you can use the online version: https://www.shellcheck.net

I ran the following command to check all scripts:

* shellcheck -s bash \<file_name\>