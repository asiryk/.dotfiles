function npm --wraps npm
    GITLAB_NPM_TOKEN=(security find-generic-password -a $USER -s gitlab-npm-token -w) command npm $argv
end

# Load Keychain-stored SSH keys into the agent once per login (agent is empty after reboot)
if status is-interactive; and not /usr/bin/ssh-add -l >/dev/null 2>&1
    /usr/bin/ssh-add --apple-load-keychain -q 2>/dev/null
end
