resource "kubernetes_manifest" "serviceaccount_elastic_system_elastic_operator" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-operator"
      "namespace" = var.namespace
    }
  }
}

resource "kubernetes_manifest" "secret_elastic_system_elastic_webhook_server_cert" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Secret"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-webhook-server-cert"
      "namespace" = var.namespace
    }
  }
}

resource "kubernetes_manifest" "configmap_elastic_system_elastic_operator" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "eck.yaml" = <<-EOT
      log-verbosity: 0
      metrics-port: 0
      container-registry: docker.elastic.co
      max-concurrent-reconciles: 3
      ca-cert-validity: 8760h
      ca-cert-rotate-before: 24h
      cert-validity: 8760h
      cert-rotate-before: 24h
      exposed-node-labels: [topology.kubernetes.io/.*,failure-domain.beta.kubernetes.io/.*]
      set-default-security-context: auto-detect
      kube-client-timeout: 60s
      elasticsearch-client-timeout: 180s
      disable-telemetry: false
      distribution-channel: all-in-one
      validate-storage-class: true
      enable-webhook: true
      webhook-name: elastic-webhook.k8s.elastic.co
      webhook-port: 9443
      enable-leader-election: true
      elasticsearch-observation-interval: 10s
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-operator"
      "namespace" = var.namespace
    }
  }
}

