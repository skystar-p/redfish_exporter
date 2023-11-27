FROM golang:1.21-bookworm AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o redfish_exporter

# -----

FROM debian:bookworm AS runner

COPY --from=builder /app/redfish_exporter /usr/local/bin/redfish_exporter

CMD ["/usr/local/bin/redfish_exporter", "--config.file", "/etc/prometheus/redfish_exporter.yml"]
