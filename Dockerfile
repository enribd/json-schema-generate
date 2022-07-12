FROM golang:1.18-alpine3.16 as modules
COPY go.mod go.sum /modules/
WORKDIR /modules
RUN go mod download

FROM golang:1.18-alpine3.16 as builder
COPY --from=modules /go/pkg /go/pkg
WORKDIR /app
COPY . /app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -v -o schema-generate ./cmd/schema-generate

FROM scratch
COPY --from=builder /app/schema-generate /schema-generate
ENTRYPOINT ["/schema-generate"]
