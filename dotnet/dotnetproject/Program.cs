// See https://aka.ms/new-console-template for more information
if(args.Length==0){
    Console.WriteLine("Welcome to the wrongsecrets dotnet binary which hides a secret.");
    Console.WriteLine("Use args spoil or a string to guess the password.");
} else {
    if(args[0] == "spoil"){
        Console.WriteLine("spoil called");
    } else {
        Console.WriteLine(args[0]); 
    }
}


