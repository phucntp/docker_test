pipeline {
    agent any

    environment {
        IMAGE_NAME = 'phucntp/my-nest-app'
        TAG = "latest" // Hoặc dùng "${env.BUILD_NUMBER}" nếu muốn version hóa
        SSH_CREDENTIALS_ID = '85b936a3-017f-4af2-ada7-f4dcca7b6dad' // ID SSH credentials trong Jenkins
        REMOTE_USER = 'phucn'
        REMOTE_HOST = '192.168.14.234'
        REMOTE_DIR = '/home/phucn/app'
        DOCKER_REGISTRY_CREDENTIALS = '85b936a3-017f-4af2-ada7-f4dcca7b6dad'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'yarn install'
                sh 'yarn build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$TAG ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_REGISTRY_CREDENTIALS, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push $IMAGE_NAME:$TAG
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent([SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST '
                            cd $REMOTE_DIR &&
                            docker-compose pull &&
                            docker-compose up -d
                        '
                    """
                }
            }
        }
    }
}
