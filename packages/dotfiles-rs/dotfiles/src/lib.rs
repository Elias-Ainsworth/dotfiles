use clap_complete::{generate, Shell};
use cli::ShellCompletion;

pub mod cli;

pub fn generate_completions(
    progname: &str,
    cmd: &mut clap::Command,
    shell_completion: &ShellCompletion,
) {
    match shell_completion {
        ShellCompletion::Bash => generate(Shell::Bash, cmd, progname, &mut std::io::stdout()),
        ShellCompletion::Zsh => generate(Shell::Zsh, cmd, progname, &mut std::io::stdout()),
        ShellCompletion::Fish => generate(Shell::Fish, cmd, progname, &mut std::io::stdout()),
    }
}
