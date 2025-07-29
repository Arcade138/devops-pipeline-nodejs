DevOps Pipeline Case Study


This report summarizes the implementation of an end-to-end DevOps pipeline for a simple Node.js application, as outlined in the provided case study. The pipeline leverages Git/GitHub, Jenkins, Terraform, Ansible, Docker, and DockerHub to automate the build, provision, configure, and deployment processes on AWS Free Tier.

I started by creating a GitHub repository devops-pipeline-nodejs to host my Node.js application's code along with supporting files like the Dockerfile, Jenkinsfile, shell scripts, and Ansible deployment files. This centralized the source and enabled Jenkins to pull updates for automated builds.
Next, I launched a Jenkins server on an AWS EC2 Ubuntu instance and installed essential tools: Git (to clone the repo), Docker (to build and push images), and Ansible (to handle deployment). This setup ensured that Jenkins could handle every stage of the CI/CD pipeline independently.

To connect Jenkins with my GitHub and Docker Hub accounts securely, I added credentials inside Jenkins — a GitHub PAT (github-pat) for repo access and Docker Hub credentials (dockerhub) for pushing images. This allowed automation without exposing secrets in the code.

I then created a build_and_push.sh shell script that Jenkins would use to build a Docker image, tag it with the Git commit ID and latest, log in to Docker Hub, and push both tags. This kept the Jenkinsfile clean and reusable. In the Jenkinsfile, I defined stages to clean the workspace, clone the GitHub repository, build and push the Docker image using the script, and finally deploy the app using Ansible. Each stage was dependent on the previous one — deployment relied on a pushed image, which required a successful build from the latest code.

For deployment, I wrote an Ansible playbook deploy.yml along with an ansible/hosts.ini file pointing to my EC2 instance. The playbook stops any existing app container, pulls the latest Docker image, and runs a new container exposing the app on port 80.

To securely SSH into the EC2 instance during deployment, I uploaded my PEM file as a secret file in Jenkins credentials and used withCredentials to inject it during the pipeline run. This ensured secure, passwordless access for Ansible.

With all this in place, my Jenkins pipeline now fully automates the process: every code push triggers a new Docker image build, pushes it to Docker Hub, and deploys it via Ansible — all without manual intervention. Each step builds on the last to create a seamless CI/CD workflow.

