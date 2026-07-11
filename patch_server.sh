#!/bin/bash
scp -i "/Users/giahyng/server/ninja.pem" src/nro/models/network/MessageSendCollect.java src/nro/models/network/Collector.java src/nro/models/server/ServerManager.java ubuntu@ec2-54-255-161-217.ap-southeast-1.compute.amazonaws.com:/home/ubuntu/nro-server/
ssh -i "/Users/giahyng/server/ninja.pem" ubuntu@ec2-54-255-161-217.ap-southeast-1.compute.amazonaws.com << 'SSH_EOF'
    cd /home/ubuntu/nro-server
    mkdir -p build/nro/models/network build/nro/models/server
    cp MessageSendCollect.java build/nro/models/network/
    cp Collector.java build/nro/models/network/
    cp ServerManager.java build/nro/models/server/
    cd build
    javac -cp ../20.jar nro/models/network/MessageSendCollect.java nro/models/network/Collector.java nro/models/server/ServerManager.java
    jar uf ../20.jar nro/models/network/MessageSendCollect.class nro/models/network/Collector.class nro/models/server/ServerManager.class nro/models/server/ServerManager\$1.class
    cd ..
    docker compose restart nro-app
SSH_EOF
