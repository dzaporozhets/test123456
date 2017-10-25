# gl-sast

GitLab tool for running Static Application Security Testing (SAST) on provided source code

## How to use

```
./bin/run /path/to/source/code

# With Docker
docker run \
  --interactive --tty --rm \
  --volume "$PWD":/app \
  --volume /path/to/source/code:/code \
  ruby:latest /app/bin/run /code
```
