FROM node:20

WORKDIR /app

# COPY package*.json ./

#
ENV TZ=Africa/Johannesburg

# RUN npm install

COPY . .

RUN ls -la

CMD ["npm", "run", "verifyid"]