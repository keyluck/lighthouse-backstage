# Stage 0 - Set the ssm-parent and ssm-get-parameter as a Docker stage
FROM springload/ssm-parent@sha256:4f97e29ec5726f685c092320bc909e857cf8840677bb9c92d5d8235e3037fc42 as ssm-parent
FROM binxio/ssm-get-parameter@sha256:f41ad114581ab9426606e0001e743c6641919e3f761a121cfd8566ff6c36a373 as ssm-get-parameter

# Stage 1 - Create yarn install skeleton layer
FROM node:14-buster-slim AS packages

WORKDIR /app
COPY package.json yarn.lock ./

COPY packages packages
# COPY plugins plugins

RUN find packages \! -name "package.json" -mindepth 2 -maxdepth 2 -exec rm -rf {} \+

# Stage 2 - Install dependencies and build packages
FROM node:14-buster-slim AS build

WORKDIR /app
COPY --from=packages /app .

RUN yarn install --frozen-lockfile --network-timeout 600000 && rm -rf "$(yarn cache dir)"

COPY . .

RUN yarn tsc
RUN yarn --cwd packages/backend backstage-cli backend:bundle --build-dependencies

# LABEL maintainer=lighthouse

# # Static Labels
# LABEL org.opencontainers.image.authors="leeroy-jenkles@va.gov" \
#       org.opencontainers.image.url="https://github.com/department-of-veterans-affairs/lighthouse-backstage" \
#       org.opencontainers.image.documentation="https://github.com/department-of-veterans-affairs/lighthouse-backstage/README.md" \
#       org.opencontainers.image.vendor="lighthouse" \
#       org.opencontainers.image.title="lighthouse-backstage" \
#       org.opencontainers.image.source="https://github.com/department-of-veterans-affairs/lighthouse-backstage/Dockerfile" \
#       org.opencontainers.image.description="Backstage developer portal for lighthouse project" \
#       gov.va.image.ssm_parent_version="1.4.3" \
#       gov.va.image.ssm_get_parameter_version="0.3.0" \

# Dynamic Labels
# LABEL org.opencontainers.image.created=${BUILD_DATE_TIME} \
#      org.opencontainers.image.version=${VERSION} \
#      gov.va.build.number=${BUILD_NUMBER} \
#      gov.va.build.tool=${BUILD_TOOL}

# Stage 3 - Build the actual backend image and install production dependencies
FROM node:14

WORKDIR /app

# Copy the install dependencies from the build stage and context
COPY --from=build /app/yarn.lock /app/package.json /app/packages/backend/dist/skeleton.tar.gz ./
RUN tar xzf skeleton.tar.gz && rm skeleton.tar.gz

RUN yarn install --frozen-lockfile --production --network-timeout 600000 && rm -rf "$(yarn cache dir)"

# Copy the built packages from the build stage
COPY --from=build /app/packages/backend/dist/bundle.tar.gz .
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

# Copy any other files that we need at runtime
COPY app-config.yaml ./
COPY app-config.production.yaml ./
COPY --from=ssm-parent /usr/bin/ssm-parent /usr/local/bin/
COPY --from=ssm-get-parameter /ssm-get-parameter /usr/local/bin/

# Configs are merged with left-lower right-higher priority
# see https://backstage.io/docs/conf/writing#configuration-files
CMD ["ssm-parent", "--plain-path", "/lighthouse/staging/backstage_backend/ENV", "run", "--", "node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]