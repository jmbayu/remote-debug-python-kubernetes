docker login  10.1.1.101:5000
# admin 
# regS3cr3tP4ss

docker build -f app1/Dockerfile -t 10.1.1.101:5000/python-debugging-app1:v1.0 app1
docker build -f app2/Dockerfile -t 10.1.1.101:5000/python-debugging-app2:v1.0 app2

docker push 10.1.1.101:5000/python-debugging-app1:v1.0
docker push 10.1.1.101:5000/python-debugging-app2:v1.0

kubectl delete -f deployment.yam
kubectl apply -f deployment.yaml

APP1_POD=$(kubectl get -l=app=app1 pod --output=jsonpath='{.items[0].metadata.name}')
APP2_POD=$(kubectl get -l=app=app2 pod --output=jsonpath='{.items[0].metadata.name}')
./create-debug-container.sh default "$APP1_POD" app1
./create-debug-container.sh default "$APP2_POD" app2


kubectl port-forward "$APP1_POD" 5000 5678 &
kubectl port-forward "$APP2_POD" 5679:5678 &

curl localhost:5000

