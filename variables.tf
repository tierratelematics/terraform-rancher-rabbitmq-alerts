variable "rancher2_notifier" {
  description = "the URL of the Rancher2 server"
}

variable "rancher2_project" {
  description = "the URL of the Rancher2 server"
}

variable "rabbitmq_node_count" {
  description = "Number of desired nodes running on the cluster"
  type = string
  default = "3"
}

variable "rabbitmq_alarm_time_duration" {
  description = "Time after the alarm is triggered"
  type = string
  default = "5m"
}

variable "rabbitmq_max_unack" {
  description = "Max number of unacked messages"
  type = string
  default = "1000"
}

variable "rabbitmq_max_connections" {
  description = "Max number of connections"
  type = string
  default = "1000"
}

variable "rabbitmq_workload_name" {
  description = "Name of the installed k8s app"
  type = string
  default = "rabbitmq"
}

variable "rabbitmq_queue_consumers" {
  description = "Minimun number of consumer per queue"
  type = string
  default = "0"
}

