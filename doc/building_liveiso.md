# Manually building live ISO

```
docker build -t debian-gsd ./liveiso
docker run --rm --privileged -v $(pwd)/out:/image/out -v gsd-cache:/image/cache -it debian-gsd
 ```
