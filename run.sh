docker build -t dustinwang/laratest:1.2 .
docker run  -d --name laratest --rm -p 8000:8000 -d dustinwang/laratest:1.2

docker push dustinwang/laratest:1.3

k8s=========================================================
minikube start --container-runtime=containerd

kubectl create -f k8s/my-first-pod.yaml
kubectl port-forward laratest-pod 8000:8000
K8S內部跳版================================================
kubectl run -i --tty alpine --image=alpine --restart=Never -- sh
apk add --no-cache curl
=========================================================
kubectl create -f k8s/my-replication-controller.yaml
kubectl scale --replicas=4 -f k8s/my-replication-controller.yaml
kubectl delete rc my-replication-controller --cascade=false

kubectl set image deployment my-laratest-deployment my-laratest=dustinwang/laratest:1.3 --record
kubectl rollout history deployment my-laratest-deployment
kubectl rollout undo deployment my-laratest-deployment

kubectl create -f k8s/my-laratest-service.yaml 
minikube service my-laratest-service --url

gcloud====================================================
https://blog.cloud-ace.tw/application-modernization/devops/gke-autopilot-tutorial/
gcloud auth configure-docker asia-east1-docker.pkg.dev
docker build -t asia-east1-docker.pkg.dev/stately-voltage-381808/sit-docker/laratest:latest .
docker push asia-east1-docker.pkg.dev/stately-voltage-381808/sit-docker/laratest:1.0

gcloud container clusters get-credentials asit-cluster --region=asia-east1
「開啟API」
gcloud services enable compute.googleapis.com sqladmin.googleapis.com \
     container.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

[k8s]
gcloud container clusters get-credentials asit-cluster --region asia-east1
gcloud iam service-accounts create gke-quickstart-service-account --display-name="GKE Quickstart Service Account"
[PersistentVolume]
gcloud container clusters update asit-cluster --update-addons=GcePersistentDiskCsiDriver=ENABLED --region=asia-east1
kubectl create -f pd-example-class.yaml
kubectl create -f pvc-example.yaml

cloudsql==================================================
https://blog.cloud-ace.tw/database/cloud-sqlpart2-cloud-sql-proxy/
cloud_sql_proxy -instances=stately-voltage-381808:asia-east1:my-dev-pgsql=tcp:5432 \
   -credential_file=/Users/dustin/Projects/docker/Docker_PHP/alpine-php-webserver-master/k8s/stately-voltage-381808-5b1b94e0fc78.json &
QAZwsxp!@#

apk --update add postgresql-client
psql -h 10.55.112.3 -d postgres -U postgres

[IAP TCP-Forwarding]
https://blog.cloud-ace.tw/identity-security/iap-tcp-forwarding/

pgbuncer================================================
https://jmrobles.medium.com/postgres-connection-pool-on-kubernetes-in-1-minute-80b8020315ef
https://github.com/edoburu/docker-pgbouncer#configuration

kubectl create secret generic pgpwd \
  --from-literal POSTGRES_PASSWORD='QAZwsxp!@#'
  
kubectl create configmap pgsql \
     --from-literal POSTGRES_HOST_INNER=10.55.112.3 \
     --from-literal POSTGRES_USER=postgres

kubectl apply -f pgbouncer-deployment.yaml
kubectl apply -f pgbouncer-service.yaml
[run postgresql]
docker run --name postgres -e "POSTGRES_USER=dustin" -e "POSTGRES_PASSWORD=qazwsxp123" \
--network=docker-apisix_apisix --volume=/Users/dustin/Projects/Server/pgsql:/var/lib/postgresql/data -d postgres

docker run \
    -e "POSTGRESQL_HOST=postgres" \
    -e "POSTGRESQL_USERNAME=dustin" \
    -e "POSTGRESQL_PASSWORD=qazwsxp123" \
    -e "POSTGRESQL_DATABASE=postgres" \
    -e "PGBOUNCER_PORT=5432" \
    -e "PGBOUNCER_POOL_MODE=transaction" \
    -p 5432:5432 \
    --network=docker-apisix_apisix \
    --name=pgbouncer \
    -d bitnami/pgbouncer

psql -h pgbouncer-service -U postgres
psql postgres://postgres@pgbouncer-service/pgbouncer

GCE==========================================================
gcloud compute instances create gcelab2 --machine-type e2-medium --zone=asia-east1-b --project=stately-voltage-381808
gcloud compute ssh --project=stately-voltage-381808 --zone=asia-east1-b gcelab
sudo apt-get install postgresql-client 

