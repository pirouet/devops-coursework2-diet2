# Dockerfile contains a multi-stage build process to create a production image with minimal size. This is a minimal setup
# requiring a handful of files. The base layout of a mulit-stage build is:

# Step 1: Prepare the application as a `builder`.
# Step 2: Copy all required files from `builder` to `production` image.
# Step 3: Expose the port(s) needed to run the application.
FROM        node:24.0.2-alpine AS builder

LABEL version="1.0"
LABEL description="DevOps Coursework - DIET 2"

COPY        server.js ./

# Prepare the final image to ensure the least number of layers. This
# aids with faster deployments and allows for the smallest size possible.
FROM        node:24.0.2-alpine AS deployable
WORKDIR    /apps/devops-coursework
COPY        --from=builder server.js ./
EXPOSE      8081

CMD         ["node", "server.js"]
