You will need to create a corresponding K8s role, and associate the IAM Policies with the role. 

Chart Info: 
  name             = "mimir"
  chart            = "mimir-distributed"
  repo_url         = "https://grafana.github.io/helm-charts"
  release_name     = "mimir"
  namespace        = "observability"
  target_revision  = "5.2.3"

mimir-service-account

IAM Role Policy 
statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      mimir-bucket-arn,
      mimir-ruler-bucket-arn
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "mimir-bucket-arn/*",
      "mimir-ruler-bucket-arn/*"
    ]
  }
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
            "${ODICProviderArn}:sub": "system:serviceaccount:observability:mimir-service-account"
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
          "AWS" : "<mimir-role-arn>"
        },
        "Action" : "s3:ListBucket",
        "Resource" : "<mimir-bucket-arn>"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "<mimir-role-arn>"
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "<mimir-bucket-arn>/*",
      }
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "<mimir-role-arn>"
        },
        "Action" : "s3:ListBucket",
        "Resource" : "<mimir-ruler-bucket-arn>"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "<mimir-role-arn>"
        },
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "<mimir-ruler-bucket-arn>/*",
      }
    ]
  }


Either use the Grafana Agent or Otel to send metric data to Mimir as required. 
https://grafana.com/docs/mimir/latest/configure/configure-otel-collector/
