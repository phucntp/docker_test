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
        PASSWORD = 'phucqwert1106'
        USERNAME = 'phucntp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // stage('Build') {
        //     steps {
        //         bat 'yarn install'
        //         bat 'yarn build'
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t $IMAGE_NAME:$TAG ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_REGISTRY_CREDENTIALS, usernameVariable: 'phucntp', passwordVariable: 'phucqwert1106')]) {
                    bat '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push $IMAGE_NAME:$TAG
                        echo test
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    bat """
                        ssh -o StrictHostKeyChecking=no phucntp@phucqwert1106 '
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
