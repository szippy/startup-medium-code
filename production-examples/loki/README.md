Loki Distributed Suggested Prod Config  

# Repo URL: https://grafana.github.io/helm-charts
#helm install --values values.yaml loki grafana/loki-distributed
#helm install --values loki.values.yaml loki grafana/loki --version 6.6.2

Note: 
I have set up a node type that has the label: 
application-type: observability 
if you don't want to do that, remove the following from each of the loki components. 

```  
  nodeSelector:
    application-type: observability
``` 

Chart Info: 

  name             = "loki"
  chart            = "loki"
  repo_url         = "https://grafana.github.io/helm-charts"
  release_name     = "loki"
  namespace        = "loki"
  target_revision = "6.6.2"


You will need to create a corresponding K8s role, and associate the IAM Policies with the role. 

Creating the AWS Role: 

https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html

IAM Role Policy Permissions:
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      loki-bucket-arn
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "loki-bucket-arn/*"
    ]
  }


IAM Assume Role 
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": ${ODICProviderArn}
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${ODICProviderArn}:sub": "system:serviceaccount:observability:loki-service-account"
          }
        }
      }
    ]
}


Bucket Permissions: 
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "<loki-role-arn>"
        },
        "Action" : "s3:ListBucket",
        "Resource" : "<loki-bucket-arn>"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "<loki-role-arn>"
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "<loki-bucket-arn>/*"
      }
    ]

  }


Promtail will be configured to send logs to Loki, but you can also use Alloy, Otel, or the Grafana Agent to send additional logs to Loki 
https://grafana.com/docs/loki/latest/send-data/
