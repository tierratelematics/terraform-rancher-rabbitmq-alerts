resource "rancher2_project_alert_group" "rabbitmq-alert" {
  name = "rabbitmq-alert"
  description = "Alert group for failed rabbitmq"
  project_id = var.rancher2_project.id
  recipients {
    notifier_id = var.rancher2_notifier.id
  }
}

resource "rancher2_project_alert_rule" "rabbit-workload-unavailable" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitWorkloadUnavailable"
  severity = "critical"
  workload_rule {
    available_percentage = "100"
    selector = {"app.kubernetes.io/name" = "$(var.rabbitmq_workload_name)"}
  }
}

resource "rancher2_project_alert_rule" "rabbit-node-down" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitNodeDown"
  severity = "critical"
  metric_rule {
    expression = "sum(rabbitmq_build_info)"
    comparison = "less-than"
    threshold_value = var.rabbitmq_node_count
    duration = var.rabbitmq_alarm_time_duration
  }
}

resource "rancher2_project_alert_rule" "rabbitmq-cluster-partition" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "Rabbitmq Cluster Partition"
  severity = "critical"
  metric_rule {
    expression = "rabbitmq_partitions"
    comparison = "greater-than"
    threshold_value = 0
    duration = var.rabbitmq_alarm_time_duration
  }
}


resource "rancher2_project_alert_rule" "rabbitmq-node-not-distributed" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqNodeNotDistributed"
  severity = "critical"
  metric_rule {
    expression = "erlang_vm_dist_node_state"
    comparison = "less-than"
    threshold_value = var.rabbitmq_node_count
    duration = var.rabbitmq_alarm_time_duration
  }
}

resource "rancher2_project_alert_rule" "rabbitmq-instances-different-versions" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqInstancesDifferentVersions"
  severity = "warning"
  metric_rule {
    expression = "count(count(rabbitmq_build_info) by (rabbitmq_version))"
    comparison = "greater-than"
    threshold_value = 1
    duration = var.rabbitmq_alarm_time_duration
  }
}

resource "rancher2_project_alert_rule" "rabbitmq-memory-high" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqMemoryHigh"
  severity = "warning"
  metric_rule {
    expression = "rabbitmq_process_resident_memory_bytes / rabbitmq_resident_memory_limit_bytes * 100"
    comparison = "greater-than"
    threshold_value = 90
    duration = var.rabbitmq_alarm_time_duration
  }
}

resource "rancher2_project_alert_rule" "rabbitmq-file-descriptors-usage" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqFileDescriptorsUsage"
  severity = "warning"
  metric_rule {
    expression = "rabbitmq_process_open_fds / rabbitmq_process_max_fds * 100"
    comparison = "greater-than"
    threshold_value = 90
    duration = var.rabbitmq_alarm_time_duration
  }
}

resource "rancher2_project_alert_rule" "rabbitmq-too-much-unack" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqTooMuchUnack"
  severity = "warning"
  metric_rule {
    expression = "sum(rabbitmq_queue_messages_unacked) BY (queue)"
    comparison = "greater-than"
    threshold_value = var.rabbitmq_max_unack
    duration = var.rabbitmq_alarm_time_duration
  }
}


resource "rancher2_project_alert_rule" "rabbitmq-too-much-connections" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqTooMuchConnections"
  severity = "warning"
  metric_rule {
    expression = "rabbitmq_connections"
    comparison = "greater-than"
    threshold_value = var.rabbitmq_max_connections
    duration = var.rabbitmq_alarm_time_duration
  }
}


resource "rancher2_project_alert_rule" "rabbitmq-no-queue-consumer" {
  project_id = var.rancher2_project.id
  group_id = rancher2_project_alert_group.rabbitmq-alert.id
  name = "RabbitmqNoQueueConsumer"
  severity = "warning"
  metric_rule {
    expression = "rabbitmq_queue_consumers"
    comparison = "less-than"
    threshold_value = var.rabbitmq_queue_consumers
    duration = var.rabbitmq_alarm_time_duration
  }
}