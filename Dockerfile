FROM busybox

ARG ARG_PORT=8007
ARG ARG_TIMEOUT_SEC=10
ENV PORT=${ARG_PORT}
ENV TIMEOUT_SEC=${ARG_TIMEOUT_SEC}

EXPOSE ${ARG_PORT}

CMD ["sh", "-c", "mkfifo fifo && while :; do cat fifo | nc -lk -p ${PORT} -w ${TIMEOUT_SEC} >fifo 2>/dev/null; done"]
#CMD ["sh"]
