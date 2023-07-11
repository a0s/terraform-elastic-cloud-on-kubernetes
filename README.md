# Elastic Cloud on Kubernetes (ECK) for Terraform

This is a direct conversion of the ECK project's kubectl manifests to Terraform using tfk8s.

Original files:

* https://download.elastic.co/downloads/eck/2.8.0/crds.yaml
* https://download.elastic.co/downloads/eck/2.8.0/operator.yaml

## Modifications from original

* Namespace name is extracted as variable `namespace` for potential adjustments.

* Removed creation of namespace inside. It should be created outside of this module. Namespace should have label `name` with their name.  

## Using with CDK for Terraform (CDKTF) 

Add path to module into cdktf.json

```json
{
  "terraformModules": [
    {
      "name": "elastic-cloud-on-kubernetes",
      "source": "../terraform-elastic-cloud-on-kubernetes"
    }
  ]
}
```

Run `cdktf get` to generate content in `.gen`.

Your stack can look like:

```typescript
import {
  ElasticCloudOnKubernetes,
  ElasticCloudOnKubernetesConfig
} from ".gen/modules/elastic-cloud-on-kubernetes"

const eck = new ElasticCloudOnKubernetes(this, "eck", <ElasticCloudOnKubernetesConfig>{
  providers: [config.k8sProvider],
  namespace: config.namespace
})

new Manifest(this, "elasticsearch", <ManifestConfig>{
  provider: config.k8sProvider,
  dependsOn: [eck],
  manifest: {
    apiVersion: "elasticsearch.k8s.elastic.co/v1",
    kind: "Elasticsearch",
    metadata: {
      namespace: config.namespace,
      name: "elasticsearch",
    },
    spec: {
      version: "8.8.2",
      nodeSets: [
        {
          name: "default",
          count: "1",
          config: {
            "node.store.allow_mmap": "false"
          }
        }
      ]
    }
  }
})
```

## Links

* https://github.com/elastic/cloud-on-k8s
* https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html
