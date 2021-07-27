FROM nikolaik/python-nodejs:python3.6-nodejs14

WORKDIR /Pozyx
COPY /Pozyx/requirements.txt /Pozyx/requirements.txt

RUN pip install -r /Pozyx/requirements.txt

WORKDIR /Backend
COPY package.json package-lock.json ./

RUN npm cache clean --force && npm install

COPY . /Backend

EXPOSE 3000 8888

CMD [ "npm", "start" ]
