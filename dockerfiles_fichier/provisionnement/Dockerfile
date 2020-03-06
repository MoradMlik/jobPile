FROM ansible/centos7-ansible
RUN mkdir -p /app/data/
WORKDIR /app/data/
VOLUME /app/data/
COPY ./ansi/ /app/data/
COPY ./.ssh/ /app/data/.ssh/
CMD ansible-playbook deploy_pile.yml -i inventory
