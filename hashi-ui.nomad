job "hashi-ui" {
  datacenters = ["default"]
  type = "system"

  update {
    stagger = "60s"
    max_parallel = 1
  }

  group "hashi-ui" {

    task "hashi-ui-container" {
      driver = "docker"

      config {
        image = "jippi/hashi-ui"
        hostname = "alloc${NOMAD_ALLOC_INDEX}"
        force_pull = true
        port_map {
          http = 3000
        }
        labels {
          task = "hashi-ui"
          group = "hashi-ui"
          task = "hashi-ui-container"
        }
      }

      logs {
        max_files = 10
        max_file_size = 10
      }

      service {
        name = "hashi-ui"
        tags = ["contextPath=/hashi-ui"]
        port = "http"

        check {
          type = "tcp"
          port = "http"
          interval = "15s"
          timeout = "3s"
        }
      }

      kill_timeout = "45s"

      resources {
        memory = 32
        network {
          port "http" {
            static = 8000
          }
        }
      }

      env {
        SERVICE_IGNORE = "true"

        CONSUL_ADDR = "172.17.0.1:8500"
        CONSUL_ENABLE = "1"

        NOMAD_ENABLE = "1"
        NOMAD_ADDR = "http://172.17.0.1:4646"
      }
    }
  }
}