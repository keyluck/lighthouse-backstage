# Automated workflows and infrastructure (WIP)

[![Collaborate on HackMD](https://hackmd.io/LGwdWMlvTOOfyXBzLw9hyg/badge)](https://hackmd.io/LGwdWMlvTOOfyXBzLw9hyg)

*This is a draft and does not represent current state.*

## Application deployment

```plantuml
actor Developer as dev 
box "Internet"
participant "Github Action" as builder
database "GitHub Artifacts" as storage
end box
box VA Network
participant "Jenkins" as deployer
participant "EKS" as runner
end box
dev->builder : merge into main
builder->builder: build container artifact
builder->storage : save container artifact
builder->deployer: POST deploy webhook
deployer->builder : return link to deploy job view?
builder->builder : log deployment watch link
deployer->storage : GET container artifact 
storage->deployer : return container artifact
deployer->runner : deploy container
```

## TechDocs publication 

```plantuml
participant Dispatcher as dispatcher 
box Internet 
participant "Github Action" as builder
database "Github Artifacts" as buildStorage
end box
box VA Network
participant "Jenkins" as publisher
database "S3" as hostStorage
end box
dispatcher->builder : dispatch build publish 
builder->builder: build web artifact (tar)
builder->buildStorage : save web tar
builder->publisher: POST publish webhook
publisher->builder : return link to publish job view
builder->builder : log deployment watch link
publisher->buildStorage : GET web tar 
buildStorage->publisher : return web tar
publisher->hostStorage : untar and sync files
```

#### Jenkins environment variables

| Name                   | Description | 
| --------               | -------      | 
|TECHDOCS_S3_BUCKET_NAME| | 
| AWS_ACCESS_KEY_ID      |AWS IAM user |
| AWS_SECRET_ACCESS_KEY  |              |
| AWS_REGION             |              |

#### Minimum IAM user access policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
            ],
            "Resource": [
                "arn:aws:s3:::TECHDOCS_S3_BUCKET_NAME/*",
                "arn:aws:s3:::TECHDOCS_S3_BUCKET_NAME"
            ]
        }
    ]
}
```

## Backstage backend components

```plantuml
left to right direction
package "Backstage frontend"
cloud "AWS\n"{
  component "PostgreSQL" as postgresql
  package container as "Backstage backend container"{
    [Catalog]
    [TechDocs]
    [GitHub OAuth]
    [Express]
    REST - Express
  } 
  
  [S3]
  [Catalog] --> [postgresql] : read write
  [TechDocs] --> [S3] : read 
  [Backstage frontend] --> REST
}

cloud "GitHub\n" {
  interface "REST" as RepoAPI
  interface "REST" as OrgAPI
  interface "REST" as OAuth
  OrgAPI - [Organization]
  RepoAPI - [Repository]
  OAuth - [User Identity]
  [Catalog] --> OrgAPI : read
  [Catalog] --> RepoAPI : read
  [GitHub OAuth] --> OAuth 
}
```

#### Backstage backend container environment variables 

|Name | Description | Privileges, permissions |
| -------- | -------- | -------- |
|  GITHUB_TOKEN     | GitHub Personal Access Token     | admin:org:read:org, user:read:user     |
|AUTH_GITHUB_CLIENT_ID |GitHub OAuth| |
|AUTH_GITHUB_CLIENT_SECRET| | |
|TECHDOCS_S3_BUCKET_NAME| | |
|AWS_ACCESS_KEY_ID |AWS IAM user | |
|AWS_SECRET_ACCESS_KEY| | |
|AWS_REGION | | |
|POSTGRES_USER |PostgreSQL instance user |SELECT, INSERT, UPDATE, DELETE, TRUNCATE, CREATE, CONNECT |
|POSTGRES_HOST | | |
|POSTGRES_PORT | | |
|POSTGRES_PASSWORD| | |

#### Minimum IAM user policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::TECHDOCS_S3_BUCKET_NAME/*",
                "arn:aws:s3:::TECHDOCS_S3_BUCKET_NAME"
            ]
        }
    ]
}
```

## Backstage frontend components
```plantuml
left to right direction
cloud "AWS\n" {
  package container as "Backstage backend container" {
    interface BackstageAPI as "REST"
    BackstageAPI - [Express]
  }
}

package "Backstage frontend" {
 
  node "GitHub Plugins\n" {
    [GitHub OAuth] --> BackstageAPI 
    [GitHub Pull Requests] 
    [GitHub Actions]
    [GitHub Code Insights]
    [GitHub Security Insights]
  }
  node "Backstage Plugins\n" {
    [Catalog] --> BackstageAPI : "read write"
    [TechDocs] --> BackstageAPI : read
  }
}

cloud "GitHub\n" {
  interface "REST" as RepoAPI
  interface "REST" as OAuth
  RepoAPI - [Repository]
  OAuth - [User Identity]
  [GitHub OAuth] --> [OAuth]
  [GitHub Pull Requests] --> RepoAPI : read
  [GitHub Actions] --> RepoAPI : read
  [GitHub Code Insights] --> RepoAPI : read
  [GitHub Security Insights] --> RepoAPI : read
}
```