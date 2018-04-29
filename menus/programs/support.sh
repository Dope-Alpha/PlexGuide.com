#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

export NCURSES_NO_UTF8_ACS=1
skip=no
## point to variable file for ipv4 and domain.com
domain=$( cat /var/plexguide/server.domain )

HEIGHT=14
WIDTH=37
CHOICE_HEIGHT=8
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Supporting"

OPTIONS=(A "Netdata"
         B "NextCloud"
         C "Ombi"
         D "pyLoad"
         E "Resilio"
         F "SpeedTEST Server"
         G "Tautulli (PlexPy)"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=NETDATA
			bash /opt/plexguide/menus/programs/monitoring.sh
            ;;
        B)
            display=NEXTCloud
            program=nextcloud
            port=4645
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags next &>/dev/null &
            sleep 2 
            cronskip=no
            ;;
        C)
            display=Ombi
            program=ombi
            port=3579
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi &>/dev/null &
            sleep 2
            cronskip=no
            ;;
        D)
            display=pyLoad
            program=pyload
            port=8000
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pyLoad &>/dev/null &
            sleep 2
            cronskip=no
            ;;
        E)
            display=RESILIO
            program=resilio
            port=8888
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio &>/dev/null &
            sleep 2
            cronskip=no
            ;;
        F)
            program=speed
            port=8223
            dialog --infobox "Installing: SpeedTEST Server" 3 38
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags speedtestserver &>/dev/null &
            sleep 2
            cronskip=yes
            ;;
        G)
            display=Tautulli
            program=tautulli
            port=8181
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli &>/dev/null &
            sleep 2
            cronskip=no
            ;;
        Z)
            exit 0 ;;
    esac

########## Cron Job a Program
echo "$program" > /tmp/program_var
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
    bash /opt/plexguide/menus/backup/main.sh
fi 

echo "$program" > /tmp/program
echo "$port" > /tmp/port
#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/support.sh
