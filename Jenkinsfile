pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        ECR_REPO = "547694239239.dkr.ecr.ap-southeast-1.amazonaws.com/caringup_demo"
        IMAGE_TAG = "latest"
        AWS_REGION = "ap-southeast-1"
        AWS_ACCOUNT_ID = "547694239239"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/VMoshik/my-static-site.git', credentialsId: 'Github'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        success {
            echo '✅ Deployment succeeded!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
