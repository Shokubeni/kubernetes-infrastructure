#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME> <NAMESPACE>"
  exit
fi

KEY_NAME=$1
NAMESPACE=$2
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn" -o jsonpath='{.items[0].metadata.name}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/revokeClientCert.sh "$KEY_NAME"