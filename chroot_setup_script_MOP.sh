#!/QOpenSys/usr/bin/ksh

## CHANGED VERSION WITH 2 ARGS - BENOIT MAROLLEAU
##
##############################################################################
### Example script to setup chroot environment on IBM i
###
### Version 20160503
###
### IBM grants you a nonexclusive copyright license to use all programming
### code examples from which you can generate similar function tailored to
### your own specific needs.
###
### SUBJECT TO ANY STATUTORY WARRANTIES WHICH CANNOT BE EXCLUDED, IBM,
### ITS PROGRAM DEVELOPERS AND SUPPLIERS MAKE NO WARRANTIES OR CONDITIONS
### EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE IMPLIED
### WARRANTIES OR CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
### PURPOSE, AND NON-INFRINGEMENT, REGARDING THE PROGRAM OR TECHNICAL
### SUPPORT, IF ANY.
###
### UNDER NO CIRCUMSTANCES IS IBM, ITS PROGRAM DEVELOPERS OR SUPPLIERS
### LIABLE FOR ANY OF THE FOLLOWING, EVEN IF INFORMED OF THEIR POSSIBILITY:
###
### LOSS OF, OR DAMAGE TO, DATA;
### DIRECT, SPECIAL, INCIDENTAL, OR INDIRECT DAMAGES, OR FOR ANY ECONOMIC
### CONSEQUENTIAL DAMAGES; OR
### LOST PROFITS, BUSINESS, REVENUE, GOODWILL, OR ANTICIPATED SAVINGS.
### SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF DIRECT,
### INCIDENTAL, OR CONSEQUENTIAL DAMAGES, SO SOME OR ALL OF THE ABOVE
### LIMITATIONS OR EXCLUSIONS MAY NOT APPLY TO YOU.
###
##############################################################################

V=`uname -v`
R=`uname -r`

case $V$R in
61)
  USERDATA=/QOpenSys/QIBM/UserData/SC1/OpenSSH/openssh-3.8.1p1
  PRODDATA=/QOpenSys/QIBM/ProdData/SC1/OpenSSH/openssh-3.8.1p1
  ;;

71)
  USERDATA=/QOpenSys/QIBM/UserData/SC1/OpenSSH/openssh-4.7p1
  PRODDATA=/QOpenSys/QIBM/ProdData/SC1/OpenSSH/openssh-4.7p1
  ;;

*)
  if [ $V$R -lt 72 ]
  then
    echo "Unsupported version $V.$R"
    exit 1
  fi

  USERDATA=/QOpenSys/QIBM/UserData/SC1/OpenSSH
  PRODDATA=/QOpenSys/QIBM/ProdData/SC1/OpenSSH
  ;;
esac

# directory that will be created and used as the chroot root "/" directory
if [ -z "$CHROOTDIR" ]
then
  #CHROOTDIR=$USERDATA/chroot
  CHROOTDIR=$2
fi

if [ -z "$CHROOTLOCALE" ]
then
  CHROOTLOCALE='*C'
fi

FIRST=`echo "$CHROOTLOCALE" | /QOpenSys/usr/bin/cut -c 1`
if [ "$FIRST" != '*' -a $V -lt 7 ]
then
  echo "chroot user locale must be *C (default), *POSIX, or *NONE on IBM i 6.1 and below"
  exit 1
fi

# log file
LOGFILE=chroot_config.log

# (optional) userid to change home directory to trigger ssh chroot access
USER=$1

function log
{
  echo "$@"
  echo "$@" >> $LOGFILE
}

function log_only
{
  echo "$@" >> $LOGFILE
}

function log_cmd
{
  log_only "$@"

  prog=`shift`
  $prog "$@" >> $LOGFILE 2>&1
}

function show_progress
{
  echo ".\c"
}

log_only
log_only "$(date)"
log_only
log_only "Starting configuration of chroot environment. chroot-dir = $CHROOTDIR"
log_only

