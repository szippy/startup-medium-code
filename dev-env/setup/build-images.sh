
echo "building masterwork" 
docker build -t k3d-szippy-registry.localhost:12345/masterwork:latest -f masterwork/Dockerfile . 

echo "pushing masterwork" 
docker push k3d-szippy-registry.localhost:12345/masterwork:latest

echo "building worldbuilder"
docker build -t k3d-szippy-registry.localhost:12345/worldbuilder:latest -f worldbuilder/Dockerfile .

echo "pushing worldbuilder"
docker push k3d-szippy-registry.localhost:12345/worldbuilder:latest

echo "building web"
docker build -t k3d-szippy-registry.localhost:12345/web:latest -f web/Dockerfile .

echo "pushing web"
docker push k3d-szippy-registry.localhost:12345/web:latest
