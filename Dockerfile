# Dockerfile contains a multi-stage build process to create a production image with minimal size.
# Step 1: Prepare the application as a `builder`.
# Step 2: Copy all required files. This is a no-dependency build however the package.json would normally
# be included to install all dependencies, including devDevependencies.
FROM        node:24.0.2-alpine as builder
COPY        server.js ./

# Prepare the final image to ensure the least number of layers. This
# aids with faster deployments and allows for the smallest size possible.
FROM        node:24.0.2-alpine as deployable
RUN         mkdir -p /apps/devops-coursework
WORKDIR    /apps/devops-coursework
COPY        --from=builder server.js ./
EXPOSE      3000

CMD         ["node", "server.js"]
