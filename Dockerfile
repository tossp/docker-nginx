FROM alpine:edge

LABEL maintainer="TossPig <docker@TossP.com>" \
      version="2.0.2" \
      description="nginx服务"

ENV TIMEZONE Asia/Shanghai

#RUN echo -e "http://mirrors.aliyun.com/alpine/edge/main/\nhttp://mirrors.aliyun.com/alpine/edge/community/" > /etc/apk/repositories
RUN apk update &&  apk upgrade && \ 
	apk add --no-cache tzdata logrotate && \
	apk add --no-cache --virtual web_tools nginx \
	        nginx-mod-http-upstream-fair \
	        nginx-mod-http-vod \
		nginx-mod-rtmp \
	        nginx-mod-http-fancyindex \
		nginx-mod-devel-kit \
		nginx-mod-http-cache-purge \
		nginx-mod-http-echo \
		nginx-mod-http-fancyindex \
		nginx-mod-http-headers-more \
		nginx-mod-http-lua \
		nginx-mod-http-lua-upstream \
		nginx-mod-http-nchan \
		nginx-mod-http-redis2 \
		nginx-mod-http-set-misc \
		nginx-mod-http-shibboleth \
		nginx-mod-http-upload-progress \
		nginx-mod-http-geoip \
		nginx-mod-http-image-filter \
		nginx-mod-http-js \
		nginx-mod-http-perl \
		nginx-mod-http-xslt-filter \
		nginx-mod-mail \				
		nginx-mod-stream \
		nginx-mod-stream-geoip \
		nginx-mod-stream-js && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	mkdir -p /run/nginx && \
	apk del tzdata && \
	rm -rf /var/cache/apk/* && \
	

	echo '#!/bin/sh' > /ENTRYPOINT.sh  && \
	echo 'cp -rf /etc/nginx/* /def_conf' >> /ENTRYPOINT.sh  && \
	echo 'nginx -V' >> /ENTRYPOINT.sh && \
	echo 'nginx -c /conf/nginx.conf -t' >> /ENTRYPOINT.sh && \
	echo 'nginx -c /conf/nginx.conf' >> /ENTRYPOINT.sh && \
	#cat /ENTRYPOINT.sh  && \
	chmod 755 /ENTRYPOINT.sh

VOLUME ["/log","/def_conf","/conf","/hosts","/tsrun"]

EXPOSE 80 443

#ENTRYPOINT ["env"]
#CMD ["cat","/etc/nginx/nginx.conf"]
CMD ["/ENTRYPOINT.sh"]
