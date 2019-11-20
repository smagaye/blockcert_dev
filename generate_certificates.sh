# Creation des certificats avec le fichier de configuration conf.ini
python3  cert-tools/cert_tools/create_v2_certificate_template.py -c cert-tools/conf.ini
python3  cert-tools/cert_tools/instantiate_v2_certificate_batch.py -c cert-tools/conf.ini

# Copie des certificats non signe vers cert-issuer
mv ./cert-tools/sample_data/unsigned_certificates/* ./cert-issuer/data/unsigned_certificates/

# Demarrage du conteneur cert-issuer
docker run -it -d bc/cert-issuer:1.0

# Récupération de l'identifiant du container cert-issuer 
idcontainer=$(docker ps --filter ancestor=bc/cert-issuer:1.0 --format {{.ID}})

echo "idcontainer : $idcontainer"

# Copie des certificats dans le container cert-issuer lancé
docker cp ./cert-issuer/data/unsigned_certificates/ $idcontainer:/etc/cert-issuer/data/
rm -rf ./cert-issuer/data/unsigned_certificates/*
echo "copie reussie!"

# Copie du fichier script dans le container
docker cp ./save_certificates.sh $idcontainer:/home/save_certificates.sh

# Execution de la generation de certficat
docker exec -it $idcontainer bash /home/save_certificates.sh

# Copie vers la machine local
docker cp $idcontainer:/etc/cert-issuer/data/blockchain_certificates/ ./certificates

# Stop container
docker stop $idcontainer
