job "mongodb" {
  datacenters = ["default"]
  type = "service"
  priority = 100

  group "mongodb" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }

    task "mongodb-container" {
      driver = "docker"

      config {
        image = "mongo:3.4"
        hostname = "alloc${NOMAD_ALLOC_INDEX}"
        port_map {
          mongodb = 27017
        }
        labels {
          group = "mongodb"
          task = "mongodb-container"
        }
        command = "mongod"
        args = [
          "--dbpath",
          "${NOMAD_ALLOC_DIR}/data"
        ]
      }

      logs {
        max_files = 10
        max_file_size = 10
      }

      service {
        name = "mongodb"
        port = "mongodb"

        check {
          type     = "tcp"
          port     = "mongodb"
          interval = "15s"
          timeout  = "3s"
        }
      }

      resources {
        network {
          port "mongodb" {
            static = 27017
          }
        }
      }
    }
  }
}
