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
                    sh 'docker stop $(docker ps -q)'
                    sh 'docker rm $(docker ps -a -q)'
                    sh 'docker rmi $(docker images -q -f dangling=true)'
                    bluedockerImage = docker.build("laxgod77/testblueimage",'./blue')
                    greendockerImage = docker.build("laxgod77/testgreenimage",'./green')
                }
            }
        }

        stage('Push to Dockerfile') {
            steps {
                script {
                    echo "Push Docker Image"
                    retry(2){
                        docker.withRegistry('', "dockerhub") {
                            bluedockerImage.push()
                            greendockerImage.push()
                        }
                    }
                }
            }
        }

        stage('Set kubectl context') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh "aws eks --region us-west-2 update-kubeconfig --name capstone"
                    sh 'kubectl config use-context arn:aws:eks:us-west-2:522853478682:cluster/capstone'
                }
            }
        }

        stage('Deploy blue container') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh "kubectl apply -f ./blue/blue-controller.json"
                }
            }
        }

        stage('Deploy green container') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh 'kubectl apply -f ./green/green-controller.json'
                }
            }
        }
        stage('Create service') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
                    sh 'kubectl apply -f ./blue-green-service.json'
                    sh "kubectl get services"
                    sh "kubectl describe pod"
                }
            }
        }
    }
}

