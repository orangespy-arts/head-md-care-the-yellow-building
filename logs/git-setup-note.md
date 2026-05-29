# Git Setup Note

We have 2 computers, 2 people, and 1 GitHub account.

Recommended setup:

- Keep the same GitHub account for both computers.
- Give each computer its own local Git identity.
- Lisa uses Lisa's name and email on Lisa's computer.
- OrangeSpy uses OrangeSpy's name and email on OrangeSpy's computer.
- Both computers can push to the same GitHub account.

This keeps the commit history cleaner and avoids switching names back and forth on one machine.

Branch meaning:

- main is the local branch you work on.
- origin/main is the GitHub-tracking copy on that computer.
- Normally both computers should work on main, not on origin/main.

Clean workflow plan:

1. Before working, run `git status --short --branch` and make sure you are on `main`.
2. Before editing, pull the latest remote changes with `git pull --rebase origin main`.
3. Make your changes, then commit with one clear message.
4. Push with `git push origin main`.
5. If Git says the branch is behind or diverged, pull with rebase first, then push.
6. Keep Lisa's computer using Lisa's Git identity and OrangeSpy's computer using OrangeSpy's Git identity.
7. Use the same GitHub account on both computers, but do not switch identities back and forth on the same machine.
