FROM nginx
ADD ./apps.conf /etc/nginx/conf.d/apps.conf
RUN mkdir /tools; mkdir /tools/apps; chmod -R 777 /tools
ADD ./dist  /tools/apps
EXPOSE 8030
CMD ["nginx", "-g", "daemon off;"]