resource "kubernetes_manifest" "clusterrole_elastic_operator" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-operator"
    }
    "rules" = [
      {
        "apiGroups" = [
          "authorization.k8s.io",
        ]
        "resources" = [
          "subjectaccessreviews",
        ]
        "verbs" = [
          "create",
        ]
      },
      {
        "apiGroups" = [
          "coordination.k8s.io",
        ]
        "resources" = [
          "leases",
        ]
        "verbs" = [
          "create",
        ]
      },
      {
        "apiGroups" = [
          "coordination.k8s.io",
        ]
        "resourceNames" = [
          "elastic-operator-leader",
        ]
        "resources" = [
          "leases",
        ]
        "verbs" = [
          "get",
          "watch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "endpoints",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "events",
          "persistentvolumeclaims",
          "secrets",
          "services",
          "configmaps",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "apps",
        ]
        "resources" = [
          "deployments",
          "statefulsets",
          "daemonsets",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "policy",
        ]
        "resources" = [
          "poddisruptionbudgets",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "elasticsearch.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearches",
          "elasticsearches/status",
          "elasticsearches/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "autoscaling.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearchautoscalers",
          "elasticsearchautoscalers/status",
          "elasticsearchautoscalers/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "kibana.k8s.elastic.co",
        ]
        "resources" = [
          "kibanas",
          "kibanas/status",
          "kibanas/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "apm.k8s.elastic.co",
        ]
        "resources" = [
          "apmservers",
          "apmservers/status",
          "apmservers/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "enterprisesearch.k8s.elastic.co",
        ]
        "resources" = [
          "enterprisesearches",
          "enterprisesearches/status",
          "enterprisesearches/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "beat.k8s.elastic.co",
        ]
        "resources" = [
          "beats",
          "beats/status",
          "beats/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "agent.k8s.elastic.co",
        ]
        "resources" = [
          "agents",
          "agents/status",
          "agents/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "maps.k8s.elastic.co",
        ]
        "resources" = [
          "elasticmapsservers",
          "elasticmapsservers/status",
          "elasticmapsservers/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "stackconfigpolicy.k8s.elastic.co",
        ]
        "resources" = [
          "stackconfigpolicies",
          "stackconfigpolicies/status",
          "stackconfigpolicies/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "logstash.k8s.elastic.co",
        ]
        "resources" = [
          "logstashes",
          "logstashes/status",
          "logstashes/finalizers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "storage.k8s.io",
        ]
        "resources" = [
          "storageclasses",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "admissionregistration.k8s.io",
        ]
        "resources" = [
          "validatingwebhookconfigurations",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "nodes",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_elastic_operator_view" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
        "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
        "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
        "rbac.authorization.k8s.io/aggregate-to-view" = "true"
      }
      "name" = "elastic-operator-view"
    }
    "rules" = [
      {
        "apiGroups" = [
          "elasticsearch.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearches",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "autoscaling.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearchautoscalers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "apm.k8s.elastic.co",
        ]
        "resources" = [
          "apmservers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "kibana.k8s.elastic.co",
        ]
        "resources" = [
          "kibanas",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "enterprisesearch.k8s.elastic.co",
        ]
        "resources" = [
          "enterprisesearches",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "beat.k8s.elastic.co",
        ]
        "resources" = [
          "beats",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "agent.k8s.elastic.co",
        ]
        "resources" = [
          "agents",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "maps.k8s.elastic.co",
        ]
        "resources" = [
          "elasticmapsservers",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "stackconfigpolicy.k8s.elastic.co",
        ]
        "resources" = [
          "stackconfigpolicies",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "logstash.k8s.elastic.co",
        ]
        "resources" = [
          "logstashes",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_elastic_operator_edit" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
        "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
        "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
      }
      "name" = "elastic-operator-edit"
    }
    "rules" = [
      {
        "apiGroups" = [
          "elasticsearch.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearches",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "autoscaling.k8s.elastic.co",
        ]
        "resources" = [
          "elasticsearchautoscalers",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "apm.k8s.elastic.co",
        ]
        "resources" = [
          "apmservers",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "kibana.k8s.elastic.co",
        ]
        "resources" = [
          "kibanas",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "enterprisesearch.k8s.elastic.co",
        ]
        "resources" = [
          "enterprisesearches",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "beat.k8s.elastic.co",
        ]
        "resources" = [
          "beats",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "agent.k8s.elastic.co",
        ]
        "resources" = [
          "agents",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "maps.k8s.elastic.co",
        ]
        "resources" = [
          "elasticmapsservers",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "stackconfigpolicy.k8s.elastic.co",
        ]
        "resources" = [
          "stackconfigpolicies",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "logstash.k8s.elastic.co",
        ]
        "resources" = [
          "logstashes",
        ]
        "verbs" = [
          "create",
          "delete",
          "deletecollection",
          "patch",
          "update",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_elastic_operator" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-operator"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "elastic-operator"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "elastic-operator"
        "namespace" = var.namespace
      },
    ]
  }
}

resource "kubernetes_manifest" "service_elastic_system_elastic_webhook_server" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-webhook-server"
      "namespace" = var.namespace
    }
    "spec" = {
      "ports" = [
        {
          "name" = "https"
          "port" = 443
          "targetPort" = 9443
        },
      ]
      "selector" = {
        "control-plane" = "elastic-operator"
      }
    }
  }
}

