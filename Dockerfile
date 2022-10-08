## Build
FROM golang:1.19-buster AS build
WORKDIR /build

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY .git ./
COPY .envrc ./
COPY Makefile ./
COPY app ./app
RUN make build/api

## Deploy
FROM gcr.io/distroless/base-debian10

COPY --from=build /build/bin/api /app/api

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/app/api", "-env", "production", "-port", "8080"]
