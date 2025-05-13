There are several ways to clone a repository from github. Similar from other providers, such as bitbucket, gitlab, etc.

https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols

Mostly, we use 

- http
- ssh

### Sample clone commands: 
The clone command with protocol `https`

```
git clone https://github.com/kubernetes/kubernetes.git
```

 The clone command with protocol `ssh+git`

```
git clone git@github.com:kubernetes/kubernetes.git
```

### Work with ssh config 

When we are behind proxy, I have to set ssh config (`~/.ssh/config`) with `ProxyCommand` properly, git clone start working with proxy. 

Install `corkscrew` or other proxy tool first. 

#### with this way, we don't need provide username and password each time when clone the repository behind proxy

set ssh config
```
Host github.com
    Hostname github.com
    ServerAliveInterval 55
    ForwardAgent yes
    ProxyCommand /usr/bin/corkscrew <replace_with_your_company_proxy_server> <3128> %h %p
```
#### need write down username and password for your proxy. 
In some company policies, the password need be changed every 90 days, so you need update this configuration file when your proxy password is changed.

```
cat ~/.ssh/myauth
proxyUsername:proxyPassword
```
set ssh config
```
Host github.com
    Hostname github.com
    ServerAliveInterval 55
    ForwardAgent yes
    ProxyCommand /usr/bin/corkscrew <replace_with_your_company_proxy_server> <3128> %h %p ~/.ssh/myauth
```

### Work with http/https 

update ~/.gitconfig

```
[http]
[http "https://github.com"]
	proxy = http://proxyUsername:proxyPassword@proxy.server.com:port
	sslVerify = false
```

`sslVerify` setting is not necessary. 

### Notes: 
**If you only need access github by the way of `ssh+git`, you needn't set any proxy in `~/.gitconfig` and run `git config --global http.proxy ...` and similar commands at all**
