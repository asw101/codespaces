# codespaces

[![Open in GitHub Codespaces](https://codespaces.new/asw101/codespaces/tree/test?devcontainer_path=.devcontainer%2Feverything%2Fdevcontainer.json)

check azure cli installed

```sh
az --version
```

login to azure cli

```sh {"promptEnv":"always"}
export TENANT_ID='caglobaldemos2504.onmicrosoft.com'
az login --tenant $TENANT_ID
```

clone repo

```sh
git clone https://github.com/Azure-Samples/linux-postgres-migration
```

deploy `vm-postgres.bicep`

```sh
az deployment group create \
    --resource-group 240900-linux-postgres \
    --template-file linux-postgres-migration/deploy/vm-postgres.bicep \
    --parameters deployPostgres=false
```

list resources

```sh
az resource list --resource-group 240900-linux-postgres | jq '.[].id'
```