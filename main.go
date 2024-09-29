package main

import (
	"fmt"
	"log"
	"os/exec"
	"time"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()
	
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendStatus(200)
	})
	
	app.Get("/:name", func(c *fiber.Ctx) error {
		name := c.Params("name")

		// Call the script with the name argument
		cmd := exec.Command("./script.sh", "selam "+name)

		output, baseerr := cmd.CombinedOutput() // Capture output and error
		if baseerr != nil {
			str := fmt.Sprintf("Error executing script: %v\nOutput: %s\n", baseerr, output)
			return c.Status(500).SendString(str)
		}
		// Wait for 3 seconds
		time.Sleep(3 * time.Second)

		// Return the image
		return c.SendFile("./output.jpeg")
	})

	log.Fatal(app.Listen(":3000"))
}