resource "kubernetes_manifest" "statefulset_elastic_system_elastic_operator" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "StatefulSet"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-operator"
      "namespace" = var.namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "control-plane" = "elastic-operator"
        }
      }
      "serviceName" = "elastic-operator"
      "template" = {
        "metadata" = {
          "annotations" = {
            "checksum/config" = "f5dd5faf7957b8681c25599dfb9862fa493377fc9a4525517707c7a633411235"
            "co.elastic.logs/raw" = "[{\"type\":\"container\",\"json.keys_under_root\":true,\"paths\":[\"/var/log/containers/*$${data.kubernetes.container.id}.log\"],\"processors\":[{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"error\",\"to\":\"_error\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"_error\",\"to\":\"error.message\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"source\",\"to\":\"_source\"}]}},{\"convert\":{\"mode\":\"rename\",\"ignore_missing\":true,\"fields\":[{\"from\":\"_source\",\"to\":\"event.source\"}]}}]}]"
          }
          "labels" = {
            "control-plane" = "elastic-operator"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "manager",
                "--config=/conf/eck.yaml",
              ]
              "env" = [
                {
                  "name" = "OPERATOR_NAMESPACE"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.namespace"
                    }
                  }
                },
                {
                  "name" = "POD_IP"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "status.podIP"
                    }
                  }
                },
                {
                  "name" = "WEBHOOK_SECRET"
                  "value" = "elastic-webhook-server-cert"
                },
              ]
              "image" = "docker.elastic.co/eck/eck-operator:2.8.0"
              "imagePullPolicy" = "IfNotPresent"
              "name" = "manager"
              "ports" = [
                {
                  "containerPort" = 9443
                  "name" = "https-webhook"
                  "protocol" = "TCP"
                },
              ]
              "resources" = {
                "limits" = {
                  "cpu" = 1
                  "memory" = "1Gi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "150Mi"
                }
              }
              "securityContext" = {
                "allowPrivilegeEscalation" = false
                "capabilities" = {
                  "drop" = [
                    "ALL",
                  ]
                }
                "readOnlyRootFilesystem" = true
                "runAsNonRoot" = true
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/conf"
                  "name" = "conf"
                  "readOnly" = true
                },
                {
                  "mountPath" = "/tmp/k8s-webhook-server/serving-certs"
                  "name" = "cert"
                  "readOnly" = true
                },
              ]
            },
          ]
          "securityContext" = {
            "runAsNonRoot" = true
          }
          "serviceAccountName" = "elastic-operator"
          "terminationGracePeriodSeconds" = 10
          "volumes" = [
            {
              "configMap" = {
                "name" = "elastic-operator"
              }
              "name" = "conf"
            },
            {
              "name" = "cert"
              "secret" = {
                "defaultMode" = 420
                "secretName" = "elastic-webhook-server-cert"
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_elastic_webhook_k8s_elastic_co" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind" = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/version" = "2.8.0"
        "control-plane" = "elastic-operator"
      }
      "name" = "elastic-webhook.k8s.elastic.co"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-agent-k8s-elastic-co-v1alpha1-agent"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-agent-validation-v1alpha1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "agent.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "agents",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-apm-k8s-elastic-co-v1-apmserver"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-apm-validation-v1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "apm.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "apmservers",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-apm-k8s-elastic-co-v1beta1-apmserver"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-apm-validation-v1beta1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "apm.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "apmservers",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-beat-k8s-elastic-co-v1beta1-beat"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-beat-validation-v1beta1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "beat.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "beats",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-enterprisesearch-k8s-elastic-co-v1-enterprisesearch"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-ent-validation-v1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "enterprisesearch.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "enterprisesearches",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-enterprisesearch-k8s-elastic-co-v1beta1-enterprisesearch"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-ent-validation-v1beta1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "enterprisesearch.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "enterprisesearches",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-elasticsearch-k8s-elastic-co-v1-elasticsearch"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-es-validation-v1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "elasticsearch.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "elasticsearches",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-elasticsearch-k8s-elastic-co-v1beta1-elasticsearch"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-es-validation-v1beta1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "elasticsearch.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "elasticsearches",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-ems-k8s-elastic-co-v1alpha1-mapsservers"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-ems-validation-v1alpha1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "maps.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "mapsservers",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-kibana-k8s-elastic-co-v1-kibana"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-kb-validation-v1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "kibana.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "kibanas",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-kibana-k8s-elastic-co-v1beta1-kibana"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-kb-validation-v1beta1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "kibana.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "kibanas",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-autoscaling-k8s-elastic-co-v1alpha1-elasticsearchautoscaler"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-esa-validation-v1alpha1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "autoscaling.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "elasticsearchautoscalers",
            ]
          },
        ]
        "sideEffects" = "None"
      },
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "service" = {
            "name" = "elastic-webhook-server"
            "namespace" = var.namespace
            "path" = "/validate-scp-k8s-elastic-co-v1alpha1-stackconfigpolicies"
          }
        }
        "failurePolicy" = "Ignore"
        "matchPolicy" = "Exact"
        "name" = "elastic-scp-validation-v1alpha1.k8s.elastic.co"
        "rules" = [
          {
            "apiGroups" = [
              "stackconfigpolicy.k8s.elastic.co",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "stackconfigpolicies",
            ]
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}
