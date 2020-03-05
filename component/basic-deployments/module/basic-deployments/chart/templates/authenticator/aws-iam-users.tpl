%{ for item in iam_access }
- roleARN: ${item.role}
  username: ${item.name}
  groups:
  %{~ for group in item.groups }
  - ${group}
  %{ endfor }
%{ endfor }
