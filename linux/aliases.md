alias
alias ..='cd ..'
alias amazonbackup='s3backup'
alias apt-get='sudo apt-get'
alias name=value
alias name='command'
alias name='command arg1 arg2'
alias name='/path/to/script'
alias name='/path/to/script.pl arg1'
alias c='clear'
alias c='clear'
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias bc='bc -l'
alias sha1='openssl sha1'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist
alias header='curl -I'
alias headerc='curl -I --compress'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
alias update='sudo apt-get update && sudo apt-get upgrade'
alias update='yum update'
alias updatey='yum -y update'
alias root='sudo -i'
alias su='sudo -i'
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias lightyload='sudo /etc/init.d/lighttpd reload'
alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'
alias playavi='mplayer *.avi'
alias vlc='vlc *.avi'
alias dnstop='dnstop -l 5  eth1'
alias vnstat='vnstat -i eth1'
alias iftop='iftop -i eth1'
alias tcpdump='tcpdump -i eth1'
alias ethtool='ethtool eth1'
alias iwconfig='iwconfig wlan0'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
alias reboottomato="ssh admin@192.168.1.1 /sbin/reboot"
alias wget='wget -c'
alias browser=chrome
alias df='df -H'
alias du='du -ch'
alias top='atop'
alias nfsrestart='sync && sleep 2 && /etc/init.d/httpd stop && umount netapp2:/exports/http && sleep 2 && mount -o rw,sync,rsize=32768,wsize=32768,intr,hard,proto=tcp,fsc natapp2:/exports /http/var/www/html &&  /etc/init.d/httpd start'
alias mcdstats='/usr/bin/memcached-tool 10.10.27.11:11211 stats'
alias mcdshow='/usr/bin/memcached-tool 10.10.27.11:11211 display'
alias flushmcd='echo "flush_all" | nc 10.10.27.11 11211'

alias apt-update="sudo apt update"
alias apt-upgrade="sudo apt upgrade -y"
alias apt-full-upgrade="sudo apt full-upgrade -y"
alias apt-install="sudo apt install"
alias apt-remove="sudo apt remove"
alias apt-purge="sudo apt purge"
alias apt-clean="sudo apt clean"
alias apt-autoremove="sudo apt autoremove -y"
alias apt-search="apt search"
alias apt-show="apt show"
alias apt-list-installed="apt list --installed"
alias apt-depends="apt-cache depends"
alias apt-rdepends="apt-cache rdepends"
alias apt-hold="sudo apt-mark hold"
alias apt-unhold="sudo apt-mark unhold"
alias apt-dry-run="sudo apt upgrade --dry-run"

############################################################################
#                                                                          #
#               ------- Useful Docker Aliases --------                     #
#                                                                          #
#     # Installation :                                                     #
#     copy/paste these lines into your .bashrc or .zshrc file or just      #
#     type the following in your current shell to try it out:              #
#     wget -O - https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/d84ef1741c59e7ab07fb055a70df1830584c6c18/docker-aliases.sh | bash
#                                                                          #
#     # Usage:                                                             #
#     daws <svc> <cmd> <opts> : aws cli in docker with <svc> <cmd> <opts>  #
#     dc             : docker compose                                      #
#     dcu            : docker compose up -d                                #
#     dcd            : docker compose down                                 #
#     dcr            : docker compose run                                  #
#     dex <container>: execute a bash shell inside the RUNNING <container> #
#     di <container> : docker inspect <container>                          #
#     dim            : docker images                                       #
#     dip            : IP addresses of all running containers              #
#     dl <container> : docker logs -f <container>                          #
#     dnames         : names of all running containers                     #
#     dps            : docker ps                                           #
#     dpsa           : docker ps -a                                        #
#     drmc           : remove all exited containers                        #
#     drmid          : remove all dangling images                          #
#     drun <image>   : execute a bash shell in NEW container from <image>  #
#     dsr <container>: stop then remove <container>                        #
#                                                                          #
############################################################################

