#!/usr/bin/sh -e
# This script mounts a user's confidential private folder
#
# Original by Michael Halcrow, IBM
# Extracted to a stand-alone script by Dustin Kirkland <kirkland@ubuntu.com>
#
# This script:
#  * interactively prompts for a user's wrapping passphrase (defaults to their
#    login passphrase)
#  * checks it for validity
#  * unwraps a users mount passphrase with their supplied wrapping passphrase
#  * inserts the mount passphrase into the keyring
#  * and mounts a user's encrypted private folder

PRIVATE_DIR="Private"
WRAPPING_PASS="LOGIN"
PW_ATTEMPTS=3
TEXTDOMAIN="ecryptfs-utils"
MESSAGE=`gettext "Enter your login passphrase:"`

if [ -f $HOME/.ecryptfs/wrapping-independent ]; then
	# use a wrapping passphrase different from the login passphrase
	WRAPPING_PASS="INDEPENDENT"
	MESSAGE=`gettext "Enter your wrapping passphrase:"`
fi

WRAPPED_PASSPHRASE_FILE="$HOME/.ecryptfs/wrapped-passphrase"
MOUNT_PASSPHRASE_SIG_FILE="$HOME/.ecryptfs/$PRIVATE_DIR.sig"

# First, silently try to perform the mount, which would succeed if the appropriate
# key is available in the keyring
if /sbin/mount.ecryptfs_private >/dev/null 2>&1; then
	exit 0
fi

#load kernel module if it's missing, FNE support check would fail otherwise
[ ! -e /sys/fs/ecryptfs/version ] && modinfo ecryptfs >/dev/null 2>&1 && /sbin/mount.ecryptfs_private --loadmodule

# Otherwise, interactively prompt for the user's password
if [ -f "$WRAPPED_PASSPHRASE_FILE" -a -f "$MOUNT_PASSPHRASE_SIG_FILE" ]; then
	tries=0
	stty_orig=`stty -g`
	while [ $tries -lt $PW_ATTEMPTS ]; do
		echo -n "$MESSAGE"
		stty -echo
		LOGINPASS=`zenity --password --title="Mount folder"`
		stty $stty_orig
		echo
		if [ $(wc -l < "$MOUNT_PASSPHRASE_SIG_FILE") = "1" ]; then
			# No filename encryption; only insert fek
			if printf "%s\0" "$LOGINPASS" | ecryptfs-unwrap-passphrase "$WRAPPED_PASSPHRASE_FILE" - | ecryptfs-add-passphrase -; then
				break
			else
				echo `gettext "ERROR:"` `gettext "Your passphrase is incorrect"`
				tries=$(($tries + 1))
				continue
			fi
		else
			if printf "%s\0" "$LOGINPASS" | ecryptfs-insert-wrapped-passphrase-into-keyring "$WRAPPED_PASSPHRASE_FILE" - ; then
				break
			else
				echo `gettext "ERROR:"` `gettext "Your passphrase is incorrect"`
				tries=$(($tries + 1))
				continue
			fi
		fi
	done
	if [ $tries -ge $PW_ATTEMPTS ]; then
		echo `gettext "ERROR:"` `gettext "Too many incorrect password attempts, exiting"`
		exit 1
	fi
	if ! /sbin/mount.ecryptfs_private;
	then
		# Check if the ecryptfs group exists, and user is member of ecryptfs group
		if grep -qs "^ecryptfs:" /etc/group; then
		        if ! id "$USER" | grep -qs "\(ecryptfs\)"; then
	                       echo $(gettext 'ERROR: ') $(gettext 'User needs to be a member of ecryptfs group')
                               exit 1
		        fi
		fi
	fi
else
	echo `gettext "ERROR:"` `gettext "Encrypted private directory is not setup properly"`
	exit 1
fi
if grep -qs "$HOME/.Private $PWD ecryptfs " /proc/mounts 2>/dev/null; then
	echo
	echo `gettext "INFO:"` `gettext "Your private directory has been mounted."`
	echo `gettext "INFO:"` `gettext "To see this change in your current shell:"`
	echo "  cd $PWD"
	echo
fi
exit 0
