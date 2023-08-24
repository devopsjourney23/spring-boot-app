Idea of this exercise is to build CICD Pipeline to deployment (Java Spring Boot Application) changes automatically on k8s cluster.
Continous Integration is implemented using Jenkins and Continous Delivery using ArgoCD tp deploy on local k8s cluster created via minikube.

![image](https://github.com/devopsjourney23/spring-boot-app/assets/142556153/c40fc189-7b7c-453b-ad53-3c43315d86d4)

Demo Video:
https://youtu.be/D-fpDanYOS8


Please follow below steps for installtion for respective components of this CICD implementation.

**A) **Installing Docker on Linux (Ubuntu)****
   ```
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   sudo groupadd docker
   sudo usermod -aG docker $USER
   sudo usermod -aG docker jenkins
   newgrp docker
   docker run hello-world

   sudo systemctl enable docker.service
   sudo systemctl enable containerd.service
   ```

**B) **I'm using docker container for Jenkins Agent to carryout pipeline execution. Below are steps for Jenkins Installation on Linux.****
   ```
   Install Java 
   sudo apt update
   sudo apt install openjdk-17-jre
   java -version

   Install Jenkins
   curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
   echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
   sudo apt-get update
   sudo apt-get install jenkins
   sudo systemctl enable jenkins
   sudo systemctl status jenkins
   sudo systemctl start jenkins
   ```

**C) SonarQube is "Code Quality Assurance Tool" that collects and analyze source code, and provides reports for the code quality of your project.
   It combines static and dynamic analysis tools and enables quality to be measure continually over time.In a nutshell, SonarQube provide "Continuous Inspection".**
    
   **Installing SonarQube on Linux(Ubuntu)**
   ```
   sudo apt install openjdk-17-jre
   sudo apt install openjdk-17-jre
   java -version
   sudo su - 
   adduser sonarqube
   su - sonarqube
   wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.1.69595.zip --no-check-certificate
   unzip sonarqube-9.9.1.69595.zip
   chmod -R 755 /home/sonarqube/sonarqube-9.9.1.69595
   chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.9.1.69595

   create three alias in your bash profile
   alias start-sonar="/home/sonarqube/sonarqube-9.9.1.69595/bin/linux-x86-64/sonar.sh start"
   alias stop-sonar="/home/sonarqube/sonarqube-9.9.1.69595/bin/linux-x86-64/sonar.sh stop"
   alias status-sonar="/home/sonarqube/sonarqube-9.9.1.69595/bin/linux-x86-64/sonar.sh status"
   ```

   After your start sonarqube, you can access webgui "http://localhost:9000/"

**D) ArgoCD is designed to work natively with Kubernetes Clusters, making is easire to scale. In a nutshell, ArgoCD is a k8s controller, responsible for continously    
   monitoring all running applications and comparing their live state to the desired state defined in GIT repo. ArgoCD is declarative continous delivery tool for k8s applications.**

   As a prerequisite to ArgoCD, I've deployed k8s cluster using minikube.
   https://minikube.sigs.k8s.io/docs/start/

   To install the latest minikube stable release on x86-64 Linux using binary download:
   ```
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   minikube start --memory=4098 --driver=docker
   ```

   I'm using Operators as deployment of ArgoCD.
   https://operatorhub.io/operator/argocd-operator

   1. Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
   ```curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/install.sh | bash -s v0.25.0```

   2. Install the operator by running the following command:
   ```kubectl create -f https://operatorhub.io/install/argocd-operator.yaml```
   This Operator will be installed in the "operators" namespace and will be usable from all namespaces in the cluster.

   3. After install, watch your operator come up using next command.
      ```
      kubectl get csv -n operators
      kubectl get pod -n operators -w
      ```

   Use **minikube service example-argocd-server** to expose url to your desktop.
   
   Default credentials:
   ```
   admin/output of "kubectl get secret example-argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d"
   ```
   
   Modify Password
   ```
   kubectl patch secret example-argocd-cluster -p '{"stringData": { "admin.password": "password" }}'
   ```
    
