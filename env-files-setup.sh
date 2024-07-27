#!/bin/bash

BASE_DIR=`readlink -f $(dirname ${0})`
TF_STATE_FILE=$BASE_DIR/terraform/terraform.tfstate
COGNITIVE_SERVICES_ENDPOINT=$(terraform output -state=$TF_STATE_FILE -raw cognitive_services_endpoint)
COGNITIVE_SERVICES_KEY=$(terraform output -state=$TF_STATE_FILE -raw cognitive_services_key)
DOCUMENT_INTELLIGENCE_MODEL_ID="survey-model"
VM_FQDN=$(terraform output -state=$TF_STATE_FILE -raw vm_dns_name 2> /dev/null) || VM_FQDN="http://localhost:5000/analyze"
if [[ $VM_FQDN == *"localhost"* ]]; then
    VM_FQDN="$VM_FQDN"
else
    # Add HTTPS and append /analyze if its not local
    VM_FQDN="https://${VM_FQDN}/analyze"
fi

cat <<EOL > $BASE_DIR/frontend/.env
VITE_API_URL="$VM_FQDN"
EOL

cat <<EOL > $BASE_DIR/backend/.env
FORM_RECOGNIZER_ENDPOINT="$COGNITIVE_SERVICES_ENDPOINT"
FORM_RECOGNIZER_KEY="$COGNITIVE_SERVICES_KEY"
COGNITIVE_SERVICES_ENDPOINT="$COGNITIVE_SERVICES_ENDPOINT"
COGNITIVE_SERVICES_KEY="$COGNITIVE_SERVICES_KEY"
MODEL_ID="$DOCUMENT_INTELLIGENCE_MODEL_ID"
EOL