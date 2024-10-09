#!/usr/bin/env python3

from typing import TypedDict 
import subprocess
import argparse 
from time import sleep


class Args(TypedDict):
    mode: str


def monitor() -> bool:
    
    result = subprocess.check_output("ps aux | grep aw-server", shell=True, text=True)
    is_server_running = "aw-server/aw-server" in result
    return is_server_running
    

def turn_switch():
    status = monitor()
    if status is False:
        # enable aw-server if no another instance 
        subprocess.call("~/repos/misc/activitywatch/aw-qt", shell=True, text=True, executable="/usr/bin/zsh") 
    else:
        # disable aw-server 
        subprocess.call("killall aw-server && killall aw-awatcher", shell=True, text=True)


def parse_args() -> Args:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-m",
        "--mode",
        default="monitor",
        type=str,
    )
    args = parser.parse_args()

    return {"mode": args.mode}

def main(): 
    args = parse_args()
    mode = args.get("mode", "monitor")
    if mode == "monitor":
        status = monitor()
        if status is False:
            # no any aw-servers running 
            print("󰶐 <span style=\"italic\">Off</span>", flush=True) 
        else:
            print("󰍹 On", flush=True)
    else:
        turn_switch() 


if __name__ == "__main__":
    main()
