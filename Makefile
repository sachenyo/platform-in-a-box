KIND_CLUSTER?=pib
NAMESPACE?=demo

kind-up:
	kind create cluster --name $(KIND_CLUSTER) || true

kind-down:
	-kind delete cluster --name $(KIND_CLUSTER)

deploy-local: ns ingress metrics app

ns:
	kubectl create ns $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

ingress:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace

metrics:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update
	helm upgrade --install kube-prom-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

app:
	helm upgrade --install platform-in-a-box ./helm/platform-in-a-box -n $(NAMESPACE) -f ./helm/platform-in-a-box/values.local.yaml

status:
	kubectl get pods -A

port-grafana:
	kubectl -n monitoring port-forward svc/kube-prom-stack-grafana 3000:80
