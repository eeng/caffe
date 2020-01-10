FROM node:12-alpine

WORKDIR /code

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 4001

CMD [ "npm", "start" ]
