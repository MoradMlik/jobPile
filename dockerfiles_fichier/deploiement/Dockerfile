FROM hashicorp/terraform
RUN mkdir -p /app/data
WORKDIR /app/data
VOLUME /app/data
COPY ./terra/ /app/data/
COPY ./.ssh/ /app/data/.ssh/
CMD cd Nginx
CMD terraform init
CMD terraform destroy -var-file=main.tfvars -var-file=backend.tfvars
CMD terraform -auto-approve apply -var-file=main.tfvars -var-file=backend.tfvars
CMD cd ../Prod
CMD terraform init
CMD terraform -auto-approve apply -var-file=main.tfvars -var-file=backend.tfvars
CMD cd ../Test
CMD terraform init
CMD terraform -auto-approve apply -var-file=main.tfvars -var-file=backend.tfvars
