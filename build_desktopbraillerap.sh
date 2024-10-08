Xvfb :99 -screen 0 1024x768x16 &
DISPLAY=:99.0
export DISPLAY

python3 -m venv venv
source ./venv/bin/activate

# checkout last revision
git pull
git checkout $BRANCH_BUILD 



printf "\e[1;34m###########################\e[0m\n"
printf "\e[1;34minstall python dependencies\e[0m\n" 
printf "\e[1;34m###########################\e[0m\n"
pip install -r /home/builduser/DesktopBrailleRAP/requirement_linux.txt

printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mplatform status\e[0m\n" 
printf "\e[1;34m######################\e[0m\n"
printf "python :%s %s\n" $(python --version)
printf "nodejs :%s\n" $(node --version)
printf "npm    :%s\n" $(npm --version)
printf "branch :%s\n" "$BRANCH_BUILD"

rm -r /home/builduser/dist/*

git-changelog -x -s v0.6.0 -f `git tag | tail -n 1`
git-changelog -x -s v0.6.0 -f `git tag | tail -n 1` | gzip > /home/builduser/dist/changelog.gz

printf "writing python linux dependencies\n" 
pip freeze > /home/builduser/dist/requirement_test.txt


# !! delete .gitignore !!
#ls -lah /home/builduser/DesktopBrailleRAP/package/ubuntu/desktopbraillerap-ubuntu/bin/.*
#rm /home/builduser/DesktopBrailleRAP/package/ubuntu/desktopbraillerap-ubuntu/bin/.*

tree  -a /home/builduser/DesktopBrailleRAP/package/ubuntu



#install nodejs depencies
printf "\e[1;34m###########################\e[0m\n"
printf "\e[1;34minstall nodejs dependencies\e[0m\n" 
printf "\e[1;34m###########################\e[0m\n"
npm install

#printf "\e[1;34mBuild debug \e[0m\n"
#npm run builddev
printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mBuild production ready\e[0m\n"
printf "\e[1;34m######################\e[0m\n"
npm run buildubuntu
printf "\e[0mBuild finished\n"

printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mSome useful info\e[0m\n"
printf "\e[1;34m######################\e[0m\n"
ldd --version
ldd /home/builduser/DesktopBrailleRAP/dist/desktopbraillerap-ubuntu
dpkg -S 'libc.so.6'
dpkg -S 'libdl.so.2'
dpkg -S 'libpthread.so.0'
dpkg -S 'libz.so.1'

#npm run buildview
#pyinstaller LinuxDesktopBrailleRAP.spec

 if [ $(find /home/builduser/DesktopBrailleRAP/dist/ -name "desktopbraillerap-ubuntu-*.deb") ];
  then
    #ls -la /home/builduser/AccessBrailleRAP/build/
    #ls -la /home/builduser/AccessBrailleRAP/
    #ls -la /home/builduser/AccessBrailleRAP/dist/
    #cp -r /home/builduser/AccessBrailleRAP/build/* /home/builduser/dist/
    for f in /home/builduser/DesktopBrailleRAP/dist/desktopbraillerap-ubuntu-*.deb
    do
        md5sum $f > $f.md5sum
        sed -i -r "s/ .*\/(.+)/  \1/g" $f.md5sum
    done

    cp -r /home/builduser/DesktopBrailleRAP/dist/* /home/builduser/dist/
    ls -lah /home/builduser/dist/*
    printf "\e[0mCompilation: \e[1;32mSucceeded\n"
    printf "\n"
    printf "####### #    # \n"
    printf "#     # #   #  \n"
    printf "#     # #  #   \n"
    printf "#     # ###    \n"
    printf "#     # #  #   \n"
    printf "#     # #   #  \n"
    printf "####### #    # \n"
    printf "\n" 
  else
    printf "\e[0mCompilation: \e[0;31mFailed\n"
    printf "\n"
    printf "#    # #######\n"
    printf "#   #  #     #\n"
    printf "#  #   #     #\n"
    printf "# ###  #     #\n"
    printf "#  #   #     #\n"
    printf "#   #  #     #\n"
    printf "#    # #######\n"
    printf "\n" 
  fi
