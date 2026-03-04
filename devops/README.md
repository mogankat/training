Docker Desktop

https://docs.docker.com/desktop/setup/install/windows-install/#wsl-verification-and-setup

https://docs.docker.com/desktop/setup/install/linux/
https://docs.docker.com/desktop/install/windows-install/

https://docs.docker.com/desktop/setup/install/windows-install/

Open Docker Desktop Settings → Resources → WSL Integration → Toggle "On" for your specific Ubuntu/WSL distro.

Version Check: docker --version and docker compose version2. 

kubectl
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

minikube
https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker
minikube version


Helm
https://helm.sh/docs/intro/install/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

Ansible
https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
sudo apt update && sudo apt install python3-pip -y
pip install --user ansible
Check: ansible --version

AWS CLI
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
Check: aws --version

Terraform
https://developer.hashicorp.com/terraform/install
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
Check: terraform version

PATH
 ~/.bashrc or ~/.zshrc
 export PATH=$PATH:$HOME/.local/bin