FROM node:12-alpine

WORKDIR /code

COPY package*.json ./
RUN npm install

COPY . .

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV:-development}

RUN if [ "$NODE_ENV" == "production" ]; then npm run build; fi

CMD [ "npm", "start" ]
