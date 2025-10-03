SHELL := /bin/bash
NAMESPACE ?= platform
CHART_DIR := deploy/helm/platform
EKS_CLUSTER_NAME ?= platform-eks
AWS_REGION ?= eu-north-1

.PHONY: bootstrap helm-install helm-upgrade helm-uninstall kind-up kind-down kubecontext

bootstrap:
	@echo "Initialize Terraform with dev backend and apply..."
	cd infra/terraform && terraform init -backend-config=envs/dev/backend.tfvars && \
	( terraform workspace new dev || terraform workspace select dev ) && \
	terraform apply -var-file=envs/dev/terraform.tfvars

helm-install:
	helm upgrade --install $(NAMESPACE) $(CHART_DIR) -n $(NAMESPACE) --create-namespace

helm-upgrade:
	helm upgrade $(NAMESPACE) $(CHART_DIR) -n $(NAMESPACE)

helm-uninstall:
	helm uninstall $(NAMESPACE) -n $(NAMESPACE) || true

kind-up:
	kind create cluster --name platform --wait 60s

kind-down:
	kind delete cluster --name platform

kubecontext:
	aws eks update-kubeconfig --name $(EKS_CLUSTER_NAME) --region $(AWS_REGION)
