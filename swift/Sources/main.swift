// The Swift Programming Language
// https://docs.swift.org/swift-book
func getSecret() -> String {
    let CharArr: [Character] = ["T", "h", "i", "s", " ", "a", " ", "s", "e", "c", "r", "e", "t"] 

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

