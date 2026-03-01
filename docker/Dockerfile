FROM python:3.12-slim AS builder

WORKDIR /app

ENV PATH=/root/.local/bin:$PATH
RUN pip install pipx && \
    pipx ensurepath && \
    pipx install poetry
RUN apt update && apt install -y git

COPY . .

RUN poetry self add poetry-dynamic-versioning && \
    poetry config virtualenvs.in-project true && \
    poetry install && \
    rm -rf /app/.git


FROM python:3.12-slim as runner

WORKDIR /app

# Install gosu for running as arbitrary uid/gid (Unraid compatibility)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gosu && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/ /app/
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default uid/gid for Unraid (nobody:users = 99:100)
ENV PUID=99
ENV PGID=100

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-i", "/video"]
