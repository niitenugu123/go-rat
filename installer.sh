#!/bin/bash
ch() {
chomd +x installer.sh
}

run() {
./installer.sh
}

ch()
run()

# Function to display a message and exit in case of an error
function error_exit {
    echo "Error: $1"
    exit 1
}

# Detect the latest Go version
echo "Fetching the latest Go version..."
LATEST_GO_VERSION=$(curl -s https://go.dev/VERSION?m=text) || error_exit "Failed to fetch the latest Go version."

# Detect system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    armv7l)
        ARCH="armv6l"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    *)
        error_exit "Unsupported architecture: $ARCH"
        ;;
esac

# Detect operating system
OS=$(uname -s)
case $OS in
    Linux)
        OS="linux"
        ;;
    Darwin)
        OS="darwin"
        ;;
    *)
        error_exit "Unsupported operating system: $OS"
        ;;
esac

# Define download URL
DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO_VERSION}.${OS}-${ARCH}.tar.gz"
echo "Downloading Go from $DOWNLOAD_URL..."

# Download and extract Go
curl -OL "$DOWNLOAD_URL" || error_exit "Failed to download Go."
sudo tar -C /usr/local -xzf "${LATEST_GO_VERSION}.${OS}-${ARCH}.tar.gz" || error_exit "Failed to extract Go."

# Set up Go environment variables
echo "Setting up Go environment variables..."
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
export PATH=$PATH:/usr/local/go/bin

# Verify installation
echo "Verifying Go installation..."
if ! go version; then
    error_exit "Go installation failed."
else
    echo "Go successfully installed!"
fi

# Cleanup
echo "Cleaning up..."
rm "${LATEST_GO_VERSION}.${OS}-${ARCH}.tar.gz"

echo "Installation complete. Please restart your terminal or run 'source ~/.profile' to apply the changes."
