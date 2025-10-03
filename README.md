# Platform-in-a-Box (EKS + Terraform + GitHub Actions + Helm)

**Goal:** A realistic, recruitable demo that shows you can provision AWS infra with Terraform, run workloads on EKS with Helm, and ship with GitHub Actions (CI, image build, PR previews, tagged releases).

## What it does
- Provisions **VPC + EKS** (managed node groups) with Terraform (modular, remote state ready).
- Sets up **IRSA** for pod-level IAM roles.
- Deploys a minimal **API** and **Web** app via **Helm** with HPA, probes, and NGINX ingress.
- Adds **Prometheus/Grafana** and **Loki** (optional) for observability.
- **GitHub Actions**: CI for test/lint; build and push images to **GHCR**; PR previews using ephemeral namespaces.

## Repo map
```
infra/
  terraform/
    envs/
      dev/
        backend.tfvars
        terraform.tfvars
    modules/
      eks/
      vpc/
    main.tf
    variables.tf
    outputs.tf
apps/
  api/        # Node.js Express API
  web/        # Minimal React app
deploy/
  helm/
    platform/ # umbrella chart
      Chart.yaml
      values.yaml
      templates/...
.github/
  workflows/
    ci.yml
    cd_release.yml
    pr_preview.yml
k8s/
  ingress/
  monitoring/
Makefile
```

## Quick start
> You need: AWS account, Terraform, kubectl, helm, Docker, and (optional) kind.

1. **Bootstrap infra (dev)**
   ```bash
   cd infra/terraform
   terraform init -backend-config=envs/dev/backend.tfvars
   terraform workspace new dev || terraform workspace select dev
   terraform apply -var-file=envs/dev/terraform.tfvars
   aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME} --region ${AWS_REGION}
   ```

2. **Deploy platform**
   ```bash
   make helm-install
   ```

3. **Local test (no AWS)**
   ```bash
   make kind-up
   make helm-install NAMESPACE=demo
   ```

4. **GitHub Actions**
   - Add repo secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `GHCR_PAT` (or use GITHUB_TOKEN for GHCR), `EKS_CLUSTER_NAME`.
   - CI runs on PRs; images built on pushes to `main` and tags `v*`.
   - PRs create ephemeral namespace `pr-<num>` with app deployment; auto-clean on close.

## Notes
- This is a **template**. Replace module sources with your fork or pin to versions.
- For interviews, point to: Terraform modules, IRSA annotations, Helm values, and Actions workflows.
