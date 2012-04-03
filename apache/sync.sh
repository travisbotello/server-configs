#!/bin/bash
# Updates sites-available/default with the htaccess file from h5bp's main repo
#
# Download the raw .htaccess file from the html5-boilerplate project
# Indent the whole contents to the same depth as the placeholder comment it is going to be injected into
# Splice the contents of the htaccess file inbetween the two comment markers in sites-available/default
# Output to a temporary file, and then replace the original (because you can't do in-place updates with
# awk)

cd /tmp
rm .htaccess
wget --no-check-certificate https://raw.github.com/h5bp/html5-boilerplate/master/.htaccess

cd -
sed  's/^/                /'  /tmp/.htaccess > .htaccess

awk -v htaccess=.htaccess '
	/### .htaccess file contents ###/ {print; system("cat " htaccess); step=1; next}
	/### END .htaccess file contents ###/ {step=0}
	step {next}
	{print}
' sites-available/default > /tmp/h5bp-default && mv /tmp/h5bp-default sites-available/default && rm .htaccess
