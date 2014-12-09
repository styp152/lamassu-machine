#!/bin/sh
mkdir -p data/log
mkdir -p ui/css/fonts
mkdir -p /tmp/lamassu-fonts
rm /tmp/lamassu-fonts/* -rf

echo

if [ ! -d "node_modules" ]; then
    echo "node.js dependencies not yet installed.. installing them now."
    npm install
else
    echo "node_modules folder found. skipping dependency install."
fi

if [ ! -e "/usr/local/bin/jasmine" ]; then
    if [ "$(id -u)" != "0" ]; then
        echo "jasmine.js is used for unit testing. You are not logged in as root, so to install it, you will need to manually run 'sudo npm install -g jasmine'" 
    else
        npm install -g jasmine
    fi
else
    echo "jasmine has already been installed. skipping.."
fi

if [ ! -e "/usr/local/bin/istanbul" ]; then
    if [ "$(id -u)" != "0" ]; then
        echo "istanbul.js is used for unit testing. You are not logged in as root, so to install it, you will need to manually run 'sudo npm install -g istanbul'" 
    else
        npm install -g istanbul 
    fi
else
    echo "istanbul has already been installed. skipping.."
fi

echo "Downloading fonts..."
curl -# -L https://github.com/adobe-fonts/source-sans-pro/archive/2.010R-ro/1.065R-it.zip > /tmp/lamassu-fonts/source-sans-pro.zip
curl -# -L https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip > /tmp/lamassu-fonts/source-code-pro.zip
echo "Installing fonts in lamassu-machine..."
unzip -q /tmp/lamassu-fonts/source-sans-pro.zip -d /tmp/lamassu-fonts
unzip -q /tmp/lamassu-fonts/source-code-pro.zip -d /tmp/lamassu-fonts
cp -rf /tmp/lamassu-fonts/source-sans-pro-*/TTF ui/css/fonts
cp -rf /tmp/lamassu-fonts/source-code-pro-*/TTF ui/css/fonts
echo "Setting up config files..."
cp device_config.sample.json device_config.json
echo "Setting up keys..."
cp data/client.sample.key data/client.key
cp data/client.sample.pem data/client.pem

if [ ! -e "licenses.json" ]; then
    echo
    echo "licenses.json not found. Edit the licenses.sample.json file, and add your API keys manually."
    echo 
fi

echo "Successful installation."
