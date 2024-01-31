use clap::Parser;
use dotfiles_utils::{
    cli::WaifuFetchArgs,
    fetch::{
        arg_exit, arg_waifu, arg_wallpaper, arg_wallpaper_ascii, create_fastfetch_config,
        show_wallpaper_ascii,
    },
};
use execute::Execute;
use signal_hook::{
    consts::{SIGINT, SIGUSR2},
    iterator::Signals,
};
use std::{
    io::{self, Write},
    thread,
    time::Duration,
};

fn wfetch(args: &WaifuFetchArgs) {
    let config_jsonc = "/tmp/wfetch.jsonc";
    create_fastfetch_config(args, config_jsonc);

    let mut fastfetch =
        execute::command_args!("fastfetch", "--hide-cursor", "--config", config_jsonc);

    if arg_wallpaper_ascii(args) {
        show_wallpaper_ascii(args, &mut fastfetch);
    } else {
        fastfetch
            .execute_output()
            .expect("failed to execute fastfetch");
    }
}

fn main() {
    let args = WaifuFetchArgs::parse();

    // clear screen
    print!("\x1B[2J\x1B[1;1H");
    io::stdout().flush().expect("Failed to flush stdout");

    // initial display of wfetch
    wfetch(&args);

    // not showing waifu / wallpaper, no need to wait for signal
    if arg_exit(&args)
        || (!arg_waifu(&args) && !arg_wallpaper(&args) && !arg_wallpaper_ascii(&args))
    {
        std::process::exit(0);
    }

    // hide terminal cursor
    print!("\x1B[?25l");
    io::stdout().flush().expect("Failed to flush stdout");

    // handle SIGUSR2 to update colors
    // https://rust-cli.github.io/book/in-depth/signals.html#handling-other-types-of-signals
    let mut signals = Signals::new([SIGINT, SIGUSR2]).expect("failed to register signals");

    thread::spawn(move || {
        for sig in signals.forever() {
            match sig {
                SIGINT => {
                    // restore terminal cursor
                    print!("\x1B[?25h");
                    io::stdout().flush().expect("Failed to flush stdout");
                    std::process::exit(0);
                }
                SIGUSR2 => {
                    wfetch(&args);
                }
                _ => unreachable!(),
            }
        }
    });

    loop {
        thread::sleep(Duration::from_millis(200));
    }
}