# Ensure your docker image is running and bitcoind process is started
# Create an 'issuing address' and save the output as follows:

issuer=`bitcoin-cli getnewaddress`
sed -i.bak "s/<issuing-address>/$issuer/g" /etc/cert-issuer/conf.ini
bitcoin-cli dumpprivkey $issuer > /etc/cert-issuer/pk_issuer.txt

# You're using bitcoind in regtest mode, so you can print money. This should give you 50 (fake) BTC:

bitcoin-cli generate 101
bitcoin-cli getbalance

# Send the money to your issuing address -- note that bitcoin-cli's standard denomination is bitcoins not satoshis
#(In our app, the standard unit is satoshis.) This command sends 5 bitcoins to the address

bitcoin-cli sendtoaddress $issuer 5

# Issue the certificates on the blockchain

cert-issuer -c /etc/cert-issuer/conf.ini