function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function dl-fn {
	docker logs -f $1
}

function drun-fn {
	docker run -it $1 $2
}

function dcr-fn {
	docker compose run $@
}

function dsr-fn {
	docker stop $1;docker rm $1
}

function drmc-fn {
       docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
       docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
        docker compose $*
}

function d-aws-cli-fn {
    docker run \
           -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
           -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
           -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
           amazon/aws-cli:latest $1 $2 $3
}

alias daws=d-aws-cli-fn
alias dc=dc-fn
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr=dcr-fn
alias dex=dex-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dsr=dsr-fn

extract() { # Extract most know archives with one command
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz) tar xvzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xvf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

mcd() { mkdir -p "$1" && cd "$1"; } # Make directory and change to it

settitle() { # Set the terminal title
  echo -ne "\033]0;"$*"\007"
}

ipinfo() { # Get IP Address Information
  curl http://ipinfo.io/$1
}

myip() { # Get Your Public IP Address
  curl http://ipecho.net/plain
}

calc() { # Simple calculator
  awk "BEGIN { print $* ; }"
}

speedtest() { # Test Internet speed using speedtest_cli
  if command -v speedtest-cli > /dev/null; then
    speedtest-cli
  else
    echo "Please install speedtest-cli first."
  fi
}

# --- Network Troubleshooting ---
lookup() { # DNS lookup
  nslookup $1 | awk '/^Address: / { print $2; exit }'
}

portinfo() { # Get info on a port
  curl -s "https://www.speedguide.net/port.php?port=$1" | \
  awk -v port="$1" -F'</?h1>|Port |</?b>|</?p>' \
  '/Port [0-9]+/ { getline

; getline; print port": "$5 }'
}

# --- Quick Text Operations ---
lower() { # Convert text to lowercase
  tr 'A-Z' 'a-z'
}

upper() { # Convert text to uppercase
  tr 'a-z' 'A-Z'
}

strip() { # Remove spaces and tabs from text
  tr -d '\t '
}

# --- Text Information ---
wordcount() { # Count words in text
  wc -w
}

charcount() { # Count characters in text
  wc -c
}

# --- File Operations ---
backup() { # Backup a file
  cp $1{,.$(date +%F_%R).bak}
}

# --- Git ---
git_cleanup() { # Clean up Git branches
  git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
}

git_purge() { # Purge all local branches that are fully merged in the remote repository
  git branch --merged | egrep -v "(^\*|master|dev)" | xargs -I % git push origin --delete %
}

# --- Disk Space ---
largedir() { # List 10 largest directories
  du -hs * | sort -rh | head -10
}

largefile() { # List 10 largest files
  find . -type f -exec du -h {} + | sort -rh | head -10
}

# Show all processes with full formatting
alias psg='ps -ef'

# Show processes sorted by memory usage
alias psmem="ps aux --sort=-%mem | head -n 20"

# Show processes sorted by CPU usage
alias pscpu="ps aux --sort=-%cpu | head -n 20"

# Show process tree
alias pstree='pstree -p -A'

# Show PID, command, CPU, MEM and start time
alias psproc="ps -eo pid,ppid,user,cmd,%mem,%cpu,start_time --sort=-%cpu"

# Show PID, nice value, priority and CPU time
alias psnice="ps -eo pid,ni,pri,etime,%cpu,cmd --sort=ni"

# Show only root processes
alias psroot="ps -U root -u root u"

# Show all threads
alias psthreads="ps -eLf"

# Show TTY-associated processes (usually interactive)
alias pstty="ps -t $(tty)"

# Show zombie processes
alias pszombie="ps aux | awk '\$8 ~ /Z/ { print }'"

# Show processes run by current user
alias psme='ps -u $USER -f'

# Show parent and child process relationship
alias psfamily="ps -eo pid,ppid,cmd --forest"

# Show detailed memory per process
alias psmemdetail="ps -eo pid,user,%mem,vsz,rss,cmd --sort=-rss | head -n 20"

