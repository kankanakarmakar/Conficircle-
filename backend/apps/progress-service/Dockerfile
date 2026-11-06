# Multi-stage build. Run Docker builds from the backend/ root,
# which hosts the pnpm workspace.
FROM node:20.18.1-alpine AS build
WORKDIR /workspace
RUN corepack enable
COPY pnpm-workspace.yaml package.json tsconfig.base.json ./
COPY packages ./packages
COPY apps/progress-service ./apps/progress-service
RUN pnpm install --filter=./apps/progress-service
RUN pnpm --filter ./apps/progress-service build

FROM node:20.18.1-alpine
WORKDIR /workspace
ENV NODE_ENV=production
COPY --from=build /workspace /workspace
EXPOSE 3000
CMD ["node", "apps/progress-service/dist/main.js"]
