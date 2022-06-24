/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
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

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// spoilCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// spoilCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
