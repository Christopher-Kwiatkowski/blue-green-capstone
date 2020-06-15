pipeline {
    agent any
    stages {
        stage('Lint Dockerfile') {
            steps {
                echo "Linting Docker File"
                retry(2){
                    sh 'wget -O hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.5/hadolint-Linux-x86_64 &&\
                                chmod +x hadolint'
                    sh 'make lint'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo "Build Docker Image"
                    dockerImage = docker.build("laxgod77/testblueimage:latest")
                }
            }
        }

        stage('Push to Dockerfile') {
            steps {
                script {
                    echo "Push Docker Image"
                    retry(2){
                        docker.withRegistry('', "DockerHub") {
                            dockerImage.push()
                        }
                    }
                }
            }
        }

        stage('Deploy blue container and create service') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh 'kubectl config view'
                    sh 'kubectl config use-context arn:aws:eks:us-west-2:522853478682:cluster/capstonecluster'
                    sh 'kubectl apply -f blue/blue-deploy.yaml'
                    sleep(time:20,unit:"SECONDS")
                    sh 'kubectl apply -f blue/blue-controller.json'
                }
            }
        }
        stage('Deploy green container and create service') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh 'kubectl config use-context arn:aws:eks:us-west-2:522853478682:cluster/capstonecluster'
                    sh 'kubectl apply -f green/green-deploy.yaml'
                    sleep(time:20,unit:"SECONDS")
                    sh 'kubectl apply -f green/green-controller.json '
                    sh 'kubectl get service/ducks-prod'
                }
            }
        }
    }
}

