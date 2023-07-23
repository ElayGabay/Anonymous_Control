
Anonymous_Control.sh
2023 ElayGabay 

---------------------
Warning
---------------------
Please use the application responsibly and solely for learning and self-improvement
purposes. Do not utilize it for hacking or gathering information on others. Be a white hat
hacker, using your skills ethically and responsibly.

------------------------
How to use the script
------------------------
Before running the script, make sure it has the required permissions:
sudo chmod +x Anonymous_Control.sh
To start the application, you must have sudo privileges. Run one of the following commands:
sudo ./Anonymous_Control.sh
sudo bash Anonymous_Control.sh
It is essential to execute the application with sudo privileges; otherwise, it will not function
correctly. Please ensure you run it with elevated privileges to ensure proper functionality.
Additionally, you need to make changes in the script to include your own password, username,
and the IP address of the server you wish to connect to via sshpass. This ensures that it will work properly
Remember, this application is intended for learning and personal use only; refrain from
using it for hacking or gathering information on others. Adopt the role of a white hat hacker, utilizing your skills ethically and responsibly.

-------------------
Description
-------------------
Every time you run "Anonymous_Control," it will automatically download the required applications needed for its operation.
Additionally, the script will spoof your internet connection, ensuring anonymity,
and display your spoofed IP along with the corresponding country information obtained from a whois website.
The "Anonymous_Control" application will prompt you to enter an IP/DOMAIN for scanning.
After performing the scan, it will save the results in a file named "Nmap.txt." Each time you run the script,
it will add new information about your scan to the existing "Nmap.txt" file without overwriting the previous data.
Furthermore, the script will connect to a remote server using "sshpass" and perform the same requested scan via an SSH
connection. The results of this remote scan will also be added to the "Nmap.txt" file. 
Additionally, the script will fetch information about the provided IP/DOMAIN through the SSH connection
and store the data in a file named "Whois.txt."
As you continue to run the script, it will keep accumulating more information about your scans in the
"Nmap.txt" and "Whois.txt" files. Moreover, you can monitor the script's log in "/var/log/Anonymous_Control_log.txt."

---------------------
Signature signs
---------------------

[*] --- Information line.
[!] --- Scanning or installing line.
[#] --- Connection to server line.
[@] --- File was created or the file's location line.
[?] --- Question line.	

