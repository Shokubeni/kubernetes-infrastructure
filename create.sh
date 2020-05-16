#!/bin/bash


kubectl -n "network-services" exec -it "pod/openvpn-0" /etc/openvpn/setup/newClientCert.sh "ruslan.safin" "3.208.146.99"
kubectl -n "network-services" exec -it "pod/openvpn-0" cat "/etc/openvpn/certs/pki/ruslan.safin.ovpn" > "ruslan.safin.ovpn"