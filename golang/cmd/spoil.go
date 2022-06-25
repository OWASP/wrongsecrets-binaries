package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// spoilCmd represents the spoil command
var spoilCmd = &cobra.Command{
	Use:   "spoil",
	Short: "Spoils the secret",
	Long:  `Spoils the secret for this challenge.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(Secret)
	},
}

func init() {
	rootCmd.AddCommand(spoilCmd)
}
