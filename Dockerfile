# Stage 1: Build
FROM node:20-alpine AS builder

RUN apk add --no-cache git

ARG CACHE_BUST=2026-01-12
RUN git clone --depth 1 https://github.com/open-world-agents/owa-dataset-visualizer /workspace

WORKDIR /workspace
RUN npm ci && npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine
ARG CACHE_BUST
RUN echo "Cache bust: $CACHE_BUST"

COPY --from=builder /workspace/dist /usr/share/nginx/html
COPY --from=builder /workspace/nginx.conf /etc/nginx/conf.d/default.conf

# HuggingFace Spaces uses port 7860
EXPOSE 7860
CMD ["nginx", "-g", "daemon off;"]
