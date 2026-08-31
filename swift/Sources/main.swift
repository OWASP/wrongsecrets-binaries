// The Swift Programming Language
// https://docs.swift.org/swift-book

func getSecret() -> String {
    let characters: [Character] = ["T", "h", "i", "s", " ", "a", " ", "s", "e", "c", "r", "e", "t"]
    return String(characters)
}

let arguments = CommandLine.arguments

switch arguments.count {
case 1:
    print("Welcome to the wrongsecrets Swift binary which hides a secret.")
    print("Use args spoil or a string to guess the password.")
case 2:
    let suppliedValue = arguments[1]
    if suppliedValue == "spoil" {
        print(getSecret())
    } else if suppliedValue == getSecret() {
        print("This is correct! Congrats!")
    } else {
        print("This is incorrect. Try again")
    }
default:
    print("Too many arguments supplied.")
}

