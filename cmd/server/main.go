package main

import (
	"context"
	"time"

	"github.com/kenshin579/echo-server/cmd/bootstrap"
	_ "github.com/kenshin579/echo-server/docs"
	"github.com/labstack/gommon/log"
)

// @title Echo API
// @version 1.0
// @description Echo API Server.

// @BasePath /
func main() {
	app := bootstrap.NewApp()

	startCtx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := app.Start(startCtx); err != nil {
		log.Fatal(err)
	}

	<-app.Done()
}
