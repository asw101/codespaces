# codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/asw101/codespaces/tree/test?devcontainer_path=.devcontainer%2Feverything%2Fdevcontainer.json)

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

set environment variables

```sh
export RESOURCE_GROUP='240900-linux-postgres'
export SUBSCRIPTION_ID=$(az account show --out json | jq -r '.id')
export TENANT_ID=$(az account show --out json | jq -r '.tenantId')
echo "environment variables set"
```

deploy `vm-postgres.bicep`

```sh
az deployment group create \
    --resource-group 240900-linux-postgres \
    --template-file linux-postgres-migration/deploy/vm-postgres.bicep \
    --parameters deployPostgres=false
```

monitor deployment via azure portal

```sh
PORTAL_URL="https://portal.azure.com/#@${TENANT_ID}/resource/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/deployments"

echo "Monitor deployment via Azure Portal:"
echo "$PORTAL_URL"
```

list resources

```sh
az resource list --resource-group 240900-linux-postgres | jq '.[].id'
```

open resource group in azure portal

```sh
PORTAL_URL="https://portal.azure.com/#@${TENANT_ID}/resource/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/overview"

echo "Open Resource Group in Azure Portal:"
echo "$PORTAL_URL"
```

empty resource group

```sh
az deployment group create \
    --resource-group 240900-linux-postgres \
    --template-file linux-postgres-migration/deploy/empty.bicep \
    --mode Complete
```
