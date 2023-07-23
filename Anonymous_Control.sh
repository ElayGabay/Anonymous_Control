#!/bin/bash

#Before using the script read the txt file README


#Value for "/var/log/Remote_Control_log.txt".
log_file="/var/log/Anonymous_Control_log.txt"

#Function to make the Remote_Control_log.txt.
#This function includes LOG_MESSAGE in the script to handle logging..
function LOG_MESSAGE() {
	
    local message="$1"
    if [[ -n "$message" ]]; then
        echo "$(date '+[%Y-%m-%d %H:%M:%S]') $message" >> "$log_file"
    fi
}

#Verifying if figlet is installed if not, installing figlet.
function INSTALL_FIGLET() {
if ! command -v figlet &> /dev/null; 
	then
		sudo apt-get install -y figlet &> /dev/null
		LOG_MESSAGE "[*]Figlet is installed." 
	fi
	
	#Using figlet command to display Anonymous and echo command for the color red.
	echo -e "\e[31m$(figlet Anonymous)\e[0m"
}



#This function installs the required applications, such as nmap, sshpass, cpanminus, and nipe.
function INSTALL_APP() {

	LOG_MESSAGE "[*]installing needed application"	
	echo "[!]Please wait installation is in process...."
	

	if ! command -v nmap &> /dev/null; 
	then
		sudo apt-get install -y nmap &> /dev/null
		LOG_MESSAGE "[*]Nmap is installed." 
	fi

	if ! command -v sshpass &> /dev/null; 
	then
		sudo apt-get install -y sshpass &> /dev/null
		LOG_MESSAGE "[*]Sshpass is installed." 
	fi

	if ! command -v cpanm &> /dev/null; 
	then
		echo 'yes' | sudo cpan App::cpanminus &> /dev/null
		LOG_MESSAGE "[*]Cpanmius is installed."
	fi

	if [[ -z $(sudo find / -name nipe) ]] &> /dev/null; 
	then
		sudo git clone https://github.com/htrgouvea/nipe &> /dev/null
		sudo sh -c "cd nipe && cpanm --installdeps . && perl nipe.pl install" &> /dev/null
		LOG_MESSAGE "[*]Nipe is installed." 
	fi

	echo "[*]installation is done."
	LOG_MESSAGE "[*]installing is done"

}

#This function initiates the 'nipe' application and checks if the connection is anonymous.
#The 'nipe' application is started twice within the function to address a bug that prevents it from starting on the first run.
function NIPE_START() {
		
	nipe_directory=$(sudo find / -name "nipe" -print -quit 2>/dev/null)

	if [ -d "$nipe_directory" ]; 
	then
		cd "$nipe_directory"
		sudo perl nipe.pl start
		sudo perl nipe.pl stop
		sudo perl nipe.pl start 

	if sudo perl "$nipe_directory/nipe.pl" status | grep -i "true" &> /dev/null;
	then 
		echo "[*]The network connection is anonymous."
		LOG_MESSAGE "[*]Nipe start, connection is anonymouse."
	else
		echo "[*]The network connection is not anonymous."
		LOG_MESSAGE "[*]Nipe failed connection is not anoynmouse."
		exit 
	fi	
	fi
}


