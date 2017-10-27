job "fabio" {
  datacenters = ["default"]
  type = "system"
  priority = 100

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {

    task "fabio-container" {
      driver = "docker"

      config {
        image = "fabiolb/fabio"
        hostname = "alloc${NOMAD_ALLOC_INDEX}"
        port_map {
          http = 8080
          ui = 9998
        }
        labels {
          job = "fabio"
          group = "fabio"
          task = "fabio-container"
        }
      }

      logs {
        max_files = 10
        max_file_size = 10
      }

      resources {
        memory = 512
        network {
          port "http" {
            static = 8080
          }
          port "ui" {
            static = 9998
          }
        }
      }
      env {
        FABIO_REGISTRY_CONSUL_ADDR = "172.17.0.1:8500"
        FABIO_REGISTRY_CONSUL_TAGPREFIX = "contextPath="
        FABIO_PROXY_ADDR = ":8080"
        FABIO_UI_ADDR = ":9998"
      }
    }
  }
}
