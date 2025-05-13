
You may need to configure a proxy server if you're having trouble cloning 
or fetching from a remote repository or getting an error 
like `unable to access '...' Couldn't resolve host '...'`.

# Configure the proxy 

## One proxy for all http and https repo access

Configure a global proxy if all access to all repos require this proxy

```
git config --global http.proxy http://proxyUsername:proxyPassword@proxy.server.com:port
git config --global https.proxy https://proxyUsername:proxyPassword@proxy.server.com:port
```

## Separate rules for proxies specific to URLs

If you wish to specify that a proxy should be used for just 
some URLs that specify the URL as a git config subsection
using `sectioname.subsectionname.key` notation:

```
git config --global http.http://domain.com.proxy http://proxyUsername:proxyPassword@proxy.server.com:port
git config --global https.https://domain.com.proxy https://proxyUsername:proxyPassword@proxy.server.com:port
```

The above seems strange to me but it seems that the convention must be 
that everything between the first and last dots in `http.http://domain.com.proxy` 
becomes the subsection name. Thus the above commands result in the following 
sections in the global `~/.gitconfig`

```
[http]
[http "http://domain.com"]
	proxy = http://proxyUsername:proxyPassword@proxy.server.com:port
[https "https://domain.com"]
	proxy = https://proxyUsername:proxyPassword@proxy.server.com:port
```

## Handle subsequent SSL protocol errors

If you're still having trouble cloning or fetching and are now getting 
an `unable to access 'https://...': Unknown SSL protocol error in connection to ...:443` then
you may decide to switch off SSL verification for the single operation 
by using the `-c http.sslVerify=false` option

```
git -c http.sslVerify=false clone https://domain.com/path/to/git
```

Once cloned, you may decide set this for just this cloned 
repository's `.git/config` by doing. Notice the absence of the `--global`

```
git config http.sslVerify false
```

# List the currently set proxies and SSL verification

```
git config --global --get http.proxy
git config --global --get https.proxy
git config --get http.sslVerify
```

# Unset a proxy or SSL verification

```
git config --global --unset http.proxy
git config --global --unset https.proxy
git config --unset https.proxy
```
