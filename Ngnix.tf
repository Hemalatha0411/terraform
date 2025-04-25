Thanks for the update. If the namespace is created but no resources (like pods, services) appear, it usually means the Helm release installed nothing—most likely due to a missing or incorrect configuration in the values.yaml or a mismatch between the Helm chart and cluster permissions.

Let’s troubleshoot and fix this:


---

1. Confirm Helm Chart Installed

Check if the Helm release succeeded:

helm list -n ingress-nginx

If it's not listed, the release might have failed silently.


---

2. Check Terraform Logs

Re-run Terraform with debug logs:

TF_LOG=DEBUG terraform apply

Look for errors like failed CRD installation, failed webhook creation, etc.


---

3. Try Removing the Empty values.yaml (Quick Fix)

If you don’t need custom values yet, try a minimal working version:

Updated helm_release block (no values.yaml)

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.replicaCount"
    value = "2"
  }
}

Then run:

terraform apply


---

4. Verify Pods

After applying, check:

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

You should see the controller pod and a LoadBalancer service.


---

Want me to regenerate a new .zip with this fix applied?

