Dockerized Ubuntu Plex Media Server 
===================================


```bash
docker rm -f plex >/dev/null
docker build -t smj10j/plexmediaserver-ubuntu . && \
    docker run -d --name plex \
    -h smj10j.net \
    -v config:/config \
    -v data:/data \
    -p 32400:32400 \
    smj10j/plexmediaserver-ubuntu
```

- Setup at: [http://192.168.99.100:32400/web/index.html](http://192.168.99.100:32400/web/index.html)