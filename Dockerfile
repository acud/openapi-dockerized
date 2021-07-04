# This dockerfile relies on a few resources provided through
# environment variables
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

FROM node:16.3.0

RUN npm i -g redoc-cli

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.16.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# FOR GITHUB ACTIONS:
# determine whether there were changes:  lll=$(git diff HEAD~1 openapi/* | wc -l); if [ $lll -eq 0 ] ;then;  echo "zero"; else ;  echo "one" ; fi;
# when building, create a pending state check on the pr, and once the file is uploaded
# it can provided with a link to the result of the action using "details_url"
