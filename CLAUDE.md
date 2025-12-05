# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Build
make build              # Build binary to bin/echo-server
make package            # Run go mod tidy

# Run
go run cmd/server/main.go    # Start server on :8080
make docker-run              # Run in Docker container

# Test
make test               # Run tests with coverage (opens HTML report)
go test ./...           # Run tests without coverage report

# Docker
make docker-build       # Build Docker image
make docker-push        # Build and push to registry

# Swagger
make swagger            # Regenerate Swagger docs (requires swag)

# Quick test endpoint
make curl-ping          # Test /ping endpoint
```

## Architecture

This is a simple HTTP Echo server built with:
- **Echo v4** - Web framework
- **Uber fx** - Dependency injection framework
- **Swaggo** - Swagger documentation generator

### Code Structure

```
cmd/
├── bootstrap/app.go    # fx app setup, Echo config, lifecycle hooks
└── server/main.go      # Entry point with Swagger annotations

echo/route/http/        # Echo handler (POST /echo - returns request body)
ping/route/http/        # Ping handler (GET /ping - returns "Pong")
docs/                   # Generated Swagger files
```

### Adding New Endpoints

1. Create a handler package under `<domain>/route/http/`
2. Define handler struct with constructor that takes `*echo.Echo` and registers routes
3. Add the handler constructor to `fx.Invoke()` in `cmd/bootstrap/app.go`
4. Add Swagger annotations (godoc comments with `@` tags) above handler methods
5. Run `make swagger` to regenerate docs

### fx Dependency Injection Pattern

The app uses fx for DI. Handlers are registered via `fx.Invoke()` which calls their constructors with the Echo instance. The serve function manages the HTTP server lifecycle via `fx.Lifecycle` hooks.
