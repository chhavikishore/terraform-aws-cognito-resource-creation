FROM hashicorp/terraform:light
WORKDIR /terraform
COPY ./AwsProvider/*.tf .
RUN terraform init
RUN terraform plan
# ENTRYPOINT ["terraform", "apply", "-auto-approve"]