docker build -t brooksbenson03/multi-client -f ./client/Dockerfile ./client
docker build -t brooksbenson03/multi-server -f ./server/Dockerfile ./server
docker build -t brooksbenson03/multi-worker -f ./worker/Dockerfile ./worker
docker push brooksbenson03/multi-client
docker push brooksbenson03/multi-server
docker push brooksbenson03/multi-worker
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=brooksbenson03/multi-server
kubectl set image deployments/client-deployment client=brooksbenson03/multi-client
kubectl set image deployments/worker-deployment worker=brooksbenson03/multi-worker