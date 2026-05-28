-- YAML snippets: Kubernetes, GitHub Actions, docker-compose.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("k8s_deployment", fmt([[
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {name}
  labels:
    app: {name}
spec:
  replicas: {replicas}
  selector:
    matchLabels:
      app: {name}
  template:
    metadata:
      labels:
        app: {name}
    spec:
      containers:
        - name: {name}
          image: {image}
          ports:
            - containerPort: {port}
]], { name = i(1, "my-app"), replicas = i(2, "1"), image = i(3, "nginx:latest"), port = i(4, "8080") })),

  s("k8s_service", fmt([[
apiVersion: v1
kind: Service
metadata:
  name: {name}
spec:
  type: {type}
  selector:
    app: {name}
  ports:
    - port: {port}
      targetPort: {target}
]], { name = i(1, "my-app"), type = i(2, "ClusterIP"), port = i(3, "80"), target = i(4, "8080") })),

  s("k8s_configmap", fmt([[
apiVersion: v1
kind: ConfigMap
metadata:
  name: {name}
data:
  {key}: |
    {value}
]], { name = i(1, "my-config"), key = i(2, "config.yaml"), value = i(3, "...") })),

  s("k8s_ingress", fmt([[
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {name}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: {host}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {service}
                port:
                  number: {port}
]], { name = i(1, "my-ing"), host = i(2, "example.com"), service = i(3, "my-app"), port = i(4, "80") })),

  s("gha_workflow", fmt([[
name: {name}

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  {jobid}:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      {body}
]], { name = i(1, "CI"), jobid = i(2, "build"), body = i(3, "- name: Run\n        run: echo hi") })),

  s("gha_job", fmt([[
{jobid}:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - name: {step}
      run: {cmd}
]], { jobid = i(1, "build"), step = i(2, "Test"), cmd = i(3, "make test") })),

  s("compose_service", fmt([[
{name}:
  image: {image}
  container_name: {name}
  restart: unless-stopped
  ports:
    - "{port_host}:{port_cont}"
  environment:
    {env_key}: {env_val}
  volumes:
    - {vol_host}:{vol_cont}
]], {
    name = i(1, "app"),
    image = i(2, "nginx:alpine"),
    port_host = i(3, "8080"),
    port_cont = i(4, "80"),
    env_key = i(5, "NODE_ENV"),
    env_val = i(6, "production"),
    vol_host = i(7, "./data"),
    vol_cont = i(8, "/data"),
  })),
}
