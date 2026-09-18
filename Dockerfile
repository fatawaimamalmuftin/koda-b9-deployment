FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM nginx:alpine

RUN apk add --no-cache openssh

RUN adduser -D fatawa

RUN passwd -d fatawa

RUN mkdir -p /home/fatawa/.ssh

COPY id_rsa.pub /home/fatawa/.ssh/authorized_keys

RUN chmod 700 /home/fatawa/.ssh \
    && chmod 600 /home/fatawa/.ssh/authorized_keys \
    && chown -R fatawa:fatawa /home/fatawa/.ssh

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers fatawa" >> /etc/ssh/sshd_config \
    && ssh-keygen -A

EXPOSE 80
EXPOSE 22

CMD ["/bin/sh", "-c", "nginx && exec /usr/sbin/sshd -D -e"]