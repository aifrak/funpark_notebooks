# Book Examples


## Livebook

If you'd like to experiment in a visual environment, try [Livebook](https://hexdocs.pm/livebook/readme.html)!

![](./images/learn_funx_livebook.png)

1. Start the Livebook container with Docker Compose:
    - ```sh
      docker compose up --detach
      ```
2. Run the local application
    - ```sh
      iex --name learn_funx@host.docker.internal --cookie learn_funx -S mix run
      ```
3. Open `http://localhost:8090/`
4. Experiment!

You can copy Livebook files between your host machine and the container:
```sh
# From host to container
docker cp ./livebooks livebook:/data

# From container to host
docker cp livebook:/data ./livebooks
```

### Troubleshooting Livebook

If needed, you can reset things with:
```sh
docker compose up --detach --remove-orphans --renew-anon-volumes --force-recreate
```

If you use a non-Docker container runtime (like Podman) and run into issues, you may need to update your `/etc/hosts` file to include a local entry for `host.docker.internal`. For example:
```
127.0.0.1 host.docker.internal
```
