# Sophos Update

## A standalone, _post_-post-install script to (hopefully) update Sophos and detect false-positive installation results

---

## Background

While deploying a recent [Sophos EDR](https://www.sophos.com/en-us/products/endpoint-antivirus/edr.aspx) pilot, creating a custom installer package with a minimal post-install script a close as possible to [Sophos Central: How to deploy Sophos Endpoint for macOS from Command Line](https://support.sophos.com/support/s/article/KB-000035045?language=en_US) seemed like the best approach:

```
#!/bin/sh
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3


# Install Sophos
echo "* Installing application ..."
/var/tmp/Sophos\ Endpoint\ Workforce\ EDR-2020-10-21/Sophos\ Installer.app/Contents/MacOS/Sophos\ Installer --install
echo "* Application installed."

# Remove Installer
echo "* Remove installer files ..."
/bin/rm -Rf /var/tmp/Sophos\ Endpoint\ Workforce\ EDR-2020-10-21
echo "* Installer removed."



exit 0		## Success
exit 1		## Failure

```

However, the Jamf Pro policy logs included a false-positive:

> 7. Verifying package integrity...
> 8. Installing Sophos Endpoint Workforce EDR-2020-10-21.pkg...
> 9. **Successfully installed Sophos Endpoint Workforce EDR-2020-10-21.pkg.**

Yes, the custom package had successfully executed, but the `SophosUpdate` binary was missing client-side.

Adding the one-liner of …

`if [ -f /usr/local/bin/SophosUpdate ]; then /usr/local/bin/SophosUpdate; else /bin/echo "Error: SophosUpdate NOT found"; fi`

… to …

**Jamf Pro Policy > Options > Files and Processes > Execute Command**, _still_ resulted in a false-positive Jamf Pro Policy Status of **Completed**.


> 13. Running command if [ -f /usr/local/bin/SophosUpdate ]; then /usr/local/bin/SophosUpdate; else /bin/echo "Error: SophosUpdate NOT found"; fi...
> 14. Result of command: **Error: SophosUpdate NOT found**

Jamf Support confirmed this is the current expected behavior and recommended creating yet another script.

---

## Script

[SophosUpdate.sh](SophosUpdate.sh)

This script is compatible with Jamf Pro and can be pasted directly — without modification — into a new Script window in Jamf Pro (no additional parameters need to be specified).

Add the script to your Sophos Endpoint policy to execute **After** the installation package.
