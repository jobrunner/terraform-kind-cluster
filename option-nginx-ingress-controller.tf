data "kubectl_file_documents" "nginx_ingress_manifests" {
  count   = var.enable_ingress && var.ingress_controller == "Nginx" ? 1 : 0
  content = file("${path.module}/manifest/nginx-ingress.yml")
}

resource "kubectl_manifest" "kubectl_apply_ingress" {
  count             = var.enable_ingress && var.ingress_controller == "Nginx" ? length(data.kubectl_file_documents.nginx_ingress_manifests[0].documents) : 0
  yaml_body         = element(data.kubectl_file_documents.nginx_ingress_manifests[0].documents, count.index)
  server_side_apply = true
  depends_on        = [kind_cluster.this]
}
