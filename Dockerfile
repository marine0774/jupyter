FROM ubuntu:18.04
MAINTAINER MARINE0774 "junechang.lee@gmail.com"
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL=C.UTF-8
ENV CONTAINER_TIMEZONE Asia/Seoul
RUN apt-get update \
    && apt-get install -y python3 \
    && apt-get install -y python3-pip \
    && pip3 install --upgrade pip \
    && apt-get install -y fontconfig \
    && apt-get install -y ntp
RUN pip install jupyter
RUN pip install pandas
RUN pip install numpy
RUN pip install matplotlib
RUN pip install plotnine
RUN pip install folium
RUN pip install tensorflow 
RUN jupyter notebook --generate-config --allow-root
RUN echo "c = get_config()" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.certfile = '/root/ssl/cert.pem'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.notebook_dir = u'/notebooks'" >> /root/.jupyter/jupyter_notebook_config.py
RUN mkdir -p /root/ssl
ADD ./cert.pem /root/ssl/cert.pem
RUN mkdir /notebooks
RUN mkdir -p /usr/share/fonts/truetype/D2Coding
ADD ./D2Coding.ttf /usr/share/fonts/truetype/D2Coding
ADD ./D2CodingBold.ttf /usr/share/fonts/truetype/D2Coding
RUN chmod -R 755 /notebooks
RUN chmod -R 755 /usr/share/fonts/truetype/D2Coding
RUN /usr/bin/fc-cache -fv
RUN echo "vm.overcommit_memory = 1" >> /etc/systl.conf
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
WORKDIR /notebooks
EXPOSE 8888
ENTRYPOINT jupyter notebook --allow-root --ip=0.0.0.0 --port 8888 --no-browser --log-level=DEBUG
