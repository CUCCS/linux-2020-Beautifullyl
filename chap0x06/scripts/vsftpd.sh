#!/usr/bin/env bash



#apt update



#if [[ $? -ne 0 ]];then

#		echo "apt update failed!"

#		exit

#fi





# ...........vsftpd


if ! command -v vsftpd > /dev/null
then

  apt install vsftpd -y

	if ! apt install vsftpd -y
        then
		echo "failed to install vsftpd!"
	        exit

	fi

else

  echo "vsftpd is already installed!"

fi



conf=/etc/vsftpd.conf

# ..........

if [[ ! -f "${conf}.bak" ]];then

		# .............

		cp "$conf" "$conf".bak

else

		echo "${conf}.bak already exits!"

fi







# ......FTP..

# .............

anon_path="/var/ftp/pub"

if [[ ! -d "$anon_path" ]];

then

		mkdir -p "$anon_path"

fi



# ..pub.......

chown nobody:nogroup "$anon_path"

echo "vsftpd test file" | sudo tee "${anon_path}/test.txt"



# ..vsftpd.conf

# allow anonymous FTP

sed -i -e "/anonymous_enable=/s/^[#]//g;/anonymous_enable=/s/NO/YES/g" "$conf"

# not allow anonymous user to upload files

sed -i -e "/anon_upload_enable=/s/^[#]//g;/anon_upload_enable=/s/YES/NO/g" "$conf"

# not allow anonymous user to create new directories

sed -i -e "/anon_mkdir_write_enable=/s/^[#]//g;/anon_mkdir_write_enable=/s/YES/NO/g" "$conf"



grep -q "anon_root=" "$conf" && sed -i -e "#anon_root=#s#^[#]##g;#anon_root=#s#\=.*#=/var/ftp#g" "$conf" || echo "anon_root=/var/ftp" >> "$conf"

grep -q "no_anon_password=" "$conf" && sed -i -e "/no_anon_password=/s/^[#]//g;/no_anon_password=/s/\=.*/=YES/g" "$conf" || echo "no_anon_password=YES" >> "$conf"





# ...............

user="sammy"

# ....

if [[ $(grep -c "^$user:" /etc/passwd) -eq 0 ]];then

		adduser $user

else

		echo "${user} is already exited!"

fi



# ......

u_path="/home/${user}/ftp"

if [[ ! -d "$u_path" ]];

then

		mkdir "$u_path"

else

		echo "${u_path} is already exited!"

fi

# .....

chown nobody:nogroup "$u_path"

# .....

chmod a-w "$u_path"

# ....

ls -la "$u_path"

# .....upload..

u_write_path="${u_path}/files"



if [[ ! -d "$u_write_path" ]];

then

		mkdir "$u_write_path"

else

		echo "${u_write_path} is already exited!"

fi

chown "$user":"$user" "$u_write_path"

ls -la "$u_path"

echo "vsftpd test file" | tee "${u_write_path}/test.txt"



# ......

sed -i -e "/local_enable=/s/^[#]//g;/local_enbale=/s/NO/YES/g" "$conf"

sed -i -e "/write_enable=/s/^[#]//g;/^write_enable=/s/NO/YES/g" "$conf"

# ...............

sed -i -e "/chroot_local_user=/s/^[#]//g;/chroot_local_user=/s/NO/YES/g" "$conf"



# ........FTP...

port_min=40000

port_max=50000

grep -q "pasv_min_port=" "$conf" && sed -i -e "/pasv_min_port=/s/^[#]//g;/pasv_min_port=/s/\=.*/=${port_min}/g" "$conf" || echo "pasv_min_port=${port_min}" >> "$conf" 



grep -q "pasv_max_port=" "$conf" && sed -i -e "/pasv_max_port=/s/^[#]//g;/pasv_max_port=/s/\=.*/=${port_max}/g" "$conf" || echo "pasv_max_port=${port_max}" >>  "$conf"







# .........userlist....

grep -q "userlist_enable=" "$conf" && sed -i -e "/userlist_enable=/s/^[#]//g;/userlist_enable=/s/\=.*/=YES/g" "$conf" || echo "userlist_enable=YES" >> "$conf"



grep -q "userlist_file=" "$conf" && sed -i -e "#userlist_file=#s#^[#]##g;#userlist_file=#s#\=.*#=/etc/vsftpd.userlist#g" "$conf" || echo "userlist_file=/etc/vsftpd.userlist" >> "$conf"

# only user on the list allow access

grep -q "userlist_deny=" "$conf" && sed -i -e "/userlist_deny=/s/^[#]//g;/userlist_deny=/s/\=.*/=NO/g" "$conf" || echo "userlist_deny=NO" >> "$conf"



# ......userlist

grep -q "$user" /etc/vsftpd.userlist ||  echo "$user" | tee -a /etc/vsftpd.userlist

grep -q "anonymous" /etc/vsftpd.userlist || echo "anonymous" | tee -a /etc/vsftpd.userlist



# ..........ftp

grep -q "tcp_wrappers=" "$conf" && sed -i -e "/tcp_wrappers=/s/^[#]//g;/tcp_wrappers=/s/NO/YES/g" "$conf" || echo "tcp_wrappers=YES" >> "$conf"

grep -q "vsftpd:ALL" /etc/hosts.deny || echo "vsftpd:ALL" >> /etc/hosts.deny

grep -q "vsftpd:192.168.56.101" /etc/hosts.allow || echo "vsftpd:192.168.56.101" >> /etc/hosts.allow

grep -q "allow_writeable_chroot=" "$conf" && sed -i -e "/allow_writeable_chroot=/s/^[#]//g;/allow_writeable_chroot=/s/NO/YES/g" "$conf" || echo "allow_writeable_chroot=YES" >> "$conf"



# ..vsftpd..

if pgrep -x "vsftpd" > /dev/null

then 

		systemctl restart vsftpd

else

		systemctl start vsftpd

fi


