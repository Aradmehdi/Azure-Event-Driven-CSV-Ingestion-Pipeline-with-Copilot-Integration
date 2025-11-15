cd infra
cat > deploy.sh << 'EOF'
#!/usr/bin/env bash
set -e

# Anpassa dessa vid behov
RG="la-copilot-demo-rg"
LOC="westeurope"
ST="lacopilot$RANDOM"
QUEUE="outqueue"
LAW="la-copilot-law"
AI="la-copilot-ai"

echo "==> Skapar resource group"
az group create -n $RG -l $LOC

echo "==> Skapar Storage account + container + queue"
az storage account create -n $ST -g $RG -l $LOC --sku Standard_LRS
az storage container create --account-name $ST -n incoming --auth-mode login
az storage queue create --account-name $ST -n $QUEUE --auth-mode login

echo "==> Skapar Log Analytics + App Insights"
az monitor log-analytics workspace create -g $RG -n $LAW -l $LOC
LAW_RES_ID=$(az monitor log-analytics workspace show -g $RG -n $LAW --query id -o tsv)

az monitor app-insights component create \
  -g $RG -l $LOC -a $AI --kind web --application-type web \
  --workspace $LAW_RES_ID

echo "==> Klart! Notera värden:"
echo "Resource Group: $RG"
echo "Storage Account: $ST"
echo "Queue: $QUEUE"
echo "Log Analytics workspace: $LAW"
echo "App Insights: $AI"
EOF

chmod +x deploy.sh


