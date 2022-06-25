/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// guessCmd represents the guess command
var guessCmd = &cobra.Command{
	Use:   "guess",
	Short: "Try to guess the secret embedded in this binary",
	Long: `Try to guess the secret embedded in this binary.
	Return the secret in quotes as an argument 
	(E.g. guess "thisisa secret")`,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 1 {
			if args[0] == Secret {
				fmt.Println("This is correct! Congrats!")
			} else {
				fmt.Println("This is incorrect. Try again")
			}
		} else {
			fmt.Println("Please suppy 1 argument only: the secret in quotes")
		}
	},
}

func init() {
	rootCmd.AddCommand(guessCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// guessCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// guessCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
