
String getSecret()
{
    return "This is a dotnet secret, huray.";
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