# ensure that we can handle user names longer than 8 characters
export PASE_USRGRP_LIMITED=N

# Step 1 - verify that the chroot directory does not yet exist
log "########## STEP 1 ##########"
log "Verify that the chroot-dir does not yet exist"
if [ -e $CHROOTDIR  ]
then
  log "Error: chroot-dir $CHROOTDIR already exists"
  exit 1
fi


# Step 2 - verify that the userid to be changed exists
log
log "########## STEP 2 ##########"
log "If specified, verify that the user profile to be changed to ssh chroot access exists"
if [ -n "$USER" ]
then
  # translate USER to all lowercase
  USER=`echo $USER | /QOpenSys/usr/bin/tr '[A-Z]' '[a-z]'`
  log_cmd /QOpenSys/usr/bin/id $USER
  if [ $? != 0 ]
  then
    log "Error: chroot user profile $USER does not exist"
    exit 2
  fi
fi


# Step 3 - create chroot directories
log
log "########## STEP 3 ##########"
log "Making necessary directories in chroot-dir"
log_only "/home, /home/<user>, /dev, /dev/pts, /usr/bin/X11, /usr/sbin, /usr/lib,  $PRODDATA/libexec and $PRODDATA/etc will be created"
log_only
log_cmd /QOpenSys/usr/bin/mkdir -p $CHROOTDIR
for i in /home /dev/pts /usr/bin/X11 /usr/sbin /usr/lib $PRODDATA/libexec $PRODDATA/etc
do
  log_cmd /QOpenSys/usr/bin/mkdir -p $CHROOTDIR/$i
  show_progress
done

if [ -n "$USER" ]
then
  log_cmd /QOpenSys/usr/bin/mkdir -p $CHROOTDIR/home/$USER
  show_progress
fi
echo


# Step 4 - set directory permissions
log
log "########## STEP 4 ##########"
log "Make sure that the permissions on all the files created inside the chrooted directory"
log "are same as the one for the original directories"
log_only
log_cmd /QOpenSys/usr/bin/chmod -R 0755 $CHROOTDIR


# Step 5 - create QOpenSys/usr symlink
log
log "########## STEP 5 ##########"
log "Create QOpenSys/usr symlink inside the chroot-dir directory"
log_only
log_cmd /QOpenSys/usr/bin/ln -s ../usr $CHROOTDIR/QOpenSys/usr


# Step 6 - copy binaries and libraries
log
log "########## STEP 6 ##########"
log "Copying example binaries and libraries to the chroot environment"
log_only
log_only "This script is an example script only!"
log_only "Thus, only a few binaries and the necessary libraries are copied to the chroot environment."
log_only "If you need additional binaries you will have to copy them manually to the chroot directories or adapt this script. "
log_only "Remember to check for any requisite libaries with the dump command and copy them to the chroot environment as well."
log_only
log_only "The following binaries and libraries have been copied to the chroot directory:"
log_only

for i in execerror sh bsh ksh cd pwd ls mkdir rmdir rm cp cat xauth scp ssh sftp
do
  log_cmd /QOpenSys/usr/bin/cp -p `which $i` $CHROOTDIR/`which $i`
  log_cmd /QOpenSys/usr/bin/ls -l $CHROOTDIR/`which $i`
  log_only
  show_progress
done

for i in /usr/lib/libc.a /usr/lib/libpthreads.a /usr/lib/libiconv.a /usr/lib/libcrypt.a /usr/lib/libcrypto.a /usr/lib/libcrypto.so.1.1 /usr/lib/libX11.a /usr/lib/libXext.a /usr/lib/libIM.a /usr/lib/libICE.a /usr/lib/libXi.a /usr/lib/libSM.a /usr/lib/libgaimisc.a /usr/lib/libgair4.a /usr/lib/libC.a /usr/lib/libz.a
do
  log_cmd /QOpenSys/usr/bin/cp -p $i $CHROOTDIR/$i
  log_cmd /QOpenSys/usr/bin/ls -l $CHROOTDIR/$i
  log_only
  show_progress
