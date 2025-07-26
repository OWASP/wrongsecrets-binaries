use std::env;

fn check_input(guess: String) -> String {
    let secret = get_secret();
    if guess.eq("spoil") {
        return get_secret();
    }
    let correct = guess.eq(&secret);
    get_secret_array(); // Just call the function to not get an unused warning
    if correct {
        "This is correct! Congrats!".to_string()
    } else {
        "This is incorrect. Try again. If the secret contains spaces, make sure to enclose the value in quotes (\' or \").".to_string()
    }
}

fn get_secret() -> String {
    "This is a not very random string posing as a secret in Rust".to_string()
}

fn get_secret_array() -> Vec<char> {
    vec![
        'T', 'h', 'i', 's', ' ', 'i', 's', ' ', 'a', ' ', 'n', 'o', 't', ' ', 'v', 'e', 'r', 'y',
        ' ', 'r', 'a', 'n', 'd', 'o', 'm', ' ', 's', 't', 'r', 'i', 'n', 'g', ' ', 'p', 'o', 's',
        'i', 'n', 'g', ' ', 'a', 's', ' ', 'a', ' ', 's', 'e', 'c', 'r', 'e', 't', ' ', 'i', 'n',
        ' ', 'R', 'u', 's', 't',
    ]
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() == 1 {
        println!("Welcome to the wrongsecrets Rust binary which hides a secret.");
        println!("Use args spoil or a string to guess the password.")
    } else if args.len() == 2 {
        let output = check_input(args[1].to_string());
        println!("{output}")
    } else {
        println!("Too many arguments supplied")
    }
}
