job "rabbitmq" {
  datacenters    = ["default"]
  type           = "system"
  priority       = 100

  update {
    stagger      = "5s"
    max_parallel = 1
  }

  group "rabbitmq" {

    task "rabbitmq-container" {
      driver = "docker"

      config {
        image = "aweber/rabbitmq-autocluster"
        network_mode = "host"
        volumes = ["/var/lib/rabbitmq:/home/docker/rabbitmq/data"]
        labels {
          group = "rabbitmq"
          task = "rabbitmq-container"
        }
      }

      logs {
        max_files = 10
        max_file_size = 10
      }

      resources {
        memory = 1024
        network {}
      }
      env {
        RABBITMQ_ERLANG_COOKIE = "wxPGRVTvRJbewas4gsKENy6B"
        AUTOCLUSTER_TYPE = "consul"
        CONSUL_HOST = "172.17.0.1"
        AUTOCLUSTER_DELAY = "60"
      }
    }
  }
}
