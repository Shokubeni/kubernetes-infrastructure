#!/bin/bash


kubectl -n "basic-deployments" exec -it "pod/openvpn-0" /etc/openvpn/setup/newClientCert.sh "ruslan.safin" "18.213.22.224"
kubectl -n "basic-deployments" exec -it "pod/openvpn-0" cat "/etc/openvpn/certs/pki/ruslan.safin.ovpn" > "ruslan.safin.ovpn"