if not exist c:\users\%username%\alphaz mkdir c:\users\%username%\alphaz
if not exist c:\users\%username%\alphaz\workspace mkdir c:\users\%username%\alphaz\workspace
if not exist c:\users\%username%\alphaz\git mkdir c:\users\%username%\alphaz\git
"C:\Program Files\Git\bin\bash.exe" -c  " echo $(ipconfig | grep IPv4 | tail -1 | sed 's|^.*: \(.*\)$|\1|') > /c/users/$(whoami)/alphaz/ip.txt"
set /p IP=</c/users/%username%/alphaz/ip.txt
del /c/users/%username%/alphaz/ip.txt
docker run -it --rm -e DISPLAY=%IP%:0.0 -v /c/Users/%username%/alphaz/workspace:/home/developer/eclipse-workspace -v /c/Users/%username%/alphaz/git:/home/developer/git narmour/alphaz-user-image
