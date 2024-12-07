#!/usr/bin/env fish

# ln -s <this_file> ~/.config/fish/conf.d/from_git_dotfiles.fish
# or in ~/.config/fish/config.fish
# source <this_file>

# Without --global, they'll be universal, and
# will persist in ~/.config/fish/fish_variables after they are removed here
abbr --add --global cp "cp --interactive"  # confirm if overwriting
abbr --add --global g 'git'
abbr --add --global gs 'git status'
abbr --add --global c 'code .'
abbr --add --global s 'smerge .'
abbr --add --global l 'ls -CF'
abbr --add --global mv "mv --interactive"  # confirm if overwriting
abbr --add --global v 'vim'
abbr --add --global vi 'vim'
function ntfy
	curl -X POST -d hey ntfy.sh/yanspublic
end

#------------------
# Homebrew on Linux
#------------------
if [ -d /home/linuxbrew/.linuxbrew ]
	# eval (SHELL=fish /home/linuxbrew/.linuxbrew/bin/brew shellenv) is too slow!
	set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
	set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
	set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
	set -q PATH; or set PATH ''; set -gx PATH "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $PATH;
	set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH;
	set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH;
end

#------------------
# Environment specific
#------------------

function _is_wsl1
	string match --quiet '*Microsoft' < /proc/sys/kernel/osrelease
end
function _is_wsl2
	string match --quiet '*-WSL2' < /proc/sys/kernel/osrelease
end
function _is_dell
	string match --quiet '*F1G*' < /proc/sys/kernel/hostname
end

if _is_dell
	set -gx OKTA_USERNAME 'yan.wu'
	set -gx OKTA_MFA_OPTION 'google'

	function _source_creds
		sed -E 's/^export (\w+)=(.*)$/set -gx \1 \2/' /tmp/creds.txt | source
	end
	function auth
		if [ -f /tmp/creds.txt ]; rm /tmp/creds.txt; end
		set --erase AWS_REGION
		authenticate --format sh $argv
		_source_creds
	end
	if [ -f /tmp/creds.txt ]; _source_creds; end

	if _is_wsl1
		set --export DOCKER_HOST 'tcp://localhost:2375'
		abbr --add --global p 'powershell.exe'
		abbr --add --global c 'powershell.exe code .'
		abbr --add --global e 'explorer.exe .'
		abbr --add --global s 'smerge.exe .'
		abbr --add --global gb '/c/Program\ Files/Git/bin/bash.exe'
		abbr --add --global g 'git.exe'
		abbr --add --global gs 'git.exe status'
		abbr --add --global gh 'gh.exe'
	end
end
