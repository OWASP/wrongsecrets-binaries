
String getSecret()
{
    return "this is the secret in dotnet : 5306de5fe92f0f7a";
}

String evalAnswer(String answer)
{
    if (String.Compare(answer, getSecret()) == 0)
    {
        return "This is correct! Congrats!";
    }
    else
    {
        return "This is incorrect. Try again";
    }
}

if (args.Length == 0)
{
    Console.WriteLine("Welcome to the wrongsecrets dotnet binary which hides a secret.");
    Console.WriteLine("Use args spoil or a string to guess the password.");
}
else
{
    if (args[0] == "spoil")
    {
        Console.WriteLine(getSecret());
    }
    else
    {
        Console.WriteLine(evalAnswer(args[0]));
    }
}