Helm==========================================================
https://cwhu.medium.com/kubernetes-helm-chart-tutorial-fbdad62a8b61
https://helm.sh/zh/docs/intro/quickstart/
https://godleon.github.io/blog/DevOps/Helm-v3-Chart-Template-Guide/
helm create helm-demo
#測試運行
helm install --dry-run --debug larademo ./charts/larademo/ 
helm install --set favorite.food1=" bar" --dry-run --debug goodly-guppy .
helm install --dry-run --debug goodly-guppy .

terraform=====================================================
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
terraform destroy --target=helm_release.larademo

cloudrun==========================================================
https://www.minwt.com/website/server/22907.html
gcloud builds submit --tag asia.gcr.io/stately-voltage-381808/phpsite-image 

cloud_source======================================================
Host source.developers.google.com
 HostName source.developers.google.com
 IdentityFile ~/.ssh/gcsource_rsa

ssh-keygen -t rsa -C "dustinwang1105@gmail.com"
git clone ssh://dustinwang1105@gmail.com@source.developers.google.com:2022/p/stately-voltage-381808/r/phpsite

google cloud vpn=====================================================
https://hazel.style/2022/06/23/AWS-to-GCP-site-to-site-VPN/
https://ikala.cloud/google-cloud-vpn/
https://medium.com/google-cloud/how-to-setup-point-to-site-vpn-in-google-cloud-using-openvpn-66f642ba08c9

https://104.199.220.187:943/Admin


Laravel===========================================================
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
BRANCH_HASH=$(git rev-parse HEAD)
docker build -t dustinwang/larademo:1.0 .

docker build -t asia.gcr.io/stately-voltage-381808/sit-docker/larademo:latest -f Dockerfile_docker .
docker push asia.gcr.io/stately-voltage-381808/sit-docker/larademo:v1.0.5
docker run -d --name larademo -p 8000:8080 --network=docker-apisix_apisix asia.gcr.io/stately-voltage-381808/sit-docker/larademo:latest
docker exec -it larademo /bin/bash

docker build -t asia.gcr.io/myvpn-385103/sit-docker/larademo:v1.0.1 .
docker push asia.gcr.io/myvpn-385103/sit-docker/larademo:v1.0.1

gcloud builds submit --tag asia.gcr.io/stately-voltage-381808/sit-docker/larademo:v1.0.9
[deploy]
kubectl rollout history deploy larademo-deployment
kubectl apply -f larademo-deployment.yaml
kubectl set image deployment larademo-deployment larademo=asia.gcr.io/stately-voltage-381808/sit-docker/larademo:v1.0.7

docker run -d --name larademo -p 8080:8080 dustinwang/larademo:1.0
composer create-project --prefer-dist laravel/laravel larademo

php artisan make:provider GetwayServiceProvider
php artisan config:clear
php artisan config:cache --env=local
php artisan key:generate
php artisan migrate --env=local --database=pgsql
php artisan env #檢視現在環境
#產生資料庫PHP物件==========================================================================
https://github.com/kitloong/laravel-migrations-generator
composer require --dev kitloong/laravel-migrations-generator
php artisan migrate:generate --tables="table1,table2,table3,table4,table5" --env=local 
#Generate Module==========================================================================
composer require pangodream/migbuilder
#behat BDD tool
vendor/bin/behat --init
vendor/bin/behat --append-snippets

#Queue
php artisan queue:work --queue=luck,report --env=local
#測試Server
https://learnku.com/articles/5638/laravel-env-loading-and-source-analysis-of-environment-variables
php -S 0.0.0.0:8000 -t public/
php artisan serve --host 0.0.0.0 --port 8000 --env=local

#Queue==============================================================================
https://mattsuyolo.medium.com/laravel-queue-supervisor-%E9%85%8D%E7%BD%AE-d4d43f2acdd6
https://laracasts.com/discuss/channels/laravel/class-redis-not-found
php artisan app:c-pay dustin1122 --env=local
php artisan queue:work --env=local

psql -h 10.55.112.3 -U postgres


[autoload_routes]==
https://github.com/izniburak/laravel-auto-routes
composer require izniburak/laravel-auto-routes
composer install
php artisan vendor:publish --provider="Buki\AutoRoute\AutoRouteServiceProvider"



