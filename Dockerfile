LABEL version="1.0"
LABEL description="DevOps Coursework - DIET 2"

# Dockerfile contains a multi-stage build process to create a production image with minimal size.
# Step 1: Prepare the application as a `builder`.
# Step 2: Copy all required files. This is a no-dependency build however the package.json would normally
# be included to install all dependencies, including devDevependencies.
FROM        node:24.0.2-alpine as builder
COPY        server.js ./

# Prepare the final image to ensure the least number of layers. This
# aids with faster deployments and allows for the smallest size possible.
FROM        node:24.0.2-alpine as deployable
WORKDIR    /apps/devops-coursework
COPY        --from=builder server.js ./
EXPOSE      8081

CMD         ["node", "server.js"]
