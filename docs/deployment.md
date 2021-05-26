# Automated workflows (WIP)

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
participant "Jankins" as deployer
participant "ECS?" as runner
end box
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
publisher->builder : return link to publish job view?
publisher->buildStorage : GET web tar 
buildStorage->publisher : return web tar
publisher->hostStorage : untar and sync files
```

## Backstage backend components

```plantuml

cloud "AWS\n"{
  component "PostgreSQL" as postgresql
  package container as "Backstage backend container"{
    [Catalog]
    [TechDocs]
  } 
  [S3]
  [Catalog] --> [postgresql] : read write
  [TechDocs] --> [S3] : read 
  REST - container
}

cloud "GitHub\n" {
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
cloud "AWS\n" {
  package "Backstage backend container" {
    interface "REST" as BackstageAPI
    BackstageAPI - [Backstage backend container]
  }
}

package "Backstage frontend" {
  [Frontend Auth]
  node "GitHub Plugins\n" {
    [GitHub Pull Requests] 
    [GitHub Actions]
    [GitHub Code Insights]
    [GitHub Security Insights]
  }
  node "Backstage Plugins\n" {
    [Catalog] -up-> BackstageAPI : "read write"
    [TechDocs] --> BackstageAPI : read
  }
}

cloud "GitHub\n" {
  interface "REST" as RepoAPI
  interface "REST" as RepoPrivateAPI
  RepoAPI - [Repository (Public)]
  RepoPrivateAPI - [Repository (Private)]
  OAuth - [Identity]
  [Frontend Auth] --> [OAuth]
  [GitHub Pull Requests] --> RepoAPI : read
  [GitHub Actions] --> RepoPrivateAPI : read
  [GitHub Code Insights] --> RepoPrivateAPI : read
  [GitHub Security Insights] --> RepoPrivateAPI : read
}

```




