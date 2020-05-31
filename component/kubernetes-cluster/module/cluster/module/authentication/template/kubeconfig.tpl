apiVersion: v1
preferences: {}
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${cluster_cert}
    server: ${endpoint_url}
  name: ${cluster_name}
current-context: ${auth_roles[0].username}@${cluster_name}
contexts:
%{~ for i in auth_roles }
- name: ${i.username}@${cluster_name}
  context:
    user: ${i.username}
    cluster: ${cluster_name}
%{~ endfor }
users:
%{~ for i in auth_roles }
- name: ${i.username}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - token
        - -i
        - ${cluster_name}
        - -r
        - ${i.rolearn}
%{~ endfor ~}
