FROM node:22.12-alpine AS builder

WORKDIR /app

COPY package.json tsconfig.json ./
COPY index.ts ./

RUN npm install
RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json

ENV NODE_ENV=production

RUN npm install --omit=dev --ignore-scripts

ENTRYPOINT ["node", "dist/index.js"]