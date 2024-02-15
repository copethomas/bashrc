#Tom's Custom Bash Profile and Config
#-------------------------------------

# My Personal Defaults
export TERM=xterm
export PAGER=less
export VISUAL=vim
export EDITOR="$VISUAL"

#Custom Bash Settings
export HISTSIZE= #Give me infinite command history!
export HISTFILESIZE=
unset HISTCONTROL 
export IGNOREEOF=10  #Stops me from Pressing Control-D to exit.
#Flushes history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#Custom Alias
alias ll='ls -l'
alias vi='/usr/bin/vim'
alias gpg='gpg2 --require-secmem --no-greeting --openpgp --armor'
alias brc="$EDITOR /home/$USER/bin/custom_bashrc"
alias more=less

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias df='df -h'
alias free='free -m'

#Git Alias
alias gs='git status'

# SSH Agent Stuff
#export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
#export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh

#Path Changes
PATH=$PATH:/home/$USER/go/bin/:/home/$USER/bin/:/home/$USER/.local/bin
export PATH

#Custom Functions

loadkeys() {
   ssh-add -D
   ssh-add -t 24h ~/.ssh/*.key
   ssh-add -l 
}

sshtunnel() {
        if [[ $1 == "-L" ]]
        then
           ssh -a -C -f -N -n -o TCPKeepAlive=true -o ServerAliveInterval=10 $@
           return
        fi
        pgrep -af "ssh -a -C -f -N -n -o"
}

yamlcheck() {
    yamllint $1 | grep -v "line too long"
}

scratch() {
    #scratch is like a mini notepad to quicly jot ideas down.
    SCRATCHFILE=""
    ls -l /dev/shm/${USER}_scratch.* >/dev/null 2>&1
    if [[ $? -eq 0 ]]
    then
        SCRATCHFILE=$(ls /dev/shm/${USER}_scratch.*)
    else
        SCRATCHFILE=$(mktemp /dev/shm/${USER}_scratch.XXXXXXXXXX)
    fi
    $EDITOR $SCRATCHFILE
}

catscratch() {
    ls -l /dev/shm/${USER}_scratch.* >/dev/null 2>&1
    if [[ $? -eq 0 ]]
    then
        cat /dev/shm/${USER}_scratch.*
    else
        echo "catscratch : error : No Scratch File Found"
    fi
}

nice_json() {
    cat $1 | json_reformat
}

#dlm "DownLoad Move" - Moved something recently in your downloads to the current pwd
dlm() {
    TMPFILE="/tmp/toms_dlm.$$.$RANDOM"
    touch $TMPFILE
    chmod 600 $TMPFILE
    trap "rm -f $TMPFILE > /dev/null 2>&1" RETURN
    find /home/$USER/Downloads/ -maxdepth 1 -cmin -5 -type f > $TMPFILE
    while IFS= read -r files <&9
    do
       rfilename=$(basename "$files")
       if [[ -e "${PWD}/$rfilename" ]]
       then
           read -p "$rfilename exists. Please enter a new name: " NEWNAME
           if [[ $NEWNAME == "" ]]
           then
               echo "empty name. Aborting...."
               return
           else
               mv -v -i "$files" "${PWD}/${NEWNAME}"
           fi
       else
           mv -v -i "$files" "${PWD}"
       fi
    done 9< "$TMPFILE"
}

ogui() {
    if [[ "$#" -ne 1 ]] 
    then 
        echo "ogui: Please provide a file to open via the GUI" 
    else
        setsid /usr/bin/xdg-open "$1" >/dev/null 2>&1
        #/usr/local/bin/rifle $1
    fi
}

dnd() {
   if [[ "$1" == "" ]]
   then
       echo "dnd: error : please specify a time period such as '15m' or '1h'"
       return
   fi
   echo "dnd: Enabling Do Not Disturb Mode..."
   sleep 3
   dunstctl close-all
   sleep 3 
   notify-send -u critical "DND Enabled" "Don't forget to change your slack status!"
   sleep 3 
   setsid bash -c "dunstctl set-paused true ; sleep $1 ; dunstctl set-paused false ; notify-send -u critical 'DND Disabled' 'Dont forget to change your slack status!'"
   echo "dnd: done"
}

#Silly notification for long running commands
bonk() {
   notify-send -u critical "Bonk!" "Command Finished"
}
