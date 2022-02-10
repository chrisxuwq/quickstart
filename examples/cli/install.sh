# install eru cli as binary 

CLI_DOWNLOAD_ADDR=$1

wget $CLI_DOWNLOAD_ADDR -O /tmp/eru_cli.tar.gz 

cd /tmp/
tar zxf eru_cli.tar.gz 
mv eru-cli /usr/local/bin/
chmod a+x /usr/local/bin/eru-cli 
rm /tmp/eru_cli.tar.gz 