done

log_cmd /QOpenSys/usr/bin/cp -p $PRODDATA/etc/sshd_config $CHROOTDIR$PRODDATA/etc/sshd_config
log_cmd /QOpenSys/usr/bin/ls -al $CHROOTDIR$PRODDATA/etc/sshd_config
log_only
show_progress

log_cmd /QOpenSys/usr/bin/cp -p $PRODDATA/libexec/sftp-server $CHROOTDIR$PRODDATA/libexec/sftp-server
log_cmd /QOpenSys/usr/bin/ls -al $CHROOTDIR$PRODDATA/libexec/sftp-server
log_only
show_progress
echo


# Step 7 - create necessary devices
log
log "########## STEP 7 ##########"
log "Necessary devices will be created in the chroot environment"
log_only

log_cmd /QOpenSys/usr/sbin/mknod $CHROOTDIR/dev/tty c 32945 0
show_progress

log_cmd /QOpenSys/usr/sbin/mknod $CHROOTDIR/dev/null c 32769 1
show_progress

log_cmd /QOpenSys/usr/sbin/mknod $CHROOTDIR/dev/zero c 32769 2
show_progress

log_cmd /QOpenSys/usr/sbin/mknod $CHROOTDIR/dev/urandom c 32954 1
show_progress

i=0
while [ $i -lt 10 ]
do
  log_cmd /QOpenSys/usr/sbin/mknod $CHROOTDIR/dev/pts/$i c 32947 $i
  show_progress
  ((i=i+1))
done

for i in zero null tty urandom
do
  log_cmd /QOpenSys/usr/bin/chmod 0666 $CHROOTDIR/dev/$i
  show_progress
done

log_cmd /QOpenSys/usr/bin/chmod 0666 $CHROOTDIR/dev/pts/*

log_only
log_only "The following devices have been configured within your chroot environment:"
log_only
for i in zero null tty urandom
do
  log_cmd /QOpenSys/usr/bin/ls -al $CHROOTDIR/dev/$i
  log_only
  show_progress
done

i=0
while [ $i -lt 10 ]
do
  log_cmd /QOpenSys/usr/bin/ls -al $CHROOTDIR/dev/pts/$i
  log_only
  show_progress
  ((i=i+1))
done
echo


# Step 8 - change ownership
log
log "########## STEP 8 ##########"
log "Change ownership of files in chroot environment:"
log_only
log_cmd /QOpenSys/usr/bin/chown -Rh qsys:0 $CHROOTDIR
if [ -n "$USER" ]
then
  log_cmd /QOpenSys/usr/bin/chown $USER $CHROOTDIR/home/$USER
fi


# Step 9 - change home directory of chroot user to enable chroot at ssh connection
log
log "########## STEP 9 ##########"
log "If specified, change user profile home directory to enable chroot ssh connection"
if [ -n "$USER" ]
then
  log_only
  log_cmd /QOpenSys/usr/bin/system "CHGUSRPRF USRPRF($USER) HOMEDIR('$CHROOTDIR/./home/$USER')"
fi


# Step 10 - set chroot user profile to use C locale
log
log "########## STEP 10 ##########"
log "If specified, change user profile locale to enable chroot ssh connection"
if [ -n "$USER" -a $V -lt 7 ]
then
  log_only
  log_cmd /QOpenSys/usr/bin/system "CHGUSRPRF USRPRF($USER) LOCALE('$CHROOTLOCALE')"
fi


log
log "########## FINISH ##########"
log
log "Configuration of the following chroot environment has completed:"
log_only
log_cmd /QOpenSys/usr/bin/find $CHROOTDIR -ls
log
echo "A log file was created for reference if needed: $LOGFILE"