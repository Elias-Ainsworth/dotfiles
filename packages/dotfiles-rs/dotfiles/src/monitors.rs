use std::collections::HashMap;

use crate::{
    cli::{MonitorExtend, WmMonitorArgs},
    generate_completions,
};
use clap::CommandFactory;
use common::{
    WorkspacesByMonitor,
    nixinfo::{NixInfo, NixMonitorInfo},
    rearranged_workspaces,
    rofi::Rofi,
    wallpaper,
};
use itertools::Itertools;

/// mirrors the current display onto the new display
fn mirror_monitors(new_mon: &str) {
    let nix_monitors = NixInfo::new().monitors;

    let primary = nix_monitors.first().expect("no primary monitor found");

    // mirror the primary to the new one
    hyprland::keyword::Keyword::set(
        "monitor",
        format!("{},preferred,auto,1,mirror,{}", primary.name, new_mon),
    )
    .expect("unable to mirror displays");
}

fn move_workspaces_to_monitors(workspaces: &WorkspacesByMonitor) {
    let is_nstack = hyprland::keyword::Keyword::get("general:layout")
        .expect("unable to get hyprland layout")
        .value
        .to_string()
        .as_str()
        == "nstack";

    for (mon, wksps) in workspaces {
        for wksp in wksps {
            {
                // note it can error if the workspace is empty and hasnt been created yet
                use hyprland::dispatch::{
                    Dispatch, DispatchType, MonitorIdentifier, WorkspaceIdentifier,
                };
                hyprland::dispatch!(
                    MoveWorkspaceToMonitor,
                    WorkspaceIdentifier::Id(*wksp),
                    MonitorIdentifier::Name(&mon.name)
                )
                .ok();

                hyprland::keyword::Keyword::set("workspace", mon.layoutopts(*wksp, is_nstack)).ok();
            }
        }
    }
}

/// distribute the workspaces evenly across all monitors
fn distribute_workspaces(
    extend_type: &MonitorExtend,
    nix_monitors: &[NixMonitorInfo],
) -> WorkspacesByMonitor {
    use hyprland::shared::HyprData;
    let workspaces: Vec<i32> = (1..=10).collect();

    let all_monitors = hyprland::data::Monitors::get().expect("could not get monitors");
    let all_monitors = all_monitors
        .iter()
        // put the nix_monitors first
        .sorted_by_key(|a| {
            let is_base_monitor = nix_monitors.iter().any(|m| m.name == a.name);
            (
                match extend_type {
                    MonitorExtend::Primary => is_base_monitor,
                    MonitorExtend::Secondary => !is_base_monitor,
                },
                a.id,
            )
        })
        .collect_vec();

    let mut start = 0;
    all_monitors
        .iter()
        .enumerate()
        .map(|(i, mon)| {
            let len = workspaces.len() / all_monitors.len()
                + usize::from(i < workspaces.len() % all_monitors.len());
            let end = start + len;
            let wksps = &workspaces[start..end];
            start += len;

            let nixmon = NixMonitorInfo {
                name: mon.name.to_string(),
                width: mon.width,
                height: mon.height,
                transform: mon.transform as u8,
                workspaces: wksps.to_vec(),
            };

            (nixmon, wksps.to_vec())
        })
        .collect()
}

pub fn wm_monitors(args: WmMonitorArgs) {
    // print shell completions
    if let Some(shell) = args.generate {
        return generate_completions("wm-monitors", &mut WmMonitorArgs::command(), &shell);
    }

    let mut mirror = args.mirror;
    let mut extend_type = args.extend;

    // --rofi
    if let Some(new_mon) = args.rofi {
        let choices = ["Extend as Primary", "Extend as Secondary", "Mirror"];

        let (sel, _) = Rofi::new(&choices)
            .arg("-lines")
            .arg(choices.len().to_string())
            .run();

        match sel.as_str() {
            "Extend as Primary" => {
                extend_type = Some(MonitorExtend::Primary);
            }
            "Extend as Secondary" => {
                extend_type = Some(MonitorExtend::Secondary);
            }
            "Mirror" => {
                mirror = Some(new_mon);
            }
            _ => {
                eprintln!("No selection made, exiting...");
                std::process::exit(1);
            }
        }
    }

    // --mirror
    if let Some(new_mon) = mirror {
        mirror_monitors(&new_mon);
    }

    // distribute workspaces per monitor
    let nix_monitors = NixInfo::new().monitors;
    let workspaces = if let Some(extend) = extend_type {
        // --extend
        distribute_workspaces(&extend, &nix_monitors)
    } else {
        use hyprland::shared::HyprData;
        let active_workspaces: HashMap<_, _> = hyprland::data::Monitors::get()
            .expect("could not get monitors")
            .iter()
            .map(|mon| (mon.name.clone(), mon.active_workspace.id))
            .collect();

        rearranged_workspaces(&nix_monitors, &active_workspaces)
    };

    move_workspaces_to_monitors(&workspaces);

    // reload wallpaper
    wallpaper::reload(None);
}
