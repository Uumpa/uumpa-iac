#!/usr/bin/env python3
import sys
import json
import subprocess


def main():
    query = json.load(sys.stdin)
    p = subprocess.run(query['script'], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if p.returncode == 0:
        print(json.dumps({"output": p.stdout.decode()}))
    else:
        print(p.stderr.decode().replace("\n", " "))
        exit(p.returncode)


if __name__ == "__main__":
    main()
