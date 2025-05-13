If you're using GPG (GNU Privacy Guard) behind a proxy and encountering issues—particularly with retrieving keys or interacting with keyservers—here’s how you can configure it properly.

### 🔧 Step-by-Step: Configure GPG to Work Behind a Proxy

#### 1. **Install `dirmngr`**

Ensure you have `dirmngr` installed, as it's required for GPG to communicate with keyservers.

```bash
sudo apt-get install dirmngr
```

#### 2. **Set Proxy Environment Variables**

You can export the proxy settings in your shell session or add them to your shell configuration file (`~/.bashrc` or `~/.zshrc`):

```bash
export http_proxy=http://yourproxy:port
export https_proxy=http://yourproxy:port
```

> Replace `yourproxy` and `port` with your actual proxy address and port number.

#### 3. **Configure `dirmngr.conf`**

Edit (or create) the config file at:

```bash
~/.gnupg/dirmngr.conf
```

Add this line to direct traffic through the proxy:

```bash
http-proxy=http://yourproxy:port
```

#### 4. **Restart `dirmngr`**

To apply changes:

```bash
gpgconf --kill dirmngr
```

Then it will restart automatically when needed.

#### 5. **Test with a Keyserver**

Now try retrieving a public key:

```bash
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys <KEY_ID>
```

You should see the key being fetched if your proxy is configured correctly.

---

If you still face issues, consider:

* Trying a different keyserver (some might not support proxies well).
* Checking firewall/proxy rules for port 11371 (used by HKP).
* Using `--keyserver-options http-proxy` inline with your command:

```bash
gpg --keyserver-options http-proxy=http://yourproxy:port --keyserver hkp://keyserver.ubuntu.com --recv-keys <KEY_ID>
```

Would you like help testing it live or setting this up for a specific OS?
