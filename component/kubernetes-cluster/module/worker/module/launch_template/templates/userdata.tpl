#!/bin/bash -xe

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh --b64-cluster-ca '${cluster_auth}' --apiserver-endpoint '${cluster_endpoint}' --kubelet-extra-args "${kubelet_extra_args}" '${cluster_name}'