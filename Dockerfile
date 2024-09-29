# Use the official Go image
FROM golang:1.22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code and the script
COPY . .

# Build the Go app
RUN go build -o server .

# Use a minimal image to run the server
FROM alpine:latest

RUN apk add --no-cache bash
RUN apk add --no-cache imagemagick imagemagick-dev libjpeg-turbo-dev font-dejavu

WORKDIR /root/

# Copy the built binary and the script
COPY --from=builder /app/server .
COPY --from=builder /app/script.sh .
COPY --from=builder /app/brody.jpeg .

# Make the script executable
RUN chmod +x script.sh

# Expose the port
EXPOSE 3000

# Command to run the binary
CMD ["./server"]
