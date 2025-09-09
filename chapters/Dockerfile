FROM ghcr.io/livebook-dev/livebook:0.17.1

# Apps configuration
ENV LIVEBOOK_APPS_PATH="/apps"
ENV LIVEBOOK_APPS_PATH_WARMUP="manual"
ENV LIVEBOOK_DEFAULT_MODE=notebook


# Notebooks and files
COPY . /apps

# Cache apps setup at build time
RUN /app/bin/warmup_apps
