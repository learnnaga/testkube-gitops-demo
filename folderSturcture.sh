# Inside your cloned git repo
mkdir -p clusters/{dev,stage,prod}

# Create a simple Nginx deployment for ALL environments
# We start them all at version 1.19
for env in dev stage prod; do
cat <<EOF > clusters/$env/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: simple-app
  template:
    metadata:
      labels:
        app: simple-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: simple-app
  namespace: default
spec:
  selector:
    app: simple-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF
done

git add .
git commit -m "Initial Infrastructure"
git push
