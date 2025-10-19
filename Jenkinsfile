pipeline {
    agent any

    environment {
        DEV_REGISTRY = "nishanth420/capstone-dev"
        PROD_REGISTRY = "nishanth420/capstone-prod"
        IMAGE_NAME = "react-static-app"
        IMAGE_TAG = "latest"
        BRANCH = "${env.BRANCH_NAME}"
        EC2_HOST = "ec2-user@50.18.64.238"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Nishanth-automater/devops-build.git',
                    branch: "${env.BRANCH_NAME}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'chmod +x build.sh'
                sh "./build.sh ${env.BRANCH_NAME}"
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"

                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push $DEV_REGISTRY:$IMAGE_TAG"
                        } else if (env.BRANCH_NAME == 'main') {
                            sh "docker push $PROD_REGISTRY:$IMAGE_TAG"
                        } else {
                            echo "Branch is neither dev nor main. Skipping Docker push."
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $EC2_HOST '
                        cd /home/ec2-user/devops-build &&
                        git pull &&
                        chmod +x deploy.sh &&
                        ./deploy.sh ${env.BRANCH_NAME}
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully for branch ${env.BRANCH_NAME}!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}

