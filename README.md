# Test deconz-rest-plugin with docker

This builds the deconz-rest-plugin and injects it into a new marthoc/deconz docker image.

How to use it:

```
docker build -t marthoc/deconz:myimage .
```

Then, run it:

```
docker run --rm -it marthoc/deconz:myimage
```
