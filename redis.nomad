job "redis" {
  datacenters = ["default"]
  type = "service"
  priority = 100

  group "redis" {
    count = 1

    task "redis-container" {
      driver = "docker"

      config {
        image = "redis"
        hostname = "alloc${NOMAD_ALLOC_INDEX}"
        port_map {
          redis = 6379
        }
        labels {
          group = "redis"
          task = "redis-container"
        }
      }

      logs {
        max_files = 10
        max_file_size = 10
      }

      service {
        name = "redis"
        port = "redis"

        check {
          type = "tcp"
          port = "redis"
          interval = "15s"
          timeout = "3s"
        }
      }

      resources {
        network {
          port "redis" {
            static = 6379
          }
        }
      }
    }
  }
}
