# Building the binary of the App
FROM golang:1.19 AS build
FROM wizio.azurecr.io/sensor-serverless AS wiz-sensor

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky


FROM alpine:3.17.0 as release

WORKDIR /app
COPY --from=wiz-sensor /opt/wiz/sensor /opt/wiz/sensor
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
COPY --from=build  /go/src/tasky/wizexercise.txt .
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]


