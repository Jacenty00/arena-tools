#!/bin/bash
# Install Python packages (preferably in your virtual environment):
if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    CURSHELL=zsh
    echo "Currently using zsh."
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
    # assume Bash
    CURSHELL=bash
    echo "Currently using bash."
else
    # assume something else
    echo "Currently only Bash and ZSH are supported for an automatic install. Please refer to the manual installation if you use any other shell."
fi

case $(lsb_release -sc) in
  focal)
    ROS_NAME_VERSION=noetic
    ;;

  bionic)
    ROS_NAME_VERSION=melodic
    ;;

  *)
    echo "Currently only Ubuntu Bionic Beaver and Focal Fossa are supported for an automatic install. Please refer to the manual installation if you use any Linux release or version."
    exit 1
    ;;
esac

# find ros commands
source /opt/ros/${ROS_NAME_VERSION}/setup.bash
# find package arena-tools with roscd
source ../../../devel/setup.bash
# find command workon rosnav
source /usr/local/bin/virtualenvwrapper.sh
workon rosnav

pip3 install pyqt5 numpy pyyaml lxml scikit-image Pillow scikit-image opencv-python matplotlib
pip install PyQt5 --upgrade

# To enable compatibility with arena-rosnav-3d
roscd arena-tools
git clone https://gitlab.com/LIRS_Projects/LIRS-WCT lirs-wct
cd lirs-wct
./deploy.sh
roscd arena-tools
mv ./lirs-wct/lirs_wct_console/build/lirs_wct_console .

# For converting 2D maps to Gazebo worlds we are using [LIRS_WCT] (https://gitlab.com/LIRS_Projects/LIRS-WCT). Please follow their [installation guide] (https://gitlab.com/LIRS_Projects/LIRS-WCT#installation) and place the lirs_wct_console executable inside your arena-tools folder to use this functionality.