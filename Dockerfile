FROM node:20-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev || npm i --omit=dev
COPY app/ ./
EXPOSE 8080
CMD ["npm","start"]
