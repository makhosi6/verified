FROM node:20

WORKDIR /app

# COPY package*.json ./

# RUN npm install

ENV TZ=Africa/Johannesburg

COPY . .

CMD ["ls" , "-la"]

CMD ["npm", "run", "cdn"]