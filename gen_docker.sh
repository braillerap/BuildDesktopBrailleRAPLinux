# set user / group for writing on shared volume
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)

# build docker image
docker build   --build-arg UID=$HOST_UID --build-arg GID=$HOST_GID -t sgngodin/builddesktopbraillerap .