#Display the spof IP and the spof COUNTRY.
function SPOF_NETWORK() {
	
	
    nipe_directory=$(sudo find / -name "nipe" -print -quit 2>/dev/null)
    anonymous_ip=$(cd "$nipe_directory" && sudo perl nipe.pl status | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
	spof_curl=$(curl -s https://ipwhois.app/json/$anonymous_ip | grep -oP '(?<="country":")[^"]+')
	
	LOG_MESSAGE "[*]The SPOF IP is: $anonymous_ip"
	LOG_MESSAGE "[*]The SPOF country is : $spof_curl"
		
	echo "[*]The SPOF Ip is :$anonymous_ip The SPOF country is : $spof_curl"
	cd ..
}

#Function to check if the files exist, and if they do not, create them.
function FILE_CREATE() {
	
	#Checking if the file 'Nmap.txt' exists, and if it doesn't, creating it and give it write permissions to everyone.
	if [[ -z $(sudo find / -name Nmap.txt) ]] &> /dev/null; 
	then
        touch Nmap.txt
        sudo chmod +w Nmap.txt
	else 	
		sudo chmod +w Nmap.txt
    fi
	LOG_MESSAGE "[@]File Nmap.txt was created."
	
	#Checking if the file 'Whois.txt' exists, and if it doesn't, creating it and give it write permissions to everyone.
	if [[ -z $(sudo find / -name Whois.txt) ]] &> /dev/null; 
	then
        touch Whois.txt
        sudo chmod +w Whois.txt
	else 	
		sudo chmod +w Whois.txt
    fi
	LOG_MESSAGE "[@]File Whois.txt was created."
	
}
#This function scan the ip and save the data in Nmap that the user put in the function 
function IP_SCAN() {
	
	read -rp "[?] What target would you like to scan IP/Domain? " ip_target
	LOG_MESSAGE "[*]Start nmap Scan"
    echo "[!] Scanning..."
    nmap "$ip_target" >> Nmap.txt 2>/dev/null
    echo "[@] File Nmap.txt was created."
    
    LOG_MESSAGE "[*]Nmap.txt is :$ip_target"
    LOG_MESSAGE "[@]File Nmap.txt was created."
    
}

#This function connects to a remote server using 'sshpass' and executes a specified command.
function SSHPASS() {
	
	
    target_ip=$(sudo sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "ifconfig eth0 | awk '/inet /{print \$2}'")
    public_ip=$(sudo sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "curl -s https://api.ipify.org")
    target_country=$(sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "curl -s https://ipwhois.app/json/$public_ip | grep -oP '(?<=\"country\":\")[^\"]+'")
	
	echo -e "\n"
    echo "[#] Connecting to the remote server..."
    LOG_MESSAGE "[#]Conecting to remote server via sshpass"
	sudo sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "echo '[*] The target IP address is: $target_ip'; echo '[*] The target country is: $target_country'; echo -n '[*] The Uptime is: '; uptime | tr '\n' ' '"
	LOG_MESSAGE "[*]Sshpass remote server IP is :$target_ip"
    LOG_MESSAGE "[*]Sshpass remote server Public IP is :$public_ip"
    LOG_MESSAGE "[*]Sshpass remote server Country is :$target_country"
    LOG_MESSAGE "[*]Sshpass conection is done."
	
	LOG_MESSAGE "[#]Conecting to remote server via sshpass"
	echo -e "\n" 
	echo "[#]Conectiong to sshpass victim's:"
	sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "whois $ip_target" >> Whois.txt 2>/dev/null
	echo "[@]The whois data store in: $(sudo find / -name Whois.txt 2>/dev/null)"
	LOG_MESSAGE "[*]The who is target is :$ip_target"
	LOG_MESSAGE	"[*]Sshpass conection is done."
	
	LOG_MESSAGE "[#]Connecting to the victim's SSH and initiating the scan"
	echo -e "\n" 
	echo "[#]Conectiong to sshpass victim's and start scaning:"
	sshpass -p "kali" ssh -o StrictHostKeyChecking=no kali@192.168.255.130 "nmap $ip_target" >> Nmap.txt 2>/dev/null
	echo "[@]The nmap data store in: $(sudo find / -name Nmap.txt 2>/dev/null)"
	LOG_MESSAGE "[*]The scan target is :$ip_target"
	LOG_MESSAGE "[*]Sshpass conection is done."
}


LOG_MESSAGE
INSTALL_FIGLET
INSTALL_APP
NIPE_START
SPOF_NETWORK
FILE_CREATE
IP_SCAN
SSHPASS
