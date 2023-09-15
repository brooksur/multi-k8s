docker build -t brooksbenson03/multi-client:latest -t brooksbenson03/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t brooksbenson03/multi-server:latest -t brooksbenson03/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t brooksbenson03/multi-worker:latest -t brooksbenson03/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push brooksbenson03/multi-client:latest
docker push brooksbenson03/multi-server:latest
docker push brooksbenson03/multi-worker:latest

docker push brooksbenson03/multi-client:$SHA
docker push brooksbenson03/multi-server:$SHA
docker push brooksbenson03/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=brooksbenson03/multi-server:$SHA
kubectl set image deployments/client-deployment client=brooksbenson03/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=brooksbenson03/multi-worker:$SHA