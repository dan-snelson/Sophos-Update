#!/bin/sh
####################################################################################################
#
# ABOUT
#
#	Update Sophos Endpoint via the /usr/local/bin/SophosUpdate binary
#
####################################################################################################
#
# HISTORY
#
#	Version 1.0.0, 14-Nov-2020, Dan K. Snelson
#		Original version
#
####################################################################################################

/bin/echo "Sophos Update, v1.0.0"

# Check for the SophosUpdate binary
if [ -f /usr/local/bin/SophosUpdate ]; then

	/bin/echo "Success: \"/usr/local/bin/SophosUpdate\" found; proceeding …"

	# Pause for 45 seconds
	/bin/echo "Pause for 45 seconds …"
	/bin/sleep 45
	/bin/echo "Resume …"

	/usr/local/bin/SophosUpdate > /var/tmp/SophosUpdate.log 2>&1

	sophosUpdateResult=$( /bin/cat /var/tmp/SophosUpdate.log )

	case "${sophosUpdateResult}" in

		*"URL is invalid!"*		)
			/bin/echo "Error: URL is invalid!"
			exit 1
			;;

		*"up-to-date"*			)
			/bin/echo "Success: Sophos Anti-Virus is up-to-date"
			exit 0
			;;

		*						)
			/bin/echo "Update Result: ${sophosUpdateResult}"
			exit 0
			;;

	esac

	/bin/rm /var/tmp/SophosUpdate.log

else

	/bin/echo "Error: \"/usr/local/bin/SophosUpdate\" NOT found!"
	exit 1

fi

exit 0
