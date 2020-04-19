package kubernetes.admission

operations = {"CREATE", "UPDATE"}

deny["Disabling Istio is not allowed"] {
  operations[input.request.operation]
  annotations := get_annotations[_]
  annotations["sidecar.istio.io/inject"] == "false"
}

get_annotations[a] {
  a := input.request.object.metadata.annotations # Pod
}

get_annotations[a] {
  a := input.request.object.spec.template.metadata.annotations # Deployment
}
