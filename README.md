# Elastic Cloud on Kubernetes (ECK) for Terraform

This is a direct conversion of the ECK project's kubectl manifests to Terraform using tfk8s.

## Modifications from original

* Namespace name is extracted as variable `namespace` for potential adjustments.

* Removed creation of namespace inside. It should be created outside of this module. Namespace should have label `name` with their name.  

## Source

- https://download.elastic.co/downloads/eck/2.8.0/crds.yaml
- https://download.elastic.co/downloads/eck/2.8.0/operator.yaml

## Links

* https://github.com/elastic/cloud-on-k8s
* https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html
