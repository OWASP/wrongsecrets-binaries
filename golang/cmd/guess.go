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
			fmt.Println("Please supply 1 argument only: the secret in quotes")
		}
	},
}

func init() {
	rootCmd.AddCommand(guessCmd)
}
