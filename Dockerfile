FROM node:22-bookworm-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg ca-certificates python3 && rm -rf /var/lib/apt/lists/*
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
RUN mkdir -p /app/data /app/uploads /app/output
ENV NODE_ENV=production PORT=3456
EXPOSE 3456
CMD ["npm", "start"]
