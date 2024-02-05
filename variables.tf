variable "cluster_name" {
  description = "Cluster name to create k8s cluster in Docker and set kubeconfig, You can use this cluster name select context with kubectl."
  type        = string
}

variable "node_image" {
  description = "Change base image for kubernetes cluster, This parameter allow you to use local build image."
  type        = string
  default     = "kindest/node"
}

variable "kubernetes_version" {
  description = "Specific kubernetes version to create cluster, Must specific in SemVer version. (Check all supported version -> https://hub.docker.com/r/kindest/node/tags)"
  type        = string
  default     = "1.21.14"
  validation {
    condition     = can(regex("^((([0-9]+)\\.([0-9]+)\\.([0-9]+)(?:-([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?)(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?)$", var.kubernetes_version))
    error_message = "Use SemVer to specific kubernetes version (Check all supported version -> https://hub.docker.com/r/kindest/node/tags)?"
  }
}

variable "nodes" {
  description = "Nodes information to create cluster with control plan and worker. Default is AIO node."
  type = list(object({
    role                   = optional(string)
    kubeadm_config_patches = optional(list(string))
    extra_port_mappings = optional(list(object({
      listen_address = optional(string)
      container_port = optional(string)
      host_port      = optional(string)
      protocol       = optional(string)
    })))
  }))
  default = []
}

variable "enable_loadbalancer" {
  description = "Set to true to enable loadbalance for kind cluster."
  type        = bool
  default     = false
}

variable "enable_ingress" {
  description = "Set to true to enable ingress for kind cluster."
  type        = bool
  default     = false
}

variable "ingress_controller" {
  description = "Select the incress controller."
  type        = string
  default     = "Nginx"
  validation {
    condition     = contains(["Nginx"], var.ingress_controller)
    error_message = "Valid values for var: ingress_controller are (Nginx)."
  }
}

variable "enable_metrics_server" {
  description = "Set to true to install metrics server into cluster."
  type        = bool
  default     = false
}

variable "enable_registry" {
  description = "Set to true to install image registry as docker container."
  type        = bool
  default     = false
}

variable "registry_port" {
  description = "Port of registry container."
  type        = number
  default     = 5000
}

variable "containerd_config_patches" {
  description = "Path config to existing default for containerd."
  type        = list(string)
  default     = []
}
