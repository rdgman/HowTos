```bash
#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Starting Docker Installation for Ubuntu 22.04 ---"

# 1. Uninstall conflicting packages (if any exist)
echo "--- Removing older Docker versions (if any)... ---"
# Use || true to prevent script exit if packages are not installed
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras || true
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# 2. Set up Docker's APT repository.
echo "--- Setting up Docker APT repository... ---"
# Update apt package index and install prerequisites
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
# Check if key exists before downloading
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg # Previous command might set restrictive permissions
else
    echo "Docker GPG key already exists."
fi

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Install Docker Engine
echo "--- Installing Docker Engine... ---"
sudo apt-get update
# Install the latest version
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Add current user to the 'docker' group
echo "--- Adding current user ($USER) to the 'docker' group... ---"
# Check if group exists, create if not (should exist after install, but good practice)
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
# Add user to group
sudo usermod -aG docker $USER

# 5. Verify installation (optional basic check)
echo "--- Verifying Docker service status... ---"
sudo systemctl status docker --no-pager # Check status without paging

echo ""
echo "--- Docker Installation Complete! ---"
echo ""
echo "IMPORTANT: You must LOG OUT and LOG BACK IN for the group changes to take effect."
echo "Alternatively, you can run 'newgrp docker' in your current terminal session to apply the change temporarily."
echo ""
echo "After logging back in or using 'newgrp docker', test with: docker run hello-world"
echo "To load an image from a tar file: docker load < my_image.tar"
echo "To run a loaded image: docker run <image_name_or_id>"

exit 0
```
