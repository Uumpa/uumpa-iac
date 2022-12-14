#!/usr/bin/env python3
import os
import sys
import shutil
import subprocess
from glob import glob
from itertools import chain


def iter_repo(path):
    filenames = set()
    for filename in chain(
        glob(f'{path}/**/*', recursive=True),
        glob(f'{path}/**/.*', recursive=True),
        glob(f'{path}/.**/*', recursive=True),
        glob(f'{path}/.**/.*', recursive=True)
    ):
        if os.path.isdir(filename):
            continue
        filename = filename.replace(path, '').lstrip('/')
        if filename.startswith('.git/'):
            continue
        if filename not in filenames:
            filenames.add(filename)
            yield filename


def git_commit(path, message):
    p = subprocess.run([
        'git', 'commit', '-m', message
    ], cwd=path, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if p.returncode != 0:
        if 'nothing to commit, working tree clean' in p.stdout.decode():
            return False
        else:
            raise Exception(f'git commit failed: {p.stdout.decode()}')
    else:
        return True


def main(*args):
    is_gamal = '--gamal' in args
    repo_name = 'gamal' if is_gamal else 'uumpa-iac'
    GITHUB_PATH = f'.data/sync-{repo_name}-github'
    AZURE_PATH = f'.data/sync-{repo_name}-azure'
    shutil.rmtree(GITHUB_PATH, ignore_errors=True)
    shutil.rmtree(AZURE_PATH, ignore_errors=True)
    subprocess.check_call([
        'git', 'clone', '--depth', '1', '--branch', 'main',
        f'git@github.com:Uumpa/{repo_name}.git', GITHUB_PATH
    ])
    subprocess.check_call([
        'git', 'clone', '--depth', '1', '--branch', 'main',
        f'git@ssh.dev.azure.com:v3/uumpa/uumpa/{repo_name}', AZURE_PATH
    ])
    print("Clearing GitHub repo...")
    for filename in iter_repo(GITHUB_PATH):
        os.remove(os.path.join(GITHUB_PATH, filename))
    print("Copying files...")
    for filename in iter_repo(AZURE_PATH):
        os.makedirs(os.path.dirname(os.path.join(GITHUB_PATH, filename)), exist_ok=True)
        shutil.copyfile(os.path.join(AZURE_PATH, filename), os.path.join(GITHUB_PATH, filename))
    print("Committing to GitHub...")
    subprocess.check_call(['git', 'add', '-A'], cwd=GITHUB_PATH)
    if git_commit(GITHUB_PATH, 'Sync from Azure DevOps repository'):
        subprocess.check_call(
            ['git', 'push'],
            cwd=GITHUB_PATH,
            env={
                **os.environ,
                **({
                    "GIT_SSH_COMMAND": 'ssh -i ~/.ssh/id_rsa_gamal -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
               } if is_gamal else {})
            }
        )
    else:
        print("Nothing to commit.")
    print("OK")


if __name__ == "__main__":
    main(*sys.argv[1:])
