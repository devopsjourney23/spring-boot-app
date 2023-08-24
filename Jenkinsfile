pipeline{
    agent{
        docker {
            image 'maven-docker-agent:latest'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
        }
    }
    stages{
        stage("Checkout"){
            steps{
                sh 'echo passeed'
                sh 'echo Testing E2E CICD Demo'
                //git branch: 'master', url: 'https://github.com/devopsjourney23/e2e-cicd-demo.git'
                //checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/devopsjourney23/e2e-cicd-demo.git']])

            }
        }
        stage('Build and Test'){
            steps{
                sh 'ls -ltr'
                // build the project and create a JAR file
                sh 'cd cicd-pipeline-01/spring-boot-app && mvn clean package'
            }
        }
        stage('SonarQube Code Inspection'){
            steps{
                withSonarQubeEnv('my-sonarqube') {
                    sh 'cd cicd-pipeline-01/spring-boot-app && mvn sonar:sonar'
                }
            }
        }
        stage('Build and Push Docker Image'){
            environment {
              DOCKER_IMAGE = "lkt143/cicd-pipeline-demo-01:${BUILD_NUMBER}"
              DOCKERFILE_LOCATION = "cicd-pipeline-01/spring-boot-app/Dockerfile"
              REGISTRY_CREDENTIALS = credentials('docker-cred')
            }
            steps{
                script {
                  sh 'cd cicd-pipeline-01/spring-boot-app && docker build -t ${DOCKER_IMAGE} .'
                  def dockerImage = docker.image("${DOCKER_IMAGE}")
                  docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                  dockerImage.push()
                  }
                }
            }
        }
        stage('Update Deployment File') {
            environment {
              GIT_REPO_NAME = "e2e-cicd-demo"
              GIT_USER_NAME = "devopsjourney23"
            }
            steps {
              withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config --global user.email "lax.aws1@gmail.com"
                    git config --global user.name "devopsjourney23"
                    git config --global --add safe.directory "*"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" cicd-pipeline-01/spring-boot-app-manifests/deployment.yaml
                    git add cicd-pipeline-01/spring-boot-app-manifests/deployment.yaml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                '''
                }
            }
        }
    }
}