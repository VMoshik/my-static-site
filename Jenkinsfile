pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = ''
        AWS_REGION = ''
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/caringup_demo"
        IMAGE_TAG = 'latest'
        EKS_CLUSTER_NAME = 'demo-eks'   // updated here
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${ECR_REPO}:${IMAGE_TAG} .'
            }
        }
        
        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh 'docker push ${ECR_REPO}:${IMAGE_TAG}'
            }
        }
        
        stage('Configure kubectl') {
            steps {
                sh 'aws eks --region ${AWS_REGION} update-kubeconfig --name ${EKS_CLUSTER_NAME}'
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}
