// The Swift Programming Language
// https://docs.swift.org/swift-book

func getSecret() -> String {
    let CharArr: [Character] = ["t", "h", "i", "s", " ", "i", "s", " ", "t", "h", "e", " ", "s", "e", "c", "r", "e", "t", " ", "i", "n", " ", "S", "w", "i", "f", "t", " ", ":", " ", "4", "8", "8", "f", "a", "f", "f", "c", "b", "0", "4", "8", "1", "6", "b", "9"] 

    let newStr = String(CharArr) 
    return newStr
}
if(CommandLine.arguments.count == 2){
    if (CommandLine.arguments[1] == "spoil"){
        print(getSecret())
    } else {
        if (CommandLine.arguments[1] == getSecret()){
            print("This is correct! Congrats!");
        }else{
            print("This is incorrect. Try again");
        }
    }
} else if (CommandLine.arguments.count==1) {
    print("Welcome to the wrongsecrets Swift binary which hides a secret.");
    print("Use args spoil or a string to guess the password.");
} else {
    print("Too many arguments supplied.");
}

