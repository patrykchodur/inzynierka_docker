# docker\_inzynierka

## Docker
- to build image run ./docker\_build\_and\_run.sh build
- to run built image run ./docker\_build\_and\_run.sh run
- to kill image run ./docker\_build\_and\_run.sh kill
- to clean image run ./docker\_build\_and\_run.sh clean

## ssh
- to connect to server run `ssh -X gemroc@localhost` and provide password (from
Dockerfile or docker\_build\_and\_run.sh)
- to use different port change first number in docker\_build\_and\_run.sh `-p 22:22` (eg `-p 1234:22`)

