# Kubernetes

- What is K8s? A system to deploy containerized applications
- Nodes are individual machines (or VM’s) that run containers
- Masters are machines (or VM’s) with a set of programs to manage nodes
- Kubernetes doesn’t build our images. It fetches them from somewhere else.
- Kubernetes (the master) decides where to run each containers - each node can run a dissimilar set of containers
- To deploy something, _we update the desired state of the master with a config file_
- The master works constantly to meet your desired state
- `kubectl apply -f <filename>`: applies an object definition to the cluster
- `kubectl get <kind>`: fetches information on pods of a certain kind
- Imperative deployment: explicitly saying exactly what you want to happen on each state change. Requires a knowledge of the current state.
- Declarative deployment: saying what you want to have happen and then allowing the master to decide how to make that happen. This style of deployment is why kubernetes exists in the first place.
- When applying a configuration file, if there is an existing object with the same name and type, the master will update that existing object. If not, it will create a new object.
- `kubectl describe <object_type> <object_name>`: returns detailed information about the provided object.
- Only certain types of information can change when updating pods. Otherwise an error will be thrown.
- `kubectl delete -f <config file>`: deletes a configuration from a cluster
- `kubectl get pods -o wide`: provides more information as opposed to the standard get
- Every single pod get its own IP inside of a node

### Configuration

- Config files are used to make **\*\*\***objects**\*\*\***
- Each object type has a different purpose
- apiVersion: scopes the set different kinds of objects that can be used
- selector: selects an object in a cluster
  - matchLabels: used to match against another objects label
- spec: property in configuration files that configure the objects
- Pods: An object that can be used to run containers. Groups together containers of very similar purpose.
  - Runs a single set of containers
  - Good for one-ff dev purposes
  - Rarely used directly in production
- Services: An object that sets up networking in a kubernetes cluster. Services have sub types.
  - NodePort: Exposes a container to the outside world. Only good for dev purposes.
  - ClusterIP: Exposes a set of pods to other objects in the cluster
  - label selector system: a system in kubernetes for defining associations between objects. One object defines a label and another selects it.
  - When pods come online or shut down, they are being assigned new IP addresses. If a service is assigned to a pod it will keep track of these changes and make sure that traffic is still being routed to the correct locations
- Deployment: Maintains a set of identical pods, ensuring they have the correct config and that the right number exists
  - Runs a set of identical pods (one or more)
  - Monitors the state of each pod, updating as necessary
  - Good for development and production
  - It’s better to use deployments instead of directly using pods
  - replicas: number of pods for deployment to make
- Persistent Volume Claim: if you are running a pod with postgres, if the postgres container crashes and the data was being stored in the container or pod, the data gets destroyed. This is why you want to set up a volume when using postgres. You want the data to be stored on the host machine.
  - There is a difference between a Persistent Volume and a Persistent Volume Claim. A claim is like request to the master saying hey, the cluster needs a persistent volume with the defined specs. A persistent volume is the actual data store. Depending on where the cluster is running, the data store mechanism may change. By running `kubectl get storageclass`, you can see the different storage providers on the host machine. Without defining the storage class in the persistent volume claim configuration the cluster will use the default option, which is different depending on the host.
  - In the database deployment, you will want to define the persistent volume claim that the database is supposed to use.

### Deployment

- What happens if you want k8s to pull down the latest version of an image for a container?
  - You can manually delete a pod in a deployment and the deployment will recreate the pod
  - You can tag an image with a version and then update the configuration to use that version
  - Use an imperative command to update the image version the deployment should use
    - Tag docker image: `docker build -t brooksbenson03/multi-client:v5 .`
    - Push docker image: `docker push -t brooksbenson03/multi-client:v5`
    - Use kubernetes imperative command: `kubectl set image <object_type>/<object_name> <container_name> = <new image to use>`
