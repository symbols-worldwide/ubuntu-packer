#!/bin/bash

set -e

echo Attempting to preconfigure keyboard-configuration..

cat > /tmp/keyboard-configuration <<_EOF_ 
keyboard-configuration  keyboard-configuration/modelcode        string  pc105
keyboard-configuration  keyboard-configuration/model    select  Generic 105-key PC (intl.)
keyboard-configuration  keyboard-configuration/layout   select  English (UK)
keyboard-configuration  keyboard-configuration/altgr    select  Right Alt (AltGr)
keyboard-configuration  keyboard-configuration/layoutcode       string  gb
keyboard-configuration  keyboard-configuration/ctrl_alt_bksp    boolean false
keyboard-configuration  keyboard-configuration/unsupported_options      boolean true
keyboard-configuration  keyboard-configuration/store_defaults_in_debconf_db     boolean true
keyboard-configuration  console-setup/detect    detect-keyboard
keyboard-configuration  keyboard-configuration/compose  select  Right Logo key
keyboard-configuration  keyboard-configuration/xkb-keymap       select
keyboard-configuration  keyboard-configuration/unsupported_layout       boolean true
keyboard-configuration  keyboard-configuration/variantcode      string
keyboard-configuration  console-setup/detected  note
keyboard-configuration  keyboard-configuration/variant  select  English (UK)
keyboard-configuration  keyboard-configuration/toggle   select  No toggling
keyboard-configuration  keyboard-configuration/unsupported_config_layout        boolean true
keyboard-configuration  keyboard-configuration/switch   select  No temporary switch
keyboard-configuration  keyboard-configuration/optionscode      string  lv3:ralt_switch,compose:rwin
keyboard-configuration  keyboard-configuration/unsupported_config_options       boolean true
keyboard-configuration  console-setup/ask_detect        boolean false
_EOF_

echo Done. Keyboard-configuration settings are:
cat /tmp/keyboard-configuration

apt-get update
debconf-set-selections < /tmp/keyboard-configuration
dpkg-reconfigure keyboard-configuration -f noninteractive
DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold"  install grub-pc
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade
apt-get install -y unzip