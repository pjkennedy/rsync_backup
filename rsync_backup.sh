HOME="/home/joe"

# run this script from $HOME/joe/sh

# make unequal to skip staging of data
if [ "true" = "true" ]; then

  # reminder: probably run like this script like this: 
  # nice -n 15 ./rsync_backup.sh
  #
  # umount everything; remote just the 1st (a fair assumption) 
  umount /dev/sdb1    2> /dev/null  # toshiba portable hard drive
  umount /dev/sdb2    2> /dev/null  # usb thumb
  umount /media/joe_aux/*  2> /dev/null

  echo 'formatting'
  echo 'y' | mkfs.ext4 /dev/sdb1

  echo 'mount sdb1' > $HOME/sh/log.txt
  mkdir -p /media/joe_aux
  mount /dev/sdb1 /media/joe_aux  2> /dev/null

  cd /media/joe_aux

fi


if [ "true" = "true" ]; then


 ############################
 # cp data to staging areas #
 ############################

# Pre-staging selected data 
# moving data to stuff1 (mostly text) and stuff2 (mostly binary)
# never delete stuff1 and stuff2; they are the permanent data sources;
# just added stuff outside them
# 
# modify as needed
 echo 'Downloads'
 rsync -azP $HOME/Downloads    $HOME/stuff1

 echo 'apt sources'
 rsync -azP /etc/apt/sources.list    $HOME/stuff1

 echo 'web server data'
 rsync -azP /var/www $HOME/stuff2

 echo 'staging done'

fi

# if you already prestaged, then you can just to the latter part sometimes
if [ "true" = "true" ]; then
 ####cd $HOME

 #***********************************
 # Copy staged data to remote media
 #***********************************


 rsync -azP $HOME/stuff1 /media/joe_aux
 rsync -azP $HOME/stuff2 /media/joe_aux


 touch /media/joe_aux/done.txt
 cd /media/joe_aux
 find . | wc -l >> done.txt
 cat done.txt
fi
