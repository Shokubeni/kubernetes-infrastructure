#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME> <NAMESPACE> <VPN_DOMAIN_NAME>"
  exit
fi

KEY_NAME=$1
NAMESPACE=$2
DOMAIN=$3
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn" -o jsonpath='{.items[0].metadata.name}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$DOMAIN"
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" > "$KEY_NAME.ovpn"