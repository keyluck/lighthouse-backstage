# Automated workflows (WIP)

[![Collaborate on HackMD](https://hackmd.io/LGwdWMlvTOOfyXBzLw9hyg/badge)](https://hackmd.io/LGwdWMlvTOOfyXBzLw9hyg)

*This is a draft and does not represent current state.*

## Application deployment

```plantuml
actor Developer as dev 
participant "Github Action" as builder
database "GitHub Artifacts" as storage
participant "Jankins" as deployer
participant "ECS?" as runner
dev->builder : merge into main
builder->builder: build container artifact
builder->storage : save container artifact
builder->deployer: POST deploy webhook
deployer->builder : return link to deploy job view?
builder->dev : notify deployment triggered
deployer->storage : GET container artifact 
storage->deployer : return container artifact
deployer->runner : deploy container
deployer->dev : how are we going to tell them it is done
```

## TechDocs publication 

```plantuml
participant Dispatcher as dispatcher 
participant "Github Action" as builder
database "Github Artifacts" as buildStorage
participant "Jenkins" as publisher
database "S3" as hostStorage
dispatcher->builder : dispatch build publish 
builder->builder: build web artifact (tar)
builder->buildStorage : save web tar
builder->publisher: POST publish webhook
publisher->builder : return link to publish job view?
publisher->buildStorage : GET web tar 
buildStorage->publisher : return web tar
publisher->hostStorage : untar and sync files
```

## Backstage backend components

```plantuml
cloud "AWS"{
  package "Backstage backend container" as backstage
  package backstage {
    [Catalog]
    [TechDocs]
  }
  [S3]
  [Catalog] --> [Postgres Instance] : read write
  [TechDocs] --> [S3] : read 
  REST - backstage
}

cloud "GitHub" {
  interface "REST" as RepoAPI
  interface "REST" as OrgAPI
  OrgAPI - [Organization (Private)]
  RepoAPI - [Repository (Public)]
  [Catalog] --> OrgAPI : read
  [Catalog] --> RepoAPI : read
}
```

## Backstage frontend components
```plantuml
package "Backstage backend container" {
  interface "REST" as BackstageAPI
  BackstageAPI - [BEPlugins]
}

package "Backstage frontend" {
  [Frontend Auth]
  node FEPlugins {
    [GitHub Pull Requests]
    [GitHub Actions]
    [GitHub Code Insights]
    [GitHub Security Insights]
    [Catalog] --> BackstageAPI : "read write"
    [TechDocs] --> BackstageAPI : read
  }
}

cloud "GitHub" {
  interface "REST" as RepoAPI
  interface "REST" as OrgAPI
  interface "REST" as RepoPrivateAPI
  OrgAPI - [Organization (Private)]
  RepoAPI - [Repository (Public)]
  RepoPrivateAPI - [Repository (Private)]
  OAuth - [Identity]
  [Frontend Auth] --> [OAuth]
  [GitHub Pull Requests] --> RepoAPI : read
  [GitHub Actions] --> RepoPrivateAPI : read
  [GitHub Code Insights] --> RepoPrivateAPI : read
  [GitHub Security Insights] --> RepoPrivateAPI : read
  [Catalog] --> OrgAPI : read
}

```